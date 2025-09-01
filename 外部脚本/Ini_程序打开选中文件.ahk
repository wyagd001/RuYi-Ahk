;|2.9|2024.01.08|1213
#Include <Ruyi>
CandySel := A_Args[1]
IniMenuInifile := A_ScriptDir "\..\配置文件\外部脚本\Ini_收藏夹.ini"
if !fileexist(IniMenuInifile)
  FileCopy % A_ScriptDir "\..\..\配置文件\外部脚本\Ini_收藏夹_默认配置.ini", % IniMenuInifile
IniMenuobj := ini2obj(IniMenuInifile)
show_openwith(IniMenuobj["程序"])
return

show_openwith(obj, menu_name := ""){
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
		Sub_menu := GetStringIndex(v, 2)
		Menu, % menu_name, add, % Sub_menu, Menuopenwith
	}
	if main = 1
		menu,% menu_name, show
	return
}

Menuopenwith:
Candy_Cmd := IniMenuobj["程序"][A_ThisMenuItemPos]
Candy_Cmd := GetStringIndex(Candy_Cmd, 1)
run %Candy_Cmd% %CandySel%,, UseErrorLevel
return