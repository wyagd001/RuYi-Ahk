;|2.6|2024.05.01|1588
CandySel := A_Args[1]
Windy_CurWin_Id := A_Args[2]
DetectHiddenWindows, On
if !Windy_CurWin_Id
{
	WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
}

if !CandySel
{
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
}
DetectHiddenWindows, Off
;tooltip % CandySel "11111"
Tmp_Val := Trim(CandySel, " `t`r`n")
;tooltip % Tmp_Val "11111"
;sleep 5000
if !Tmp_Val
{
	return
}
if WinActive("ahk_class XLMAIN") or WinActive("ahk_class OpusApp")
	translist := ini2obj(A_ScriptDir "\..\..\配置文件\外部脚本\一键替换.ini").股票基金
else
	translist := ini2obj(A_ScriptDir "\..\..\配置文件\外部脚本\一键替换.ini").翻译
;tooltip % Tmp_Val
;sleep 5000
for key, value in translist
{
	if (Tmp_Val = key) or (Tmp_Val = key "s")
	{
		if InStr(value, "``r")
		{
			value := SubStr(value,1,-2)
			value := value "`r"
		}
		WinActivate, ahk_id %Windy_CurWin_id%
		Send {text}%value%
		return
	}
}
sleep 5000
return

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
		FSection := RegExMatch(content, "\[.*\]") ;正则表达式匹配section
		if FSection = 1 ;如果找到
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
