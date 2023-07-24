﻿;|2.1|2023.07.24|1374
; Script by MrRight in 2015.
; from https://autohotkey.com/boards/viewtopic.php?t=8963
; Modified by Marius Şucan and Drugwash in 2018. Included in KeyPress OSD.
; Latest version at:
; https://github.com/marius-sucan/KeyPress-OSD
; http://marius.sucan.ro/media/files/blog/ahk-scripts/keypress-osd.ahk
; This is a slightly modified version made to work standalone - Drugwash 2021.
; Edited to allow no lag in detriment of double-click specific appearance. Added idle ripples. Drugwash 2022.03.02.

#NoEnv
#SingleInstance, Force
#Persistent
;#NoTrayIcon
#MaxThreads 255
#MaxThreadsPerHotkey 255
#MaxHotkeysPerInterval 500
CoordMode Mouse, Screen
SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
ListLines, Off
DetectHiddenWindows, On

Global Debug
Loop, % A_Args.Length()
	Debug .= A_Args[A_Index] " "
If InStr(Debug, "Dbg")
	OutputDebug, % "Ripples thread ID: " DllCall("kernel32\GetCurrentThreadId")

Global IsRipplesFile	:= 1		; True/False
 , ScriptSuspended		:= 0		; True/False
 , WinMouseRipples		:= "Mouse ripples"
 , ShowMouseRipples		:= 1		; True/False
 , ShowIdleRipples		:= 0		; True/False
 , NoDblClk			:= 0		; True/False
 , MouseRippleMinSize	:= 30		; [px]
 , MouseRippleMaxSize	:= 90		; [px]
 , MouseRippleThick		:= 3		; [px]
 , MouseRippleFrequency	:= 25		; [ms]
 , MouseRippleAlpha		:= 80		; [%]
 , MouseRippleLColor	:= "FF0000"	; [RGB]
 , MouseRippleMColor	:= "33CC33"	; [RGB]
 , MouseRippleRColor	:= "4499FF"	; [RGB]
 , MouseRippleVColor	:= "996699"	; [RGB]
 , MouseRippleHColor	:= "669966"	; [RGB]
 , MouseRippleLShape	:= 1		; [1-2] 1=Circle, 2=Square
 , MouseRippleMShape	:= 2		; [1-2] 1=Circle, 2=Square
 , MouseRippleRShape	:= 1		; [1-2] 1=Circle, 2=Square
 , MouseIdleTimer		:= 5000		; [ms]
 , MouseIdleMinSize		:= 30		; [px]
 , MouseIdleMaxSize		:= 80		; [px]
 , MouseIdleFrequency	:= 40		; [ms]
 , MouseIdleRippleColor	:= "808080"	; [RGB]
 , MouseIdleShape		:= 1		; [1-2] 1=Circle, 2=Square
 ;, MButts				:= "LButton|MButton|RButton|WheelDown|WheelUp|WheelLeft|WheelRight"
 , MButts				:= "LButton|MButton|WheelDown|WheelUp|WheelLeft|WheelRight"
 , MainMouseRippleThick	:= 3
 , Period, PointDir, tf
 , style1				:= "GdipDrawEllipse"
 , style2				:= "GdipDrawRectangle"
 , style3				:= "GdipDrawPolygon"
/*
vars := "ShowMouseRipples,MouseRippleMinSize,MouseRippleMaxSize,MouseRippleThick,MouseRippleFrequency
		,MouseRippleLColor,MouseRippleMColor,MouseRippleRColor,MouseRippleVColor,MouseRippleHColor
		,MouseRippleAlpha,MouseRippleLShape,MouseRippleMShape,MouseRippleRShape,AppName"
MainExe := AhkExported()
Loop, Parse, vars, CSV
	If ((i := MainExe.ahkgetvar(A_LoopField)) != "")
		%A_LoopField% := i
MainExe := vars := i := ""
*/
WinMouseRipples	:= AppName ? AppName ": Mouse ripples" : WinMouseRipples

OnExit("MouseRippleClose")
If (ScriptSuspended || !ShowMouseRipples)
	Return
