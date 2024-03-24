;|2.5|2024.03.23|1566
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}
CandySel2 := A_Args[2]
if !InStr(FileExist(CandySel2), "D")
	CandySel2 := A_desktop

SendToFolder:
if !instr(CandySel, "`n")
{
	SplitPath, CandySel, FileName
	TargetFile := PathU(CandySel2 "\" FileName)
	if GetKeyState("Shift")
		FileMove %CandySel%, %TargetFile%
	else
		FileCopy %CandySel%, %TargetFile%
}
else
{
	Loop, Parse, CandySel, `n,`r
	{
		SplitPath, A_LoopField, Tmp_FileName
		TargetFile := PathU(CandySel2 "\" Tmp_FileName)
		if GetKeyState("Shift")
			FileMove %A_LoopField%, %TargetFile%
		else
			FileCopy %A_LoopField%, %TargetFile%
	}
}
Return

PathU(Filename) { ;  PathU v0.91 by SKAN on D35E/D68M @ tiny.cc/pathu
Local OutFile
  VarSetCapacity(OutFile, 520)
  DllCall("Kernel32\GetFullPathNameW", "WStr",Filename, "UInt",260, "Str",OutFile, "Ptr",0)
  DllCall("Shell32\PathYetAnotherMakeUniqueName", "Str",OutFile, "Str",Outfile, "Ptr",0, "Ptr",0)
Return A_IsUnicode ? OutFile : StrGet(&OutFile, "UTF-16")
}