RuYi_GetRuYiDir()
{
  if FileExist(A_ScriptDir "\如一.exe")
    return A_ScriptDir
  if FileExist(A_ScriptDir "\..\如一.exe")
    return GetFullPathName(A_ScriptDir "\..")
  else if FileExist(A_ScriptDir "\..\..\如一.exe")
    return GetFullPathName(A_ScriptDir "\..\..")
  else if FileExist(A_ScriptDir "\..\..\..\如一.exe")
    return GetFullPathName(A_ScriptDir "\..\..\..")
  else if FileExist(A_ScriptDir "\..\..\..\..\如一.exe")
    return GetFullPathName(A_ScriptDir "\..\..\..\..")
  else if FileExist(A_ScriptDir "\..\..\..\..\..\如一.exe")
    return GetFullPathName(A_ScriptDir "\..\..\..\..\..")
}

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}

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

ExecSendToRuyi(ByRef StringToSend := "", Title := "如一 ahk_class AutoHotkey", wParam := 0, Msg := 0x4a) {
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)

	DetectHiddenWindows, On
	if Title is integer
	{
		SendMessage, Msg, wParam, &CopyDataStruct,, ahk_id %Title%
		;msgbox % ErrorLevel  "qq"
	}
	else if Title is not integer
	{
		SetTitleMatchMode 2
		sendMessage, Msg, wParam, &CopyDataStruct,, %Title%
	}
	DetectHiddenWindows, Off
  return ErrorLevel
}

Deref(String)
{
    spo := 1
    out := ""
    while (fpo:=RegexMatch(String, "(%(.*?)%)|``(.)", m, spo))
    {
        out .= SubStr(String, spo, fpo-spo)
        spo := fpo + StrLen(m)
        if (m1)
            out .= %m2%
        else switch (m3)
        {
            case "a": out .= "`a"
            case "b": out .= "`b"
            case "f": out .= "`f"
            case "n": out .= "`n"
            case "r": out .= "`r"
            case "t": out .= "`t"
            case "v": out .= "`v"
            default: out .= m3
        }
    }
    return out SubStr(String, spo)
}

GetSelText(returntype := 1, ByRef _isFile := "", ByRef _ClipAll := "", waittime := 0.5)
{
	global clipmonitor
	clipmonitor := (returntype = 0) ? 1 : 0
	BackUp_ClipBoard := ClipboardAll    ; 备份剪贴板
	Clipboard =    ; 清空剪贴板
	Send, ^c
	sleep 100
	ClipWait, % waittime
	If(ErrorLevel) ; 如果粘贴板里面没有内容，则还原剪贴板
	{
		Clipboard := BackUp_ClipBoard
		sleep 100
		clipmonitor := 1
	Return
	}
	If(returntype = 0)
	Return Clipboard
	else If(returntype=1)
		_isFile := _ClipAll := ""
	else
	{
		_isFile := DllCall("IsClipboardFormatAvailable", "UInt", 15) ; 是否是文件类型
		_ClipAll := ClipboardAll
	}
	ClipSel := Clipboard

	Clipboard := BackUp_ClipBoard  ; 还原粘贴板
	sleep 200
	clipmonitor := 1
	return ClipSel
}