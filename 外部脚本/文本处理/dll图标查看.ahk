;|2.3|2023.09.01|1451
#Include <Ruyi>
; %SystemRoot%\system32\shell32.dll,-16769
; %SystemRoot%\System32\imageres.dll,-5203
; %SystemRoot%\system32\wmploc.dll,-730
; %SystemRoot%\system32\shell32.dll,-25
; %SystemRoot%\system32\shell32.dll,25
; %SystemRoot%\system32\shell32.dll,-16802
; C:\WINDOWS\System32\imageres.dll,154   ; 系统中图标从 0 开始, ahk 中图标从 1 开始
                                         ; 所以 系统的 154, ahk 中要 155 才能正确显示
; C:\WINDOWS\System32\imageres.dll,197
; C:\WINDOWS\System32\imageres.dll,198

CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}

GuiText2(1, "Dll 文件图标资源查看", CandySel, "转换",450)

转换:
Gui, GuiText2: Submit, NoHide
if myedit1
{
	Tmp_Arr := StrSplit(myedit1, ",")
	dllfile := Trim(Tmp_Arr[1], " """)
	dllfile := Deref(dllfile)
	if (Tmp_Arr[2] < 0)
		Icon_index := IndexOfIconResource(dllfile, abs(Tmp_Arr[2]))
	else
		Icon_index := Tmp_Arr[2] + 1
	GuiControl,, myedit2, % "*Icon" Icon_index " " dllfile
}
return

;GuiControl,, pic5, % Array[1] ? "*Icon" Icon_index " " Array[1] : "*Icon0" " " vLnk_Icon

GuiText2(Gtext2, Title:="", Gtext1:="", Label:="", w:=300, l:=20)
{
	global myedit1, myedit2, TextGuiHwnd
	Gui,GuiText2: Destroy
	Gui,GuiText2: Default
	Gui, +HwndTextGuiHwnd
	;MsgBox % Gtext1
	if Gtext1
	{
		Gui, Add, Edit, w%w% r%l% -WantReturn vmyedit1
		if Label
		{
			;MsgBox % "Default xp+" w+1 " w100 h1 g" Label
			Gui, Add, Button, % "Default xp+" w+1 " w1 h1 g" Label, 翻译
			Gui, Add, Picture, % "xp+10 w32 h32 vmyedit2"
		}
		else
			Gui, Add, Picture, % "xp+" w+10 " w32 h32 vmyedit2"
		GuiControl,, myedit1, %Gtext1%
	}
	else
	{
		Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit2
	}

	gui, Show, AutoSize, % Title
	return

	GuiText2GuiClose:
	GuiText2Guiescape:
	Gui, GuiText2: Destroy
	ExitApp
	Return
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