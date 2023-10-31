;|2.4|2023.10.23|1527
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?t=61649
; 2 = ABS_ALWAYSONTOP  |  1 = ABS_AUTOHIDE
SetTaskbarState( GetTaskbarState() & 1 ? 2 : 1|2 )
exitapp

GetTaskbarState()
{
    local APPBARDATA := "", Size := A_PtrSize = 4 ? 36 : 48
    VarSetCapacity(APPBARDATA, Size, 0), NumPut(Size, &APPBARDATA+0, "UInt")
    return DllCall("Shell32.dll\SHAppBarMessage", "UInt", 4, "UPtr", &APPBARDATA, "UPtr")
} ; https://docs.microsoft.com/en-us/windows/desktop/api/shellapi/nf-shellapi-shappbarmessage

SetTaskbarState(State)
{
    local APPBARDATA := "", Size := A_PtrSize = 4 ? 36 : 48
    VarSetCapacity(APPBARDATA, Size, 0), NumPut(Size, &APPBARDATA+0, "UInt")
    NumPut(State, APPBARDATA, A_PtrSize=4?32:40, "UPtr")
    ; ABM_SETSTATE = 10 (https://msdn.microsoft.com/es-es/a60e156d-19ef-49b9-83fc-138d1a2169f2)
    DllCall("Shell32.dll\SHAppBarMessage", "UInt", 10, "UPtr", &APPBARDATA)
} ; https://docs.microsoft.com/en-us/windows/desktop/api/shellapi/nf-shellapi-shappbarmessage
