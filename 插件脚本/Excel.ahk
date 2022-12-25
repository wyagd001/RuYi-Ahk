冻结到单元格:
WinActivate, Ahk_ID %Windy_CurWin_id%
send !w
sleep 30
send f
sleep 30
send f
return

; 按下 Alt+H, 快捷键显示有B(屏幕上显示有绘制边框按钮) 才会生效
全部边框:
WinActivate, Ahk_ID %Windy_CurWin_id%
send !h
sleep 30
send b
sleep 30
send a
return

粘贴为数值:
WinActivate, Ahk_ID %Windy_CurWin_id%
send ^c
sleep 10
send ^!v
sleep 1000
send v
sleep 500
send {enter}
return

; 只对选中的首个单元格生效
输入为数值:
WinActivate, Ahk_ID %Windy_CurWin_id%
Tmp_V := StrSplit(CandySel, [A_Tab, "`r", "`n"])[1]
if Tmp_V is number
{
	send %Tmp_V%
	sleep 30
	send {enter}
}
return
