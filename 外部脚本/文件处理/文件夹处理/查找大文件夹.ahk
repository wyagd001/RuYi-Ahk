;|2.8|2024.08.24|1658
#SingleInstance force
CandySel :=  A_Args[1]
SetBatchLines, -1
ListLines Off
ipause := 0
Heap := new BinaryHeap
B_index := 0
fileobj := {}

if !CandySel
{
  GuiText("未指定扫描文件夹", "查找大文件夹", 800)
  return
}
else
  GuiText("按 Esc 停止搜索", "查找大文件夹", 800)
if (StrLen(CandySel) > 3)
  skipminsize := 0
else
  skipminsize := 1
Loop, Files, %CandySel%\*.*, DR
{
  if ipause
    break
  if (Mod(A_index, 10000) = 0)
    tooltip % A_index
  FolderSize := CountFolderSize(A_LoopFilePath)
  if skipminsize && (FolderSize < 524288000)
    continue
  else
  {
    B_index++

    if (B_index <= 50)
    {
      ;msgbox % B_index " 1|1 " A_LoopFileFullPath
      Heap.Add(FolderSize)
      fileobj["a" FolderSize] := A_LoopFileFullPath
    }
    else
    {
      ;msgbox % B_index " 2|2 " A_LoopFileFullPath
      miniV := Heap.Peek()
      if (FolderSize > miniV)
      {
        Heap.Add(FolderSize)
        Heap.Pop()
        fileobj["a" FolderSize] := A_LoopFileFullPath
        fileobj.Delete("a" miniV)
      }
    }
  }
}
loop 50
{
  if !Heap.Data.MaxIndex()
    break
  v := Heap.Pop()
  Tmp_str .= fileobj["a" v] " | " Round(v/1024/1024, 2) "`n"
}
tooltip
GuiControl,, myedit, % Tmp_str
return

Esc::
ipause := 1
tooltip
Tmp_str := ""
loop 50
{
  if !Heap.Data.MaxIndex()
    break
  v := Heap.Pop()
  Tmp_str .= fileobj["a" v] " | " Round(v/1024/1024, 2) "`n"
}
GuiControl,, myedit, % Tmp_str
return

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd, openpath
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd +Resize
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
  gui, add, Button, XM+3 vopenpath gopenpath, 打开路径
  ;gui, add, Button, xp+80 yp vopenpath gopenpath, 打开路径
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	;GuiTextGuiescape:
	Gui, GuiText: Destroy
	exitapp
	Return

	GuiTextGuiSize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	AutoXYWH("wh", "myedit")
  AutoXYWH("y", "openpath")
	return
  
  openpath:
  ControlGet, OutputVar, CurrentLine,, edit1, ahk_id %TextGuiHwnd%
  ControlGet, OutputVar, Line, %OutputVar%, edit1, ahk_id %TextGuiHwnd%
  file := SubStr(OutputVar, 1, Instr(OutputVar, "|")-2)
  run %file%
  return
}

CountFolderSize(Folder) {
    static fso := ComObjCreate("Scripting.FileSystemObject")
    Folder := fso.GetFolder(Folder)
    try Size := fso.GetFolder(Folder).Size
    return Size
}


; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;             add a 't' to DimSize to tell AutoXYWH that the controls in cList are on/in a tab3 control
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
;   AutoXYWH("t x h0.5", "Btn1")
; ---------------------------------------------------------------------------------
; Version: 2020-5-20 / small code improvements (toralf)
;          2018-1-31 / added a line to prevent warnings (pramach)
;          2018-1-13 / added t option for controls on Tab3 (Alguimist)
;          2015-5-29 / added 'reset' option (tmplinshi)
;          2014-7-03 / mod by toralf
;          2014-1-02 / initial version tmplinshi
; requires AHK version : 1.1.13.01+    due to SprSplit()
; =================================================================================

AutoXYWH(DimSize, cList*){   ;https://www.autohotkey.com/boards/viewtopic.php?t=1079
  Static cInfo := {}

  If (DimSize = "reset")
    Return cInfo := {}

  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If !cInfo.hasKey(ctrlID) {
      ix := iy := iw := ih := 0	
      GuiControlGet i, %A_Gui%: Pos, %ctrl%
      MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
      fx := fy := fw := fh := 0
      For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) 
        If !RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)
          f%dim% := 1

      If (InStr(DimSize, "t")) {
        GuiControlGet hWnd, %A_Gui%: hWnd, %ctrl%
        hParentWnd := DllCall("GetParent", "Ptr", hWnd, "Ptr")
        VarSetCapacity(RECT, 16, 0)
        DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", &RECT)
        DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", &RECT, "UInt", 1)
        ix := ix - NumGet(RECT, 0, "Int")
        iy := iy - NumGet(RECT, 4, "Int")
      }

      cInfo[ctrlID] := {x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a, m:MMD}
    } Else {
      dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw, dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
      Options := ""
      For i, dim in cInfo[ctrlID]["a"]
        Options .= dim (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) A_Space
      GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
} } }

class BinaryHeap
{
    __New()
    {
        this.Data := []
    }

    Add(Value)
    {
        Index := this.Data.MaxIndex(), Index := Index ? (Index + 1) : 1

        ;append value to heap array
        this.Data[Index] := Value

        ;rearrange the array to satisfy the minimum heap property
        ParentIndex := Index >> 1
        While, Index > 1 && this.Compare(this.Data[Index],this.Data[ParentIndex]) ;child entry is less than its parent
        {
            ;swap the two elements so that the child entry is greater than its parent
            Temp1 := this.Data[ParentIndex]
            this.Data[ParentIndex] := this.Data[Index]
            this.Data[Index] := Temp1

            ;move to the parent entry
            Index := ParentIndex, ParentIndex >>= 1
        }
    }

    Peek()
    {
        If !this.Data.MaxIndex()
            throw Exception("Cannot obtain minimum entry from empty heap.",-1)
        Return, this.Data[1]
    }

    Pop()
    {
        MaxIndex := this.Data.MaxIndex()
        If !MaxIndex ;no entries in the heap
            throw Exception("Cannot pop minimum entry off of empty heap.",-1)

        Minimum := this.Data[1] ;obtain the minimum value in the heap

        ;move the last entry in the heap to the beginning
        this.Data[1] := this.Data[MaxIndex]
        this.Data.Remove(MaxIndex), MaxIndex --

        ;rearrange array to satisfy the heap property
        Index := 1, ChildIndex := 2
        While, ChildIndex <= MaxIndex
        {
            ;obtain the index of the lower of the two child nodes if there are two of them
            If (ChildIndex < MaxIndex && this.Compare(this.Data[ChildIndex + 1],this.Data[ChildIndex]))
                ChildIndex ++

            ;stop updating if the parent is less than or equal to the child
            If this.Compare(this.Data[Index],this.Data[ChildIndex])
                Break

            ;swap the two elements so that the child entry is greater than the parent
            Temp1 := this.Data[Index]
            this.Data[Index] := this.Data[ChildIndex]
            this.Data[ChildIndex] := Temp1

            ;move to the child entry
            Index := ChildIndex, ChildIndex <<= 1
        }

        Return, Minimum
    }

    Count()
    {
        Value := this.Data.MaxIndex()
        Return, Value ? Value : 0
    }

    Compare(Value1,Value2)
    {
        Return, Value1 < Value2
    }
}