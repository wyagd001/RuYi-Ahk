;|2.3|2023.08.25|1436
CandySel := Trim(A_Args[1])
Cando_ColorPicker:
mCol := A_ScriptDir "\..\..\引用程序\x32\ColorPicker.exe"
if RegExMatch(CandySel, "([a-fA-F\d]){6}", mColV)
{
	mCol := A_ScriptDir "\..\..\引用程序\x32\ColorPicker.exe " . mColV . "ff"
}
else if RegExMatch(CandySel, "\((?P<col1>25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\,(?P<col2>25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\,(?P<col3>25[0-5]|2[0-4]\d|[0-1]\d{2}|[1-9]?\d)\)", mColV){
	mCol := A_ScriptDir "\..\..\引用程序\x32\ColorPicker.exe " . (color_dec2hex(mColV1)color_dec2hex(mColV2)color_dec2hex(mColV3)) . "ff"
}
Run, % mCol
Return

;十进制转换为十六进制的函数，参数为10进制数整数.
color_dec2hex(d)
{
	SetFormat, integer, hex
	h :=d+0
	SetFormat, integer, dec ;恢复至正常的10进制计算习惯
	h := substr(h,3)  ; 去掉十六进制前面的 0x
	h :="0" . h
	h := substr(h,-1)
	return h
}