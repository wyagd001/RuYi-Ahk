;|2.5|2024.03.20|1564
CandySel :=  A_Args[1]
CandySel2 :=  A_Args[2]
SplitPath, CandySel,, OutDir
CandySel2 := CandySel2 = "" ? "*" : CandySel2
if (CandySel2 = "*")
{
	目标目录 := OutDir "\所有文件"
}
else
{
	目标目录 := OutDir "\" CandySel2
}
FileCreateDir, %目标目录%
Loop, Files, %CandySel%\*.%CandySel2%, R
{
	;if (A_LoopFileDir != "C:\Documents and Settings\Administrator\Desktop\测试")
	FileCopy, %A_LoopFilePath%, %目标目录%
}
return