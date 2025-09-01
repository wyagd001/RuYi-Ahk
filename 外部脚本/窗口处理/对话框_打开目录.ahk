;|2.9|2024.01.08|1226
#Include <Ruyi>
#Include <OpenedFolder>
Menu, Tray, UseErrorLevel
Windy_CurWin_id := A_Args[1]

Windo_对话框打开目录:
IniMenuInifile := A_ScriptDir "\..\..\配置文件\外部脚本\Ini_收藏夹.ini"
if !fileexist(IniMenuInifile)
  FileCopy % A_ScriptDir "\..\..\配置文件\外部脚本\Ini_收藏夹_默认配置.ini", % IniMenuInifile
IniMenuobj := ini2obj(IniMenuInifile)
AllOpenFolder := GetAllWindowOpenFolder()

Menu, JumpToFavFolder, DeleteAll
Menu JumpToFavFolder, add, 添加文件夹到收藏夹, Add_JumpToFolder
Menu JumpToFavFolder, add
for k,v in IniMenuobj["对话框"]
{
	SubMenuName := GetStringIndex(v, 1)
	Menu JumpToFavFolder, add, %SubMenuName%, Windo_JumpToFolder
}
Menu DialogMenu, Add, 收藏的文件夹, :JumpToFavFolder

if isobject(IniMenuobj["对话框_子文件夹"])
{
  Menu, JumpToFavFolder2, add
  Menu, JumpToFavFolder2, DeleteAll
  Menu, JumpToFavFolder2, add, 添加当前路径到收藏夹, Add_JumpToFolder
  Menu, JumpToFavFolder2, add
  for k,v in IniMenuobj["对话框_子文件夹"]
  {
    Menu, JumpToFavFolder2, add, % GetStringIndex(v, 1), Windo_JumpToFolder
  }
}
menu, DialogMenu, add, 子文件夹, :JumpToFavFolder2
Menu DialogMenu, Add

Menu DialogMenu, Add, ▼▼跳转到打开的文件夹▼▼, nul
Menu, DialogMenu, Disable, ▼▼跳转到打开的文件夹▼▼
Menu DialogMenu, Add
for k, v in AllOpenFolder
{
	Menu DialogMenu, add, %v%, Windo_JumpToFolder
}
Menu DialogMenu, add, %A_desktop%, Windo_JumpToFolder
Menu DialogMenu, Show
Menu, DialogMenu, DeleteAll
return

Windo_JumpToFolder:
ControlSetText, edit1, %A_ThisMenuItem%, Ahk_ID %Windy_CurWin_id%
ControlSend, edit1, {Enter}, Ahk_ID %Windy_CurWin_id%
return

nul:
return

Add_JumpToFolder:
Gui addtoDialog:Destroy
Gui addtoDialog:Default
gui, add, Text, x10 y10, 新添加文件夹:
gui, add, Edit, xp+90 yp w400 vmypath, 
gui, add, Text, x10 yp+30, 新添加菜单名:
gui, add, Edit, xp+90 yp w400 vmymenu,
gui, add, Button, x380 yp+30 w50 gaddtoDialog_ok, 确定
gui, add, Button, xp+60 yp w50 gaddtoDialog_cancel, 取消
gui, show, , 将文件夹添加到收藏夹
return

addtoDialog_ok:
Gui addtoDialog: Default 
Gui, Submit, NoHide
if fileexist(mypath)
{
  R_index := IniMenuobj["对话框"].Count()+1
  IniMenuobj["对话框"][R_index] := mypath "|" mymenu
  obj2ini(IniMenuobj, IniMenuInifile)
  Gui addtoDialog: Destroy
}
else
{
  CF_ToolTip("文件夹不存在, 无法添加到收藏夹", 4000)
}
return

addtoDialog_cancel:
Gui addtoDialog: Destroy
return