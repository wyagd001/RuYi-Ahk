;|3.0|2025.08.31|1732
#SingleInstance Force

CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}

SplitPath, CandySel, IniFileName, IniFolder
customactionsettingobj := ini2obj(CandySel)
actionobj := {}
for k,v in customactionsettingobj["Name"]  ; 自定义的动作
{
	actionobj[k] := {}
	arrCandy_Cmd_Str := StrSplit(v, "|", " `t")
	actionobj[k]["图标"] := arrCandy_Cmd_Str[1]
	actionobj[k]["名称"] := arrCandy_Cmd_Str[2]
	actionobj[k]["对象"] := arrCandy_Cmd_Str[3]
	actionobj[k]["说明"] := arrCandy_Cmd_Str[4]
	actionobj[k]["内容"] := customactionsettingobj["action"][k]
	actionobj[k]["ATA内置"] := GetStringIndex(v, 5) = 1 ? 1 : 0    ; ATA 是否内置, 不使用自定义内置中的设置值
	actionobj[k]["外部脚本"] := arrCandy_Cmd_Str[6] = 1 ? 1 : 0
	actionobj[k]["脚本优先"] := arrCandy_Cmd_Str[7] = 1 ? 1 : 0
	actionobj[k]["在线帮助"] := GetStringIndex(v, 8) = 1 ? 1 : 0  ; 动作是否有在线帮助, 不使用自定义内置中的设置值
}
FileMove, % CandySel, % CandySel ".old"
obj2ini(actionobj, IniFolder "\自定义动作.ini")
;msgbox % actionobj[5000]["说明"]
return

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

ini2obj(file)
{
	iniobj := {}
	FileRead, filecontent, %file% ;加载文件到变量
	StringReplace, filecontent, filecontent, `r, , All
	StringSplit, line, filecontent, `n, , ;用函数分割变量为伪数组
	Loop ;循环
	{
		if A_Index > %line0%
			Break
		content = % line%A_Index% ; 赋值当前行
		if (instr(content, ";") = 1)  ; 每行第一个字符为 ; 为注释跳过
			continue
		FSection := RegExMatch(content, "\[.*\]") ; 正则表达式匹配 section
		if FSection = 1 ; 如果找到
		{
			TSection := RegExReplace(content, "\[(.*)\]", "$1") ; 正则替换并赋值临时section $为向后引用
			iniobj[TSection] := {}
		}
		Else
		{
			FKey := RegExMatch(content, "^.*=.*")    ;正则表达式匹配key
			if FKey
			{
				TKey := RegExReplace(content, "^(.*?)=.*", "$1")   ; 正则替换并赋值临时key
				;StringReplace, TKey, TKey, ., _, All               ; 会将键中的 "." 自动替换为 "_". 快捷键中有 ., 所以注释掉了
				TValue := RegExReplace(content, "^.*?=(.*)", "$1") ; 正则替换并赋值临时value
				if TKey
					iniobj[TSection][TKey] := TValue
			}
		}
	}
	Return iniobj
}

obj2ini(obj, file, sectionName := "")
{
	if (!isobject(obj) or !file)
		Return 0
	If !fileexist(file)
		fileappend,, %file%, UTF-16
	for k,v in obj
	{
    if (isobject(v))
    {
      for key,value in v              ; 删除的键值不会保存, 但也不会删除, 保持原样
      {
        IniWrite, %value%, %file%, %k%, %key%
        ;fileappend %key%-%value%`n, %A_desktop%\123.txt
      }
    }
    else
    {
      if sectionName
        IniWrite, %v%, %file%, %sectionName%, %k%
    }
	}
  Return 1
}