#SingleInstance, Force
DetectHiddenWindows, On
WinGet, W, List
Gui +AlwaysOnTop +ToolWindow +LastFound
Gui1 := WinExist
Gui,Add,ListView, w640 h480 R25 Grid Checked AltSubmit gShowHide, wID|Class|Title|PID|Exe
LV_ModifyCol(1,"75 Right")  , LV_ModifyCol(2,"150"), LV_ModifyCol(3,"250")
LV_ModifyCol(4,"40 Integer"), LV_ModifyCol(5,"100"), LV_ModifyCol(6,"100")
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
         LV_Add( Checked, ID, Class, Title, PID, Process, Parent )
} Gui, Show, , * List of all windows ( Hidden / Shown )
LV_Ready := True
Return

ShowHide:
 IfNotEqual,LV_Ready,1,Return
 IfNotEqual,ErrorLevel,C,Return
 LV_GetText( ID, A_EventInfo, 1 )
  If DllCall( "IsWindowVisible", UInt,ID )
         WinHide, ahk_id %ID%
  Else {
         WinShow, ahk_id %ID%
         WinActivate, ahk_id %ID%
}
Return

GuiClose:
GuiEscape:
 ExitApp

 g::
 Reload
 return