;|2.9|2025.01.30|1588
#Include <Ruyi>
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
;msgbox % CandySel "11111"
Tmp_Val := Trim(CandySel, " `t`r`n")
;tooltip % Tmp_Val "11111"
;sleep 5000
if !Tmp_Val
{
	return
}
translistfile := A_ScriptDir "\..\..\配置文件\外部脚本\文本处理\一键替换.ini"
if !fileexist(translistfile)
    FileCopy % A_ScriptDir "\..\..\配置文件\外部脚本\文本处理\一键替换_默认配置.ini", % translistfile
translistobj := ini2obj(translistfile)

if WinActive("ahk_class XLMAIN") or WinActive("ahk_class OpusApp")
	translist := translistobj.股票基金
else if Instr(Windy_CurWin_Title, ".htm")
	translist := translistobj.翻译
else
  translist := translistobj.合体字

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
sleep 3000
return