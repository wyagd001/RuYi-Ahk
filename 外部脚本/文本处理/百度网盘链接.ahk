;|2.0|2023.07.01|1186
#SingleInstance force
CandySel := A_Args[1]
ATA_settingFile := A_ScriptDir "\..\..\配置文件\如一.ini"

DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
WinGet, Windy_CurWin_Fullpath, ProcessPath, Ahk_ID %Windy_CurWin_id%
WinGet, OutPID, PID, Ahk_ID %Windy_CurWin_id%
if !Windy_CurWin_Fullpath
{
	WinGet, Windy_CurWin_Fullpath, ProcessPath, A
	WinGet, OutPID, PID, A
}
SplitPath, Windy_CurWin_Fullpath, Windy_CurWin_ProcName

newSel := RegExReplace(CandySel, "[一-龟]")
RegExMatch(newSel, "i)(https?|ftp|file)(://)[-A-Za-z0-9\+&@#/%\?=~_\|!:,\.;]+[-A-Za-z0-9\+&@#/%=~_\|]", OutURL)
;RegExMatch(CandySel, "i)(https?|ftp|file)(://)[-A-Za-z0-9\+&@#/%\?=~_\|!:,\.;]+[-A-Za-z0-9\+&@#/%=~_\|]", OutURL)
RegExMatch(CandySel, "(?:提取码|密码).*?(\w{4})", OutCode)
;msgbox % OutURL " `n " OutCode1
If OutURL
{
	ATA_filepath := OutURL
	Gosub CurrentWebOpen
}
If OutCode1
{
	clipboard := OutCode1
	sleep 2000
	if (Windy_CurWin_ProcName = "chrome.exe")
	{
		accAddressBar := FindChromeAddressBar(Windy_CurWin_id)
		accAddressBar.accObj.accValue(0) := "javascript:document.querySelector(""form input"").value = '" OutCode1 "';document.querySelector('form').onsubmit()"
		accAddressBar.accObj.accSelect(0x1, 0)
		sleep,500
		;ControlSend,, {Enter}, ahk_id %Windy_CurWin_id%
	}
	else
	{
		WinGet, Windy_CurWin_Fullpath, ProcessPath, A
		SplitPath, Windy_CurWin_Fullpath, Windy_CurWin_ProcName
		if (Windy_CurWin_ProcName = "chrome.exe")
		{
			Windy_CurWin_id := WinExist("A")
			accAddressBar := FindChromeAddressBar(Windy_CurWin_id)
			accAddressBar.accObj.accValue(0) := "javascript:document.querySelector(""form input"").value = '" OutCode1 "';document.querySelector('form').onsubmit()"
			accAddressBar.accObj.accSelect(0x1, 0)
			sleep,500
			;ControlSend,, {Enter}, ahk_id %Windy_CurWin_id%
		}
	}
}
return

