;|3.0|2025.09.03|1735
Windy_CurWin_Pid := A_Args[1]

;Process, Exist, SOGOUSmartAssistant.exe
;pid := ErrorLevel

for proc in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where ProcessId=" . Windy_CurWin_Pid)
  procexepath := proc.ExecutablePath
if !Instr(procexepath, "\Windows\")
{
  Process, Close, % Windy_CurWin_Pid
  FileMove, %procexepath%, %procexepath%.bak
}