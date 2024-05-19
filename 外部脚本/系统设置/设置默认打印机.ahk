;|2.6|2024.05.16|1602
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=118596&sid=944d4607cbc1f093322a290939bb6f52
#SingleInstance, Force
;===================
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=118596&p=526363#p526363
; For AHK v1 ; By Kunkel321 with help from Garry.
; A tool to allow user to check and/or change default printer.

;!^+p::
menu, tray, icon, shell32.dll,107

guiColor =
fontColor =

Switches =
(
/e 打印首选项
/ge enum per machine printer connections
/k 使用指定的打印机打印测试页面
/o 显示打印机队列
/p 打印机属性
/s 显示服务属性
/y 设置为默认打印机
/Xg 获取打印机设置
/? 帮助
)


; ===== Get default printer name. ======
RegRead, defaultPrinter, HKCU, Software\Microsoft\Windows NT\CurrentVersion\Windows, Device

; ==== Get list of installed printers ======
printerlist =
loop,HKCU,Software\Microsoft\Windows NT\CurrentVersion\devices
	printerlist = %printerlist%%A_loopRegName%`n
printerlist := SubStr(printerlist, 1, strlen(printerlist)-1)
;StringSplit, printerlist, printerlist, `n ; Determines number of lines

;  ==== Put names in GUI ====
Gui, df:Destroy
Gui, df:color, %guiColor%
Gui, df:font, s12 bold c%FontColor%

; ---- put switches in menu ----
Loop, parse, Switches, `n
	Menu,df: Menu1, Add, %A_LoopField%, Label%A_Index%

Gui, df:Add, Text,, 设置默认打印机 ...
Gui, df:font, s10 normal
Gui, df:Add, Text,y+6, [右键打印机名称查看更多命令]
Gui, df:font, s11 normal
Loop, parse, printerlist, `n
	If instr(defaultPrinter, A_LoopField)
		Gui, df:Add, Radio, checked vRadio%a_index%, %a_loopfield%
    Else
		Gui, df:Add, Radio, vRadio%a_index%, %a_loopfield%
Gui, df:Add, Button, default gSet, 设置打印机
Gui, df:Add, Button, x+10 gQue, 打印队列
Gui, df:Add, Button, x+10 gPanel, 设备与打印机
Gui, df:Add, Button, x+10 gstartserv, 启动打印服务
Gui, df:Add, Button, x+10 gdfButtonCancel, 取消
Gui, df:Add, Button, x10 y+10 gstartserv2, 开启防火墙服务(共享打印机的前提条件)
Gui, df:Show, , 默认打印机切换器
Return

Label1:
Label2:
Label3:
Label4:
Label5:
Label6:
Label7:
Label8:
Label9:
Label10:
Label11:
Label12:
Label13:
Label14:
Label15:
Label16:
Label17:
Label18: ; If you have more than 18 'Switches' lines, above, add more labels.
MenuItem := StrReplace(A_ThisLabel, "Label", "")
StringSplit, Switches, Switches, `n
ThisSwitch := Switches%MenuItem%
StringSplit, ThisSwitch, ThisSwitch, " "
ThisSwitch := ThisSwitch1
return

dfGuiContextMenu:
If (A_GuiControl) {
	menu,df: Menu1, Show
	MouseGetPos,,,,Control1
	Loop, parse, printerlist, `n
		If (A_GuiControl = "Radio" A_Index) && (ThisSwitch <> "") {
			runwait, rundll32 printui.dll`, PrintUIEntry "%ThisSwitch%" /n "%A_LoopField%" ; Not sure why the /n has to be there....
			ThisSwitch =
		}
}
return

Set:
	Gui, df:Submit
	Loop, parse, printerlist, `n
		If Radio%a_index% <> 0
			newDefault = %a_loopfield%
	; ==== Set new default printer =====
	RunWait, C:\Windows\System32\RUNDLL32.exe PRINTUI.DLL`, PrintUIEntry /y /n "%newDefault%" ; sets the printer
	Gui, df:Destroy
Return

Que:
	Gui, df:Submit
	Loop, parse, printerlist, `n
		If Radio%a_index% <> 0
			viewThis = %a_loopfield%
	; ==== View print queue for selected =====
	runwait, rundll32 printui.dll`, PrintUIEntry /o /n "%viewThis%"  ;- display printer queue view -User Garry
	Gui, df:Destroy
Return

Panel:
	; run,shell:PrintersFolder   ;- show printers and with rightclick change as default printer -User Garry
	run, control printers       ;- maybe rightclick for problem solution -User Garry
Return

dfGuiEscape:
dfGuiClose:
dfButtonCancel:
	Gui, df:Destroy
	printerlist =
	exitapp
Return

startserv:
ExecSend("Spooler|3",, 985)  ; 打印服务改为手动模式
sleep 500
ExecSend("Spooler|Start",, 985) ; 启动打印服务
return

startserv2:
ExecSend("mpssvc|3",, 985)   ; 
sleep 500
ExecSend("mpssvc|Start",, 985)  ; 开启防火墙服务
return

ExecSend(ByRef StringToSend, Title := "AnyToAhk ahk_class AutoHotkey", wParam := 0, Msg := 0x4a, Idc := "") {
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(Idc, CopyDataStruct, 0)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)

	DetectHiddenWindows, On
	if Title is integer
	{
		SendMessage, Msg, wParam, &CopyDataStruct,, ahk_id %Title%
	}
	else if Title is not integer
	{
		SetTitleMatchMode 2
		SendMessage, Msg, wParam, &CopyDataStruct,, %Title%
	}
	DetectHiddenWindows, Off
	return ErrorLevel
}

/*
; Stuff from User: Garry
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=118596&p=526470#p526470
F1:=a_scriptdir . "\test.txt"
printerA:="SnagIt 2023"
;---------------
runwait,RUNDLL32 PRINTUI.DLL`,PrintUIEntry /f "%f1%" /Xg /n "%printerA%"      ;- show printers specification in file F1
runwait,rundll32 printui.dll`,PrintUIEntry /?                                 ;- Help
runwait,rundll32 printui.dll`,PrintUIEntry /o /n "%printerA%"                 ;- display printer queue view
runwait,rundll32 printui.dll`,PrintUIEntry /p /n "%printerA%"                 ;-  printer properties
try,
  run,%f1%    ;- show printers specification
run,shell:PrintersFolder
run,control printers
return
*/
