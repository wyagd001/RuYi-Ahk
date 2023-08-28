;|2.0|2023.07.01|1004
#SingleInstance force
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\E7AC.ico"
if fileexist(A_ScriptDir "\..\临时目录")
	tmp_folder := A_ScriptDir "\..\临时目录"
else if fileexist(A_ScriptDir "\..\..\临时目录")
	tmp_folder := A_ScriptDir "\..\..\临时目录"
else
	tmp_folder := A_ScriptDir

stitem := "txt||jpg|bmp|png|doc|xls|docx|xlsx|md|mp3|mp4|bat|reg|htm|html|lrc|ahk|ahk2|wma|rar|zip|7z|pdf|xml"

ExtOpenAndIconGui:
Gui, Destroy
Gui, Default 
gui, +HwndMyGuiHwnd

Gui, Add, GroupBox, x15 y10 w530 h55, 扩展名
Gui, Add, Text, xp+10 yp+15 w65 h30 +0x200, 扩展名:
Gui, Add, ComBoBox, xp+120 yp+2 w350 h120 vext gloadext, % stitem
Gui, Add, button, xp+355 yp w30 h25 gloadext, 载入

Gui, Add, GroupBox, x15 y70 w530 h250, 编辑
Gui, Add, Text, xp+10 yp+15 w65 h30 +0x200, 类:
Gui, Add, Edit, xp+120 yp+2 w350 h25 ReadOnly vext_class,
Gui, Add, Text, xp-120 yp+35 w65 h30 +0x200, 打开方式:
Gui, Add, Edit, xp+120 yp+2 w350 h25 ReadOnly  vext_open,
Gui, Add, button, xp+355 yp w30 h25 gopenwith, 更改
Gui, Add, Text, x25 yp+35 w65 h30 +0x200, 图标:
Gui, Add, Edit, xp+120 yp+2 w350 h25 vext_Icon gload_icon,
Gui, Add, Picture, xp+355 yp w32 h32 vPic gsel_icon, 
Gui, Add, Text, x25 yp+45 w130 h32, 新建菜单下菜单名:
Gui, Add, Edit, xp+120 yp-2 w350 h25 vext_newmenuname,
Gui, Add, Text, x25 yp+45 w130 h32, 新建菜单名(优先):
Gui, Add, Edit, xp+120 yp-2 w350 h25 vext_nmn,
Gui, Add, Edit, xp yp+35 w350 h25 ReadOnly vext_nmn2,

Gui, Add, Button, xp+250 yp+60 w70 h30 gGuiClose, 取消
Gui, Add, Button, xp+80 yp w70 h30 gSave, 保存
;Gui, Add, Button, x620 y25 w40 h30 vStartMGHZ gDelLnkFileFB, 删除
;Gui, Add, Button, xp yp+35 w40 h30  gReNameLnkFile, 修改

SetGuiValue(".txt")
Gui, Show, w560 h380, 文件扩展名设置
Return

loadext:
gui, submit, nohide
SetGuiValue(instr(ext,".") ? ext : "." ext)
return

load_icon:
gui, submit, nohide
Array := StrSplit(ext_Icon, ",")
;tooltip % (Array[1]) ? "*Icon" IndexOfIconResource(ExpandEnvVars(Array[1]), abs(Array[2])) " " ExpandEnvVars(Array[1]) : "*Icon1" ext_Icon
GuiControl,, pic, % (Array[1]) ? "*Icon" IndexOfIconResource(ExpandEnvVars(Array[1]), abs(Array[2])) " " ExpandEnvVars(Array[1]) : "*Icon1" ext_Icon
return

sel_icon:
gui, submit, nohide
Array := StrSplit(ext_Icon, ",")
DllCall("Shell32.dll\PickIconDlg", "UInt", MyGuiHwnd, "str", Array[1], "UInt", 260, "IntP", Index)
i_Index := GetIconGroupNameByIndex(ExpandEnvVars(Array[1]), Index+1)
;tooltip % (Array[1] "," Index+1 "," i_Index)
GuiControl,, ext_Icon, % Array[1] ",-" i_Index
return

