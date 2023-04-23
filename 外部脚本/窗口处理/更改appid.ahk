Windy_CurWin_id := A_Args[1]
if !Windy_CurWin_id
{
	DetectHiddenWindows, On
	WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
}
if !Windy_CurWin_id
	Windy_CurWin_id := WinExist("A")
setwinappid(Windy_CurWin_id, "My_Custom_Group")
return

setwinappid(winhwnd,appid)
{
VarSetCapacity(IID_IPropertyStore, 16)
DllCall("ole32.dll\CLSIDFromString", "wstr", "{886d8eeb-8cf2-4446-8d02-cdba1dbdcf99}", "ptr", &IID_IPropertyStore)
VarSetCapacity(PKEY_AppUserModel_ID, 20)
DllCall("ole32.dll\CLSIDFromString", "wstr", "{9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3}", "ptr", &PKEY_AppUserModel_ID)
NumPut(5, PKEY_AppUserModel_ID, 16, "uint")
dllcall("shell32\SHGetPropertyStoreForWindow","Ptr", winhwnd, "ptr", &IID_IPropertyStore, "ptrp", pstore)
VarSetCapacity(variant, 8+2*A_PtrSize, 0)
NumPut(31, variant, 0, "short") ; VT_LPWSTR
NumPut(&Appid, variant, 8)
hr := IPropertyStore_SetValue(pstore, &PKEY_AppUserModel_ID, &variant)
}

IPropertyStore_GetCount(pstore, ByRef count) {
    return DllCall(VTable(pstore,3), "ptr", pstore, "uintp", count)
}
IPropertyStore_GetValue(pstore, pkey, pvalue) {
    return DllCall(VTable(pstore,5), "ptr", pstore, "ptr", pkey, "ptr", pvalue)
}
IPropertyStore_SetValue(pstore, pkey, pvalue) {
    return DllCall(VTable(pstore,6), "ptr", pstore, "ptr", pkey, "ptr", pvalue)
}

VTable(ppv, idx) {
    Return NumGet(NumGet(1 * ppv) + A_PtrSize * idx)
}