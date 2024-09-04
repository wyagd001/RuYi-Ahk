;|2.8|2024.08.31|1663, 1664
#NoEnv
#SingleInstance, force
SetBatchLines, -1
SetWorkingDir %A_ScriptDir%

if !(A_IsAdmin||RegExMatch(DllCall("GetCommandLine", "str"), " /restart(?!\S)"))
{
  try
  {
      if A_IsCompiled
          Run *RunAs "%A_ScriptFullPath%" /restart
      else
          Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
  }
  ExitApp
}
ahk__ := A_Args[1]

if !ahk__
  ahk__ := "ahk"

Var_SetUserFTAexe := GetFullPathName(A_ScriptDir "\..\..\引用程序\x32\SetUserFTA.exe")
Var_Autohotkeyexe :=GetFullPathName(A_ScriptDir "\..\..\引用程序\AutoHotkeyU" 8*A_PtrSize ".exe")
Var_Autohotkey2exe := GetFullPathName(A_ScriptDir "\..\..\引用程序\2.0\AutoHotkey" 8*A_PtrSize ".exe")
AHK_Path := ahk__="ahk"?Var_Autohotkeyexe:Var_Autohotkey2exe
ProgId := "AutoHotkeyScript" . (ahk__="ahk"?"":"." . ahk__)

ireturn := RunCmd(Var_SetUserFTAexe " ." ahk__ " " ProgId)

  RegWrite_("REG_SZ", "HKEY_CLASSES_ROOT\." ahk__,, ProgId)
  RegWrite_("REG_SZ", "HKEY_CLASSES_ROOT\" ProgId "\Shell",, "Open")
  ;RegWrite_("REG_SZ", "HKEY_CLASSES_ROOT\" ProgId "\Shell\Open",, "运行脚本(&O)")
  RegWrite_("REG_SZ", "HKEY_CLASSES_ROOT\" ProgId "\Shell\Open", "Icon", """" AHK_Path """")
  RegWrite_("REG_SZ", "HKEY_CLASSES_ROOT\" ProgId "\Shell\Open\Command",, """" AHK_Path """ ""%1"" %*")
DllCall("shell32\SHChangeNotify", "uint", 0x08000000, "uint", 0, "int", 0, "int", 0) ; SHCNE_ASSOCCHANGED
return

RegRead_(KeyName, ValueName:="")
{
	RegRead, OutputVar, %KeyName% , %ValueName%
	return OutputVar
}
RegWrite_(ValueType, KeyName, ValueName:="", Value:="")
{
	RegWrite, %ValueType%, %KeyName%, %ValueName%, %Value%
	return ErrorLevel
}
RegDelete_(KeyName, ValueName:="")
{
  if !ValueName or (ValueName="\")
  {
    KeyName := KeyName ValueName
    if KeyName in HKEY_LOCAL_MACHINE,HKEY_LOCAL_MACHINE\,HKEY_LOCAL_MACHINE\\,HKLM,HKLM\,HKLM\\,HKEY_CLASSES_ROOT,HKEY_CLASSES_ROOT\,HKEY_CLASSES_ROOT\\,HKCR,HKCR\,HKCR\\,HKEY_CURRENT_USER,HKEY_CURRENT_USER\,HKEY_CURRENT_USER\\,HKCU,HKCU\,HKCU\\
    {
      return
    }
  }
	RegDelete, %KeyName%, %ValueName%
	return ErrorLevel
}

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}

RunCmd(CmdLine, WorkingDir:="", Cp:="CP0") { ; Thanks Sean!  SKAN on D34E @ tiny.cc/runcmd 
  Local P8 := (A_PtrSize=8),  pWorkingDir := (WorkingDir ? &WorkingDir : 0)                                                
  Local SI, PI,  hPipeR:=0, hPipeW:=0, Buff, sOutput:="",  ExitCode:=0,  hProcess, hThread
                   
  DllCall("CreatePipe", "PtrP",hPipeR, "PtrP",hPipeW, "Ptr",0, "UInt",0)
, DllCall("SetHandleInformation", "Ptr",hPipeW, "UInt",1, "UInt",1)
    
  VarSetCapacity(SI, P8? 104:68,0),      NumPut(P8? 104:68, SI)
, NumPut(0x100, SI,  P8? 60:44,"UInt"),  NumPut(hPipeW, SI, P8? 88:60)
, NumPut(hPipeW, SI, P8? 96:64)   

, VarSetCapacity(PI, P8? 24:16)               

  If not DllCall("CreateProcess", "Ptr",0, "Str",CmdLine, "Ptr",0, "UInt",0, "UInt",True
              , "UInt",0x08000000 | DllCall("GetPriorityClass", "Ptr",-1,"UInt"), "UInt",0
              , "Ptr",pWorkingDir, "Ptr",&SI, "Ptr",&PI )  
     Return Format( "{1:}", "" 
          , DllCall("CloseHandle", "Ptr",hPipeW)
          , DllCall("CloseHandle", "Ptr",hPipeR)
          , ErrorLevel := -1 )
  DllCall( "CloseHandle", "Ptr",hPipeW)

, VarSetCapacity(Buff, 4096, 0), nSz:=0   
  While DllCall("ReadFile",  "Ptr",hPipeR, "Ptr",&Buff, "UInt",4094, "PtrP",nSz, "UInt",0)
    sOutput .= StrGet(&Buff, nSz, Cp)

  hProcess := NumGet(PI, 0),  hThread := NumGet(PI,4)
, DllCall("GetExitCodeProcess", "Ptr",hProcess, "PtrP",ExitCode)
, DllCall("CloseHandle", "Ptr",hProcess),    DllCall("CloseHandle", "Ptr",hThread)
, DllCall("CloseHandle", "Ptr",hPipeR),      ErrorLevel := ExitCode  
Return sOutput  
}