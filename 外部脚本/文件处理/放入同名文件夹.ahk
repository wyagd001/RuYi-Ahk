;|2.0|2023.07.01|1039
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}
Loop, Parse, CandySel, `n, `r
{
	FileFullPath := A_LoopField
	SplitPath, FileFullPath, FileName, FilePath, FileExtension, FileNameNoExt
	creatfolder = %FilePath%\%FileNameNoExt%
	IfNotExist %creatfolder%
	{
		FileCreateDir, %creatfolder%
		FileMove, %FileFullPath%, %creatfolder%
	}
	else
	{
		TargetFile = %creatfolder%\%FileName%
		ifExist, %TargetFile%
		{
			ind = 1
			Loop, 100
			{
				TargetFile = %creatfolder%\%FileNameNoExt%_(%ind%).%FileExtension%
				ifExist, %TargetFile%
				{
					ind += 1
					continue
				}
				else
				{
					Run, %comspec% /c move "%FileFullPath%" "%TargetFile%",,hide
					break
				}
			}
		}
		; 无同名文件时，复制文件
		else
		{
			Run, %comspec% /c move "%FileFullPath%" "%TargetFile%",,hide
		}
	}
}
Return