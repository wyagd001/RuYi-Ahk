;|2.0|2023.07.01|1001
global A_icon := Object("视频", "{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}", "图片", "{24ad3ad4-a569-4530-98e1-ab02f9417aa8}", "文档", "{d3162b92-9365-467a-956b-92703aca08af}", "下载", "{088e3905-0323-4b02-9826-5d99428e115f}", "音乐", "{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}", "桌面", "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}", "3D", "{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}")
global A_icon2 := Object("视频", "{35286a68-3c57-41a1-bbb1-0eae73d76c95}", "图片", "{0ddd015d-b06c-45d5-8c4c-f59713854639}", "文档", "{f42ee2d3-909f-4907-8871-4c22fc0bf756}", "下载", "{7d83ee9b-2244-4e70-b1f5-5393042af1e4}", "音乐", "{a0c69a99-21c8-4671-8703-7934162fcf1d}", "桌面", "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}", "3D", "{31C0DD25-9439-4F12-BF41-7FF4EDA38722}")
global A_iconDy := Object("视频", "vvideo", "图片", "vpicture", "文档", "vdocument", "下载", "vdownload","音乐", "vmusic","桌面", "vdesktop", "3D", "v3d")
global A_iconDy2 := Object("视频", "vvideo_32", "图片", "vpicture_32", "文档", "vdocument", "下载", "vdownload_32","音乐", "vmusic_32","桌面", "vdesktop_32", "3D", "v3d_32")
global A_iconSt := Object("视频", 0, "图片", 0, "文档", 0, "下载", 0,"音乐", 0,"桌面", 0)
global A_iconSt2 := Object("视频", 0, "图片", 0, "文档", 0, "下载", 0,"音乐", 0,"桌面", 0)
for key in A_icon
{
	A_iconSt[key] := readshoworhide(key)
	A_iconSt2[key] := readshoworhide(key, 1)
}

Gui, Add, Button, x295 y310 w70 h30 gGuiSave, 确定
Gui, Add, Button, xp+80 yp w70 h30 gGuiClose, 取消
Gui, Add, Button, xp+80 yp w70 h30 gGuiApply, 应用

Gui, Add, Tab, x-4 y1 w530 h300, 6个文件夹|其他文件夹
Gui, Tab, 6个文件夹
Gui, Add, GroupBox, x10 y30 w500 h120, 此电脑6个文件夹图标
Gui, Add, CheckBox, % "xp+10 yp+30 w40 h20 vvvideo Checked" A_iconSt["视频"], 视频
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvpicture Checked" A_iconSt["图片"], 图片
Gui, Add, CheckBox, % "xp-150 yp+30 w40 h20 vvdocument Checked" A_iconSt["文档"], 文档
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvdownload Checked" A_iconSt["下载"], 下载
Gui, Add, CheckBox, % "xp-150 yp+30 w40 h20 vvmusic Checked" A_iconSt["音乐"], 音乐
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvdesktop Checked" A_iconSt["桌面"], 桌面

Gui, Add, GroupBox, x10 y165 w500 h120, 32位程序(打开对话框等)
Gui, Add, CheckBox, % "xp+10 yp+30 w40 h20 vvvideo_32 Checked" A_iconSt2["视频"], 视频
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvpicture_32 Checked" A_iconSt2["图片"], 图片
Gui, Add, CheckBox, % "xp-150 yp+30 w40 h20 vvdocument_32 Checked" A_iconSt2["文档"], 文档
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvdownload_32 Checked" A_iconSt2["下载"], 下载
Gui, Add, CheckBox, % "xp-150 yp+30 w40 h20 vvmusic_32 Checked" A_iconSt2["音乐"], 音乐
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvdesktop_32 Checked" A_iconSt2["桌面"], 桌面

Gui, Tab, 其他文件夹
Gui, Add, GroupBox, x10 y30 w500 h120, 其他文件夹图标
Gui, Add, CheckBox, % "xp+10 yp+30 w120 h20 vv3d Checked" A_iconSt["3d"], 3D 对象
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvpicture Checked" A_iconSt["图片"], 图片
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvdocument Checked" A_iconSt["文档"], 文档
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdownload Checked" A_iconSt["下载"], 下载
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvmusic Checked" A_iconSt["音乐"], 音乐
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdesktop Checked" A_iconSt["桌面"], 桌面

Gui, Add, GroupBox, x10 y165 w500 h120, 32位程序打开对话框
Gui, Add, CheckBox, % "xp+10 yp+30 w120 h20 vv3d_32 Checked" A_iconSt2["3d"], 3D 对象

gui, show, , 此电脑中文件夹图标的显示/隐藏
return

GuiEscape:
GuiClose:
Gui, Destroy
exitapp
return

GuiApply:
Gui, submit, nohide
for key, value in A_iconDy
{
	tmp_val := %value%
	if (A_iconSt[key] != tmp_val)
	{
		A_iconSt[key] := tmp_val
		writeshoworhide(key, tmp_val)
	}
}
for key, value in A_iconDy2
{
	tmp_val := %value%
	if (A_iconSt2[key] != tmp_val)
	{
		A_iconSt2[key] := tmp_val
		writeshoworhide(key, tmp_val, 1)
	}
}
return

GuiSave:
gosub GuiApply
Gui, Destroy
exitapp
return

readshoworhide(sKey, x32:=0)
{
	if !x32
	{
		if !RegKeyExist(sKey)
		return 0
	}
	tmp_val := A_icon2[sKey]
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\" tmp_val "\PropertyBag"
	if x32
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\" tmp_val "\PropertyBag"
	
	RegRead, OutputVar, %APath%, ThisPCPolicy
	;msgbox % sKey " - " tmp_val " - " OutputVar
	if (OutputVar = "Hide")
	return 0
	else
	return 1
}

writeshoworhide(sKey, show:=1, x32:=0)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\" tmp_val
	if x32
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\" tmp_val
	if show && !RegKeyExist(sKey, x32)
	{
		RegWrite, REG_SZ, %APath%
	}

	tmp_val := A_icon2[sKey]
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\" tmp_val "\PropertyBag"
	if x32
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\" tmp_val "\PropertyBag"
	if show
	{
		RegWrite, REG_SZ, %APath%, ThisPCPolicy, Show
		;msgbox % APath " - " ErrorLevel " - " A_LastError 
	}
	else
	{
		RegWrite, REG_SZ, %APath%, ThisPCPolicy, Hide
		;msgbox % APath " - " ErrorLevel " - " A_LastError 
	}
}

RegKeyExist(sKey, x32:=0) {
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace"
	if x32
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace"
	tmp_val := A_icon[sKey]
	Loop, Reg, %APath%, K
	{
		if (A_LoopRegName = tmp_val)
			return, 1
	}
	return 0
}
