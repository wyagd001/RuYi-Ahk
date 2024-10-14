;|2.8|2024.10.07|1680
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?p=319855#p319855
;================================================================================================================================
; Subject:        Gdip Draw shapes and lines with the mouse
; Description:    Proof of concept for drawing shapes and lines with the mouse using BitBlt()
; Topic:            https://www.autohotkey.com/boards/viewtopic.php?f=6&t=74009
; Sript version:  1.5
; AHK Version:    1.1.24.03 (U32)
; Tested on:      Win 7 (x64)
; Authors:        SpeedMaster, Hellbent
; Credits :       Special thanks to Linear Spoon (how to draw a filled rectangle)
; https://autohotkey.com/board/topic/92184-deleting-a-rectangle-or-range-created-with-gdi/
;
; Shortcuts:      Shift + left mouse = draw lines
;                 Alt + left mouse = draw filled rectangles
;                 Ctrl + left mouse = draw rectangles
;                 Win + left mouse = draw ellipses
;                 Ctrl + Z = undo last drawing 
;                 F1 = Toggle Gui 
;                 Ctrl + F1 = Display Help
;                 F9 = clear the screen
;                 
;
; other related topic: https://www.autohotkey.com/boards/viewtopic.php?f=76&t=60827&hilit=draw+on+screen

#SingleInstance force
;;#Include <My Altered Gdip Lib>  ;<------       Replace with your copy of GDIP

;*******   HB Alteration    ******
global ColorList := ["000000","7F7F7F","880015","ED1C24","FF7F27","FFF200","22B14C","00A2E8","3F48CC","A349A4","FFFFFF","C3C3C3","B97A57","FFAEC9","FFC90E","EFE4B0","B5E61D","99D9EA","7092BE","C8BFE7"]
ActionsListObj := {"Cline": "DrawCline", "Line": "DrawLine", "Rect": "DrawRect", "FRect": "DrawFRect", "Ellipse": "DrawEllipse", "Cross": "DrawCross", "Arrow": "DrawArrow", "earse": "DrawCline2", "Text": "DrawText", "Masic": "DrawMasic"}
global Handles := [],Handles2:=[],ALED,Thickness,LH,LA:="FF",LT:=5

;*********************************

SetBatchLines -1
SetMouseDelay -1 

coordmode, mouse, screen

; (+E0x80000 : must be used for UpdateLayeredWindow to work!) that is always on top (+AlwaysOnTop)
; 要使窗体拥有透明效果，则窗口必须有WS_EX_LAYERED扩展属性，而一般情况下窗口是不具有WS_EX_LAYERED属性的
Gui, 1: -Caption +E0x80000  +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs 
Gui, 1: Show, NA
hwnd7 := WinExist() ; hwnd7 to avoid conflict ("hwnd1" name is too much used in other scripts)
steps:=[]
pens:=[]

gosub f1

for k, v in handles {
	if (v=1) {
		LH:=k
	}
}

Onexit, exit

;---------------------------------------------------- Gdip stuff ----------------------------------------------
Width := A_ScreenWidth, Height := A_ScreenHeight
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
; 初始化 GDI+ ----> 创建位图 ----> 创建 DC ----> 把位图跟 DC 绑定 ----> 创建画布
; 屏幕，屏幕是一个全透明的玻璃, 屏幕后面的是 DC 。而 DC 的后面，则是画布。
; 设备无关位图 DIB(Device-Independent-Bitmap)
; DIB 具有自己的调色板信息，它可以不依赖系统的调色板。
hbm := CreateDIBSection(Width, Height)  ;screen
; 创建DC, 窗口都对应一个 DC, 可以把 DC 想象成一个视频缓冲区, 
; 对这个缓冲区进行操作，会表现在这个缓冲区对应的屏幕窗口上。
; 双缓冲技术, 把内容在内存 DC 中画好，再一次性拷贝到目标 DC 里
hdc := CreateCompatibleDC()             ;screen, device context, 设备环境
; 把 GDI 对象选入 DC 里。可以认为是 “把位图跟 DC 绑定”。
obm := SelectObject(hdc, hbm)           ;screen
hbm2 := CreateDIBSection(Width, Height) ;buffer
hdc2 := CreateCompatibleDC()            ;buffer
obm2 := SelectObject(hdc2, hbm2)        ;buffer
hbm3 := CreateDIBSection(Width, Height) ;saving buffer
hdc3 := CreateCompatibleDC()            ;saving buffer
obm3 := SelectObject(hdc3, hbm3)        ;saving buffer
; G 表示的是一张画布，之后不管我们贴图也好，画画也好，都是画到这上面。
G := Gdip_GraphicsFromHDC(hdc)
G2 := Gdip_GraphicsFromHDC(hdc2)
Gdip_SetSmoothingMode(G, 4)
Gdip_SetSmoothingMode(G2, 4)

