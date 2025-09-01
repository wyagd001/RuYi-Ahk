;|2.0|2023.07.01|1044
#Include <File_GetEncoding>
#Include <File_CpTransform>
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
	MultiF := InStr(CandySel, "`r")
	if MultiF
	{
		CandySel_org := CandySel
		CandySel := SubStr(CandySel, 1, MultiF - 1)   ;  第一行的文件
	}
}
aInCp := File_GetEncoding(CandySel)
SplitPath, CandySel, CandySel_FileName, , , , CandySel_Drive
vvaluetocp := {"ANSI(中文简体)": "CP936", "UTF-8 BOM": "UTF-8", "UTF-8 Raw": "UTF-8-Raw", "Unicode": "UTF-16","Unicode 高位在前": "cp1201", "ANSI(日文)": "CP932", "ANSI(韩文)": "CP949", "ANSI(拉丁语 1)": "CP1252"}
cptovvalue := {"CP936": "ANSI(中文简体)", "UTF-8": "UTF-8 BOM", "UTF-8-Raw": "UTF-8 Raw", "UTF-16": "Unicode", "cp1201": "Unicode 高位在前"}

gui add, text, x5 y5, 原编码:
gui add, ComboBox, xp+50 yp-3 w110 vvaInCp, ANSI|UTF-8 Raw|UTF-8 BOM|Unicode|Unicode 高位在前|ANSI(日文)|ANSI(韩文)|ANSI(拉丁语 1)
gui add, text, xp+120 y5, 新编码:
gui add, ComboBox, xp+50 yp-3 w100 vvOutCp, ANSI|UTF-8 Raw|UTF-8 BOM|Unicode|Unicode 高位在前
gui add, Button, xp+120 h25 gchange, 转换
Gui, Add, Radio, xs h20 vMyRadioGroup Checked, 新建文件, 并保留原文件
Gui, Add, Radio, xs h20, 文件名不变并删除原文件
GuiControl, ChooseString, vaInCp, % cptovvalue[aInCp]
if MultiF
	TC = 批量
else
	TC = %CandySel_Drive%\...\%CandySel_FileName%
gui show,, 文件 %TC% 转码
return

change:
Gui, submit, nohide
if instr(vaInCp, "Cp")
	F_vaInCp := vaInCp
else
	F_vaInCp := vvaluetocp[vaInCp]
if (MyRadioGroup = 1)
{
	loop, parse, CandySel_org, `n, `r
	{
		if A_LoopField
			File_CpTransform(A_LoopField, F_vaInCp, vvaluetocp[vOutCp])
	}
}
else if if (MyRadioGroup = 2)
{
	loop, parse, CandySel_org, `n, `r
	{
		if A_LoopField
			File_CpTransform(A_LoopField, F_vaInCp, vvaluetocp[vOutCp], 0)
	}
}
return

GuiClose:
GuiEscape:
Gui, Destroy
exitapp
return