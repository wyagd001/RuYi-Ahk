CandySel := A_Args[1]

DetectHiddenWindows, On
WinGetTitle, h_hwnd, ��ȡ��ǰ������Ϣ
Windy_CurWin_id := StrReplace(h_hwnd, "��ȡ��ǰ������Ϣ_")
if !Windy_CurWin_id
	Windy_CurWin_id := WinExist("A")
if !Windy_CurWin_id
	exitapp
SysGet, OutputVar, MonitorWorkArea

if (CandySel = "��ֱ���")
CF_WinMove(Windy_CurWin_id,, 0,, OutputVarBottom)
if (CandySel = "ˮƽ���")
CF_WinMove(Windy_CurWin_id, 0,, OutputVarRight)


CF_WinMove(Win, x:="", y:="", w:="", h:="")
{
	WinMove, ahk_id %win%,, x, y, w, h
}