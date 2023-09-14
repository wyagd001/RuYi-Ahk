;|2.3|2023.09.13|1424
#SingleInstance force
CandySel := A_Args[1]
IniRead, notepad2, %A_ScriptDir%\..\..\配置文件\如一.ini, 其他程序, notepad2, Notepad.exe
if InStr(notepad2, "%A_ScriptDir%")
{
	RY_Dir := Deref("%A_ScriptDir%")
	RY_Dir := SubStr(RY_Dir, 1, InStr(RY_Dir, "\", 0, 0, 2) - 1)
	notepad2 := StrReplace(notepad2, "%A_ScriptDir%", RY_Dir)
}

if (CandySel = "")
	exitapp
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

Run %notepad2% %CandySel%,, UseErrorLevel
if (ErrorLevel = "ERROR")
{
	MsgBox 请检查编辑器路径: %notepad2%
	return
}
Sleep 300
if CandySel2
	Run %notepad2% %CandySel2%
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
	static test_ahk := A_AhkPath
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

Deref(String)
{
    spo := 1
    out := ""
    while (fpo:=RegexMatch(String, "(%(.*?)%)|``(.)", m, spo))
    {
        out .= SubStr(String, spo, fpo-spo)
        spo := fpo + StrLen(m)
        if (m1)
            out .= %m2%
        else switch (m3)
        {
            case "a": out .= "`a"
            case "b": out .= "`b"
            case "f": out .= "`f"
            case "n": out .= "`n"
            case "r": out .= "`r"
            case "t": out .= "`t"
            case "v": out .= "`v"
            default: out .= m3
        }
    }
    return out SubStr(String, spo)
}