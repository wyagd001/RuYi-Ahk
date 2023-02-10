CandySel := Trim(A_Args[1])
Cando_十进制十六进制转换:
	Gui, 66: Default
	Gui, Destroy

	Gui, add, text, x10 y10 , 十进制:
	Gui, add, Edit, xp+60 yp-3 w150 h20 vNumDec, 
	Gui, add, text, xp+160 yp+3, 十六进制:
	Gui, add, Edit, xp+70 yp-3 w150 h20 vNumHex,
	Gui, add, button, xp+160 yp w60 h20 gNumUptoDown, 转换

	Gui, add, text, x10 yp+40, 十六进制:
	Gui, add, Edit, xp+60 yp-3 w150 h20 vDectoHex,
	Gui, add, text, xp+160 yp+3, 十进制:
	Gui, add, Edit, xp+70 yp-3 w150 h20 vHextoDec,
	;Gui, add, button, xp+160 yp w60 h20  gNumSwap, 交换数字
	Gosub, NumCon
	;Gui,add,button,x380 y65 w60 h20  gNumHextoDec,10 进制

	Gui, show,, 十进制十六进制转换
Return

66GuiClose:
66Guiescape:
Gui,66: Destroy
exitapp
Return

NumCon:
Gui, 66: Default
	If CandySel Is digit
	{
		GuiControl,, NumDec, % CandySel
		Tmp_Value := dec2hex(CandySel)
		GuiControl,, DectoHex, % Tmp_Value
	}
	If CandySel Is Xdigit
	{
		numtemp := InStr(CandySel, "0x") ? CandySel : "0x" CandySel
		GuiControl, , NumHex, % numtemp
		Tmp_Value := hex2dec(numtemp)
		GuiControl, , HextoDec, % Tmp_Value
	}
Return

NumUptoDown:
Gui, 66: Default
Gui, Submit, NoHide
Tmp_Value := dec2hex(Trim(NumDec))
GuiControl,, DectoHex, % Tmp_Value
numtemp := InStr(NumHex, "0x") ? NumHex : "0x" NumHex
Tmp_Value := hex2dec(numtemp)
GuiControl,, HextoDec, % Tmp_Value
return

NumSwap:
	Gui, Submit, NoHide
	GuiControl, , NumDec, % NumHex
	GuiControl, , NumHex, % NumDec
Return

hex2dec(h)
{
	BackUp_FmtInt := A_FormatInteger
	SetFormat, integer, dec
	d := h+0
	SetFormat, IntegerFast, %BackUp_FmtInt% 
return d
} 

dec2hex(d)
{
	BackUp_FmtInt := A_FormatInteger
	SetFormat, integer, H
	h := d+0
	SetFormat, IntegerFast, %BackUp_FmtInt%
return h
}