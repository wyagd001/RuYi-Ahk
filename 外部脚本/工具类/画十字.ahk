;|2.1|2023.07.21|1376
CandySel := A_Args[1]

Width := A_ScreenWidth, Height := A_ScreenHeight
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
global Handles := [],Handles2:=[],ALED,Thickness,LH,LA:="FF",LT:=5

Gui, 1: -Caption +E0x80000  +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs 
Gui, 1: Show, NA
hwnd7 := WinExist() ; hwnd7 to avoid conflict ("hwnd1" name is too much used in other scripts)

hbm := CreateDIBSection(Width, Height)  ;screen
hdc := CreateCompatibleDC()             ;screen
obm := SelectObject(hdc, hbm)           ;screen

hbm2 := CreateDIBSection(Width, Height) ;buffer
hdc2 := CreateCompatibleDC()            ;buffer
obm2 := SelectObject(hdc2, hbm2)        ;buffer

hbm3 := CreateDIBSection(Width, Height) ;saving buffer
hdc3 := CreateCompatibleDC()            ;saving buffer
obm3 := SelectObject(hdc3, hbm3)        ;saving buffer

G := Gdip_GraphicsFromHDC(hdc)
G2 := Gdip_GraphicsFromHDC(hdc2)
Gdip_SetSmoothingMode(G, 4)
Gdip_SetSmoothingMode(G2, 4)
global pPen := Gdip_CreatePen("0xFFFF0000", 2)

Menu, Tray, NoStandard
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e948.ico"
Menu, Tray, Add, 画十字, TM_ModeC
Menu, Tray, Add, 画横线, TM_ModeH
Menu, Tray, Add, 画竖线, TM_ModeV
Menu, Tray, Add
Menu, Tray, Add, 退出(&X), TM_Exit

if (CandySel = "") or (CandySel = "十字")
{
	Mode := "Cross"
	Menu, Tray, Check, 画十字
}
else if (CandySel = "横线")
{
	Mode := "horizontal"
	Menu, Tray, Check, 画横线
}
else if (CandySel = "竖线")
{
	Mode := "vertical"
	Menu, Tray, Check, 画竖线
}
return

!q::
Gdip_GraphicsClear(G)  ;This sets the entire area of the graphics to 'transparent'
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height)  ;This is what actually changes the display

CoordMode, Mouse, Screen
MouseGetPos, x1, y1
BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0) ; save previous hdc first

Gdip_GraphicsClear(G2)
BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0)
if (Mode = "horizontal")
	Gdip_DrawLine(G2, pPen, 0, y1, Width, y1)
if (Mode = "vertical")
	Gdip_DrawLine(G2, pPen, x1, 0, x1, Height)
if (Mode = "Cross")
{
	Gdip_DrawLine(G2, pPen, 0, y1, Width, y1)
	Gdip_DrawLine(G2, pPen, x1, 0, x1, Height)
}

UpdateLayeredWindow(hwnd7, hdc2, 0, 0, Width, Height)

BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0) ;copy buffer to screen
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height) ; now draw on screen
return

TM_ModeC:
Mode := "Cross"
Menu, Tray, Check, 画十字
Menu, Tray, unCheck, 画竖线
Menu, Tray, unCheck, 画竖线
return

TM_ModeH:
Mode := "horizontal"
Menu, Tray, Check, 画横线
Menu, Tray, unCheck, 画十字
Menu, Tray, unCheck, 画竖线
return

TM_ModeV:
Mode := "vertical"
Menu, Tray, Check, 画
Menu, Tray, unCheck, 画十字
Menu, Tray, unCheck, 画横线
return

TM_Exit:
ExitApp