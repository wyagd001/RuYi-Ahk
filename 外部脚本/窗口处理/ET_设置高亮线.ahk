;|2.7|2024.06.06|1612
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=84585
#Persistent
#SingleInstance

Tiptext =
(
Draws a line under the active Excel selection
in the menu color, line thickness can be selected
Double click = Pause
)

Hilfe =
(
Draws a line under the active Excel selection
in the menu color, line thickness and can be selected
)

WinClass1 := "ahk_class XLMAIN"
WinClass2 := "ahk_class OpusApp"
ComStr1 := "Excel.Application"
ComStr2 := "Ket.Application"
Cur_WinClass := WinClass2
Cur_ComStr := ComStr2

Menu, Tray, NoStandard
Menu, tray,add,  ExcelHelpLine
Menu, tray,Disable,ExcelHelpLine

Menu, tray, add
Menu, tray,add, red

Menu, tray,add, green
Menu, tray,add, yellow
Menu, tray,add, blue
Menu, tray,add, black

Menu, tray, add
Menu, tray,add, H1
Menu, tray,add, H2

Menu, tray,add, H3
Menu, tray,add, H5
Menu, tray, add
Menu, Tray, Tip, %Tiptext%
Menu, tray, add, help
Menu, tray, add
Menu, tray,add, Pause
Menu, Tray, Default, Pause
Menu, tray, add, exit
Menu, tray, NoStandard

;=================
; Preset
color:="cc0000"
Menu, Tray, Disable,  red
line:=2
Menu, Tray, Disable,  H2
;=================

SetTimer, rule ,100
return

rule:
ruler(color,line)
return

ruler(color,line){
global Cur_ComStr, Cur_WinClass
static yold:=0, wold:=0, hold:=0, xold:=0, run:=0

if (r and !WinActive(Cur_WinClass))
{
	SplashImage, off
	run:=0
}
	
If !IsObject(xl)
{
try
		xl := ComObjActive(Cur_ComStr)
	catch
	{
		SplashImage, off
		wold:=-1
		return
	}
}

if hwnd:=WinActive(Cur_WinClass)
{
	run:=1
	
	try
	{
		c:=xl.selection.rows.count  ; counts the lines of the selection
		y1:=xl.ActiveWindow.ActivePane.PointsToScreenPixelsY(xl.selection.offset(c,0).top) ; screen position of the selection shifted by its number of lines
		WinGetPos, x, Cy, Width, Height, ahk_id %hwnd%
		ControlGetFocus, WhichControl, ahk_id %hwnd%
		;MouseGetPos, , , WhichWindow, WhichControl ; Alternativly
		
		if (WhichControl="NetUIHWND1")
		{
			SplashImage, off
			wold:=-1
			return
		}
			
		if (yold <> y1) or (xold <> x) or (hold <> height) or (wold <> width)
		{
			r:="a" round(xl.ActiveWindow.ActivePane.ScrollRow //1,0)
			yr:=xl.ActiveWindow.ActivePane.PointsToScreenPixelsY(xl.range(r).top)-10	
											
			if (y1<yr) or (y1>(cy+height-20))
			{
				SplashImage, off
				return
			}
			
			Splashimage,, B W%Width% H%line% Y%y1% X%x% CW%color% ; create line only on change
			yold:=y1
			wold:=width
			hold:=height
			xold:= x
		
		}
	}
}

else
{
	SplashImage, off
	yold:=0, wold:=0, hold:=0, xold:=0, run:=0
}
return
}

ExitApp
return

red:
color:="cc0000"
gosub Menuchange1
Menu, Tray, Disable, red
WinActivate, % Cur_WinClass
return

green:
color:="00cc00"
gosub Menuchange1
Menu, Tray, Disable, green
WinActivate, % Cur_WinClass
return

yellow:
color:="efef00"
gosub Menuchange1
Menu, Tray, Disable, yellow
WinActivate, % Cur_WinClass
return

blue:
color:="00cccc"
gosub Menuchange1
Menu, Tray, Disable, blue
WinActivate, % Cur_WinClass
return

black:
color:="000000"
gosub Menuchange1
Menu, Tray, Disable, black
WinActivate, % Cur_WinClass
return 

h1:
line:=1
gosub Menuchange2
Menu, Tray, Disable, H1
WinActivate, % Cur_WinClass
return

h2:
line:=2
gosub Menuchange2
Menu, Tray, Disable, H2
WinActivate, % Cur_WinClass
return

h3:
line:=3
gosub Menuchange2
Menu, Tray, Disable, H3
WinActivate, % Cur_WinClass
return

h5:
line:=5
gosub Menuchange2
Menu, Tray, Disable, H5
WinActivate, % Cur_WinClass
return

Menuchange1:
Gui, Submit , NoHide
Menu, Tray, Enable, red
Menu, Tray, Enable, green
Menu, Tray, Enable, yellow
Menu, Tray, Enable, blue
Menu, Tray, Enable, black
return

Menuchange2:
Gui, Submit , NoHide
Menu, Tray, Enable, H1
Menu, Tray, Enable, H2
Menu, Tray, Enable, H3
Menu, Tray, Enable, H5
return

help:
Msgbox, %Hilfe%
return

exit:
exitapp

ExcelHelpLine:
return

Pause:
Pause 
WinActivate, % Cur_WinClass
return