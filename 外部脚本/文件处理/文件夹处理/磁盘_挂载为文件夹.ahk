;|2.2|2023.07.01|1405
CandySel := A_Args[1]
param := A_Args[2]
CandySel := trim(CandySel, """")

if param
{
	param := RTrim(param, " \")
	if !FileExist(param)
		FileCreateDir, % param
	if !CF_FolderIsEmpty(param)
	{
		msgbox 错误，文件夹不为空！
		ExitApp
	}
	if (CF_GetDriveFS(param) != "NTFS")
	{
		msgbox 文件夹所在分区不是 NTFS 文件系统格式！
		ExitApp
	}

	VolumeName := GetVolumeNameForVolumeMountPoint(CandySel)
	If VolumeName
	{
		if !SetVolumeMountPoint(param, VolumeName)
			msgbox 挂载分区出现错误`nErrorLevel: %ErrorLevel%`nA_LastError: %A_LastError%`n
		ExitApp
	}
}
else
{
	Gui,66:Destroy
	Gui,66:Default
	Gui, Add, Text, x10 y17, 目标文件夹(&T)：
	Gui, Add, Edit, x100 y15 h40 w350 vPMTF_TGPath
	Gui, Add, Button, x280 y60 w80 h25 Default gPMTF_OK, 确定(&S)
	Gui, Add, Button, x370 y60 w80 h25 g66GuiClose, 取消(&X)
	Gui,show, , 挂载分区 [%CandySel%] 到 NTFS 分区的空文件夹
}
Return

PMTF_OK:
Gui,66:Default
gui, submit, hide
if !PMTF_TGPath
return
if (CF_GetDriveFS(PMTF_TGPath)!="NTFS")
{
	msgbox 文件夹所在分区不是 NTFS 文件系统格式！
return
}
if !FileExist(PMTF_TGPath)
	FileCreateDir, % PMTF_TGPath
if !CF_FolderIsEmpty(PMTF_TGPath)
{
	msgbox 错误，文件夹不为空！
return
}
VolumeName := GetVolumeNameForVolumeMountPoint(CandySel)
If VolumeName
{
	if !SetVolumeMountPoint(PMTF_TGPath, VolumeName)
		msgbox 挂载分区出现错误`nErrorLevel: %ErrorLevel%`nA_LastError: %A_LastError%`n
}
return

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

/*
您可以通过使用SetVolumeMountPoint函数为本地卷分配一个驱动器号（例如，X:），前提是没有卷已经分配给该驱动器号。如果本地卷已经有一个驱动器号，那么SetVolumeMountPoint将失败。要处理这种情况，首先使用DeleteVolumeMountPoint函数删除驱动器代号。示例代码请参见编辑驱动器号分配。

系统支持每个卷最多支持一个驱动器字母。因此，您不能使用 SetVolumeMountPoint 让C:\和F:\代表同一个卷。
*/
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

CF_FolderIsEmpty(sfolder){
Loop, Files, %sfolder%\*.*, FD
	return 0
return 1
}

CF_GetDriveFS(sfile){
	SplitPath, sfile, , , , , sDrive
	DriveGet, DFS, FS, %sDrive%
	return DFS
}

66GuiClose:
66Guiescape:
Gui,66: Destroy
exitapp
Return