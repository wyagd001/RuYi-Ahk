;|2.1|2023.07.26|1115
; 管理员权限运行时, 无法修改当前普通用户的配置
CF_RegWrite("REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden", 1)
CF_RegWrite("REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowSuperHidden", 1)
RefreshExplorer()
return

CF_RegWrite(ValueType, KeyName, ValueName="", Value="")
{
	RegWrite, % ValueType, % KeyName, % ValueName, % Value
	if ErrorLevel
	Return %A_LastError%
	else
	Return 0
}

RefreshExplorer()
{ ; by teadrinker on D437 @ tiny.cc/refreshexplorer
	local Windows := ComObjCreate("Shell.Application").Windows
	Windows.Item(ComObject(0x13, 8)).Refresh()
	for Window in Windows
		if (Window.Name != "Internet Explorer")
			Window.Refresh()
}