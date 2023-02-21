OnMessage(0x4a, "Receive_WM_COPYDATA")
return

!q::
msgbox %A_ScriptDir%
msgbox % addd(2, 3)
return

Receive_WM_COPYDATA(wParam, lParam)
{
	ID := NumGet(lParam + 0)
	StringAddress := NumGet(lParam + 2*A_PtrSize)
	global Windy_CurWin_id := wParam
	global CandySel := StrGet(StringAddress)
	;msgbox %wParam% - %id%
	if IsLabel(ID)
	{
		SetTimer, % ID, -200
		return true
	}
}

1209:
测试标签:
msgbox, 你好!
return

addd(x, y)
{
	return x + y
}