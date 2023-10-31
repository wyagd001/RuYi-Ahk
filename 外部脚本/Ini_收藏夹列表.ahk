;|2.4|2023.10.03|1516
#Persistent
#SingleInstance Force
Windy_CurWin_Id := A_Args[1]

IniMenuInifile := A_ScriptDir "\..\配置文件\外部脚本\ini菜单.ini"
ATA_settingFile := A_ScriptDir "\..\配置文件\如一.ini"
IniMenuobj := ini2obj(IniMenuInifile)
Global IniMenuobj, IniMenuInifile
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, Shell32.dll, 174

Gui, Destroy
gui, add, listbox, x5 y5 vComb w80 h505 gMR, 文件||文件夹|程序|命令|网址|注册表|如意动作|常用文本

Gui, Add, ListView, vMyListView gMyListView xp+82 y5 w525 h497 grid, N|文件名|地址
Gui, Add, Button, xp+535 yp w60 geditnewrow, 新增
Gui, Add, Button, xp yp+28 w60 geditrow, 编辑
Gui, Add, Button, xp yp+28 w60 gDelListItem, 删除

Gui, Add, Button, xp yp+40 w60 gMoveRow_Up, 向上
Gui, Add, Button, xp yp+28 w60 gMoveRow_Down, 向下

Gui, Add, Button, xp yp+40 w60 gopensetfile, 打开配置

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

	else if(Comb = "常用文本")
	{
		if Windy_CurWin_Id
		{
			if WinExist("ahk_id" Windy_CurWin_id)
				WinActivate, ahk_id %Windy_CurWin_id%
			else
				gui, Minimize
		}
		else
			gui, Minimize
		Candy_Cmd := StrReplace(Candy_Cmd, "\r", "`r")
		Candy_Cmd := StrReplace(Candy_Cmd, "\n", "`n")
		sleep 200
		send, %Candy_Cmd%
	}

	; 注册表
	else if (RegExMatch(Candy_Cmd, "i)^(HKCU|HKCR|HKCC|HKU|HKLM|HKEY|计算机\\HK|\[HK)"))
	{
		f_OpenReg(Candy_Cmd)
		return
	}

	; 网址
	else if RegExMatch(Candy_Cmd, "i)^(https://|http://)+(.*\.)+.*")
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
		LV_Add("", index, data_array[2], data_array[1])
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

GuiDropFiles:
;MsgBox % A_GuiEvent "|" A_EventInfo
AddDroppedFileOrLnk(A_GuiEvent, A_EventInfo)
RefreshData(Comb)
Return

AddDroppedFileOrLnk(FileList, filesCount) ;Add all shortcuts dropped from explorer to the listview (quite equivalent to "EditLV")
{
	If (filesCount=1)
		AddSelToMenu(FileList)
	else
	{
		Loop, parse, FileList, `n
		{
			AddSelToMenu(A_LoopField)
		}
	}
}

AddSelToMenu(CandySel)
{
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
		{
			Tmp_Count := IniMenuobj["程序"].Count()
			iniwrite, % CandySel "|" CandySel_FileNameNoExt "．" CandySel_Ext, %IniMenuInifile%, 程序, % Tmp_Count + 1
			 IniMenuobj["程序"][Tmp_Count + 1] := CandySel "|" CandySel_FileNameNoExt "．" CandySel_Ext
		}
		else
		{
			Tmp_Count := IniMenuobj["文件"].Count()
			iniwrite, % CandySel "|" CandySel_FileNameNoExt "．" CandySel_Ext, %IniMenuInifile%, 文件, % IniMenuobj["文件"].Count() + 1
			IniMenuobj["文件"][Tmp_Count + 1] := CandySel "|" CandySel_FileNameNoExt "．" CandySel_Ext
		}
	}
	else
	{
		Tmp_Count := IniMenuobj["文件夹"].Count()
		iniwrite, % CandySel "|" CandySel_FileNameNoExt, %IniMenuInifile%, 文件夹, % IniMenuobj["文件夹"].Count() + 1
		IniMenuobj["文件夹"][Tmp_Count + 1] := CandySel "|" CandySel_FileNameNoExt
	}
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
{
	Tmp_Count := IniMenuobj["命令"].Count()
	iniwrite, % CandySel "|" CandySel, %IniMenuInifile%, 命令, % IniMenuobj["命令"].Count() + 1
	IniMenuobj["命令"][Tmp_Count + 1] := CandySel "|" CandySel
}
return
}

MoveRow_Up:
Gui, Submit, NoHide
LV_MoveRow()
LV_RowIndexOrder()
LV_ListToObj(comb)
Return

MoveRow_Down:
Gui, Submit, NoHide
LV_MoveRow(0)
LV_RowIndexOrder()
LV_ListToObj(comb)
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

LV_RowIndexOrder()
{
	loop % LV_GetCount()
	{
		LV_Modify(A_index, , A_index)
	}
}

LV_ListToObj(SubObj)
{
	loop % LV_GetCount()
	{
		LV_GetText(R_index, A_index, 1)
		LV_GetText(R_Name, A_index, 2)
		LV_GetText(R_Path, A_index, 3)
		IniMenuobj[SubObj][R_index] := R_Path "|" R_Name
	}
	obj2ini(IniMenuobj, IniMenuInifile)
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
	;msgbox % Tmp_Index
	IniMenuobj[Comb].RemoveAt(Tmp_Index)
	IniDelete, % IniMenuInifile, % Comb, % IniMenuobj[Comb].Count()+1
}
obj2ini(IniMenuobj, IniMenuInifile)
RefreshData(Comb)
return


Editrow:
RF := LV_GetNext(0, "F")
if RF
{
	LV_GetText(R_index, RF, 1)
	LV_GetText(R_Name, RF, 2)
	LV_GetText(R_Path, RF, 3)
}
editnewrow:
Gui, 98:Destroy
Gui, 98:+Owner1
Gui, 1:+Disabled
Gui, 98:Default
Gui, Submit, NoHide
if !R_index && !R_Name && !R_Path
	R_index := IniMenuobj[Comb].Count()+1
Gui, Add, Text, x20 y20 w50 h20, 编号：
Gui, Add, Text, x20 y50 w60 h20, 名称：
Gui, Add, Text, x20 y80 w80 h20, 路径(地址)：
Gui, Add, Edit, x110 y20 w500 h20 readonly vR_index, %R_index%
Gui, Add, Edit, x110 y50 w500 h20 vR_Name, %R_Name%
Gui, Add, Edit, x110 y80 w500 h20 vR_Path, %R_Path%
Gui, Add, Button, x460 y110 w70 h30 g98ButtonOK, 确定
Gui, Add, Button, x540 y110 w70 h30 g98GuiClose Default, 取消
Gui, Show,, Ini_收藏夹 项目编辑
Return

98ButtonOK:
Gui, 98:Submit
Gui, 98:Destroy
Gui, 1:Default
Gui, 1:-Disabled
Gui, Submit, NoHide
IniMenuobj[Comb][R_index] := R_Path "|" R_Name
obj2ini(IniMenuobj, IniMenuInifile)
RefreshData(Comb)
R_index := R_Name := R_Path := ""
return

98GuiEscape:
98GuiClose:
Gui, 1:-Disabled
Gui, 98:Destroy
R_index := R_Name := R_Path := ""
Return

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