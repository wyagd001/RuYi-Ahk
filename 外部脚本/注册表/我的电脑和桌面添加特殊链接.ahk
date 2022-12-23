;来源网址: http://thinkai.net/page/16
;创建界面
Gui, Add, Text, x0 y0 w40 h20 , 名称:
Gui, Add, Edit, x50 y0 w280 h20 vname,
Gui, Add, Button, x330 y0 w80 h20 gapply, 应用
Gui, Add, Button, x410 y0 w40 h20 ghelp, ？
Gui, Add, Text, x0 y20 w40 h20 , 图标
Gui, Add, Picture, x40 y20 w24 h24 vsico,
Gui, Add, Edit, x64 y20 w346 h20 vicon,
Gui, Add, Button, x410 y20 w40 h20 gselectico, 浏览
Gui, Add, Text, x0 y50 w50 h20 , 右键菜单
Gui, Add, text, x0 y70 w40 h20 , 菜单名
Gui, add, Edit, x40 y70 w100 h20 vmenu_name,
Gui, Add, text, x140 y70 w40 h20 , 命令行
Gui, add, Edit, x180 y70 w230 h20 vmenu_cmd,
Gui, Add, Button, x410 y70 w40 h20 gadd, 添加
Gui, add, ListView, xo y90 w450 h100, id|是否默认|标题|命令
Gui, Show, , 我的电脑/桌面添加链接 By Thinkai
;初始化
option := object()
option["index"] := 0
Return

add:
gui, submit, nohide ;获取表单
if (menu_name and menu_cmd) ;已经填写
{
	option["index"]++
	Default = 否
	MsgBox, 36, 提示, 是否设为默认项？
	IfMsgBox, Yes
	{
		option["default"] := option["index"]
		Default = 是
		loop % LV_GetCount() ;覆盖lv的显示
		{
		LV_Modify(A_index, , , "否")
		}
	}
	;键值是个数组
	option[option["index"]] := object()
	option[option["index"]]["name"] := menu_name
	option[option["index"]]["cmd"] := menu_cmd
	LV_Add("",option["index"],default,menu_name,menu_cmd) ;添加到列表 列表只是显示 执行从数组走
	LV_ModifyCol() ;调整列宽
	;清空填写框
	GuiControl, , menu_name,
	GuiControl, , menu_cmd,
}
Return


apply:
gui, submit, nohide
if (name and icon)
{
	Random, n5, 10000, 99999
	clsid = {FD4DF9E0-E3DE-11CE-BFCF-ABCD1DE%n5%} ;随机CLSID
	;if (A_Is64bitOS && (!InStr(A_OSType,"WIN_2003") or !InStr(A_OSType,"WIN_XP") or !InStr(A_OSType,"WIN_2000"))) ;是新版64位系统
	;	item = Software\Classes\Wow6432Node\CLSID\%clsid%
	;Else
		item = Software\Classes\CLSID\%clsid%
	;创建具体的CLSID项
	RegWrite, REG_SZ, HKCU, %item%, , %name% ;显示名称
	RegWrite, REG_SZ, HKCU, %item%, InfoTip, 右键查看%name%具体项目 ;悬停提示
	RegWrite, REG_SZ, HKCU, %item%, LocalizedString, %name%
	RegWrite, REG_SZ, HKCU, %item%, System.ItemAuthors, 右键查看%name%具体项目
	RegWrite, REG_SZ, HKCU, %item%, TileInfo, prop:System.ItemAuthors
	RegWrite, REG_SZ, HKCU, %item%\DefaultIcon, , %icon% ;图标
	RegWrite, REG_SZ, HKCU, %item%\InprocServer32, , %SystemRoot%\system32\shdocvw.dll
	RegWrite, REG_SZ, HKCU, %item%\InprocServer32, ThreadingModel, Apartment
	;循环添加命令
	Loop % option["index"]
	{
	mname := option[A_index]["name"]
	mcmd := option[A_index]["cmd"]
	if option["default"] = A_index
		RegWrite, REG_SZ, HKCU, %item%\Shell, , n_%A_Index%
	RegWrite, REG_SZ, HKCU, %item%\Shell\n_%A_Index%, , %mname% ;名称
	RegWrite, REG_SZ, HKCU, %item%\Shell\n_%A_Index%\Command, , %mcmd% ;命令
	}
	;RegWrite, REG_BINARY, HKCU, %item%, Attributes, 00000000 ;属性
	RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%clsid%, , %name% ;添加到我的电脑
	RegWrite, REG_SZ, HKCU, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\%clsid%, , %name% ;添加到桌面
	;生成卸载reg
	FileAppend, Windows Registry Editor Version 5.00, %A_ScriptDir%\卸载%name%.reg
	FileAppend, `n[-HKEY_CURRENT_USER\%item%], %A_ScriptDir%\卸载%name%.reg
	FileAppend, `n[-HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%clsid%], %A_ScriptDir%\卸载%name%.reg
	FileAppend, `n[-HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\%clsid%], %A_ScriptDir%\卸载%name%.reg
	MsgBox, 4128, 提示, 已创建图标，桌面上请手动刷新！`n若要卸载，请在程序目录下`n双击"卸载%name%.reg"卸载!
}
;清空所有填写
GuiControl, , menu_name,
GuiControl, , menu_cmd,
GuiControl, , icon,
GuiControl, , name,
GuiControl, , sico,
LV_Delete()
option := object()
option["index"] := 0
Return

selectico:
gui +owndialogs
fileselectfile, icon, 1, %lastdir%, 打开一图标文件, 图标文件(*.ico;*.exe)
if icon =
	Return
GuiControl, , icon, %icon%
guicontrol, , sico, %icon%
Return

help:
MsgBox, 4128, 帮助, “名称”为在我的电脑和桌面显示的名称`n“图标”为在我的电脑和桌面显示的图标`n“菜单名”是右键菜单中的项名，可以使用“(&e)”这种快捷键`n“命令行”为打开时执行的命令。`n`n若要卸载，请在程序目录下`n双击卸载xx.reg卸载。, 10
Return

show_obj(obj,menu_name:=""){
if menu_name =
    {
    main = 1
    Random, rand, 100000000, 999999999
    menu_name = %A_Now%%rand%
    }
Menu, % menu_name, add,
Menu, % menu_name, DeleteAll
for k,v in obj
{
if (IsObject(v))
	{
    Random, rand, 100000000, 999999999
	submenu_name = %A_Now%%rand%
    Menu, % submenu_name, add,
    Menu, % submenu_name, DeleteAll
	Menu, % menu_name, add, % k ? "【" k "】[obj]" : "", :%submenu_name%
    show_obj(v,submenu_name)
	}
Else
	{
	Menu, % menu_name, add, % k ? "【" k "】" v: "", MenuHandler
	}
}
if main = 1
    menu,% menu_name, show
}


MenuHandler:
return

GuiClose:
ExitApp