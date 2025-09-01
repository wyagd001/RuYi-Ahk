;|2.8|2024.09.17|1658
#Include <AutoXYWH>
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
  GuiText("未指定扫描文件夹", "查找大文件", 800)
  return
}
else
  GuiText("按 Esc 停止搜索", "查找大文件", 800)
if (StrLen(CandySel) > 3)
  skipminsize := 0
else
  skipminsize := 1
Loop, Files, %CandySel%\*.*, FR
{
  if ipause
    break
  if (Mod(A_index, 10000) = 0)
    tooltip % A_index
  if skipminsize && (A_LoopFileSize < 52428800)
    continue
  else
  {
    B_index++

    if (B_index <= 50)
    {
      ;msgbox % B_index " 1|1 " A_LoopFileFullPath
      Heap.Add(A_LoopFileSize)
      ; 同样的大小的文件, 只会记录一个路径
      if !fileobj["a" A_LoopFileSize]
        fileobj["a" A_LoopFileSize] := A_LoopFileFullPath
      else if fileobj["a" A_LoopFileSize] && !fileobj["b" A_LoopFileSize]
        fileobj["b" A_LoopFileSize] := A_LoopFileFullPath
      else if fileobj["b" A_LoopFileSize] && !fileobj["c" A_LoopFileSize]
        fileobj["c" A_LoopFileSize] := A_LoopFileFullPath
      else if fileobj["c" A_LoopFileSize] && !fileobj["d" A_LoopFileSize]
        fileobj["d" A_LoopFileSize] := A_LoopFileFullPath
    }
    else
    {
      ;msgbox % B_index " 2|2 " A_LoopFileFullPath
      miniV := Heap.Peek()
      if (A_LoopFileSize > miniV)
      {
        Heap.Add(A_LoopFileSize)
        Heap.Pop()
        ; 同样的大小的文件, 只会记录一个路径
        if !fileobj["a" A_LoopFileSize]
          fileobj["a" A_LoopFileSize] := A_LoopFileFullPath
        else if fileobj["a" A_LoopFileSize] && !fileobj["b" A_LoopFileSize]
          fileobj["b" A_LoopFileSize] := A_LoopFileFullPath
        else if fileobj["b" A_LoopFileSize] && !fileobj["c" A_LoopFileSize]
          fileobj["c" A_LoopFileSize] := A_LoopFileFullPath
        else if fileobj["c" A_LoopFileSize] && !fileobj["d" A_LoopFileSize]
          fileobj["d" A_LoopFileSize] := A_LoopFileFullPath
        fileobj.Delete("a" miniV), fileobj.Delete("b" miniV), fileobj.Delete("c" miniV), fileobj.Delete("d" miniV)
      }
    }
  }
}
loop 50
{
  if !Heap.Data.MaxIndex()
    break
  v := Heap.Pop()
  if (lastv = v)
  {
    Tmp_LineStr := fileobj["a" v] " | " Round(v/1024/1024, 2) " mb`n"
    if InStr(Tmp_str, Tmp_LineStr)
    {
      Tmp_LineStr := fileobj["b" v] " | " Round(v/1024/1024, 2) " mb`n"
      if InStr(Tmp_str, Tmp_LineStr)
      {
        Tmp_LineStr := fileobj["c" v] " | " Round(v/1024/1024, 2) " mb`n"
        if InStr(Tmp_str, Tmp_LineStr)
          Tmp_LineStr := fileobj["d" v] " | " Round(v/1024/1024, 2) " mb`n"
      }
    }
  }
  else
    Tmp_LineStr := fileobj["a" v] " | " Round(v/1024/1024, 2) " mb`n"

  Tmp_str .= Tmp_LineStr
  lastv := v
}
Loop, Parse, Tmp_str, `n, `r
{
	newStr := A_LoopField "`n" newStr
  ;msgbox % A_LoopField
}
GuiControl,, myedit, % Trim(newStr, "`n")
newStr := Tmp_str := ""
tooltip
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
  if (lastv = v)
  {
    Tmp_LineStr := fileobj["a" v] " | " Round(v/1024/1024, 2) " mb`n"
    if InStr(Tmp_str, Tmp_LineStr)
    {
      Tmp_LineStr := fileobj["b" v] " | " Round(v/1024/1024, 2) " mb`n"
      if InStr(Tmp_str, Tmp_LineStr)
      {
        Tmp_LineStr := fileobj["c" v] " | " Round(v/1024/1024, 2) " mb`n"
        if InStr(Tmp_str, Tmp_LineStr)
          Tmp_LineStr := fileobj["d" v] " | " Round(v/1024/1024, 2) " mb`n"
      }
    }
  }
  else
    Tmp_LineStr := fileobj["a" v] " | " Round(v/1024/1024, 2) " mb`n"

  Tmp_str .= Tmp_LineStr
  lastv := v
}
Loop, Parse, Tmp_str, `n, `r
{
	newStr := A_LoopField "`n" newStr
  ;msgbox % A_LoopField
}
;msgbox % newStr
GuiControl,, myedit, % Trim(newStr, "`n")
newStr := Tmp_str := ""
return

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd, openfile, openpath
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd +Resize
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
  gui, add, Button, XM+3 vopenfile gopenfile, 打开文件
  gui, add, Button, xp+80 yp vopenpath gopenpath, 打开路径
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
  AutoXYWH("y", "openfile", "openpath")
	return
  
  openfile:
  openpath:
  ControlGet, OutputVar, CurrentLine,, edit1, ahk_id %TextGuiHwnd%
  ControlGet, OutputVar, Line, %OutputVar%, edit1, ahk_id %TextGuiHwnd%
  file := SubStr(OutputVar, 1, Instr(OutputVar, "|")-2)
  ;msgbox % file
  if (A_GuiControl = "openfile")
    run %file%
  else
  {
    SplitPath, file,, Folder
    run %Folder%
  }
  return
}

/*
Basic example:
    Heap := new BinaryHeap
    For Index, Value In [10,17,20,30,38,30,24,34]
        Heap.Add(Value)
    MsgBox % Heap.Peek()
    Loop, 8
        MsgBox % Heap.Pop()
You can use a custom comparison function to modify the behavior of the heap. For example, the class implements a min-heap by default, but it can become a max-heap by extending the class and overriding Compare():
    Heap := new MaxHeap
    
    class MaxHeap extends Heap
    {
        Compare(Value1,Value2)
        {
            Return, Value1 > Value2
        }
    }
Or work with objects:
    Heap := ObjectHeap
    
    class ObjectHeap extends Heap
    {
        Compare(Value1,Value2)
        {
            Return, Value1.SomeKey < Value2.SomeKey
        }
    }
*/
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

    Compare(Value1, Value2)
    {
        Return, Value1 < Value2
    }
}

/*
    Heap := new MaxHeap
    For Index, Value In [10,17,20,30,38,30,24,34]
        Heap.Add(Value)
    MsgBox % Heap.Peek()
    Loop, 8
        MsgBox % Heap.Pop()
return

class MaxHeap extends BinaryHeap
{
  Compare(Value1,Value2)
  {
    Return, Value1 > Value2
  }
}
*/