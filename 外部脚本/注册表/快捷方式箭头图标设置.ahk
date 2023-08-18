;|2.0|2023.07.01|1006
;if !CF_RegWrite("REG_SZ", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons", "29", "C:\WINDOWS\system32\imageres.dll,197")
;	msgbox
	; % CF_RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons", "29")

;CF_RegWrite("REG_BINARY", "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", "Link", "00000000")
;CF_RegWrite("REG_BINARY", "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", "Link", "1e000000")

;if !CF_RegWrite("REG_SZ", "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics", "MinWidth", "-70")
;	RestartExplorer()

#SingleInstance force
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\E8AD.ico"
SetRegView, 64
global A_icon := Object("默认", A_WinDir "\System32\imageres.dll,154", "透明", A_WinDir "\System32\imageres.dll,197", "经典", A_WinDir "\System32\shell32.dll,29", "大图标", A_WinDir "\System32\shell32.dll,263")
global Arr_sel := [A_WinDir "\System32\imageres.dll,154", A_WinDir "\System32\imageres.dll,197", A_WinDir "\System32\shell32.dll,29", A_WinDir "\System32\shell32.dll,263"]
global A_icon2 := Object("默认", A_WinDir "\System32\imageres.dll,-163", "透明", A_WinDir "\System32\imageres.dll,-1015", "经典", A_WinDir "\System32\shell32.dll,-30", "大图标", A_WinDir "\System32\shell32.dll,-16769")
global A_iconSt := Object("默认", 0, "透明", 0, "经典", 0, "大图标", 0, "带快捷方式字样", 0)
if !RegKeyExist("Shell Icons")
	A_iconSt["默认"] := 1
else
{
	Alnk_icon := CF_RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons", 29)
	if (Alnk_icon = "")
		A_iconSt["默认"] := 1
	;tooltip % Alnk_icon
	lnk_icon := ExpandEnvVars(Alnk_icon)
	;msgbox % lnk_icon
	Array := StrSplit(Lnk_Icon, ",")
	if (Array[2] < 0)
	{
		Icon_index := IndexOfIconResource(Array[1], abs(Array[2]))
		;msgbox % Icon_index
	}
	else
		Icon_index := Array[2] + 1

	if !A_iconSt["默认"]
	{
	for k,v in A_icon
	{
		if (lnk_icon = v)
		{
			A_iconSt[k] := 1
			break
		}
	}
	for k,v in A_icon2
	{
		if (lnk_icon = v)
		{
			A_iconSt[k] := 1
			break
		}
	}
	}
}

Alnk_text := CF_RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", "link")
if (Alnk_text = "1e000000")
	A_iconSt["带快捷方式字样"] := 0
else if (Alnk_text = "00000000")
	A_iconSt["带快捷方式字样"] := 1


gui, +HwndMyGuiHwnd
Gui, Add, GroupBox, x10 y10 w470 h140, 快捷方式小箭头图标设置(重启桌面生效)
Gui, Add, Radio, % "xp+10 yp+30 w40 h20 vMyRadioGroup gselectedicon Checked" A_iconSt["默认"], 默认
Gui, Add, Radio, % "xp+80 yp w40 h20 gselectedicon Checked" A_iconSt["透明"], 透明
Gui, Add, Radio, % "xp+80 yp w40 h20 gselectedicon Checked" A_iconSt["经典"], 经典
Gui, Add, Radio, % "xp+80 yp w60 h20 gselectedicon Checked" A_iconSt["大图标"], 大图标
Gui, Add, Picture, x60 yp-10 w32 h32, % A_ScriptDir "\..\..\脚本图标\default_shortcut_arrow.ico"
Gui, Add, Picture, xp+80 yp w32 h32, % A_ScriptDir "\..\..\脚本图标\blank.png"
Gui, Add, Picture, xp+85 yp-3 w32 h32, % A_ScriptDir "\..\..\脚本图标\classic_arrow.png"
Gui, Add, Picture, xp+90 yp+3 w32 h32, % A_ScriptDir "\..\..\脚本图标\large_shortcut_arrow.ico"

Gui, Add, text, % "x20 yp+50 w70 h60", 图标路径:
Gui, Add, edit, % "xp+70 yp-2 w350 h25 vvlnk_icon gload_icon", % lnk_icon
Gui, Add, Picture, % "xp+355 yp w32 h32 vPic5 gsel_icon Icon" Icon_index, % Array[1]

Gui, Add, CheckBox, % "x20 yp+40 w120 h20 vvlnk_text Checked" A_iconSt["带快捷方式字样"], 去除快捷方式字样
;Gui, Add, CheckBox, % "xp-150 yp+30 w40 h20 vvmusic Checked" A_iconSt["音乐"], 音乐
;Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvdesktop Checked" A_iconSt["桌面"], 桌面
Gui, Add, Button, x140 y160 w100 h30 gRestartExplorer, 应用并重启桌面
Gui, Add, Button, xp+110 yp w70 h30 gGuiSave, 确定
Gui, Add, Button, xp+80 yp w70 h30 gGuiClose, 取消
Gui, Add, Button, xp+80 yp w70 h30 gGuiApply, 应用
gui, show,, 快捷方式小箭头图标的设置
return

GuiEscape:
GuiClose:
Gui, Destroy
exitapp
return

GuiApply:
gui, submit, nohide
if (vLnk_Icon != ALnk_Icon)
{
	CF_RegWrite("REG_SZ", "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons", "29", vLnk_Icon)
}
if (vlnk_text != A_iconSt["带快捷方式字样"])
{
	A_iconSt["带快捷方式字样"] := vlnk_text
	if vlnk_text
		CF_RegWrite("REG_BINARY", "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", "link", "00000000")
	else
		CF_RegWrite("REG_BINARY", "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer", "link", "1e000000")
}
return

selectedicon:
gui, submit, nohide
;tootlip % Arr_sel[MyRadioGroup]
GuiControl,, vlnk_Icon, % Arr_sel[MyRadioGroup]
return

load_icon:
gui, submit, nohide
Array := StrSplit(vLnk_Icon, ",")
	if (Array[2] < 0)
	{
		Icon_index := IndexOfIconResource(ExpandEnvVars(Array[1]), abs(Array[2]))
		;msgbox % Icon_index
	}
	else
		Icon_index := Array[2] + 1
GuiControl,, pic5, % Array[1] ? "*Icon" Icon_index " " Array[1] : "*Icon0" " " vLnk_Icon
;msgbox % Array[1] ? "*Icon" Array[2]+1 " " Array[1] : "*Icon0" " " Lnk_Icon
return

sel_icon:
gui, submit, nohide
if vlnk_Icon
	Array := StrSplit(vlnk_Icon, ",")
else
	Tmp_val := A_WinDir "\system32\imageres.dll"
icon_path := Array[1] ? Array[1] : Tmp_val
DllCall("Shell32.dll\PickIconDlg", "UInt", MyGuiHwnd, "str", icon_path, "UInt", 260, "IntP", i_Index)
GuiControl,, vlnk_Icon, % icon_path "," i_Index
return

GuiSave:
gosub GuiApply
Gui, Destroy
exitapp

RestartExplorer:
gosub GuiApply
RestartExplorer()
return

CF_RegRead(KeyName, ValueName="")
{
	RegRead, OutputVar, % KeyName, % ValueName
	if ErrorLevel
	Return %A_LastError%
	else
	Return OutputVar
}

CF_RegWrite(ValueType, KeyName, ValueName="", Value="")
{
	RegWrite, % ValueType, % KeyName, % ValueName, % Value
	if ErrorLevel
	Return %A_LastError%
	else
	Return 0
}

CF_RegDelete(KeyName, ValueName := "")
{
	RegDelete, % KeyName, % ValueName
	if ErrorLevel
	Return %A_LastError%
	else
	Return 0
}

RestartExplorer()
{
	run, taskkill /f /im explorer.exe,,hide
	sleep 1000
	run, explorer.exe
}

RegKeyExist(Skey) {
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\"
	Loop, Reg, %APath%, K
	{
		if (A_LoopRegName = Skey)
			return, 1
	}
	return 0
}

ExpandEnvVars(string){
   ; Find length of dest string:
   nSize := DllCall("ExpandEnvironmentStrings", "Str", string, "Str", NULL, "UInt", 0, "UInt")
  ,VarSetCapacity(Dest, size := (nSize * (1 << !!A_IsUnicode)) + !A_IsUnicode) ; allocate dest string
  ,DllCall("ExpandEnvironmentStrings", "Str", string, "Str", Dest, "UInt", size, "UInt") ; fill dest string
   return Dest
}

/*
ExpandEnvVars(ppath)
{
	VarSetCapacity(dest, 2000)
	DllCall("ExpandEnvironmentStrings", "str", ppath, "str", dest, "int", 1999, "Cdecl int")
	Return dest
}
*/

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

GetIconGroupNameByIndex(FilePath, Index, NamePtr := "", Param := "") {
   Static EnumProc := RegisterCallback("GetIconGroupNameByIndex", "F", 4)
   Static EnumCall := A_TickCount
   Static EnumCount := 0
   Static GroupIndex := 0
   Static GroupName := ""
   Static Loaded := 0
   ; ----------------------------------------------------------------------------------------------
   If (Param = EnumCall) { ; called by EnumResourceNames
      EnumCount++
      If (EnumCount = GroupIndex) {
         If ((NamePtr & 0xFFFF) = NamePtr)
            GroupName := NamePtr
         Else
            GroupName := StrGet(NamePtr)
         Return False
      }
      Return True
   }
   ; ----------------------------------------------------------------------------------------------
   EnumCount := 0
   GroupIndex := Index
   GroupName := ""
   Loaded := 0
   If !(HMOD := DllCall("GetModuleHandle", "Str", FilePath, "UPtr")) {
      If (HMOD := DllCall("LoadLibraryEx", "Str", FilePath, "Ptr", 0, "UInt", 0x02, "UPtr"))
         Loaded := HMOD
      Else
         Return ""
   }
   DllCall("EnumResourceNames", "Ptr", HMOD, "Ptr", 14, "Ptr", EnumProc, "Ptr", EnumCall)
   If (Loaded)
      DllCall("FreeLibrary", "Ptr", Loaded)
   Return GroupName
}