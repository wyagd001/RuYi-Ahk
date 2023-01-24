; 1151
ComObjError(0)
DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
if Windy_CurWin_id
{
	WinGet Windy_CurWin_Pid, PID, ahk_id %Windy_CurWin_id%
}
else
{
	WinGet Windy_CurWin_Pid, PID, A
}

CMDLine := WMI_Query(Windy_CurWin_Pid)
if CMDLine
clipboard := CMDLine
return

WMI_Query(pid)
{
   wmi :=    ComObjGet("winmgmts:")
    queryEnum := wmi.ExecQuery("" . "Select * from Win32_Process where ProcessId=" . pid)._NewEnum()
    if queryEnum[process]
        sResult.=process.CommandLine
    else
        sResult := 0 
   Return   sResult
}