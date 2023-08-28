;|2.0|2023.07.01|1249,1250
CandySel :=  A_Args[1]
CandySel2 :=  A_Args[2]
if (StrLen(CandySel) < 4)
	Return
if CandySel2
	CopyDirStructure(CandySel, 1)
else
	CopyDirStructure(CandySel)
Return

CopyDirStructure(_inpath, blankfile := 0)
{
	if !CF_IsFolder(_inpath)
		Return
	SplitPath, _inpath, _inpath_FileName, _inpath_ParentPath
	_outpath := _inpath_ParentPath "\" _inpath_FileName "(目录结构)"
	_outpath := PathU(_outpath)
	Loop, Files, %_inpath%\*.*, DR
	{
		StringReplace, _temp, A_LoopFileLongPath, %_inpath%\,, All
		FileCreateDir, %_outpath%\%_temp%
		If errorlevel
			_problem = 1
	}
	if blankfile
	{
		Loop, Files, %_inpath%\*.*, FR
		{
			StringReplace, _temp, A_LoopFileLongPath, %_inpath%\,, All
			FileAppend,, %_outpath%\%_temp%
		}
	}
	Return _problem
}

CF_IsFolder(sfile){
	if InStr(FileExist(sfile), "D")
	|| (sfile = """::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
	|| (SubStr(sfile, 1, 2) = "\\")
		return 1
	else
		return 0
}

PathU(Filename) { ;  PathU v0.91 by SKAN on D35E/D68M @ tiny.cc/pathu
Local OutFile
  VarSetCapacity(OutFile, 520)
  DllCall("Kernel32\GetFullPathNameW", "WStr",Filename, "UInt",260, "Str",OutFile, "Ptr",0)
  DllCall("Shell32\PathYetAnotherMakeUniqueName", "Str",OutFile, "Str",Outfile, "Ptr",0, "Ptr",0)
Return A_IsUnicode ? OutFile : StrGet(&OutFile, "UTF-16")
}