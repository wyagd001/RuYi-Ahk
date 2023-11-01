;|2.4|2023.09.20|1505
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

去除空白行:
if !CandySel
{
	WinActivate, ahk_id %Windy_CurWin_id%
	Send ^a
	sleep 20
	Send ^x
	sleep 20
	CandySel := Clipboard
}
newStr := ""
Loop, Parse, CandySel, `n, `r
{
	if A_LoopField or (StrLen(A_LoopField) != 0)
		newStr .= A_LoopField "`r`n"
}
Clipboard := newStr
WinActivate, ahk_id %Windy_CurWin_id%
Send ^v
newStr := CandySel := ""
return