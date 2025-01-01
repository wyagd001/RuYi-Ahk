;|2.9|2024.12.31|1226
Menu, Tray, UseErrorLevel
Windy_CurWin_id := A_Args[1]

Windo_对话框打开目录:
IniMenuInifile := A_ScriptDir "\..\..\配置文件\外部脚本\Ini_收藏夹.ini"
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
Menu DialogMenu, Add

Menu DialogMenu, Add, ▼▼跳转到打开的文件夹▼▼, nul
Menu, DialogMenu, Disable, ▼▼跳转到打开的文件夹▼▼
Menu DialogMenu, Add
for k, v in AllOpenFolder
{
	Menu DialogMenu, add, %v%, Windo_JumpToFolder
}

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

ini2obj(file){
	iniobj := {}
	FileRead, filecontent, %file% ;加载文件到变量
	StringReplace, filecontent, filecontent, `r,, All
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

GetAllWindowOpenFolder()
{
	if WinActive("ahk_class TTOTAL_CMD")
	return TC_getTwoPath()

	QtTabBarObj := QtTabBar()
	if QtTabBarObj
	{
		OPenedFolder := QtTabBar_GetAllTabs()
	}
	else
	{
		OPenedFolder := []
		ShellWindows := ComObjCreate("Shell.Application").Windows
		for w in ShellWindows
		{
			Tmp_Fp := w.Document.Folder.Self.path
			if (Tmp_Fp)
				if FileExist(Tmp_Fp)
				{
					OPenedFolder.push(Tmp_Fp)
				}
		}
	}
return OPenedFolder
}

TC_getTwoPath()
{
	DetectHiddenText, On
	WinGetText, TCWindowText, Ahk_class TTOTAL_CMD
	m := RegExMatchAll(TCWindowText, "m)(.*)\\\*\.\*", 1)
	return m
}

QtTabBar()
{
	try QtTabBarObj := ComObjCreate("QTTabBarLib.Scripting")
	if IsObject(QtTabBarObj)
	return 1
	else
	return 0
}

QtTabBar_GetAllTabs()
{
	ScriptCode = 
	(
		OPenedFolder_Str := GetAllWindowOpenFolder()
		FileAppend `% OPenedFolder_Str, *

		GetAllWindowOpenFolder()
		{
			OPenedFolder_Str := ""
			QtTabBarObj := ComObjCreate("QTTabBarLib.Scripting")
			if QtTabBarObj
			{
				for k in QtTabBarObj.Windows
					for w in k.Tabs
					{
						Tmp_Fp := w.path
						if (Tmp_Fp)
							if FileExist(Tmp_Fp)
							{
								OPenedFolder_Str .= Tmp_Fp "``n"
							}
					}
			}
		return OPenedFolder_Str
		}
	)

	OPenedFolder_Str := RunScript(ScriptCode, 1)
	OPenedFolder_Str := Trim(OPenedFolder_Str, " `t`n")
	OPenedFolder := StrSplit(OPenedFolder_Str, "`n")
return OPenedFolder
}

RegExMatchAll(ByRef Haystack, NeedleRegEx, SubPat="")
{
	arr := [], startPos := 1
	while ( pos := RegExMatch(Haystack, NeedleRegEx, match, startPos) )
	{
		arr.push(match%SubPat%)
		startPos := pos + StrLen(match)
	}
	return arr.MaxIndex() ? arr : ""
}

RunScript(script, WaitResult:="false")
{
	static test_ahk := A_AhkPath,
	shell := ComObjCreate("WScript.Shell")
	BackUp_WorkingDir:= A_WorkingDir
	SetWorkingDir %A_ScriptDir%
	exec := shell.Exec(chr(34) test_ahk chr(34) " /ErrorStdOut *")
	exec.StdIn.Write(script)
	exec.StdIn.Close()
	SetWorkingDir %BackUp_WorkingDir%
	if WaitResult
		return exec.StdOut.ReadAll()
	else 
return
}

GetStringIndex(String, Index := "", MaxParts := -1, SplitStr := "|")
{
	arrCandy_Cmd_Str := StrSplit(String, SplitStr, " `t", MaxParts)
	if Index
	{
		NewStr := arrCandy_Cmd_Str[Index]
		return NewStr
	}
	else
		return arrCandy_Cmd_Str
}

CF_ToolTip(tipText, delay := 1000)
{
	ToolTip
	ToolTip, % tipText
	SetTimer, RemoveToolTip, % "-" delay
  return

  RemoveToolTip:
    ToolTip
  return
}