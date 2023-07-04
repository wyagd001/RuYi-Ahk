;|2.0|2023.07.01|1334
;来源网址: https://www.autohotkey.com/boards/viewtopic.php?t=65822
/*
	Restart "Local area connection" without admin privileges

	Example: RestartNetwork("Local area connection")

	If ConnectionName is omited, the adapter name that contains "Realtek PCIe" will be selected.
*/
RestartNetwork()
;RestartNetwork("以太网")

RestartNetwork(ConnectionName := "") {

	oShell := ComObjCreate("Shell.Application")
	oShell.Open("::{7007ACC7-3202-11D1-AAD2-00805FC1270E}") ; Open Network Connections

	FolderName := oShell.Namespace(0x31).Title
	;MsgBox % FolderName   ; Win10  显示为  网络连接
	; Find "Network Connections" window
	Loop
	{
		Sleep, 200

		for oWin in oShell.Windows
		{
			if ( oWin.LocationName = FolderName )
			&& ( oWin.LocationURL = "" )
			&& ( InStr(oWin.FullName, "\Explorer.EXE") )
				Break, 2
		}
	}

	oFolder := oWin.Document.Folder

	for item in oFolder.Items
	{
		devName := oFolder.GetDetailsOf(item, 2)

		if (item.name = ConnectionName)
		|| (ConnectionName = "" && InStr(devName, "Realtek PCIe"))
		{
			if InStr(item.Verbs.Item(0).Name, "&B")
			{
				item.InvokeVerb("disable")
				Sleep, 1000
			}

			item.InvokeVerb("enable")
			break
		}
	}
	
	;oWin.Quit
}