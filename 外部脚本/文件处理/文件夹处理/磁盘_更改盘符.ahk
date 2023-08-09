;|2.2|2023.07.01|1174
CandySel := A_Args[1]
msgbox % CandySel
CandySel := trim(CandySel, """")

Gui,66: Destroy
Gui,66: Default
gui add, text, x5 y5, 原盘符:
gui add, ComboBox, xp+50 yp-3 w110 vvaInCp, C:|D:|E:|F:|G:|H:|I:|J:|K:|L:|M:|N:|O:|P:|Q:|R:|S:|T:|U:|V:|W:|X:|Y:|Z:
gui add, text, xp+120 y5, 新盘符:
gui add, ComboBox, xp+50 yp-3 w100 vvOutCp, C:|D:|E:|F:|G:|H:|I:|J:|K:|L:|M:|N:|O:|P:|Q:|R:|S:|T:|U:|V:|W:|X:|Y:|Z:
gui add, Button, xp+120 h25 gchange, 转换
GuiControl, ChooseString, vaInCp, % SubStr(CandySel, 1, 2)
gui show,, 更改磁盘 %CandySel% 的驱动号
return

change:
Gui,66:Default 
gui, submit, nohide
if FileExist(vOutCp)
{
	msgbox 错误，磁盘 %vOutCp% 已经存在！
return
}
if fileexist(vaInCp "\Windows\System32\winload.exe")
{
	msgbox 选中盘符[%vaInCp%]为系统盘, 不支持更改!
return
}
VolumeName := GetVolumeNameForVolumeMountPoint(vaInCp)
If VolumeName
{
	DeleteVolumeMountPoint(vaInCp)
	if !SetVolumeMountPoint(vOutCp, VolumeName)
		msgbox 挂载分区出现错误`nErrorLevel: %ErrorLevel%`nA_LastError: %A_LastError%`n
}
Else
	msgbox 获取分区VolumeName出现错误`nErrorLevel: %ErrorLevel%`nA_LastError: %A_LastError%`n
return

66GuiClose:
66Guiescape:
Gui,66: Destroy
exitapp
Return

GetVolumeNameForVolumeMountPoint(pl)
{
	pl := RTrim(pl, " \")
	pl := pl "\"
	VarSetCapacity(VolumeName, 100, 0)
	hl:=dllcall("Kernel32.dll\GetVolumeNameForVolumeMountPoint", "Str", pl, "Str", VolumeName, "Uint", 100, "Int")
	if hl && !ErrorLevel
	return VolumeName
	else
	return 0
}

DeleteVolumeMountPoint(pl)
{
	pl := RTrim(pl, " \")
	pl := pl "\"
	hl:=dllcall("Kernel32.dll\DeleteVolumeMountPoint", "Str", pl)
	if hl && !ErrorLevel
	return 1
	else
	return 0
}

SetVolumeMountPoint(pl, VolumeName)
{
	pl := RTrim(pl, " \")
	pl := pl "\"
	hl:=dllcall("Kernel32.dll\SetVolumeMountPoint", "Str", pl, "Str", VolumeName)
	if hl && !ErrorLevel
	return 1
	else
	return 0
}