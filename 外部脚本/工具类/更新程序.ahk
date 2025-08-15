;|2.9|2025.06.24|0000
ruyiexefile := A_Args[1]
;ruyiexefile := "如一.exe"
if !ruyiexefile
	ExitApp
if instr(ruyiexefile, "_x32")
	AnyToAhkexefile := "AnyToAhk_x32.exe"
else
	AnyToAhkexefile := "AnyToAhk.exe"

A_RuYiDir := RuYi_GetRuYiDir()
FileGetSize, OutputVar, % A_RuYiDir "\临时目录\"  ruyiexefile, K
if (OutputVar < 400)
{
  ;msgbox 文件大小不符
	ExitApp
}

ExitProcess("如一.exe ahk_class AutoHotkey")
ExitProcess("如一_x32.exe ahk_class AutoHotkey")
ExitProcess("AnyToAhk_x32.exe ahk_class AutoHotkey")
ExitProcess("AnyToAhk.exe ahk_class AutoHotkey")
sleep 2000
FileRecycle, % A_RuYiDir "\" ruyiexefile
FileMove, % A_RuYiDir "\临时目录\" ruyiexefile, % A_RuYiDir "\" ruyiexefile, 1
if ErrorLevel
{
  ExitProcess("如一.exe ahk_class AutoHotkey")
  ExitProcess("如一_x32.exe ahk_class AutoHotkey")
  sleep 500
  FileRecycle, % A_RuYiDir "\" ruyiexefile
  FileMove, % A_RuYiDir "\临时目录\" ruyiexefile, % A_RuYiDir "\" ruyiexefile, 1
}

FileGetSize, OutputVar, % A_RuYiDir "\临时目录\"  AnyToAhkexefile, K
if (OutputVar < 400)
{
  ;msgbox 文件大小不符
	ExitApp
}
FileRecycle, % A_RuYiDir "\" AnyToAhkexefile
FileMove, % A_RuYiDir "\临时目录\" AnyToAhkexefile, % A_RuYiDir "\" AnyToAhkexefile, 1
if ErrorLevel
{
  ExitProcess("AnyToAhk_x32.exe ahk_class AutoHotkey")
  ExitProcess("AnyToAhk.exe ahk_class AutoHotkey")
  sleep 500
  FileRecycle, % A_RuYiDir "\" AnyToAhkexefile
  FileMove, % A_RuYiDir "\临时目录\" AnyToAhkexefile, % A_RuYiDir "\" AnyToAhkexefile, 1
}
sleep 500
run % A_RuYiDir "\" ruyiexefile
return

ExitProcess(Title)
{
	DetectHiddenWindows, On
	Settitlematchmode, 2
	loop 5
	{
		if (UniqueID := WinExist(Title))
		{
			WinClose, ahk_id %UniqueID%
			sleep 300
			if A_index = 5
			{
				WinGet, hPid, PID, ahk_id %UniqueID%
				Process, Close, %hPid%            ; 没有考虑进程卡住的特殊情况
			}
		}
		else
			break
	}
}