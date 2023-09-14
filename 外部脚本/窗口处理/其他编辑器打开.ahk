;|2.3|2023.09.13|多条目
CandySel := A_Args[1]
if InStr(CandySel, "%A_ScriptDir%")
{
	RY_Dir := Deref("%A_ScriptDir%")
	RY_Dir := SubStr(RY_Dir, 1, InStr(RY_Dir, "\", 0, 0, 2) - 1)
	CandySel := StrReplace(CandySel, "%A_ScriptDir%", RY_Dir)
	;msgbox % CandySel
}
DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")

if Windy_CurWin_id
{
	WinGet Windy_CurWin_Pid, PID, ahk_id %Windy_CurWin_id%
	WinGetTitle, Windy_CurWin_Title, ahk_id %Windy_CurWin_id%
}
else
{
	WinGet Windy_CurWin_Pid, PID, A
	WinGetTitle, Windy_CurWin_Title, A
}

Windo_其他编辑器打开:
sTextDocumentPath := GetTextDocumentPath(Windy_CurWin_Pid, Windy_CurWin_id, Windy_CurWin_Title)
if (CandySel = "当前浏览器")
{
	B_Autohotkey := A_ScriptDir "\..\..\引用程序\" (A_PtrSize = 8 ? "AutoHotkeyU64.exe" : "AutoHotkeyU32.exe")
	run, "%B_Autohotkey%" "%A_ScriptDir%\当前浏览器打开.ahk" "%sTextDocumentPath%"
	If (ErrorLevel = "Error")
		msgbox 请检查编辑器路径: %B_Autohotkey% `n和文档路径: %sTextDocumentPath%
}
else
{
	run, %CandySel% "%sTextDocumentPath%",, UseErrorLevel
	If (ErrorLevel = "Error")
		msgbox 请检查编辑器路径: %CandySel% `n和文档路径: %sTextDocumentPath%
}
return

GetTextDocumentPath(_pid, _id, _Title)
{
	; 窗口标题有路径的窗口直接获取窗口标题文字
	IfInString, _Title, :\ 
	{  
		; 匹配目录不能匹配文件
		;FullNamell:=RegExReplace(_Title,"^.*(.:(\\)?.*)\\.*$","$1")
		; 编辑器文件修改后标题开头带“*”
		RegExMatch(_Title, "i)^\*?\K.*\..*(?= [-*] )", FileFullPath)
		FileFullPath := Trim(FileFullPath, " *[]")
		If FileFullPath  && FileExist(FileFullPath)
			return FileFullPath
	}

	;;;;;;;;;;;;;;提取命令行;;;;;;;;;
	;WMI_Query("\\.\root\cimv2", "Win32_Process")
	CMDLine := WMI_Query(_pid)
	RegExMatch(CMDLine, "i).*exe.*?\s+""?([a-zA-Z]:\\.*)", ff_)   ; 正则匹配命令行参数
	; 带参数的命令行不能得到路径  例如 a.exe /resart "D:\123.txt"
	; 命令行参数中打开的文件有些程序带  “"”，（"打开文件路径"） 有些程序不带 “"”（打开文件路径）
	StringReplace, FileFullPath, ff_1, `",, All
	ff_ := ff_1 := ""
	if FileFullPath && FileExist(FileFullPath)
		return FileFullPath

	IfInString, _Title, 记事本
	{
		_Title := StrReplace(_Title, "*")
		If (_Title = "无标题 - 记事本")
		Return

		OSRecentTextFile := A_AppData "\Microsoft\Windows\Recent\" StrReplace(_Title, " - 记事本") ".lnk"
		FileGetShortcut, % OSRecentTextFile, FileFullPath
		if FileExist(FileFullPath)
			return FileFullPath
	}
}

WMI_Query(pid)
{
	wmi :=    ComObjGet("winmgmts:")
	queryEnum := wmi.ExecQuery("" . "Select * from Win32_Process where ProcessId=" . pid)._NewEnum()
	if queryEnum[process]
		sResult.=process.CommandLine
	else
		sResult := 0 
	Return   sResult
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