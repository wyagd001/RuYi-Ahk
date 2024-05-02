;|2.6|2024.04.28|1565
CandySel := A_Args[1]
if RegExMatch(CandySel, "^\d{14}$|^\d{8}$")
{
	FormatTime, CandySel, % CandySel, yyyyMMdd
	;msgbox % CandySel
}
else
	CandySel := DateParse(CandySel)
Gui, Add, Text, x10 y10 cBlue ggetNowT, 时间
Gui, Add, Edit, xp+60 yp w160 vTime1, %CandySel%
Gui, add, text, xp+165 yp cBlue gcutday, 去掉时间
Gui, Add, Text, x10 yp+30 cBlue ggetNowT2, 时间2
Gui, Add, Edit, xp+60 yp w160 vTime2  
Gui, add, text, xp+165 yp cBlue gcutday2, 去掉时间
Gui, add, text, xp+60 yp cBlue gswitcht, 交换时间
Gui, Add, Text, x10 yp+30, 加上天数
Gui, Add, Edit, xp+60 yp w160 vAddedDays, -280
Gui, Add, Text, x10 yp+30, 结果
Gui, Add, Edit, xp+60 yp w160 vresult
Gui, add, button, xp+165 yp w60 h25 gjisuan Default, 执行计算
Gui, Add, Text, x70 yp+30 w160 vYearText,
Gui, show,, 天数计算
Return

jisuan:
Gui, Submit, NoHide
if Time2
{
	orgT := Time1
	EnvSub, Time1, %Time2%, days
	GuiControl,, result, % Time1
	nian := Time1//365
	if (nian != 0)
	{
		DaysLeft := orgT
		Time2 := Substr(orgT, 1, 4) - nian
		Time2 := Time2 Substr(orgT, 5, 8)
		EnvSub, DaysLeft, %Time2%, days
		;msgbox % Time2 "|" DaysLeft "|" Time1
		if (Time1 > 0)
			tian := Time1 -DaysLeft
		else
			tian := DaysLeft - Time1
		nian := abs(nian)
	}
	else
		tian := abs(Time1)
	if (Time1 > 0)
		tips = 已过去%nian%年，又%tian%天
	else
		tips = 还剩%nian%年，又%tian%天
	GuiControl,, YearText, %tips%
	return
}
if AddedDays
{
	Time1 += AddedDays, days
	FormatTime, Time1, % Time1, yyyyMMdd
	GuiControl,, result, % Time1
}
return

getNowT:
GuiControl,, Time1, % SubStr(A_Now, 1, 8)
return

getNowT2:
GuiControl,, Time2, % SubStr(A_Now, 1, 8)
return

switcht:
Gui, Submit, NoHide
GuiControl,, Time2, % Time1
GuiControl,, Time1, % Time2
return

cutday:
Gui, 66: Default
Gui, Submit, NoHide
FormatTime, Time1, % Time1, yyyyMMdd
GuiControl,, Time1, % Time1
return

cutday2:
Gui, 66: Default
Gui, Submit, NoHide
FormatTime, Time2, % Time2, yyyyMMdd
GuiControl,, Time2, % Time2
return

GuiClose:
Guiescape:
Gui, Destroy
exitapp
Return

DateParse(str) {
	static e1 = "i)(\d{1,2})\s*:\s*(\d{1,2})(?:\s*(\d{1,2}))?\s*([ap]m)"
		, e2 = "i)(?:(\d{1,2}+)[\s\.\-\/,]+)?(\d{1,2}|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*)[\s\.\-\/,]+(\d{2,4})"
	str := RegExReplace(str, "((?:" . SubStr(e2, 42, 47) . ")\w*)(\s*)(\d{1,2})\b", "$3$2$1", "", 1)
	If RegExMatch(str, "i)^\s*(?:(\d{4})([\s\-:\/])(\d{1,2})\2(\d{1,2}))?"
		. "(?:\s*[T\s](\d{1,2})([\s\-:\/])(\d{1,2})(?:\6(\d{1,2})\s*(?:(Z)|(\+|\-)?"
		. "(\d{1,2})\6(\d{1,2})(?:\6(\d{1,2}))?)?)?)?\s*$", i)
		d3 := i1, d2 := i3, d1 := i4, t1 := i5, t2 := i7, t3 := i8
	Else If !RegExMatch(str, "^\W*(\d{1,2}+)(\d{2})\W*$", t)
		RegExMatch(str, e1, t), RegExMatch(str, e2, d)
	f = %A_FormatInteger%
	SetFormat, Float, 02.0
	d := (d3 ? (StrLen(d3) = 2 ? 20 : "") . d3 : A_YYYY)
		. ((d2 := d2 + 0 ? d2 : (InStr(e2, SubStr(d2, 1, 3)) - 40) // 4 + 1.0) > 0 ? d2 + 0.0 : A_MM)
		. ((d1 += 0.0) ? d1 : A_DD) . t1 + (t4 = "pm" ? 12.0 : 0.0) . t2 + 0.0 . t3 + 0.0
	SetFormat, Float, %f%
	Return, d
}