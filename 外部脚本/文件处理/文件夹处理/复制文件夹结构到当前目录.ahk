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

PathU(sFile) {                     ; PathU v0.90 by SKAN on D35E/D35F @ tiny.cc/pathu 
Local Q, F := VarSetCapacity(Q,520,0) 
  DllCall("kernel32\GetFullPathNameW", "WStr",sFile, "UInt",260, "Str",Q, "PtrP",F)
  DllCall("shell32\PathYetAnotherMakeUniqueName","Str",Q, "Str",Q, "Ptr",0, "Ptr",F)
Return A_IsUnicode ? Q : StrGet(&Q, "UTF-16")
}