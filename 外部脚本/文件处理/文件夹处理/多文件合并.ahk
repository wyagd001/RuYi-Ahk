;|2.8|2024.09.18|1548
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\f156.ico"

CandySel :=  A_Args[1]
;CandySel := "C:\Documents and Settings\Administrator\Desktop\Gui"
valuetocp := {"ANSI(中文简体)": "CP936", "UTF-8 BOM": "UTF-8", "UTF-8 Raw": "UTF-8-Raw", "Unicode(UTF-16)": "UTF-16"}
Gui, Add, Text, x10 y15 h25, 文件夹:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vsfolder, % CandySel
Gui, Add, Button, xp+560 yp-2 w60 h30 gstartsearch, 载入
Gui, Add, Text, x10 yp+40 h25, 指定扩展名:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vsExt, % "txt,ahk,ahk2,md"
Gui, Add, Button, xp+560 yp w60 h30 gexemerge, 执行

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

  if addchaifen
  {
    LV_GetText(filecode, RowNumber, 5)
    Relpath := strreplace(fullpath, OutDir "\")
    fileMD5 := MD5_File(fullpath)
    FileGetTime, CreateTime, %fullpath%, C
    FileGetTime, ModifyTime, %fullpath%, M
    FileEncoding, % filecode
    FileRead, OutputVar, %fullpath%
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




/*!
	函数: File_GetEncoding
		类似 chardet Py库, 检测文件的代码页.

	参数:
		aFile - 要分析的外部文件路径.

	备注:
			> 注意:
			> ANSI 文档为全英文时, 默认返回 UTF-8.

	返回值:
		字符串
		0      - 错误, 文件不存在
		CPnnn  - ANSI (CPnnn), 必须带有中文字符串, 才能和 UTF-8 无签名 区分开.
		UTF-16 - text Utf-16 LE File
		CP1201 - text Utf-16 BE File
		UTF-32 - text Utf-32 BE/LE File
		UTF-8  - text Utf-8 File (UTF-8 + BOM). 检验的文件太小, 不足以检查时, 默认返回 UTF-8.
		UTF-8-RAW  - UTF-8 无签名. 
		对于 UTF-8-RAW 的说明：
		1.文件小于100kb 读取整个文件, 必须带有中文字符串(文件中存在乱码（特殊字符）时可能得到错误的结果), 才能和 CP936 区分开.
		2.文件大于100kb 读取文件前 100kb 的内容。
*/

; isBinFile
; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=144&start=20

/*
; 示例
Loop, Files, *.txt
msgbox % A_LoopFileName " - " File_GetEncoding(A_LoopFileLongPath)
*/

File_GetEncoding(aFile, aNumBytes = 0, aMinimum = 4)
{
	if !FileExist(aFile) or InStr(FileExist(aFile), "D")
		return 0

	_rawBytes := ""
	_hFile := FileOpen(aFile, "r")
	; force position to 0 (zero)
	_hFile.Position := 0
	; 文件小于100k, 则读取整个文件
	_nBytes := (_hFile.length < 102400) ? (_hFile.RawRead(_rawBytes, _hFile.length)) : (aNumBytes = 0) ? (_hFile.RawRead(_rawBytes, 102402)) : (_hFile.RawRead(_rawBytes, aNumBytes))
	_hFile.Close()

	; Initialize vars
	_t := 0, _i := 0, _bytesArr := []

	loop % _nBytes ; create c-style _bytesArr array
		_bytesArr[(A_Index - 1)] := Numget(&_rawBytes, (A_Index - 1), "UChar")

	; determine BOM if possible/existant
	if ((_bytesArr[0] = 0xFE) && (_bytesArr[1] = 0xFF))
	{
		; text Utf-16 BE File
		return "CP1201"
	}
	if ((_bytesArr[0] = 0xFF) && (_bytesArr[1] = 0xFE))
	{
		; text Utf-16 LE File
		return "UTF-16"
	}
	if ((_bytesArr[0] = 0xEF) && (_bytesArr[1] = 0xBB) && (_bytesArr[2] = 0xBF))
	{
		; text Utf-8 File
		return "UTF-8"
	}
	if ((_bytesArr[0] = 0x00) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0xFE) && (_bytesArr[3] = 0xFF))
	|| ((_bytesArr[0] = 0xFF) && (_bytesArr[1] = 0xFE) && (_bytesArr[2]= 0x00) && (_bytesArr[3] = x00))
	{
		; text Utf-32 BE/LE File
		return "UTF-32"
	}
	; 为了 unicode 检测, 推荐 aMinimum 为 4  (4个字节以下的文件无法判断类型)
	if (_nBytes < aMinimum)
	{
		; 如果文本太短，返回编码"UTF-8"
		return "UTF-8"
	}

	while(_i < _nBytes)
	{
		; // ASCII
		if (_bytesArr[_i] == 0x09)
		|| (_bytesArr[_i] == 0x0A)
		|| (_bytesArr[_i] == 0x0D)
		|| ((0x20 <= _bytesArr[_i]) && (_bytesArr[_i] <= 0x7E))
		{
			_i += 1
			continue
		}

		; // non-overlong 2-byte
		if (0xC2 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xDF)
		&& (0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF)
		{
			_i += 2
			if (_i + 1 > 102400) or (_i + 2 > 102400)
				break
			else
				continue
		}

		; // excluding overlongs, straight 3-byte, excluding surrogates
		if (((_bytesArr[_i] == 0xE0)
		&& ((0xA0 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF)))
		|| ((((0xE1 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xEC))
		|| (_bytesArr[_i] == 0xEE)
		|| (_bytesArr[_i] == 0xEF))
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF)))
		|| ((_bytesArr[_i] == 0xED)
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0x9F))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))))
		{
			_i += 3
			if (_i + 1 > 102400) or (_i + 2 > 102400) or (_i + 3 > 102400)
				break
			else
				continue
		}

		; // planes 1-3, planes 4-15, plane 16
		if (((_bytesArr[_i] == 0xF0)
		&& ((0x90 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
			&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF)))
		|| (((0xF1 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xF3))
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF)))
		|| ((_bytesArr[_i] == 0xF4)
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0x8F))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF))))
		{
			_i += 4
			continue
		}
		_t := 1
		break
	}

	; while 循环没有失败，然后确认为utf-8
	if (_t = 0)
	{
		return "UTF-8-RAW"
	}

	; 如果通过以上判断没有获取到文件编码
	; 通过检测文件是否含有不可见字符来简单判断是否为exe类型的二进制文件
