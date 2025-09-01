;|2.5|2024.03.23|1109
#Include <OpenedFolder>
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}
SplitPath CandySel, CandySel_FileName, CandySel_ParentPath
SplitPath CandySel_ParentPath,, CandySel_YeYePath
CandySel2 := A_Args[2]
if CandySel2
{
	if instr(CandySel2, ",")
		FavFolderArr := StrSplit(CandySel2, ",")
	else
		FavFolderArr := [CandySel2]
}

; 1109
Cando_CopyToOpenedFolder:
AllOpenFolder := GetAllWindowOpenFolder()
Menu SendToOpenedFolder, Add, 发送到打开的文件夹, nul
Menu SendToOpenedFolder, Add
Menu SendToOpenedFolder, add, %CandySel_YeYePath%, Cando_SendToFolder
Menu SendToOpenedFolder, Add
for k, v in AllOpenFolder
{
	if (v = CandySel_ParentPath)
		continue
	Menu SendToOpenedFolder, add, %v%, Cando_SendToFolder
}
if FavFolderArr
{
	Menu SendToOpenedFolder, Add
	for k, v in FavFolderArr
	{
		if (v = CandySel_ParentPath)
			continue
		Menu SendToOpenedFolder, add, %v%, Cando_SendToFolder
	}
}
Menu SendToOpenedFolder, Show
Menu, SendToOpenedFolder, DeleteAll
return

nul:
return

Cando_SendToFolder:
if !instr(CandySel, "`n")   ; 单文件
{
	TargetFile := PathU(A_ThisMenuItem "\" CandySel_FileName)
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
		TargetFile := PathU(A_ThisMenuItem "\" Tmp_FileName)
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