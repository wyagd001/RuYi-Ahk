﻿;|2.8|2024.11.30|1646
; 复制路径后，自动打开本地文件(用于github 上帮助文件更新时自动打开本地文件同步更新)
git:
;if !SelectedPath
;	SelectedPath := GetSelText()
SelectedPath := StrReplace(Clipboard, "::")
SelectedPath := StrReplace(SelectedPath, "/", "\")
SelectedPath := RegExReplace(SelectedPath, "docs\\(.*)=", "docs\")
SelectedPath := RegExReplace(SelectedPath, "(.*)\.htm(.*)", "$1.htm")
;msgbox % SelectedPath
Ahk_Help_Html_Path := "D:\资料\autohotkey 帮助"
Ahk_Help_Editor_Path := "F:\Program Files\AutoHotkey\SciTE\SciTE.exe"

Switch  ; 需要主程序版本 1.1.31.00
{
	case InStr(SelectedPath, "zh-cn"), InStr(SelectedPath, "v1"):
	{
    if InStr(SelectedPath, "zh-cn")
      SelectedPath := SubStr(SelectedPath, InStr(SelectedPath, "docs")+5)
    else if InStr(SelectedPath, "v1")
      SelectedPath := SubStr(SelectedPath, InStr(SelectedPath, "docs")+8)
		if FileExist(Ahk_Help_Html_Path "\v1\docs\" SelectedPath)
		{
			;if WinExist("ahk_class Notepad3U")
			;{
			;	WinActivate, ahk_class Notepad3U
			;	DropFiles(Ahk_Help_Html_Path "\v1\docs\" SelectedPath, "ahk_class Notepad3U")
			;}
			;else
				run "%Ahk_Help_Editor_Path%" "%Ahk_Help_Html_Path%\v1\docs\%SelectedPath%"
			return
		}
	}

	case InStr(SelectedPath, "v2"):
	{
    if InStr(SelectedPath, "v2\docs")
      SelectedPath := SubStr(SelectedPath, InStr(SelectedPath, "docs")+5)
    else if InStr(SelectedPath, "docs\v2")
      SelectedPath := SubStr(SelectedPath, InStr(SelectedPath, "docs")+8)
    ;msgbox % InStr(SelectedPath, "docs")
		if FileExist(Ahk_Help_Html_Path "\v2\docs\" SelectedPath)
		{
			;if WinExist("ahk_class Notepad2U")
			;{
			;	WinActivate, ahk_class Notepad2U
			;	DropFiles(Ahk_Help_Html_Path "\v2\docs\" SelectedPath, "ahk_class Notepad2U")
			;}
			;else
			run "%Ahk_Help_Editor_Path%" "%Ahk_Help_Html_Path%\v2\docs\%SelectedPath%"
		return
		}
	}

	Default:
	{
		SelectedPath := LTrim(SelectedPath,"\")
		if FileExist(Ahk_Help_Html_Path "\v2\" SelectedPath) && !GetKeyState("ScrollLock" , "T")
		{
			;if WinExist("ahk_class Notepad2U")
			;{
			;	WinActivate, ahk_class Notepad2U
			;	DropFiles(Ahk_Help_Html_Path "\v2\" SelectedPath, "ahk_class Notepad2U")
			;}
			;else
			;{
				run "%Ahk_Help_Editor_Path%" "%Ahk_Help_Html_Path%\v2\%SelectedPath%"
			;	sleep, 200
			;	WinSet, AlwaysOnTop,, ahk_class Notepad2U
			;}
		return
		}
		if FileExist(Ahk_Help_Html_Path "\v1\" SelectedPath) && GetKeyState("ScrollLock" , "T")
		{
			;if WinExist("ahk_class Notepad3U")
			;{
			;	WinActivate, ahk_class Notepad3U
			;	DropFiles(Ahk_Help_Html_Path "\v1\" SelectedPath, "ahk_class Notepad3U")
			;}
			;else
			;{
				run "%Ahk_Help_Editor_Path%" "%Ahk_Help_Html_Path%\v1\%SelectedPath%"
			;	sleep, 200
			;	WinSet, AlwaysOnTop,, ahk_class Notepad3U
			;}
		return
		}
	}
}
return