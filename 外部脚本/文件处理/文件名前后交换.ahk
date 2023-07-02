;|2.0|2023.07.01|1238
CandySel := A_Args[1]
if !CandySel             ; 多个文件
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}
Loop Parse, CandySel, `n, `r
{
	if A_LoopField
		File_SwapAB(A_LoopField)
}
Return

File_SwapAB(filename, SepStr := "-", Con := " - ")
{
	SplitPath, filename, , CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
	SepArr := StrSplit(SepStr, ",")
	for k,v in SepArr
	{
		Tmp_Arr := StrSplit(CandySel_FileNameNoExt, v)
		if Tmp_Arr[2]
		{
			FileMove, %filename%, % CandySel_ParentPath "\" Trim(Tmp_Arr[2]) Con Trim(Tmp_Arr[1]) "." CandySel_Ext
			break
		}
	}
}