MouseRippleSetup()
Return
;================================================================
MouseRippleClose() {
Global
If !ModuleInitialized
	Return
MREnd()
If pToken
	DllCall("gdiplus\GdiplusShutdown", "Ptr", pToken)
Sleep, 10
If hGdiplus
	DllCall("kernel32\FreeLibrary", "Ptr", hGdiplus)
If InStr(Debug, "Dbg")
	OutputDebug, Ripples thread exit
Return, ModuleInitialized := 0
}
;================================================================
MouseRippleSetup() {
Global
; Gdiplus initialization. Proper shutdown is done in MouseRippleClose()
If hGdiplus := DllCall("kernel32\LoadLibraryW", "Str", "gdiplus.dll")
	{
	If InStr(Debug, "Dbg")
		OutputDebug, Loaded gdiplus
	VarSetCapacity(buf, 16, 0)
	NumPut(1, buf)
	DllCall("gdiplus\GdiplusStartup", "PtrP", pToken, "Ptr", &buf, "Ptr", 0)
	If InStr(Debug, "Dbg")
		OutputDebug, Gdiplus token: %pToken%
	}
Else Return, IsRipplesFile := 0
If ShowMouseRipples
	MRInit()
ModuleInitialized := 1 ; if the above failed, the module is NOT initialized, so don't mislead the main script!
}
;================================================================
MRInit() {
Global
If InStr(Debug, "Dbg")
	OutputDebug, %A_ThisFunc%() start
If !pToken
	MouseRippleSetup()
MainMouseRippleThick := MouseRippleThick
;RippleWinSize := MouseRippleMaxSize
RippleWinSize := MouseRippleMaxSize+2*MouseRippleThick
RippleStep := MouseRippleMaxSize < 156 ? 4 : 6
;RippleMinSize := MouseRippleMaxSize < 156 ? 30 : 65
RippleMinSize := MouseRippleMaxSize < 156 ? MouseRippleMinSize : MouseRippleMinSize*2
;RippleMaxSize := RippleWinSize - 10
RippleMaxSize := RippleWinSize - 2*MouseRippleThick
RippleAlphaMax := Round(MouseRippleAlpha*255/100)
RippleAlphaStep := RippleAlphaMax // ((RippleMaxSize - RippleMinSize) / RippleStep)
;RippleVisible := False
;outputdebug, thick=%MouseRippleThick% min=%MouseRippleMinSize% max=%MouseRippleMaxSize% alpha=%MouseRippleAlpha%
DCT := NoDblClk ? 0 : DllCall("user32\GetDoubleClickTime")
;msgbox, DCT=%DCT%	; This is the actual delay before showing single-click ripples, set NoDblClk to 1 for no delay
hDeskDC := DllCall("user32\GetDC", "Ptr", 0, "Ptr")
VarSetCapacity(buf, 40, 0)
NumPut(40, buf, 0)
NumPut(RippleWinSize, buf, 4)
NumPut(RippleWinSize, buf, 8)
NumPut(1, buf, 12, "UShort")
NumPut(32, buf, 14, "UShort")
NumPut(0, buf, 16)
hRippleBmp := DllCall("gdi32\CreateDIBSection"
	, "Ptr"	, hDeskDC
	, "Ptr"	, &buf
	, "UInt", 0
	, "PtrP", ppvBits
	, "Ptr"	, 0
	, "UInt", 0
	, "Ptr")
DllCall("user32\ReleaseDC", "Ptr", 0, "Ptr", hDeskDC)
hRippleDC := DllCall("gdi32\CreateCompatibleDC", "Ptr", 0, "Ptr")
hOldRippleBmp := DllCall("gdi32\SelectObject", "Ptr", hRippleDC, "Ptr", hRippleBmp, "Ptr")
DllCall("gdiplus\GdipCreateFromHDC", "Ptr", hRippleDC, "PtrP", pRippleGraphics)
DllCall("gdiplus\GdipSetSmoothingMode", "Ptr", pRippleGraphics, "Int", 4)
ToggleMouseRipples()
If ShowIdleRipples
	SetTimer, MouseIdleTimer, %MouseIdleTimer%
If InStr(Debug, "Dbg")
	OutputDebug, %A_ThisFunc%() finished
}
;================================================================
MREnd() {
Global
ToggleMouseRipples(True)
SetTimer RippleTimer, Off
If hRippleDC
	{
	DllCall("gdi32\SelectObject", "Ptr", hRippleDC, "Ptr", hOldRippleBmp)
	DllCall("gdiplus\GdipDeleteGraphics", "Ptr", pRippleGraphics)
	DllCall("DeleteObject", "Ptr", hRippleBmp)
	DllCall("DeleteDC", "Ptr", hRippleDC)
	Gui, Ripple: Hide
	}
}
;================================================================
MouseRippleUpdate() {
Global
MREnd()
If ShowMouseRipples
	MRInit()
}
;================================================================
ShowRipple(_color, _style, _interval:=10, _dir:="") {
Global
Static lastStyle:="", lastEvent:="", lastClk := A_TickCount
If ScriptSuspended
	Return

Gui Ripple: Destroy
Sleep, 10
Gui Ripple: -Caption +LastFound +AlwaysOnTop +ToolWindow +Owner +E0x80000 +hwndhRippleWin
Gui Ripple: Show, NoActivate, %WinMouseRipples%
WinSet, ExStyle, -0x20, %WinMouseRipples%
_color := "0x" _color
;If RippleVisible
;	Return
;outputdebug, color=%_color% style=%_style% timer=%_interval%
w := InStr(_style, "Poly") ? 1 : 0	; wheel
RippleStart := _dir="I"
		? MouseIdleMinSize : w
		? RippleMinSize+40 : RippleMinSize
CRippleMaxSize := _dir="I" ? MouseIdleMaxSize : RippleMaxSize
If ((A_TickCount-lastClk<DCT) && lastEvent=_color && !w)
	{
	SetTimer RippleTimer, Off
	tf := 1.6
	MouseRippleThick := MainMouseRippleThick*tf
	RippleColor := _color & 0xBFBFBF
	_style := lastStyle
	lastEvent := ""
	Period := _interval*3
	}
Else
	{
	tf := 1
	MouseRippleThick := MainMouseRippleThick
	RippleColor := _color
	lastEvent := _color
	lastStyle := _style
	Period := _interval
	lastClk := A_TickCount
	Sleep, % (DCT - 10)*(1-w)
	}
PointDir := _dir
RippleStyle := _style
RippleDiameter := RippleStart
RippleAlpha := RippleAlphaMax
WinSet, AlwaysOnTop, On, %WinMouseRipples%
MouseGetPos _pointerX, _pointerY
RippleTimer()
SetTimer RippleTimer, %Period%
Return
}
;================================================================
; Currently not used
WaitDblClk() {
Global
tf := 1
MouseRippleThick := MainMouseRippleThick
RippleColor := _color
lastEvent := _color
lastStyle := _style
Period := _interval
PointDir := _dir
RippleStyle := _style
RippleDiameter := RippleStart
RippleAlpha := RippleAlphaMax
WinSet, AlwaysOnTop, On, %WinMouseRipples%
MouseGetPos _pointerX, _pointerY
RippleTimer()
SetTimer RippleTimer, %Period%
;tooltip, outta here
}
;================================================================
RippleTimer() {
Global
Static PolyBuf, c := Cos(4*ATan(1)/6), offset
SetTimer MouseIdleTimer, Off
DllCall("gdiplus\GdipGraphicsClear", "Ptr", pRippleGraphics, "Int", 0)
If ((RippleDiameter += RippleStep) < CRippleMaxSize)
	{
	offset := MouseRippleThick*tf/2
	DllCall("gdiplus\GdipCreatePen1"
		, "UInt"	, ((RippleAlpha -= RippleAlphaStep) << 24) | RippleColor
		, "Float"	, MouseRippleThick
		, "Int"		, 2
		, "PtrP"	, pRipplePen)
	If (RippleStyle != "GdipDrawPolygon")
		DllCall("gdiplus\"RippleStyle
		, "Ptr"		, pRippleGraphics
		, "Ptr"		, pRipplePen
		, "Float"	, offset
		, "Float"	, offset
		, "Float"	, RippleDiameter - 1
		, "Float"	, RippleDiameter - 1)
	Else
		{
		; cos(pi/6):=(l/2)/(RippleDiameter/2) => l := 2*(cos(Pi/6)*(RippleDiameter/2))
		VarSetCapacity(PolyBuf, 32, 0), L := 2*c*(RippleDiameter/2), H := c*L
		vx1:=(RippleDiameter-L)/2+offset	; left X
		vx2:=RippleDiameter/2+offset		; middle X
		vx3:=RippleDiameter/2+L/2+offset	; right X
		vy1:=H
		vy2:=offset
		vy3:=RippleDiameter-H
		vy4:=RippleDiameter-offset
		hx1:=offset
		hx2:=H
		hx3:=RippleDiameter-H
		hx4:=RippleDiameter-offset
		hy1:=RippleDiameter/2+offset
		hy2:=offset
		hy3:=RippleDiameter-offset
		x1 := (PointDir="U" || PointDir="D") ? vx1 : PointDir="L" ? hx1 : hx3
		x2 := (PointDir="U" || PointDir="D") ? vx2 : PointDir="L" ? hx2 : hx4
		x3 := (PointDir="U" || PointDir="D") ? vx3 : PointDir="L" ? hx2 : hx3
		x4 := (PointDir="U" || PointDir="D") ? vx1 : PointDir="L" ? hx1 : hx3
		y1 := PointDir="U" ? vy1 : PointDir="D" ? vy3 : PointDir="L" ? hy1 : hy2
		y2 := PointDir="U" ? vy2 : PointDir="D" ? vy4 : PointDir="L" ? hy2 : hy1
		y3 := PointDir="U" ? vy1 : PointDir="D" ? vy3 : PointDir="L" ? hy3 : hy3
		y4 := PointDir="U" ? vy1 : PointDir="D" ? vy3 : PointDir="L" ? hy1 : hy2
		NumPut(x1, PolyBuf, 0, "Float"), NumPut(y1, PolyBuf, 4, "Float")
		NumPut(x2, PolyBuf, 8, "Float"), NumPut(y2, PolyBuf, 12, "Float")
		NumPut(x3, PolyBuf, 16, "Float"), NumPut(y3, PolyBuf, 20, "Float")
		NumPut(x4, PolyBuf, 24, "Float"), NumPut(y4, PolyBuf, 28, "Float")
		DllCall("gdiplus\GdipDrawPolygon"
		, "Ptr"	, pRippleGraphics
		, "Ptr"	, pRipplePen
		, "Ptr"	, &PolyBuf
		, "UInt", 4)
		}
	DllCall("gdiplus\GdipDeletePen", "Ptr", pRipplePen)
	}
Else
	{
;	RippleVisible := False
	SetTimer RippleTimer, Off
	Gui Ripple: Destroy
	If ShowIdleRipples
		SetTimer MouseIdleTimer, %MouseIdleTimer%
	}
L := RippleDiameter+MouseRippleThick*tf
VarSetCapacity(buf, 8)
NumPut(_pointerX - L // 2, buf, 0)
NumPut(_pointerY - L // 2, buf, 4)
DllCall("user32\UpdateLayeredWindow"
	, "Ptr"		, hRippleWin
	, "Ptr"		, 0
	, "Ptr"		, &buf
	, "Int64P"	, L|L<<32
	, "Ptr"		, hRippleDC
	, "Int64P"	, 0
	, "UInt"	, 0
	, "UIntP"	, 0x1FF0000
	, "UInt"	, 2)
}
;================================================================
ToggleMouseRipples(force:=0) {
Global
If InStr(Debug, "Dbg")
	OutputDebug, %A_ThisFunc%(%force%) running
If (ScriptSuspended || force)
	Loop, Parse, MButts, |
		Hotkey, % "~*" A_LoopField, OnMouse%A_LoopField%, Off UseErrorLevel
Else Loop, Parse, MButts, |
	Hotkey, % "~*" A_LoopField, OnMouse%A_LoopField%, On UseErrorLevel
}
;================================================================
MouseIdleTimer:
MouseGetPos _x, _y
if (_x == _lastX and _y == _lastY)
    ShowRipple(MouseIdleRippleColor, style%MouseIdleShape%, MouseIdleFrequency, "I")
else
	{
	_lastX := _x, _lastY := _y
	SetTimer MouseIdleTimer, Off
	SetTimer MouseIdleTimer, %MouseIdleTimer%
	}
Return
;================================================================
OnMouseLButton:
Sleep, 0
ShowRipple(MouseRippleLColor, style%MouseRippleLShape%, MouseRippleFrequency)
Return

OnMouseRButton:
Sleep, 0
ShowRipple(MouseRippleRColor, style%MouseRippleRShape%, MouseRippleFrequency)
Return

OnMouseMButton:
Sleep, 0
ShowRipple(MouseRippleMColor, style%MouseRippleMShape%, MouseRippleFrequency)
Return

OnMouseWheelDown:
Sleep, 0
ShowRipple(MouseRippleVColor, style3, MouseRippleFrequency, "D")
Return

OnMouseWheelUp:
Sleep, 0
ShowRipple(MouseRippleVColor, style3, MouseRippleFrequency, "U")
Return

OnMouseWheelLeft:
Sleep, 0
ShowRipple(MouseRippleHColor, style3, MouseRippleFrequency, "L")
Return

OnMouseWheelRight:
Sleep, 0
ShowRipple(MouseRippleHColor, style3, MouseRippleFrequency, "R")
Return