;|2.4|2023.09.20|1096
; Script Information ===========================================================
; Name:         File String Search
; Description:  Search files for a specific string (Inspired by TLM)
;               https://autohotkey.com/boards/viewtopic.php?f=6&t=27299 
; AHK Version:  AHK_L 1.1.24.04 (Unicode 32-bit) - December 17, 2016
; OS Version:   Windows 2000+
; Language:     English - United States (en-US)
; Author:       Weston Campbell <westoncampbell@gmail.com>
; Filename:     StringSearch.ahk
; ==============================================================================

; Revision History =============================================================
; Revision 1 (2017-01-25)
; * Initial release
; ==============================================================================

; Auto-Execute =================================================================
#SingleInstance, Force ; Allow only one running instance of script
#Persistent ; Keep the script permanently running until terminated
#NoEnv ; Avoid checking empty variables for environment variables
#Warn ; Enable warnings to assist with detecting common errors
;#NoTrayIcon ; Disable the tray icon of the script
SendMode, Input ; The method for sending keystrokes and mouse clicks
SetWorkingDir, %A_ScriptDir% ; Set the working directory of the script
SetBatchLines, -1 ; The speed at which the lines of the script are executed
SetWinDelay, -1 ; The delay to occur after modifying a window
SetControlDelay, -1 ; The delay to occur after modifying a control
OnExit("OnUnload") ; Run a subroutine or function when exiting the script
return ; End automatic execution
; ==============================================================================

; Labels =======================================================================
ControlHandler:
    VarCount := ""
    If (A_GuiControl = "ButtonDir") {
        FileSelectFolder, DirSel,,, 选择目录...
        IfEqual, ErrorLevel, 1, return
        GuiControl,, EditDir, % DirSel
        GuiControl, choose, EditDir, % DirSel
    } Else If (A_GuiControl = "ButtonSearch") {
        Gui, Submit, NoHide
        if !EditString
          Return
        GuiControl, Choose, Tab, 2
        LV_Delete()
        SB_SetText("搜索中...", 1)
        SB_SetText("", 2)
        
        GuiControl, Disable, ButtonSearch
        GuiControl, Enable, ButtonStop
        
        Loop, Files, % EditDir "\" (EditType ? EditType : "*.*"), FR
        {
            if A_LoopFileExt in txt,ahk,au3,htm
            	FileEncoding % File_GetEncoding(A_LoopFileFullPath)
            ;FileEncoding % File_GetEncoding(A_LoopFileFullPath)
            Try FileRead, MatchRead, % A_LoopFileFullPath   ;  utf8  编码的问题

            IfEqual, SearchStop, 1, Break
            if !fullword
            {
              StringReplace, MatchRead, MatchRead, % EditString, % EditString, UseErrorLevel
              IfEqual, ErrorLevel, 0, Continue
            }
            else
            {
              MatchRead := RegExReplace(MatchRead, "i)\b" EditString "\b", EditString, VarCount) 
              IfEqual, VarCount, 0, Continue
            } 
            LV_Add("", (VarCount != "") ? VarCount : ErrorLevel, A_LoopFileFullPath)
            LV_ModifyCol(1, "AutoHdr")
            LV_ModifyCol(2, "AutoHdr")
            SB_SetText("`t`t搜索 " A_Index . " 个文件, (" LV_GetCount() "个匹配)", 2)
        }
        LV_ModifyCol(1, "Logical")
        SearchStop := 0
        
        GuiControl, Disable, ButtonStop
        GuiControl, Enable, ButtonSearch
        GuiControl, Enable, OpenFileFullPath
        GuiControl, Enable, OpenFile
        
        SB_SetText("扫描完毕", 1)
    } Else If (A_GuiControl = "ButtonStop") {
        SearchStop := 1
    }
return

OpenFileFullPath:
LV_GetText(FileFullPath, LV_GetNext("F"), 2)
If Fileexist(FileFullPath)
	CF_OpenFolder(FileFullPath)
else
	msgbox, 未选中或文件不存在。
Return

OpenFile:
LV_GetText(FileFullPath, LV_GetNext("F"), 2)
If Fileexist(FileFullPath)
	Run, "%notepad2%" "%FileFullPath%"
else
	msgbox, 未选中或文件不存在。
Return

LV1x:
Gui,1:default
Gui,1:submit, nohide
rcon := a_guicontrol
Gui,1:ListView, %rcon%
Extensions := "ahk,txt,bat,bas,ini,htm,html,csv,xml"    ;- some extensions with text
  RN := LV_GetNext("C")
  RF := LV_GetNext("F")
  GC := LV_GetCount()
  if (rn = 0)
    return
