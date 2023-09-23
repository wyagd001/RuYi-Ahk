;|2.3|2023.09.13|1070,1423
#SingleInstance force
#include <ImagePut>
ATA_settingFile := A_ScriptDir "\..\..\配置文件\如一.ini"
ATA_filepath := A_Args[1]
if(A_Cursor="IBeam") or IsRenaming()
{
	send {space}
	ExitApp
}
PrewFile:
Prew_File := ATA_filepath
SplitPath, Prew_File,,, Prew_File_Ext
Prew_Cmd := ""
if CF_IsFolder(Prew_File)
	Prew_Cmd := "文件夹"
else if (Prew_File = "::{645FF040-5081-101B-9F08-00AA002F954E}")
	Prew_Cmd := "回收站"
else if (Prew_File_Ext = "")
	Prew_File_Ext := "txt"
if !Prew_Cmd
	Prew_Cmd := SkSub_Regex_IniRead(ATA_settingFile, "FilePrew", "i)(^|\|)" Prew_File_Ext "($|\|)")
;msgbox % Prew_Cmd " - " Prew_File_Ext " - " Prew_File
if Prew_Cmd && (Prew_Cmd != "error")
{
	Gui, PreWWin: Destroy
	GUI, PreWWin: Default
	GUI, PreWWin: +hwndh_PrewGui
	GroupAdd, MyPreWWinGroup, ahk_id %h_PrewGui%
	If IsLabel("Cando_" . Prew_Cmd . "_prew")
		Gosub % "Cando_" .  Prew_Cmd . "_prew"
}
return

#ifWinActive, ahk_group MyPreWWinGroup
$Space::
gosub PreWWinGuiClose
;msgbox 123123
return

