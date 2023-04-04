; 1081
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}
Files_TwoFilesSwapName(CandySel)
Return

Files_TwoFilesSwapName(Filelist)
{
	; 传递的字符串中的换行是回车+换行
	StringReplace, Filelist, Filelist, `r`n, `n
	StringSplit, File_, Filelist, `n
	if File_2
	{
		SplitPath, File_1, , FileDir, , FileNameNoExt
		;msgbox % fileexist(File_1) " - " fileexist(File_2)
		FileMove, %File_1%, %FileDir%\%FileNameNoExt%.tempExt
		FileMove, %File_2%, %File_1%
		FileMove, %FileDir%\%FileNameNoExt%.tempExt, %File_2%
		return
	}
}