;------------------------------------------------  create some brushes and pencils ------------------------------------
global pPen := Gdip_CreatePen("0xFF" ColorList[1] , 5)      
, pBrush := Gdip_BrushCreateSolid("0xFF" ColorList[1])
return

;*******   HB Alteration    ******
;********************************************************************************************************************************************
;********************************************************************************************************************************************
;********************************************************************************************************************************************
F1::
99GuiClose:

	if(showgui:=!showgui){
		if(!ft){
			ft:=1
			Gui,99:+AlwaysOnTop +ToolWindow
			Gui,99:Color,% ColorList[1], 333333
			Gui,99:Font,cWhite s8 ,Segoe UI
			y:=0,x:=m:=20,w:=m,C:="00ffff"
			Gui,99:Margin,20,20
			Loop,% ColorList.Length()	{
				if(A_Index=11)
					x:=m+w,y:=0
				y+=m
				Gui,99:Add,Text,% "x" x " y" y " w" m " h" m " hwndhwnd gChangeColor" " v1_" a_index, x
				Handles[hwnd] := A_Index
				Gui,99:Add,Progress,% "x" x " y" y " w" m " h" m " c" ColorList[A_Index] " Background" C " hwndhwnd" " v2_" a_index  ,100
				Handles2[A_Index]:= hwnd, C:="555555"
			}
			Gui,99:Add,Edit,xm y+1 w40 r1 Limit2 Center hwndALED gChangeBrush,FF
			Gui,99:Add,Edit,xm y+1 w40 r1 Limit2 Center hwndThickness gChangeBrush,5
			Gui,99:Add,button,xm y+2 w40 gapply, 应用
			GuiControl,% "99:Focus", % hwnd
			Gui,99:Add,button,x20 yp+30 w20 vCline gselectaction, 曲
			Gui,99:Add,button,x40 yp w20 vLine gselectaction, 线
			Gui,99:Add,button,x20 yp+30 w20 vRect gselectaction, 框
			Gui,99:Add,button,x40 yp w20 vFRect gselectaction, 块
			Gui,99:Add,button,x20 yp+30 w20 vEllipse gselectaction, 圆
			Gui,99:Add,button,x40 yp w20 vArrow gselectaction, 箭 
			Gui,99:Add,button,x20 yp+30 w20 , 占
			Gui,99:Add,button,x40 yp w20 w20 gclear, 清
			Gui,99:Add,button,x20 yp+30 w20 vText gselectaction, 字
			Gui,99:Add,button,x40 yp w20 vcross gselectaction, 十
			Gui,99:Add,button,x20 yp+30 w20 vearse gselectaction, 橡
			Gui,99:Add,button,x40 yp w20 vmasic gselectaction, 马
		}
		Gui,99:Show,% "x" A_ScreenWidth-250 " y150", 桌面画图
	}
	else{
		Gui,99:Hide
	}
	return

;------------------------------------------------  Undo/Redo stuff  ----------------------------------------------------
;clear the screen
f9::
clear:
Gdip_GraphicsClear(G)  ;This sets the entire area of the graphics to 'transparent'
; 对指定的源设备环境区域中的像素进行位块（bit_block）转换，以传送到目标设备环境。hdc2 目标   hdc  源
BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0)
BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0)
; 将 hdc 上的内容显示在 hwnd7 窗口上
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height)  ;This is what actually changes the display
steps:=[]
return

; undo last drawing
^Z::
steps.pop() ; erase last step

Gdip_GraphicsClear(G)  ;This sets the entire area of the graphics to 'transparent'
;UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height)  ;This is what actually changes the display

for k, v in steps
{
	refresh(v)
  ;ToolTip % k " | " steps.maxindex()
	if (k = steps.maxindex()-1)
		BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0) ; save previous hdc
}
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height)
BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0) ; refresh buffer
return

