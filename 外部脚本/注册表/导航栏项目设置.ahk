;|2.7|2024.08.18|1003
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\E71D.ico"
global A_icon := Object("收藏夹", "{323CA680-C24D-4099-B94D-446DD2D7249E}", "库", "{031E4825-7B94-4dc3-B131-E946B44C8DD5}", "家庭组", "{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}", "网络", "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}", "OneDrive", "{018D5C66-4533-4307-9B53-224DE2ED1FE6}", "快速访问", "{679f85cb-0220-4080-b29b-5540cc05aab6}", "控制面板", "{26EE0668-A00A-44D7-9371-BEB064C98683}")
global A_iconev := Object("收藏夹", "a0900100", "库", "b080010d", "家庭组", "b084010c", "网络", "b0040064", "OneDrive", "f080004d", "快速访问", "a0100000", "控制面板", "a0000004")
global A_icondv := Object("收藏夹", "a9400100", "库", "b090010d", "家庭组", "b094010c", "网络", "b0940064", "OneDrive", "f090004d", "快速访问", "a0600000", "控制面板", "a0100004")
global A_iconDy := Object("收藏夹", "vfav", "库", "vlib", "家庭组", "vhomegroup", "网络", "vweb", "OneDrive", "voned", "快速访问", "vquickac", "控制面板", "vcontr")
global A_iconDy2 := Object("收藏夹", "vfav_32", "库", "vlib_32", "家庭组", "vhomegroup_32", "网络", "vweb_32", "OneDrive", "voned_32", "快速访问", "vquickac_32", "控制面板", "vcontr_32")
global A_iconSt := Object("收藏夹", 0, "库", 0, "家庭组", 0, "网络", 0, "OneDrive", 0, "快速访问", 0, "控制面板", 0)
global A_iconSt2 := Object("收藏夹", 0, "库", 0, "家庭组", 0, "网络", 0, "OneDrive", 0, "快速访问", 0, "控制面板", 0)
for key in A_icon
{
	A_iconSt[key] := readshoworhide(key)
	A_iconSt2[key] := readshoworhide(key, 1)
}
if (A_PtrSize = 8)
{
	if FileExist(A_ScriptDir "\x64\SetACL.exe")
		AbsP := A_ScriptDir "\x64\SetACL.exe"
	else if FileExist(A_ScriptDir "\..\引用程序\x64\SetACL.exe")
	{
		VarSetCapacity(AbsP,260,0)
		DllCall("shlwapi\PathCombineW", "Str", AbsP, "Str", A_ScriptDir, "Str", "..\引用程序\x64\SetACL.exe")
	}
	else if FileExist(A_ScriptDir "\..\..\引用程序\x64\SetACL.exe")
	{
		VarSetCapacity(AbsP,260,0)
		DllCall("shlwapi\PathCombineW", "Str", AbsP, "Str", A_ScriptDir, "Str", "..\..\引用程序\x64\SetACL.exe")
	}
	else
		AbsP := A_ScriptDir "\SetACL.exe"
}
else
{
	if FileExist(A_ScriptDir "\x32\SetACL.exe")
		AbsP := A_ScriptDir "\x32\SetACL.exe"
	else if FileExist(A_ScriptDir "\..\引用程序\x64\SetACL.exe")
	{
		VarSetCapacity(AbsP,260,0)
		DllCall("shlwapi\PathCombineW", "Str", AbsP, "Str", A_ScriptDir, "Str", "..\引用程序\x64\SetACL.exe")
	}
	else if FileExist(A_ScriptDir "\..\..\引用程序\x32\SetACL.exe")
	{
		VarSetCapacity(AbsP,260,0)
		DllCall("shlwapi\PathCombineW", "Str", AbsP, "Str", A_ScriptDir, "Str", "..\..\引用程序\x64\SetACL.exe")
	}
	else
		AbsP := A_ScriptDir "\SetACL.exe"
}
global AbsP

Gui, Add, Button, x185 y310 w100 h30 gRestartExplorer, 应用并重启桌面
Gui, Add, Button, xp+110 yp w70 h30 gGuiSave, 确定
Gui, Add, Button, xp+80 yp w70 h30 gGuiClose, 取消
Gui, Add, Button, xp+80 yp w70 h30 gGuiApply, 应用

