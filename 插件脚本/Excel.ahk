���ᵽ��Ԫ��:
WinActivate, Ahk_ID %Windy_CurWin_id%
send !w
sleep 30
send f
sleep 30
send f
return

; ���� Alt+H, ��ݼ���ʾ��B(��Ļ����ʾ�л��Ʊ߿�ť) �Ż���Ч
ȫ���߿�:
WinActivate, Ahk_ID %Windy_CurWin_id%
send !h
sleep 30
send b
sleep 30
send a
return

ճ��Ϊ��ֵ:
WinActivate, Ahk_ID %Windy_CurWin_id%
send ^c
sleep 10
send ^!v
sleep 1000
send v
sleep 500
send {enter}
return

; ֻ��ѡ�е��׸���Ԫ����Ч
����Ϊ��ֵ:
WinActivate, Ahk_ID %Windy_CurWin_id%
Tmp_V := StrSplit(CandySel, [A_Tab, "`r", "`n"])[1]
if Tmp_V is number
{
	send %Tmp_V%
	sleep 30
	send {enter}
}
return