refresh(v)
{
  global
	Gdip_DeleteBrush( pBrush )
	Gdip_DeletePen( pPen )
  pPen := Gdip_CreatePen(v.1, v.2)
  pBrush := Gdip_BrushCreateSolid(v.1)

  LA := substr(v.1, 3, 2) ; transparency
  currentcontrol := "2_" _HasVal(colorlist, substr(v.1, 5))

  loop, % colorlist.length()
    GuiControl, % "99:+Background" "555555", % "2_" A_Index

  GuiControl, % "99:+Background" "00FFFF", % currentcontrol  ;select

  LH := _HasVal(handles, _HasVal(colorlist, substr(v.1, 5)))

  if (v.2 != "br") {
    LT := v.2                ;Thickness
    ;if Instr(v[3], "gdip")
      v[3](G, pPen, v.4, v.5, v.6, v.7)  ;draw the shape
    ;else
    ;{
      ;ToolTip % "画箭头 " v.3 " " v.4
      ;v[3](G, pPen, v.4)   ; 画箭头
    ;}
  }
  else
    v[3](G, pBrush, v.4, v.5, v.6, v.7) ;draw the shape

  GuiControl,, % Thickness, % LT ;thickness
  GuiControl,, % ALED, % LA    ;transparency
}
return

;------------------------------------------------ Help -------------------------------------------------

^F1::
help:=!help
if help {
  helptext:="Shift + 左键 = 绘制线条`n"
  helptext.="Alt + 左键 = 绘制填充矩形`n"
  helptext.="Ctrl + 左键 = 绘制矩形`n"
  helptext.="Win + 左键 = 绘制椭圆`n"
  helptext.="Ctrl + Z = 撤消上一个图形`n"
  helptext.="F9 = 清除屏幕`n" 
	helptext.="F1 = toggle help"
  tooltip, % helptext
}
else
	tooltip
return

selectaction:
if A_GuiControl && (A_GuiControl != PrevControl)
{
  WinGetPos, prevloopX, prevloopY, prevloopW, prevloopH
  PrevControl := A_GuiControl
  CurrMode := ActionsListObj[PrevControl]
}
else if (A_GuiControl = PrevControl)
{
  CurrMode := PrevControl := ""
  return
}
else
{
  CurrMode := ActionsListObj[PrevControl]
}
if CurrMode
{
  loop
  {
    if getKeyState("LButton", "P")
    {
      MouseGetPos, loopx, loopy
      if IsInArea(loopx, loopy, prevloopX, prevloopY, prevloopW, prevloopH)
        return
      Gdip_SetCompositingMode(G2, 0)
      settimer, % CurrMode, -30
      break
    }
  }
}
return

IsInArea(px,py,x,y,w,h)
{
	Return (px>x&&py>y&&px<x+w&&py<y+h)
}

;--------------------------------------------  Draw rectangles  ----------------------------------------------------
;Draw rectangles
^LButton::
DrawRect:
CoordMode, Mouse, Screen
MouseGetPos, x1, y1
BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0) ; save previous hdc first

while getKeyState("LButton", "P") ; draw in buffer
{
  MouseGetPos, x2, y2
  Gdip_GraphicsClear(G2)
  BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0) ; BitBlt first before drawing
  Gdip_DrawRectangle(G2, pPen, min(x1,x2), min(y1,y2), abs(x2-x1), abs(y2-y1))
  UpdateLayeredWindow(hwnd7, hdc2, 0, 0, Width, Height)
}

step := ["0x" LA ColorList[Handles[LH]], LT, "Gdip_DrawRectangle", min(x1,x2), min(y1,y2), abs(x2-x1), abs(y2-y1)]
steps.push(step)

  BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0) ;copy buffer to screen
  UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height) ; now draw on screen
settimer, selectaction, -30
return

;----------------------------------------------  Draw a filled rectangles  --------------------------------------------
;Draw a filled rectangles
!LButton::
DrawFRect:
CoordMode, Mouse, Screen
MouseGetPos, x1, y1
BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0) ; save previous hdc first

while getKeyState("LButton", "P") ; draw in buffer
{
  MouseGetPos, x2, y2
  Gdip_GraphicsClear(G2)
  BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0) ; BitBlt first before drawing
  ;FillRect seems to expect the (x,y) coordinates passed to always be the upper left corner and width,height to be positive
  Gdip_FillRectangle(G2, pBrush, min(x1,x2), min(y1,y2), abs(x2-x1), abs(y2-y1))
  UpdateLayeredWindow(hwnd7, hdc2, 0, 0, Width, Height)
}

