;|2.4|2023.09.20|1506
CandySel := A_Args[1]
Windy_CurWin_Id := A_Args[2]

if !Windy_CurWin_Id
{
	DetectHiddenWindows, On
	WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
}

if !CandySel
{
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}

整理数字序号:
if !CandySel
{
	WinActivate, ahk_id %Windy_CurWin_id%
	Send ^a
	sleep 20
	Send ^x
	sleep 20
	CandySel := Clipboard
}
newStr := ""

Loop, Parse, CandySel, `n, `r
{
	RegExMatch(A_LoopField, "^\s*(\d+)", FirstLineNum)
	break
}
b_index := FirstLineNum - 1
xhw := 0
if (instr(b_index,  "0") = 1)
	xhw := strlen(b_index)
Loop, Parse, CandySel, `n, `r
{
	RegExMatch(A_LoopField, "^\s*(\d+)", LineNum)
	if LineNum
		b_index ++
	else
	{
		NewStr .= A_LoopField "`r`n"
		continue
	}
	if xhw
	{
		NewStr .= RegExReplace(A_LoopField, "^(\s*)(\d+)(.*)$", "$1" Format("{:" xhw "}", b_index) "$3") "`r`n"
	}
	Else
	{
		NewStr .= RegExReplace(A_LoopField, "^(\s*)(\d+)(.*)$", "$1" b_index "$3") "`r`n"
	}
}

Clipboard := newStr
WinActivate, ahk_id %Windy_CurWin_id%
Send ^v
newStr := CandySel := ""
return