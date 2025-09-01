;|3.0|2025.08.16|1723
#Include <OpenedFolder>
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