CurrentWebOpen:
; ATA_filepath 含有 "/" 字符时, 使用浏览器打开, 网址中不支持中文字符
IniRead, Default_Browser, %ATA_settingFile%, Browser, Default_Browser, %A_Space%
IniRead, url, %ATA_settingFile%, Browser, Default_Url
IniRead, InUse_Browser, %ATA_settingFile%, Browser, InUse_Browser
;msgbox % Default_Browser " - " ATA_filepath
If Default_Browser
{
	Loop, parse, url, |
	{
		IfInString, ATA_filepath, %A_LoopField%    ;ATA_filepath有特定字符时使用默认浏览器打开
		{
			Loop, parse, Default_Browser, `,
			{
				run %A_LoopField% "%ATA_filepath%",, UseErrorLevel
				if !ErrorLevel
				break
			}
			if (ErrorLevel = "error")
				msgbox A_LastError
			return
		}
	}
}
br := 0
if InStr(InUse_Browser, Windy_CurWin_ProcName)   ;当前窗口在使用的浏览器列表当中
{
	If(Windy_CurWin_ProcName = "chrome.exe" or Windy_CurWin_ProcName = "firefox.exe")
	{
			pid := GetCommandLine2(OutPID)
			run, %pid% "%ATA_filepath%"
			br :=1
	}
	else
	{
			pid := GetModuleFileNameEx(OutPID)
			;msgbox %pid% "%ATA_filepath%"
			run, %pid% "%ATA_filepath%"
			br := 1
	}
}
StringSplit, BApp, InUse_Browser, `,     ;当前窗口进程名不在使用的浏览器列表当中
LoopN := 1
if !br
{
	Loop, %BApp0%
	{
		BCtrApp := BApp%LoopN%
		LoopN++
		Process, Exist, %BCtrApp%
		If (errorlevel<>0)    ;  使用的浏览器列表当中的浏览器进程是否存在
		{
			NewPID = %ErrorLevel%
			If(BCtrApp = "chrome.exe" or BCtrApp = "firefox.exe")
			{
				pid := GetCommandLine2(NewPID)
				;pid := GetCommandLine(NewPID)
				;FileAppend , %pid%`n, %A_desktop%\123.txt
				run, %pid% "%ATA_filepath%"
				br :=1
				break
			}
			else
			{
				pid := GetModuleFileNameEx(NewPID)
				;FileAppend , %pid%`n, %A_desktop%\123.txt
				run, %pid% "%ATA_filepath%"
				br := 1
				break
			}
		}
	}
}
if !br   ; 没有打开的浏览器时使用默认的浏览器
{
	If Default_Browser
	{
		Loop, parse, Default_Browser, `,
		{
			run %A_LoopField% "%ATA_filepath%",, UseErrorLevel
			if !ErrorLevel
			break
		}
		if (ErrorLevel = "error") && (A_LastError = 2)
		{
			msgbox % "找不到默认的浏览器, 请检查设置文件的 Default_Browser 条目, 指定默认的浏览器位置或名称."
		}
	}
	else
	{
		run iexplore.exe %ATA_filepath%,, UseErrorLevel
		if (ErrorLevel = "error")
		msgbox 请检查网址: %ATA_filepath%
	}
}
return

GetModuleFileNameEx(p_pid)
{
	if A_OSVersion in WIN_95,WIN_98,WIN_ME,WIN_XP
	{
		MsgBox, Windows 版本 (%A_OSVersion%) 不支持。Win 7 及以上系统才能正常使用。
		return
	}

	h_process := DllCall("OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid)
	if ( ErrorLevel or h_process = 0 )
		return

	name_size = 255
	VarSetCapacity(name, name_size)

	result := DllCall("psapi.dll\GetModuleFileNameEx", "uint", h_process, "uint", 0, "str", name, "uint", name_size)

	DllCall("CloseHandle", h_process)
	return, name
}

GetCommandLine2(pid)
{
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where ProcessId=" pid)
		Return sCmdLine := process.CommandLine
}

FindChromeAddressBar(Win_hWnd := "", oAcc := "", accPath := "") {
	if !oAcc {
			oAcc := Acc_ObjectFromWindow(Win_hWnd)
			while oAcc.accRole(0) != 9 { ; ROLE_SYSTEM_WINDOW := 9
				oAcc := Acc_Parent(oAcc)
			}
		}

	for i, child in Acc_Children(oAcc) {
		nRole := child.accRole(0)
		
		if (nRole = 42) { ; ROLE_SYSTEM_TEXT := 42
			if (child.accName(0) ~= "i)address|地址") {
				accPath := LTrim(accPath "." i, ".")
				return {accObj: child, accPath: accPath, hWnd: hWnd}
			}
		}

		/*
			ROLE_SYSTEM_APPLICATION := 14
			ROLE_SYSTEM_PANE        := 16
			ROLE_SYSTEM_GROUPING    := 20
			ROLE_SYSTEM_TOOLBAR     := 22
			ROLE_SYSTEM_COMBOBOX    := 46
		*/
		static oGroup := {14:1, 16:1, 20:1, 22:1, 46:1}
		if oGroup.HasKey(nRole) {
			if result := FindChromeAddressBar(, child, accPath "." i) {
				return result
			}
		}
	}
}