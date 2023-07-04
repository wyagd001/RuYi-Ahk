;|2.0|2023.07.01|1339
#SingleInstance force
#Include  %A_AhkPath%\..\lib\ImagePut.ahk
CandySel := A_Args[1]

newStr := ImagePutBase64(CandySel)
GuiText(newStr, "图片文件转为 Base64 码", 420)
Return

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
	ExitApp
	Return
}