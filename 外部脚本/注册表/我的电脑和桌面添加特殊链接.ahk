;|2.7|2024.08.26|1005
; 来源网址: http://thinkai.net/page/16   已修改
#SingleInstance force
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\E703.ico"
;创建界面
Gui, Add, CheckBox, x0 y0 vcomp w120 h20 Checked, 我的电脑中新增
Gui, Add, CheckBox, xp+130 y0 vdesk w120 h20 Checked, 桌面中新增
Gui, Add, Text, x0 yp+20 w40 h20 , 名称:
Gui, Add, Edit, x50 yp w280 h20 viname,
Gui, Add, Button, x330 yp w80 h20 gapply, 新增
Gui, Add, Button, x410 yp w40 h20 ghelp, ？
Gui, Add, Text, x0 yp+20 w40 h20, 图标:
Gui, Add, Edit, x50 yp w360 h20 viicon gshowicon,
Gui, Add, Button, x410 yp w40 h20 gselectico, 浏览
Gui, Add, Text, x0 yp+20 w40 h20, 目标:
Gui, Add, Edit, x50 yp w360 h20 vitargetfile,
Gui, Add, Button, x410 yp w40 h20 gselectexe, 浏览
Gui, Add, Text, x0 yp+20 w40 h20, 描述:
Gui, Add, Edit, x50 yp w360 h20 viTileInfo,
Gui, Add, Text, x0 yp+20 w40 h20, 提示:
Gui, Add, Edit, x50 yp w360 h20 viInfoTip,

Gui, Add, Text, x0 yp+30 w180 h20 vmenustatetxt, 右键菜单(可选, 现为空)
Gui, Add, text, x0 yp+20 w40 h20 , 菜单:
Gui, add, Edit, x50 yp w100 h20 vmenu_name,
Gui, Add, text, xp+110 yp w40 h20 , 图标:
Gui, add, Edit, xp+40 yp w120 h20 vmenu_icon,
Gui, Add, CheckBox, xp+130 yp vsep w120 h20, 菜单后添加分隔符

Gui, Add, text, x0 yp+20 w40 h20 , 命令行
Gui, add, Edit, x50 yp w360 h20 vmenu_cmd,
Gui, Add, Button, xp+360 yp w40 h20 gadd, 添加
Gui, add, ListView, x0 yp+20 w450 h160 vmylist1, id|是否默认|菜单名|命令|子键名|带分隔符

Gui, Add, Text, x0 yp+180 w50 h20, 已有项目
Gui, add, ListView, x0 yp+20 w450 h160 Checked vmylist2 AltSubmit gEditItem, id|名称|命令|clsid|注册表来源
Gui, Add, Button, x460 yp w60 h20 gLoadSystemItem, 刷新
Gui, Add, Button, x460 yp+40 w60 h20 gdelicon, 删除
Gui Add, Text, x460 yp+30 w80 h2 +0x10
Gui, Add, Button, x460 yp+10 w60 h20 ggreg1, 我的电脑
Gui, Add, Button, x460 yp+20 w60 h20 ggreg4, HKLM
Gui, Add, Button, x460 yp+20 w60 h20 ggreg3, 桌面
Gui, Add, Button, x460 yp+20 w60 h20 ggreg2, CLSID

Gui, Add, Picture, x460 y10 w64 h64 vsico,

Gui, Show, , 我的电脑/桌面添加新图标
;初始化
option := object()
option["index"] := 0
gosub LoadSystemItem
Return