if A_GuiEvent = DoubleClick
  {
  LV_GetText(C2, a_eventinfo, 2)
  SplitPath,c2, , , ext,
  if Ext in %Extensions%
    {
    try
		run, "%notepad2%" "%c2%"
    }
  }
return

GuiEscape:
GuiClose:
ExitSub:
    ExitApp ; Terminate the script unconditionally
return
; ==============================================================================

; Functions ====================================================================
OnLoad() {
    Global ; Assume-global mode
    run_iniFile = %A_ScriptDir%\文本文件中查找字符.ini
    Static Init := OnLoad() ; Call function
		Menu, Tray, UseErrorLevel
		Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\ede4.ico"
    EditDir = %1%
    if !EditDir
      IniRead, EditDir, %run_iniFile%, 文件中查找字符, 路径, %A_Space%
    IniRead, SEditDir, %run_iniFile%, 文件中查找字符, 固定查找目录, %A_Space%
    IniRead, EditType, %run_iniFile%, 文件中查找字符, 类型, %A_Space%
    IniRead, SEditType, %run_iniFile%, 文件中查找字符, 固定类型, %A_Space%
    IniRead, EditString, %run_iniFile%, 文件中查找字符, 字符, %A_Space%
    IniRead, notepad2, %A_ScriptDir%\..\..\..\配置文件\如一.ini, 其他程序, notepad2, Notepad.exe
    if InStr(notepad2, "%A_ScriptDir%")
		{
			RY_Dir := Deref("%A_ScriptDir%")
			RY_Dir := SubStr(RY_Dir, 1, InStr(RY_Dir, "\", 0, 0, 3) - 1)
   		notepad2 := StrReplace(notepad2, "%A_ScriptDir%", RY_Dir)
   		;msgbox % notepad2
		}
    SearchStop := 0
}

OnUnload(ExitReason, ExitCode) {
    Global ; Assume-global mode
    
    Gui, Submit, NoHide
    if EditDir <>
			IniWrite, % EditDir, %run_iniFile%, 文件中查找字符, 路径
		if EditType <>
      IniWrite, % EditType, %run_iniFile%, 文件中查找字符, 类型
    IniWrite, % EditString, %run_iniFile%, 文件中查找字符, 字符
}

GuiCreate() {
    Global ; Assume-global mode
    Static Init := GuiCreate() ; Call function
    If SEditDir not contains  %EditDir%
       EditDirList := EditDir "|" SEditDir
    else
       EditDirList := SEditDir
    If SEditType not contains  %EditType%
       EditTypeList := EditType "|" SEditType
    else
       EditTypeList := SEditType
    Gui, +LastFound -Resize +HWNDhGui1
    Gui, Margin, 8, 8
    Gui, Add, Tab3, vTab, 查找|搜索结果

    Gui, Tab, 1
    Gui, Add, Text, w460 BackgroundTrans Section, 目录:
    Gui, Add, ComBoBox, y+10 w416 vEditDir, % EditDirList
    Gui, Add, Button, x+10 yp w34 hp vButtonDir gControlHandler, ...
    Gui, Add, Text, xs y+20 w460 BackgroundTrans, 文件类型:
    Gui, Add, ComBoBox, y+10 w460 vEditType, % EditTypeList
    Gui, Add, Text, xs y+20 w460 BackgroundTrans, 字符:
    Gui, Add, Edit, y+10 w460 vEditString, % EditString
    GuiControl, choose, EditDir, % EditDir
    GuiControl, choose, EditType, % EditType
    Gui, Add, CheckBox, xs y+10 h20 vfullword,全字符匹配(单词边界)

    Gui, Tab, 2
    Gui, Add, ListView, w460 r10 vListView Grid +altsubmit vLV1 gLV1x, 找到次数|文件路径

    Gui, Tab
    Gui, Add, Button, w80 h24 default vButtonSearch gControlHandler, 搜索   
    Gui, Add, Button, x+10 w80 h24 vButtonStop gControlHandler Disabled, 停止
    Gui, Add, Button, x+10 w100 h24 vOpenFileFullPath gOpenFileFullPath Disabled, 打开文件位置
    Gui, Add, Button, x+10 w100 h24 vOpenFile gOpenFile Disabled, 编辑文件  
    
    Gui, Add, StatusBar,,
    SB_SetParts(120)
    
    Gui, Show, AutoSize, 文件字符搜索
}
; ==============================================================================

CF_OpenFolder(sfile, OnlyFolder := 1){
	if !CF_IsFolder(sfile)
		SplitPath, sfile, , oPath
	if OnlyFolder
		Run %oPath%
	else
		Run, % "explorer.exe /select," sfile
}

CF_IsFolder(sfile){
	if InStr(FileExist(sfile), "D")
	|| (sfile = """::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
	|| SubStr(sfile, 1, 2) = "\\"
		return 1
	else
		return 0
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