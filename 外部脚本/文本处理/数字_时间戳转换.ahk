CandySel := Trim(A_Args[1])
;CandySel := 1682598190000
Cando_时间戳转换:
Gui, 66: Destroy
Gui, 66: Default

Gui, add, text, x10 y10 , Unix 时间戳:
Gui, add, Edit, xp+100 yp-5 w150 h24 vS_Timestamp, 
Gui, add, button, xp+160 yp w60 h25 gTS2T, 转换

Gui, add, text, x10 yp+40 cBlue ggetNowTS, Unix 时间戳:
Gui, add, Edit, xp+100 yp-5 w150 h24 vTimestamp, 
Gui, add, button, xp+160 yp w60 h25 gTS2T1 Default, 转换

Gui, add, text, x10 yp+40, LDAP 时间戳:
Gui, add, Edit, xp+100 yp-5 w150 h24 vLDAPTimestamp,
Gui, add, button, xp+160 yp w60 h25 gTS2T2 Default, 转换

Gui, add, text, x10 yp+40 cBlue ggetNowT, 本地日期时间:
Gui, add, Edit, xp+100 yp-5 w150 h24 vTime,
Gui, add, button, xp+160 yp w60 h25 gTS2T3 Default, 转换

Gosub, TimeCon
Gui, show,, 时间戳转换
Return

66GuiClose:
66Guiescape:
Gui,66: Destroy
exitapp
Return

getNowT:
GuiControl,, Time, % A_Now
Return

getNowTS:
Tmp_Value := Time_human2unix(A_Now, 0)
GuiControl,, Timestamp, % Tmp_Value
Return

TimeCon:
Gui, 66: Default
If (StrLen(CandySel) <= 10)
{
	GuiControl,, S_Timestamp, % CandySel
	Gosub TS2T
}
If (StrLen(CandySel) = 13)
{
	GuiControl,, Timestamp, % CandySel
	Gosub TS2T1
}
else If (StrLen(CandySel) = 14)
{
	GuiControl,, Time, % CandySel
	Gosub TS2T3
}
else If (StrLen(CandySel) = 18)
{
	GuiControl,, LDAPTimestamp, % CandySel
	Gosub TS2T2
}
Return

TS2T:
Gui, 66: Default
Gui, Submit, NoHide
Timestamp := Trim(s_Timestamp) * 1000
GuiControl,, Timestamp, % Timestamp
Tmp_Value := Time_unix2LDAP(Timestamp)
GuiControl,, LDAPTimestamp, % Tmp_Value
Tmp_Value := Time_unix2human(Timestamp)
GuiControl,, Time, % Tmp_Value
return

TS2T1:
Gui, 66: Default
Gui, Submit, NoHide
s_Timestamp := Trim(Timestamp) // 1000
GuiControl,, s_Timestamp, % s_Timestamp
Tmp_Value := Time_unix2human(s_Timestamp)
GuiControl,, Time, % Tmp_Value
Tmp_Value := Time_unix2LDAP(Trim(Timestamp))
GuiControl,, LDAPTimestamp, % Tmp_Value
return

TS2T2:
Gui, 66: Default
Gui, Submit, NoHide
Tmp_Value := Time_LDAP2unix(Trim(LDAPTimestamp))
GuiControl,, Timestamp, % Tmp_Value
GuiControl,, s_Timestamp, % Tmp_Value // 1000
Tmp_Value := Time_unix2human(Tmp_Value)
GuiControl,, Time, % Tmp_Value
return

TS2T3:
Gui, 66: Default
Gui, Submit, NoHide
if !Time
{
	Time := A_Now
	GuiControl,, Time, % A_Now
}
Tmp_Value := Time_human2unix(Time, 0)
GuiControl,, Timestamp, % Tmp_Value 
GuiControl,, s_Timestamp, % Tmp_Value // 1000
Tmp_Value := Time_unix2LDAP(Tmp_Value)
GuiControl,, LDAPTimestamp, % Tmp_Value
return

Time_unix2human(time)
{
	if (StrLen(time) = 13)
		time //= 1000
	human = 19700101000000
	time -= ((A_NowUTC - A_Now) // 10000) * 3600        ; 时差
	human += %time%, Seconds
	return human
}

Time_human2unix(time, sec:=1)
{
	time -= 19700101000000, Seconds
	time += ((A_NowUTC - A_Now) // 10000) * 3600        ; 时差
	if sec
		return time
	else
		return time * 1000
}

Time_LDAP2unix(LDAP)   ; Ldap 转 unix 时间戳 (毫秒)
{
	return Floor((LDAP - 116444736000000000) / 10000)
}

Time_unix2LDAP(Timestamp)   ; unix 转 Ldap 时间戳 (毫秒)
{
	return Floor(Timestamp * 10000 + 116444736000000000)
}