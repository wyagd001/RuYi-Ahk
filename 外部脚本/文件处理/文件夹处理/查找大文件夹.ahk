;|2.8|2024.09.17|1659
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
/*
loop % Heap.Data.MaxIndex()    ; Heap 乱序数组
{
  v := Heap.Data[A_index]
  msgbox % v
  Tmp_str .= fileobj["a" v] " | " Round(v/1024/1024, 2) "`n"
}
*/
loop 50
{
  if !Heap.Data.MaxIndex()
    break
  v := Heap.Pop()
  ;msgbox % v
  Tmp_str .= fileobj["a" v] " | " Round(v/1024/1024, 2) " mb`n"
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
  Tmp_str .= fileobj["a" v] " | " Round(v/1024/1024, 2) " mb`n"
}
Loop, Parse, Tmp_str, `n, `r
{
	newStr := A_LoopField "`n" newStr
  ;msgbox % A_LoopField
}
GuiControl,, myedit, % Trim(newStr, "`n")
newStr := Tmp_str := ""
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

/*
Basic example:
    Heap := new BinaryHeap
    For Index, Value In [10,17,20,30,38,30,24,34]
        Heap.Add(Value)
    MsgBox % Heap.Peek()
    Loop, 8
        MsgBox % Heap.Pop()
You can use a custom comparison function to modify the behavior of the heap. For example, the class implements a min-heap by default, but it can become a max-heap by extending the class and overriding Compare():
您可以使用自定义比较函数来修改堆的行为。例如，类默认实现最小堆，但通过扩展类并重写Compare()，它可以变成最大堆:

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

    Compare(Value1,Value2)
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