step := ["0x" LA ColorList[Handles[LH]], "Br", "Gdip_FillRectangle", min(x1,x2), min(y1,y2), abs(x2-x1), abs(y2-y1)]
steps.push(step)

  BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0) ;copy buffer to screen
  UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height) ; now draw on screen
settimer, selectaction, -30
return

f2::reload
f5::
GuiControl,, % Thickness, 11
return

DrawCline2:
Gdip_SetCompositingMode(G2, 1)
pPen := Gdip_CreatePen(0x00FFFFFF, 20)
pBrush := Gdip_BrushCreateSolid(0x00FFFFFF)
DrawCline:
Critical
CoordMode, Mouse, Screen
MouseGetPos, x1, y1, Win
BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0)  ; save previous hdc first

while getKeyState("LButton", "P") ; draw in buffer
{
  MouseGetPos, x2, y2
  If (X2 != X1) || (Y2 != Y1)
  {
    Gdip_GraphicsClear(G2)
    BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0) ; BitBlt first before drawing
    Gdip_FillEllipse(G2, pBrush, x2-(LT//2), y2-(LT//2), LT, LT)
    Gdip_DrawLine(G2, pPen, x1 ? x1 : x2, y1 ? y1 : y2, x2, y2)
    step := ["0x" LA ColorList[Handles[LH]], LT, "Gdip_DrawLine", x1, y1, x2, y2]
    steps.push(step)
    x1 := x2, y1 := y2
    UpdateLayeredWindow(hwnd7, hdc2, 0, 0, Width, Height)
    sleep 40
    BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0)
    UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height)
  }
}

;BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0)
;UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height)
Critical Off

settimer, selectaction, -30
Return

;----------------------------------------------------  draw lines  -----------------------------------------------------
;draw lines
+lbutton::
DrawLine:
CoordMode, Mouse, Screen
MouseGetPos, x1, y1
BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0) ; save previous hdc first
    
while getKeyState("LButton", "P")
{
    MouseGetPos, x2, y2
    Gdip_GraphicsClear(G2)
    BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0)
    Gdip_DrawLine(G2, pPen, x1, y1, x2, y2)
    UpdateLayeredWindow(hwnd7, hdc2, 0, 0, Width, Height)
}

step := ["0x" LA ColorList[Handles[LH]], LT, "Gdip_DrawLine", x1, y1, x2, y2]
steps.push(step)

BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0) ;copy buffer to screen
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height) ; now draw on screen
settimer, selectaction, -30
return

;----------------------------------------------------  Draw ellipse  -------------------------------------------------
#LButton::
DrawEllipse:
CoordMode, Mouse, Screen
MouseGetPos, x1, y1
BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0) ; save previous hdc first

while getKeyState("LButton", "P") ; draw in buffer
{
  ;tooltip % x1 "|" y1
  MouseGetPos, x2, y2
  Gdip_GraphicsClear(G2)
  BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0) ; BitBlt first before drawing
  ;seems to expect the (x,y) coordinates passed to always be the upper left corner and width,height to be positive
  Gdip_DrawEllipse(G2, pPen, min(x1,x2), min(y1,y2), abs(x2-x1), abs(y2-y1))
  UpdateLayeredWindow(hwnd7, hdc2, 0, 0, Width, Height)
}

step := ["0x" LA ColorList[Handles[LH]], LT, "Gdip_DrawEllipse", min(x1,x2), min(y1,y2), abs(x2-x1), abs(y2-y1)]
steps.push(step)

BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0) ;copy buffer to screen
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height) ; now draw on screen
settimer, selectaction, -30
return

;----------------------------------------------------  Draw ellipse  -------------------------------------------------

;----------------------------------------------------  Draw Arrow  -------------------------------------------------
DrawArrow:
CoordMode, Mouse, Screen
MouseGetPos, x1, y1
BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0) ; save previous hdc first

while getKeyState("LButton", "P")
{
  MouseGetPos, x2, y2
  Gdip_GraphicsClear(G2)
  BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0)
  Gdip_Arrow(G2, pPen, x1, y1, x2, y2)
  UpdateLayeredWindow(hwnd7, hdc2, 0, 0, Width, Height)
}

