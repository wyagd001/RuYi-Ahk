;|2.0|2023.07.01|1328
pad := ComObjCreate("{75048700-EF1F-11D0-9888-006097DEACF9}", "{F490EB00-1240-11D1-9888-006097DEACF9}")
VarSetCapacity(wFile, 260 * 2)
DllCall(VTable(pad, 4), "Uint", pad, "str", wFile, "Uint", 260, "Uint", 0)	; GetWallpaper
DllCall(VTable(pad, 2), "Uint", pad)
;ObjRelease(pad)
RegRead, pFile, HKEY_CURRENT_USER\Control Panel\Desktop, WallPaper
GuiText("IActiveDesktop: " wFile "`n注册表: " pFile, 壁纸路径, w:=500, l:=5)
return

vtable(ptr, n) {
    return NumGet(NumGet(ptr+0), n*A_PtrSize)  
}

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	exitapp
	Return
}