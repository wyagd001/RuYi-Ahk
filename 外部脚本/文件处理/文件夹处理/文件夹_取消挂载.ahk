;|2.2|2023.07.01|1406
CandySel := A_Args[1]
if !InStr(FileExist(CandySel), "D")
	exitapp
VolumeName := GetVolumeNameForVolumeMountPoint(CandySel)
if ErrorLevel
	msgbox 错误`nErrorLevel: %ErrorLevel%`nA_LastError: %A_LastError%`n
if !VolumeName
{
	msgbox 该文件夹可能不是分区挂载的！
	return
}
if !DeleteVolumeMountPoint(CandySel)
	msgbox 取消挂载的文件夹出现错误`nErrorLevel: %ErrorLevel%`nA_LastError: %A_LastError%`n
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