step := ["0x" LA ColorList[Handles[LH]], LT, "Gdip_Arrow", x1, y1, x2, y2]
steps.push(step)

BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0) ;copy buffer to screen
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height) ; now draw on screen
settimer, selectaction, -30
return

Gdip_Arrow(Graphics, Pen, x1, y1, x2, y2) 
{
  ; define an arrow tip pointing right, front at 0/0 in polar 
  tip1_length := 30 
  tip1_angle := 150 ; degrees 
  tip2_length := 30 
  tip2_angle := 210 ; degrees 
  ; transform angle to radians 
  tip1_angle *= 0.01745329252 
  tip2_angle *= 0.01745329252 

  ; move line to the base of the coord-system to ... 
  P2_X := x2 - x1 
  P2_Y := y2 - y1 
  ; get "direction the line is pointing to" 
  P2_r := Kart2Polar_r( P2_X, P2_Y) 
  P2_Phi := Kart2Polar_Phi( P2_X, P2_Y, P2_r) 
  ; rotate the arrow to the lines direction 
  curr_tip1_angle := tip1_angle + P2_Phi 
  curr_tip2_angle := tip2_angle + P2_Phi 
  ; transform arrow coord to cartesian    
  pX1 := Round(Polar2Kart_X(tip1_length, curr_tip1_angle)) 
  pX2 := Round(Polar2Kart_X(tip2_length, curr_tip2_angle)) 
  pY1 := Round(Polar2Kart_Y(tip1_length, curr_tip1_angle)) 
  pY2 := Round(Polar2Kart_Y(tip2_length, curr_tip2_angle)) 
  ; move arrow to the end of the line 
  pX1 += x2 
  pX2 += x2 
  pY1 += y2 
  pY2 += y2

  Points = %x1%,%y1%|%x2%,%y2% 
  PointArrow1 = %x2%,%y2%|%pX1%,%pY1% 
  PointArrow2 = %x2%,%y2%|%pX2%,%pY2% 
  Gdip_DrawLines(Graphics, Pen, Points) 
  Gdip_DrawLines(Graphics, Pen, PointArrow1) 
  Gdip_DrawLines(Graphics, Pen, PointArrow2) 
  return 
}

Get_Color()
{
   Random, Red, 0, 225
   Random, Green, 0, 225
   Random, Blue, 0, 225
   Color := 0xFF000000
   Color += (Red << 16)
   Color += (Green << 8)
   Color += (Blue << 0)
   return (Color)
}

;Thanks to Zed Gecko for these four funtions
Polar2Kart_X(r, Phi)
{
   x := r * Cos(Phi)
   return x
}

Polar2Kart_Y(r, Phi)
{
   y := r * Sin(Phi)
   return y
}

Kart2Polar_r( x, y)
{
   r := Sqrt( (x*x) + (y*y) )
   return r
}

Kart2Polar_Phi(x, y, r)
{
   if (y < 0)
      Phi := -1 * ACos(x/r)
   else
      Phi := ACos(x/r)
   return Phi
}

;Currently this is not used
Distance(x1, y1, x2, y2)
{
   N := (x2-x1)**2 + (y2-y1)**2
   return ( sqrt(N) )
}

Drawcross:
Gdip_GraphicsClear(G)  ;This sets the entire area of the graphics to 'transparent'
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height)  ;This is what actually changes the display

CoordMode, Mouse, Screen
MouseGetPos, x1, y1
BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0) ; save previous hdc first

Gdip_GraphicsClear(G2)
BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0)
;if (Mode = "horizontal")
;	Gdip_DrawLine(G2, pPen, 0, y1, Width, y1)
;if (Mode = "vertical")
;	Gdip_DrawLine(G2, pPen, x1, 0, x1, Height)
;if (Mode = "Cross")
;{
	Gdip_DrawLine(G2, pPen, 0, y1, Width, y1)
	Gdip_DrawLine(G2, pPen, x1, 0, x1, Height)
;}

UpdateLayeredWindow(hwnd7, hdc2, 0, 0, Width, Height)

BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0) ;copy buffer to screen
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height) ; now draw on screen
settimer, selectaction, -30
return

exit:
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)

SelectObject(hdc2, obm2)
DeleteObject(hbm2)
DeleteDC(hdc2)
Gdip_DeleteGraphics(G2)

SelectObject(hdc3, obm3)
DeleteObject(hbm3)

Gdip_Shutdown(pToken)

