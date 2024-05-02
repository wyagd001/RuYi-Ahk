;|2.6|2024.04.20|1575
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?t=84282
SetWorkingDir %A_ScriptDir%
;URL = https://i.imgur.com/hw5wxoO.png
;URLDownloadToFile, %URL%, Image.png

CandySel := A_Args[1]
counterSeconds := CandySel ? CandySel : 60
counterSecondsAdjusted := counterSeconds + 1

counter:=0
SetTimer, UpdateOSD, -10 ; to update immediately
SetTimer, UpdateOSD, 1000

;On-screen display (OSD)
Gui +LastFound +AlwaysOnTop -Caption -border +ToolWindow ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, 0c0909
Gui, Margin, 0, 0
Gui, Font, c04F4F0 s35 ; Set a large font size (35-point).
Gui, Add, Text, ym+30 x212 w100 Center vTimerText BackgroundTrans gDrag, ; 00 serve to auto-size the window.
WinSet, TransColor, 0c0909 ; Make all pixels of this color transparent
Gui, Show, x0 y0 NoActivate ; NoActivate avoids deactivating the currently active window.
return

Drag:
PostMessage, 0xA1, 2,,, A
return

UpdateOSD:
counter++
timer:=counterSecondsAdjusted-counter ; 6 and not 5 because counter starts with 1
if (timer=0)
{
	SetTimer, UpdateOSD, off ; stops the counter
	settimer esc, -5000
}
if (timer > 60)
{
	minutesTime := Floor(timer/60)
	secondsTime := Mod(timer,60)
	secondsTime := Floor(secondsTime)
	if (secondsTime < 10)
	{
		GuiControl,, TimerText, %minutesTime%`:0%secondsTime%
	}
	else
		GuiControl,, TimerText, %minutesTime%`:%secondsTime%
}
else
{
	GuiControl,, TimerText, %timer%
	if (timer <= 5)
		SoundBeep
}
return

esc::exitapp
