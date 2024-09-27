;|2.8|2024.09.22|1679
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
CandySel := A_Args[1]

Gui Font, s9, Segoe UI
Gui Add, Text, x10 y12 w120 h23 +0x200, 身份证号:
Gui Add, Edit, x145 y13 w351 h23 gadddes vsfznum, % CandySel
Gui Add, Text, x8 y52 w120 h23 +0x200, 出生日期:
Gui Add, Edit, x145 y52 w351 h23 vcsrq
Gui Add, Text, x11 y98 w120 h23 +0x200, 性别:
Gui Add, DropDownList, x143 y99 w351 vxb gctui, 男|女
Gui Add, Radio, x156 y143 w120 h23 vtui63, 58/63岁退休
Gui Add, Radio, x280 y142 w140 h23 vtui55, 女: 55岁退休(原50岁)
Gui Add, button, x440 y142 w60 h23 gcalc, 计算
Gui Add, Text, x9 y184 w120 h23 +0x200, 退休日期:
Gui Add, Edit, x145 y183 w351 h23 vtxrq
Gui Add, Text, x9 y215 w120 h23 +0x200, 当年最低缴费年限:
Gui Add, Edit, x145 y215 w150 h23 vjfnx
Gui Add, Text, x320 y215 w150 h23 +0x200 vtxnl
Gui Show, w522 h255, 退休日期计算
if CandySel
  gosub adddes
Return

GuiEscape:
GuiClose:
    ExitApp

adddes:
gui submit, nohide
year := SubStr(sfznum, 7, 4)
month := SubStr(sfznum, 11, 2)
day := SubStr(sfznum, 13, 2)
GuiControl,, csrq, %year%-%month%-%day%
nannv := Mod(SubStr(sfznum, 17, 1), 2)=1?0:1
GuiControl, Choose, xb, % nannv + 1
if (nannv=0)
{
  GuiControl,, tui63, 1
  GuiControl, Disable, tui55
}
else
  GuiControl, Enable, tui55
return

ctui:
gui submit, nohide
if (xb="男")
{
  GuiControl,, tui63, 1
  GuiControl, Disable, tui55
}
else if  (xb="女")
  GuiControl, Enable, tui55
return

calc:
gui submit, nohide
if !csrq
{
  year := SubStr(sfznum, 7, 4)
  month := SubStr(sfznum, 11, 2)
  day := SubStr(sfznum, 13, 2)
}
else
{
  if (StrLen(csrq) = 10)
  {
    year := SubStr(csrq, 1, 4)
    month := SubStr(csrq, 6, 2)
    day := SubStr(csrq, 9, 2)
  }
  else if (StrLen(csrq) = 8)
  {
    year := SubStr(csrq, 1, 4)
    month := SubStr(csrq, 5, 2)
    day := SubStr(csrq, 7, 2)
  }
}

if !xb
  nannv := Mod(SubStr(sfznum, 17, 1), 2)=1?0:1
else
{
  if (xb="男")
    nannv := 0
  else if (xb="女")
    nannv := 1
}

if (tui55=1)
  addmonth := (60-((nannv)+1*(nannv))*5)*12 + MIN(Ceil(MAX(12*(year-1964-((nannv)+1*(nannv))*5)+month-12,0)/2), 60)
else
  addmonth := (60-(nannv+0*(nannv))*5)*12 + Min(Ceil(Max(12*(year-1964-((nannv)+0*(nannv))*5)+month-12,0)/4), 36)
;msgbox % tui55 "|" nannv "|" year "|" month "|" addmonth
;msgbox % (60-(nannv+0*(nannv)))*12 "`n" Min(Ceil(Max(12*(year-1964-((nannv)+0*(nannv))*5)+month-12,0)/4), 36)
txrq := JEE_DateAddMonths(year month, addmonth, "yyyy-MM")
GuiControl,, txrq, %txrq%-%day%
txyear := SubStr(txrq, 1, 4)
txmonth := SubStr(txrq, 6, 2)
;msgbox % txmonth "|" month
if (txyear <= 2029)
  jfnx := "15年"
else if (txyear = 2030)
  jfnx := "15年半"
else if (txyear = 2031)
  jfnx := "16年"
else if (txyear = 2032)
  jfnx := "16年半"
else if (txyear = 2033)
  jfnx := "17年"
else if (txyear = 2034)
  jfnx := "17年半"
else if (txyear = 2035)
  jfnx := "18年"
else if (txyear = 2036)
  jfnx := "18年半"
else if (txyear = 2037)
  jfnx := "19年"
else if (txyear = 2038)
  jfnx := "19年半"
else
  jfnx := "20年"
GuiControl,, jfnx, %jfnx%
txnl := ((txmonth - month) >= 0)?(txyear - year):(txyear - year - 1)
txyf := (txmonth - month)>=0?(txmonth - month):(txmonth - month + 12)
GuiControl,, txnl, 退休时年龄: %txnl% 岁 %txyf% 月
return

JEE_DateAddMonths(vDate, vNum, vFormat="yyyyMMddHHmmss")
{
	;make date the standard 14-character format:
	vDate .= SubStr(19990101000000, StrLen(vDate)+1)
	vYear := SubStr(vDate, 1, 4), vMonth := SubStr(vDate, 5, 2)
	vDay := SubStr(vDate, 7, 2), vTime := SubStr(vDate, 9)

	vMonths := (vYear*12) + vMonth + vNum
	vYear := Floor(vMonths/12)
	vMonth := Mod(vMonths,12)
	(!vMonth) && (vYear -= 1, vMonth := 12)

	if (vMonth = 2) && (vDay > 28)
		if !Mod(vYear,4) && (Mod(vYear,100) || !Mod(vYear,400)) ;4Y AND (100N OR 400Y)
			vDay := 29
		else
			vDay := 28
	if (vDay = 31) && RegExMatch(vMonth, "^(4|6|9|11)$")
		vDay := 30

	vDate := Format("{:04}{:02}{:02}" vTime, vYear, vMonth, vDay)
	if !(vFormat == "yyyyMMddHHmmss")
		FormatTime, vDate, % vDate, % vFormat
	return vDate
}












