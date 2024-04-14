;|2.6|2024.04.14|1296
CandySel := Trim(A_Args[1])
;CandySel := 1682598190000
Cando_时间戳转换:
Gui, 66: Destroy
Gui, 66: Default

Gui, add, text, x10 y10 , Unix 时间戳:`n(19700101 秒数)
Gui, add, Edit, xp+150 yp w150 h24 vS_Timestamp, 
Gui, add, button, xp+160 yp w60 h25 gTS2T, 转换
Gui, add, Edit, xp+80 yp w150 h24 vS_Timestamp_UTC, 
Gui, add, text, xp+150 yp cBlue vdS_Timestamp_UTC gdelval, ×

Gui, add, text, x10 yp+38 cBlue ggetNowTS, Unix 时间戳:`n(点击获取当前时间)
Gui, add, Edit, xp+150 yp w150 h24 vTimestamp, 
Gui, add, button, xp+160 yp w60 h25 gTS2T1 Default, 转换
Gui, add, Edit, xp+80 yp w150 h24 vTimestamp_UTC, 
Gui, add, text, xp+150 yp cBlue vdTimestamp_UTC gdelval, ×

Gui, add, text, x10 yp+38, LDAP 时间戳:`n(16010101 100纳秒数)
Gui, add, Edit, xp+150 yp w150 h24 vLDAPTimestamp,
Gui, add, button, xp+160 yp w60 h25 gTS2T2 Default, 转换
Gui, add, Edit, xp+80 yp w150 h24 vLDAPTimestamp_UTC,
Gui, add, text, xp+150 yp cBlue vdLDAPTimestamp_UTC gdelval, ×

Gui, add, text, x10 yp+38 cBlue ggetNowT, 本地日期时间:`n(点击获取当前时间)
Gui, add, Edit, xp+150 yp w150 h24 vTime,
Gui, add, button, xp+160 yp w60 h25 gTS2T3 Default, 转换
Gui, add, text, xp+62 yp+5 cBlue vshowmore gshowutc, >>
Gui, add, Edit, xp+20 yp-5 w150 h24 vTime_UTC,
Gui, add, text, xp+150 yp cBlue vdTime_UTC gdelval, ×

Gosub, TimeCon
Gui, show, w400 h170, 时间戳转换
Return

66GuiClose:
66Guiescape:
Gui,66: Destroy
exitapp
Return

showutc:
if !showmore
{
	gui, show, w580 h170
	GuiControl,, showmore, <<
	showmore := 1
}
else
{
	gui, show, w400 h170
	GuiControl,, showmore, >>
	showmore := 0
}
return

delval:
whichcontrol := substr(A_GuiControl, 2)
GuiControl,, % whichcontrol
return

getNowT:
GuiControl,, Time, % A_Now
GuiControlGet, OutputVar,, Time_UTC
if !OutputVar
	GuiControl,, Time_UTC, % A_NowUTC
Return

getNowTS:
Tmp_Value := Time_human2unix(A_Now, 0)
GuiControl,, Timestamp, % Tmp_Value
GuiControlGet, OutputVar,, Timestamp_UTC
if !OutputVar
{
	Tmp_Value_UTC := Time_human2unix(A_NowUTC, 0)
	GuiControl,, Timestamp_UTC, % Tmp_Value_UTC
}
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
if s_Timestamp
{
	Timestamp := Trim(s_Timestamp) * 1000
	GuiControl,, Timestamp, % Timestamp
	Tmp_Value := Time_unix2LDAP(Timestamp)
	GuiControl,, LDAPTimestamp, % Tmp_Value
	Tmp_Value := Time_unix2human(Timestamp)
	GuiControl,, Time, % Tmp_Value
}
if s_Timestamp_UTC
{
	Timestamp_UTC := Trim(s_Timestamp_UTC) * 1000
	GuiControl,, Timestamp_UTC, % Timestamp_UTC
	Tmp_Value_UTC := Time_unix2LDAP(Timestamp_UTC)
	GuiControl,, LDAPTimestamp_UTC, % Tmp_Value_UTC
	Tmp_Value_UTC := Time_unix2human(Timestamp_UTC)
	GuiControl,, Time_UTC, % Tmp_Value_UTC
}
return

TS2T1:
Gui, 66: Default
Gui, Submit, NoHide
if Timestamp
{
	s_Timestamp := Trim(Timestamp) // 1000
	GuiControl,, s_Timestamp, % s_Timestamp
	Tmp_Value := Time_unix2human(s_Timestamp)
	GuiControl,, Time, % Tmp_Value
	Tmp_Value := Time_unix2LDAP(Trim(Timestamp))
	GuiControl,, LDAPTimestamp, % Tmp_Value
}
if Timestamp_UTC
{
	s_Timestamp_UTC := Trim(Timestamp_UTC) // 1000
	GuiControl,, s_Timestamp_UTC, % s_Timestamp_UTC
	Tmp_Value_UTC := Time_unix2human(s_Timestamp_UTC)
	GuiControl,, Time_UTC, % Tmp_Value_UTC
	Tmp_Value_UTC := Time_unix2LDAP(Trim(Timestamp_UTC))
	GuiControl,, LDAPTimestamp_UTC, % Tmp_Value_UTC
}
return

TS2T2:
Gui, 66: Default
Gui, Submit, NoHide
if LDAPTimestamp
{
	Tmp_Value := Time_LDAP2unix(Trim(LDAPTimestamp))
	GuiControl,, Timestamp, % Tmp_Value
	GuiControl,, s_Timestamp, % Tmp_Value // 1000
	Tmp_Value := Time_unix2human(Tmp_Value)
	GuiControl,, Time, % Tmp_Value
}
if LDAPTimestamp_UTC
{
	Tmp_Value_UTC := Time_LDAP2unix(Trim(LDAPTimestamp_UTC))
	GuiControl,, Timestamp_UTC, % Tmp_Value_UTC
	GuiControl,, s_Timestamp_UTC, % Tmp_Value_UTC // 1000
	Tmp_Value_UTC := Time_unix2human(Tmp_Value_UTC)
	GuiControl,, Time_UTC, % Tmp_Value_UTC
}
return

TS2T3:
Gui, 66: Default
Gui, Submit, NoHide
if !Time
{
	Time := A_Now
	GuiControl,, Time, % A_Now
}
if !Time_UTC
{
	Time_UTC := A_NowUTC
	GuiControl,, Time_UTC, % A_NowUTC
}
Tmp_Value := Time_human2unix(Time, 0)
Tmp_Value_UTC := Time_human2unix(Time_UTC, 0)
GuiControl,, Timestamp, % Tmp_Value
GuiControl,, Timestamp_UTC, % Tmp_Value_UTC
GuiControl,, s_Timestamp, % Tmp_Value // 1000
GuiControl,, s_Timestamp_UTC, % Tmp_Value_UTC // 1000
Tmp_Value := Time_unix2LDAP(Tmp_Value)
Tmp_Value_UTC := Time_unix2LDAP(Tmp_Value_UTC)
GuiControl,, LDAPTimestamp, % Tmp_Value
GuiControl,, LDAPTimestamp_UTC, % Tmp_Value_UTC
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