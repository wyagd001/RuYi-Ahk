CandySel := A_Args[1]
CandySel2 := A_Args[2]
if CandySel2
	goto SendToFolder
;msgbox % CandySel
; 1109
Cando_CopyToOpenedFolder:
AllOpenFolder := GetAllWindowOpenFolder()
Menu SendToOpenedFolder, Add, 发送到打开的文件夹, nul
Menu SendToOpenedFolder, Add
for k, v in AllOpenFolder
{
	Menu SendToOpenedFolder, add, %v%, Cando_SendToFolder
}
Menu SendToOpenedFolder, Show
Menu, SendToOpenedFolder, DeleteAll
return

nul:
return

Cando_SendToFolder:
if !instr(CandySel, "`n")
{
	SplitPath, CandySel, CandySel_FileName
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

SendToFolder:
if !instr(CandySel, "`n")
{
	SplitPath, CandySel, CandySel_FileName
	TargetFile := PathU(CandySel2 "\" CandySel_FileName)
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

GetAllWindowOpenFolder()
{
	if WinActive("ahk_class TTOTAL_CMD")
	return TC_getTwoPath()

	QtTabBarObj := QtTabBar()
	if QtTabBarObj
	{
		OPenedFolder := QtTabBar_GetAllTabs()
	}
	else
	{
		OPenedFolder := []
		ShellWindows := ComObjCreate("Shell.Application").Windows
		for w in ShellWindows
		{
			Tmp_Fp := w.Document.Folder.Self.path
			if (Tmp_Fp)
				if FileExist(Tmp_Fp)
				{
					OPenedFolder.push(Tmp_Fp)
				}
		}
	}
return OPenedFolder
}

TC_getTwoPath()
{
	DetectHiddenText, On
	WinGetText, TCWindowText, Ahk_class TTOTAL_CMD
	m := RegExMatchAll(TCWindowText, "m)(.*)\\\*\.\*", 1)
	return m
}

QtTabBar()
{
	try QtTabBarObj := ComObjCreate("QTTabBarLib.Scripting")
	if IsObject(QtTabBarObj)
	return 1
	else
	return 0
}

QtTabBar_GetAllTabs()
{
	ScriptCode = 
	(
		OPenedFolder_Str := GetAllWindowOpenFolder()
		FileAppend `% OPenedFolder_Str, *

		GetAllWindowOpenFolder()
		{
			OPenedFolder_Str := ""
			QtTabBarObj := ComObjCreate("QTTabBarLib.Scripting")
			if QtTabBarObj
			{
				for k in QtTabBarObj.Windows
					for w in k.Tabs
					{
						Tmp_Fp := w.path
						if (Tmp_Fp)
							if FileExist(Tmp_Fp)
							{
								OPenedFolder_Str .= Tmp_Fp "``n"
							}
					}
			}
		return OPenedFolder_Str
		}
	)

	OPenedFolder_Str := RunScript(ScriptCode, 1)
	OPenedFolder_Str := Trim(OPenedFolder_Str, " `t`n")
	OPenedFolder := StrSplit(OPenedFolder_Str, "`n")
return OPenedFolder
}

RegExMatchAll(ByRef Haystack, NeedleRegEx, SubPat="")
{
	arr := [], startPos := 1
	while ( pos := RegExMatch(Haystack, NeedleRegEx, match, startPos) )
	{
		arr.push(match%SubPat%)
		startPos := pos + StrLen(match)
	}
	return arr.MaxIndex() ? arr : ""
}

RunScript(script, WaitResult:="false")
{
	static test_ahk := A_AhkPath,
	shell := ComObjCreate("WScript.Shell")
	BackUp_WorkingDir:= A_WorkingDir
	SetWorkingDir %A_ScriptDir%
	exec := shell.Exec(chr(34) test_ahk chr(34) " /ErrorStdOut *")
	exec.StdIn.Write(script)
	exec.StdIn.Close()
	SetWorkingDir %BackUp_WorkingDir%
	if WaitResult
		return exec.StdOut.ReadAll()
	else 
return
}

PathU(sFile) {                     ; PathU v0.90 by SKAN on D35E/D35F @ tiny.cc/pathu 
Local Q, F := VarSetCapacity(Q,520,0) 
  DllCall("kernel32\GetFullPathNameW", "WStr",sFile, "UInt",260, "Str",Q, "PtrP",F)
  DllCall("shell32\PathYetAnotherMakeUniqueName","Str",Q, "Str",Q, "Ptr",0, "Ptr",F)
Return A_IsUnicode ? Q : StrGet(&Q, "UTF-16")
}