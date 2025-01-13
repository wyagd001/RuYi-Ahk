;|2.9|2024.01.08|1212
CandySel := A_Args[1]
IniMenuInifile := A_ScriptDir "\..\配置文件\外部脚本\Ini_收藏夹.ini"
if !fileexist(IniMenuInifile)
  FileCopy % A_ScriptDir "\..\..\配置文件\外部脚本\Ini_收藏夹_默认配置.ini", % IniMenuInifile
CurrentWebBrowserOpen_IniFile := A_ScriptDir "\..\配置文件\外部脚本\运行选中的文本.ini"
if !fileexist(CurrentWebBrowserOpen_IniFile)
  FileCopy % A_ScriptDir "\..\..\配置文件\外部脚本\运行选中的文本_默认配置.ini", % CurrentWebBrowserOpen_IniFile

IniMenuobj := ini2obj(IniMenuInifile)
show_obj(IniMenuobj)
return

ini2obj(file){
	iniobj := {}
	FileRead, filecontent, %file% ;加载文件到变量
	StringReplace, filecontent, filecontent, `r,, All
	StringSplit, line, filecontent, `n, , ;用函数分割变量为伪数组
	Loop ;循环
	{
		if A_Index > %line0%
			Break
		content = % line%A_Index% ;赋值当前行
		FSection := RegExMatch(content, "\[.*\]") ;正则表达式匹配section
		if FSection = 1 ;如果找到
		{
			TSection := RegExReplace(content, "\[(.*)\]", "$1") ;正则替换并赋值临时section $为向后引用
			iniobj[TSection] := {}
		}
		Else
		{
			FKey := RegExMatch(content, "^.*=.*") ;正则表达式匹配key
			if FKey
			{
				TKey := RegExReplace(content, "^(.*?)=.*", "$1") ;正则替换并赋值临时key
				StringReplace, TKey, TKey, ., _, All
				TValue := RegExReplace(content, "^.*?=(.*)", "$1") ;正则替换并赋值临时value
				if TKey
					iniobj[TSection][TKey] := TValue
			}
		}
	}
Return iniobj
}

