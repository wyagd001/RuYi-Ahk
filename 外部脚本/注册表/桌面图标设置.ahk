;|2.2|2023.08.06|1002
;HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu
;HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel
global A_icon := Object("计算机", "{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "回收站", "{645FF040-5081-101B-9F08-00AA002F954E}", "用户的文件", "{59031a47-3f72-44a7-89c5-5595fe6b30ee}", "控制面板", "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}", "网络", "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}", "库", "{031E4825-7B94-4dc3-B131-E946B44C8DD5}")

; key - 变量  对应关系1, 对应关系2, 对应关系3, 对应关系4
global A_iconDy := Object("计算机", "vcomputer", "回收站", "vrecycle", "用户的文件", "vdocument", "控制面板", "vcontrol","网络", "vweb", "库", "vlib")
global A_iconDy2 := Object("计算机", "vcomputer_all", "回收站", "vrecycle_all", "用户的文件", "vdocument_all", "控制面板", "vcontrol_all", "网络", "vweb_all", "库", "vlib_all")
global A_iconDy3 := Object("计算机", "vcomputer_value", "回收站", "vrecycle_value", "用户的文件", "vdocument_value", "控制面板", "vcontrol_value", "网络", "vweb_value", "库", "vlib_value")
global A_iconDy4 := Object("计算机", "vcomputer_all_value", "回收站", "vrecycle_all_value", "用户的文件", "vdocument_all_value", "控制面板", "vcontrol_all_value", "网络", "vweb_all_value", "库", "vlib_all_value")

; 当前用户和所有用户图标的状态值
global A_iconSt := Object("计算机", 0, "回收站", 0, "用户的文件", 0, "控制面板", 0, "网络", 0, "库", 0)
global A_iconSt2 := Object("计算机", 0, "回收站", 0, "用户的文件", 0, "控制面板", 0, "网络", 0, "库", 0)

Gui, Add, Button, x295 y325 w70 h30 gGuiSave, 确定
Gui, Add, Button, xp+80 yp w70 h30 gGuiClose, 取消
Gui, Add, Button, xp+80 yp w70 h30 gGuiApply, 应用

Gui, Add, Tab, x-4 y1 w530 h320, 常规|其他
Gui, Tab, 常规
Gui, Add, GroupBox, x10 y30 w500 h135, 当前用户
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvcomputer Checked0", 计算机
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvcomputer_value",
Gui, Add, CheckBox, % "xp+90 yp-3 w80 h20 vvrecycle  Checked0", 回收站
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvrecycle_value",
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvdocument Checked0", 用户的文件
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvdocument_value",
Gui, Add, CheckBox, % "xp+90 yp-3 w80 h20 vvcontrol Checked0", 控制面板
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvcontrol_value",

Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvweb Checked0", 网络
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvweb_value",

Gui, Add, Link, % "xp+90 yp-3 w310 h35 gdelusersetting", 当前用户中存在值时, 优先使用. <a>删除当前用户中的所有值</a>

Gui, Add, GroupBox, x10 y175 w500 h140, 所有用户
Gui, Add, CheckBox, % "xp+10 yp+30 w80 h20 vvcomputer_all Checked0", 计算机
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvcomputer_all_value",0
Gui, Add, CheckBox, % "xp+90 yp-3 w80 h20 vvrecycle_all Checked0", 回收站
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvrecycle_all_value",
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvdocument_all Checked0", 用户的文件
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvdocument_all_value",
Gui, Add, CheckBox, % "xp+90 yp-3 w80 h20 vvcontrol_all Checked0", 控制面板
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvcontrol_all_value",
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvweb_all Checked0", 网络
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvweb_all_value",

Gui, Add, Link, % "xp+90 yp-3 w310 h35 gdelallusersetting", 当前用户和所有用户两者都不存在值时, 默认显示图标. <a>删除所有用户中的所有值</a>

Gui, Tab, 其他
Gui, Add, GroupBox, x10 y30 w500 h120, 当前用户(需要导航栏勾选库才能生效)
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvlib Checked" A_iconSt["库"], 库
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvlib_value",


Gui, Add, GroupBox, x10 y165 w500 h120, 系统(所有用户)(需要导航栏勾选库才能生效)
Gui, Add, CheckBox, % "xp+10 yp+30 w60 h20 vvlib_all Checked" A_iconSt2["库"], 库
Gui, Add, Text, % "xp+80 yp+3 w80 h20 vvlib_all_value",
gosub loadiconState
gui, show, , 桌面图标的显示/隐藏
return

GuiEscape:
GuiClose:
Gui, Destroy
exitapp
return

GuiSave:
gosub GuiApply
Gui, Destroy
exitapp
return