/*
	loop, %_nBytes%
	{
		if ((_bytesArr[(A_Index - 1)] > 0) && (_bytesArr[(A_Index - 1)] < 9))
		|| ((_bytesArr[(A_Index - 1)] > 13) && (_bytesArr[(A_Index - 1)] < 20))
		{
			return 1
		}
	}
*/

	changyongzi := ["的", "一", "是", "了", "不", "在", "有", "个", "人", "这", "上", "中", "大", "为", "来", "我", "到", "出", "要", "以", "时", "和", "地", "们", "得", "可", "下", "对", "生", "也", "子", "就", "过", "能", "他", "会", "多", "发", "说", "而", "于", "自", "之", "用", "年", "行", "家", "方", "后", "作", "成", "开", "面", "事", "好", "小", "心", "前", "所", "道", "法", "如", "进", "着", "同", "经", "分", "定", "都", "然", "与", "本", "还", "其", "当", "起", "动", "已", "两", "点", "从", "问", "里", "主", "实", "天", "高", "去", "现", "长", "此", "三", "将", "无", "国", "全", "文", "理", "明", "日"]
	readstr := StrGet(&_rawBytes, _nBytes, "CP65001")
	changyongzi_jishu := 0
	for k,v in changyongzi
	{
		if InStr(readstr, v)
			changyongzi_jishu := changyongzi_jishu + 1
		if (changyongzi_jishu > 5)
		{
			return "UTF-8-Raw"
		}
	}

	readstr := StrGet(&_rawBytes, _nBytes, "CP936")
	changyongzi_jishu := 0
	for k,v in changyongzi
	{
		if InStr(readstr, v)
		{
			changyongzi_jishu := changyongzi_jishu + 1
		}
		if (changyongzi_jishu > 5)
		{
			return "CP936"
		}
	}

	changyongzi2 := ["個", "這", "為", "來", "時", "們", "得", "對", "過", "會", "發", "說", "開", "進", "經", "與", "本", "還", "當", "動", "兩", "點", "從", "問", "實", "現", "長", "將", "無", "國", "愛", "罷", "筆", "邊", "慘", "憐", "稱", "辦", "礙", "幫", "斃", "標", "彆", "錶", "參", "陽", "産", "蟲", "醜", "塵", "個", "掃", "監", "見", "舉", "鳥", "贜", "樹", "雜", "聽", "嘆", "薦", "夥", "漢", "黨", "齣", "遲", "車", "竄", "燈", "膚", "團", "態", "條", "殺", "農", "樂", "競", "驚", "幾", "處", "齒", "廠", "徹", "雙", "懲", "東", "當", "電", "奪", "麽", "舊", "關", "畫", "來", "賣", "買", "門", "麵", "氣"]
	readstr := StrGet(&_rawBytes, _nBytes, "CP950")
	changyongzi_jishu := 0
	for k,v in changyongzi2
	{
		if InStr(readstr, v)
			changyongzi_jishu := changyongzi_jishu + 1
		if (changyongzi_jishu > 5)
		{
			return "CP950"
		}
	}

	; 未符合上面条件的返回系统默认 ansi 内码
	; 简体中文系统默认返回的是 CP936, 非中文系统的内码显示中文会乱码,如果要显示中文可直接改为"CP936"
	return "CP" DllCall("GetACP")  
}