add:
Gui, ListView, MyList1
if !option["index"]
{
  LV_Delete()
}
gui, submit, nohide ;获取表单
if (menu_name and menu_cmd) ;已经填写
{
	option["index"]++
  menunum := option["index"]
  GuiControl, , menustatetxt, 右键菜单(可选, 现有 %menunum% 个菜单)
	Default = 否
	MsgBox, 36, 提示, 是否设为默认项？默认项会处于菜单顶部
	IfMsgBox, Yes
	{
		option["default"] := menunum
		Default := "是"
		loop % LV_GetCount() ;覆盖lv的显示
		{
      LV_Modify(A_index, , , "否")
		}
	}
  ;msgbox % option["default"]
	;键值是个数组
	option[option["index"]] := object()
	option[option["index"]]["name"] := menu_name
	option[option["index"]]["cmd"] := menu_cmd
  option[option["index"]]["sep"] := sep
  option[option["index"]]["icon"] := menu_icon
	LV_Add("", menunum, default, menu_name, menu_cmd, "n_" menunum, sep) ;添加到列表 列表只是显示 执行从数组走
	LV_ModifyCol() ;调整列宽
	;清空填写框
	GuiControl, , menu_name,
	GuiControl, , menu_cmd,
  GuiControl, , menu_icon,
  GuiControl, , sep, 0
}
Return

apply:
gui, submit, nohide
if (iname and iicon)
{
	Random, n5, 10000, 99999
	clsid = {FD4DF9E0-E3DE-11CE-BFCF-ABCD1DE%n5%} ;随机CLSID
	;if (A_Is64bitOS && (!InStr(A_OSType,"WIN_2003") or !InStr(A_OSType,"WIN_XP") or !InStr(A_OSType,"WIN_2000"))) ;是新版64位系统
	;	item = Software\Classes\Wow6432Node\CLSID\%clsid%
	;Else
		item = Software\Classes\CLSID\%clsid%
	;创建具体的CLSID项
	RegWrite, REG_SZ, HKCU, %item%, , %iname%    ; 显示名称
  iInfoTip := !iInfoTip?"右键查看具体项目":iInfoTip
  RegWrite, REG_SZ, HKCU, %item%, InfoTip, %iInfoTip%    ; 悬停提示
  RegWrite, REG_SZ, HKCU, %item%, LocalizedString, %iname%
  iTileInfo := !TileInfo?iname:iTileInfo
	RegWrite, REG_SZ, HKCU, %item%, System.ItemAuthors, %iTileInfo%
	RegWrite, REG_SZ, HKCU, %item%, TileInfo, prop:System.ItemAuthors
	RegWrite, REG_SZ, HKCU, %item%\DefaultIcon, , %iicon% ;图标
	RegWrite, REG_SZ, HKCU, %item%\InprocServer32, , %SystemRoot%\system32\shdocvw.dll
	RegWrite, REG_SZ, HKCU, %item%\InprocServer32, ThreadingModel, Apartment

  if !option["index"]
  {
    RegWrite, REG_SZ, HKCU, %item%\Shell\Open\Command,, %itargetfile%
  }
	;循环添加菜单
	Loop % option["index"]
	{
    mname := option[A_index]["name"]
    mcmd := option[A_index]["cmd"]
    if (option["default"] = A_index)
      RegWrite, REG_SZ, HKCU, %item%\Shell, , n_%A_Index%
    ;msgbox % option["default"] " | " A_index
    RegWrite, REG_SZ, HKCU, %item%\Shell\n_%A_Index%, , %mname% ;名称
    RegWrite, REG_SZ, HKCU, %item%\Shell\n_%A_Index%\Command, , %mcmd% ;命令
    if option[A_index]["sep"]
      RegWrite, REG_SZ, HKCU, %item%\Shell\n_%A_Index%, SeparatorAfter
    if option[A_index]["icon"]
       RegWrite, REG_SZ, HKCU, %item%\Shell\n_%A_Index%, icon, % option[A_index]["icon"]
	}
	;RegWrite, REG_BINARY, HKCU, %item%, Attributes, 00000000 ;属性
  if comp
    RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%clsid%,, %iname% ;添加到我的电脑
  if desk
    RegWrite, REG_SZ, HKCU, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\%clsid%,, %iname% ;添加到桌面
}
;清空所有填写
GuiControl, , menu_name,
GuiControl, , menu_cmd,
GuiControl, , iname,
;GuiControl, , sico,
GuiControl, , iTileInfo,
GuiControl, , iInfoTip,
GuiControl, , itargetfile,
GuiControl, , iicon,

