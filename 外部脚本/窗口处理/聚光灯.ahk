;|2.8|2024.11.24|1689
Create_Focus:
Gui, Focus: Margin , 0, 0
Gui, Focus: -Caption +AlwaysOnTop +E0x20 +LastFound +ToolWindow
Gui, Focus: Color, 000000
SysGet, Mon, MonitorWorkArea
Gui, Focus: Show, x%MonLeft% y%MonTop% w%MonRight% h%MonBottom%, Mouse Spotlight
WinGetPos, , , w, h, Mouse Spotlight ahk_class AutoHotkeyGUI
WinGet, ID, ID, Mouse Spotlight ahk_class AutoHotkeyGUI
WinSet, Transparent, 210, Mouse Spotlight

SetTimer, Cut, 200
return

Cut:
CoordMode, Mouse, Screen
;MousegetPos, X1, Y1
MousegetPos,,, OutputVarWin
;WinActivate, %OutputVarWin%
WinGetPos, WinX, WinY, WinW, WinH, ahk_id %OutputVarWin%
;WinGetActiveStats, Title, WinW, WinH, WinX, WinY
;Winset, Region, % RegionNotEllipse( w, h, X1, Y1, 200/2, 200/2, 0.8 ), Mouse Spotlight ahk_class AutoHotkeyGUI
WinX := WinX + 7
hwinh := WinY + WinH - 7
hwinw := WinX + WinW - 14

Winset, Region, %MonLeft%-%MonTop% %MonLeft%-%h% %w%-%h% %w%-%MonLeft% %MonLeft%-%MonTop% %WinX%-%WinY% %WinX%-%hwinh% %hwinw%-%hwinh% %hwinw%-%WinY% %WinX%-%WinY%, Mouse Spotlight ahk_class AutoHotkeyGUI
Return 

;https://autohotkey.com/board/topic/40439-using-winset-to-create-a-round-see-through-window/?p=252582
RegionNotEllipse( w, h, x, y, rx, ry, pointratio )
  { ; w,h = width,height of the window
  ; x,y = location of the center of the hole
  ; rx,ry = the radius along the x,y axes 
  ; pointratio = approximate ratio between the
  ; circumference and the number of points along it
  lp := " " . x - rx . "-" . y . " "
  hp := x + rx . "-" y . " "
  Loop, % -1 + dr := Ceil(pointratio * 1.5708 * (rx + ry))
    {
    qx := Round( rx * Cos(3.1416 * A_Index / dr))
    qy := Round( ry * Sin(3.1416 * A_Index / dr))
    lp .= x - qx . "-" . y + qy . " "
    hp .= x + qx . "-" . y - qy . " "
    }
  Return "0-0 " . w . "-0 " . w . "-" . h . " 0-" . h . " 0-0 " . lp . hp . x - rx . "-" . y . " 0-0"
  }