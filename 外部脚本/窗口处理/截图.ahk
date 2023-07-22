;|2.1|2023.07.17|1171,1172,1360
#SingleInstance force
#include <ImagePut>
CandySel := A_Args[1]
picfilepath := A_Args[2]

if (CandySel = "窗口截图")
{
	DetectHiddenWindows, On
	WinGetTitle, h_hwnd, 获取当前窗口信息
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
	if !Windy_CurWin_id
		Windy_CurWin_id := WinExist("A")
	gosub 窗口截图
}
else if (CandySel = "") or (CandySel = "屏幕截图")
	gosub 屏幕截图
exitapp

; 1171
窗口截图:
if !picfilepath
	picfilepath := A_ScriptDir "\..\..\截图目录\截取窗口_" A_Now ".png"
filepath := ImagePutFile(ImagePutWindow("ahk_id " Windy_CurWin_id), picfilepath)
;msgbox % filepath
return

; 1172
屏幕截图:
if !picfilepath
	picfilepath := A_ScriptDir "\..\..\截图目录\截取屏幕_" A_Now ".png"
filepath := ImagePutFile(ImagePutWindow(0), picfilepath)
return