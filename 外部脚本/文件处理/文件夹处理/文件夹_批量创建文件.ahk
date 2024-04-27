;|2.6|2024.04.22|1543
CandySel := A_Args[1]
tmp_Str := ""
GuiText(tmp_Str, "根据文件列表批量创建文件, 一行一个", "qq", 500)
return

GuiText(Gtext, Title:="", Label:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd, gp, st, end, step, long, pref, suff, gp2, dstep, stt, edt, dstep, tstyle
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd +Resize
	Gui, Add, Edit, Multi w%w% r%l% vmyedit ;-WantReturn
	;tooltip % "xp yp+30+" 20*l
	Gui, Add, Radio, % "xp h25 vgp yp+" 15*l, 阿拉伯数字
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

; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
; ---------------------------------------------------------------------------------
; Version: 2015-5-29 / Added 'reset' option (by tmplinshi)
;          2014-7-03 / toralf
;          2014-1-2  / tmplinshi
; requires AHK version : 1.1.13.01+
; =================================================================================
AutoXYWH(DimSize, cList*){       ; http://ahkscript.org/boards/viewtopic.php?t=1079
  static cInfo := {}
 
  If (DimSize = "reset")
    Return cInfo := {}
 
  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If ( cInfo[ctrlID].x = "" ){
        GuiControlGet, i, %A_Gui%:Pos, %ctrl%
        MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
        fx := fy := fw := fh := 0
        For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
            If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
              f%dim% := 1
        cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
    }Else If ( cInfo[ctrlID].a.1) {
        dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
        For i, dim in cInfo[ctrlID]["a"]
            Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
        GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
} } }