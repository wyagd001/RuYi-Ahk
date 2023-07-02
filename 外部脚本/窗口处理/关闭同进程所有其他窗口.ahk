;|2.0|2023.07.01|1325
Windy_CurWin_id := A_Args[1]
if !Windy_CurWin_id
{
	DetectHiddenWindows, On
	WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
	DetectHiddenWindows, Off
}

WinGet, Windy_CurWin_Fullpath, ProcessPath, Ahk_ID %Windy_CurWin_id%           ;  当前窗口的进程路径
SplitPath, Windy_CurWin_Fullpath, Windy_CurWin_ProcName, Windy_CurWin_ParentPath,, Windy_CurWin_ProcNameNoExt
WinGet, OutWinidList, List, % "ahk_exe " Windy_CurWin_ProcName
loop %OutWinidList%
{
	id := OutWinidList%A_Index%
	WinGet, style, style, ahk_id %id%
	if !(style & 0xC00000) or !(Style & 0x10000)
		continue
	if (id !=Windy_CurWin_id)
		WinClose, % "ahk_id " id
}
exitapp