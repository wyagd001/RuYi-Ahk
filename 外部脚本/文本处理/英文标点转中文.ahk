;|2.5|2023.11.03|1534
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

英文标点转中文:
if !CandySel
{
	WinActivate, ahk_id %Windy_CurWin_id%
	Send ^a
	sleep 20
	Send ^x
	sleep 20
	CandySel := Clipboard
}

CandySel := StrReplace(CandySel, ", ", "，")
CandySel := StrReplace(CandySel, ". ", "。")
CandySel := StrReplace(CandySel, ": ", "：")
CandySel := StrReplace(CandySel, "! ", "！")
CandySel := StrReplace(CandySel, "? ", "？")
CandySel := StrReplace(CandySel, ",", "，")
CandySel := StrReplace(CandySel, ".", "。")
CandySel := StrReplace(CandySel, ":", "：")
CandySel := StrReplace(CandySel, "!", "！")
CandySel := StrReplace(CandySel, "?", "？")
CandySel := StrReplace(CandySel, "(", "（")
CandySel := StrReplace(CandySel, ")", "）")

Clipboard := CandySel
WinActivate, ahk_id %Windy_CurWin_id%
Send ^v
newStr := CandySel := ""
return