GuiApply:
Gui, submit, nohide
for key, value in A_iconDy
{
	tmp_val := %value%
	;msgbox % value " - " %value%
	if (A_iconSt[key] = 2) && (tmp_val = 0)
		continue
	if (A_iconSt[key] != tmp_val)
	{
		writeshoworhide(key, !tmp_val)
	}
}
for key, value in A_iconDy2
{
	tmp_val := %value%
	if (A_iconSt2[key] = 2) && (tmp_val = 0)
		continue
	if (A_iconSt2[key] != tmp_val)
	{
		writeshoworhide(key, !tmp_val, 1)
	}
}
gosub loadiconState
RefreshExplorer()
return

delusersetting:
for key, value in A_iconDy
{
	delusersetting(key)
}
gosub loadiconState
RefreshExplorer()
return

delallusersetting:
for key, value in A_iconDy
{
	delusersetting(key, 1)
}
gosub loadiconState
RefreshExplorer()
return

loadiconState:
for key in A_icon
{
	A_iconSt[key] := readshoworhide(key)
	A_iconSt2[key] := readshoworhide(key, 1)
	GuiControl,, % A_iconDy[key], % (A_iconSt[key]?!(A_iconSt[key] - 1):0)
	GuiControl,, % A_iconDy2[key], % (A_iconSt2[key]?!(A_iconSt2[key] - 1):0)
	GuiControl,, % A_iconDy3[key], % (A_iconSt[key] = 2) ? "值:不存在" : (A_iconSt[key] = 1) ? "值:1" : "值:0"
	GuiControl,, % A_iconDy4[key], % (A_iconSt2[key] = 2) ? "值:不存在" : (A_iconSt2[key] = 1) ? "值:1" : "值:0"
}
return

readshoworhide(sKey, alluser:=0)
{
	tmp_val := A_icon[sKey]
	if alluser
	{
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
		RegRead, OutputVar, %APath%, %tmp_val%
		if (OutputVar = 1)
		{
			return 0
		}
		if (OutputVar = 0)
		{
			return 1
		}
		if (ErrorLevel = 1) && (A_LastError = 2)
		{
			APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
			RegRead, OutputVar2, %APath%, %tmp_val%
			if (OutputVar2 = 1)
			{
				return 0
			}
			if (OutputVar2 = 0)
			{
				return 1
			}
			if (ErrorLevel = 1) && (A_LastError = 2)  ; 错误:2, 系统找不到指定的文件, 说明在所有用户中没有设置过
			{
				return 2
			}
		}
	}
	else
	{
		APath := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
		RegRead, OutputVar, %APath%, %tmp_val%
		;msgbox % sKey " - " tmp_val " - " OutputVar " - " ErrorLevel " - " A_LastError
		if (OutputVar = 1)
		return 0
		if (OutputVar = 0)
		return 1
		if (ErrorLevel = 1) && (A_LastError = 2)  ; 当前用户的配置没有, 说明被删除了
		{
			APath := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
			RegRead, OutputVar2, %APath%, %tmp_val%
			if (OutputVar2 = 1)
				return 0
			if (OutputVar2 = 0)
				return 1
			if (ErrorLevel = 1) && (A_LastError = 2)
			{
				return 2
			}
		}
	}
}

delusersetting(sKey, alluser:=0)
{
	tmp_val := A_icon[sKey]
	if (alluser = 1)
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	else
		APath := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	RegDelete, %APath%, %tmp_val%

	if (alluser = 1)
		APath2 := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
	else
		APath2 := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
	RegDelete, %APath2%, %tmp_val%
}

writeshoworhide(sKey, sValue:=0, alluser:=0)
{
	tmp_val := A_icon[sKey]
	if alluser
	{
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
		APath2 := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
	}
	else
	{
		APath := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
		APath2 := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu"
	}
	RegWrite, REG_DWORD, %APath%, %tmp_val%, %sValue%
	RegWrite, REG_DWORD, %APath2%, %tmp_val%, %sValue%
	;msgbox % APath " - " tmp_val " - " sValue " - " ErrorLevel " - " A_LastError
	;msgbox % sValue " - " sKey " - " RegKeyExist(sKey)
	if (sValue = 1) && (sKey = "库") && !RegKeyExist(sKey)
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{031E4825-7B94-4dc3-B131-E946B44C8DD5}
	}
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

RefreshExplorer()
{ ; by teadrinker on D437 @ tiny.cc/refreshexplorer
	local Windows := ComObjCreate("Shell.Application").Windows
	Windows.Item(ComObject(0x13, 8)).Refresh()
	for Window in Windows
		if (Window.Name != "Internet Explorer")
			Window.Refresh()
}