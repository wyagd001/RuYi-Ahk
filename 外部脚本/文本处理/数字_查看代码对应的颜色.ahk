;|2.3|2023.08.25|1201
CandySel := Trim(A_Args[1])
Cando_颜色查看:
Gui,66: Default
Gui, Destroy
Gui,+Lastfound +AlwaysOnTop
IfInString, CandySel,`,
{
	IfInString, CandySel, rgb
		RegExMatch(CandySel, "i)rgb\(?(\s*\d+\s*),(\s*\d+\s*),(\s*\d+\s*)\)", m)
	else
		RegExMatch(CandySel, "i)(\s*\d+\s*),(\s*\d+\s*),(\s*\d+\s*)", m)
	SetFormat, Integer, % (BackUp_FmtInt := A_FormatInteger) = "D" ? "H" : BackUp_FmtInt 
	StringReplace, Color_Hex, CandySel, %m%, % RegExReplace(RegExReplace(m1+0 m2+0 m3+0,"0x(.)(?=$|0x)", "0$1"), "0x") 
	SetFormat, Integer, %BackUp_FmtInt%
	Color_RGB := CandySel
}
else
{
	RegExMatch(CandySel, "([a-fA-F\d]){6}", Color_Hex)
	Color_RGB := Hex2RGB(Color_Hex)
	Color_RGB := "RGB(" Color_RGB ")"
}

Gui, add, text, x7, 颜色代码(Hex):
Gui, Add, edit, x+10 w120 vcolor_hex, %Color_Hex%
gui, add, button, x+120 default gchangcolor, Ok
Gui, add, text, x7, 颜色代码(RGB):
Gui, Add, edit, x+10 readonly w120 vColor_RGB, %Color_RGB%
Gui, add, text, x7, 颜色:
Gui, Add, Progress, x+10 c%Color_Hex% w170 h170 vprobar, 100
Gui, Show, w230 h230, 颜色查看
Return

66GuiClose:
66Guiescape:
Gui,66: Destroy
exitapp
Return

changcolor:
Gui,66: Default
Gui Submit, nohide
Color_RGB := Hex2RGB(Color_Hex)
Color_RGB := "RGB(" Color_RGB ")"
GuiControl,, Color_RGB, %Color_RGB%
GuiControl, +c%Color_Hex%, probar
return

Hex2RGB(_hexRGB, _delimiter="")
{
	local color, r, g, b, decimalRGB

	If _delimiter =
		_delimiter = ,
	color += "0x" . _hexRGB
	b := color & 0xFF
	g := (color & 0xFF00) >> 8
	r := (color & 0xFF0000) >> 16
	decimalRGB := r _delimiter g _delimiter b
	Return decimalRGB
}

RGB2Hex(_decimalRGB, _delimiter="")
{
	local weight, color, hexRGB

	If _delimiter =
		_delimiter = ,
	weight = 16
	BackUp_FmtInt := A_FormatInteger
	SetFormat Integer, Hex
	color := 0x1000000
	Loop Parse, _decimalRGB, %_delimiter%
	{
		color += A_LoopField << weight
		weight -= 8
	}
	StringTrimLeft hexRGB, color, 3
	SetFormat Integer, %BackUp_FmtInt%
	Return hexRGB
}