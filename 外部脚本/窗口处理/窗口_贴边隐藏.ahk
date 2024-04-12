;|2.6|2024.03.26|1568
; 原版脚本来源: https://github.com/hzhbest/winautohide

#Persistent
#SingleInstance ignore
OnExit menuExit

Menu tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\ea5b.ico"
Windy_CurWin_id := A_Args[1]
edge := A_Args[2]

/*
 * Timer initialization.
 */
SetTimer, watchCursor, 300

/*
 * Tray menu initialization.
 */
Menu, tray, NoStandard
Menu, tray, Add, About..., menuAbout
Menu, tray, Add, Un-autohide all windows, menuUnautohideAll
Menu, tray, Add, Exit, menuExit
Menu, tray, Default, About...
if edge in 上,下,左,右
	gosub toggleWindow%edge%
return ; end of code that is to be executed on script start-up

/*
 * Tray menu implementation.
 */
menuAbout:
	MsgBox, 8256, About, BoD winautohide v1.01.`nModded by hzhbest`nhttps://github.com/hzhbest/winautohide`n`nThis program and its source are in the public domain.`nContact BoD@JRAF.org for more information.
return

menuUnautohideAll:
	Loop, Parse, autohideWindows, `,
	{
		curWinId := A_LoopField
		if (autohide_%curWinId%) {
			Gosub, unautohide
		}
	}
return

menuExit:
	Gosub, menuUnautohideAll
	ExitApp
return

/*
 * Timer implementation.
 */
watchCursor:
	MouseGetPos, , , winId ; get window under mouse pointer
	;WinGet winPid, PID, ahk_id %winId% ; get the PID for process recognition
	
	;if (autohide_%winId% || autohide_%winPid%) { ; window or process is on the list of 'autohide' windows
	if (autohide_%winId%) {
		if (hidden_%winId%) { ; window is in 'hidden' position
			previousActiveWindow := WinExist("A")
			WinActivate, ahk_id %winId% ; activate the window
			WinMove, ahk_id %winId%, , showing_%winId%_x, showing_%winId%_y ; move it to 'showing' position
			hidden_%winId% := false
			needHide := winId ; store it for next iteration
		}
	} else {
		if (needHide) {
			WinGetPos, now_win_x, now_win_y, , , ahk_id %needHide%
			If (showing_%needHide%_x !== now_win_x || showing_%needHide%_y !== now_win_y) { ; win moved before hidden
				curWinId := needHide
				;WinGet winPhid, PID, ahk_id %needHide%
				;curWinPId := winPhid
				autohide_%curWinId% := false
				;autohide_%curWinPid% := false
				needHide := false
				Gosub, unworkWindow
				hidden_%curWinId% := false
				ExitApp
			} else {
				WinMove, ahk_id %needHide%, , hidden_%needHide%_x, hidden_%needHide%_y ; move it to 'hidden' position
				WinActivate, ahk_id %previousActiveWindow% ; activate previously active window
				hidden_%needHide% := true
				needHide := false ; do that only once
			}
		}
	}
return

/*
 * Hotkey implementation.
 */
toggleWindow右:
	mode := "right"
	Gosub, toggleWindow
return

toggleWindow左:
	mode := "left"
	Gosub, toggleWindow
return

toggleWindow上:
	mode := "up"
	Gosub, toggleWindow
return

toggleWindow下:
	mode := "down"
	Gosub, toggleWindow
return

toggleWindow:
	curWinId := Windy_CurWin_id
	;WinGet, curWinId, ID, A
	;WinGet, curWinPId, PID, A
	autohideWindows = %autohideWindows%,%curWinId%

	if (autohide_%curWinId%) {
		Gosub, unautohide
	} else {
		autohide_%curWinId% := true
		;autohide_%curWinPid% := true ; record the process in the list
		Gosub, workWindow
		WinGetPos, orig_%curWinId%_x, orig_%curWinId%_y, width, height, ahk_id %curWinId% ; get the window size and store original position

		if (mode = "right") {
			showing_%curWinId%_x := A_ScreenWidth - width
			showing_%curWinId%_y := orig_%curWinId%_y
			prehid_%curWinId%_x := A_ScreenWidth - 51
			prehid_%curWinId%_y := orig_%curWinId%_y
			hidden_%curWinId%_x := A_ScreenWidth - 1
			hidden_%curWinId%_y := orig_%curWinId%_y
		} else if (mode = "left") {
			showing_%curWinId%_x := 0
			showing_%curWinId%_y := orig_%curWinId%_y
			prehid_%curWinId%_x := -width + 51
			prehid_%curWinId%_y := orig_%curWinId%_y
			hidden_%curWinId%_x := -width + 1
			hidden_%curWinId%_y := orig_%curWinId%_y
		} else if (mode = "up") {
			showing_%curWinId%_x := orig_%curWinId%_x
			showing_%curWinId%_y := 0
			prehid_%curWinId%_x := orig_%curWinId%_x
			prehid_%curWinId%_y := -height + 51
			hidden_%curWinId%_x := orig_%curWinId%_x
			hidden_%curWinId%_y := -height + 1
		} else { ; down
			showing_%curWinId%_x := orig_%curWinId%_x
			showing_%curWinId%_y := A_ScreenHeight - height
			prehid_%curWinId%_x := orig_%curWinId%_x
			prehid_%curWinId%_y := A_ScreenHeight - 51
			hidden_%curWinId%_x := orig_%curWinId%_x
			hidden_%curWinId%_y := A_ScreenHeight - 1
		}

		WinMove, ahk_id %curWinId%, , prehid_%curWinId%_x, prehid_%curWinId%_y
		Sleep 300
		WinMove, ahk_id %curWinId%, , hidden_%curWinId%_x, hidden_%curWinId%_y ; hide the window
		hidden_%curWinId% := true
	}
return

unautohide:
	autohide_%curWinId% := false
	;autohide_%curWinPid% := false
	needHide := false
	Gosub, unworkWindow
	WinMove, ahk_id %curWinId%, , orig_%curWinId%_x, orig_%curWinId%_y ; go back to original position
	hidden_%curWinId% := false
return

workWindow:
	DetectHiddenWindows, On
	WinSet, AlwaysOnTop, on, ahk_id %curWinId% ; always-on-top
	;WinHide, ahk_id %curWinId%
	WinSet, ExStyle, +0x80, ahk_id %curWinId% ; remove from task bar
	;WinShow, ahk_id %curWinId%
return

unworkWindow:
	DetectHiddenWindows, On
	WinSet, AlwaysOnTop, off, ahk_id %curWinId% ; always-on-top
	;WinHide, ahk_id %curWinId%
	WinSet, ExStyle, -0x80, ahk_id %curWinId% ; remove from task bar
	;WinShow, ahk_id %curWinId%
return