;|2.8|2024.10.10|1548
#Include <File_GetEncoding>
#Include <AutoXYWH>
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\f156.ico"

CandySel :=  A_Args[1]
;CandySel := "C:\Documents and Settings\Administrator\Desktop\Gui"
valuetocp := {"ANSI(中文简体)": "CP936", "UTF-8 BOM": "UTF-8", "UTF-8 Raw": "UTF-8-Raw", "Unicode(UTF-16)": "UTF-16"}
Gui, Add, Text, x10 y15 h25, 文件夹:
Gui, Add, Edit, xp+80 yp-5 w610 h25 vsfolder, % CandySel
Gui, Add, Button, xp+625 yp-2 w60 h30 gstartsearch, 载入
Gui, Add, Text, x10 yp+40 h25, 指定扩展名:
Gui, Add, Edit, xp+80 yp-5 w610 h25 vsExt, % "txt,ahk,ahk2,md"
Gui, Add, Button, xp+625 yp w60 h30 gexemerge, 执行

Gui, Add, Text, x10 yp+40 w60, 文件名(可选):
Gui, Add, Edit, xp+80 yp-3 w360 h25 vofilename,
gui, add, Text, xp+370 yp+3 w60, 输出编码:
gui, add, ComboBox, xp+80 yp-3 w100  vOut_Code, ANSI(中文简体)|UTF-8 Raw|UTF-8 BOM||Unicode(UTF-16)
Gui, Add, Text, x10 yp+40 w60, 选项:
Gui, Add, Radio, xp+80 yp-10 h30 vaddblankline, 文件间添加空行
Gui, Add, Radio, xp+120 yp h30 vaddfilepath, 文件间添加文件路径
Gui, Add, Radio, xp+145 yp h30 vaddchaifen, 文件间添加拆分信息
Gui, Add, Radio, xp+140 yp h30 checked, 无 

Gui, Add, ListView, x10 yp+40 w700 h500 vfilelist hwndHLV Checked AltSubmit grid, 序号|文件名|相对路径|扩展名|文件编码|大小(KB)|修改日期|完整路径   ;
Gui, Add, Button, xp+710 yp w60 gMoveRow_Top, 置顶
Gui, Add, Button, xp yp+28 w60 gMoveRow_Up, 向上
Gui, Add, Button, xp yp+28 w60 gMoveRow_Down, 向下
Gui, Add, Button, xp yp+28 w60 gMoveRow_Bottom, 置底
;Gui, Add, Button, xp yp+28 w60 gDelListItem, 删除

Gui, Add, Button, x10 y655 w60 h30 gcheckall, 全选
Gui, Add, Button, xp+70 yp w60 h30 guncheckall, 全不选
gui, add, Button, xp+70 yp w60 h30 gcheckallSeletedfile, 选中高亮
gui, add, Button, xp+70 yp w60 h30 guncheckallSeletedfile, 高亮不选
Gui, Add, Button, xp+70 yp w60 h30 gEditfilefromlist, 编辑文件
Gui, Add, Button, xp+70 yp w60 h30 gopenfilefromlist, 打开文件
Gui, Add, Button, xp+70 yp w60 h30 gopenfilepfromlist, 打开路径
Gui, Add, Button, xp+70 yp w60 h30 gprevrun, 预览执行

Gui, Show,, 多文件合并

if FileExist(CandySel)
	gosub startsearch
return

startsearch:
gui, Submit, NoHide
if !FileExist(sfolder)
	return
ToolTip, % "正在遍历文本文件编码类型, 请稍候..."
LV_Delete()
B_Index := 0
Loop, Files, %sfolder%\*.*, FR
{
	if A_LoopFileSize = 0
		continue
	if Tmp_Hfolderpath     ; 不加载隐藏文件夹中的文件
	{
		if InStr(A_LoopFileLongPath, Tmp_Hfolderpath)
			continue
	}
	if A_LoopFileAttrib contains H,R,S   ; 不在载隐藏的文件
	{
		if InStr(A_LoopFileAttrib, "D")
			Tmp_Hfolderpath := A_LoopFileLongPath
		continue
	}
	if sExt
	{
		if A_LoopFileExt not in %sExt%
			continue
	}
	B_Index ++
	LV_Add("", B_Index, A_LoopFileName, StrReplace(StrReplace(A_LoopFilePath, sfolder), A_LoopFileName), A_LoopFileExt, File_GetEncoding(A_LoopFileFullPath), Ceil(A_LoopFileSize / 1024), A_LoopFileTimeModified, A_LoopFilePath)
}
;msgbox % "文件遍历完成. 用时: " A_TickCount - st
ToolTip

LV_ModifyCol()
LV_ModifyCol(1, "Integer")
LV_ModifyCol(2, 200)
LV_ModifyCol(3, 250)
LV_ModifyCol(4, 60)
LV_ModifyCol(6, 75)
Return

