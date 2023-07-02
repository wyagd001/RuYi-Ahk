;|2.0|2023.07.01|1262
#SingleInstance force
B_adb := A_ScriptDir "\..\引用程序\adb.exe"
CandySel := A_Args[1]
gui +hwndGuiID
gui, font, s11, 宋体
gui, add, listbox, x5 y5 vcomm w160 h630 gupdatemode, ADB服务|USB调试|网络调试||电脑端文件|手机端文件|App包管理|控制手机|调试命令|信息获取|其他Android命令
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
gui, show, AutoSize, Adb 命令
OnMessage(0x4a, "Receive_WM_COPYDATA")
return

Receive_WM_COPYDATA(wParam, lParam)
{
	Global CandySel
	ID := NumGet(lParam + 0)
	StringAddress := NumGet(lParam + 2*A_PtrSize)  ; 获取 CopyDataStruct 的 lpData 成员.
	CandySel := StrGet(StringAddress)  ; 从结构中复制字符串.
	if IsLabel(CandySel)
	{
		SetTimer, % CandySel, -200
		return true
	}
	return False
}

updatemode:
GuiControl,, myedit4
Gui Submit, nohide
if (comm = "ADB服务")
{
	commmode("预设命令:",, "enable")
	GuiControl,, myedit1, 启用ADB服务||关闭ADB服务|查看Adb版本
}
else if (comm = "USB调试")
{
	commmode("预设命令:", "参数:", "enable", "enable")
	GuiControl,, myedit1, 查看连接的设备||使用USB连接|指定连接的设备
}
else if (comm = "网络调试")
{
	commmode("预设命令:", "参数:", "enable", "enable")
	GuiControl,, myedit1, 开启网络调试|连接手机||断开连接|无线配对|查看连接的设备
}
else if (comm = "电脑端文件")
{
	commmode("预设命令:", "路径:", "enable", "enable")
	GuiControl,, myedit1, 安装apk到手机||覆盖安装apk|发送文件到手机根目录|
}
else if (comm = "手机端文件")
{
	commmode("预设命令:", "路径:", "enable", "enable")
	GuiControl,, myedit1, 手机端文件到桌面||安装apk
}
else if (comm = "App包管理")
{
	commmode("预设命令:", "包名:", "enable", "enable")
	GuiControl,, myedit1, App列表||启动App|强制停止App|App打开指定网页|禁用App|启用App|卸载App|查看包信息
}
else if (comm = "控制手机")
{
	commmode("预设命令:", "参数:", "enable", "enable")
	GuiControl,, myedit1, 关机||重启|按键|输入字母数字|常用开关|其他设置
}
else if (comm = "调试命令")
{
	commmode("预设命令:", "参数:", "enable", "enable")
	GuiControl,, myedit1, dumpsys||
}
else if (comm = "其他Android命令")
{
	commmode("预设命令:", "参数:", "enable", "enable")
	GuiControl,, myedit1, ls根目录||截图到根目录|ifconfig|cat
}
else if (comm = "信息获取")
{
	commmode("预设命令:", "参数:", "enable", "enable")
	GuiControl,, myedit1, 简单信息获取||
}
gosub updatecomm
return

updatecomm:
Gui Submit, nohide
if (A_GuiControl != "myedit2")
	GuiControl,, myedit2, |
