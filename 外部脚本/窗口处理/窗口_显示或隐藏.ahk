;|2.8|2023.10.05|1199
#SingleInstance, Force
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\f5ed.ico"
DetectHiddenWindows, On
Gui +AlwaysOnTop +ToolWindow +LastFound
Gui1 := WinExist
Gui,Add,ListView, w685 h480 R25 Grid Checked AltSubmit gShowHide, 序号|wID|Class|Title|PID|Exe
Gui,Add, Button, xs gLoadWinlist, 刷新
Gosub LoadWinlist
Gui, Show, , * List of all windows ( Hidden / Shown )
Return

LoadWinlist:
LV_Delete()
LV_Ready := 0
WinGet, W, List
LV_ModifyCol(1, "45 Right"), LV_ModifyCol(2, "75 Right"), LV_ModifyCol(3,"150"), LV_ModifyCol(4,"250")
LV_ModifyCol(5,"40 Integer"), LV_ModifyCol(6,"100"), LV_ModifyCol(7,"100")
Loop %W% {
         ID := W%A_Index%, Checked := DllCall( "IsWindowVisible", UInt,ID ) ? "Check" : ""
         WinGet, Style, style, ahk_id %ID%
;         If ! ( Style & ( WS_SYSMENU := 0x80000 ) )
;            Continue
         IfEqual,ID,%Gui1%, Continue
         WinGetClass, Class, ahk_id %ID%
         WinGetTitle, Title, ahk_id %ID%
         IfEqual,Title,,Continue
         WinGet, PID, PID, ahk_id %ID%
         WinGet, Process, ProcessName, ahk_id %ID%
         LV_Add( Checked, A_Index, ID, Class, Title, PID, Process, Parent )
}
LV_Ready := True
return

ShowHide:
IfNotEqual,LV_Ready,1,Return
IfNotEqual,ErrorLevel,C,Return
LV_GetText( ID, A_EventInfo, 2 )
If DllCall( "IsWindowVisible", UInt,ID )
  WinHide, ahk_id %ID%
Else 
{
  WinShow, ahk_id %ID%
  WinActivate, ahk_id %ID%
}
Return

GuiClose:
GuiEscape:
 ExitApp