exitapp
return

esc::exitapp

ChangeColor(hwnd){
	;global LH
	static LC := 1, C :="00FFFF"
	loop, % colorlist.length()
	GuiControl,% "99:+Background" "555555", % "2_" A_Index
	LH:=hwnd

	GuiControl,% "99:Focus", % Handles2[Handles[hwnd]]
	GuiControl,% "99:+Background555555",  % "2_" LC
	GuiControl,% "99:+Background" C, % Handles2[Handles[hwnd]]
	GuiControlGet,LA,99:,% ALED
	GuiControlGet,LT,99:,% Thickness
	Gui,99:Color,% ColorList[Handles[hwnd]]
	LC := Handles[hwnd]
	ChangeBrush()
}

ChangeBrush(){
	Gdip_DeleteBrush( pBrush )
	Gdip_DeletePen( pPen )
	pPen := Gdip_CreatePen("0x" LA ColorList[Handles[LH]], LT)      
	pBrush := Gdip_BrushCreateSolid("0x" LA ColorList[Handles[LH]])
}

apply:
if (!steps.Maxindex())
	return
BitBlt(hdc, 0, 0, Width, Height, hdc3, 0, 0)
steps[steps.maxindex()][1]:="0x" LA ColorList[Handles[LH]]  ;apply new selected color to the last shape
(steps[steps.maxindex()][2]!="br") && steps[steps.maxindex()][2]:=LT  ; apply transparency and thickness to the last shape
refresh(steps[steps.maxindex()])
UpdateLayeredWindow(hwnd7, hdc,0,0, Width, Height)
return

_HasVal(haystack, needle) {
    for index, value in haystack
        if (value = needle)
            return index
    if !(IsObject(haystack))
        throw Exception("Bad haystack!", -1, haystack)
    return 0
}

DrawText:
CoordMode, Mouse, Screen
MouseGetPos, x1, y1

font=tahoma
display_text=逗你玩
Options = x%x1% y%y1% w80 cff808080 Center Bold s20 r4
Gdip_GraphicsClear(G)  ;This sets the entire area of the graphics to 'transparent'
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height)  ;This is what actually changes the display

BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0)
Gdip_TextToGraphics(G2, display_text, Options, Font)

BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0) ;copy buffer to screen
UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height) ; now draw on screen
settimer, selectaction, -30
return

DrawMasic:
CoordMode, Mouse, Screen
MouseGetPos, x1, y1
BitBlt(hdc3, 0, 0, Width, Height, hdc, 0, 0) ; save previous hdc first

while getKeyState("LButton", "P") ; draw in buffer
{
  MouseGetPos, x2, y2
  Gdip_GraphicsClear(G2)
  BitBlt(hdc2, 0, 0, Width, Height, hdc, 0, 0) ; BitBlt first before drawing
  Gdip_DrawRectangle(G2, pPen, min(x1,x2), min(y1,y2), abs(x2-x1), abs(y2-y1))
  UpdateLayeredWindow(hwnd7, hdc2, 0, 0, Width, Height)
}
BitBlt(hdc2, 0, 0, Width, Height, hdc3, 0, 0)
UpdateLayeredWindow(hwnd7, hdc2, 0, 0, Width, Height)

aRect :=  min(x1,x2) "|" min(y1,y2) "|" abs(x2-x1) "|" abs(y2-y1)
;ToolTip % aRect
If (X2 != X1) || (Y2 != Y1)
{
  pBitmap := Gdip_BitmapFromScreen(aRect)
  ;Gdip_SetBitmapToClipboard(pBitmap)
  pBitmapOut := Gdip_CreateBitmap(abs(x2-x1), abs(y2-y1))
  Gdip_PixelateBitmap(pBitmap, pBitmapOut, 10)
  Gdip_DrawImage(G2, pBitmapOut, min(x1,x2), min(y1,y2), abs(x2-x1), abs(y2-y1))
  BitBlt(hdc, 0, 0, Width, Height, hdc2, 0, 0) ;copy buffer to screen
  UpdateLayeredWindow(hwnd7, hdc, 0, 0, Width, Height) ; now draw on screen

  step := ["0x" LA ColorList[Handles[LH]], LT, "Gdip_DrawRectangle", min(x1,x2), min(y1,y2), abs(x2-x1), abs(y2-y1)]
  steps.push(step)
}
settimer, selectaction, -30
return