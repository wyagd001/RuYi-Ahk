;|2.4|2023.10.31|1532
CandySel := A_Args[1]
Windy_CurWin_Id := A_Args[2]
DetectHiddenWindows, On

if !Windy_CurWin_Id
{
	WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
}

if !CandySel
{
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_
}
DetectHiddenWindows, Off

中英文隔开:
if !CandySel
{
	WinActivate, ahk_id %Windy_CurWin_id%
	Send ^a
	sleep 20
	Send ^x
	sleep 20
	CandySel := Clipboard
}
CandySel := RegExReplace(CandySel, "([\x{4e00}-\x{9fa5}]+)([\x21-\x7f]+)", "$1 $2")
Clipboard := RegExReplace(CandySel, "([\x21-\x7f]+)([\x{4e00}-\x{9fa5}]+)", "$1 $2")
WinActivate, ahk_id %Windy_CurWin_id%
Send ^v
newStr := CandySel := ""
return