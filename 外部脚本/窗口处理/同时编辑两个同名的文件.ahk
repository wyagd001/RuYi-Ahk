;|3.0|2025.08.16|1424
#Include <Ruyi>
#Include <OpenedFolder>
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
AllOpenFolder.push(A_Desktop)
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