;|2.6|2024.05.18|1603
CandySel := A_Args[1]
RegRead, OutValue, HKCU\Software\Classes\CLSID\{86CA1AA0-34AA-4E8B-A509-50C905BAE2A2}\InprocServer32

if (OutValue = "") && ErrorLevel   ; 值不存在，正在使用新式菜单
{
	if (CandySel = "") or (CandySel = "旧") or (CandySel = "Win10")
	{
		regwrite, reg_sz, HKCU\Software\Classes\CLSID\{86CA1AA0-34AA-4E8B-A509-50C905BAE2A2}\InprocServer32
		msgbox, 3, 应用设置, 将右键菜单改为旧式样式. 点击是将重启资源管理器使设置生效.`n点击否或取消下次重启计算机后生效.
		IfMsgBox Yes
			CF_restartexplorer()
	}
}
else if (OutValue = "") && !ErrorLevel ; 值存在，正在使用旧式菜单
{
	if (CandySel = "") or (CandySel = "新") or (CandySel = "Win11")
	{
		RegDelete, HKCU\Software\Classes\CLSID\{86CA1AA0-34AA-4E8B-A509-50C905BAE2A2}
		msgbox, 3, 应用设置, 将右键菜单改为新式样式. 点击是将重启资源管理器使设置生效.`n点击否或取消下次重启计算机后生效.
		IfMsgBox Yes
			CF_restartexplorer()
	}
}
return

CF_restartexplorer(){
	PostMessage, 0x5B4, 0, 0,, ahk_class Shell_TrayWnd ; WM_USER+436
	loop, 20
	{
		Process, Exist, explorer.exe
		if ErrorLevel
		{
			Process, Close, explorer.exe
			sleep 100
		}
		else
			break
	}
	run, %A_WinDir%\explorer.exe
}
