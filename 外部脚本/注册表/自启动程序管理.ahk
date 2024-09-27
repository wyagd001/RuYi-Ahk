;|2.8|2024.09.17|1671
; 来源网址: http://thinkai.net/page/16   已修改
#SingleInstance force
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\E703.ico"
;创建界面
Gui, Add, CheckBox, x5 y5 vuser w120 h20 Checked, HKCU(当前用户)
Gui, Add, CheckBox, xp+130 y5 vcomp w120 h20 Checked, HKLM(所有用户)
Gui, Add, Text, x5 yp+20 w40 h20 , 名称:
Gui, Add, Edit, x50 yp w395 h20 viname,
Gui, Add, Button, xp+395 yp w60 h20 gapply, 新增
Gui, Add, Text, x5 yp+20 w40 h20, 目标:
Gui, Add, Edit, x50 yp w395 h20 vitargetfile,
Gui, Add, Button, xp+395 yp w60 h20 gselectexe, 浏览

Gui, Add, Text, x5 yp+30 w50 h20, 已有项目
Gui, add, ListView, x5 yp+20 w500 h260 Checked vmylist1 AltSubmit gEditItem, 序号|名称|命令|注册表来源
Gui, Add, Button, x510 yp w60 h20 gLoadSystemItem, 刷新
Gui, Add, Button, x510 yp+40 w60 h20 gdelicon, 删除
Gui Add, Text, x510 yp+40 w70 h2 +0x10
Gui, Add, Button, x510 yp+10 w60 h20 ggreg1, HKCU
Gui, Add, Button, x510 yp+20 w60 h20 ggreg2, HKLM
Gui, Add, Button, x510 yp+20 w60 h20 ggreg3, HKLM32
Gui, Add, Button, x510 yp+20 w60 h20 ggstartfolder, 启动
Gui, Add, Button, x510 yp+20 w60 h20 ggstartfolder2, 启动(All)
Gui, Add, Button, x510 yp+20 w60 h20 ggsettingsS, 设置启动
Gui, Add, Button, x510 yp+20 w60 h20 ggtaskmgrS, 任管

Gui, Add, Picture, x510 y15 w48 h48 vsico,
Gui, Show, , 启动项管理

gosub LoadSystemItem
Return

apply:
gui, submit, nohide
if (iname and itargetfile)
{
  if comp
    RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %iname%, %itargetfile%
  if user
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, %iname%, %itargetfile%
}

gosub LoadSystemItem
Return

GuiClose:
ExitApp

selectexe:
gui +owndialogs
fileselectfile, exe, 1, %lastdir%, 打开---可执行文件, 可执行文件(*.exe)
if exe =
	Return
GuiControl, , itargetfile, %exe%
return

greg1:
KeyName := "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run"
f_OpenReg(KeyName)
return

greg2:
KeyName := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
f_OpenReg(KeyName)
return

greg3:
KeyName := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run"
f_OpenReg(KeyName)
return

gstartfolder:
run "%A_Startup%"
return

gstartfolder2:
run "%A_StartupCommon%"
return

gtaskmgrS:
if InStr(A_OSVersion, "10.0.")
  return
