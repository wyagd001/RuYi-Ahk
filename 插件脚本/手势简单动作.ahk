;1187
关闭窗口:
;Tooltip % Windy_CurWin_Class
if (Windy_CurWin_Class = "Chrome_WidgetWin_1") or (Windy_CurWin_Class = "360se6_Frame")
{
	WinActivate, Ahk_ID %Windy_CurWin_id%
	sleep 20
	Send ^w
	return
}
if (Windy_CurWin_Class = "Progman") or (Windy_CurWin_Class = "Shell_TrayWnd") or (Windy_CurWin_Class = "WorkerW")
{
	WinClose ahk_class Progman
	return
}
else
	PostMessage, 0x112, 0xF060,,, ahk_id %Windy_CurWin_id%
return

;1188
左半后退:
if (Windy_CurWin_Class = "Chrome_WidgetWin_1") or (Windy_CurWin_Class = "360se6_Frame")
{
	Send {Alt Down}{left}{Alt Up}
	return
}
else
{
	WinGet, state, MinMax, ahk_id %Windy_CurWin_id%
	if (state = 1)
		WinRestore, ahk_id %Windy_CurWin_id%
	WinMove, ahk_id %Windy_CurWin_id%,, 0, 0, WMAwidth / 2, WMAHeight
}
return

右半前进:
if (Windy_CurWin_Class = "Chrome_WidgetWin_1") or (Windy_CurWin_Class = "360se6_Frame")
{
	Send {Alt Down}{right}{Alt Up}
	return
}
else
{
	WinGet, state, MinMax, ahk_id %Windy_CurWin_id%
	if (state = 1)
		WinRestore, ahk_id %Windy_CurWin_id%
	WinMove, ahk_id %Windy_CurWin_id%,, WMAwidth / 2, 0, WMAwidth / 2, WMAHeight
}
return

;1190
窗口最小化:
if (Windy_CurWin_Class = "Progman") or (Windy_CurWin_Class = "Shell_TrayWnd") or (Windy_CurWin_Class = "WorkerW")
{
	WinMinimizeAll
	return
}
else
  WinMinimize, ahk_id %Windy_CurWin_id%
return

;1191
窗口最大化:
if (Windy_CurWin_Class != "Progman") or (Windy_CurWin_Class != "Shell_TrayWnd") or (Windy_CurWin_Class != "WorkerW")
{
  WinMaximize, ahk_id %Windy_CurWin_id%
}
return