Encode := ""
if (myedit1 = "启用ADB服务")
{
	GuiControl,, myedit3, start-server
}
else if (myedit1 = "关闭ADB服务")
{
	GuiControl,, myedit3, kill-server
}
else if (myedit1 = "查看Adb版本")
{
	GuiControl,, myedit3, version
	Encode := "cp936"
}
else if (myedit1 = "查看连接的设备")
{
	GuiControl,, myedit3, devices
}
else if (myedit1 = "使用USB连接")
{
	GuiControl,, myedit3, usb
}
else if (myedit1 = "指定连接的设备")
{
	GuiControl,, myedit3, -s 
}
else if (myedit1 = "开启网络调试")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, 5555||
		Gui Submit, nohide
	}
	GuiControl,, myedit3, % "tcpip " myedit2
}
else if (myedit1 = "连接手机")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, 192.168.1.109:5555||192.168.1.214:5555
		Gui Submit, nohide
	}
	GuiControl,, myedit3, % "connect " myedit2
}
else if (myedit1 = "断开连接")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, 192.168.1.109:5555||192.168.1.214:5555
		Gui Submit, nohide
	}
	GuiControl,, myedit3, % "disconnect " myedit2
}
else if (myedit1 = "无线配对")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, 192.168.1.109:33565 配对码❤❤❤修改IP和配对码||
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 10)
	GuiControl,, myedit3, % "pair " myedit2
}
else if (myedit1 = "安装apk到手机")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, %A_Desktop%\测试.apk||
		Gui Submit, nohide
	}
	GuiControl,, myedit3, install "%myedit2%"
}
else if (myedit1 = "覆盖安装apk")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, %A_Desktop%\测试.apk||
		Gui Submit, nohide
	}
	GuiControl,, myedit3, install -r "%myedit2%"
}
else if (myedit1 = "发送文件到手机根目录")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, "%A_Desktop%\测试.apk" "/storage/emulated/0/测试.apk"||
		Gui Submit, nohide
	}
	GuiControl,, myedit3, push %myedit2%
}
else if (myedit1 = "手机端文件到桌面")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, "/sdcard/Download/wangzhi.txt" "%A_Desktop%\wangzhi.txt"||"/sdcard/Test.png" "%A_Desktop%\Test.png"
		Gui Submit, nohide
	}
	GuiControl,, myedit3, pull %myedit2%
}
else if (myedit1 = "安装apk")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, "/sdcard/Download/test.apk"||
		Gui Submit, nohide
	}
	GuiControl,, myedit3, shell pm install %myedit2%
}
else if (myedit1 = "App列表")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, ❤❤❤无参数||-f❤❤❤包和Apk文件|-3❤❤❤第三方|-s❤❤❤系统|-i❤❤❤安装来源|-e❤❤❤启用的包|-d❤❤❤禁用的包|-u❤❤❤已安装的和已卸载的包|"tencent"❤❤❤只显示包含关键词的包|
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 10)
	GuiControl,, myedit3, shell pm list package %myedit2%
}
else if (myedit1 = "启动App")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, com.eg.android.AlipayGphone/.AlipayLogin❤❤❤打开支付宝||com.tencent.mm/.ui.LauncherUI❤❤❤打开微信|com.android.settings/.wifi.WifiSettings❤❤❤Wifi设置页面|-n "'com.android.settings/.Settings$AccessibilitySettingsActivity'"❤❤❤无障碍设置页面|-n "'com.android.settings/.Settings$ManageApplicationsActivity'"❤❤❤应用管理|-n "'com.android.settings/.Settings$DevelopmentSettingsActivity'"❤❤❤开发人员选项|-a android.intent.action.CALL tel:10086❤❤❤拨打10086|-a android.intent.action.CALL tel:10010❤❤❤拨打10010
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell am start %myedit2%
}
else if (myedit1 = "强制停止App")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, com.eg.android.AlipayGphone❤❤❤支付宝||com.tencent.mm❤❤❤微信|
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell am force-stop %myedit2%
}
else if (myedit1 = "App打开指定网页")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, com.coolapk.market -d https://www.coolapk.com/apk/com.tencent.mm❤❤❤酷安||tv.danmaku.bili -d https://b23.tv/fZnDR6p❤❤❤B 站如意页面|
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 60)
	GuiControl,, myedit3, shell am start -a android.intent.action.VIEW -p %myedit2%
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
else if (myedit1 = "启用App")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, com.eg.android.AlipayGphone❤❤❤支付宝||com.tencent.mm❤❤❤微信
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell pm enable %myedit2%
}
else if (myedit1 = "卸载App")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, com.dragon.read❤❤❤番茄小说||-k com.dragon.read❤❤❤卸载但保留数据
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell pm uninstall %myedit2%
}
else if (myedit1 = "查看包信息")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, com.eg.android.AlipayGphone❤❤❤支付宝||
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell dumpsys package %myedit2%
}
else if (myedit1 = "关机")
{
	GuiControl,, myedit3, shell reboot -p
}
else if (myedit1 = "重启")
{
	GuiControl,, myedit3, shell reboot
}
else if (myedit1 = "按键")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, 26❤❤❤电源键||82❤❤❤菜单键|24❤❤❤音量+|25❤❤❤音量-|164❤❤❤音乐视频游戏静音|
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell input keyevent %myedit2%
}
else if (myedit1 = "输入字母数字")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, 123456❤❤❤锁屏密码123456||
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell input text %myedit2%
}
else if (myedit1 = "常用开关")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, svc wifi enable❤❤❤打开 WiFi||svc wifi disable❤❤❤关闭 WiFi|svc bluetooth enable❤❤❤打开蓝牙|svc bluetooth disable❤❤❤关闭蓝牙|svc data enable❤❤❤打开移动数据|svc data disable❤❤❤关闭移动数据|svc nfc enable❤❤❤打开 nfc|svc nfc disable❤❤❤关闭 nfc|settings put system accelerometer_rotation 1❤❤❤打开自动旋转|settings put system accelerometer_rotation 0❤❤❤关闭自动旋转|settings put global airplane_mode_on 1❤❤❤打开飞行模式|settings put global airplane_mode_on 0❤❤❤关闭飞行模式||settings put system screen_brightness_mode 1❤❤❤开启自动亮度
|settings put system screen_brightness_mode 0❤❤❤关闭自动亮度|
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell %myedit2%
}
else if (myedit1 = "其他设置")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, get system screen_off_timeout❤❤❤获取休眠时间||put system screen_off_timeout 60000❤❤❤设置休眠时间为1分钟(单位毫秒)|get global wifi_on❤❤❤查询WiFi开关状态|get global bluetooth_on❤❤❤查询蓝牙开关状态|get system screen_brightness_mode❤❤❤查询是否开启自动亮度|get system screen_brightness❤❤❤查询屏幕的亮度|put system screen_brightness 100❤❤❤设置屏幕的亮度为 100|
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell settings %myedit2%
}
else if (myedit1 = "dumpsys")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, window||window displays|battery❤❤❤电池|bluetooth_manager❤❤❤蓝牙|location❤❤❤定位|activity|activity activities|shortcut|cpuinfo|wifi|
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell dumpsys %myedit2%
}
else if (myedit1 = "ls根目录")
{
	GuiControl,, myedit3, shell ls /sdcard
}
else if (myedit1 = "截图到根目录")
{
	GuiControl,, myedit3, shell screencap -p > /sdcard/test.png
}
else if (myedit1 = "ifconfig")
{
	GuiControl,, myedit3, shell ifconfig
}
else if (myedit1 = "cat")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, /proc/cpuinfo❤❤❤CPU||/proc/meminfo❤❤❤内存|/sys/class/net/wlan0/address❤❤❤网络|/sys/class/power_supply/battery/capacity
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell cat %myedit2%
}
else if (myedit1 = "简单信息获取")
{
	if (A_GuiControl != "myedit2")
	{
		GuiControl,, myedit2, wm size❤❤❤分辨率||getprop ro.product.model❤❤❤手机型号|getprop ro.build.version.release❤❤❤Android版本|settings get secure android_id❤❤❤android_id|getprop ro.build.version.sdk❤❤❤SDK 版本|getprop ro.product.brand❤❤❤品牌|getprop ro.product.board❤❤❤处理器型号|uptime❤❤❤开机时间|
		Gui Submit, nohide
	}
	myedit2 := SubStr(myedit2, 1, (pos := InStr(myedit2, "❤❤❤")) ? pos - 1 : 30)
	GuiControl,, myedit3, shell %myedit2%
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
if RegExMatch(myedit3, "^adb\s")
	myedit3 := SubStr(myedit3, 5)
if Encode
{
	comreturnStr := RunCmd(B_adb " " myedit3,, Encode)
	Encode := ""
}
else
	comreturnStr := RunCmd(B_adb " " myedit3,, "CP65001")
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

ADB设备:
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