run Taskmgr.exe
sleep 500
; A_OsVersion
; win 10  10.0.19045
; win 11  10.0.22631
; win 10
; 计算机\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\TaskManager
; StartUpTab  以 0 开始的选项卡序号
; win 11
; %LocalAppData%\Microsoft\Windows\TaskManager\settings.json
; DefaultStartPage  以 0 开始的选项卡序号
; 计算机\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run
;       HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run
; 计算机\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\StartupFolder
; 启用 RuYi - Ahk
; 启用 : 02 00 00 00 00 00 00 00 00 00 00 00 (hex)
; 禁用 : 03 00 00 00 xx xx xx xx xx xx xx 01(hex)   xx 为随机字符
OSbuildNum := StrReplace(A_OsVersion, "10.0.")
if (OSbuildNum < 20348) ; Win10
{
  ControlGet, OutputVar, Tab,, SysTabControl321, 任务管理器
  while (OutputVar != 4)
  {
    if (A_index > 5)
      break
    SendMessage, 0x1330, 3,, SysTabControl321, 任务管理器  ; 0x1330 为 TCM_SETCURFOCUS.
    Sleep 0  ; 此行和下一行只对于某些选项卡控件才需要.
    SendMessage, 0x130C, 3,, SysTabControl321, 任务管理器  ; 0x130C 为 TCM_SETCURSEL.
    ControlGet, OutputVar, Tab,, SysTabControl321, 任务管理器
    sleep 100
  }
}
else   ; Win11
{
  ControlFocus, Windows.UI.Input.InputSite.WindowClass2, 任务管理器
  send ^{home}
  sleep 100
  send {down}
  sleep 100
  send {down}
  sleep 100
  send {down}
  sleep 100
  send {down}
  send {enter}
}
Return

gsettingsS:
run ms-settings:startupapps
return

delicon:
Gui, ListView, MyList1
RF := LV_GetNext("F")
IsChecked := 0
if RF
{
	LV_GetText(lname, RF, 2)
  LV_GetText(regaddr, RF, 4)
  SendMessage, 0x102C, RF - 1, 0xF000, SysListView321  ; 0x102C 为 LVM_GETITEMSTATE. 0xF000 为 LVIS_STATEIMAGEMASK.
  IsChecked := (ErrorLevel >> 12) - 1  ; 如果 RowNumber 为选中的则设置 IsChecked 为真, 否则为假.
}
;msgbox % lname "|" regaddr "|" IsChecked
if lname && regaddr
{
  if IsChecked
  {
    if (regaddr = "HKCU")
      RegDelete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, %lname%
    else if (regaddr = "HKLM")
      RegDelete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %lname%
    else if (regaddr = "HKLM32")
      RegDelete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run, %lname%
  }
  if !IsChecked
  {
    if (regaddr = "HKCU")
      RegDelete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, %lname%
    else if (regaddr = "HKLM")
      RegDelete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, %lname%
    else if (regaddr = "HKLM32")
      RegDelete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, %lname%
  }
}
gosub LoadSystemItem
return

