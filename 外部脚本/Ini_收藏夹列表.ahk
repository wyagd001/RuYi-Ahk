;|2.4|2023.09.15|1317
#Persistent
#SingleInstance Force
CandySel := A_Args[1]
IniMenuInifile := A_ScriptDir "\..\配置文件\外部脚本\ini菜单.ini"
ATA_settingFile := A_ScriptDir "\..\配置文件\如一.ini"
IniMenuobj := ini2obj(IniMenuInifile)
Global IniMenuobj
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, Shell32.dll, 174

Gui, Destroy
Gui, font, s10 ,等线
Gui, Add, ComboBox, gMR vComb, 文件||文件夹|程序|命令|网址|注册表|如意动作|常用文本
Gui, Add, Button, xp+160 w120 gopensetfile, 打开配制文件

Gui, font, s12 ,等线
Gui, Add, ListView, vMyListView gMyListView x10 y33 w525 h500 grid, N|文件名|地址
GuiControl, Font, MyListView
Menu, MyListViewMenu, Add, 删除条目, DelListItem
Gosub updateListView
Return

MyListView:
if (A_GuiEvent = "DoubleClick")
{
	LV_GetText(Candy_Cmd, A_EventInfo, 3)
	Gui, Submit, NoHide

	if (Comb = "如意动作")
	{
		ExecSendToRuyi("", Candy_Cmd)
		Return
	}

	if(Comb = "常用文本")
	{
		Gui, hide
		content := RowText3
		Candy_Cmd := StrReplace(Candy_Cmd, "\r", "`r")
		Candy_Cmd := StrReplace(Candy_Cmd, "\n", "`n")
		sleep 200
		send, %Candy_Cmd%
	}

	; 注册表
	if (RegExMatch(Candy_Cmd, "i)^(HKCU|HKCR|HKCC|HKU|HKLM|HKEY|计算机\\HK|\[HK)"))
	{
		f_OpenReg(Candy_Cmd)
		return
	}

	; 网址
	if RegExMatch(Candy_Cmd, "i)^(https://|http://)+(.*\.)+.*")
	{
		WinGet, Windy_CurWin_Fullpath, ProcessPath, A
		WinGet, OutPID, PID, A
		SplitPath, Windy_CurWin_Fullpath, Windy_CurWin_ProcName
		ATA_filepath := Candy_Cmd
		Gosub CurrentWebOpen
		return
	}

	; 文件
	Candy_Cmd := Deref(Candy_Cmd)
	run %Candy_Cmd%,, UseErrorLevel
	return
}
return

MR:
Gosub updateListView
return

updateListView:
Gui,Submit, NoHide
RefreshData(Comb)
return

RefreshData(sectname)
{
	LV_Delete()
	for index,element in IniMenuobj[sectname]
	{
		data_array := StrSplit(element, "|")
		LV_Add("", index, data_array[2],data_array[1])
	}
	LV_ModifyCol()
	Gui, Show, , Ini_收藏夹
}

GuiContextMenu:
if (A_GuiControl = "MyListView")
{
	Menu, MylistViewMenu, Show, %A_GuiX%, %A_GuiY%
}
return

DelListItem:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_Str, RF, 1)
}
Gui,Submit, NoHide
IniMenuobj[Comb].Remove(Tmp_Str)
obj2ini(IniMenuobj, IniMenuInifile)
IniDelete, % IniMenuInifile, % Comb, % IniMenuobj[Comb].Count()+1
RefreshData(Comb)
return

opensetfile:
run, % IniMenuInifile
return

#IFWinActive Ini_收藏夹
1::
2::
3::
4::
5::
6::
7::
8::
9::
LV_GetText(Candy_Cmd, A_ThisHotkey, 3)
Gui, Submit, NoHide

if (Comb = "如意动作")
{
	ExecSendToRuyi("", Candy_Cmd)
	Return
}

if(Comb = "常用文本")
{
	Gui, hide
	content := RowText3
	Candy_Cmd := StrReplace(Candy_Cmd, "\r", "`r")
	Candy_Cmd := StrReplace(Candy_Cmd, "\n", "`n")
	sleep 200
	send, %Candy_Cmd%
	Return
}

; 注册表
if (RegExMatch(Candy_Cmd, "i)^(HKCU|HKCR|HKCC|HKU|HKLM|HKEY|计算机\\HK|\[HK)"))
{
	f_OpenReg(Candy_Cmd)
	return
}

; 网址
if RegExMatch(Candy_Cmd, "i)^(https://|http://)+(.*\.)+.*")
{
	WinGet, Windy_CurWin_Fullpath, ProcessPath, A
	WinGet, OutPID, PID, A
	SplitPath, Windy_CurWin_Fullpath, Windy_CurWin_ProcName
	ATA_filepath := Candy_Cmd
	Gosub CurrentWebOpen
	return
}

; 文件
Candy_Cmd := Deref(Candy_Cmd)
run %Candy_Cmd%,, UseErrorLevel
return

ESC::
Gui,hide
Return
#IfWinActive

GuiClose:
	ExitApp

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

GetStringIndex(String, Index := 1)
{
	arrCandy_Cmd_Str := StrSplit(String, "|", " `t")
	NewStr := arrCandy_Cmd_Str[Index]
	return NewStr
}

FileExt_GetIcon(File)
{
	; Allocate memory for a SHFILEINFOW struct.
	VarSetCapacity(fileinfo, fisize := A_PtrSize + 688)
	
	; Get the file's icon.
	if DllCall("shell32\SHGetFileInfoW", "wstr", File
		, "uint", 0, "ptr", &fileinfo, "uint", fisize, "uint", 0x100 | 0x000000001)
	{
		Return hicon := NumGet(fileinfo, 0, "ptr")
		; Set the menu item's icon.
		; Because we used ":" and not ":*", the icon will be automatically
		; freed when the program exits or if the menu or item is deleted.
	}
}

ExecSendToRuyi(ByRef StringToSend := "", wParam := 0, Title := "如一 ahk_class AutoHotkey", Msg := 0x4a) {
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