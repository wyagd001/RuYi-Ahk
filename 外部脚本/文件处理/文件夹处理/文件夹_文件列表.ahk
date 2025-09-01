;|2.8|2023.09.27|1298
#Include <AutoXYWH>
CandySel := A_Args[1]
tmp_Str := ""
if CandySel
{
  Loop, Files, %CandySel%\*.*, FR
  {
    tmp_Str .= A_LoopFileLongPath "`n"
  }
}
GuiText(tmp_Str, "文件列表", 500)
return

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd +Resize
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	ExitApp
	Return

	GuiTextGuiSize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	AutoXYWH("wh", "myedit")
	return
}