f_OpenReg(RegPath)
{
	RegPath:=LTrim(RegPath, "[")
	RegPath:=RTrim(RegPath, "]")
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

LoadSystemItem:
;Critical On
LoadLV_dis_Label := 1
sleep 100
Gui, ListView, MyList1
LV_Delete()

B_index := 0
Loop, Reg, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, V
{
  RegRead, value
  ;msgbox % A_LoopRegName "|" Value
  if value
  {
    B_index ++
    LV_Add("Check", B_index, A_LoopRegName, value, "HKCU")
  }
}
Loop, Reg, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, V
{
  RegRead, value
  if value
  {
    B_index ++
    LV_Add("", B_index, A_LoopRegName, value, "HKCU")
  }
}
Loop, Reg, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, V
{
  RegRead, value
  if value
  {
    B_index ++
    LV_Add("Check", B_index, A_LoopRegName, value, "HKLM")
  }
}
Loop, Reg, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, V
{
  RegRead, value
  if value
  {
    B_index ++
    LV_Add("", B_index, A_LoopRegName, value, "HKLM")
  }
}
Loop, Reg, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run, V
{
  RegRead, value
  if value
  {
    B_index ++
    LV_Add("Check", B_index, A_LoopRegName, value, "HKLM32")
  }
}
Loop, Reg, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, V
{
  RegRead, value
  if value
  {
    B_index ++
    LV_Add("", B_index, A_LoopRegName, value, "HKLM32")
  }
}

LV_ModifyCol()
LV_ModifyCol(3, 270)
settimer setlvdisvalue, -1500
return

EditItem:
Gui, ListView, MyList2
if (A_GuiEvent = "DoubleClick")
{
	RF := LV_GetNext("F")
	if RF
	{
    LV_GetText(lname, RF, 2)
		LV_GetText(lfpath, RF, 3)
		GuiControl,, iname, % lname
		GuiControl,, itargetfile, % lfpath
		SetIcon(lfpath)
	}
}
if (A_GuiEvent = "I") && (ErrorLevel = "C") && !LoadLV_dis_Label
{
  LV_GetText(lname, A_EventInfo, 2)
  LV_GetText(lfpath, A_EventInfo, 3)
	LV_GetText(regaddr, A_EventInfo, 4)
  ;msgbox % regaddr "|" LoadLV_dis_Label "|" A_GuiControl "|" ErrorLevel
	if (ErrorLevel == "c") && lname
	{
    if (regaddr = "HKCU")
    {
      RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, %lname%, %lfpath%
      RegDelete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, %lname%
    }
    else if (regaddr = "HKLM")
    {
      RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, %lname%, %lfpath%
      RegDelete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %lname%
    }
    else if (regaddr = "HKLM32")
    {
      RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, %lname%, %lfpath%
      RegDelete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run, %lname%
    }
	}
	if (ErrorLevel == "C") && lname
	{
		if (regaddr = "HKCU")
    {
      RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, %lname%, %lfpath%
      RegDelete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, %lname%
    }
    else if (regaddr = "HKLM")
    {
      RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run, %lname%, %lfpath%
      RegDelete HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, %lname%
    }
    else if (regaddr = "HKLM32")
    {
      RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run, %lname%, %lfpath%
      RegDelete HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run\AutorunsDisabled, %lname%
    }
	}
}
return

setlvdisvalue:
LoadLV_dis_Label := 0
tooltip 可勾选已有项目已进行激活或禁用!
sleep 2000
tooltip
return

SetIcon(auroruncom)
{
  iconpath := PathGetPath(auroruncom)
  GuiControl, , sico, % "*Icon0 *w48 *h48 " iconpath
}

; 从注册表值字符串中提取路径
PathGetPath(pSourceCmd)
{
	local Path, ArgsStartPos = 0
	if (SubStr(pSourceCmd, 1, 1) = """")    ; 以双引号 " 开头
		Path := SubStr(pSourceCmd, 2, InStr(pSourceCmd, """", False, 2) - 2)   ; 从第2个字符开始提取到第二个双引号的位置
	else
	{
		Path = %pSourceCmd%
	}
	return Path
}

ExpandEnvVars(string){
   ; Find length of dest string:
   nSize := DllCall("ExpandEnvironmentStrings", "Str", string, "Str", NULL, "UInt", 0, "UInt")
  ,VarSetCapacity(Dest, size := (nSize * (1 << !!A_IsUnicode)) + !A_IsUnicode) ; allocate dest string
  ,DllCall("ExpandEnvironmentStrings", "Str", string, "Str", Dest, "UInt", size, "UInt") ; fill dest string
   return Dest
}

IndexOfIconResource(Filename, ID)
{
    hmod := DllCall("GetModuleHandle", "str", Filename, "ptr")
    ; If the DLL isn't already loaded, load it as a data file.
    loaded := !hmod
        && hmod := DllCall("LoadLibraryEx", "str", Filename, "ptr", 0, "uint", 0x2, "ptr")
    
    enumproc := RegisterCallback("IndexOfIconResource_EnumIconResources","F")
    param := {ID: ID, index: 0, result: 0}
    
    ; Enumerate the icon group resources. (RT_GROUP_ICON=14)
    DllCall("EnumResourceNames", "ptr", hmod, "ptr", 14, "ptr", enumproc, "ptr", &param)
    DllCall("GlobalFree", "ptr", enumproc)
    
    ; If we loaded the DLL, free it now.
    if loaded
        DllCall("FreeLibrary", "ptr", hmod)
    
    return param.result
}

IndexOfIconResource_EnumIconResources(hModule, lpszType, lpszName, lParam)
{
    param := Object(lParam)
    param.index += 1

    if (lpszName = param.ID)
    {
        param.result := param.index
        return false    ; break
    }
    return true
}