Gui, ListView, MyList1
LV_Delete()
option := object()
option["index"] := 0
GuiControl, , menustatetxt, 右键菜单(可选, 现为空)

gosub LoadSystemItem
RefreshExplorer()
Return

selectico:
gui +owndialogs
fileselectfile, icon, 1, %lastdir%, 打开---图标文件, 图标文件(*.ico; *.exe; *.dll)
if icon =
	Return
GuiControl, , iicon, %icon%
;guicontrol, , sico, %icon%
Return

showicon:
gui, submit, nohide

Array := StrSplit(iicon, ",")
	if (Array[2] < 0)
	{
		Icon_index := IndexOfIconResource(ExpandEnvVars(Array[1]), abs(Array[2]))
		;msgbox % Icon_index
	}
	else
		Icon_index := Array[2] + 1
GuiControl,, sico, % Array[1] ? "*Icon" Icon_index " " Array[1] : "*Icon0" " " iicon
return

help:
MsgBox, 4128, 帮助, “名称”为在我的电脑和桌面新图标显示的名称`n“图标”为在我的电脑和桌面显示的图标`n“目标”为双击图标时执行的文件`n“菜单”是右键菜单中的项目名，可以使用“(&e)”这种快捷键`n“命令行”为点击菜单时执行的命令。, 20
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

;MenuHandler:
;return

GuiClose:
ExitApp

selectexe:
gui +owndialogs
fileselectfile, exe, 1, %lastdir%, 打开---可执行文件, 可执行文件(*.exe)
if exe =
	Return
GuiControl, , itargetfile, %exe%
return

greg1:
Gui, ListView, MyList2
RF := LV_GetNext("F")
if RF
{
	LV_GetText(lclsid, RF, 4)
}
KeyName := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\" lclsid
f_OpenReg(KeyName)
return

greg4:
Gui, ListView, MyList2
RF := LV_GetNext("F")
if RF
{
	LV_GetText(lclsid, RF, 4)
}
KeyName := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\" lclsid
f_OpenReg(KeyName)
return

greg3:
Gui, ListView, MyList2
RF := LV_GetNext("F")
if RF
{
	LV_GetText(lclsid, RF, 4)
}
KeyName := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\" lclsid
f_OpenReg(KeyName)
return

greg2:
Gui, ListView, MyList2
RF := LV_GetNext("F")
if RF
{
	LV_GetText(lclsid, RF, 4)
}
KeyName := "HKCU\Software\Classes\CLSID\" lclsid
f_OpenReg(KeyName)
return

delicon:
Gui, ListView, MyList2
RF := LV_GetNext("F")
IsChecked := 0
if RF
{
	LV_GetText(lclsid, RF, 4)
  SendMessage, 0x102C, RF - 1, 0xF000, SysListView322  ; 0x102C 为 LVM_GETITEMSTATE. 0xF000 为 LVIS_STATEIMAGEMASK.
  IsChecked := (ErrorLevel >> 12) - 1  ; 如果 RowNumber 为选中的则设置 IsChecked 为真, 否则为假.
}
if lclsid && IsChecked
{
  RegDelete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%lclsid%
  RegDelete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\%lclsid%
  RegDelete HKEY_CURRENT_USER\Software\Classes\CLSID\%lclsid%
  gosub LoadSystemItem
}
return

