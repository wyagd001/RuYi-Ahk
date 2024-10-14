;|2.7|2024.07.14|1643
Arg := A_Args[1]
SysGet, MonitorNum, MonitorCount
if (MonitorNum = 2)
{
  SysGet, Monitor1, Monitor, 1
  Monitor1_Width := Monitor1Right - Monitor1Left
  Monitor1_Height := Monitor1Bottom - Monitor1Top
  SysGet, Monitor2, Monitor, 2
  Monitor2_Width := Monitor2Right - Monitor2Left
  Monitor2_Height := Monitor2Bottom - Monitor2Top
	if (Monitor1_Width = A_ScreenWidth)
	{
		主屏幕_宽 := Monitor1_Width
		主屏幕_高 := Monitor1_Height
    主屏幕_左 := Monitor1Left
    主屏幕_右 := Monitor1Right
    主屏幕_上 := Monitor1Top
    主屏幕_下 := Monitor1Bottom

		副屏幕_宽 := Monitor2_Width
		副屏幕_高 := Monitor2_Height
    副屏幕_左 := Monitor2Left
    副屏幕_右 := Monitor2Right
    副屏幕_上 := Monitor2Top
    副屏幕_下 := Monitor2Bottom
	}
	if (Monitor2_Width = A_ScreenWidth)
	{
		主屏幕_宽 := Monitor2_Width
		主屏幕_高 := Monitor2_Height
    主屏幕_左 := Monitor2Left
    主屏幕_右 := Monitor2Right
    主屏幕_上 := Monitor2Top
    主屏幕_下 := Monitor2Bottom

		副屏幕_宽 := Monitor1_Width
		副屏幕_高 := Monitor1_Height
    副屏幕_左 := Monitor1Left
    副屏幕_右 := Monitor1Right
    副屏幕_上 := Monitor1Top
    副屏幕_下 := Monitor1Bottom
	}
}
if (Arg = "主")
  gosub movetoprimary
else if (Arg = "副")
  gosub movetosecondary
return

;+F1::
movetoprimary:
CoordMode, Mouse, Screen
MouseMove, (A_ScreenWidth // 2), (A_ScreenHeight // 2)
sleep 1000
return

;+F2::
movetosecondary:
CoordMode, Mouse, Screen
vx := (副屏幕_左 + 副屏幕_右) // 2, vy := (副屏幕_下 + 副屏幕_上) // 2
MouseMove, % vx, % vy
;msgbox % vx "|" vy "|" 副屏幕_左 "|" 副屏幕_上 "|" 副屏幕_右 "|" 副屏幕_下
sleep 1000
return