;|2.1|2023.07.16|1xxx
#SingleInstance force
;CandySel := A_Args[1]
CandySel := "ipconfig /all"
gui +hwndGuiID
gui, font, s11, 宋体
gui, add, listbox, x5 y5 vcomm w160 h630 gupdatemode, 系统信息||USB调试|
gui, add, Text, x170 yp w140 vmyparam1, 参数1:
gui, add, ComboBox, xp+140 yp w450 vmyedit1 gupdatecomm, 
gui, add, Text, xp-140 yp+40 w140 vmyparam2, 参数2:
gui, add, ComboBox, xp+140 yp w450 vmyedit2 hwndhcb gupdatecomm,
;PostMessage, 0x153, 0, 40,, ahk_id %hcb%
;PostMessage, 0x153, -1, 50,, ahk_id %hcb% 
gui, add, Text, xp-140 yp+40 w140 vmyparam3, 执行的命令:
gui, add, Edit, xp+140 yp w450 r2 -WantReturn vmyedit3,
gui, add, Button, xp+470 yp w60 gruncomm default, 运行
gui, add, Edit, x175 yp+45 w585 h500 vmyedit4,
gui, add, Button, xp+600 yp w100 gruncommincmd, 使用终端打开
gosub updatemode
gui, show, AutoSize, Cmd 命令
if CandySel
	gosub pramrun
return

updatemode:
GuiControl,, myedit4
Gui Submit, nohide
if (comm = "系统信息")
{
	commmode("预设命令:",, "enable")
	GuiControl,, myedit1, 系统信息||ipconfig
}
else if (comm = "USB调试")
{
	commmode("预设命令:", "参数:", "enable", "enable")
	GuiControl,, myedit1, 查看连接的设备||使用USB连接|指定连接的设备
}
gosub updatecomm
return

updatecomm:
Gui Submit, nohide
if (A_GuiControl != "myedit2")
	GuiControl,, myedit2, |
Encode := ""
if (myedit1 = "系统信息")
{
	GuiControl,, myedit3, systeminfo
}
if (myedit1 = "ipconfig")
{
	GuiControl,, myedit3, ipconfig /all
}
if (myedit1 = "已安装的驱动")
{
	GuiControl,, myedit3, driverquery
}



else if (myedit1 = "禁用App")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, com.eg.android.AlipayGphone❤❤❤支付宝||com.tencent.mm❤❤❤微信
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell pm disable-user %myedit2%
}
return


commmode(p1:="参数1:", p2:="参数2:", st1:="Disable", st2:="Disable")
{
	GuiControl,, myparam1, % p1
	GuiControl,, myparam2, % p2
	GuiControl,, myedit1, |
	GuiControl,, myedit2, |
	GuiControl, % st1, myedit1
	GuiControl, % st2, myedit2
}

runcomm:
Gui Submit, nohide
GuiControl,, myedit4
if Encode
{
	comreturnStr := RunCmd(myedit3,, Encode)
	Encode := ""
}
else
	comreturnStr := RunCmd(myedit3)
GuiControl,, myedit4, % comreturnStr
return

pramrun:
comreturnStr := RunCmd(CandySel)
GuiControl,, myedit3, % CandySel
GuiControl,, myedit4, % comreturnStr
return

runcommincmd:
Gui Submit, nohide
if RegExMatch(myedit3, "^adb\s")
	myedit3 := SubStr(myedit3, 5)

Run %comSpec% /k adb %myedit3%, %A_ScriptDir%\..\引用程序
Return

Guiescape:
guiclose:
exitapp

ADB服务:
myedit1 := SubStr(myedit1, 1, (pos := InStr(myedit1, "❤❤❤")) ? pos - 1 : 10)
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