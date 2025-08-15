;|3.0|2025.07.25|1045
CandySel := A_Args[1]
SplitPath, CandySel, CandySel_FileName, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt, CandySel_Drive
CandySel_Ext := CF_IsFolder(CandySel) ? "Folder" : CandySel_Ext

Cando_CreateLink:
If (CF_GetDriveFS(CandySel_Drive) != "NTFS")
{
	Gui, +OwnDialogs
	MsgBox, 262192, 磁盘格式不匹配, 当前磁盘 %CandySel_Drive% 不是 NTFS 文件系统格式，无法创建硬软链接！
	Return
}
Gui, Destroy
Gui, Default
Gui, Add, Text, x10 y17, 目标文件(&T)
Gui, Add, Edit, x90 y15 h40 w350 readonly vSHHL_TGPath, % CandySel
Gui, Add, Text, x10 y65, 链接文件(&P)
Gui, Add, Edit, x90 y63 h40 w350 vSHHL_Path gupdate_descr,
Gui, Add, Radio, x90 y110 w120 h30 vSHHL_Type_Hardlink Checked gupdate_descr, 硬链接(仅文件)
Gui, Add, Radio, x240 y110 w120 h30 vSHHL_Type_SymbolicLink gupdate_descr, 符号链接(软链接)
Gui, Add, Text, x10 y150, 说明(&P)
Gui, Add, Edit, x90 y148 h40 w350 readonly vSHHL_descr,
Gui, Add, Button, x280 y200 w80 h25 Default gSHHL_OK, 确定(&S)
Gui, Add, Button, x370 y200 w80 h25 gGuiClose, 取消(&X)
if (CandySel_Ext = "Folder")
{
	GuiControl, Disable, SHHL_Type_Hardlink
	GuiControl, , SHHL_Type_SymbolicLink, 1
	Gui, show, , 为文件夹 [%CandySel_FileName%] 创建链接
}
else
	Gui, show, , 为文件 [%CandySel_FileName%] 创建链接
return

SHHL_OK:
Gui, Default
gui, submit, nohide
if !SHHL_Path
{
	guicontrol,, SHHL_descr, 链接文件路径为空！
	SHHL_Err := 1
}
if SHHL_Err
	return
SHHL_Path := Trim(SHHL_Path, " `r`n`t")
if SHHL_Type_Hardlink
{
	returnVal := CreateHardLink(SHHL_TGPath, SHHL_Path)
	if returnVal
		guicontrol,, SHHL_descr, 创建文件硬链接成功！
	else
  {
    if (A_LastError=183)
    {
      guicontrol,, SHHL_descr, 失败！错误代码: %A_LastError%。`n链接文件已经存在, 无法创建。请删除链接文件后再次创建！
    }
    else
      guicontrol,, SHHL_descr, 失败！错误代码: %A_LastError%。
  }
}
else if SHHL_Type_SymbolicLink && (CandySel_Ext = "Folder")
{
	returnVal := CreateSymbolicLink(SHHL_TGPath, SHHL_Path, 0x1)
	if returnVal
		guicontrol,, SHHL_descr, 创建文件夹符号链接成功！
	else
		guicontrol,, SHHL_descr, 失败！错误代码: %A_LastError%。
}
else
{
	returnVal := CreateSymbolicLink(SHHL_TGPath, SHHL_Path)
	if returnVal
		guicontrol, , SHHL_descr, 创建文件符号链接成功！
	else
		guicontrol, , SHHL_descr, 失败！错误代码: %A_LastError%。
}
return

GuiClose:
exitapp

update_descr:
Gui, Default
gui, submit, nohide
If (RegexMatch(SHHL_Path, "^([a-zA-Z]:\\)[^\/:\*\?""\<>\|]*$") = 0)
{
	guicontrol,, SHHLF_descr, 链接文件路径错误。例如包含以下非法字符：\ / : * \ ? " < > |
	SHHL_Err := 1
	return
}
if SHHL_Type_Hardlink
{
	SplitPath, SHHL_Path, , , , , Tmp_Drive
	if (Tmp_Drive <> CandySel_Drive)
	{
		guicontrol, , SHHL_descr, 硬链接文件分区错误，硬链接不能跨分区!
		SHHL_Err := 1
	}
	else
	{
		guicontrol,, SHHL_descr,
		SHHL_Err := 0
	}
}
if SHHL_Type_SymbolicLink
{
	If (CF_GetDriveFS(SHHL_Path) != "NTFS")
	{
		guicontrol, , SHHL_descr, 链接文件所在分区不是 NTFS 文件系统格式！
		SHHL_Err := 1
	}
else
	{
		guicontrol, , SHHL_descr,
		SHHL_Err := 0
	}
}
return

; https://docs.microsoft.com/zh-cn/windows/win32/api/winbase/nf-winbase-createhardlinka
; 成功返回非零值，失败返回 0.
CreateHardLink(InFile, OutFile)
{
Return (DllCall("CreateHardLink", "Str", OutFile, "Str", InFile, "Int",0))
}

; https://docs.microsoft.com/zh-cn/windows/win32/api/winbase/nf-winbase-createsymboliclinka
; 成功返回非零值，失败返回 0.
CreateSymbolicLink(InFile, OutFile, IsDirectoryLink := 0)
{
Return (DllCall("CreateSymbolicLink", "Str", OutFile, "Str", InFile, "UInt", IsDirectoryLink))
}

CF_GetDriveFS(sfile){
	SplitPath, sfile, , , , , sDrive
	DriveGet, DFS, FS, %sDrive%
	return DFS
}