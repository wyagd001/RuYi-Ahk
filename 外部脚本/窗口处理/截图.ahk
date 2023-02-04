#SingleInstance force
#include <ImagePut>
CandySel := A_Args[1]

DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
if !Windy_CurWin_id
	Windy_CurWin_id := WinExist("A")
if !Windy_CurWin_id
	exitapp
if (CandySel = "窗口截图")
	gosub 窗口截图
else
	gosub 屏幕截图
exitapp

窗口截图:
filepath := ImagePutFile(ImagePutWindow("ahk_id " Windy_CurWin_id), A_ScriptDir "\..\..\截图目录\截取窗口_" A_Now ".png")
;msgbox % filepath
return

屏幕截图:
filepath := ImagePutFile(ImagePutWindow(0), A_ScriptDir "\..\..\截图目录\截取屏幕_" A_Now ".png")
;msgbox % filepath
return