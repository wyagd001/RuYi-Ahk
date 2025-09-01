;|3.0|2025.07.16|1543
#Include <AutoXYWH>
CandySel := A_Args[1]
tmp_Str := ""
GuiText(tmp_Str, "根据文件列表批量创建文件, 一行一个", "qq", 500)
return

GuiText(Gtext, Title:="", Label:="", w:=300, l:=20)
{
	global
	Gui, GuiText: Destroy
	Gui, GuiText: Default
	Gui, +HwndTextGuiHwnd +Resize
	Gui, Add, text, x10 y10 w70, 目标文件夹:
	Gui, Add, Edit, xp+80 yp-3 w420, % CandySel

	Gui, Add, Edit, Multi x10 w%w% r%l% vmyedit Hwndhedit ;-WantReturn
	;tooltip % "xp yp+30+" 20*l
  Gui, Add, Button, % "xp h25 gaddfolder yp+" 15*l-5, 新增文件夹
  Gui, Add, Button, % "xp+90 h25 gaddfile yp", 新增文件
  Gui, Add, Button, % "xp+80 h25 gdelff yp", 删除
	Gui, Add, text, x10 yp+35 w60, 替换:
  Gui, Add, text, x10 yp+25 w70, 搜索字符串:
	Gui, Add, Edit, xp+80 yp-2 w120 vstext
  Gui, Add, text, xp+180 yp+2 w70, 替换为:
	Gui, Add, Edit, xp+60 yp-2 w120 vrtext
  Gui, Add, Button, xp+140 h25 yp-3 gretxt, 替换

	Gui, Add, Radio, % "x10 h25 vgp yp+" 30, 阿拉伯数字
	Gui, Add, Radio, xp+180 h25 vgp2 yp, 日期
	Gui, Add, text, x10 yp+30 w60, 起始:
	Gui, Add, Edit, xp+60 yp w80 gwline
	Gui, Add, updown, gwline vst, 1
	Gui, Add, text, xp+120 yp w80 ggetnow cblue, 起始日期:
	Gui, Add, Edit, xp+80 yp w120 vstt
	Gui, Add, text, x10 yp+30 w60, 结束:
	Gui, Add, Edit, xp+60 yp w80 gwline
	Gui, Add, updown, gwline vend, 10
	Gui, Add, text, xp+120 yp w80 cblue, 结束日期:
	Gui, Add, Edit, xp+80 yp w120 vedt 
	Gui, Add, text, x10 yp+30 w60, 增量:
	Gui, Add, Edit, xp+60 yp w80 gwline
	Gui, Add, updown, gwline vstep, 1
	Gui, Add, text, xp+120 yp w80, 增量天数:
	Gui, Add, Edit, xp+80 yp w120 gwline
	Gui, Add, updown, gwline2 vdstep, 0

	Gui, Add, text, x10 yp+30 w60, 数值长度:
	Gui, Add, Edit, xp+60 yp w80 gwline
	Gui, Add, updown, gwline vlong, 1

	Gui, Add, text, xp+120 yp w80, 格式化样式:
	Gui, Add, ComboBox, xp+80 yp w120 vtstyle, yyyyMMdd||yyyy年MM月dd日|yyyy-MM-dd
	Gui, Add, text, x10 yp+30 w60, 前缀:
	Gui, Add, Edit, xp+60 yp w80 gwline vpref, 
	Gui, Add, text, x10 yp+30 w60, 后缀:
	Gui, Add, Edit, xp+60 yp w80 gwline vsuff, 

	Gui, Add, Button, % "Default xp+" w-120 " yp w60 h30 g" Label, 执行
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	ExitApp
	Return

	GuiTextGuiSize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	AutoXYWH("wh", "myedit") ;, "gp", "st", "end", "step", "long", "pref", "suff")
	return
}

