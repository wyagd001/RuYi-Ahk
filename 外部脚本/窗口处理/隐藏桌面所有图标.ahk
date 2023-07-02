;|2.0|2023.07.01|1076
ControlGet, HWND, Hwnd,, SysListView321, ahk_class WorkerW
If HWND =
{
	DetectHiddenWindows On
	ControlGet, HWND, Hwnd,, SysListView321, ahk_class Progman
	DetectHiddenWindows Off
}
If DllCall("IsWindowVisible", UInt, HWND)
	WinHide, ahk_id %HWND%
Else
	WinShow, ahk_id %HWND%
return