File_CpTransform(aInFile, aInCp := "", aOutCp := "", aOutNewFile := 1)
{
	if (aInCp = "CP1201")
	{
		_hFile := FileOpen(aInFile, "r")
		_hFile.Position := 2
		aInLen := _hFile.length - 2
		_hFile.RawRead(FileR_TFRaw, aInLen)
		_hFile.Close()
		;msgbox % aInLen
	}
	else
	{
		FileEncoding, % aInCp
		FileRead, FileR_TFC, %aInFile%
		FileEncoding
	}

	aSysCp := "CP" DllCall("GetACP")
	if !aOutCp or (aOutCp = "ansi")
		aOutCp := aSysCp

	SplitPath, % aInFile, , aOutDir, OutExtension, OutNameNoExt
	if aOutNewFile
	{
		aOutFile := aOutDir "\" OutNameNoExt "(" aInCp "转码" aOutCp ")." OutExtension
		aOutFile := PathU(aOutFile)
	}
	else
	{
		FileRecycle, %aInFile%
		aOutFile := aInFile
	}

	if (aOutCp != "CP1201")
	{
		if (aInCp = "CP1201")
		{
			LCMAP_BYTEREV := 0x800   ; 高低位转换
			cch := DllCall("LCMapStringW", "UInt", 0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFRaw, "UInt", -1, "Str", 0, "UInt", 0)
			;msgbox % cch  ; 长度与文件的实际长度 不一致
			VarSetCapacity(LE, cch * 2)
			DllCall("LCMapStringW", "UInt",0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFRaw, "UInt", cch, "Str", LE, "UInt",  cch)
			;msgbox % LE
			StrLE := StrGet(&LE, aInLen / 2)   ; 移除掉多余的长度的乱码
			;msgbox % StrLE
			FileAppend, %StrLE%, % aOutFile, % aOutCp
			FileR_TFRaw := StrLE := LE := ""
			return
		}
		else
		{
			FileAppend, %FileR_TFC%, % aOutFile, % aOutCp
			FileR_TFC := ""
			return
		}
	}
	else if (aOutCp = "CP1201")
	{
		if (aInCp = "CP1201")
		{
			_hFile := FileOpen(aOutFile, "w")
			MCode(code, "FEFF")
			_hFile.RawWrite(code, 2)
			_hFile.RawWrite(FileR_TFRaw, aInLen)
			FileR_TFRaw := ""
			return
		}
		else
		{
			LCMAP_BYTEREV := 0x800
			cch:=DllCall("LCMapStringW", "UInt",0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFC, "UInt", -1, "Str", 0, "UInt", 0)
			VarSetCapacity(BE, cch * 2)
			DllCall("LCMapStringW", "UInt", 0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFC, "UInt", cch, "Str", BE, "UInt", cch)
			_hFile := FileOpen(aOutFile, "w")
			MCode(code, "FEFF")
			_hFile.RawWrite(code, 2)
			_hFile.RawWrite(BE, cch * 2-2)
			FileR_TFC := BE := ""
			return
		}
	}
}

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