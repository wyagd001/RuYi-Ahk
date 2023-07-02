;|2.0|2023.07.01|1002
global A_icon := Object("计算机", "{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "回收站", "{645FF040-5081-101B-9F08-00AA002F954E}", "用户的文件", "{59031a47-3f72-44a7-89c5-5595fe6b30ee}", "控制面板", "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}", "网络", "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}", "库", "{031E4825-7B94-4dc3-B131-E946B44C8DD5}")
;global A_icon2 := Object()
global A_iconDy := Object("计算机", "vcomputer", "回收站", "vrecycle", "用户的文件", "vdocument", "控制面板", "vcontrol","网络", "vweb", "库", "vlib")
global A_iconDy2 := Object("计算机", "vcomputer_all", "回收站", "vrecycle_all", "用户的文件", "vdocument_all", "控制面板", "vcontrol_all", "网络", "vweb_all", "库", "vlib_all")
global A_iconDy3 := Object("计算机", "vcomputer_fsys", "回收站", "vrecycle_fsys", "用户的文件", "vdocument_fsys", "控制面板", "vcontrol_fsys", "网络", "vweb_fsys", "库", "vlib_fsys")
global A_iconSt := Object("计算机", 0, "回收站", 0, "用户的文件", 0, "控制面板", 0, "网络", 0, "库", 0)
global A_iconSt2 := Object("计算机", 0, "回收站", 0, "用户的文件", 0, "控制面板", 0, "网络", 0, "库", 0)
global A_iconSt3 := Object("计算机", 0, "回收站", 0, "用户的文件", 0, "控制面板", 0, "网络", 0, "库", 0)
for key in A_icon
{
	A_iconSt[key] := readshoworhide(key)
	A_iconSt2[key] := readshoworhide(key, 1)
}

Gui, Add, Button, x295 y310 w70 h30 gGuiSave, 确定
Gui, Add, Button, xp+80 yp w70 h30 gGuiClose, 取消
Gui, Add, Button, xp+80 yp w70 h30 gGuiApply, 应用

Gui, Add, Tab, x-4 y1 w530 h300, 常规|其他
Gui, Tab, 常规
Gui, Add, GroupBox, x10 y30 w500 h120, 当前用户
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvcomputer gdelfollow Checked" A_iconSt["计算机"], 计算机
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvcomputer_fsys gfollowsys Checked" A_iconSt3["计算机"], 跟随系统
Gui, Add, CheckBox, % "xp+120 yp w80 h20 vvrecycle gdelfollow Checked" A_iconSt["回收站"], 回收站
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvrecycle_fsys gfollowsys Checked" A_iconSt3["回收站"], 跟随系统
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvdocument gdelfollow Checked" A_iconSt["用户的文件"], 用户的文件
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvdocument_fsys gfollowsys Checked" A_iconSt3["用户的文件"], 跟随系统
Gui, Add, CheckBox, % "xp+120 yp w80 h20 vvcontrol gdelfollow Checked" A_iconSt["控制面板"], 控制面板
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvcontrol_fsys gfollowsys Checked" A_iconSt3["用户的文件"], 跟随系统
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvweb gdelfollow Checked" A_iconSt["网络"], 网络
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvweb_fsys gfollowsys Checked" A_iconSt3["用户的文件"], 跟随系统

Gui, Add, GroupBox, x10 y165 w500 h120, 系统(所有用户)
Gui, Add, CheckBox, % "xp+10 yp+30 w80 h20 vvcomputer_all Checked" A_iconSt2["计算机"], 计算机
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvrecycle_all Checked" A_iconSt2["回收站"], 回收站
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvdocument_all Checked" A_iconSt2["用户的文件"], 用户的文件
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvcontrol_all Checked" A_iconSt2["控制面板"], 控制面板
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvweb_all Checked" A_iconSt2["网络"], 网络
;Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvlib_all Checked" A_iconSt["库"], 库

Gui, Tab, 其他
Gui, Add, GroupBox, x10 y30 w500 h120, 当前用户(需要导航栏勾选库才能生效)
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvlib gdelfollow Checked" A_iconSt["库"], 库
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvlib_fsys gfollowsys Checked" A_iconSt3["库"], 跟随系统
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvpicture Checked" A_iconSt["图片"], 图片
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvdocument Checked" A_iconSt["文档"], 文档
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdownload Checked" A_iconSt["下载"], 下载
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvmusic Checked" A_iconSt["音乐"], 音乐
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdesktop Checked" A_iconSt["桌面"], 桌面

Gui, Add, GroupBox, x10 y165 w500 h120, 系统(所有用户)(需要导航栏勾选库才能生效)
Gui, Add, CheckBox, % "xp+10 yp+30 w120 h20 vvlib_all Checked" A_iconSt2["库"], 库

gui, show, , 桌面图标的显示/隐藏
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
		writeshoworhide(key, !tmp_val)
	}
}
for key, value in A_iconDy2
{
	tmp_val := %value%
	if (A_iconSt2[key] != tmp_val)
	{
		A_iconSt2[key] := tmp_val
		writeshoworhide(key, !tmp_val, 1)
	}
}
return

GuiSave:
gosub GuiApply
Gui, Destroy
exitapp
return

followsys:
Gui, submit, nohide
tmp_val := %A_GuiControl%
;tooltip % A_GuiControl " - " tmp_val
if (tmp_val=1)
{
	for key, value in A_iconDy3
	{
		if (value=A_GuiControl)
		{
			GuiControl,, % A_iconDy[key], 0
			A_iconSt[key] := 0
			delusersetting(key)
			break
		}
	}
}
return

delfollow:
Gui, submit, nohide
tmp_val := %A_GuiControl%
if (tmp_val=1)
{
	for key, value in A_iconDy
	{
		if (value=A_GuiControl)
		{
			GuiControl,, % A_iconDy3[key], 0
			break
		}
	}
}
return

readshoworhide(sKey, alluser:=0)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	if alluser
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	RegRead, OutputVar, %APath%, %tmp_val%
	;msgbox % sKey " - " tmp_val " - " OutputVar " - " ErrorLevel " - " A_LastError 
	if (OutputVar = 1)
	return 0
	if (OutputVar = 0)
	return 1
	if (ErrorLevel=1) && (A_LastError=2)
	{
		A_iconSt3[skey] := 1
	return 0
	}
}

delusersetting(sKey)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	RegDelete, %APath%, %tmp_val%
}

writeshoworhide(sKey, sValue:=0, alluser:=0)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	if alluser
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	RegWrite, REG_DWORD, %APath%, %tmp_val%, %sValue%
	;msgbox % APath " - " tmp_val " - " sValue " - " ErrorLevel " - " A_LastError
	;msgbox % sValue " - " sKey " - " RegKeyExist(sKey)
	if (sValue = 1) && (sKey = "库") && !RegKeyExist(sKey)
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{031E4825-7B94-4dc3-B131-E946B44C8DD5}
	}
*/
}

RegKeyExist(sKey, x32:=0) {
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"
	if x32
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"
	tmp_val := A_icon[sKey]
	Loop, Reg, %APath%, K
	{
		if (A_LoopRegName = tmp_val)
			return, 1
	}
	return 0
}
