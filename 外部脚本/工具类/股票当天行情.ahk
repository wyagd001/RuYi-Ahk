;|2.8|2024.11.21|1220
#Include <WinHttp>
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e9d2.ico"
SetFormat, float, 10.4

; <title>上证指数 3167.24 +1.08%(33.99)股票价格-行情-走势图-行情-金融界</title>
; [\+\-]?\d+\.\d+%?

settingInifile := A_ScriptDir "\股票当天行情.ini"
settingobj := ini2obj(settingInifile)
Global settingobj, settingInifile
ColorsOn := settingobj["选项"]["显示颜色"]
speccolor := settingobj["选项"]["仅五六列显示颜色"]
Gui, Add, ListView, w760 h250 hwndHLV vgupiaolistview, 序号|股票代码|股票名称|价格点数|涨跌|涨幅|涨跌(元)|持仓份额|单价(元)|投入(元)|盈亏(元)|
CLV := New LV_Colors(HLV)
Gui, Add, Button, grefresh, 刷新
Gui, Add, CheckBox, xp+60 yp vColorsOn ggcolor h25, 是否显示颜色
Gui, Add, CheckBox, xp+120 yp vspeccolor ggcolor h25, 仅5,6列显示颜色

Gui, Add, Button, x780 y5 w60 geditnewrow, 新增
Gui, Add, Button, xp yp+28 w60 geditrow, 编辑
Gui, Add, Button, xp yp+28 w60 gDelListItem, 删除

Gui, Add, Button, xp yp+40 w60 gMoveRow_Up, 向上
Gui, Add, Button, xp yp+28 w60 gMoveRow_Down, 向下

Gui, Add, Button, xp yp+40 w60 gopenweb, 打开网页
Gui, Add, Button, xp yp+28 w60 gopensetfile, 打开配置
Gui, Add, Button, xp yp+28 w60 gsearchcode, 代码查询

GuiControl,, ColorsOn, % ColorsOn
GuiControl,, speccolor, % speccolor
Gui, Show, AutoSize, 股票当天行情
gosub refresh
return

refresh:
Gui, Default 
CLV.clear()
LV_Delete()
;GuiControl, -redraw, gupiaolistview  ; 会导致 ListView 冻结
for k,v in settingobj["股票"]
{
	;msgbox % v
	code := GetStringIndex(v, 1), name := GetStringIndex(v, 2), fene := GetStringIndex(v, 3), chengben := GetStringIndex(v, 4)
	Tmp_Obj := Gupiao(code)
	if fene
		LV_Add("", A_Index, code, name?name:Tmp_Obj["名称"], Tmp_Obj["现价"], Tmp_Obj["涨跌"], Tmp_Obj["涨幅"], Format("{:.2f}", fene * Tmp_Obj["涨跌"]), fene, chengben, Format("{:.2f}", fene * chengben), Format("{:.2f}", fene * Tmp_Obj["现价"] - fene * chengben) " / " Format("{:.2f}", (fene * Tmp_Obj["现价"] - fene * chengben) *100 / (fene * chengben)) "`%")
	else
		LV_Add("", A_Index, code, name?name:Tmp_Obj["名称"], Tmp_Obj["现价"], Tmp_Obj["涨跌"], Tmp_Obj["涨幅"])
}
LV_ModifyCol()
LV_ModifyCol(1, "Logical 40")
LV_ModifyCol(2, "Logical 60")
LV_ModifyCol(4, "Logical 60")
LV_ModifyCol(5, "Logical")
LV_ModifyCol(7, 60)
LV_ModifyCol(8, 60)
LV_ModifyCol(9, 60)
LV_ModifyCol(10, 60)
if ColorsOn
{
	CLV.OnMessage()
	Loop, % LV_GetCount()
	{
		LV_GetText(OutputVar, A_Index, 5)
		;ToolTip % ColorsOn "|" OutputVar
		if (OutputVar + 0 > 0)
		{
			if !speccolor
				CLV.Row(A_Index, , "0xFF0000")
			else
			{
				CLV.Cell(A_Index, 5,, "0xFF0000")
				CLV.Cell(A_Index, 6,, "0xFF0000")
			}
		}
		else if (OutputVar = "--")
		{
			;ToolTip % ColorsOn "|" OutputVar
			if !speccolor
				CLV.Row(A_Index, , "0x000000")
			else
			{
				CLV.Cell(A_Index, 5,, "0x000000")
				CLV.Cell(A_Index, 6,, "0x000000")
			}
		}
		else if (OutputVar + 0 < 0)
		{
			if !speccolor
				CLV.Row(A_Index, , "0x00FF00")
			else
			{
				CLV.Cell(A_Index, 5,, "0x00FF00")
				CLV.Cell(A_Index, 6,, "0x00FF00")
			}
		}
	}
}
;GuiControl, +redraw, gupiaolistview
return

