;|2.3|2023.08.22|1437
Windy_CurWin_id := A_Args[1]

Winhide, ahk_id %Windy_CurWin_id%
Sleep 3000
WinShow, ahk_id %Windy_CurWin_id%
return