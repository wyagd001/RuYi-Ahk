;|2.6|2024.04.28|1584
Windy_CurWin_id := A_Args[1]
pin2desk(Windy_CurWin_id)
Return

pin2desk(shwnd)
{
	WinGet, DesktopID, ID, ahk_class WorkerW
	if !DesktopID
		WinGet, DesktopID, ID, ahk_class Progman

	ParentID := DllCall("SetParent", "UInt", shwnd, "UInt", DesktopID)
	if (ParentID = DesktopID)
	{
		DllCall("SetParent", "UInt", shwnd, "UInt", 0)
	}
}