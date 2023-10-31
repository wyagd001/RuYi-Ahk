;|2.4|2023.10.06|1171,1172,1360
#SingleInstance force
#include <ImagePut>
CandySel := A_Args[1]
CaptureArea := (A_Args[2] = "") ? 0 : A_Args[2]
WinIdOrDesktopId := (A_Args[3] = "") ? 0 : A_Args[3]
;msgbox % CandySel "-" CaptureArea "-" WinIdOrDeskTopId

if instr(CaptureArea, "|")
{
	Tmp_Arr := StrSplit(CaptureArea,  "|")
	CaptureArea := (Tmp_Arr[1] = "") ? 0 : Tmp_Arr[1]
	WinIdOrDesktopId := (Tmp_Arr[2] = "") ? 0 : Tmp_Arr[2]
	;msgbox % CaptureArea "-" WinIdOrDesktopId
}
if (CaptureArea = "Window")
{
	if !WinIdOrDesktopId
	{
		DetectHiddenWindows, On
		WinGetTitle, h_hwnd, 获取当前窗口信息
		Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
		if !Windy_CurWin_id
			Windy_CurWin_id := WinExist("A")
	}
	else
		Windy_CurWin_id := WinIdOrDesktopId
	gosub 窗口截图
}
else if (CaptureArea = 0) or (CaptureArea = "Screen")
{
	gosub 屏幕截图
}
exitapp

; 1171
窗口截图:
if !CandySel
	CandySel := A_ScriptDir "\..\..\截图目录\截取窗口_" A_Now ".png"
filepath := ImagePutFile(ImagePutWindow("ahk_id " Windy_CurWin_id), CandySel)
;msgbox % filepath
return

; 1172
屏幕截图:
if !CandySel
	CandySel := A_ScriptDir "\..\..\截图目录\截取屏幕_" A_Now ".png"
filepath := ImagePutFile(ImagePutWindow(WinIdOrDesktopId), CandySel)
return