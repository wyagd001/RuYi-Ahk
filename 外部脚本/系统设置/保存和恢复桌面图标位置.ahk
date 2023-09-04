;|2.3|2023.08.24|1434
CandySel := A_Args[1]

if !CandySel
{
	mydesktopiconpos := DeskIcons()
	FileDelete, % A_ScriptDir "\..\..\临时目录\mdip\" SubStr(A_Now, 1, 8) ".mdip"
	if !FileExist(A_ScriptDir "\..\..\临时目录\mdip")
		FileCreateDir, % A_ScriptDir "\..\..\临时目录\mdip"
	FileAppend, %mydesktopiconpos%, % A_ScriptDir "\..\..\临时目录\mdip\" SubStr(A_Now, 1, 8) ".mdip", UTF-16
	Var := A_Now
	EnvAdd, Var, -7, days
	FileDelete, % A_ScriptDir "\..\..\临时目录\mdip\" SubStr(Var, 1, 8) ".mdip"
	Return
}
else if (CandySel="restore")
{
	Loop, Files, % A_ScriptDir "\..\..\临时目录\mdip\*.mdip"
	{
		menu, RS_mydesktopicon, Add, % A_LoopFileName, Restore
	}
	menu, RS_mydesktopicon, Show
}
Return

Restore:
FileRead, FileR_coords, % A_ScriptDir "\..\..\临时目录\mdip\" A_ThisMenuItem
DeskIcons(FileR_coords)
return

DeskIcons(coords := "")
{
	Critical
	static MEM_COMMIT := 0x1000, PAGE_READWRITE := 0x04, MEM_RELEASE := 0x8000
	static LVM_GETITEMPOSITION := 0x00001010, LVM_SETITEMPOSITION := 0x0000100F, WM_SETREDRAW := 0x000B

	BackUp_DetectHiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, Off
	ControlGet, hwWindow, HWND,, SysListView321, ahk_class Progman
	if !hwWindow ; #D mode
	{
		;MsgBox,,,请点击桌面空白处完成保存桌面的操作,2
		;WinWaitActive,ahk_class WorkerW
		ControlGet, hwWindow, HWND,, SysListView321, ahk_class WorkerW
	}
	IfWinExist ahk_id %hwWindow% ; last-found window set
		WinGet, iProcessID, PID
	hProcess := DllCall("OpenProcess"   , "UInt",   0x438         ; PROCESS-OPERATION|READ|WRITE|QUERY_INFORMATION
                              , "Int",   FALSE         ; inherit = false
                              , "Ptr",   iProcessID)
	if hwWindow and hProcess
	{
		ControlGet, list, list, Col1  ; 第1列 名称
		ControlGet, list2, list, Col3 ; 第2列 大小 第3列 项目类型
		Loop, Parse, list2, `n
		{
			filetype_%A_Index% := SubStr(A_LoopField, 1)
			filetype_%A_Index% := StrReplace(filetype_%A_Index%, " ")
		}

		if !coords    ; 保存
		{
			VarSetCapacity(iCoord, A_PtrSize * 2)
			pItemCoord := DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "UInt", 8, "UInt", MEM_COMMIT, "UInt", PAGE_READWRITE)
			Loop, Parse, list, `n
			{
				SendMessage, %LVM_GETITEMPOSITION%, % A_Index-1, %pItemCoord%
				DllCall("ReadProcessMemory", "Ptr", hProcess, "Ptr", pItemCoord, "UInt" . (A_PtrSize == 8 ? "64" : ""), &iCoord, "UInt", A_PtrSize * 2, "UIntP", cbReadWritten)
				iconid := A_LoopField . "(" . filetype_%A_Index% . ")"
				ret .= iconid ":" (NumGet(iCoord,"Int") & 0xFFFF) | ((Numget(iCoord, 4,"Int") & 0xFFFF) << 16) "`n"
			}
			DllCall("VirtualFreeEx", "Ptr", hProcess, "Ptr", pItemCoord, "Ptr", 0, "UInt", MEM_RELEASE)
		}
		else   ; 加载, 将图标摆放为与给定的坐标数据一致
		{
			SendMessage, %WM_SETREDRAW%, 0, 0
			Loop, Parse, list, `n
			{
				iconid := A_LoopField . "(" . filetype_%A_Index% . ")"
				If RegExMatch(coords, "\Q" iconid "\E:\K.*", iCoord_new)
					SendMessage, %LVM_SETITEMPOSITION%, % A_Index-1, %iCoord_new%
			}
			SendMessage, %WM_SETREDRAW%, 1, 0
			ret := true
		}
	}
	DllCall("CloseHandle", "Ptr", hProcess)
	DetectHiddenWindows, % BackUp_DetectHiddenWindows
	Critical, Off
	return ret
}