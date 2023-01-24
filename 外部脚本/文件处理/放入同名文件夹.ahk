CandySel := A_Args[1]
; 1039
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