openwith:
gui, submit, nohide
;run rundll32.exe shell32.dll`,OpenAs_RunDLL c:\1.%ext%
fileappend,, %tmp_folder%\1.%ext%
sleep 300
run properties %tmp_folder%\1.%ext%
sleep 300
WinActivate 1.%ext% 属性 ahk_class #32770
send c
sleep 300 
loop
{
Process, Exist, OpenWith.exe
tooltip % ErrorLevel
if ErrorLevel
	sleep 100
else
 {
WinClose, 1.%ext% 属性 ahk_class #32770
gosub loadext
break
}
}
return

save:
gui, submit, nohide
CF_RegWrite("REG_EXPAND_SZ", "HKEY_CLASSES_ROOT\" ext_class "\DefaultIcon",, ext_Icon)
CF_RegWrite("REG_SZ", "HKEY_CLASSES_ROOT\" ext_class,, ext_newmenuname)
if ext_nmn
	CF_RegWrite("REG_SZ", "HKEY_CLASSES_ROOT\" ext_class, "FriendlyTypeName", ext_nmn)
return

GuiEscape:
GuiClose:
MGA_CNameList:=""
StartMGHZ:=0
Gui, Destroy
exitapp
return

SetGuiValue(ext)
{
ext_class := readextclass(ext)
if !ext_class
return
GuiControl,, ext_class, % ext_class
ext_open := readextclassopen(ext_class)
GuiControl,, ext_open, % ext_open
if ExistShellNew(ext)
{
	ext_newmenuname := readnewmenuname(ext, ext_nmn)
	GuiControl,, ext_newmenuname, % ext_newmenuname
	GuiControl,, ext_nmn, % ext_nmn
	if ext_nmn && instr(ext_nmn, ",")
	{
		Array := StrSplit(ext_nmn, ",")
		tmp_val := trim(Array[1],"@")
		ext_nmn2 := TranslateMUI(ExpandEnvVars(tmp_val), abs(Array[2]))
		GuiControl,, ext_nmn2, % ext_nmn2
	}
	else
		GuiControl,, ext_nmn2
}
else
	GuiControl,, ext_newmenuname, 新建菜单没有该项目
ext_icon := readextclassicon(ext_class)
if !ext_icon
{
	FoundPos := InStr(ext_open, """ ")
	NewStr := SubStr(ext_open, 1, FoundPos)
	NewStr := Trim(NewStr, """ ")
	ext_icon := NewStr
}
GuiControl, , ext_icon, % ext_icon
Array := StrSplit(ext_Icon, ",")
;tooltip % (Array[1]) ? "*Icon" (IndexOfIconResource(ExpandEnvVars(Array[1]), abs(Array[2]))-1) " " Array[1]  : "*Icon1" ext_Icon
GuiControl,, pic, % (Array[1]) ? "*Icon" IndexOfIconResource(ExpandEnvVars(Array[1]), abs(Array[2])) " " Array[1]  : "*Icon1" ext_Icon
}

readextclass(ext)
{
	RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\%ext%\UserChoice, progid
	;if !OutputVar
	;	RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Classes\%ext%
	if !OutputVar
		RegRead, OutputVar, HKEY_CLASSES_ROOT\%ext%
return OutputVar
}

readextclassopen(class)
{
	;RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Classes\%class%\shell\open\command
	;if !OutputVar
	RegRead, OutputVar, HKEY_CLASSES_ROOT\%class%\shell\open\command
	return OutputVar
}

CF_RegWrite(ValueType, KeyName, ValueName="", Value="")
{
	RegWrite, % ValueType, % KeyName, % ValueName, % Value
	if ErrorLevel
	Return %A_LastError%
	else
	Return 0
}

readnewmenuname(ext, ByRef nmn)
{
	RegRead, Tmp_val, HKEY_CLASSES_ROOT\%ext%,
	tooltip % OutputVar
	RegRead, nmn, HKEY_CLASSES_ROOT\%Tmp_val%, FriendlyTypeName

	;RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Classes\%class%
	;if !OutputVar
	RegRead, OutputVar, HKEY_CLASSES_ROOT\%Tmp_val%
	return OutputVar
}

readextclassicon(class)
{
	;RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Classes\%class%\DefaultIcon
	;f !OutputVar
	RegRead, OutputVar, HKEY_CLASSES_ROOT\%class%\DefaultIcon
	return OutputVar
}

ExpandEnvVars(ppath)
{
	VarSetCapacity(dest, 2000)
	DllCall("ExpandEnvironmentStrings", "str", ppath, "str", dest, "int", 1999, "Cdecl int")
	Return dest
}

/*
ExistShellNew(ext) {
	APath := "HKEY_CLASSES_ROOT\" ext
	Loop, Reg, %APath%, K
	{
		if (A_LoopRegName = "ShellNew")
			return, 1
	}
	return 0
}
*/
ExistShellNew(ext) {
	RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Discardable\PostSetup\ShellNew, Classes
	if instr(OutputVar, ext)
	return, 1
	else
	return 0
}

TranslateMUI(resDll, resID)
{
VarSetCapacity(buf, 256)
hDll := DllCall("LoadLibrary", "str", resDll, "Ptr")
Result := DllCall("LoadString", "uint", hDll, "uint", resID, "uint", &buf, "int", 128)
VarSetCapacity(buf, -1)
Return buf
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