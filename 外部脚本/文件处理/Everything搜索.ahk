;|2.8|2024.08.31|1667
#NoEnv
#SingleInstance, force
SetBatchLines, -1
CandySel := A_Args[1]

If (Fileexist(CandySel) && RegExMatch(CandySel, "^(\\\\|.:\\)"))
{
  SplitPath, CandySel,,,, CandySel_FileNameNoExt
  CandySel := CandySel_FileNameNoExt
}

ATA_settingFile := A_ScriptDir "\..\..\配置文件\如一.ini"
Everything32 := CF_IniRead(ATA_settingFile, "其他程序", "Everything32")
Everything64 := CF_IniRead(ATA_settingFile, "其他程序", "Everything64")
Everything := (A_PtrSize = 8)?Everything64:Everything32
if !WinExist("ahk_class EVERYTHING")
{
  Run % Everything
  WinWait, ahk_class EVERYTHING
  ControlSetText, Edit1, %CandySel%, ahk_class EVERYTHING
}
else
{
  WinActivate ahk_class EVERYTHING
  ControlSetText, Edit1, %CandySel%, ahk_class EVERYTHING
}
Send {Enter}
Return