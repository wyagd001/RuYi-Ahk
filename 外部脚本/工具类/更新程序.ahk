;|2.7|2024.06.17|0000
ruyiexefile := A_Args[1]
;ruyiexefile := "如一.exe"
if instr(ruyiexefile, "_x32")
	AnyToAhkexefile := "AnyToAhk_x32.exe"
else
	AnyToAhkexefile := "AnyToAhk.exe"
if !ruyiexefile
	ExitApp
if FileExist(A_ScriptDir "\..\..\临时目录\" ruyiexefile)
{
	ExitProcess("如一.exe ahk_class AutoHotkey")
	ExitProcess("如一_x32.exe ahk_class AutoHotkey")
	ExitProcess("AnyToAhk_x32.exe ahk_class AutoHotkey")
	ExitProcess("AnyToAhk.exe ahk_class AutoHotkey")
	sleep 800
	FileMove, % A_ScriptDir "\..\..\临时目录\" ruyiexefile, % A_ScriptDir "\..\..\" ruyiexefile, 1
	;MsgBox % ErrorLevel 
	FileMove, % A_ScriptDir "\..\..\临时目录\" AnyToAhkexefile, % A_ScriptDir "\..\..\" AnyToAhkexefile, 1
	sleep 500
	run % A_ScriptDir "\..\..\" ruyiexefile
}
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

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}