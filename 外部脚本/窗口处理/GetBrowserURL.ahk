;|2.0|2023.07.01|1141,1142
CandySel := A_Args[1]
DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
if !Windy_CurWin_id
	Windy_CurWin_id := WinExist("A")
if !Windy_CurWin_id
	exitapp

WinActivate, Ahk_ID %Windy_CurWin_id%
if (CandySel ="") or (CandySel ="OnlyOne")
	Clipboard  := GetBrowserURL_ACC_byhwnd(Windy_CurWin_id)
else if (CandySel ="All")
	gosub Windo_ChromeCopyAllURLs
return

Windo_ChromeCopyAllURLs:
	Tmp_Val := ""
	URLs := []
	loop,50
	{
		URLs[A_index] := GetBrowserURL_ACC_byhwnd(Windy_CurWin_id)
		sleep, 20
		if (A_index != 1) && (URLs[A_index] = URLs[1])
		{
			URLs.RemoveAt(A_index)
			break
		}
		sleep, 200
		send ^{Tab}
		Continue
	}
	for k,v in URLs
		Tmp_Val .= v "`r`n"
	Clipboard := trim(Tmp_Val, "`r`n")
	sleep,10
	Tmp_Val := ""
	URLs := []
	;CF_ToolTip("所有标签页网址已复制到剪贴板。", 3000)
return

; https://autohotkey.com/boards/viewtopic.php?f=6&t=3702

GetActiveBrowserURL(sClass, WithProtocol:=1) {
	static ModernBrowsers, LegacyBrowsers,OtherBrowsers
ModernBrowsers := "ApplicationFrameWindow,Chrome_WidgetWin_0,Chrome_WidgetWin_1,Maxthon3Cls_MainFrm,MozillaWindowClass,Slimjet_WidgetWin_1,360se6_Frame,360chrome,QQBrowser_WidgetWin_1"
LegacyBrowsers := "IEFrame,OperaWindowClass"
OtherBrowsers := "AuroraMainFrame"
	if !sclass
		WinGetClass, sClass, A
	If sClass In % ModernBrowsers
	{
		tmp_val := GetBrowserURL_ACC(sClass, WithProtocol)
		if tmp_val
		Return tmp_val
		else
		Return GetBrowserURL_hK()
	}
	Else If sClass In % LegacyBrowsers
		Return GetBrowserURL_DDE(sClass) ; empty string if DDE not supported (or not a browser)
	Else If sClass In % OtherBrowsers
		Return GetBrowserURL_hK()
	Else
		Return ""
}

GetBrowserURL_hK()
{
	Send, ^l
	sleep,300
	sURL := GetSelText()
	if IsURL(sURL)
	Return sURL
}

; "GetBrowserURL_DDE" adapted from DDE code by Sean, (AHK_L version by maraskan_user)
; Found at http://autohotkey.com/board/topic/17633-/?p=434518