f_OpenReg(RegPath)
{
	RegPath:=LTrim(RegPath, "[")
	RegPath:=RTrim(RegPath, "]")
	StringLeft, RegPathFirst4, RegPath, 4
	if RegPathFirst4 = HKCR
		StringReplace, RegPath, RegPath, HKCR, HKEY_CLASSES_ROOT
	else if RegPathFirst4 = HKCU
		StringReplace, RegPath, RegPath, HKCU, HKEY_CURRENT_USER
	else if RegPathFirst4 = HKLM
		StringReplace, RegPath, RegPath, HKLM, HKEY_LOCAL_MACHINE
	else if RegPathFirst4 = HKCC
		StringReplace, RegPath, RegPath, HKCC, HKEY_CURRENT_CONFIG
	else if RegPathFirst4 = HKU
		StringReplace, RegPath, RegPath, HKU, HKEY_USERS

	; 将字串中的前两个"＿"(全角) 替换为“_"(半角)
	StringReplace, RegPath, RegPath, ＿, _
	StringReplace, RegPath, RegPath, ＿, _
	; 替换字串中第一个“, ”为"\"
	StringReplace, RegPath, RegPath, `,%A_Space%, \
	; 替换字串中第一个“,”为"\"
	StringReplace, RegPath, RegPath, `,, \
	; 将字串中的所有"/" 替换为“\"
	StringReplace, RegPath, RegPath, /, \, All
	; 将字串中的所有"／"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ／, \, All
	; 将字串中的所有"＼"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ＼, \, All
	StringReplace, RegPath, RegPath, %A_Space%\, \, All
	StringReplace, RegPath, RegPath, \%A_Space%, \, All
	; 将字串中的所有“\\”替换为“\”
	StringReplace, RegPath, RegPath, \\, \, All

	RegRead, MyComputer, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey
	f_Split2(MyComputer, "\", MyComputer, aaa)
	MyComputer := MyComputer ? MyComputer : (A_OSVersion="WIN_XP")?"我的电脑":"计算机"
	IfNotInString, RegPath, %MyComputer%\
		RegPath := MyComputer "\" RegPath
	;tooltip % RegPath

	IfWinExist, ahk_class RegEdit_RegEdit
	{
		RunWait, % "cmd.exe /c taskkill /IM regedit.exe", , Hide
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe
	}
	Else
	{
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe ;-m
	}
return
}

f_Split2(String, Seperator, ByRef LeftStr, ByRef RightStr)
{
	SplitPos := InStr(String, Seperator)
	if SplitPos = 0 ; Seperator not found, L = Str, R = ""
	{
		LeftStr := String
		RightStr:= ""
	}
	else
	{
		SplitPos--
		StringLeft, LeftStr, String, %SplitPos%
		SplitPos++
		StringTrimLeft, RightStr, String, %SplitPos%
	}
	return
}

LoadSystemItem:
;Critical On
LoadLV_dis_Label := 1
sleep 100
Gui, ListView, MyList2
LV_Delete()

B_index := 0
Loop, Reg, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace, K
{
  RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%A_LoopRegName%
  if !OutputVar
    RegRead, OutputVar, HKCU\Software\Classes\CLSID\%A_LoopRegName%
  if OutputVar
  {
    B_index ++
    RegRead, OutputVar2, HKCU\Software\Classes\CLSID\%A_LoopRegName%\Shell\Open\Command
    LV_Add("Check", B_index, OutputVar, OutputVar2, A_LoopRegName, "我的电脑")
  }
}
Loop, Reg, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpaceDisabled, K
{
  RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpaceDisabled\%A_LoopRegName%
  if !OutputVar
    RegRead, OutputVar, HKCU\Software\Classes\CLSID\%A_LoopRegName%
  if OutputVar
  {
    B_index ++
    RegRead, OutputVar2, HKCU\Software\Classes\CLSID\%A_LoopRegName%\Shell\Open\Command
    LV_Add("", B_index, OutputVar, OutputVar2, A_LoopRegName, "我的电脑")
  }
}
Loop, Reg, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace, K
{
  RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\%A_LoopRegName%
  if !OutputVar
    RegRead, OutputVar, HKCU\Software\Classes\CLSID\%A_LoopRegName%
  if OutputVar
  {
    B_index ++
    RegRead, OutputVar2, HKCU\Software\Classes\CLSID\%A_LoopRegName%\Shell\Open\Command
    LV_Add("Check", B_index, OutputVar, OutputVar2, A_LoopRegName, "桌面")
  }
}
Loop, Reg, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpaceDisabled, K
{
  RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpaceDisabled\%A_LoopRegName%
  if !OutputVar
    RegRead, OutputVar, HKCU\Software\Classes\CLSID\%A_LoopRegName%
  if OutputVar
  {
    B_index ++
    RegRead, OutputVar2, HKCU\Software\Classes\CLSID\%A_LoopRegName%\Shell\Open\Command
    LV_Add("", B_index, OutputVar, OutputVar2, A_LoopRegName, "桌面")
  }
}
Loop, Reg, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace, K
{
  RegRead, OutputVar, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%A_LoopRegName%
  if !OutputVar
    RegRead, OutputVar, HKCU\Software\Classes\CLSID\%A_LoopRegName%
  if OutputVar
  {
    B_index ++
    RegRead, OutputVar2, HKCU\Software\Classes\CLSID\%A_LoopRegName%\Shell\Open\Command
    LV_Add("Check", B_index, OutputVar, OutputVar2, A_LoopRegName, "HKLM")
  }
}
Loop, Reg, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpaceDisabled, K
{
  RegRead, OutputVar, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpaceDisabled\%A_LoopRegName%
  if !OutputVar
    RegRead, OutputVar, HKCU\Software\Classes\CLSID\%A_LoopRegName%
  if OutputVar
  {
    B_index ++
    RegRead, OutputVar2, HKCU\Software\Classes\CLSID\%A_LoopRegName%\Shell\Open\Command
    LV_Add("", B_index, OutputVar, OutputVar2, A_LoopRegName, "HKLM")
  }
}

LV_ModifyCol()
settimer setlvdisvalue, -1500
;LoadLV_dis_Label := 0
;Critical off
;GuiControl, Focus, Button3
;tooltip % ErrorLevel
return

EditItem:
Gui, ListView, MyList2
if (A_GuiEvent = "DoubleClick")
{
	RF := LV_GetNext("F")
	if RF
	{
		LV_GetText(lclsid, RF, 4)
		LV_GetText(lname, RF, 2)
		GuiControl,, iname, % lname
		SetGuiValue(lclsid)
	}
}
if (A_GuiEvent = "I") && (ErrorLevel = "C") && !LoadLV_dis_Label
{
	LV_GetText(lclsid, A_EventInfo, 4)
	LV_GetText(regaddr, A_EventInfo, 5)
  ;msgbox % regaddr "|" LoadLV_dis_Label "|" A_GuiControl "|" ErrorLevel
	if (ErrorLevel == "c") && lclsid
	{
    if (regaddr = "我的电脑")
    {
      RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%lclsid%
      RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpaceDisabled\%lclsid%, , %OutputVar%
      RegDelete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%lclsid%
    }
    else if (regaddr = "桌面")
    {
      RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\%lclsid%
      RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpaceDisabled\%lclsid%, , %OutputVar%
      RegDelete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\%lclsid%
    }
    else if (regaddr = "HKLM")
    {
      RegRead, OutputVar, HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%lclsid%
      RegWrite, REG_SZ, HKLM, Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpaceDisabled\%lclsid%, , %OutputVar%
      RegDelete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%lclsid%
    }
	}
	if (ErrorLevel == "C") && lclsid
	{
		if (regaddr = "我的电脑")
    {
      RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpaceDisabled\%lclsid%
      RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%lclsid%, , %OutputVar%
      RegDelete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpaceDisabled\%lclsid%
    }
    else if (regaddr = "桌面")
    {
      RegRead, OutputVar, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpaceDisabled\%lclsid%
      RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\%lclsid%, , %OutputVar%
      RegDelete HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpaceDisabled\%lclsid%
    }
    else if (regaddr = "HKLM")
    {
      RegRead, OutputVar, HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpaceDisabled\%lclsid%
      RegWrite, REG_SZ, HKLM, Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%lclsid%, , %OutputVar%
      RegDelete HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpaceDisabled\%lclsid%
    }
	}
  RefreshExplorer()
}
return

setlvdisvalue:
LoadLV_dis_Label := 0
tooltip 可勾选已有项目已进行激活或禁用!
sleep 2000
tooltip
return

SetGuiValue(hclsid)
{
  RegRead, rInfoTip, HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\%hclsid%, InfoTip
  RegRead, rTileInfo, HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\%hclsid%, System.ItemAuthors
  RegRead, ricon, HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\%hclsid%\DefaultIcon
  ;RegRead, rInfoTip, HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\%hclsid%, InfoTip
  ;MsgBox % rInfoTip
  RegRead, rdefaultitem, HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\%hclsid%\Shell
  if !rdefaultitem
  {
    RegRead, rtargetfile, HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\%hclsid%\Shell\Open\Command
  }
  Else
  {
    RegRead, rtargetfile, HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\%hclsid%\Shell\%rdefaultitem%\Command
  }
  ;MsgBox % rtargetfile
  GuiControl, , iInfoTip, % rInfoTip
  GuiControl, , iTileInfo, % rTileInfo
  GuiControl, , iicon, % ricon
  GuiControl, , itargetfile, % rtargetfile

  Gui, ListView, MyList1
  LV_Delete()
  Loop, Reg, HKEY_CURRENT_USER\SOFTWARE\Classes\CLSID\%hclsid%\Shell, K
  {
    if A_LoopRegName
    {
      RegRead, OutputVar, HKCU\Software\Classes\CLSID\%hclsid%\Shell\%A_LoopRegName%
      RegRead, OutputVar2, HKCU\Software\Classes\CLSID\%hclsid%\Shell\%A_LoopRegName%\Command
      RegRead, OutputVar3, HKCU\Software\Classes\CLSID\%hclsid%\Shell\%A_LoopRegName%, SeparatorAfter
      if errorlevel
        OutputVar3 := 0
      else
        OutputVar3 := 1
      LV_Add("", A_Index, (A_LoopRegName=rdefaultitem)?"是":!rdefaultitem?"是":"否", OutputVar, OutputVar2, A_LoopRegName, OutputVar3)
    }
  }
  LV_ModifyCol()
  return
}

ExpandEnvVars(string){
   ; Find length of dest string:
   nSize := DllCall("ExpandEnvironmentStrings", "Str", string, "Str", NULL, "UInt", 0, "UInt")
  ,VarSetCapacity(Dest, size := (nSize * (1 << !!A_IsUnicode)) + !A_IsUnicode) ; allocate dest string
  ,DllCall("ExpandEnvironmentStrings", "Str", string, "Str", Dest, "UInt", size, "UInt") ; fill dest string
   return Dest
}

IndexOfIconResource(Filename, ID)
{
    hmod := DllCall("GetModuleHandle", "str", Filename, "ptr")
    ; If the DLL isn't already loaded, load it as a data file.
    loaded := !hmod
        && hmod := DllCall("LoadLibraryEx", "str", Filename, "ptr", 0, "uint", 0x2, "ptr")
    
    enumproc := RegisterCallback("IndexOfIconResource_EnumIconResources","F")
    param := {ID: ID, index: 0, result: 0}
    
    ; Enumerate the icon group resources. (RT_GROUP_ICON=14)
    DllCall("EnumResourceNames", "ptr", hmod, "ptr", 14, "ptr", enumproc, "ptr", &param)
    DllCall("GlobalFree", "ptr", enumproc)
    
    ; If we loaded the DLL, free it now.
    if loaded
        DllCall("FreeLibrary", "ptr", hmod)
    
    return param.result
}

IndexOfIconResource_EnumIconResources(hModule, lpszType, lpszName, lParam)
{
    param := Object(lParam)
    param.index += 1

    if (lpszName = param.ID)
    {
        param.result := param.index
        return false    ; break
    }
    return true
}

RefreshExplorer()
{ ; by teadrinker on D437 @ tiny.cc/refreshexplorer
	local Windows := ComObjCreate("Shell.Application").Windows
	Windows.Item(ComObject(0x13, 8)).Refresh()
	for Window in Windows
		if (Window.Name != "Internet Explorer")
			Window.Refresh()
}