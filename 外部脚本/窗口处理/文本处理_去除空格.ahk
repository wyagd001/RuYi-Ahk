;|2.4|2023.10.02|1515
CandySel := A_Args[1]
Windy_CurWin_Id := A_Args[2]

if !Windy_CurWin_Id
{
	DetectHiddenWindows, On
	WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
}

if !CandySel
{
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}

去除空格:
if !CandySel
{
	WinActivate, ahk_id %Windy_CurWin_id%
	Send ^a
	sleep 20
	Send ^x
	sleep 20
	CandySel := Clipboard
}
Clipboard := StrReplace(CandySel, A_Space)
WinActivate, ahk_id %Windy_CurWin_id%
Send ^v
newStr := CandySel := ""
return