qq:
Gui, GuiText: Submit, NoHide
myedit := StrReplace(myedit, CandySel)
Loop, parse, myedit, `n, `r
{
	if InStr(A_LoopField, "\")
	{
		RegExMatch(A_LoopField, "(.*)\\(.*)\.(.*)$", subf)
		if !FileExist(CandySel "\" subf1)
			FileCreateDir, %CandySel%\%subf1%
	}
	if (RegExMatch(CandySel "\" A_LoopField, "(.*)\\(.*)\.(.*)$"))
	{
		Fileappend,, %CandySel%\%A_LoopField%
	}
	else
		FileCreateDir, %CandySel%\%A_LoopField%
}
Gui, GuiText: Destroy
ExitApp
Return

wline:
Gui, GuiText: Submit, NoHide
if gp
{
	if !st or !end or !step
		return
	tmp_str := ""
	loop
	{
		cur_num := st + (A_index - 1) * step
		if (cur_num > end)
			break
		cur_num := Format("{:0" long "}", cur_num)
		line_str := pref cur_num suff
		tmp_str .= line_str "`r`n"
	}
	GuiControl,, myedit, % tmp_str
}
if gp2
{
	if !stt or !edt or !dstep
		return

	tmp_str := AutoDate(stt, edt, dstep, tstyle)
	;msgbox % tmp_str
	GuiControl,, myedit, % tmp_str
}
return

wline2:
Gui, GuiText: Submit, NoHide
if gp2
{
	if !stt or !edt or !dstep
		return

	tmp_str := AutoDate(stt, edt, dstep, tstyle)
	;msgbox % tmp_str
	GuiControl,, myedit, % tmp_str
}
return

getnow:
GuiControl,, stt, % substr(A_now, 1, 8)
GuiControl,, edt, % substr(A_now, 1, 8)
return

addfolder:
Gui, GuiText: Submit, NoHide
ControlGet, OutputLine, CurrentLine,,, ahk_id %hedit%
ControlGet, OutputLineText, Line, %OutputLine%,, ahk_id %hedit%
if !OutputLineText
{
  myedit := "新建文件夹`n" myedit
  Sort myedit, U
  GuiControl,, myedit, % Trim(myedit, "`n")
}
else
{
  myedit := Strreplace(myedit, OutputLineText "`n", OutputLineText "`n" OutputLineText "\新建文件夹`n", , 1)
	Fline_array1 := {}
  newStr := ""
	Loop, Parse, myedit, `n, `r
	{
		if StrLen(A_LoopField) && Trim(A_LoopField, " `t")
		{
			if !Fline_array1[A_LoopField]
			{
				Fline_array1[A_LoopField] := 1
				newStr .= A_LoopField "`n"
			}
			else
				continue
		}
		else   ; 空行
			newStr .= A_LoopField "`n"
	}
  GuiControl,, myedit, % newStr
}
;msgbox % OutputVar " - " OutputVar2
return

addfile:
Gui, GuiText: Submit, NoHide
ControlGet, OutputLine, CurrentLine,,, ahk_id %hedit%
ControlGet, OutputLineText, Line, %OutputLine%,, ahk_id %hedit%
if !OutputLineText
{
  myedit := "新建文件.txt`n" myedit
  Sort myedit, U
  GuiControl,, myedit, % Trim(myedit, "`n")
}
else
{
  myedit := Strreplace(myedit, OutputLineText "`n", OutputLineText "`n" OutputLineText "\新建文件.txt`n", , 1)
	Fline_array1 := {}
  newStr := ""
	Loop, Parse, myedit, `n, `r
	{
		if StrLen(A_LoopField) && Trim(A_LoopField, " `t")
		{
			if !Fline_array1[A_LoopField]
			{
				Fline_array1[A_LoopField] := 1
				newStr .= A_LoopField "`n"
			}
			else
				continue
		}
		else   ; 空行
			newStr .= A_LoopField "`n"
	}
  GuiControl,, myedit, % newStr
}
return

delff:
Gui, GuiText: Submit, NoHide
ControlGet, OutputLine, CurrentLine,,, ahk_id %hedit%
ControlGet, OutputLineText, Line, %OutputLine%,, ahk_id %hedit%
myedit := Strreplace(myedit, OutputLineText "`n")
GuiControl,, myedit, % myedit
return

retxt:
Gui, GuiText: Submit, NoHide
myedit := Strreplace(myedit, stext, rtext)
GuiControl,, myedit, % myedit
return

AutoDate(StartLongDate := "", EndLongDate := "", step := 1, DateFormat := "yyyy年MM月dd日-dddd"){
global pref, suff
	If !(StartLongDate)
		StartLongDate := A_Now
	If !(EndLongDate)
		EndLongDate := A_Now
	If (RegExMatch(StartLongDate, "[^\d]")){
		MsgBox 请输入正确的待格式化日期格式：`n20001010
		Return 
	}
	FormatTime, StartTime, % StartLongDate, yyyyMMdd
	FormatTime, EndTime, % EndLongDate, yyyyMMdd
	StartLongDate += -step, days
	Loop {
		StartLongDate += step, days
		FormatTime, AutoTime, % StartLongDate, % DateFormat
		FormatTime, OutTime, % StartLongDate, yyyyMMdd
			;If (RegExReplace(Out,"^(\d{4}).+$","$1") != RegExReplace(OutTime,"^(\d{4}).+$","$1"))
			;If (RegExReplace(Out,"^\d{4}(\d{2}).+$","$1") != RegExReplace(OutTime,"^\d{4}(\d{2}).+$","$1"))
			;If (RegExReplace(Out,"^\d{6}(\d{2}).+$","$1") != RegExReplace(OutTime,"^\d{6}(\d{2}).+$","$1"))
		if (OutTime > EndTime)
				Break
		RDate .= "`n" pref AutoTime suff
	}
	Return Trim(RDate, "`n")
}