gcolor:
Gui, Submit, NoHide
If (ColorsOn)
{
	CLV.OnMessage()    ; 开启颜色
	GuiControl, Enable, speccolor
}
Else
{
	CLV.OnMessage(False)    ; 关闭颜色
	GuiControl, Disable, speccolor
}
settingobj["选项"]["仅五六列显示颜色"] := speccolor
settingobj["选项"]["显示颜色"] := ColorsOn
obj2ini(settingobj, settingInifile)
return

GuiClose:
ExitApp

Gupiao(Code)
{
	if (Code="000001") or (instr(code, "6") = 1) or (instr(code, "51") = 1) or (instr(code, "56") = 1) or (instr(code, "58") = 1)  ; 股票和ETF
		url := "https://summary.jrj.com.cn/stock/sh/" code
	else
		url := "https://summary.jrj.com.cn/stock/sz/" code
	webs := WinHttp.URLGet(url, "Charset:UTF-8")
	;if (code=515980)
		;msgbox % webs
	RegExMatch(webs, "<title>(.*)?</title>", Wtitle)
	RegExMatch(Wtitle1, "([\+\-]?\d+\.\d+%?)\s([\+\-]?\d+\.\d+%?)\(([\+\-]?\d+\.\d+%?)", Value)
	if !Value3
		RegExMatch(Wtitle1, "([\+\-]?\d+\.\d+%?)\s([\+\-]?\d+\.\d+%?)\((\-\-)", Value)
	;msgbox % Value2
	GPOBJ := {}
	GPOBJ["现价"] := Value1
	GPOBJ["涨幅"] := Value2
	GPOBJ["涨跌"] := Value3
	Array := StrSplit(Wtitle1, " ")
	GPOBJ["名称"] := Array[1]
	return GPOBJ
}

ini2obj(file)
{
	iniobj := {}
	FileRead, filecontent, %file% ;加载文件到变量
	StringReplace, filecontent, filecontent, `r, , All
	StringSplit, line, filecontent, `n, , ;用函数分割变量为伪数组
	Loop ;循环
	{
		if A_Index > %line0%
			Break
		content = % line%A_Index% ; 赋值当前行
		if (instr(content, ";") = 1)  ; 每行第一个字符为 ; 为注释跳过
			continue
		FSection := RegExMatch(content, "\[.*\]") ;正则表达式匹配section
		if FSection = 1 ;如果找到
		{
			TSection := RegExReplace(content, "\[(.*)\]", "$1") ; 正则替换并赋值临时section $为向后引用
			iniobj[TSection] := {}
		}
		Else
		{
			FKey := RegExMatch(content, "^.*=.*")    ;正则表达式匹配key
			if FKey
			{
				TKey := RegExReplace(content, "^(.*?)=.*", "$1")   ; 正则替换并赋值临时key
				;StringReplace, TKey, TKey, ., _, All               ; 会将键中的 "." 自动替换为 "_". 快捷键中有 ., 所以注释掉了
				TValue := RegExReplace(content, "^.*?=(.*)", "$1") ; 正则替换并赋值临时value
				if TKey
					iniobj[TSection][TKey] := TValue
			}
		}
	}
	Return iniobj
}

