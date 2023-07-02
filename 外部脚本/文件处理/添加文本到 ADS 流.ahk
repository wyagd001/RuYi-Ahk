;|2.0|2023.07.01|1304
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}
Loop, Parse, CandySel, `n, `r
{
	FileFullPath := A_LoopField
	Loop_Index := 1
	While FileExist(A_LoopField ":ads" Loop_Index)
	{
		Loop_Index := A_Index + 1
	}
	if !myedit
	{
		GuiEditText("", "请输入要保存到 ADS 的文本")
	}
	While !myedit
	{
		Sleep 500
		if (A_Index > 40)
			ToolTip % "5 秒后程序退出, 请保存."
		if (A_Index > 50)
			break 2
	}
	if myedit
		FileAppend, % myedit, % A_LoopField ":ads" Loop_Index
}
exitapp

GuiEditText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiEditText: Destroy
	Gui,GuiEditText: Default
	Gui, +HwndTextGuiHwnd
	Gui, Add, Edit, Multi w%w% r%l% vmyedit 
	Gui, Add, Button, xs gGuiEditTextSave, 保存
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiEditTextGuiClose:
	GuiEditTextGuiescape:
	Gui, GuiEditText: Destroy
	exitapp

	GuiEditTextSave:
	Gui,GuiEditText: Submit
	Return
}