exemerge:
gui, Submit, NoHide
RowNumber := 0
ofilecode := valuetocp[out_code]
Tmp_Str := ""
SplitPath, SFolder, OutFileName, OutDir
Loop
{
  RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
  if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
    break
  LV_GetText(fullpath, RowNumber, 8)
  LV_GetText(filecode, RowNumber, 5)
  FileEncoding, % filecode
  FileRead, OutputVar, %fullpath%

  if addchaifen
  {
    Relpath := strreplace(fullpath, OutDir "\")
    fileMD5 := MD5_File(fullpath)
    FileGetTime, CreateTime, %fullpath%, C
    FileGetTime, ModifyTime, %fullpath%, M
  }
  if addfilepath
    Tmp_Str .= fullpath "`r`n" OutputVar "`r`n"
  else if addchaifen
    Tmp_Str .= ";自拆分文件 | " Relpath " | " A_Index " | " filecode " | " fileMD5 " | " CreateTime  " | " ModifyTime "`r`n" OutputVar "`r`n"
  else if addblankline
    Tmp_Str .= OutputVar "`r`n`r`n"
  else
    Tmp_Str .= OutputVar "`r`n"
}
ofilename := ofilename ? ofilename : "合并_" A_Now ".txt"
FileAppend, %Tmp_Str%, %sfolder%\%ofilename%, % ofilecode
Return

prevrun:
gui, Submit, NoHide
RowNumber := 0
Tmp_Str := ""
SplitPath, SFolder, OutFileName, OutDir
ofilename := ofilename ? ofilename : "合并_" A_Now ".txt"
Tmp_Str := "(以下内容将写入 " sfolder "\" ofilename " 文件中.)`r`n`r`n"
Loop
{
  RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
  if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
    break
  LV_GetText(fullpath, RowNumber, 8)

  if addchaifen
  {
    LV_GetText(filecode, RowNumber, 5)
    Relpath := strreplace(fullpath, OutDir "\")
    fileMD5 := MD5_File(fullpath)
    FileGetTime, CreateTime, %fullpath%, C
    FileGetTime, ModifyTime, %fullpath%, M
  }

  if addfilepath
    Tmp_Str .= fullpath "`r`n(" fullpath "文件内容.)`r`n"
  else if addchaifen
    Tmp_Str .= ";自拆分文件 | " Relpath " | " A_Index " | " filecode " | " fileMD5 " | " CreateTime  " | " ModifyTime "`r`n(" fullpath "文件内容.)`r`n"
  else if addblankline
    Tmp_Str .= "(" fullpath "文件内容.)`r`n`r`n"
  else
    Tmp_Str .="(" fullpath "文件内容.)`r`n"
}

GuiText(Tmp_Str, "选中文本文件合并", 800)
return

GuiClose:
ExitApp

GuiDropFiles:
;MsgBox % A_GuiEvent "|" A_EventInfo
;AddDroppedFileOrLnk(FileList, filesCount)
if (A_EventInfo > 1)
{
	Loop, parse, A_GuiEvent, `n
	{
		B_Index ++
		SplitPath, A_LoopField, OutFileName, OutDir, OutExtension
		FileGetSize, OutputSize, %A_LoopField%
		FileGetTime, OutputMT, %A_LoopField%, M
		LV_Add("", B_Index, OutFileName, , OutExtension, File_GetEncoding(A_LoopField), Ceil(OutputSize / 1024), OutputMT, A_LoopField)
	}
}
else
{
	B_Index ++
	SplitPath, A_GuiEvent, OutFileName, OutDir, OutExtension
	FileGetSize, OutputSize, %A_GuiEvent%
	FileGetTime, OutputMT, %A_GuiEvent%, M
	LV_Add("", B_Index, OutFileName, , OutExtension, File_GetEncoding(A_GuiEvent), Ceil(OutputSize / 1024), OutputMT, A_GuiEvent)
}
Return

MoveRow_Top:
fr := LV_GetNext(0, "Focused")
LV_MoveRow2(HLV, fr, 1)
LV_Modify(1, "Vis")
return

MoveRow_Bottom:
fr := LV_GetNext(0, "Focused")
LV_MoveRow2(HLV, fr, LV_GetCount()+1)
LV_Modify(LV_GetCount(), "Vis")
return

MoveRow_Up:
Gui, Submit, NoHide
LV_MoveRow()
LV_RowIndexOrder()
Return

MoveRow_Down:
Gui, Submit, NoHide
LV_MoveRow(0)
LV_RowIndexOrder()
Return

LV_MoveRow(moveup = true) {
	; Original by diebagger (Guest) from:
	; http://de.autohotkey.com/forum/viewtopic.php?p=58526#58526
	; Slightly Modifyed by Obi-Wahn
	If moveup not in 1,0
		Return	; If direction not up or down (true or false)
	while x := LV_GetNext(x)	; Get selected lines
		i := A_Index, i%i% := x
	If (!i) || ((i1 < 2) && moveup) || ((i%i% = LV_GetCount()) && !moveup)
		Return	; Break Function if: nothing selected, (first selected < 2 AND moveup = true) [header bug]
				; OR (last selected = LV_GetCount() AND moveup = false) [delete bug]
	cc := LV_GetCount("Col"), fr := LV_GetNext(0, "Focused"), d := moveup ? -1 : 1
	; Count Columns, Query Line Number of next selected, set direction math.
	Loop, %i% {	; Loop selected lines
		r := moveup ? A_Index : i - A_Index + 1, ro := i%r%, rn := ro + d
		; Calculate row up or down, ro (current row), rn (target row)
		Loop, %cc% {	; Loop through header count
			LV_GetText(to, ro, A_Index), LV_GetText(tn, rn, A_Index)
			; Query Text from Current and Targetrow
			LV_Modify(rn, "Col" A_Index, to), LV_Modify(ro, "Col" A_Index, tn)
			; Modify Rows (switch text)
		}
		LV_Modify(ro, "-select -focus"), LV_Modify(rn, "select vis")
		If (ro = fr)
			LV_Modify(rn, "Focus")
	}
}

; ================================================================================================================================
; LV_MoveRow
; Moves a complete row within an own ListView control.
;     HLV            -  the handle to the ListView
;     RowNumber      -  the number of the row to be moved
;     InsertBefore   -  the number of the row to insert the moved row before
;     MaxTextLength  -  maximum length of item/subitem text being retrieved
; Returns the new row number of the moved row on success, otherwise zero (False).
; ================================================================================================================================
LV_MoveRow2(HLV, RowNumber, InsertBefore, MaxTextLength := 257) {
   Static LVM_GETITEM := A_IsUnicode ? 0x104B : 0x1005
   Static LVM_INSERTITEM := A_IsUnicode ? 0x104D : 0x1007
   Static LVM_SETITEM := A_IsUnicode ? 0x104C : 0x1006
   Static OffMask := 0
        , OffItem := OffMask + 4
        , OffSubItem := OffItem + 4
        , OffState := OffSubItem + 4
        , OffStateMask := OffState + 4
        , OffText := OffStateMask + A_PtrSize
        , OffTextLen := OffText + A_PtrSize
   ; Some checks -----------------------------------------------------------------------------------------------------------------
   If (RowNumber = InsertBefore)
      Return True
   Rows := DllCall("SendMessage", "Ptr", HLV, "UInt", 0x1004, "Ptr", 0, "Ptr", 0, "Int") ; LVM_GETITEMCOUNT
   If (RowNumber < 1) || (InsertBefore < 1) || (RowNumber > Rows)
      Return False
   ; Move it, if possible --------------------------------------------------------------------------------------------------------
   GuiControl, -Redraw, %HLV%
   HHD := DllCall("SendMessage", "Ptr", HLV, "UInt", 0x101F, "Ptr", 0, "Ptr", 0, "UPtr") ; LVM_GETHEADER
   Columns := DllCall("SendMessage", "Ptr", HHD, "UInt", 0x1200, "Ptr", 0, "Ptr", 0, "Int") ; HDM_GETITEMCOUNT
   Item := RowNumber - 1
   StructSize := 88 + (MaxTextLength << !!A_IsUnicode)
   VarSetCapacity(LVITEM, StructSize, 0)
   NumPut(0x01031F, LVITEM, OffMask, "UInt") ; might need to be adjusted for Win XP/Vista
   NumPut(Item, LVITEM, OffItem, "Int")
   NumPut(-1, LVITEM, OffStateMask, "UInt")
   NumPut(&LVITEM + 88, LVITEM, OffText, "Ptr")
   NumPut(MaxTextLength, LVITEM, OffTextLen, "Int")
   If !DllCall("SendMessage", "Ptr", HLV, "UInt", LVM_GETITEM, "Ptr", 0, "Ptr", &LVITEM, "Int")
      Return False
   NumPut(InsertBefore - 1, LVITEM, OffItem, "Int")
   NewItem := DllCall("SendMessage", "Ptr", HLV, "UInt", LVM_INSERTITEM, "Ptr", 0, "Ptr", &LVITEM, "Int")
   If (NewItem = -1)
      Return False
   DllCall("SendMessage", "Ptr", HLV, "UInt", 0x102B, "Ptr", NewItem, "Ptr", &LVITEM) ; LVM_SETITEMSTATE
   If (InsertBefore <= RowNumber)
      Item++
   VarSetCapacity(LVITEM, StructSize, 0) ; reinitialize
   Loop, %Columns% {
      NumPut(0x03, LVITEM, OffMask, "UInt")
      NumPut(Item, LVITEM, OffItem, "Int")
      NumPut(A_Index, LVITEM, OffSubItem, "Int")
      NumPut(&LVITEM + 88, LVITEM, OffText, "Ptr")
      NumPut(MaxTextLength, LVITEM, OffTextLen, "Int")
      If !DllCall("SendMessage", "Ptr", HLV, "UInt", LVM_GETITEM, "Ptr", 0, "Ptr", &LVITEM, "Int")
         Return False
      NumPut(NewItem, LVITEM, OffItem, "Int")
      DllCall("SendMessage", "Ptr", HLV, "UInt", LVM_SETITEM, "Ptr", 0, "Ptr", &LVITEM, "Int")
   }
   Result := DllCall("SendMessage", "Ptr", HLV, "UInt", 0x1008, "Ptr", Item, "Ptr", 0) ; LVM_DELETEITEM
   GuiControl, +Redraw, %HLV%
   Return (Result ? (NewItem + 1) : 0)
}

LV_RowIndexOrder()
{
	loop % LV_GetCount()
	{
		LV_Modify(A_index, , A_index)
	}
}

DelListItem:
Gui, Submit, NoHide
RowNumber := 0, TmpArr := []
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber
		Break

	LV_GetText(Tmp_Str, RowNumber, 1)
	;msgbox % RowNumber "|" Tmp_Str
	TmpArr.Push(Tmp_Str)
}
Loop % TmpArr.Length()
{
	Tmp_Index := TmpArr.Pop()
}
return

checkall:
LV_Modify(0, "check")
return

uncheckall:
LV_Modify(0, "-check")
return

checkallSeletedfile:
RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Loop
{
  RowNumber := LV_GetNext(RowNumber)  ; 在前一次找到的位置后继续搜索.
  if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
    break
  LV_Modify(RowNumber, "+check")
}
return

uncheckallSeletedfile:
RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Loop
{
  RowNumber := LV_GetNext(RowNumber)  ; 在前一次找到的位置后继续搜索.
  if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
    break
  LV_Modify(RowNumber, "-check")
}
return

Editfilefromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 8)
}
run notepad  %Tmp_file%
return

openfilefromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 8)
}
run %Tmp_file%
return

openfilepfromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 8)
}
SplitPath, Tmp_file,, OutDir
Run, %OutDir%
;Run, explorer.exe /select`, %Tmp_file%
return

MCode(ByRef code, hex) 
{ ; allocate memory and write Machine Code there
	VarSetCapacity(code, 0) 
	VarSetCapacity(code, StrLen(hex)//2+2)
	Loop % StrLen(hex)//2 + 2
		NumPut("0x" . SubStr(hex, 2*A_Index-1, 2), code, A_Index-1, "Char")
}

PathU(Filename) { ;  PathU v0.91 by SKAN on D35E/D68M @ tiny.cc/pathu
Local OutFile
  VarSetCapacity(OutFile, 520)
  DllCall("Kernel32\GetFullPathNameW", "WStr",Filename, "UInt",260, "Str",OutFile, "Ptr",0)
  DllCall("Shell32\PathYetAnotherMakeUniqueName", "Str",OutFile, "Str",Outfile, "Ptr",0, "Ptr",0)
Return A_IsUnicode ? OutFile : StrGet(&OutFile, "UTF-16")
}

MD5_File( sFile="", cSz=4 ) { ; www.autohotkey.com/forum/viewtopic.php?p=275910#275910
	global Nomd5func
 cSz  := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 )
 hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,1,Int,0,Int,3,Int,0,Int,0)
 IfLess,hFil,1, Return,hFil
 DllCall( "GetFileSizeEx", UInt,hFil, Str,Buffer ),   fSz := NumGet( Buffer,0,"Int64" )
 VarSetCapacity( MD5_CTX,104,0 ),    DllCall( "advapi32\MD5Init", Str,MD5_CTX )
	LoopNum := fSz//cSz
 Loop % ( LoopNum +!!Mod(fSz,cSz) )
	{
		if (LoopNum > 125)
				tooltip % (A_index * cSz *100) / fSz "%"
   DllCall( "ReadFile", UInt,hFil, Str,Buffer, UInt,cSz, UIntP,bytesRead, UInt,0 )
 , DllCall( "advapi32\MD5Update", Str,MD5_CTX, Str,Buffer, UInt,bytesRead )
	if Nomd5func
	break
	}
	if (LoopNum > 125)
		tooltip
 DllCall( "advapi32\MD5Final", Str,MD5_CTX ), DllCall( "CloseHandle", UInt,hFil )
 Loop % StrLen( Hex:="123456789ABCDEF0" )
  N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
Return MD5
}

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