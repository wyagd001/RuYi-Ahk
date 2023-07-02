;|2.0|2023.07.01|1115
CF_RegWrite("REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden", 1)
CF_RegWrite("REG_DWORD", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "ShowSuperHidden", 1)

CF_RegWrite(ValueType, KeyName, ValueName="", Value="")
{
	RegWrite, % ValueType, % KeyName, % ValueName, % Value
	if ErrorLevel
	Return %A_LastError%
	else
	Return 0
}