F2::
ControlGet, Tmp_V, Selected,, Edit1
if !Tmp_V
{
	try {
		GUI, PreWWin:Default
		Tmp_id := TV_GetSelection()
		TV_GetText(Tmp_V, Tmp_id)
		SplitPath, Tmp_V, , , , Tmp_V
	}
}
if !Tmp_V
return
SplitPath, Prew_File,, Prew_File_ParentPath, Prew_File_Ext
TargetFile := PathU(Prew_File_ParentPath "\" Tmp_V "." Prew_File_Ext)
FileMove, % Prew_File, % TargetFile
return

del::
MsgBox,4,删除提示,确定要把文件放入回收站吗？`n`n%Prew_File%
IfMsgBox Yes
	FileRecycle,%Prew_File%
return

F5::
run, %Prew_File%
return

F6::
if !notepad2
{
	IniRead, notepad2, %ATA_settingFile%, 其他程序, notepad2, Notepad.exe
	if InStr(notepad2, "%A_ScriptDir%")
	{
		RY_Dir := Deref("%A_ScriptDir%")
		RY_Dir := SubStr(RY_Dir, 1, InStr(RY_Dir, "\", 0, 0, 2) - 1)
		notepad2 := StrReplace(notepad2, "%A_ScriptDir%", RY_Dir)
	}
}
run, % notepad2 " " Prew_File
return
#ifWinActive

PreWWinGuiEscape:
PreWWinGuiClose:
if Tmp_Val
	Tmp_Val := ""
Gui, PreWWin:Destroy
exitapp

PreWWinGuiSize:
GuiControl, Move, displayArea, % "x0 y0 w" A_GuiWidth " h" (A_GuiHeight - 20 - DDLH)
GuiControl, Move, PV_CodePage, % "x5 y" (A_GuiHeight - 20 - DDLH)
GuiControl, Move, WMP,x0 y0 w%A_GuiWidth% h%A_GuiHeight%
return

Cando_text_prew:
File_Encode := File_GetEncoding(Prew_File)
org_File_Encode := File_Encode
FileGetSize, File_Size, % Prew_File
FileEncoding, % File_Encode
if (File_Size > 102400) && ((File_Encode = "CP936") or (File_Encode = "UTF-8-RAW"))
{
	FileReadLine, LineVar, % Prew_File, 1
		MsgBox, 36, 选择源文件的编码ANSI/UTF-8, 文件第一行内容: %LineVar%`n当前使用编码为: %File_Encode%`n文本正常显示点击"是"，否则点击"否"。, 2
	IfMsgBox, No
	{
		File_Encode := (File_Encode = "CP936") ? "UTF-8-RAW" : "CP936"
		FileEncoding, % File_Encode
	}
	IfMsgBox, yes
		File_Encode := (File_Encode = "CP936") ? "CP936" : "UTF-8-RAW"
}

if TF_CountLines(Prew_File)>100
{
	Loop, Read, % Prew_File
	{
		FileR_TFC .= A_LoopReadLine "`n"
		if a_index >100
		break
	}
}
else
	FileRead, FileR_TFC, %Prew_File%
FileEncoding
Gui, +ReSize +MinSize800x540
Gui, Add, Edit, w800 Multi ReadOnly vdisplayArea Section,
if (org_File_Encode = "CP936") or (org_File_Encode = "UTF-8-RAW")
{
	Gui, Add, DropDownList, xs+15 vPV_CodePage gswitchCodePage, 切换编码||UTF-8|CP936
	DDLH := 25
}
else
	DDLH := 0
Gui, Add, StatusBar,, % "快捷键: 1. 选中文字后按 F2 以选中文字重命名文件. 2. Del 删除文件. 3. F5 运行. 4. F6 编辑. 当前编码: " File_Encode
Gui,PreWWin:Show, w800 h540 Center, % Prew_File " - 文件预览"
GuiControl,, displayArea, %FileR_TFC%
;GuiControl, Move, displayArea, x0 y0 w800 h510
FileR_TFC := File_Size := ""
return

switchCodePage:
GUI, PreWWin: Submit, NoHide
if (File_Encode = "CP936") && (PV_CodePage = "UTF-8")
{
	FileEncoding, % PV_CodePage
}
else if (File_Encode = "UTF-8-RAW") && (PV_CodePage = "CP936")
{
	FileEncoding, % PV_CodePage
}
Loop, Read, % Prew_File
{
	FileR_TFC .= A_LoopReadLine "`n"
	if a_index >100
	break
}
GuiControl,, displayArea, %FileR_TFC%
FileR_TFC := ""
Return

Cando_music_prew:
Gui, +LastFound +Resize
Gui, Add, ActiveX, x0 y0 w0 h0 vWMP, WMPLayer.OCX
WMP.Url := Prew_File
Gui, PreWWin:Show, w500 h300 Center,% Prew_File " - 文件预览"
return

Cando_pic_prew:
hwnd := ImagePutWindow(Prew_File, Prew_File " - 文件预览")
loop 
{
if WinExist("ahk_id" hwnd)
{
	sleep 200
}
else
exitapp
}
return

Cando_html_prew:
gosub, IE_Open
WB.Navigate(Prew_File)
return

IE_Open:
Gui, +ReSize
Gui Add, ActiveX, xm w1050 h800 vWB, Shell.Explorer
WB.silent := true
ComObjConnect(WB, WB_events)
IOleInPlaceActiveObject_Interface := "{00000117-0000-0000-C000-000000000046}"
pipa := ComObjQuery(WB, IOleInPlaceActiveObject_Interface)
TranslateAccelerator := NumGet(NumGet(pipa+0) + 5*A_PtrSize)
OnMessage(0x0100, "WM_KeyPress") ; WM_KEYDOWN 
OnMessage(0x0101, "WM_KeyPress") ; WM_KEYUP   
Gui, PreWWin:Show ,,% Prew_File " - 文件预览"
return

class WB_events
{
	;for more events and other, see http://msdn.microsoft.com/en-us/library/aa752085

	NavigateComplete2(wb) {
		;~ wb.Stop() ;blocked all navigation, we want our own stuff happening
	}
	DownloadComplete(wb, NewURL) {
		;~ wb.Stop() ;blocked all navigation, we want our own stuff happening
	}
	DocumentComplete(wb, NewURL) {
		;~ wb.Stop() ;blocked all navigation, we want our own stuff happening
	}
}

WM_KeyPress( wParam, lParam, nMsg, hWnd ) {

Global WB, pipa, TranslateAccelerator
Static Vars := "hWnd | nMsg | wParam | lParam | A_EventInfo | A_GuiX | A_GuiY" 

  WinGetClass, ClassName, ahk_id %hWnd%

  If ( ClassName = "Shell DocObject View" && wParam = 0x09 ) {
    WinGet, hIES, ControlListHwnd, ahk_id %hWnd% ; Find child of 'Shell DocObject View'
    ControlFocus,, ahk_id %hIES%
    Return 0
  }

  If ( ClassName = "Internet Explorer_Server" ) {

    VarSetCapacity( MSG, 28, 0 )                   ; MSG STructure    http://goo.gl/4bHD9Z
    Loop, Parse, Vars, |, %A_Space%
      NumPut( %A_LoopField%, MSG, ( A_Index-1 ) * A_PtrSize )

    Loop 2  ; IOleInPlaceActiveObject::TranslateAccelerator method    http://goo.gl/XkGZYt
      r := DllCall( TranslateAccelerator, UInt,pipa, UInt,&MSG )
    Until wParam != 9 || WB.document.activeElement != ""

    IfEqual, R, 0, Return, 0         ; S_OK: the message was translated to an accelerator.

  }
}

Cando_pdf_prew:
	gosub, IE_Open
	WB.Navigate("https://wyagd001.github.io/pdfjs/es5/web/viewer.html?file=blank.pdf")  ; IE浏览器
	WBStartTime := A_TickCount
	loop 
	{
		WBElapsedTime := A_TickCount - WBStartTime
		Sleep, 500
	}
	Until (wb.Document.Readystate = "Complete") or WBElapsedTime>5000
	settimer,autoopenpdf,-1500  ; 模拟选择文件
	wb.document.getElementById("openFile").click()
return

autoopenpdf:
WinWaitActive,ahk_class #32770,,1000
ControlSetText, edit1, %Prew_File%, ahk_class #32770
sleep,100
send {enter}
return

Cando_md_html_prew:
File_Encode := File_GetEncoding(Prew_File)
FileEncoding, % File_Encode
Fileread, Tmp_val, % Prew_File
FileEncoding
gosub, IE_Open
WB.Navigate("http://editor.md.ipandao.com/examples/simple.html")
WBStartTime := A_TickCount
	loop 
	{
		WBElapsedTime := A_TickCount - WBStartTime
		Sleep, 500
	}
	Until (wb.Document.Readystate = "Complete") or WBElapsedTime>5000
backclip := clipboard
clipboard := Tmp_val
wb.document.querySelector("#test-editormd > div.editormd-toolbar > div > ul > li:nth-child(39) > a").click()
MouseClick , Right, 300,200
;sendevent ^v
;MouseClick , left, 350,320
clipboard := backclip
Tmp_val := ""
;msgbox % wb.document.querySelector("#test-editormd > textarea").value
return

Cando_wps_prew:
Tmp_Str := xd2txlib.ExtractText(Prew_File)
Gui, +ReSize +MinSize800x540
Gui, Add, Edit, w800 h520 Multi ReadOnly vdisplayArea
GuiControl,, displayArea, %Tmp_Str%
Gui,PreWWin:Show, w800 h540 Center, % Prew_File " - 文件预览"
sendmessage, 0xB1, -1, -1, Edit1, 文件预览
Tmp_Str := ""
return

Cando_xls_prew:
IniRead, AutoHotkeyU32, %ATA_settingFile%, 其他程序, AutoHotkeyU32, %A_Space%
if fileexist(AutoHotkeyU32)
	run, "%AutoHotkeyU32%" "%A_ScriptDir%\..\..\引用程序\输出excel数据到GUI.ahk" "%Prew_File%"
else
	run, "%A_ScriptDir%\..\..\引用程序\AutoHotkeyU32.exe" "%A_ScriptDir%\引用程序\输出excel数据到GUI.ahk" "%Prew_File%"
exitapp

Cando_rar_prew:
	IniRead, 7z, %ATA_settingFile%, 其他程序, 7z, %A_Space%
	IniRead, winrar, %ATA_settingFile%, 其他程序, winrar, %A_Space%
	if !7z
	{
		msgbox 没有找到 7z 程序，请检查设置文件 [如一.ini] 中 [其他程序] 的7z条目，文件无法预览程序退出。
		exitapp
	}
	; 提取整行
	Tmp_Str := cmdSilenceReturn("for /f ""skip=12 tokens=* delims=-"" `%a in ('^;""" 7z """ ""l"" " """" Prew_File """') do @echo `%a")
	if FileExist(winrar)
	{
		包_注释文件 := A_Temp "\123_" A_Now ".txt"
		RunWait, %comspec% /c ""%winrar%" cw "%Prew_File%" "%包_注释文件%"",,hide
		FileRead, 包_注释, %包_注释文件%
	}
	;msgbox % Tmp_Str
	StringReplace, Tmp_Str, Tmp_Str, `n, `n, UseErrorLevel
	Tmp_Lines :=  ErrorLevel
	Tmp_Val := ""
	Loop, parse, Tmp_Str, `n, `r
	{
		NewStr := SubStr(A_LoopField, 54)
		if instr(NewStr, "----")
			continue
		if (A_Index = 1) or (A_Index >= Tmp_Lines)
			continue
		Tmp_FileName := trim(NewStr)
		if (Tmp_FileName = "")
			continue
		if (Tmp_FileName = "Name")
			continue
		Tmp_Val .= Tmp_FileName "`n"
	}
Sort, Tmp_Val
Gui, +ReSize
ImageListID := IL_Create(5)  ; 创建初始容量为 5 个图标的图像列表.
Loop 5  ; 加载一些标准系统图标到图像列表中.
    IL_Add(ImageListID, "shell32.dll", A_Index)
Gui, Add, TreeView,r30 w800 h500 ImageList%ImageListID%
if 包_注释
	Gui, Add, Edit, r5 w800 h100 readonly, %包_注释%
Gui, Add, button, gtree2text, 显示文本
AddBranchesToTree(Tmp_Val)
Gui,PreWWin: Show, AutoSize Center, % Prew_File " - 文件预览"
;GuiControl,, displayArea, %Tmp_Val%
Tmp_Str := Tmp_FileName := Tmp_Lines := 包_注释 := ""
return

tree2text:
GUI,66:Destroy
Gui,66:Default 
Gui, Add, Edit, w600 h300 ReadOnly, %Prew_File%`n%Tmp_Val%
Gui show, AutoSize Center, % Prew_File " - 文件预览"
return

cmdSilenceReturn(command){
	FileR_CMDReturn := ""
	cmdFN := "RunAnyCtrlCMD.log"
	try{
		fullCommand = %ComSpec% /c "%command% >> %cmdFN%"
		RunWait, %fullCommand%, %A_Temp%, Hide

		FileRead, FileR_CMDReturn, %A_Temp%\%cmdFN%
		FileDelete, %A_Temp%\%cmdFN%
	}catch{}
return  FileR_CMDReturn
}

; 来源网址: https://autohotkey.com/board/topic/39809-script-to-open-list-of-filesfolders-in-treeview/
AddBranchesToTree(filelist)
{
	level = 0
	parent0 = 0
	Loop, parse, filelist, `n, `r
	{
		if A_LoopField =
			continue
		stringsplit, parts, A_LoopField, \	; drive + folders ( + file)
		if level = 0				; first record, insert all parts
		{
			gosub build_tree
			continue
		}
		ifinstring, A_LoopField, %hprev_file%	; sub folders or files
		{
			gosub build_tree
			continue
		}
							; other drive or folder
		line := A_LoopField              
		if (parts0 > level)			; ignore parts > level
			loop, % parts0 - level - 1
				StringLeft, line, line, % InStr(line,"\",false,0)
		else
			level := parts0			; set level to no of parts
		loop, % level
		{
			StringLeft, line, line, % InStr(line,"\",false,0)-1  
			level--
			if level = 0			; other drive
			{
				hprev_file =
				bs =
			}
		else					; find corresponding level
			{
				hprev_file := file%level%
				ifnotinstring, line, %hprev_file%
					continue
				if level = 0
					level++
			}
			gosub build_tree
			break
		}
	}
	return

build_tree:
	loop, % parts0 - level
	{
		prev_parent = parent%level%
		level++
;msgbox % parts0 "-" level "-" A_LoopField
		ifnotinstring parts%level%,.
		parent%level% := tv_add(parts%level%, %prev_parent%, "expand Icon4")
		else
 parent%level% := tv_add(parts%level%, %prev_parent%, "expand")
		if level <> 1
			bs = \
		file%level% := hprev_file bs parts%level%
		hprev_file := file%level%
    ;msgbox % hprev_file
	}
	return
}

SkSub_Regex_IniRead(ini, sec, reg)      ; 正则方式的读取，等号左侧符合正则条件
{  ; 在ini的某个段内，查找符合某正则规则的字符串，如果找到返回value值。找不到，则返回 Error
	IniRead, keylist, %ini%, %sec%,
	Loop, Parse, keylist, `n
	{
		t := RegExReplace(A_LoopField, "=.*?$")
		If(RegExMatch(t, reg))
		{
			Return % RegExReplace(A_LoopField, "^.*?=")
			Break
		}
	}
	Return "Error"
}

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

	changyongzi2 :=["的", "一", "是", "了", "不", "在", "有", "個", "人", "這", "上", "中", "大", "為", "來", "我", "到", "出", "要", "以", "時", "和", "地", "們", "得", "可", "下", "對", "生", "也", "子", "就", "過", "能", "他", "會", "多", "發", "說", "而", "于", "自", "之", "用", "年", "行", "家", "方", "后", "作", "成", "開", "面", "事", "好", "小", "心", "前", "所", "道", "法", "如", "進", "著", "同", "經", "分", "定", "都", "然", "與", "本", "還", "其", "當", "起", "動", "已", "兩", "點", "從", "問", "里", "主", "實", "天", "高", "去", "現", "長", "此", "三", "將", "無", "國", "全", "文", "理", "明", "日"]
	readstr := StrGet(&_rawBytes, _nBytes, "CP950")
	changyongzi_jishu := 0
	for k,v in changyongzi
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

/*
Name          : TF: Textfile & String Library for AutoHotkey
Version       : 3.7
Documentation : https://github.com/hi5/TF
AHKScript.org : http://www.ahkscript.org/boards/viewtopic.php?f=6&t=576
AutoHotkey.com: http://www.autohotkey.com/forum/topic46195.html (Also for examples)
License       : see license.txt (GPL 2.0)
Credits & History: See documentation at GH above.
Structure of most functions:
TF_...(Text, other parameters)
	{
	 ; get the basic data we need for further processing and returning the output:
	 TF_GetData(OW, Text, FileName)
	 ; OW = 0 Copy inputfile
	 ; OW = 1 Overwrite inputfile
	 ; OW = 2 Return variable
	 ; Text : either contents of file or the var that was passed on
	 ; FileName : Used in case OW is 0 or 1 (=file), not used for OW=2 (variable)
	 ; Creates a matchlist for use in Loop below
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; A_ThisFunc useful for debugging your scripts
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			...
			}
		 Else
			{
			...
			}
		}
	 ; either copy or overwrite file or return variable
	 Return TF_ReturnOutPut(OW, OutPut, FileName, TrimTrailing, CreateNewFile)
	 ; OW 0 or 1 = file
	 ; Output = new content of file to save or variable to return
	 ; FileName
	 ; TrimTrailing: because of the loops used most functions will add trailing newline, this will remove it by default
	 ; CreateNewFile: To create a file that doesn't exist this parameter is needed, only used in few functions
	}
*/

TF_CountLines(Text)
	{
	 TF_GetData(OW, Text, FileName)
	 StringReplace, Text, Text, `n, `n, UseErrorLevel
	 Return ErrorLevel + 1
	}

TF_ReadLines(Text, StartLine = 1, EndLine = 0, Trailing = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			OutPut .= A_LoopField "`n"
		 Else if (A_Index => EndLine)
			Break
		}
	 OW = 2 ; make sure we return variable not process file
	 Return TF_ReturnOutPut(OW, OutPut, FileName, Trailing)
	}

TF_ReplaceInLines(Text, StartLine = 1, EndLine = 0, SearchText = "", ReplaceText = "")
	{
	 TF_GetData(OW, Text, FileName)
	 IfNotInString, Text, %SearchText%
		Return Text ; SearchText not in TextFile so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 StringReplace, LoopField, A_LoopField, %SearchText%, %ReplaceText%, All
			 OutPut .= LoopField "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_Replace(Text, SearchText, ReplaceText="")
	{
	 TF_GetData(OW, Text, FileName)
	 IfNotInString, Text, %SearchText%
		Return Text ; SearchText not in TextFile so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
	 Loop
		{
		 StringReplace, Text, Text, %SearchText%, %ReplaceText%, All
		 if (ErrorLevel = 0) ; No more replacements needed.
			break
		}
	 Return TF_ReturnOutPut(OW, Text, FileName, 0)
	}

TF_RegExReplaceInLines(Text, StartLine = 1, EndLine = 0, NeedleRegEx = "", Replacement = "")
	{
	 options:="^[imsxADJUXPS]+\)" ; Hat tip to sinkfaze http://www.autohotkey.com/forum/viewtopic.php?t=60062
	 If RegExMatch(searchText,options,o)
		searchText := RegExReplace(searchText,options,(!InStr(o,"m") ? "m$0" : "$0"))
	 Else searchText := "m)" . searchText
	 TF_GetData(OW, Text, FileName)
		If (RegExMatch(Text, SearchText) < 1)
			Return Text ; SearchText not in TextFile so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3

	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 LoopField := RegExReplace(A_LoopField, NeedleRegEx, Replacement)
			 OutPut .= LoopField "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_RegExReplace(Text, NeedleRegEx = "", Replacement = "")
	{
	 options:="^[imsxADJUXPS]+\)" ; Hat tip to sinkfaze http://www.autohotkey.com/forum/viewtopic.php?t=60062
	 if RegExMatch(searchText,options,o)
		searchText := RegExReplace(searchText,options,(!InStr(o,"m") ? "m$0" : "$0"))
	 else searchText := "m)" . searchText
	 TF_GetData(OW, Text, FileName)
		If (RegExMatch(Text, SearchText) < 1)
			Return Text ; SearchText not in TextFile so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
	 Text := RegExReplace(Text, NeedleRegEx, Replacement)
	 Return TF_ReturnOutPut(OW, Text, FileName, 0)
	}

TF_RemoveLines(Text, StartLine = 1, EndLine = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			Continue
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_RemoveBlankLines(Text, StartLine = 1, EndLine = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 If (RegExMatch(Text, "[\S]+?\r?\n?") < 1)
	 	Return Text ; No empty lines so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			OutPut .= (RegExMatch(A_LoopField,"[\S]+?\r?\n?")) ? A_LoopField "`n" :
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_RemoveDuplicateLines(Text, StartLine = 1, Endline = 0, Consecutive = 0, CaseSensitive = false)
	{
	 TF_GetData(OW, Text, FileName)
	 If (StartLine = "")
	 	StartLine = 1
	 If (Endline = 0 OR Endline = "")
		EndLine := TF_Count(Text, "`n") + 1
	 Loop, Parse, Text, `n, `r
		{
		 If (A_Index < StartLine)
			Section1 .= A_LoopField "`n"
		 If A_Index between %StartLine% and %Endline%
			{
			 If (Consecutive = 1)
				{
				 If (A_LoopField <> PreviousLine) ; method one for consecutive duplicate lines
					 Section2 .= A_LoopField "`n"
				 PreviousLine:=A_LoopField
				}
			 Else
				{
				 If !(InStr(SearchForSection2,"__bol__" . A_LoopField . "__eol__",CaseSensitive)) ; not found
				 	{
				 	 SearchForSection2 .= "__bol__" A_LoopField "__eol__" ; this makes it unique otherwise it could be a partial match
					 Section2 .= A_LoopField "`n"
				 	}
				}
			}
		 If (A_Index > EndLine)
			Section3 .= A_LoopField "`n"
		}
	 Output .= Section1 Section2 Section3
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_InsertLine(Text, StartLine = 1, Endline = 0, InsertText = "")
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			Output .= InsertText "`n" A_LoopField "`n"
		 Else
			Output .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_ReplaceLine(Text, StartLine = 1, Endline = 0, ReplaceText = "")
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			Output .= ReplaceText "`n"
		 Else
			Output .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_InsertPrefix(Text, StartLine = 1, EndLine = 0, InsertText = "")
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			OutPut .= InsertText A_LoopField "`n"
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_InsertSuffix(Text, StartLine = 1, EndLine = 0 , InsertText = "")
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			OutPut .= A_LoopField InsertText "`n"
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_TrimLeft(Text, StartLine = 1, EndLine = 0, Count = 1)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 StringTrimLeft, StrOutPut, A_LoopField, %Count%
			 OutPut .= StrOutPut "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_TrimRight(Text, StartLine = 1, EndLine = 0, Count = 1)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 StringTrimRight, StrOutPut, A_LoopField, %Count%
			 OutPut .= StrOutPut "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_AlignLeft(Text, StartLine = 1, EndLine = 0, Columns = 80, Padding = 0)
	{
	 Trim:=A_AutoTrim ; store trim settings
	 AutoTrim, On ; make sure AutoTrim is on
	 TF_GetData(OW, Text, FileName)
	 If (Endline = 0 OR Endline = "")
		EndLine := TF_Count(Text, "`n") + 1
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 LoopField = %A_LoopField% ; Make use of AutoTrim, should be faster then a RegExReplace. Trims leading and trailing spaces!
			 SpaceNum := Columns-StrLen(LoopField)-1
			 If (SpaceNum > 0) and (Padding = 1) ; requires padding + keep padding
				{
				 Left:=TF_SetWidth(LoopField,Columns, 0) ; align left
				 OutPut .= Left "`n"
				}
			 Else
				OutPut .= LoopField "`n"
			}
		 Else
		 	OutPut .= A_LoopField "`n"
		}
	 AutoTrim, %Trim%	; restore original Trim
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_AlignCenter(Text, StartLine = 1, EndLine = 0, Columns = 80, Padding = 0)
	{
	 Trim:=A_AutoTrim ; store trim settings
	 AutoTrim, On ; make sure AutoTrim is on
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 LoopField = %A_LoopField% ; Make use of AutoTrim, should be faster then a RegExReplace
			 SpaceNum := (Columns-StrLen(LoopField)-1)/2
			 If (Padding = 1) and (LoopField = "") ; skip empty lines, do not fill with spaces
				{
				 OutPut .= "`n"
				 Continue
				}
			 If (StrLen(LoopField) >= Columns)
				{
				 OutPut .= LoopField "`n" ; add as is
				 Continue
				}
			 Centered:=TF_SetWidth(LoopField,Columns, 1) ; align center using set width
			 OutPut .= Centered "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 AutoTrim, %Trim%	; restore original Trim
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_AlignRight(Text, StartLine = 1, EndLine = 0, Columns = 80, Skip = 0)
	{
	 Trim:=A_AutoTrim ; store trim settings
	 AutoTrim, On ; make sure AutoTrim is on
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 LoopField = %A_LoopField% ; Make use of AutoTrim, should be faster then a RegExReplace
			 If (Skip = 1) and (LoopField = "") ; skip empty lines, do not fill with spaces
				{
				 OutPut .= "`n"
				 Continue
				}
			 If (StrLen(LoopField) >= Columns)
				{
				 OutPut .= LoopField "`n" ; add as is
				 Continue
				}
			 Right:=TF_SetWidth(LoopField,Columns, 2) ; align right using set width
			 OutPut .= Right "`n"
			}
		 Else
			OutPut .= A_LoopField "`n"
		}
	 AutoTrim, %Trim%	; restore original Trim
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

; Based on: CONCATenate text files, ftp://garbo.uwasa.fi/pc/ts/tsfltc22.zip
TF_ConCat(FirstTextFile, SecondTextFile, OutputFile = "", Blanks = 0, FirstPadMargin = 0, SecondPadMargin = 0)
	{
	 If (Blanks > 0)
		Loop, %Blanks%
			InsertBlanks .= A_Space
	 If (FirstPadMargin > 0)
		Loop, %FirstPadMargin%
			PaddingFile1 .= A_Space
	 If (SecondPadMargin > 0)
		Loop, %SecondPadMargin%
			PaddingFile2 .= A_Space
	 Text:=FirstTextFile
	 TF_GetData(OW, Text, FileName)
	 StringSplit, Str1Lines, Text, `n, `r
	 Text:=SecondTextFile
	 TF_GetData(OW, Text, FileName)
	 StringSplit, Str2Lines, Text, `n, `r
	 Text= ; clear mem

	 ; first we need to determine the file with the most lines for our loop
	 If (Str1Lines0 > Str2Lines0)
		MaxLoop:=Str1Lines0
	 Else
		MaxLoop:=Str2Lines0
	 Loop, %MaxLoop%
		{
		 Section1:=Str1Lines%A_Index%
		 Section2:=Str2Lines%A_Index%
		 OutPut .= Section1 PaddingFile1 InsertBlanks Section2 PaddingFile2 "`n"
		 Section1= ; otherwise it will remember the last line from the shortest file or var
		 Section2=
		}
	 OW=1 ; it is probably 0 so in that case it would create _copy, so set it to 1
	 If (OutPutFile = "") ; if OutPutFile is empty return as variable
		OW=2
	 Return TF_ReturnOutPut(OW, OutPut, OutputFile, 1, 1)
	}

TF_LineNumber(Text, Leading = 0, Restart = 0, Char = 0) ; HT ribbet.1
	{
	 global t
	 TF_GetData(OW, Text, FileName)
	 Lines:=TF_Count(Text, "`n") + 1
	 Padding:=StrLen(Lines)
	 If (Leading = 0) and (Char = 0)
		Char := A_Space
	 Loop, %Padding%
		PadLines .= Char
	 Loop, Parse, Text, `n, `r
		{
		 If Restart = 0
			MaxNo = %A_Index%
		 Else
			{
			 MaxNo++
			 If MaxNo > %Restart%
				MaxNo = 1
			}
		 LineNumber:= MaxNo
		 If (Leading = 1)
			{
			 LineNumber := Padlines LineNumber ; add padding
			 StringRight, LineNumber, LineNumber, StrLen(Lines) ; remove excess padding
			}
		 If (Leading = 0)
			{
			 LineNumber := LineNumber Padlines ; add padding
			 StringLeft, LineNumber, LineNumber, StrLen(Lines) ; remove excess padding
			}
		 OutPut .= LineNumber A_Space A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

; skip = 1, skip shorter lines (e.g. lines shorter startcolumn position)
; modified in TF 3.4, fixed in 3.5
TF_ColGet(Text, StartLine = 1, EndLine = 0, StartColumn = 1, EndColumn = 1, Skip = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 If (StartColumn < 0)
		{
		 StartColumn++
		 Loop, Parse, Text, `n, `r ; parsing file/var
			{
			 If A_Index in %TF_MatchList%
				{
				 output .= SubStr(A_LoopField,StartColumn) "`n"
				}
			 else
				 output .= A_LoopField "`n"
			}
		 Return TF_ReturnOutPut(OW, OutPut, FileName)
		}
	 if RegExMatch(StartColumn, ",|\+|-")
		{
		 StartColumn:=_MakeMatchList(Text, StartColumn, 1, 1)
		 Loop, Parse, Text, `n, `r ; parsing file/var
			{
			 If A_Index in %TF_MatchList%
				{
				 loop, parse, A_LoopField ; parsing LINE char by char
					{
					 If A_Index in %StartColumn% ; if col in index get char
						output .= A_LoopField
					}
				 output .= "`n"
				}
			 else
				 output .= A_LoopField "`n"
			}
		 output .= A_LoopField "`n"
		}
	 else
		{
		 EndColumn:=(EndColumn+1)-StartColumn
		 Loop, Parse, Text, `n, `r
			{
			 If A_Index in %TF_MatchList%
				{
				 StringMid, Section, A_LoopField, StartColumn, EndColumn
				 If (Skip = 1) and (StrLen(A_LoopField) < StartColumn)
					Continue
				 OutPut .= Section "`n"
				}
			}
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

; Based on: COLPUT.EXE & CUT.EXE, ftp://garbo.uwasa.fi/pc/ts/tsfltc22.zip
; modified in TF 3.4
TF_ColPut(Text, Startline = 1, EndLine = 0, StartColumn = 1, InsertText = "", Skip = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 If RegExMatch(StartColumn, ",|\+")
		{
		 StartColumn:=_MakeMatchList(Text, StartColumn, 0, 1)
		 Loop, Parse, Text, `n, `r ; parsing file/var
			{
			 If A_Index in %TF_MatchList%
				{
				 loop, parse, A_LoopField ; parsing LINE char by char
					{
					 If A_Index in %StartColumn% ; if col in index insert text
						output .= InsertText A_LoopField
					 Else
						output .= A_LoopField
					}
				 output .= "`n"
				}
			 else
				 output .= A_LoopField "`n"
			}
		 output .= A_LoopField "`n"
		}
	 else
		{
		 StartColumn--
		 Loop, Parse, Text, `n, `r
			{
			 If A_Index in %TF_MatchList%
				{
				 If (StartColumn > 0)
					{
					 StringLeft, Section1, A_LoopField, StartColumn
					 StringMid, Section2, A_LoopField, StartColumn+1
					 If (Skip = 1) and (StrLen(A_LoopField) < StartColumn)
						OutPut .= Section1 Section2 "`n"
					}
				 Else
					{
					 Section1:=SubStr(A_LoopField, 1, StrLen(A_LoopField) + StartColumn + 1)
					 Section2:=SubStr(A_LoopField, StrLen(A_LoopField) + StartColumn + 2)
					 If (Skip = 1) and (A_LoopField = "")
						OutPut .= Section1 Section2 "`n"
					}
				 OutPut .= Section1 InsertText Section2 "`n"
				}
			 Else
				OutPut .= A_LoopField "`n"
			}
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

; modified TF 3.4
TF_ColCut(Text, StartLine = 1, EndLine = 0, StartColumn = 1, EndColumn = 1)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 If RegExMatch(StartColumn, ",|\+|-")
		{
		 StartColumn:=_MakeMatchList(Text, StartColumn, EndColumn, 1)
		 Loop, Parse, Text, `n, `r ; parsing file/var
			{
			 If A_Index in %TF_MatchList%
				{
				 loop, parse, A_LoopField ; parsing LINE char by char
					{
					 If A_Index not in %StartColumn% ; if col not in index get char
						output .= A_LoopField
					}
				 output .= "`n"
				}
			 else
				 output .= A_LoopField "`n"
			}
		 output .= A_LoopField "`n"
		}
	 else
		{
		 StartColumn--
		 EndColumn++
		 Loop, Parse, Text, `n, `r
			{
			 If A_Index in %TF_MatchList%
				{
				 StringLeft, Section1, A_LoopField, StartColumn
				 StringMid, Section2, A_LoopField, EndColumn
				 OutPut .= Section1 Section2 "`n"
				}
			 Else
				OutPut .= A_LoopField "`n"
			}
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_ReverseLines(Text, StartLine = 1, EndLine = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 StringSplit, Line, Text, `n, `r ; line0 is number of lines
	 If (EndLine = 0 OR EndLine = "")
		EndLine:=Line0
	 If (EndLine > Line0)
		EndLine:=Line0
	 CountDown:=EndLine+1
	 Loop, Parse, Text, `n, `r
		{
		 If (A_Index < StartLine)
			Output1 .= A_LoopField "`n" ; section1
		 If A_Index between %StartLine% and %Endline%
			{
			 CountDown--
			 Output2 .= Line%CountDown% "`n" section2
			}
		 If (A_Index > EndLine)
			 Output3 .= A_LoopField "`n"
		}
	 OutPut.= Output1 Output2 Output3
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

;TF_SplitFileByLines
;example:
;TF_SplitFileByLines("TestFile.txt", "4", "sfile_", "txt", "1") ; split file every 3 lines
; InFile = 0 skip line e.g. do not include the actual line in any of the output files
; InFile = 1 include line IN current file
; InFile = 2 include line IN next file
TF_SplitFileByLines(Text, SplitAt, Prefix = "file", Extension = "txt", InFile = 1)
	{
	 LineCounter=1
	 FileCounter=1
	 Where:=SplitAt
	 Method=1
	 ; 1 = default, splitat every X lines,
	 ; 2 = splitat: - rotating if applicable
	 ; 3 = splitat: specific lines comma separated
	 TF_GetData(OW, Text, FileName)

	 IfInString, SplitAt, `- ; method 2
		{
		 StringSplit, Split, SplitAt, `-
		 Part=1
		 Where:=Split%Part%
		 Method=2
		}
	 IfInString, SplitAt, `, ; method 3
		{
		 StringSplit, Split, SplitAt, `,
		 Part=1
		 Where:=Split%Part%
		 Method=3
		}
	 Loop, Parse, Text, `n, `r
		{
		 OutPut .= A_LoopField "`n"
		 If (LineCounter = Where)
			{
			 If (InFile = 0)
				{
				 StringReplace, CheckOutput, PreviousOutput, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
					TF_ReturnOutPut(1, PreviousOutput, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; skip empty files
					 TF_SetGlobal(Prefix FileCounter,PreviousOutput)
				 Output:=
				}
			 If (InFile = 1)
				{
				 StringReplace, CheckOutput, Output, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
				 	 TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; skip empty files
				 	 TF_SetGlobal(Prefix FileCounter,Output)
				 Output:=
				}
			 If (InFile = 2)
				{
				 OutPut := PreviousOutput
				 StringReplace, CheckOutput, Output, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
					 TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; output to array
				 	 TF_SetGlobal(Prefix FileCounter,Output)
				 OutPut := A_LoopField "`n"
				}
			 If (Method <> 3)
				 LineCounter=0 ; reset
			 FileCounter++ ; next file
			 Part++
			 If (Method = 2) ; 2 = splitat: - rotating if applicable
			 	{
			 If (Part > Split0)
					{
					 Part=1
					}
				 Where:=Split%Part%
				}
			 If (Method = 3) ; 3 = splitat: specific lines comma separated
				{
				 If (Part > Split0)
					Where:=Split%Split0%
				 Else
					Where:=Split%Part%
				}
			}
		 LineCounter++
		 PreviousOutput:=Output
		 PreviousLine:=A_LoopField
		}
	 StringReplace, CheckOutput, Output, `n, , All
	 StringReplace, CheckOutput, CheckOutput, `r, , All
	 If (CheckOutPut <> "") and (OW <> 2) ; skip empty files
		TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
	 If (CheckOutput <> "") and (OW = 2) ; output to array
		{
		 TF_SetGlobal(Prefix FileCounter,Output)
		 TF_SetGlobal(Prefix . "0" , FileCounter)
		}
	}

; TF_SplitFileByText("TestFile.txt", "button", "sfile_", "txt") ; split file at every line with button in it, can be regexp
; InFile = 0 skip line e.g. do not include the actual line in any of the output files
; InFile = 1 include line IN current file
; InFile = 2 include line IN next file
TF_SplitFileByText(Text, SplitAt, Prefix = "file", Extension = "txt", InFile = 1)
	{
	 LineCounter=1
	 FileCounter=1
	 TF_GetData(OW, Text, FileName)
	 SplitPath, TextFile,, Dir
	 Loop, Parse, Text, `n, `r
		{
		 OutPut .= A_LoopField "`n"
		 FoundPos:=RegExMatch(A_LoopField, SplitAt)
		 If (FoundPos > 0)
			{
			 If (InFile = 0)
				{
				 StringReplace, CheckOutput, PreviousOutput, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
					TF_ReturnOutPut(1, PreviousOutput, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; output to array
					TF_SetGlobal(Prefix FileCounter,PreviousOutput)
				 Output:=
				}
			 If (InFile = 1)
				{
				 StringReplace, CheckOutput, Output, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
					TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; output to array
					TF_SetGlobal(Prefix FileCounter,Output)
				 Output:=
				}
			 If (InFile = 2)
				{
				 OutPut := PreviousOutput
				 StringReplace, CheckOutput, Output, `n, , All
				 StringReplace, CheckOutput, CheckOutput, `r, , All
				 If (CheckOutput <> "") and (OW <> 2) ; skip empty files
					TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
				 If (CheckOutput <> "") and (OW = 2) ; output to array
					TF_SetGlobal(Prefix FileCounter,Output)
				 OutPut := A_LoopField "`n"
				}
			 LineCounter=0 ; reset
			 FileCounter++ ; next file
			}
		 LineCounter++
		 PreviousOutput:=Output
		 PreviousLine:=A_LoopField
		}
	 StringReplace, CheckOutput, Output, `n, , All
	 StringReplace, CheckOutput, CheckOutput, `r, , All
	 If (CheckOutPut <> "") and (OW <> 2) ; skip empty files
		TF_ReturnOutPut(1, Output, Prefix FileCounter "." Extension, 0, 1)
	 If (CheckOutput <> "") and (OW = 2) ; output to array
		{
		 TF_SetGlobal(Prefix FileCounter,Output)
		 TF_SetGlobal(Prefix . "0" , FileCounter)
		}
	}

TF_Find(Text, StartLine = 1, EndLine = 0, SearchText = "", ReturnFirst = 1, ReturnText = 0)
	{
	 options:="^[imsxADJUXPS]+\)"
	 if RegExMatch(searchText,options,o)
		searchText:=RegExReplace(searchText,options,(!InStr(o,"m") ? "m$0(*ANYCRLF)" : "$0"))
	 else searchText:="m)(*ANYCRLF)" searchText
	 options:="^[imsxADJUXPS]+\)" ; Hat tip to sinkfaze, see http://www.autohotkey.com/forum/viewtopic.php?t=60062
	 if RegExMatch(searchText,options,o)
		searchText := RegExReplace(searchText,options,(!InStr(o,"m") ? "m$0" : "$0"))
	 else searchText := "m)" . searchText

	 TF_GetData(OW, Text, FileName)
	 If (RegExMatch(Text, SearchText) < 1)
		Return "0" ; SearchText not in file or error, so do nothing

	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 If (RegExMatch(A_LoopField, SearchText) > 0)
				{
				 If (ReturnText = 0)
					Lines .= A_Index "," ; line number
				 Else If (ReturnText = 1)
					Lines .= A_LoopField "`n" ; text of line
				 Else If (ReturnText = 2)
					Lines .= A_Index ": " A_LoopField "`n" ; add line number
				 If (ReturnFirst = 1) ; only return first occurrence
					Break
				}
			}
		}
	 If (Lines <> "")
		StringTrimRight, Lines, Lines, 1 ; trim trailing , or `n
	 Else
		Lines = 0 ; make sure we return 0
	 Return Lines
	}

TF_Prepend(File1, File2)
	{
FileList=
(
%File1%
%File2%
)
TF_Merge(FileList,"`n", "!" . File2)
Return
	}

TF_Append(File1, File2)
	{
FileList=
(
%File2%
%File1%
)
TF_Merge(FileList,"`n", "!" . File2)
Return
	}

; For TF_Merge You will need to create a Filelist variable, one file per line,
; to pass on to the function:
; FileList=
; (
; c:\file1.txt
; c:\file2.txt
; )
; use Loop (files & folders) to create one quickly if you want to merge all TXT files for example
;
; Loop, c:\*.txt
;   FileList .= A_LoopFileFullPath "`n"
;
; By default, a new line is used as a separator between two text files
; !merged.txt deletes target file before starting to merge files
TF_Merge(FileList, Separator = "`n", FileName = "merged.txt")
	{
	 OW=0
	 Loop, Parse, FileList, `n, `r
		{
		 Append2File= ; Just make sure it is empty
		 IfExist, %A_LoopField%
			{
			 FileRead, Append2File, %A_LoopField%
			 If not ErrorLevel ; Successfully loaded
				Output .= Append2File Separator
			}
		}

	 If (SubStr(FileName,1,1)="!") ; check if we want to delete the target file before we start
		{
		 FileName:=SubStr(FileName,2)
		 OW=1
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName, 0, 1)
	}

TF_Wrap(Text, Columns = 80, AllowBreak = 0, StartLine = 1, EndLine = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 If (AllowBreak = 1)
		Break=
	 Else
		Break=[ \r?\n]
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 If (StrLen(A_LoopField) > Columns)
				{
				 LoopField := A_LoopField " " ; just seems to work better by adding a space
				 OutPut .= RegExReplace(LoopField, "(.{1," . Columns . "})" . Break , "$1`n")
				}
			 Else
				OutPut .= A_LoopField "`n"
			}
		 Else
			 OutPut .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_WhiteSpace(Text, RemoveLeading = 1, RemoveTrailing = 1, StartLine = 1, EndLine = 0) {
	 TF_GetData(OW, Text, FileName)
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc) ; create MatchList
	 Trim:=A_AutoTrim ; store trim settings
	 AutoTrim, On ; make sure AutoTrim is on
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 If (RemoveLeading = 1) AND (RemoveTrailing = 1)
				{
				 LoopField = %A_LoopField%
				 Output .= LoopField "`n"
					 Continue
				}
			 If (RemoveLeading = 1) AND (RemoveTrailing = 0)
				{
				 LoopField := A_LoopField . "."
				 LoopField = %LoopField%
				 StringTrimRight, LoopField, LoopField, 1
				 Output .= LoopField "`n"
					 Continue
				}
			 If (RemoveLeading = 0) AND (RemoveTrailing = 1)
				{
				 LoopField := "." A_LoopField
				 LoopField = %LoopField%
				 StringTrimLeft, LoopField, LoopField, 1
				 Output .= LoopField "`n"
					 Continue
				}
			 If (RemoveLeading = 0) AND (RemoveTrailing = 0)
				{
				 Output .= A_LoopField "`n"
					 Continue
				}
			}
		 Else
			Output .= A_LoopField "`n"
		}
	AutoTrim, %Trim%	; restore original Trim
	Return TF_ReturnOutPut(OW, OutPut, FileName)
}

; Delete lines from file1 in file2 (using StringReplace)
; Partialmatch = 2 added in 3.4
TF_Substract(File1, File2, PartialMatch = 0) {
	Text:=File1
	TF_GetData(OW, Text, FileName)
	Str1:=Text
	Text:=File2
	TF_GetData(OW, Text, FileName)
		OutPut:=Text
	If (OW = 2)
		File1= ; free mem in case of var/text
	OutPut .= "`n" ; just to make sure the StringReplace will work

	If (PartialMatch = 2)
		{
		 Loop, Parse, Str1, `n, `r
			{
			 IfInString, Output, %A_LoopField%
				{
				 Output:= RegExReplace(Output, "im)^.*" . A_LoopField . ".*\r?\n?", replace)
				}
			}
		}
	Else If (PartialMatch = 1) ; allow paRTIal match
		{
		 Loop, Parse, Str1, `n, `r
			StringReplace, Output, Output, %A_LoopField%, , All ; remove lines from file1 in file2
		}
	Else If (PartialMatch = 0)
		{
		 search:="m)^(.*)$"
		 replace=__bol__$1__eol__
		 Output:=RegExReplace(Output, search, replace)
		 StringReplace, Output, Output, `n__eol__,__eol__ , All ; strange fix but seems to be needed.
		 Loop, Parse, Str1, `n, `r
			StringReplace, Output, Output, __bol__%A_LoopField%__eol__, , All ; remove lines from file1 in file2
		}
	If (PartialMatch = 0)
		{
		 StringReplace, Output, Output, __bol__, , All
		 StringReplace, Output, Output, __eol__, , All
		}

	; Remove all blank lines from the text in a variable:
	Loop
		{
		 StringReplace, Output, Output, `r`n`r`n, `r`n, UseErrorLevel
		 if (ErrorLevel = 0) or (ErrorLevel = 1) ; No more replacements needed.
			break
		}
	Return TF_ReturnOutPut(OW, OutPut, FileName, 0)
}

; Similar to "BK Replace EM" RangeReplace
TF_RangeReplace(Text, SearchTextBegin, SearchTextEnd, ReplaceText = "", CaseSensitive = "False", KeepBegin = 0, KeepEnd = 0)
	{
	 TF_GetData(OW, Text, FileName)
	 IfNotInString, Text, %SearchText%
		Return Text ; SearchTextBegin not in TextFile so return and do nothing, we have to return Text in case of a variable otherwise it would empty the variable contents bug fix 3.3
	 Start = 0
	 End = 0
	 If (KeepBegin = 1)
		 KeepBegin:=SearchTextBegin
	 Else
		 KeepBegin=
	 If (KeepEnd = 1)
		 KeepEnd:= SearchTextEnd
	 Else
		 KeepEnd=
	 If (SearchTextBegin = "")
		 Start=1
	 If (SearchTextEnd = "")
		 End=2

	 Loop, Parse, Text, `n, `r
		{
		 If (End = 1) ; end has been found already, replacement made simply continue to add all lines
			{
			 Output .= A_LoopField "`n"
				 Continue
			}
		 If (Start = 0) ; start hasn't been found
			{
			 If (InStr(A_LoopField,SearchTextBegin,CaseSensitive)) ; start has been found
				{
				 Start = 1
				 KeepSection := SubStr(A_LoopField, 1, InStr(A_LoopField, SearchTextBegin)-1)
				 EndSection := SubStr(A_LoopField, InStr(A_LoopField, SearchTextBegin)-1)
				 ; check if SearchEndText is in second part of line
				 If (InStr(EndSection,SearchTextEnd,CaseSensitive)) ; end found
					{
					 EndSection := ReplaceText KeepEnd SubStr(EndSection, InStr(EndSection, SearchTextEnd) + StrLen(SearchTextEnd) ) "`n"
					 If (End <> 2)
						End=1
					 If (End = 2)
					 	EndSection=
					}
				 Else
					EndSection=
				 Output .= KeepSection KeepBegin EndSection
				 Continue
				}
			 Else
				Output .= A_LoopField "`n" ; if not found yet simply add
				}
		 If (Start = 1) and (End <> 2) ; start has been found, now look for end if end isn't an empty string
			{
			 If (InStr(A_LoopField,SearchTextEnd,CaseSensitive)) ; end found
				{
				 End = 1
				 Output .= ReplaceText KeepEnd SubStr(A_LoopField, InStr(A_LoopField, SearchTextEnd) + StrLen(SearchTextEnd) ) "`n"
				}
			}
		}
	 If (End = 2)
		Output .= ReplaceText
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

; Create file of X lines and Y columns, fill with space or other character(s)
TF_MakeFile(Text, Lines = 1, Columns = 1, Fill = " ")
	{
	 OW=1
	 If (Text = "") ; if OutPutFile is empty return as variable
		OW=2
	 Loop, % Columns
		Cols .= Fill
	 Loop, % Lines
		Output .= Cols "`n"
	 Return TF_ReturnOutPut(OW, OutPut, Text, 1, 1)
	}

; Convert tabs to spaces, shorthand for TF_ReplaceInLines
TF_Tab2Spaces(Text, TabStop = 4, StartLine = 1, EndLine =0)
	{
	 Loop, % TabStop
		Replace .= A_Space
	 Return TF_ReplaceInLines(Text, StartLine, EndLine, A_Tab, Replace)
	}

; Convert spaces to tabs, shorthand for TF_ReplaceInLines
TF_Spaces2Tab(Text, TabStop = 4, StartLine = 1, EndLine =0)
	{
	 Loop, % TabStop
		Replace .= A_Space
	 Return TF_ReplaceInLines(Text, StartLine, EndLine, Replace, A_Tab)
	}

; Sort (section of) a text file
TF_Sort(Text, SortOptions = "", StartLine = 1, EndLine = 0) ; use the SORT options http://www.autohotkey.com/docs/commands/Sort.htm
	{
	 TF_GetData(OW, Text, FileName)
	 If StartLine contains -,+,`, ; no sections, incremental or multiple line input
		Return
	 If (StartLine = 1) and (Endline = 0) ; process entire file
		{
		 Output:=Text
		 Sort, Output, %SortOptions%
		}
	 Else
		{
		 Output := TF_ReadLines(Text, 1, StartLine-1) ; get first section
		 ToSort := TF_ReadLines(Text, StartLine, EndLine) ; get section to sort
		 Sort, ToSort, %SortOptions%
		 OutPut .= ToSort
		 OutPut .= TF_ReadLines(Text, EndLine+1) ; append last section
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

TF_Tail(Text, Lines = 1, RemoveTrailing = 0, ReturnEmpty = 1)
	{
	 TF_GetData(OW, Text, FileName)
	 Neg = 0
	 If (Lines < 0)
		{
		 Neg=1
		 Lines:= Lines * -1
		}
	 If (ReturnEmpty = 0) ; remove blank lines first so we can't return any blank lines anyway
		{
		 Loop, Parse, Text, `n, `r
			OutPut .= (RegExMatch(A_LoopField,"[\S]+?\r?\n?")) ? A_LoopField "`n" :
		 StringTrimRight, OutPut, OutPut, 1 ; remove trailing `n added by loop above
		 Text:=OutPut
		 OutPut=
	}
	 If (Neg = 1) ; get only one line!
		{
		 Lines++
		 Output:=Text
		 StringGetPos, Pos, Output, `n, R%Lines% ; These next two Lines by Tuncay see
		 StringTrimLeft, Output, Output, % ++Pos ; http://www.autoHotkey.com/forum/viewtopic.php?p=262375#262375
		 StringGetPos, Pos, Output, `n
		 StringLeft, Output, Output, % Pos
		 Output .= "`n"
		}
	 Else
		{
		 Output:=Text
		 StringGetPos, Pos, Output, `n, R%Lines% ; These next two Lines by Tuncay see
		 StringTrimLeft, Output, Output, % ++Pos ; http://www.autoHotkey.com/forum/viewtopic.php?p=262375#262375
		 Output .= "`n"
		}
	 OW = 2 ; make sure we return variable not process file
	 Return TF_ReturnOutPut(OW, OutPut, FileName, RemoveTrailing)
	}

TF_Count(String, Char)
	{
	StringReplace, String, String, %Char%,, UseErrorLevel
	Return ErrorLevel
	}

TF_Save(Text, FileName, OverWrite = 1) { ; HugoV write file
	Return TF_ReturnOutPut(OverWrite, Text, FileName, 0, 1)
	}

TF(TextFile, CreateGlobalVar = "T") { ; read contents of file in output and %output% as global var ...  http://www.autohotkey.com/forum/viewtopic.php?p=313120#313120
	 global
	 FileRead, %CreateGlobalVar%, %TextFile%
	 Return, (%CreateGlobalVar%)
	}

; TF_Join
; SmartJoin: Detect if CHAR(s) is/are already present at the end of the line before joining the next, this to prevent unnecessary double spaces for example.
; Char: character(s) to use between new lines, defaults to a space. To use nothing use ""
TF_Join(Text, StartLine = 1, EndLine = 0, SmartJoin = 0, Char = 0)
	{
	 If ( (InStr(StartLine,",") > 0) AND (InStr(StartLine,"-") = 0) ) OR (InStr(StartLine,"+") > 0)
		Return Text ; can't do multiplelines, only multiple sections of lines e.g. "1,5" bad "1-5,15-10" good, "2+2" also bad
	 TF_GetData(OW, Text, FileName)
	 If (InStr(Text,"`n") = 0)
		Return Text ; there are no lines to join so just return Text
	 If (InStr(StartLine,"-") > 0)	; OK, we need some counter-intuitive string mashing to substract ONE from the "endline" parameter
		{
		 Loop, Parse, StartLine, CSV
			{
			 StringSplit, part, A_LoopField, -
			 NewStartLine .= part1 "-" (part2-1) ","
			}
		 StringTrimRight, StartLine, NewStartLine, 1
		}
	 If (Endline > 0)
		Endline--
	 TF_MatchList:=_MakeMatchList(Text, StartLine, EndLine, 0, A_ThisFunc)
	 If (Char = 0)
		Char:=A_Space
	 Char_Org:=Char
	 GetRightLen:=StrLen(Char)-1
	 Loop, Parse, Text, `n, `r
		{
		 If A_Index in %TF_MatchList%
			{
			 If (SmartJoin = 1)
				{
				 GetRightText:=SubStr(A_LoopField,0)
				 If (GetRightText = Char)
					Char=
				}
			 Output .= A_LoopField Char
			 Char:=Char_Org
			}
		 Else
			Output .= A_LoopField "`n"
		}
	 Return TF_ReturnOutPut(OW, OutPut, FileName)
	}

;----- Helper functions ----------------

TF_SetGlobal(var, content = "") ; helper function for TF_Split* to return array and not files, credits Tuncay :-)
	{
	 global
	 %var% := content
	}

; Helper function to determine if VAR/TEXT or FILE is passed to TF
; Update 11 January 2010 (skip filecheck if `n in Text -> can't be file)
TF_GetData(byref OW, byref Text, byref FileName)
	{
	 If (text = 0 "") ; v3.6 -> v3.7 https://github.com/hi5/TF/issues/4 and https://autohotkey.com/boards/viewtopic.php?p=142166#p142166 in case user passes on zero/zeros ("0000") as text - will error out when passing on one 0 and there is no file with that name
		{
		 IfNotExist, %Text% ; additional check to see if a file 0 exists
			{
			 MsgBox, 48, TF Lib Error, % "Read Error - possible reasons (see documentation):`n- Perhaps you used !""file.txt"" vs ""!file.txt""`n- A single zero (0) was passed on to a TF function as text"
			 ExitApp
			}
		}
	 OW=0 ; default setting: asume it is a file and create file_copy
	 IfNotInString, Text, `n ; it can be a file as the Text doesn't contact a newline character
		{
		 If (SubStr(Text,1,1)="!") ; first we check for "overwrite"
			{
			 Text:=SubStr(Text,2)
			 OW=1 ; overwrite file (if it is a file)
			}
		 IfNotExist, %Text% ; now we can check if the file exists, it doesn't so it is a var
			{
			 If (OW=1) ; the variable started with a ! so we need to put it back because it is variable/text not a file
				Text:= "!" . Text
			 OW=2 ; no file, so it is a var or Text passed on directly to TF
			}
		}
	 Else ; there is a newline character in Text so it has to be a variable
		{
		 OW=2
		}
	 If (OW = 0) or (OW = 1) ; it is a file, so we have to read into var Text
		{
		 Text := (SubStr(Text,1,1)="!") ? (SubStr(Text,2)) : Text
		 FileName=%Text% ; Store FileName
		 FileRead, Text, %Text% ; Read file and return as var Text
		 If (ErrorLevel > 0)
			{
			 MsgBox, 48, TF Lib Error, % "Can not read " FileName
			 ExitApp
			}
		}
	 Return
	}

; Skan - http://www.autohotkey.com/forum/viewtopic.php?p=45880#45880
; SetWidth() : SetWidth increases a String's length by adding spaces to it and aligns it Left/Center/Right. ( Requires Space() )
TF_SetWidth(Text,Width,AlignText)
	{
	 If (AlignText!=0 and AlignText!=1 and AlignText!=2)
		AlignText=0
	 If AlignText=0
		{
		 RetStr= % (Text)TF_Space(Width)
		 StringLeft, RetText, RetText, %Width%
		}
	 If AlignText=1
		{
		 Spaces:=(Width-(StrLen(Text)))
		 RetStr= % TF_Space(Round(Spaces/2))(Text)TF_Space(Spaces-(Round(Spaces/2)))
		}
	 If AlignText=2
		{
		 RetStr= % TF_Space(Width)(Text)
		 StringRight, RetStr, RetStr, %Width%
		}
	 Return RetStr
	}

; Skan - http://www.autohotkey.com/forum/viewtopic.php?p=45880#45880
TF_Space(Width)
	{
	 Loop,%Width%
		Space=% Space Chr(32)
	 Return Space
	}

; Write to file or return variable depending on input
TF_ReturnOutPut(OW, Text, FileName, TrimTrailing = 1, CreateNewFile = 0) {
	If (OW = 0) ; input was file, file_copy will be created, if it already exist file_copy will be overwritten
		{
		 IfNotExist, % FileName ; check if file Exist, if not return otherwise it would create an empty file. Thanks for the idea Murp|e
			{
			 If (CreateNewFile = 1) ; CreateNewFile used for TF_SplitFileBy* and others
				{
				 OW = 1
				 Goto CreateNewFile
				}
			 Else
				Return
			}
		 If (TrimTrailing = 1)
			 StringTrimRight, Text, Text, 1 ; remove trailing `n
		 SplitPath, FileName,, Dir, Ext, Name
		 If (Dir = "") ; if Dir is empty Text & script are in same directory
			Dir := A_WorkingDir
		 IfExist, % Dir "\backup" ; if there is a backup dir, copy original file there
			FileCopy, % Dir "\" Name "_copy." Ext, % Dir "\backup\" Name "_copy.bak", 1
		 FileDelete, % Dir "\" Name "_copy." Ext
		 FileAppend, %Text%, % Dir "\" Name "_copy." Ext
		 Return Errorlevel ? False : True
		}
	 CreateNewFile:
	 If (OW = 1) ; input was file, will be overwritten by output
		{
		 IfNotExist, % FileName ; check if file Exist, if not return otherwise it would create an empty file. Thanks for the idea Murp|e
			{
			If (CreateNewFile = 0) ; CreateNewFile used for TF_SplitFileBy* and others
				Return
			}
		 If (TrimTrailing = 1)
			 StringTrimRight, Text, Text, 1 ; remove trailing `n
		 SplitPath, FileName,, Dir, Ext, Name
		 If (Dir = "") ; if Dir is empty Text & script are in same directory
			Dir := A_WorkingDir
		 IfExist, % Dir "\backup" ; if there is a backup dir, copy original file there
			FileCopy, % Dir "\" Name "." Ext, % Dir "\backup\" Name ".bak", 1
		 FileDelete, % Dir "\" Name "." Ext
		 FileAppend, %Text%, % Dir "\" Name "." Ext
		 Return Errorlevel ? False : True
		}
	If (OW = 2) ; input was var, return variable
		{
		 If (TrimTrailing = 1)
			StringTrimRight, Text, Text, 1 ; remove trailing `n
		 Return Text
		}
	}

; _MakeMatchList()
; Purpose:
; Make a MatchList which is used in various functions
; Using a MatchList gives greater flexibility so you can process multiple
; sections of lines in one go avoiding repetitive fileread/append actions
; For TF 3.4 added COL = 0/1 option (for TF_Col* functions) and CallFunc for
; all TF_* functions to facilitate bug tracking
_MakeMatchList(Text, Start = 1, End = 0, Col = 0, CallFunc = "Not available")
	{
	 ErrorList=
	 (join|
Error 01: Invalid StartLine parameter (non numerical character)`nFunction used: %CallFunc%
Error 02: Invalid EndLine parameter (non numerical character)`nFunction used: %CallFunc%
Error 03: Invalid StartLine parameter (only one + allowed)`nFunction used: %CallFunc%
	 )
	 StringSplit, ErrorMessage, ErrorList, |
	 Error = 0

	 If (Col = 1)
		{
		 LongestLine:=TF_Stat(Text)
		 If (End > LongestLine) or (End = 1) ; FIXITHERE BUG
			End:=LongestLine
		}

	 TF_MatchList= ; just to be sure
	 If (Start = 0 or Start = "")
		Start = 1

	 ; some basic error checking

	 ; error: only digits - and + allowed
	 If (RegExReplace(Start, "[ 0-9+\-\,]", "") <> "")
		 Error = 1

	 If (RegExReplace(End, "[0-9 ]", "") <> "")
		 Error = 2

	 ; error: only one + allowed
	 If (TF_Count(Start,"+") > 1)
		 Error = 3

	 If (Error > 0 )
		{
		 MsgBox, 48, TF Lib Error, % ErrorMessage%Error%
		 ExitApp
		}

	 ; Option #0 [ added 30-Oct-2010 ]
	 ; Startline has negative value so process X last lines of file
	 ; endline parameter ignored

	 If (Start < 0) ; remove last X lines from file, endline parameter ignored
		{
		 Start:=TF_CountLines(Text) + Start + 1
		 End=0 ; now continue
		}

	 ; Option #1
	 ; StartLine has + character indicating startline + incremental processing.
	 ; EndLine will be used
	 ; Make TF_MatchList

	 IfInString, Start, `+
		{
		 If (End = 0 or End = "") ; determine number of lines
			End:= TF_Count(Text, "`n") + 1
		 StringSplit, Section, Start, `, ; we need to create a new "TF_MatchList" so we split by ,
		 Loop, %Section0%
			{
			 StringSplit, SectionLines, Section%A_Index%, `+
			 LoopSection:=End + 1 - SectionLines1
			 Counter=0
			 	 TF_MatchList .= SectionLines1 ","
			 Loop, %LoopSection%
				{
				 If (A_Index >= End) ;
					Break
				 If (Counter = (SectionLines2-1)) ; counter is smaller than the incremental value so skip
					{
					 TF_MatchList .= (SectionLines1 + A_Index) ","
					 Counter=0
					}
				 Else
					Counter++
				}
			}
		 StringTrimRight, TF_MatchList, TF_MatchList, 1 ; remove trailing ,
		 Return TF_MatchList
		}

	 ; Option #2
	 ; StartLine has - character indicating from-to, COULD be multiple sections.
	 ; EndLine will be ignored
	 ; Make TF_MatchList

	 IfInString, Start, `-
		{
		 StringSplit, Section, Start, `, ; we need to create a new "TF_MatchList" so we split by ,
		 Loop, %Section0%
			{
			 StringSplit, SectionLines, Section%A_Index%, `-
			 LoopSection:=SectionLines2 + 1 - SectionLines1
			 Loop, %LoopSection%
				{
				 TF_MatchList .= (SectionLines1 - 1 + A_Index) ","
				}
			}
		 StringTrimRight, TF_MatchList, TF_MatchList, 1 ; remove trailing ,
		 Return TF_MatchList
		}

	 ; Option #3
	 ; StartLine has comma indicating multiple lines.
	 ; EndLine will be ignored

	 IfInString, Start, `,
		{
		 TF_MatchList:=Start
		 Return TF_MatchList
		}

	 ; Option #4
	 ; parameters passed on as StartLine, EndLine.
	 ; Make TF_MatchList from StartLine to EndLine

	 If (End = 0 or End = "") ; determine number of lines
			End:= TF_Count(Text, "`n") + 1
	 LoopTimes:=End-Start
	 Loop, %LoopTimes%
		{
		 TF_MatchList .= (Start - 1 + A_Index) ","
		}
	 TF_MatchList .= End ","
	 StringTrimRight, TF_MatchList, TF_MatchList, 1 ; remove trailing ,
	 Return TF_MatchList
	}

; added for TF 3.4 col functions - currently only gets longest line may change in future
TF_Stat(Text)
	{
	 TF_GetData(OW, Text, FileName)
	 Sort, Text, f _AscendingLinesL
	 Pos:=InStr(Text,"`n")-1
	 Return pos
	}

_AscendingLinesL(a1, a2) ; used by TF_Stat
	{
	 Return StrLen(a2) - StrLen(a1)
	}

CF_ToolTip(tipText, delay := 1000)
{
	ToolTip
	ToolTip, % tipText
	SetTimer, RemoveToolTip, % "-" delay
return

RemoveToolTip:
	ToolTip
return
}

; http://ebstudio.info/home/xdoc2txt.html
Class xd2txlib {
Static xd2txlibdll := A_ScriptDir . "\..\..\引用程序" (A_PtrSize=8 ? "\x64\" : "\x32\") . "xd2txlib.dll"

get_Init()
{
return this._Init
}

Init()
{
	static dll_mem
	if !dll_mem
	{
		dll_mem := DllCall("LoadLibrary", "Str", this.xd2txlibdll, "Ptr")
		if !dll_mem
    {
      this._Init := 0
      return 0
    }
    else
    {
      this.hModule := dll_mem
      this._Init := 1
      return 1
    }
	}
}

Uninit()
{
this._Init := 0
DllCall("FreeLibrary", "Ptr", this.hModule)
}

ExtractText(file)
{
	if !this._Init
	{
		this.Init()
		if !this._Init
		return 0
	}

  fileText:=""
  i:=DllCall(this.xd2txlibdll "\ExtractText", "Str", file, "int", 0, "int*", fileText)
  return StrGet( fileText, i / 2 )
}
}

IsRenaming()
{
	Vista7 := 1
	If(Vista7)
	 ControlGetFocus focussed, A ; 获取到的控件为 Edit1
  Else
    focussed:=XPGetFocussed()
	If(WinActive("ahk_class CabinetWClass")) ;Explorer
	{
		If(strStartsWith(focussed,"Edit"))
		{
			If(Vista7)
			{
				; Win 10 中有可能是 DirectUIHWND2 或 DirectUIHWND3
				ControlGetPos , X, Y, Width, Height,DirectUIHWND3, A
				if !X
					ControlGetPos , X, Y, Width, Height,DirectUIHWND2, A
			}
			Else
				ControlGetPos , X, Y, Width, Height, SysListView321, A
			ControlGetPos , X1, Y1, Width1, Height1, %focussed%, A
			If(IsInArea(X1, Y1, X, Y, Width, Height) && IsInArea(X1+Width1, Y1, X, Y, Width, Height) && IsInArea(X1,Y1+Height1, X, Y, Width, Height) && IsInArea(X1+Width1,Y1+Height1, X, Y, Width, Height))
				Return true
		}
	}
	Else If (WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW")) ;Desktop
	{
		If(focussed="Edit1")
			Return true
	}
	Else If((x:=IsDialog())) ;FileDialogs
	{
		If(strStartsWith(focussed,"Edit1"))
		{
			;figure out If the the edit control is inside the DirectUIHWND2 or SysListView321
			If(x=1 && Vista7) ;New Dialogs
				ControlGetPos , X, Y, Width, Height, DirectUIHWND2, A
			Else ;Old Dialogs
				ControlGetPos , X, Y, Width, Height, SysListView321, A
			ControlGetPos , X1, Y1, Width1, Height1, %focussed%, A
			If(IsInArea(X1, Y1, X, Y, Width, Height)&&IsInArea(X1+Width1, Y1, X, Y, Width, Height)&&IsInArea(X1, Y1+Height1, X, Y, Width, Height)&&IsInArea(X1+Width1, Y1+Height1, X, Y, Width, Height))
				Return true
		}
	}
	Else If (WinActive("ahk_class EVERYTHING")) ; EVERYTHING
	{
		If(focussed="Edit1")
		{
			;tooltip 123
			Return true
		}
	}
	Return false
}

XPGetFocussed()
{
  WinGet ctrlList, ControlList, A
  ctrlHwnd:=GetFocusedControl()
  ; Built an array indexing the control names by their hwnd
  Loop Parse, ctrlList, `n
  {
    ControlGet hwnd, Hwnd, , %A_LoopField%, A
    hwnd += 0   ; Convert from hexa to decimal
    If(hwnd=ctrlHwnd)
    {
      Return A_LoopField
    }
  }
}

strStartsWith(string,start)
{
	x:=(strlen(start)<=strlen(string)&&Substr(string,1,strlen(start))=start)
	Return x
}

IsInArea(px,py,x,y,w,h)
{
	Return (px>x&&py>y&&px<x+w&&py<y+h)
}

IsDialog(window=0)
{
	result:=0
	If(window)
		window := "ahk_id " window
	Else
		window:="A"
	WinGetClass, wc, %window%
	If(wc = "#32770")
	{
		;Check for new FileOpen dialog
		ControlGet, hwnd, Hwnd, , DirectUIHWND3, %window%
		If(hwnd)
		{
			ControlGet, hwnd, Hwnd, , SysTreeView321, %window%
			If(hwnd)
			{
				ControlGet, hwnd, Hwnd, , Edit1, %window%
				If(hwnd)
				{
					ControlGet, hwnd, Hwnd, , Button2, %window%
					If(hwnd)
					{
						ControlGet, hwnd, Hwnd, , ComboBox2, %window%
						If(hwnd)
						{
						ControlGet, hwnd, Hwnd, , ToolBarWindow323, %window%
						If(hwnd)
							result := 1
						}
					}
				}
			}
		}
		;Check for old FileOpen dialog
		If(!result)
		{
			ControlGet, hwnd, Hwnd, , ToolbarWindow321, %window%          ;工具栏
			If(hwnd)
			{
				ControlGet, hwnd, Hwnd, , SysListView321, %window%        ;文件列表
				If(hwnd)
				{
					ControlGet, hwnd, Hwnd, , ComboBox3, %window%         ;文件类型下拉选择框
					If(hwnd)
					{
						ControlGet, hwnd, Hwnd, , Button3, %window%       ;取消按钮
						If(hwnd)
						{
							;ControlGet, hwnd, Hwnd , , SysHeader321 , %window%    ;详细视图的列标题
							ControlGet, hwnd, Hwnd, , ToolBarWindow322, %window%  ;左侧导航栏
							If(hwnd)
								result := 2
						}
					}
				}
			}
		}
	}
	Return result
}

GetFocusedControl()
{
   guiThreadInfoSize := 4+4+A_PtrSize*6+16
   VarSetCapacity(guiThreadInfo, guiThreadInfoSize, 0)
   ;addr := &guiThreadInfo
   ;DllCall("RtlFillMemory", "ptr", addr, "UInt", 1, "UChar", guiThreadInfoSize)   ; Below 0xFF, one call only is needed
   If not DllCall("GetGUIThreadInfo"
         , "UInt", 0   ; Foreground thread
         , "ptr", &guiThreadInfo)
   {
      ErrorLevel := A_LastError   ; Failure
      Return 0
   }
   focusedHwnd := NumGet(guiThreadInfo,8+A_PtrSize, "Ptr") ;focusedHwnd := *(addr + 12) + (*(addr + 13) << 8) +  (*(addr + 14) << 16) + (*(addr + 15) << 24)
   Return focusedHwnd
}

CF_IsFolder(sfile){
	if InStr(FileExist(sfile), "D")
	|| (sfile = """::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
	|| SubStr(sfile, 1, 2) = "\\"
		return 1
	else
		return 0
}

PathU(Filename) { ;  PathU v0.91 by SKAN on D35E/D68M @ tiny.cc/pathu
Local OutFile
  VarSetCapacity(OutFile, 520)
  DllCall("Kernel32\GetFullPathNameW", "WStr",Filename, "UInt",260, "Str",OutFile, "Ptr",0)
  DllCall("Shell32\PathYetAnotherMakeUniqueName", "Str",OutFile, "Str",Outfile, "Ptr",0, "Ptr",0)
Return A_IsUnicode ? OutFile : StrGet(&OutFile, "UTF-16")
}

Deref(String)
{
    spo := 1
    out := ""
    while (fpo:=RegexMatch(String, "(%(.*?)%)|``(.)", m, spo))
    {
        out .= SubStr(String, spo, fpo-spo)
        spo := fpo + StrLen(m)
        if (m1)
            out .= %m2%
        else switch (m3)
        {
            case "a": out .= "`a"
            case "b": out .= "`b"
            case "f": out .= "`f"
            case "n": out .= "`n"
            case "r": out .= "`r"
            case "t": out .= "`t"
            case "v": out .= "`v"
            default: out .= m3
        }
    }
    return out SubStr(String, spo)
}