Gui, Add, Tab, x-4 y1 w530 h300, 导航栏项目|其他文件夹
Gui, Tab, 导航栏项目
Gui, Add, GroupBox, x10 y30 w500 h120,导航栏项目(取消后对应的桌面图标将会删除)
Gui, Add, CheckBox, % "xp+10 yp+30 w80 h20 vvfav Checked" A_iconSt["收藏夹"], 收藏夹
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvlib Checked" A_iconSt["库"], 库
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvhomegroup Checked" A_iconSt["家庭组"], 家庭组
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvweb Checked" A_iconSt["网络"], 网络
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvoned Checked" A_iconSt["OneDrive"], OneDrive
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvquickac Checked" A_iconSt["快速访问"], 快速访问

Gui, Add, GroupBox, x10 y165 w500 h120, 32位程序打开对话框(上下两组设置都需要重启explorer才会看到效果)
Gui, Add, CheckBox, % "xp+10 yp+30 w80 h20 vvfav_32 Checked" A_iconSt2["收藏夹"], 收藏夹
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvlib_32 Checked" A_iconSt2["库"], 库
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvhomegroup_32 Checked" A_iconSt2["家庭组"], 家庭组
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvweb_32 Checked" A_iconSt2["网络"], 网络
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvoned_32 Checked" A_iconSt2["OneDrive"], OneDrive
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvquickac_32 Checked" A_iconSt2["快速访问"], 快速访问

Gui, Tab, 其他文件夹
Gui, Add, GroupBox, x10 y30 w500 h120, 待定
Gui, Add, CheckBox, % "xp+10 yp+30 w120 h20 vvcontr Checked" A_iconSt["控制面板"], 控制面板
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvpicture Checked" A_iconSt["图片"], 图片
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvdocument Checked" A_iconSt["文档"], 文档
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdownload Checked" A_iconSt["下载"], 下载
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvmusic Checked" A_iconSt["音乐"], 音乐
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdesktop Checked" A_iconSt["桌面"], 桌面

Gui, Add, GroupBox, x10 y165 w500 h120, 32位程序打开对话框
Gui, Add, CheckBox, % "xp+10 yp+30 w120 h20 vvcontr_32 Checked" A_iconSt2["3d"], 控制面板

gui, show, , 资源管理器导航栏项目的显示/隐藏
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
		;msgbox % A_iconSt2[key] " - " tmp_val
		A_iconSt[key] := tmp_val
		writeshoworhide(key, tmp_val)
	}
}
for key, value in A_iconDy2
{
	tmp_val := %value%
	if (A_iconSt2[key] != tmp_val)
	{
		;msgbox % A_iconSt2[key] " - " tmp_val
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

RestartExplorer:
gosub GuiApply
RestartExplorer()
return

readshoworhide(sKey, x32:=0)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_CLASSES_ROOT\CLSID\" tmp_val "\ShellFolder"
	if x32
		APath := "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\" tmp_val "\ShellFolder"
	
	RegRead, OutputVar, %APath%, Attributes
	tmp_val2 := "0x" A_iconev[sKey]
	tmp_val2 := tmp_val2 + 0x0
	;msgbox % tmp_val " - " tmp_val2 " - " A_iconev[sKey] " - " OutputVar
	if (OutputVar = tmp_val2)
	return 1
	else
	return 0
}

writeshoworhide(sKey, show:=1, x32:=0)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_CLASSES_ROOT\CLSID\" tmp_val "\ShellFolder"
	if x32
		APath := "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\" tmp_val "\ShellFolder"

	if show
		tmp_val2 := "0x" A_iconev[sKey]
	else
		tmp_val2 := "0x" A_icondv[sKey]
	tmp_val2 := tmp_val2 + 0x0
	RegWrite, REG_DWORD, %APath%, Attributes, %tmp_val2%
	if ErrorLevel && (A_LastError = 5)
	;msgbox % sKey " - " ErrorLevel " - " A_LastError
	{
		run, %AbsP% -on "%APath%" -ot reg -actn setowner -ownr "n:Administrators",,hide
		sleep 1000
		run, %AbsP% -on "%APath%" -ot reg -actn ace -ace "n:Administrators;p:full",,hide
		sleep 1000
		RegWrite, REG_DWORD, %APath%, Attributes, %tmp_val2%
		if ErrorLevel
			msgbox % AbsP " - " ErrorLevel " - " A_LastError
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

RestartExplorer()
{
	run, taskkill /f /im explorer.exe,,hide
	sleep 1000
	run, explorer.exe
}