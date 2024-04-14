;|2.6|2024.04.12|1572
CandySel := A_Args[1]
Windy_CurWin_Id := A_Args[2]
numsub := {1:"₁", 2:"₂", 3:"₃", 4:"₄", 5:"₅", 6:"₆", 7:"₇", 8:"₈", 9:"₉", 0:"₀", "+":"⁺", "-":"⁻", "=":"⁼", "(":"⁽", ")":"⁾", "a":"ₐ", "e":"ₑ", "h":"ₕ", "i":"ᵢ", "j":"ⱼ", "k":"ₖ", "l":"ₗ", "m":"ₘ", "n":"ₙ", "o":"ₒ", "p":"ₚ", "r":"ᵣ", "s":"ₛ", "t":"ₜ", "u":"ᵤ", "v":"ᵥ", "x":"ₓ"}
DetectHiddenWindows, On
if !Windy_CurWin_Id
{
	WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
}

if !CandySel
{
	WinActivate, ahk_id %Windy_CurWin_id%
	send +{Left}
	send ^c
	tmp_str := numsub[Clipboard]
}
else
	tmp_str := numsub[CandySel]
;msgbox % tmp_str
if tmp_str
{
	WinActivate, ahk_id %Windy_CurWin_id%
	sleep 10
	send % tmp_str
}
newStr := CandySel := ""
return