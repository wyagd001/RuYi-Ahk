; 1119
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}
;msgbox % CandySel
cando_多文件复制文件名:
Tmp_Val := ""
Loop, Parse, CandySel, `n,`r 
{
	SplitPath, A_LoopField, outfilename
	Tmp_Val .= (Tmp_Val = "" ? "" : "`r`n") outfilename
}
clipboard := Tmp_Val
Tmp_Val := ""
return