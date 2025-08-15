;|3.0|2025.08.13|1723
CandySel := A_Args[1]
if !CandySel             ; 多个文件
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}
ATA_settingFile := A_ScriptDir "\..\..\配置文件\如一.ini"
WinMerge := CF_IniRead(ATA_settingFile, "其他程序", "WinMerge")

SplitPath, CandySel, OutFileName,, OutExtension, OutNameNoExt
AllOpenFolder := GetAllWindowOpenFolder()
for k,v in AllOpenFolder
{
	Tmp_Fp := v "\" OutNameNoExt
	Tmp_Fp := StrReplace(Tmp_Fp, "\\", "\")
	if FileExist(Tmp_Fp "*.*")
	{
		if FileExist(Tmp_Fp "." OutExtension) && (Tmp_Fp (OutExtension?".":"") OutExtension != CandySel)
		{
			CandySel2 := Tmp_Fp (OutExtension?".":"") OutExtension
			break
		}
		Loop, Files, % Tmp_Fp "*.*", F
		{
			if InStr(A_LoopFileName, OutNameNoExt) && (A_LoopFileName != OutFileName)
			{
				CandySel2 := v "\" A_LoopFileName
				CandySel2 := StrReplace(Md5FilePath2, "\\", "\")
				break 2
			}
		}
	}
}
AllOpenFolder := ""

if !WinExist("ahk_exe WinMergeU.exe")
{
  if CandySel2
    run "%WinMerge%" "%CandySel%" "%CandySel2%"
  else
    run "%WinMerge%" "%CandySel%"
}
else
{
  if WinExist("ahk_class #32770 ahk_exe WinMergeU.exe")
  {
    WinActivate, ahk_class #32770 ahk_exe WinMergeU.exe
    ControlSetText, edit2, %CandySel%, ahk_class #32770 ahk_exe WinMergeU.exe
    ControlSend, edit3, {Enter}, ahk_class #32770 ahk_exe WinMergeU.exe
    sleep 800
    ControlClick, Edit3, ahk_class #32770 ahk_exe WinMergeU.exe
    ControlSend, , {Enter}, ahk_class #32770 ahk_exe WinMergeU.exe
  }
  else if WinExist("ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe")
  {
    WinActivate, ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe
    ControlSetText, edit2, %CandySel%, ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe
    ControlSend, , {Enter}, ahk_class WinMergeWindowClassW ahk_exe WinMergeU.exe
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