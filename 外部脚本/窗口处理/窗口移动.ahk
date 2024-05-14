;|2.6|2024.05.05|1033,1034
Windy_CurWin_id := A_Args[1]
CandySel := A_Args[2]
if !Windy_CurWin_id
{
	DetectHiddenWindows, On
	WinGetTitle, h_hwnd, 获取当前窗口信息
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
	if !Windy_CurWin_id
		Windy_CurWin_id := WinExist("A")
	if !Windy_CurWin_id
		exitapp
}
SysGet, OutputVar, MonitorWorkArea

if (CandySel = "垂直最大化")
	CF_WinMove(Windy_CurWin_id,, 0,, OutputVarBottom)
if (CandySel = "水平最大化")
	CF_WinMove(Windy_CurWin_id, 0,, OutputVarRight)

CF_WinMove(Win, x:="", y:="", w:="", h:="")
{
	WinMove, ahk_id %win%,, x, y, w, h
}