GetBrowserURL_DDE(sClass) {
	WinGet, sServer, ProcessName, % "ahk_class " sClass
	StringTrimRight, sServer, sServer, 4
	iCodePage := A_IsUnicode ? 0x04B0 : 0x03EC ; 0x04B0 = CP_WINUNICODE, 0x03EC = CP_WINANSI
	DllCall("DdeInitialize", "UPtrP", idInst, "Uint", 0, "Uint", 0, "Uint", 0)
	hServer := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", sServer, "int", iCodePage)
	hTopic := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "WWW_GetWindowInfo", "int", iCodePage)
	hItem := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "0xFFFFFFFF", "int", iCodePage)
	hConv := DllCall("DdeConnect", "UPtr", idInst, "UPtr", hServer, "UPtr", hTopic, "Uint", 0)
	hData := DllCall("DdeClientTransaction", "Uint", 0, "Uint", 0, "UPtr", hConv, "UPtr", hItem, "UInt", 1, "Uint", 0x20B0, "Uint", 10000, "UPtrP", nResult) ; 0x20B0 = XTYP_REQUEST, 10000 = 10s timeout
	sData := DllCall("DdeAccessData", "Uint", hData, "Uint", 0, "Str")
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hServer)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hTopic)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hItem)
	DllCall("DdeUnaccessData", "UPtr", hData)
	DllCall("DdeFreeDataHandle", "UPtr", hData)
	DllCall("DdeDisconnect", "UPtr", hConv)
	DllCall("DdeUninitialize", "UPtr", idInst)
	csvWindowInfo := StrGet(&sData, "CP0")
	StringSplit, sWindowInfo, csvWindowInfo, `" ;"; comment to avoid a syntax highlighting issue in autohotkey.com/boards
	Return sWindowInfo2
}

; 由类获取窗口id，在检测隐藏窗口开启时，可能会得不到正确的窗口id
GetBrowserURL_ACC(sClass, WithProtocol:=1) {
	global nWindow, accAddressBar
	BackUp_DetectHiddenWindows := A_DetectHiddenWindows
	DetectHiddenWindows, Off
	If (nWindow != WinExist("ahk_class " sClass)) ; reuses accAddressBar if it's the same window
	{
		nWindow := WinExist("ahk_class " sClass)
		accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindow))
	}
	Try sURL := accAddressBar.accValue(0)
	If (sURL == "") {
		WinGet, nWindows, List, % "ahk_class " sClass ; In case of a nested browser window as in the old CoolNovo
		If (nWindows > 1) {
			loop % nWindows {
				Tmp_nWindows := nWindows%A_index%
				if (Tmp_nWindows = nWindow)
					continue
				accAddressBar := GetAddressBar(Acc_ObjectFromWindow(Tmp_nWindows))
				Try sURL := accAddressBar.accValue(0)
				if (sURL !=""){
					;msgbox % "1" sURL "1"
					break
				}
			}
		}
	}

	If ((sURL != "") and (SubStr(sURL, 1, 4) != "http")) ; Modern browsers omit "http://"
		sURL := WithProtocol ? "http://" sURL : sURL
	If (sURL == "")
		nWindow := -1 ; Don't remember the window if there is no URL
	DetectHiddenWindows, % BackUp_DetectHiddenWindows
	Return sURL
}

GetBrowserURL_ACC_byhwnd(hwnd := 0){
	if !hwnd
		hwnd := WinExist("A")
	accAddressBar := GetAddressBar(Acc_ObjectFromWindow(hwnd))
	Try sURL := accAddressBar.accValue(0)
	If (sURL == "")
	return 0
	Return sURL
}

; "GetAddressBar" based in code by uname
; Found at http://autohotkey.com/board/topic/103178-/?p=637687

GetAddressBar(accObj) {
	Try If ((accObj.accRole(0) == 42) and IsURL(accObj.accValue(0)))
	Return accObj

	Try If ((accObj.accRole(0) == 42) and IsURL("http://" accObj.accValue(0))) ; Modern browsers omit "http://"
		Return accObj

	Try If ((accObj.accRole(0) == 42) and IsURL("file://" accObj.accValue(0))) ; Modern browsers omit "file://"
	Return accObj

	Try If ((accObj.accRole(0) == 42) and InStr( accObj.accValue(0),":/"))
	Return accObj

	For nChild, accChild in Acc_Children(accObj)
		If IsObject(accAddressBar := GetAddressBar(accChild))
			Return accAddressBar
}

IsURL(sURL) {
	Return RegExMatch(sURL, "^(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+.*$")
	;Return RegExMatch(sURL, "^(?<Protocol>https?|ftp|file):///?(?<Domain>(?:[\w-]+\.)+\w\w+)(?::(?<Port>\d+))?/?(?<Path>(?:[^:/?# ]*/?)+)(?:\?(?<Query>[^#]+)?)?(?:\#(?<Hash>.+)?)?$")
}

GetSelText(returntype := 1, ByRef _isFile := "", ByRef _ClipAll := "", waittime := 0.5)
{
	global clipmonitor
	clipmonitor := (returntype = 0) ? 1 : 0
	BackUp_ClipBoard := ClipboardAll    ; 备份剪贴板
	Clipboard =    ; 清空剪贴板
	Send, ^c
	sleep 100
	ClipWait, % waittime
	If(ErrorLevel) ; 如果粘贴板里面没有内容，则还原剪贴板
	{
		Clipboard := BackUp_ClipBoard
		sleep 100
		clipmonitor := 1
	Return
	}
	If(returntype = 0)
	Return Clipboard
	else If(returntype=1)
		_isFile := _ClipAll := ""
	else
	{
		_isFile := DllCall("IsClipboardFormatAvailable", "UInt", 15) ; 是否是文件类型
		_ClipAll := ClipboardAll
	}
	ClipSel := Clipboard

	Clipboard := BackUp_ClipBoard  ; 还原粘贴板
	sleep 200
	clipmonitor := 1
	return ClipSel
}