; 1213
CandySel := A_Args[1]
IniMenuInifile := A_ScriptDir "\..\配置文件\外部脚本\ini菜单.ini"
IniMenuobj := ini2obj(IniMenuInifile)
show_openwith(IniMenuobj["程序"])
return

ini2obj(file){
	iniobj := {}
	FileRead, filecontent, %file% ;加载文件到变量
	StringReplace, filecontent, filecontent, `r, , All
	StringSplit, line, filecontent, `n, , ;用函数分割变量为伪数组
	Loop ;循环
	{
		if A_Index > %line0%
			Break
		content = % line%A_Index% ;赋值当前行
		FSection := RegExMatch(content, "\[.*\]") ;正则表达式匹配section
		if FSection = 1 ;如果找到
		{
			TSection := RegExReplace(content, "\[(.*)\]", "$1") ;正则替换并赋值临时section $为向后引用
			iniobj[TSection] := {}
		}
		Else
		{
			FKey := RegExMatch(content, "^.*=.*") ;正则表达式匹配key
			if FKey
			{
				TKey := RegExReplace(content, "^(.*?)=.*", "$1") ;正则替换并赋值临时key
				StringReplace, TKey, TKey, ., _, All
				TValue := RegExReplace(content, "^.*?=(.*)", "$1") ;正则替换并赋值临时value
				if TKey
					iniobj[TSection][TKey] := TValue
			}
		}
	}
Return iniobj
}

obj2ini(obj, file){
	if (!isobject(obj) or !file)
		Return 0
	for k,v in obj
	{
		for key,value in v
		{
			IniWrite, %value%, %file%, %k%, %key%
			;fileappend %key%-%value%`n, %A_desktop%\123.txt
		}
	}
Return 1
}

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
Candy_Cmd := GetStringIndex(Candy_Cmd)
run %Candy_Cmd% %CandySel%,, UseErrorLevel
return

GetStringIndex(String, Index := 1)
{
	arrCandy_Cmd_Str := StrSplit(String, "|", " `t")
	NewStr := arrCandy_Cmd_Str[Index]
	return NewStr
}