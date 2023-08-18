;|2.0|2023.07.01|1335
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\f385.ico"
Adapters := GetAdaptersAddresses()
for k, v in Adapters
{
	FriendlyName := v.FriendlyName
	if InStr(FriendlyName, "以太网") or InStr(FriendlyName, "本地连接")
	{
		nicSetState(FriendlyName, 0)
		Sleep 400
		nicSetState(FriendlyName, 1)
	}
}

GetAdaptersAddresses()
{
	static ERROR_SUCCESS         := 0
	static ERROR_BUFFER_OVERFLOW := 111

	if (DllCall("iphlpapi.dll\GetAdaptersAddresses", "uint", 2, "uint", 0, "ptr", 0, "ptr", 0, "uint*", size) = ERROR_BUFFER_OVERFLOW)
	{
		VarSetCapacity(buf, size, 0)
		if (DllCall("iphlpapi.dll\GetAdaptersAddresses", "uint", 2, "uint", 0, "ptr", 0, "ptr", &buf, "uint*", size) = ERROR_SUCCESS)
		{
			addr := &buf, IP_ADAPTER_ADDRESSES_LH := []
			while (addr)
			{
				IP_ADAPTER_ADDRESSES_LH[A_Index, "AdapterName"]  := StrGet(NumGet(addr + 8, A_PtrSize, "uptr"), "cp0") 
				IP_ADAPTER_ADDRESSES_LH[A_Index, "Description"]  := StrGet(NumGet(addr + 8, A_PtrSize * 7, "uptr"), "utf-16")
				IP_ADAPTER_ADDRESSES_LH[A_Index, "FriendlyName"] := StrGet(NumGet(addr + 8, A_PtrSize * 8, "uptr"), "utf-16")
				loop % NumGet(addr + 8, (A_PtrSize * 9) + 8, "uint")
					PhysicalAddress .= Format("{:02X}", NumGet(addr + 8, (A_PtrSize * 9) + (A_Index - 1), "uchar")) "-"
				IP_ADAPTER_ADDRESSES_LH[A_Index, "PhysicalAddress"] := SubStr(PhysicalAddress, 1, -1), PhysicalAddress := ""
				addr := NumGet(addr + 8, "uptr")
			}
			return IP_ADAPTER_ADDRESSES_LH, VarSetCapacity(buf, 0)
		}
		VarSetCapacity(buf, 0)
	}
	return ""
}

; state=0 (disable)
; state=1 (enable)
nicSetState(adapter, state){
    runwait,% "netsh interface set interface """ adapter """ " (state?"enable":"disable"),,hide
}