obj2ini(obj, file){
	if (!isobject(obj) or !file)
		Return 0
	for k,v in obj
	{
		for key,value in v
		{
			IniWrite, %value%, %file%, %k%, %key%
			;fileappend %key%-%value%`n, %A_desktop%\123.txt
		}
	}
Return 1
}

show_obj(obj, menu_name := ""){
	if menu_name =
	{
		main = 1
		Random, rand, 100000000, 999999999
		menu_name = %A_Now%%rand%
	}
	;Menu, % menu_name, add,
	;Menu, % menu_name, DeleteAll
	for k,v in obj
	{
		if (IsObject(v))
		{
			submenu_name = %k%
			Menu, % submenu_name, add,
			Menu, % submenu_name, DeleteAll
			Menu, % menu_name, add, % k ? k : "", :%submenu_name%
			Menu, % submenu_name, add, 添加选中到菜单, AddSelToMenu
			Menu, % submenu_name, add
			show_obj(v, submenu_name)
		}
		Else
		{
			Sub_menu := GetStringIndex(v, 2)
			Menu, % menu_name, add, % Sub_menu, MenuHandler
		}
	}
	if main = 1
		menu, % menu_name, show
}

MenuHandler:
if (A_thisMenu != "注册表")
	Candy_Cmd := IniMenuobj[A_thisMenu][A_ThisMenuItemPos-2]
else
	Candy_Cmd := IniMenuobj[A_thisMenu][A_ThisMenuItemPos-3]
Candy_Cmd := GetStringIndex(Candy_Cmd)
;msgbox % A_ThisMenuItem " - " Candy_Cmd

if (A_thisMenu = "如意动作")
{
	Candy_Cmd := GetStringIndex(Candy_Cmd)
	ExecSendToRuyi("",, Candy_Cmd)
	;MsgBox % Candy_Cmd
	Return
}

if(A_thisMenu = "常用文本")
{
	if Windy_CurWin_Id
	{
		if WinExist("ahk_id" Windy_CurWin_id)
			WinActivate, ahk_id %Windy_CurWin_id%
	}
	else
		WinActivate, A
	Candy_Cmd := StrReplace(Candy_Cmd, "\r", "`r")
	Candy_Cmd := StrReplace(Candy_Cmd, "\n", "`n")
	sleep 200
	send, %Candy_Cmd%
  return
}

if (RegExMatch(Candy_Cmd, "i)^(HKCU|HKCR|HKCC|HKU|HKLM|HKEY|计算机\\HK|\[HK)"))
{
	f_OpenReg(Candy_Cmd)
	return
}

if RegExMatch(Candy_Cmd, "i)^(https://|http://)+(.*\.)+.*")
{
	WinGet, Windy_CurWin_Fullpath, ProcessPath, A
	WinGet, OutPID, PID, A
	SplitPath, Windy_CurWin_Fullpath, Windy_CurWin_ProcName
	ATA_filepath := Candy_Cmd
	Gosub CurrentWebOpen
	return
}

Candy_Cmd := Deref(Candy_Cmd)
run %Candy_Cmd%,, UseErrorLevel
return

AddSelToMenu:
if !CandySel
	return
SplitPath, CandySel, CandySel_FileName, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt, CandySel_Drive
FileRead, Tmp_Str, % IniMenuInifile
if instr(Tmp_Str, CandySel)
	return
; 文件
if fileexist(CandySel)
{
	; 文件
	if !InStr(FileExist(CandySel), "D")
	{
		; 程序
		if (CandySel_Ext = "exe")
			iniwrite, % CandySel "|" CandySel_FileNameNoExt "．" CandySel_Ext, %IniMenuInifile%, 程序, % IniMenuobj["程序"].Count() + 1
		else
		{
			iniwrite, % CandySel "|" CandySel_FileNameNoExt "．" CandySel_Ext, %IniMenuInifile%, 文件, % IniMenuobj["文件"].Count() + 1
		}
	}
	else
		iniwrite, % CandySel "|" CandySel_FileNameNoExt, %IniMenuInifile%, 文件夹, % IniMenuobj["文件夹"].Count() + 1
}
else if RegExMatch(CandySel, "i)^(https://|http://)+(.*\.)+.*")
{
	domain := StrReplace(CandySel_Drive, "https://", "")
	domain := StrReplace(domain, "http://", "")
	iniwrite, % CandySel "|" domain, %IniMenuInifile%, 网址, % IniMenuobj["网址"].Count() + 1
}
else if (RegExMatch(CandySel, "i)^(HKCU|HKCR|HKCC|HKU|HKLM|HKEY|计算机\\HK|\[HK)"))
{
	iniwrite, % CandySel "|" CandySel_FileName, %IniMenuInifile%, 注册表, % IniMenuobj["注册表"].Count() + 1
}
else
	iniwrite, % CandySel "|" CandySel, %IniMenuInifile%, 命令, % IniMenuobj["命令"].Count() + 1
return

f_OpenReg(RegPath)
{
	RegPath := LTrim(RegPath, "[")
	RegPath := RTrim(RegPath, "]")
	StringLeft, RegPathFirst4, RegPath, 4
	if RegPathFirst4 = HKCR
		StringReplace, RegPath, RegPath, HKCR, HKEY_CLASSES_ROOT
	else if RegPathFirst4 = HKCU
		StringReplace, RegPath, RegPath, HKCU, HKEY_CURRENT_USER
	else if RegPathFirst4 = HKLM
		StringReplace, RegPath, RegPath, HKLM, HKEY_LOCAL_MACHINE
	else if RegPathFirst4 = HKCC
		StringReplace, RegPath, RegPath, HKCC, HKEY_CURRENT_CONFIG
	else if RegPathFirst4 = HKU
		StringReplace, RegPath, RegPath, HKU, HKEY_USERS

	; 将字串中的前两个"＿"(全角) 替换为“_"(半角)
	StringReplace, RegPath, RegPath, ＿, _
	StringReplace, RegPath, RegPath, ＿, _
	; 替换字串中第一个“, ”为"\"
	StringReplace, RegPath, RegPath, `,%A_Space%, \
	; 替换字串中第一个“,”为"\"
	StringReplace, RegPath, RegPath, `,, \
	; 将字串中的所有"/" 替换为“\"
	StringReplace, RegPath, RegPath, /, \, All
	; 将字串中的所有"／"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ／, \, All
	; 将字串中的所有"＼"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ＼, \, All
	StringReplace, RegPath, RegPath, %A_Space%\, \, All
	StringReplace, RegPath, RegPath, \%A_Space%, \, All
	; 将字串中的所有“\\”替换为“\”
	StringReplace, RegPath, RegPath, \\, \, All

	RegRead, MyComputer, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey
	f_Split2(MyComputer, "\", MyComputer, aaa)
	MyComputer := MyComputer ? MyComputer : (A_OSVersion="WIN_XP")?"我的电脑":"计算机"
	IfNotInString, RegPath, %MyComputer%\
		RegPath := MyComputer "\" RegPath
	;tooltip % RegPath

	IfWinExist, ahk_class RegEdit_RegEdit
	{
		RunWait, % "cmd.exe /c taskkill /IM regedit.exe", , Hide
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe
	}
	Else
	{
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe ;-m
	}
return
}

f_Split2(String, Seperator, ByRef LeftStr, ByRef RightStr)
{
	SplitPos := InStr(String, Seperator)
	if SplitPos = 0 ; Seperator not found, L = Str, R = ""
	{
		LeftStr := String
		RightStr:= ""
	}
	else
	{
		SplitPos--
		StringLeft, LeftStr, String, %SplitPos%
		SplitPos++
		StringTrimLeft, RightStr, String, %SplitPos%
	}
	return
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

CurrentWebOpen:
; ATA_filepath 含有 "/" 字符时, 使用浏览器打开, 网址中不支持中文字符
IniRead, Default_Browser, %CurrentWebBrowserOpen_IniFile%, Browser, Default_Browser, %A_Space%
IniRead, url, %CurrentWebBrowserOpen_IniFile%, Browser, Default_Url
IniRead, InUse_Browser, %CurrentWebBrowserOpen_IniFile%, Browser, InUse_Browser
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

GetStringIndex(String, Index := 1)
{
	arrCandy_Cmd_Str := StrSplit(String, "|", " `t")
	NewStr := arrCandy_Cmd_Str[Index]
	return NewStr
}

ExecSendToRuyi(ByRef StringToSend := "", Title := "如一 ahk_class AutoHotkey", wParam := 0, Msg := 0x4a) {
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)

	DetectHiddenWindows, On
	if Title is integer
	{
		SendMessage, Msg, wParam, &CopyDataStruct,, ahk_id %Title%
		;msgbox % ErrorLevel  "qq"
	}
	else if Title is not integer
	{
		SetTitleMatchMode 2
		sendMessage, Msg, wParam, &CopyDataStruct,, %Title%
	}
	DetectHiddenWindows, Off
return ErrorLevel
}