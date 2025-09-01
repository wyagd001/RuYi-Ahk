;|2.0|2023.07.01|1299
#Include <AutoXYWH>
CandySel := A_Args[1]

tmp_Str := FileList := ""
Loop, Files, %CandySel%\*.*, FR  ; 包含文件
    tmp_Str .= A_LoopFileTimeCreated "`t" A_LoopFileLongPath "`n"
Sort, tmp_Str, R  ; 根据日期排序, 最新的在前面.
Loop, Parse, tmp_Str, `n
{
    if (A_LoopField = "")  ; 忽略列表末尾的最后一个换行符(空项).
        continue
    StringSplit, FileItem, A_LoopField, %A_Tab%  ; 用 tab 作为分隔符将其分为两部分.
    FileList .= FileItem2 "`n"
}
GuiText(FileList, "文件列表", 500)
tmp_Str := FileList := ""
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
	exitapp
	Return

	GuiTextGuiSize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	AutoXYWH("wh", "myedit")
	return
}