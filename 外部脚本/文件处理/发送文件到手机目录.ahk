;|2.0|2023.07.01|1219
CandySel :=  A_Args[1], phonefolder :=  A_Args[2]
B_adb := A_ScriptDir "\..\..\引用程序\adb.exe"
CmdRes := RunCmd(B_adb " devices")
if !instr(CmdRes, "`t")
{
	InputBox, phoneip, 连接手机, % "请输入要连接的手机的 手机IP:端口号",, 300, 140,,, Locale,, % "192.168.1.109:5555"
	if ErrorLevel
		return
	else
	{
		if !phoneip
			return
		RunCmd(B_adb " connect " phoneip)
		sleep 200
		CmdRes := RunCmd(B_adb " devices")
		if !instr(CmdRes, "`t")
			return
	}
}
SplitPath, CandySel, CandySel_FileName
if !phonefolder
	phonefile := "/storage/emulated/0/" CandySel_FileName
else
	phonefile := StrReplace(phonefolder "/" CandySel_FileName, "//", "/")
CmdRes := RunCmd(B_adb . " push """ . CandySel . """ """ . phonefile . """",, "CP65001")
if instr(CmdRes, "error")
	msgbox % CmdRes
return

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