obj2ini(obj, file){
	if (!isobject(obj) or !file)
		Return 0
	for k,v in obj
	{
		for key,value in v                                  ; 删除的键值不会保存
		{
			IniWrite, %value%, %file%, %k%, %key%
			;fileappend %key%-%value%`n, %A_desktop%\123.txt
		}
	}
Return 1
}

GetStringIndex(String, Index := "", MaxParts := -1, SplitStr := "|")
{
	arrCandy_Cmd_Str := StrSplit(String, SplitStr, " `t", MaxParts)
	if Index
	{
		NewStr := arrCandy_Cmd_Str[Index]
		return NewStr
	}
	else
		return arrCandy_Cmd_Str
}

opensetfile:
run, % settingInifile
return

openweb:
RF := LV_GetNext(0, "F")
if RF
	LV_GetText(R_Code, RF, 2)
run http://fund.eastmoney.com/%R_Code%.html
return

editrow:
RF := LV_GetNext(0, "F")
if RF
{
	LV_GetText(R_index, RF, 1)
	LV_GetText(R_Code, RF, 2)
	LV_GetText(R_Name, RF, 3)
	LV_GetText(R_Share, RF, 8)
	LV_GetText(R_Price, RF, 9)
}
editnewrow:
Gui, 98:Destroy
Gui, 98:+Owner1
Gui, 1:+Disabled
Gui, 98:Default
Gui, Submit, NoHide
if !R_index && !R_Code
{
	NewCode := 1
	R_index := settingobj["股票"].Count()+1
}
else
	NewCode := 0
Gui, Add, Text, x20 y20 w50 h20, 编号：
Gui, Add, Text, x20 y50 w60 h20, 股票代码：
Gui, Add, Text, x20 y80 w80 h20, 股票名称：
Gui, Add, Text, x20 y110 w80 h20, 持有份额：
Gui, Add, Text, x20 y140 w80 h20, 成本价格：

Gui, Add, Edit, x110 y20 w100 h20 readonly vR_index, %R_index%
Gui, Add, Edit, x110 y50 w100 h20 vR_Code, %R_Code%
Gui, Add, Edit, x110 y80 w100 h20 vR_Name, %R_Name%
Gui, Add, Edit, x110 y110 w100 h20 vR_Share, %R_Share%
Gui, Add, Edit, x110 y140 w100 h20 vR_Price, %R_Price%

Gui, Add, Button, x200 y170 w70 h30 g98ButtonOK, 确定
Gui, Add, Button, x280 y170 w70 h30 g98GuiClose Default, 取消
Gui, Show,, % "股票基金项目" (NewCode ? "新增" : "编辑")
Return

98ButtonOK:
Gui, 98:Submit
Gui, 98:Destroy
Gui, 1:Default
Gui, 1:-Disabled
settingobj["股票"][R_index] := R_Code "|" R_Name "|" R_Share "|" R_Price
Tmp_Obj := Gupiao(R_Code)
if !NewCode
	LV_Modify(R_index, "", R_index, R_Code, R_Name, Tmp_Obj["现价"], Tmp_Obj["涨跌"], Tmp_Obj["涨幅"], Format("{:.2f}", R_Share * Tmp_Obj["涨跌"]), R_Share, R_Price, Format("{:.2f}", R_Share * R_Price), Format("{:.2f}", R_Share * Tmp_Obj["现价"] - R_Share * R_Price) " / " Format("{:.2f}", (R_Share * Tmp_Obj["现价"] - R_Share * R_Price) *100 / (R_Share * R_Price)))
else
	LV_Add("", R_index, R_Code, R_Name, Tmp_Obj["现价"], Tmp_Obj["涨跌"], Tmp_Obj["涨幅"], Format("{:.2f}", R_Share * Tmp_Obj["涨跌"]), R_Share, R_Price, Format("{:.2f}", R_Share * R_Price), Format("{:.2f}", R_Share * Tmp_Obj["现价"] - R_Share * R_Price) " / " Format("{:.2f}", (R_Share * Tmp_Obj["现价"] - R_Share * R_Price) *100 / (R_Share * R_Price)))
obj2ini(settingobj, settingInifile)
WinActivate, 股票当天行情 ahk_class AutoHotkeyGUI
R_index := R_Code := R_Name := R_Share := R_Price := ""
return

98GuiEscape:
98GuiClose:
Gui, 1:-Disabled
Gui, 98:Destroy
R_index := R_Code := R_Name := R_Share := R_Price := ""
Return

searchcode:
Gui, 2:Destroy
Gui, 2:Default
Gui, Add, Edit, x12 y5 w300 h80 vgpinfo,
Gui, Add, Edit, x12 y90 w300 h25 vgpcode hwndHandle gEditjisaun,
Gui, Add, Button, x12 y120 w60 h30 g600, 600
Gui, Add, Button, xp+60 yp w60 h30 g7, 7
Gui, Add, Button, xp+60 yp w60 h30 g8, 8
Gui, Add, Button, xp+60 yp w60 h30 g9, 9

Gui, Add, Button, x12 yp+35 w60 h30 g601, 601
Gui, Add, Button, xp+60 yp w60 h30 g4, 4
Gui, Add, Button, xp+60 yp w60 h30 g5, 5
Gui, Add, Button, xp+60 yp w60 h30 g6, 6

Gui, Add, Button, x12 yp+35 w60 h30 g002, 002
Gui, Add, Button, xp+60 yp w60 h30 g1, 1
Gui, Add, Button, xp+60 yp w60 h30 g2, 2
Gui, Add, Button, xp+60 yp w60 h30 g3, 3
Gui, Add, Button, xp+60 yp w60 h30 g删除, 删除

Gui, Add, Button, x12 yp+35 w60 h30 g300, 300
Gui, Add, Button, xp+60 yp w60 h30 g000, 000
Gui, Add, Button, xp+60 yp w60 h30 g0, 0
Gui, Add, Button, xp+60 yp w60 h30 ggpjiage, 查询
Gui, Add, Button, xp+60 yp w60 h30 g清除, 清空

Gui, Add, StatusBar, gSB vSB, Welcome!
SB_SetParts(73)
Menu, 历史, Add, 1, 历史
Menu, 历史, Add, 2, 历史
Menu, 历史, Add, 3, 历史
Menu, 历史, Add, 4, 历史
Menu, 历史, Add, 5, 历史
Menu, 历史, Add, 6, 历史
Menu, 历史, Add, 7, 历史
Menu, 历史, Add, 8, 历史
Menu, 历史, Add, 9, 历史
Menu, 历史, Add, 10, 历史
Menu, Menu, Add, 历史, :历史
Gui, Menu, Menu
Gui, Show, , 输入代码查询
return

2GuiEscape:
2GuiClose:
Gui, 2:Destroy
Return

gpjiage:
Gui, 2:Default
Gui, Submit, NoHide
Tmp_Obj := Gupiao(gpcode)
GuiControl, Text, gpInfo, % Tmp_Obj["名称"] " " Tmp_Obj["现价"] " " Tmp_Obj["涨跌"] " " Tmp_Obj["涨幅"]
if (StrLen(gpcode) >= 6)
{
  history++
  Menu, 历史, Rename, %history%&, %gpcode%=%numsym%
  if (history = 10)
    history := 0
}
return

MoveRow_Up:
Gui, Submit, NoHide
LV_MoveRow()
LV_RowIndexOrder()
LV_ListToObj("股票")
Return

MoveRow_Down:
Gui, Submit, NoHide
LV_MoveRow(0)
LV_RowIndexOrder()
LV_ListToObj("股票")
Return

LV_MoveRow(moveup = true) {
	; Original by diebagger (Guest) from:
	; http://de.autohotkey.com/forum/viewtopic.php?p=58526#58526
	; Slightly Modifyed by Obi-Wahn
	If moveup not in 1,0
		Return	; If direction not up or down (true or false)
	while x := LV_GetNext(x)	; Get selected lines
		i := A_Index, i%i% := x
	If (!i) || ((i1 < 2) && moveup) || ((i%i% = LV_GetCount()) && !moveup)
		Return	; Break Function if: nothing selected, (first selected < 2 AND moveup = true) [header bug]
				; OR (last selected = LV_GetCount() AND moveup = false) [delete bug]
	cc := LV_GetCount("Col"), fr := LV_GetNext(0, "Focused"), d := moveup ? -1 : 1
	; Count Columns, Query Line Number of next selected, set direction math.
	Loop, %i% {	; Loop selected lines
		r := moveup ? A_Index : i - A_Index + 1, ro := i%r%, rn := ro + d
		; Calculate row up or down, ro (current row), rn (target row)
		Loop, %cc% {	; Loop through header count
			LV_GetText(to, ro, A_Index), LV_GetText(tn, rn, A_Index)
			; Query Text from Current and Targetrow
			LV_Modify(rn, "Col" A_Index, to), LV_Modify(ro, "Col" A_Index, tn)
			; Modify Rows (switch text)
		}
		LV_Modify(ro, "-select -focus"), LV_Modify(rn, "select vis")
		If (ro = fr)
			LV_Modify(rn, "Focus")
	}
}

LV_RowIndexOrder()
{
	loop % LV_GetCount()
	{
		LV_Modify(A_index, , A_index)
	}
}

LV_ListToObj(SubObjName)
{
	loop % LV_GetCount()
	{
		LV_GetText(R_index, A_index, 1)
		LV_GetText(R_Code, A_index, 2)
		LV_GetText(R_Name, A_index, 3)
		LV_GetText(R_Share, A_index, 8)
		LV_GetText(R_Price, A_index, 9)
		settingobj[SubObjName][R_index] := R_Code "|" R_Name "|" R_Share "|" R_Price
	}
	obj2ini(settingobj, settingInifile)
}

DelListItem:
Gui, Submit, NoHide
RowNumber := 0, TmpArr := []
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber
		Break

	LV_GetText(Tmp_Str, RowNumber, 1)
	;msgbox % RowNumber "|" Tmp_Str
	TmpArr.Push(Tmp_Str)
}
Loop % TmpArr.Length()
{
	Tmp_Index := TmpArr.Pop()
	;msgbox % Tmp_Index
	settingobj["股票"].RemoveAt(Tmp_Index)
	IniDelete, % settingInifile, 股票, % settingobj["股票"].Count()+1
	LV_Delete(Tmp_Index)
}
LV_RowIndexOrder()
LV_ListToObj("股票")
return

FocusBack:
if (StrLen(gpcode) >= 6)
{
  history++
  Menu, 历史, Rename, %history%&, %gpcode%=%numsym%
  if (history = 10)
    history := 0
}

GuiControl, Text, gpcode, %numsym%
GuiControl, Focus, gpcode 
SendMessage, 0xB1, -2, -1,, ahk_id %Handle%
SendMessage, 0xB7,,,, ahk_id %Handle%
numsym := 0
return

Editjisaun:
Gui, Submit, NoHide
if InStr(gpcode, "!") > 0
	numsym := ZTrim(Fac(RTrim(gpcode, "!")))
if InStr(gpcode, "!") = 0
	numsym := Mather.Evaluate(gpcode)
SB_SetText(numsym, 2)
return

SB:
Gui, 2:Default
Gui, Submit, NoHide
GuiControl, Text, gpcode, %SB%
SB_SetText(gpcode)
Goto, Editjisaun
return

历史:
GuiControl, Text, gpcode, % StrReplace(SubStr(A_ThisMenuItem, 1, InStr(A_ThisMenuItem, "=")), "=")
GuiControl, Focus, gpcode 
SendMessage, 0xB1, -2, -1,, ahk_id %Handle%
SendMessage, 0xB7,,,, ahk_id %Handle%
Goto, Editjisaun
return

清除:
GuiControl, Text, gpcode
return

删除:
ControlSend,, {BS}, ahk_id %Handle% 
return

0:
1:
2:
3:
4:
5:
6:
7:
8:
9:
600:
601:
002:
000:
300:
Gui, 2:Default
Gui, Submit, NoHide
numsym := gpcode A_ThisLabel
Goto, FocusBack
return

ZTrim(x) {
	global Round
	x := Round(x, Round)
	IfInString, x, .00
	x := % Floor(x)
	return x
}

Fac(x) {
	var := 1
	Loop, %x%
		var *= A_Index
	return var
}

; ======================================================================================================================
; Namespace:      LV_Colors
; Function:       Individual row and cell coloring for AHK ListView controls.
; Tested with:    AHK 1.1.23.05 (A32/U32/U64)
; Tested on:      Win 10 (x64)
; Changelog:
;     1.1.04.01/2016-05-03/just me - added change to remove the focus rectangle from focused rows
;     1.1.04.00/2016-05-03/just me - added SelectionColors method
;     1.1.03.00/2015-04-11/just me - bugfix for StaticMode
;     1.1.02.00/2015-04-07/just me - bugfixes for StaticMode, NoSort, and NoSizing
;     1.1.01.00/2015-03-31/just me - removed option OnMessage from __New(), restructured code
;     1.1.00.00/2015-03-27/just me - added AlternateRows and AlternateCols, revised code.
;     1.0.00.00/2015-03-23/just me - new version using new AHK 1.1.20+ features
;     0.5.00.00/2014-08-13/just me - changed 'static mode' handling
;     0.4.01.00/2013-12-30/just me - minor bug fix
;     0.4.00.00/2013-12-30/just me - added static mode
;     0.3.00.00/2013-06-15/just me - added "Critical, 100" to avoid drawing issues
;     0.2.00.00/2013-01-12/just me - bugfixes and minor changes
;     0.1.00.00/2012-10-27/just me - initial release
; ======================================================================================================================
; CLASS LV_Colors
;
; The class provides six public methods to set individual colors for rows and/or cells, to clear all colors, to
; prevent/allow sorting and rezising of columns dynamically, and to deactivate/activate the message handler for
; WM_NOTIFY messages (see below).
;
; The message handler for WM_NOTIFY messages will be activated for the specified ListView whenever a new instance is
; created. If you want to temporarily disable coloring call MyInstance.OnMessage(False). This must be done also before
; you try to destroy the instance. To enable it again, call MyInstance.OnMessage().
;
; To avoid the loss of Gui events and messages the message handler might need to be set 'critical'. This can be
; achieved by setting the instance property 'Critical' ti the required value (e.g. MyInstance.Critical := 100).
; New instances default to 'Critical, Off'. Though sometimes needed, ListViews or the whole Gui may become
; unresponsive under certain circumstances if Critical is set and the ListView has a g-label.
; ======================================================================================================================
Class LV_Colors {
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; META FUNCTIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; __New()         Create a new LV_Colors instance for the given ListView
   ; Parameters:     HWND        -  ListView's HWND.
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 StaticMode  -  Static color assignment, i.e. the colors will be assigned permanently to the row
   ;                                contents rather than to the row number.
   ;                                Values:  True/False
   ;                                Default: False
   ;                 NoSort      -  Prevent sorting by click on a header item.
   ;                                Values:  True/False
   ;                                Default: True
   ;                 NoSizing    -  Prevent resizing of columns.
   ;                                Values:  True/False
   ;                                Default: True
   ; ===================================================================================================================
   __New(HWND, StaticMode := False, NoSort := True, NoSizing := True) {
      If (This.Base.Base.__Class) ; do not instantiate instances
         Return False
      If This.Attached[HWND] ; HWND is already attached
         Return False
      If !DllCall("IsWindow", "Ptr", HWND) ; invalid HWND
         Return False
      VarSetCapacity(Class, 512, 0)
      DllCall("GetClassName", "Ptr", HWND, "Str", Class, "Int", 256)
      If (Class <> "SysListView32") ; HWND doesn't belong to a ListView
         Return False
      ; ----------------------------------------------------------------------------------------------------------------
      ; Set LVS_EX_DOUBLEBUFFER (0x010000) style to avoid drawing issues.
      SendMessage, 0x1036, 0x010000, 0x010000, , % "ahk_id " . HWND ; LVM_SETEXTENDEDLISTVIEWSTYLE
      ; Get the default colors
      SendMessage, 0x1025, 0, 0, , % "ahk_id " . HWND ; LVM_GETTEXTBKCOLOR
      This.BkClr := ErrorLevel
      SendMessage, 0x1023, 0, 0, , % "ahk_id " . HWND ; LVM_GETTEXTCOLOR
      This.TxClr := ErrorLevel
      ; Get the header control
      SendMessage, 0x101F, 0, 0, , % "ahk_id " . HWND ; LVM_GETHEADER
      This.Header := ErrorLevel
      ; Set other properties
      This.HWND := HWND
      This.IsStatic := !!StaticMode
      This.AltCols := False
      This.AltRows := False
      This.NoSort(!!NoSort)
      This.NoSizing(!!NoSizing)
      This.OnMessage()
      This.Critical := "Off"
      This.Attached[HWND] := True
   }
   ; ===================================================================================================================
   __Delete() {
      This.Attached.Remove(HWND, "")
      This.OnMessage(False)
      WinSet, Redraw, , % "ahk_id " . This.HWND
   }
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PUBLIC METHODS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; Clear()         Clears all row and cell colors.
   ; Parameters:     AltRows     -  Reset alternate row coloring (True / False)
   ;                                Default: False
   ;                 AltCols     -  Reset alternate column coloring (True / False)
   ;                                Default: False
   ; Return Value:   Always True.
   ; ===================================================================================================================
   Clear(AltRows := False, AltCols := False) {
      If (AltCols)
         This.AltCols := False
      If (AltRows)
         This.AltRows := False
      This.Remove("Rows")
      This.Remove("Cells")
      Return True
   }
   ; ===================================================================================================================
   ; AlternateRows() Sets background and/or text color for even row numbers.
   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   AlternateRows(BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      This.AltRows := False
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["ARB"] := (BkBGR <> "") ? BkBGR : This.BkClr
      This["ART"] := (TxBGR <> "") ? TxBGR : This.TxClr
      This.AltRows := True
      Return True
   }
   ; ===================================================================================================================
   ; AlternateCols() Sets background and/or text color for even column numbers.
   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   AlternateCols(BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      This.AltCols := False
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["ACB"] := (BkBGR <> "") ? BkBGR : This.BkClr
      This["ACT"] := (TxBGR <> "") ? TxBGR : This.TxClr
      This.AltCols := True
      Return True
   }
   ; ===================================================================================================================
   ; SelectionColors() Sets background and/or text color for selected rows.
   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default selected background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default selected text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   SelectionColors(BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      This.SelColors := False
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["SELB"] := BkBGR
      This["SELT"] := TxBGR
      This.SelColors := True
      Return True
   }
   ; ===================================================================================================================
   ; Row()           Sets background and/or text color for the specified row.
   ; Parameters:     Row         -  Row number
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   Row(Row, BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      If This.IsStatic
         Row := This.MapIndexToID(Row)
      This["Rows"].Remove(Row, "")
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["Rows", Row, "B"] := (BkBGR <> "") ? BkBGR : This.BkClr
      This["Rows", Row, "T"] := (TxBGR <> "") ? TxBGR : This.TxClr
      Return True
   }
   ; ===================================================================================================================
   ; Cell()          Sets background and/or text color for the specified cell.
   ; Parameters:     Row         -  Row number
   ;                 Col         -  Column number
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> row's background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> row's text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   Cell(Row, Col, BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      If This.IsStatic
         Row := This.MapIndexToID(Row)
      This["Cells", Row].Remove(Col, "")
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      If (BkBGR <> "")
         This["Cells", Row, Col, "B"] := BkBGR
      If (TxBGR <> "")
         This["Cells", Row, Col, "T"] := TxBGR
      Return True
   }
   ; ===================================================================================================================
   ; NoSort()        Prevents/allows sorting by click on a header item for this ListView.
   ; Parameters:     Apply       -  True/False
   ;                                Default: True
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   NoSort(Apply := True) {
      If !(This.HWND)
         Return False
      If (Apply)
         This.SortColumns := False
      Else
         This.SortColumns := True
      Return True
   }
   ; ===================================================================================================================
   ; NoSizing()      Prevents/allows resizing of columns for this ListView.
   ; Parameters:     Apply       -  True/False
   ;                                Default: True
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   NoSizing(Apply := True) {
      Static OSVersion := DllCall("GetVersion", "UChar")
      If !(This.Header)
         Return False
      If (Apply) {
         If (OSVersion > 5)
            Control, Style, +0x0800, , % "ahk_id " . This.Header ; HDS_NOSIZING = 0x0800
         This.ResizeColumns := False
      }
      Else {
         If (OSVersion > 5)
            Control, Style, -0x0800, , % "ahk_id " . This.Header ; HDS_NOSIZING
         This.ResizeColumns := True
      }
      Return True
   }
   ; ===================================================================================================================
   ; OnMessage()     Adds/removes a message handler for WM_NOTIFY messages for this ListView.
   ; Parameters:     Apply       -  True/False
   ;                                Default: True
   ; Return Value:   Always True
   ; ===================================================================================================================
   OnMessage(Apply := True) {
      If (Apply) && !This.HasKey("OnMessageFunc") {
         This.OnMessageFunc := ObjBindMethod(This, "On_WM_Notify")
         OnMessage(0x004E, This.OnMessageFunc) ; add the WM_NOTIFY message handler
      }
      Else If !(Apply) && This.HasKey("OnMessageFunc") {
         OnMessage(0x004E, This.OnMessageFunc, 0) ; remove the WM_NOTIFY message handler
         This.OnMessageFunc := ""
         This.Remove("OnMessageFunc")
      }
      WinSet, Redraw, , % "ahk_id " . This.HWND
      Return True
   }
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PRIVATE PROPERTIES  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   Static Attached := {}
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PRIVATE METHODS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   On_WM_NOTIFY(W, L, M, H) {
      ; Notifications: NM_CUSTOMDRAW = -12, LVN_COLUMNCLICK = -108, HDN_BEGINTRACKA = -306, HDN_BEGINTRACKW = -326
      Critical, % This.Critical
      If ((HCTL := NumGet(L + 0, 0, "UPtr")) = This.HWND) || (HCTL = This.Header) {
         Code := NumGet(L + (A_PtrSize * 2), 0, "Int")
         If (Code = -12)
            Return This.NM_CUSTOMDRAW(This.HWND, L)
         If !This.SortColumns && (Code = -108)
            Return 0
         If !This.ResizeColumns && ((Code = -306) || (Code = -326))
            Return True
      }
   }
   ; -------------------------------------------------------------------------------------------------------------------
   NM_CUSTOMDRAW(H, L) {
      ; Return values: 0x00 (CDRF_DODEFAULT), 0x20 (CDRF_NOTIFYITEMDRAW / CDRF_NOTIFYSUBITEMDRAW)
      Static SizeNMHDR := A_PtrSize * 3                  ; Size of NMHDR structure
      Static SizeNCD := SizeNMHDR + 16 + (A_PtrSize * 5) ; Size of NMCUSTOMDRAW structure
      Static OffItem := SizeNMHDR + 16 + (A_PtrSize * 2) ; Offset of dwItemSpec (NMCUSTOMDRAW)
      Static OffItemState := OffItem + A_PtrSize         ; Offset of uItemState  (NMCUSTOMDRAW)
      Static OffCT :=  SizeNCD                           ; Offset of clrText (NMLVCUSTOMDRAW)
      Static OffCB := OffCT + 4                          ; Offset of clrTextBk (NMLVCUSTOMDRAW)
      Static OffSubItem := OffCB + 4                     ; Offset of iSubItem (NMLVCUSTOMDRAW)
      ; ----------------------------------------------------------------------------------------------------------------
      DrawStage := NumGet(L + SizeNMHDR, 0, "UInt")
      , Row := NumGet(L + OffItem, "UPtr") + 1
      , Col := NumGet(L + OffSubItem, "Int") + 1
      , Item := Row - 1
      If This.IsStatic
         Row := This.MapIndexToID(Row)
      ; CDDS_SUBITEMPREPAINT = 0x030001 --------------------------------------------------------------------------------
      If (DrawStage = 0x030001) {
         UseAltCol := !(Col & 1) && (This.AltCols)
         , ColColors := This["Cells", Row, Col]
         , ColB := (ColColors.B <> "") ? ColColors.B : UseAltCol ? This.ACB : This.RowB
         , ColT := (ColColors.T <> "") ? ColColors.T : UseAltCol ? This.ACT : This.RowT
         , NumPut(ColT, L + OffCT, "UInt"), NumPut(ColB, L + OffCB, "UInt")
         Return (!This.AltCols && !This.HasKey(Row) && (Col > This["Cells", Row].MaxIndex())) ? 0x00 : 0x20
      }
      ; CDDS_ITEMPREPAINT = 0x010001 -----------------------------------------------------------------------------------
      If (DrawStage = 0x010001) {
         ; LVM_GETITEMSTATE = 0x102C, LVIS_SELECTED = 0x0002
         If (This.SelColors) && DllCall("SendMessage", "Ptr", H, "UInt", 0x102C, "Ptr", Item, "Ptr", 0x0002, "UInt") {
            ; Remove the CDIS_SELECTED (0x0001) and CDIS_FOCUS (0x0010) states from uItemState and set the colors.
            NumPut(NumGet(L + OffItemState, "UInt") & ~0x0011, L + OffItemState, "UInt")
            If (This.SELB <> "")
               NumPut(This.SELB, L + OffCB, "UInt")
            If (This.SELT <> "")
               NumPut(This.SELT, L + OffCT, "UInt")
            Return 0x02 ; CDRF_NEWFONT
         }
         UseAltRow := (Item & 1) && (This.AltRows)
         , RowColors := This["Rows", Row]
         , This.RowB := RowColors ? RowColors.B : UseAltRow ? This.ARB : This.BkClr
         , This.RowT := RowColors ? RowColors.T : UseAltRow ? This.ART : This.TxClr
         If (This.AltCols || This["Cells"].HasKey(Row))
            Return 0x20
         NumPut(This.RowT, L + OffCT, "UInt"), NumPut(This.RowB, L + OffCB, "UInt")
         Return 0x00
      }
      ; CDDS_PREPAINT = 0x000001 ---------------------------------------------------------------------------------------
      Return (DrawStage = 0x000001) ? 0x20 : 0x00
   }
   ; -------------------------------------------------------------------------------------------------------------------
   MapIndexToID(Row) { ; provides the unique internal ID of the given row number
      SendMessage, 0x10B4, % (Row - 1), 0, , % "ahk_id " . This.HWND ; LVM_MAPINDEXTOID
      Return ErrorLevel
   }
   ; -------------------------------------------------------------------------------------------------------------------
   BGR(Color, Default := "") { ; converts colors to BGR
      Static Integer := "Integer" ; v2
      ; HTML Colors (BGR)
      Static HTML := {AQUA: 0xFFFF00, BLACK: 0x000000, BLUE: 0xFF0000, FUCHSIA: 0xFF00FF, GRAY: 0x808080, GREEN: 0x008000
                    , LIME: 0x00FF00, MAROON: 0x000080, NAVY: 0x800000, OLIVE: 0x008080, PURPLE: 0x800080, RED: 0x0000FF
                    , SILVER: 0xC0C0C0, TEAL: 0x808000, WHITE: 0xFFFFFF, YELLOW: 0x00FFFF}
      If Color Is Integer
         Return ((Color >> 16) & 0xFF) | (Color & 0x00FF00) | ((Color & 0xFF) << 16)
      Return (HTML.HasKey(Color) ? HTML[Color] : Default)
   }
}