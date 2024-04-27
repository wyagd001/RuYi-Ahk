;|2.6|2024.04.12|1571
CandySel := A_Args[1]
Windy_CurWin_Id := A_Args[2]
numsup := {1:"¹", 2:"²", 3:"³", 4:"⁴", 5:"⁵", 6:"⁶", 7:"⁷", 8:"⁸", 9:"⁹", 0:"⁰", "+":"⁺", "-":"⁻", "=":"⁼", "(":"⁽", ")":"⁾", "a":"ᵃ", "b":"ᵇ", "c":"ᶜ", "d":"ᵈ", "e":"ᵉ", "f":"ᶠ", "g":"ᵍ", "h":"ʰ", "i":"ⁱ", "j":"ʲ", "k":"ᵏ", "l":"ˡ", "m":"ᵐ", "n":"ⁿ", "o":"ᵒ", "p":"ᵖ", "r":"ʳ", "s":"ˢ", "t":"ᵗ", "u":"ᵘ", "v":"ᵛ", "w":"ʷ", "x":"ˣ", "y":"ʸ", "z":"ᶻ", "一":"㆒", "二":"㆓", "三":"㆔", "四":"㆕", "甲":"㆙", "乙":"㆚", "丙":"㆛", "丁":"㆜", "上":"㆖", "中":"㆗", "下":"㆘"}
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
	tmp_str := numsup[Clipboard]
}
else
	tmp_str := numsup[CandySel]
;msgbox % tmp_str
if tmp_str
{
	WinActivate, ahk_id %Windy_CurWin_id%
	sleep 10
	send % tmp_str
}
tmp_str := CandySel := ""
return