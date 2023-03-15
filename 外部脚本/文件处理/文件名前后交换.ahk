; 1081
CandySel := A_Args[1]
Loop Parse, CandySel, `n, `r
	File_SwapAB(A_LoopField)
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