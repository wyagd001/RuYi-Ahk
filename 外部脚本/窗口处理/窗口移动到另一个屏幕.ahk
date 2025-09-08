;|3.0|2025.09.06|1736
Windy_CurWin_id := A_Args[1]
if Windy_CurWin_id
  WinTitle := "ahk_id " Windy_CurWin_id
else
  WinTitle := "A"
;msgbox % WinTitle
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
	else if (Monitor2_Width = A_ScreenWidth)
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

;F1:: ; #代表Windows键，这里定义了Win+C的热键组合
CoordMode, Mouse, Screen

WinGetClass, Windy_CurWin_Class, % WinTitle                                ;  当前窗口的Class
if (Windy_CurWin_Class = "Progman")
  return
WinGetTitle, Windy_CurWin_Title, % WinTitle
if (Windy_CurWin_Title = "Program Manager") or (Windy_CurWin_Title = "AppBarWin")
  return
WinGet, mm, MinMax, % WinTitle
WinRestore, % WinTitle
WinGetPos, x, y, width, height, % WinTitle ; 获取当前活动窗口（A表示活动窗口）的位置和尺寸信息
if IsInArea(x,y,主屏幕_左,主屏幕_上,主屏幕_宽,主屏幕_高)
{
  vx := (副屏幕_左 + 副屏幕_右) // 2, vy := (副屏幕_下 + 副屏幕_上) // 2
  newX := vx - width / 2 ; 计算新的X坐标，让窗口在水平方向居中
  newY := vy - height / 2 ; 计算新的Y坐标，让窗口在垂直方向居中
  WinMove, % WinTitle,, newX, newY ; 将活动窗口（A）移动到计算好的新坐标位置，实现居中显示
  if mm=1
    WinMaximize, % WinTitle
}
else
{
  SysGet, MonitorWorkArea, MonitorWorkArea ; 获取主屏幕的工作区域（去除任务栏等占用的区域）信息
  newX := (MonitorWorkAreaRight - MonitorWorkAreaLeft - width) / 2 ; 计算新的X坐标，让窗口在水平方向居中
  newY := (MonitorWorkAreaBottom - MonitorWorkAreaTop - height) / 2 ; 计算新的Y坐标，让窗口在垂直方向居中
  WinMove, % WinTitle,, newX, newY ; 将活动窗口（A）移动到计算好的新坐标位置，实现居中显示
  if mm=1
    WinMaximize, % WinTitle
}
return

IsInArea(px,py,x,y,w,h)
{
	Return (px>x&&py>y&&px<x+w&&py<y+h)
}