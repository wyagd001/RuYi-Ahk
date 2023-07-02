;|2.0|2023.07.01|多条目
; 参数可变, 多条目
CandySel := A_Args[1]

DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
if !Windy_CurWin_id
	Windy_CurWin_id := WinExist("A")
if !Windy_CurWin_id
	exitapp
Windo_ChromeAddressBarOpen:
accAddressBar := FindChromeAddressBar(Windy_CurWin_id)
accAddressBar.accObj.accValue(0) := CandySel
accAddressBar.accObj.accSelect(0x1, 0)
sleep,500
ControlSend,, {Enter}, ahk_id %Windy_CurWin_id%
return

FindChromeAddressBar(Win_hWnd := "", oAcc := "", accPath := "") {
	if !oAcc {
			oAcc := Acc_ObjectFromWindow(Win_hWnd)
			while oAcc.accRole(0) != 9 { ; ROLE_SYSTEM_WINDOW := 9
				oAcc := Acc_Parent(oAcc)
			}
		}

	for i, child in Acc_Children(oAcc) {
		nRole := child.accRole(0)
		
		if (nRole = 42) { ; ROLE_SYSTEM_TEXT := 42
			if (child.accName(0) ~= "i)address|地址") {
				accPath := LTrim(accPath "." i, ".")
				return {accObj: child, accPath: accPath, hWnd: hWnd}
			}
		}

		/*
			ROLE_SYSTEM_APPLICATION := 14
			ROLE_SYSTEM_PANE        := 16
			ROLE_SYSTEM_GROUPING    := 20
			ROLE_SYSTEM_TOOLBAR     := 22
			ROLE_SYSTEM_COMBOBOX    := 46
		*/
		static oGroup := {14:1, 16:1, 20:1, 22:1, 46:1}
		if oGroup.HasKey(nRole) {
			if result := FindChromeAddressBar(, child, accPath "." i) {
				return result
			}
		}
	}
}