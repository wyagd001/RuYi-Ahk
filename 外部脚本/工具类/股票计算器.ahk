;|2.8|2024.10.19|1665
#Include <Ruyi>
#Include <WinHttp>
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e9d2.ico"
SetFormat, float, 0.4
Round := 4
; <title>上证指数 3167.24 +1.08%(33.99)股票价格-行情-走势图-行情-金融界</title>
; [\+\-]?\d+\.\d+%?
jiekouArr := ["金融界", "天天基金"]
jiekou := "金融界"
searchcode:
Gui, Destroy
Gui, Default
Gui, Add, Edit, x12 y5 w300 h80 vgpinfo,
Gui, Add, Edit, x12 y90 w300 h25 vgpcode hwndHandle gEditjisaun,
Gui, Add, Button, xp+300 yp w60 h25 gopenweb, 网页

Gui, Add, Button, x12 y120 w60 h30 g!, n!
Gui, Add, Button, xp+60 yp w60 h30 g^, x^y
Gui, Add, Button, xp+60 yp w60 h30 g√, √
Gui, Add, Button, xp+60 yp w60 h30 g`%, `%
Gui, Add, Button, xp+60 yp w60 h30 g+, +
Gui, Add, Button, xp+60 yp w60 h30 gIsPrime, IsPr

Gui, Add, Button, x12 yp+35 w60 h30 g600, 600
Gui, Add, Button, xp+60 yp w60 h30 g7, 7
Gui, Add, Button, xp+60 yp w60 h30 g8, 8
Gui, Add, Button, xp+60 yp w60 h30 g9, 9
Gui, Add, Button, xp+60 yp w60 h30 g-, -

Gui, Add, Button, x12 yp+35 w60 h30 g601, 601
Gui, Add, Button, xp+60 yp w60 h30 g4, 4
Gui, Add, Button, xp+60 yp w60 h30 g5, 5
Gui, Add, Button, xp+60 yp w60 h30 g6, 6
Gui, Add, Button, xp+60 yp w60 h30 g*, *
Gui, Add, Button, xp+60 yp w60 h30 g删除, 删除

Gui, Add, Button, x12 yp+35 w60 h30 g002, 002
Gui, Add, Button, xp+60 yp w60 h30 g1, 1
Gui, Add, Button, xp+60 yp w60 h30 g2, 2
Gui, Add, Button, xp+60 yp w60 h30 g3, 3
Gui, Add, Button, xp+60 yp w60 h30 g/, /
Gui, Add, Button, xp+60 yp w60 h30 g清除, 清空

Gui, Add, Button, x12 yp+35 w60 h30 g300, 300
Gui, Add, Button, xp+60 yp w60 h30 g00, 00
Gui, Add, Button, xp+60 yp w60 h30 g0, 0
Gui, Add, Button, xp+60 yp w60 h30 g., .
Gui, Add, Button, xp+60 yp w60 h30 gEqual, =
Gui, Add, Button, xp+60 yp w60 h30 ggpjiage, 查询

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
Menu, 收藏, Add, 000001, 收藏
Menu, 收藏, Add, 399001, 收藏
Menu, 收藏, Add, 399006, 收藏
Menu, 收藏, Add, 161725=白酒LOF, 收藏
Menu, 收藏, Add, 513050=中概互联网ETF, 收藏
Menu, 收藏, Add, 512800=银行ETF, 收藏
Menu, 收藏, Add, 515790=光伏EFT, 收藏

Menu, 收藏2, Add, 004348=南方中证500, 收藏
Menu, 收藏2, Add, 003096=中欧医疗, 收藏
Menu, 收藏2, Add, 005918=天弘沪深300, 收藏
Menu, 接口, Add, 金融界, SAPI
Menu, 接口, Add, 天天基金, SAPI
Menu, 接口, Check, 金融界
Menu, Menu, Add, 接口, :接口
Menu, Menu, Add, 历史, :历史
Menu, Menu, Add, 收藏, :收藏
Menu, Menu, Add, 收藏2, :收藏2
Gui, Menu, Menu
Gui, Show, , 输入代码查询
return

Gupiao(Code, API:="金融界")
{
	if (API="金融界")
{
	if (Code="000001") or (instr(code, "6") = 1) or (instr(code, "51") = 1) or (instr(code, "56") = 1) or (instr(code, "58") = 1)  ; 股票和ETF
		url := "https://summary.jrj.com.cn/stock/sh/" code
	else
		url := "https://summary.jrj.com.cn/stock/sz/" code
}
else if (API="天天基金")
	url := "http://fundgz.1234567.com.cn/js/" code ".js"

GPOBJ := {}
	webs := WinHttp.URLGet(url, "Charset:UTF-8")
	;if (code=515980)
		;msgbox % API "|" code
	if (API="金融界")
{
	RegExMatch(webs, "<title>(.*)?</title>", Wtitle)
	RegExMatch(Wtitle1, "([\+\-]?\d+\.\d+%?)\s([\+\-]?\d+\.\d+%?)\(([\+\-]?\d+\.\d+%?)", Value)
	if !Value3
		RegExMatch(Wtitle1, "([\+\-]?\d+\.\d+%?)\s([\+\-]?\d+\.\d+%?)\((\-\-)", Value)
  Array := StrSplit(Wtitle1, " ")
  GPOBJ["名称"] := Array[1]
}
else if (API="天天基金")
{
	;jsonpgz({"fundcode":"008087","name":"华夏中证5G通信主题ETF联接C","jzrq":"2024-08-29","dwjz":"0.8813","gsz":"0.9124","gszzl":"3.53","gztime":"2024-08-30 15:00"});
;msgbox % webs
  jsonpgz := StrReplace(webs, "jsonpgz(")
jsonpgz := StrReplace(jsonpgz, ");")
  Myobj := JSON.Load(jsonpgz)
  Value1 := Myobj.gsz
  Value2 := Myobj.gszzl "%"
  Value3 := Value1 - Myobj.dwjz
  GPOBJ["名称"] := Myobj.Name
}

	;msgbox % Value2
	
	GPOBJ["价格"] := Value1
	GPOBJ["涨幅"] := Value2
	GPOBJ["涨跌"] := Value3

	return GPOBJ
}

opensetfile:
run, % settingInifile
return

openweb:
Gui, Default
Gui, Submit, NoHide
if (StrLen(gpcode) = 6)
{
  if gpcode is integer
    run http://fund.eastmoney.com/%gpcode%.html
}
return

GuiEscape:
GuiClose:
Gui, Destroy
exitapp
Return

gpjiage:
Gui, Default
Gui, Submit, NoHide
Tmp_Obj := Gupiao(gpcode, jiekou)
GuiControl, Text, gpInfo, % Tmp_Obj["名称"] " " Tmp_Obj["价格"] " " Tmp_Obj["涨跌"] " " Tmp_Obj["涨幅"]
if (StrLen(gpcode) >= 6)
{
  history++
  Menu, 历史, Rename, %history%&, %gpcode%=%numsym%
  if (history = 10)
    history := 0
}
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

SAPI:
;msgbox % A_ThisMenuItem "|" A_ThisMenuItemPos 
jiekou := jiekouArr[A_ThisMenuItemPos]
Menu, 接口, Check, % A_ThisMenuItem
bindex:=A_ThisMenuItemPos+1
if bindex>2
	bindex := 1
Menu, 接口, UnCheck, % bindex "&"
return

SB:
Gui, Submit, NoHide
GuiControl, Text, gpcode, %SB%
SB_SetText(gpcode)
Goto, Editjisaun
return

历史:
收藏:
GuiControl, Text, gpcode, % StrReplace(SubStr(A_ThisMenuItem, 1, (epos:=InStr(A_ThisMenuItem, "="))?epos:10), "=")
;msgbox % A_ThisMenuItem "|" epos "|" A_ThisMenu
if (A_ThisMenu = "收藏2")
{
  jiekou := "天天基金"
  Menu, 接口, Check, 天天基金
  Menu, 接口, UnCheck, 金融界
}
else if (A_ThisMenu = "收藏")
{
  jiekou := "金融界"
  Menu, 接口, UnCheck, 天天基金
  Menu, 接口, Check, 金融界
}
GuiControl, Focus, gpcode 
SendMessage, 0xB1, -2, -1,, ahk_id %Handle%
SendMessage, 0xB7,,,, ahk_id %Handle%
Gosub Editjisaun
Gosub gpjiage
return

清除:
GuiControl, Text, gpcode
GuiControl, Text, gpinfo
return

删除:
ControlSend,, {BS}, ahk_id %Handle% 
return

Equal:
$NumpadEnter::
if WinActive("输入代码查询")
{
	Gui, Submit, NoHide
	SB_SetText(gpcode)
	if InStr(gpcode, "!") > 0
		numsym := ZTrim(Fac(RTrim(gpcode, "!")))
	if InStr(gpcode, "!") = 0
		numsym := Mather.Evaluate(gpcode)
	GoSub, FocusBack
	;GuiControlGet, clipboard, , Edit1, 
}
if WinActive("输入代码查询") = 0
	Send, {enter}
return

IsPrime:
Gui, Submit, NoHide
GuiControl, Text, Button7, % IsPrime(gpcode)
Sleep, 1000
GuiControl, Text, Button7, IsPr
return

IsPrime(n,k=2) {
	d := k+(k<7 ? 1+(k>2) : SubStr("6-----4---2-4---2-4---6-----2",Mod(k,30),1)) 
	Return n < 3 ? n>1 : Mod(n,k) ? (d*d <= n ? IsPrime(n,d) : "Yes") : "No"
}

Per(x, y) {
	Per :=(x/100)*y
	return Per
}

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
!:
^:
+:
-:
*:
/:
%:
.:
√:
600:
601:
002:
00:
300:
Gui, Default
Gui, Submit, NoHide
numsym := gpcode A_ThisLabel
if (A_ThisLabel = "√")
	numsym := A_ThisLabel gpcode
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

;
; cJson.ahk 0.4.1
; Copyright (c) 2021 Philip Taylor (known also as GeekDude, G33kDude)
; https://github.com/G33kDude/cJson.ahk
;
; MIT License
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;

class JSON
{
	static version := "0.4.1-git-built"

	BoolsAsInts[]
	{
		get
		{
			this._init()
			return NumGet(this.lib.bBoolsAsInts, "Int")
		}

		set
		{
			this._init()
			NumPut(value, this.lib.bBoolsAsInts, "Int")
			return value
		}
	}

	EscapeUnicode[]
	{
		get
		{
			this._init()
			return NumGet(this.lib.bEscapeUnicode, "Int")
		}

		set
		{
			this._init()
			NumPut(value, this.lib.bEscapeUnicode, "Int")
			return value
		}
	}

	_init()
	{
		if (this.lib)
			return
		this.lib := this._LoadLib()

		; Populate globals
		NumPut(&this.True, this.lib.objTrue, "UPtr")
		NumPut(&this.False, this.lib.objFalse, "UPtr")
		NumPut(&this.Null, this.lib.objNull, "UPtr")

		this.fnGetObj := Func("Object")
		NumPut(&this.fnGetObj, this.lib.fnGetObj, "UPtr")

		this.fnCastString := Func("Format").Bind("{}")
		NumPut(&this.fnCastString, this.lib.fnCastString, "UPtr")
	}

	_LoadLib32Bit() {
		static CodeBase64 := ""
		. "FLYQAQAAAAEwVYnlEFOB7LQAkItFFACIhXT///+LRUAIixCh4BYASAAgOcIPhKQAcMdFAvQAFADrOIN9DAAAdCGLRfQF6AEAQA+2GItFDIsAAI1I"
		. "AotVDIkACmYPvtNmiRAg6w2LRRAAKlABwQAOiRCDRfQAEAViIACEwHW5AMaZiSBFoIlVpAEhRCQmCABGAAYEjQATBCSg6CYcAAACaRQLXlDHACIA"
		. "DFy4AZfpgK0HAADGRfMAxAgIi1AAkwiLQBAQOcJ1RwATAcdFCuwCuykCHAyLRewAweAEAdCJRbACiwABQAiLVeyDAMIBOdAPlMCIAEXzg0XsAYB9"
		. "EPMAdAuEIkXsfIrGgkUkAgsHu1sBJpgFu3uCmYlOiRiMTQSAvYGnAHRQx0Wi6Auf6AX5KJ/oAAQjhRgCn8dF5AJ7qQULgUGDauSEaqyDfeSwAA+O"
		. "qYAPE6EsDaGhhSlSx0XgiyngqilO4AACRQyCKesnUyAgIVUgZcdF3EIgVMdERdiLItgF/Kgi2EcAAkUMgiKDRdyABBiAO0XcfaQPtoB5gPABhMAP"
		. "hJ/AwIHCeRg5ReR9fOScGItFrMCNALCYiVVKnA2wmAGwZRlEXxfNDxPpgTjKE+nKQgSAIaIcgCEPjZ9C3NQLQOjUBf4oQNQAAkUMRNyhxCyQiVWU"
		. "zSyQYRaUsRiYbivqC+scwwlgi1UQiVTgCOAEVKQkBIEIYBqVCDqtKAN/Q4ctDIP4AXUek0EBLg76FwBhnAIBKKEDBQYPhV7COqzAmIbkICAAgVXH"
		. "RdDLKbjQBQcAB98pwynQAAETJQbCKekqJA4QodzFRgzMSwzMBQxfDEYM7swAASUGQwzHphiBsUMMYshLDMgFEl8MRgzIFwABJQZDDGRCDBiNSBAB"
		. "D7aVg7+siwAoiUwkoSwMjy3N+TD//+kv5BKBLQV1liBCBk8FVsBJ6QRIBYgCdWlAAY1VgCUEVNQUwVzEIho3IhogAItViItFxAHAiI0cAioaD7cT"
		. "ERoExAEFBgHQD7cAgGaFwHW36ZCiZ2LACyXABRcfJeYKwM8AASUGpmcuHIAVv9RGCgbkAAHjyeQPjEj6RP//ZJ4PhLXiFbzt6xW8P6+IC7wAASUG"
		. "BMRv4uLhqGH7CAu0/6iIBbQXgAAVA3RUuCABuDtFqBh8pFpxXVNxfV9xA11xkgmLXfzJw5DOkLEaAgBwiFdWkIizUYoMMBQUcQDHQAjRAdjHQAxS"
		. "DIAECIEEwCEOCJFBwABhH4P4IHQi5dgACnTX2AANdCLJ2AAJdLvYAHsPjIVygjxoBcdFoDIHVkWBj2AAqGMArGEAoYaM8AjQLkAYixWhAJDHRCQg"
		. "4gFEJCCLIAAAjU2QwDMYjdRNoGAAFFABEEGWcAAf8gtwAOMMQFdxAIkUJED/0IPsJItAY0U+sN8N3w3fDd8N1wB9D6yEVARuEgGFEG9DCQFAg/gi"
		. "dAq4YCj/xOm/EAqNRYDxYOEHAeAtaf7//4XAdPoX8wGf8AH/Cf8J/wn/CXXVADrFB0LPBZJplAjfVv2SCMQCFcICiIM4CP1jArCyZ4ABTxRPCk8K"
		. "TwqR1wAsdRIqBelUcBFmkFkWhQl8C18MgCwJQQIxVbCJUAjDqlTDdQLzA1sPhfBFGTYovIVwwUGxIjK5kwB4lgDOfJQA/yj8KI1gkAIiKZ6NEQVf"
		. "KV8pVimFaBED/EW00KbxAq8VrxWvFa8VYdcAXQ+EtpSP9imlkwNA2B/h+9kfFwr1AdXgi+RjArRhArpQFS8Kby8KLwovCtkfFioFgVzplgGACBkg"
		. "XcUJegkfIDUXILQWIFJ1AkQ4D4VMYwPvNYB4ReCSA+DDkAOjBAgA6e8FSxRvDbQH/pEgNwVcD4WqF51NKQdxe+CAAYlV4LsCazsuizkGwATbAlzc"
		. "Aqpd2wIv2wIv3AIv2wKqYtsCCNwCAdsCZtsCqgzcAtPbTW7bAgrcAqql2wJy2wIN3AJ32wIudNsCMR7ZAknbAnUPfIURTT7gA4ADsWVCz+nPwdcw"
		. "AQADoNyJwuEBOhuIL34w2AA5fyLDAoORAlMBAdCD6DCFAwTpgKk1g/hAfi0B2ADAtwBGfx+LReAPtwAAicKLRQiLAEEAkAHQg+g3AXDgIGaJEOtF"
		. "BVhmg1D4YH4tCDRmE+hXEQZ0Crj/AADpbQZEAAACQI1QAgAOiQAQg0XcAYN93BADD44WAD6DReAoAusmAypCBCoQjQpKAioIAEmNSAKJGk0AZhIA"
		. "Ugh9Ig+FAP/8//+LRQyLEkgBJinIAXcMi0AQCIPoBAEp4GbHCgAMeLgAEADp3QUjBBYDSC10JIgGLw8IjrEDig85D4+foYAIx0XYAYInDIArIhSB"
		. "A8dACIEnx0DmDAEDiSh1FIAWAWiKPjGIEDB1IxMghRXpjhELKTB+dQlJf2frCkcBdlCBd2vaCmtAyAAB2bsKgBn3AOMB0YnKi00IAIsJjXECi10I"
		. "AIkzD7cxD7/OAInLwfsfAcgRANqDwNCD0v+LAE0MiUEIiVEMSck+fhoJGX6dRXCrEAQAAJCIBi4PhYalTSyGI2YPbsDAAADKZg9iwWYP1mSFUEAQ"
		. "361BAYAI3VZYwGpBUAUAVNQBVOsAQotV1InQweAAAgHQAcCJRdQBQxVIAotVCIkKAcAbmIPoMImFTIXAD9tDAUXU3vmBErBACN7BhRTIMA7KMCKi"
		. "SANldBJIA0UPHIVVACANMQMHFHUxVQk00MAA2gA00wA0lVEVNMZF00uBE0AEAY3KF+tAzAYIK3URhgxX0IhNMsRiH8KizEGM61Ani1XMh07DUU4B"
		. "ENiJRcxYFb3HRSLIwTDHRcRCChOLhFXIqDHIg0XEQBgAxDtFzHzlgH0Q0wB0E0Mv20XIoaMwWAjrEUcCyUYiFeUoKyR0WCBN2JmJAN8Pr/iJ1g+v"
		. "APEB/vfhjQwWk2FVJFHrHcYGBXVmCibYcApELgMAA3oMAqFqZXQPhasiGsAiGgA3i0XABQcXAAAAD7YAZg++0FEmBTnCdGQqy+1AgwxFwKAexgaE"
		. "wHW6lA+2wIYAQAF0G6UPJ0N4oidDeOssQwMJABCLFeQWgoWJUAhCoUIBAItABKMCiYAUJP/Qg+wEgxcuT2UPhKqFF7yFF7wF6gyaFw6PF7yAF8YG"
		. "mhf76I+JF9yHF0IBgxdBAYsXgpKrlG51f8dFIgOA6zSLRbgFEhMX0gcCF+tYrBa4oBZmBvWgFr3nEeDnEUIB4xFBAQnqEesFIguNZfRbMF5fXcNB"
		. "AgUAIlUAbmtub3duX08AYmplY3RfAA0KCiALIqUBdHJ1ZQAAZmFsc2UAbgh1bGzHBVZhbHUAZV8AMDEyMzQANTY3ODlBQkMAREVGAFWJ5VNAg+xU"
		. "x0X0ZreLAEAUjVX0iVQkIBTHRCQQIitEJKIMwUONVQzAAgjAAQ8AqaAF4HPDFhjHReSpAgVF6MMA7MMA8IMKcBCJReRgAuPOIgwYqItV9MAIIKQL"
		. "HOQAghjhAI1N5IlMgw/fwQyBD8QDwjwgEAQnD2De0hCDNgl1MCEQcE7xBUAIi1UQi1JFAgTE62hmAgN1XGECElESu0AWf7lBBTnDGSjRfBWGAT0g"
		. "AYCJQNCD2P99LvAajTRV4HEPiXAPMR4EJATooQAChcB0EYsETeBGA4kBiVEEAJCLXfzJw5CQAXAVg+xYZsdF7ikTH0XwIBYUARBNDAC6zczMzInI"
		. "9xDiweoDNkopwYkCyhAHwDCDbfQBgSGA9GaJVEXGsAMJ4gL34pAC6AOJRQAMg30MAHW5jUJVoAH0AcABkAIQDYAJCGIRwwko/v//hpBACLMdYMdF"
		. "+EIuBhrkRcAKRfjB4AQgAdCJRdgBAUAYwDlF+A+NRPAZAAsKzlEC2PEMRfTGRQDzAIN99AB5B2GQAAH3XfRQHEMM9KC6Z2ZmZkAM6nAJhPgCUnkp"
		. "2InC/wyog23s8gzs8QymngNAwfkficopoAj0AYEGdaWAffMAdAYOQQMhA8dERaYtHXAnpsAAwA5gAtDGRYbrkCXiJotF5I0hjCDQAdAPtzBn5I3S"
		. "DMEWAcgDOnWQOQgCQABmhcB1GSUBDGUmAQYQBQHrEKG8AnQDUIS8AnQHg0XkAQDrh5CAfesAD2aEoWbhH1XYMJnRLemSyiQuQBwhFYyj4gChwxTU"
		. "xkXjgAvcgwvq3IIF1IQL3I8LCAKFC/sjAYoL44ILvAKBC7wCgQtC3IML4wB0D0oL65AYg0X48n1AEFIL8Nf9//9ySLosvz1iABNyQ2Aj6AWBD90A"
		. "3RpdkC7YswGyDsdF4ONjACIbjUXoUCcwAZEH7KGIED3jQBWhAB1BIXXATCQYjU3YBUFCav8MQeVIFUEhCz8LPwvAATES0QAxBIsAADqJIEmfC3+f"
		. "C58LnwufC58Lnws2O2Q9wAnmkgrSNjQKV0l8GIM1AStMfW6NRahoSib2kEBUD+s3gUN0IACLVbCLRfABwFSNHPBqDHSWDHGWE12xzg2hIcBs8CAQ"
		. "wWzw1gEFA2YntzNzPvR60xMA7IN97AB5bYtMTeyPQY9BuDAQBCk60KpOvr4DpkHCBXWjB+ECwQJAQb4tAOtbX88GzwZfVa8GrwalhCPrQj5CEyeN"
		. "Vb7WVuhnvxO/E7IT6AF8AyYUqWvpNbMqGJIGF3oFUIMimADpyXLcmAXpt5PdKQTkdVaiAxStA1wAVx0JHwYTBmMeBlEZBlxPHwYfBh8GaALpAR4G"
		. "73vTaBMGCB8GHwYfBmYCYgAAgrEA6Z8CAACLRRAgiwCNUAEAcIkQBOmNAogID7cAZgCD+Ax1VoN9DEAAdBSLRQwAjEgAAotVDIkKZsdgAFwA6w0K"
		. "3AJMF6ENTGYA6T0OwisJwoIKPGFuAOnbAQ1hFskCEQRhDTxhcgDpKnmOMGeJMAm8MHQAFOkXjjAFgAgPtgUABAAAAITAdCkRBjYfdgyGBX52B0K4"
		. "ABMA6wW4gAIAoIPgAeszCBQYCBTCE4QFPaAAdw0awBc2bykwjgl1jQkDGw+3AMCLVRCJVCQIAQEKVCQEiQQk6DptgR4rwhHAJ8gRi1UhwAwSZokQ"
		. "jRxFCAICBC+FwA+FOvwU//9TISJNIZDJwwCQkJBVieVTgwTsJIAQZolF2McARfAnFwAAx0UC+AE/6y0Pt0XYAIPgD4nCi0XwAAHQD7YAZg++ANCL"
		. "RfhmiVRFQugBB2bB6AQBDoMARfgBg334A36gzcdF9APBDjOCIQAci0X0D7dcRZLoiiOJ2hAybfRAEBD0AHnHAl6LXfwBwic="
		static Code := false
		if ((A_PtrSize * 8) != 32) {
			Throw Exception("_LoadLib32Bit does not support " (A_PtrSize * 8) " bit AHK, please run using 32 bit AHK")
		}
		; MCL standalone loader https://github.com/G33kDude/MCLib.ahk
		; Copyright (c) 2021 G33kDude, CloakerSmoker (CC-BY-4.0)
		; https://creativecommons.org/licenses/by/4.0/
		if (!Code) {
			CompressedSize := VarSetCapacity(DecompressionBuffer, 3935, 0)
			if !DllCall("Crypt32\CryptStringToBinary", "Str", CodeBase64, "UInt", 0, "UInt", 1, "Ptr", &DecompressionBuffer, "UInt*", CompressedSize, "Ptr", 0, "Ptr", 0, "UInt")
				throw Exception("Failed to convert MCLib b64 to binary")
			if !(pCode := DllCall("GlobalAlloc", "UInt", 0, "Ptr", 9092, "Ptr"))
				throw Exception("Failed to reserve MCLib memory")
			DecompressedSize := 0
			if (DllCall("ntdll\RtlDecompressBuffer", "UShort", 0x102, "Ptr", pCode, "UInt", 9092, "Ptr", &DecompressionBuffer, "UInt", CompressedSize, "UInt*", DecompressedSize, "UInt"))
				throw Exception("Error calling RtlDecompressBuffer",, Format("0x{:08x}", r))
			for k, Offset in [33, 66, 116, 385, 435, 552, 602, 691, 741, 948, 998, 1256, 1283, 1333, 1355, 1382, 1432, 1454, 1481, 1531, 1778, 1828, 1954, 2004, 2043, 2093, 2360, 2371, 3016, 3027, 5351, 5406, 5420, 5465, 5476, 5487, 5540, 5595, 5609, 5654, 5665, 5676, 5725, 5777, 5798, 5809, 5820, 7094, 7105, 7280, 7291, 8610, 8949] {
				Old := NumGet(pCode + 0, Offset, "Ptr")
				NumPut(Old + pCode, pCode + 0, Offset, "Ptr")
			}
			OldProtect := 0
			if !DllCall("VirtualProtect", "Ptr", pCode, "Ptr", 9092, "UInt", 0x40, "UInt*", OldProtect, "UInt")
				Throw Exception("Failed to mark MCLib memory as executable")
			Exports := {}
			for ExportName, ExportOffset in {"bBoolsAsInts": 0, "bEscapeUnicode": 4, "dumps": 8, "fnCastString": 2184, "fnGetObj": 2188, "loads": 2192, "objFalse": 5852, "objNull": 5856, "objTrue": 5860} {
				Exports[ExportName] := pCode + ExportOffset
			}
			Code := Exports
		}
		return Code
	}
	_LoadLib64Bit() {
		static CodeBase64 := ""
		. "xrUMAQALAA3wVUiJ5RBIgezAAChIiU0AEEiJVRhMiUUAIESJyIhFKEggi0UQSIsABAWVAh0APosASDnCD0SEvABWx0X8AXrrAEdIg30YAHQtAItF"
		. "/EiYSI0VQo0ATkQPtgQAZkUCGAFgjUgCSItVABhIiQpmQQ++QNBmiRDrDwAbICCLAI1QAQEIiRDQg0X8AQU/TQA/AT4QhMB1pQJ9iUWgEEiLTSAC"
		. "Q41FoABJichIicHoRhYjAI4CeRkQaMcAIgoADmW4gVfpFgkAMADGRfuAZYFsUDBJgwNAIABsdVsADAEox0X0Amw1hBAYiwRF9IBMweAFSAGa0IBG"
		. "sIALgAFQEIALGIPAAQANAImUwIgARfuDRfQBgH2Q+wB0EwEZY9AILRR8sgNWLIIPCEG4wlsBMQZBuHsBuw9gBESJj1+AfSgAdFBkx0XwjLvwgpsm"
		. "mhyxu/DAXcMP5hvHXcjHRezCSqUGAidEQQLsSUGog33sAA8sjsqBL5hhLJQxZsfUReiMMeiCIV+AIa8xluiAMcMPH4gx6y+ZJkIglCZ5x0XkgiZo"
		. "KMdF4Mwo4MIYvhpt8SjgwCjDD37AD8UogwRF5MAFMDtF5H0IkA+2wJDwAYTAuA+E6EDpQVwGkTBBmdyNiZxbUL1AAajgB+FoSpjoaJjkaP4fJQoc"
		. "mTQK6f5DVIkK6epgAo3qEzjiE0Fsx0XcrCay3KIeihm/Jq8m3KAjXeMHSuAHCIOFGpCIGpAthBophhrWJCwsDesbp2YK5AlkCb0gewk6UC4Dv04t"
		. "NItAGIP4AU51YTCAEAoQXB4gcReGA2Iw4wQGD4Wf4EMzYwVhswkYoAHgl2nH1EXYbC/YYicXAAR/L01tL9hgL+MH1xdnL+m0iwJpD21AA2QP1GwP"
		. "utRiB6AABH8PbQ/UYA9V4wdgaQ8Pag8BZw/QtWwP0GIHKn8PcA/QYA8p4wfqFmgPk2JyMI00SAFACk1B48AQAExDgAZBColMJCDBNa1g+P//6WjE"
		. "M8I1Bax1H2QFLDtiITs9SQUQAg+Fg6NtqEiNoJVw////4QSKYJoox0XMIhxIIxwuSIiLlXjAA4tFzAAVYAHATI0EABttHEHoD7cQUxzMkAAKBFBd"
		. "AA+3AGaFwHWeVOmqUjzIHBXIEhHdbhUfFR8V7QbIEBXzA5338ANbPCoRb6AO7zMPTtoFDuzQBahI8XYPjET5RP//8VwPhN3iDMTl7AzE4gjwFO8M"
		. "7wwNB/bEAAfzA7DwA1dzMZRyY+sBkskGvMIChs8GzwbOBha8wAbzA0bIBoNFwIFwAcA7RTB8kKyFOl2khX2vha+FqJFIgeLEAQxdw5AKAOyiDgAK"
		. "VcCjMEEsjawkgBVCpI2zpJURJEiLhQthAKAbFLUASMdACNvyEZAJhaICAQpQAArTAAcRUXUBMSmD+CB01REtAQp0wi0BDXSvES0BCXScLQF7D4WO"
		. "KcJUrweiB8dFUMIQKMdFWHQAYHIAiwWOA+E4AT9BowX1/tAAEMdEJEBTAkQkOAGCAI1VMEiJVCSqMIAAUIEAKJABICG3VEG58QFBkha6ogKJUMFB"
		. "/9LwFzhQbGh/zxDPEM8QzxDPEM8QJwF9WA+EwvJHaQGF8IesgV4Bg/gidAq4IBDw/+lmEYEOoblgB8IeAOj3/f//hcB0+iIDAkUBAu8M7wzvDO8M"
		. "l+8M7wwkAToVCsQQDwi3CAhSKMcLOsMLtAOIsgNJsDKLjQMsRWjESQL/YA1/Go8Njw2PDY8Njw0nAZgsdR1vB2MH6cLQC+dAkIwd1Qy6D58QnBCw"
		. "OQIJtjmLVWhIiVAaCLPSfcoDkwVbD4W+ZUJ4PwX0M/LJcAD4dADTUkIQM8P7+TO10QD/M+yNVdDF8zPw/zP/M+AZwtjwM3DHhay07R8aPx8aHxof"
		. "Gh8aHxonAV0PNoRh45803kdQKCfH+pkpJxUOMQLiJouVcQz1UA1wRCftMBgvDS8NLw0BJAH+tQAKdMJIi4XAAAAAAEiLAA+3AEBmg/gNdK8NkAlE"
		. "dJwNSCx1JAdISAiNUAIFGokQg4UCrAAQAemq/v//gpANbl10Crj/AAC46T4NASoTggAJyAAJMGbHAAkBIwELSIuAVXBIiVAIuAALGADpAQo8A1ki"
		. "D4WMEwUaUwUXiYWgAgkdBFiVggaALQc7CADpRFkEDTGFwHWEXYKCDA8/XA+F9gMhP7mEVnU0AAmCPIETiQJC5YA8IpYg6ccKL4Q6FCOqXBcjgBAj"
		. "L5QRL5cRKjmQEWKUEQiXEfICVY8RZpQRDJcRq5ARblWUEQqXEWSQEXKUEQ11lxEdkBF0lBFCuJMR1sIBjxF1D4WFigWOmcHEFQAAx4WcAcvByw47"
		. "gwyBBoARweAEiUeB/UIKT1MvfkJNAjkcfy/HB2IHxwMB0INk6DDpCemuo2sqCEBEfj9NAkZ/LJoKN6mJCutczQdgLwpmPAqmVyoKhHm1CNcpg0Io"
		. "CAGDvcEAAw+OuIlAmkiDIggC6zrjB8J16QcQSI1K5wchitUjPkggPo0DExJQLmCXLJD7QAtFkkgmBynIBkiCFuMCQAhIg+hOBMs8dRcjpdcHbzEt"
		. "xHQubj4PjgyKp+Q+iA+P9eCgx4WYwSDLh6YADxQGqMdAICCwDDx1IuMGoSTfooMGMHUPITjTCk1+cA4wD46JwdACOX9260yGKAC9AInQSMHgAkgB"
		. "gNBIAcBJicBpDCkgNYuVYwwKoAdID6C/wEwBwGAP0AUISyPFTGYfbg5+jiVMUwgGAAAO4S4PheYD2BtIPmYP78DySIwPKsEUYQLyDxHgQBUGMQXA"
		. "M5TEM+tsixKVYQGJ0MAbAdAB7MCJQgP4G5jAOwIG8AUNcADScAASBGYPKMgQ8g9eyjYHEEAIsPIPWME8CFwQFw8kTI5q6h9jAWV0ngJFuA+F+I9N"
		. "/RCzAhRXImP/Ef8RxoWTDyoBKiFNkwEBTwdDB+syPQMr3HUf3gQfLUsRE68hhCEKOrI1jFRa6zqLlduxAMYbQZ8pnBtEER4xA4NfB18HfqDHhYiE"
		. "IojHhYRVBxyLlVEBSygj4QCDAgIBi2IAOyEyBnzWgL2iD3Qq61kh4BfJUCONUQMQIxoilOsolwJIgxoPKvIFePIPWb0k+R3BpdU6i0FSREiYSA+v"
		. "OTjr8jg6AwV1vwawBqEDvwalugYMtyIDAFNToQ98oPh0D4XfkhOAlROMUouyAJAJjRXSEAOAD7YEEGYPvkEK6ZgDOcIlr0taBZ1moQQL8BYWBYAU"
		. "BYTAdZcAD7YFUuT//4T4wHQdyQqoUtI/FRFkhcwVDgMHV0sF/CI2Q1AIiwXu0QCJwf/SBVMPq/+G+GYPhdMJUQ9FfCIPTItFfN3SCeewAv8O+w5b"
		. "/zz3DmhFfAG1BJu0BJAOoLmQDmjjnw5MYZ4OBKMGbZgO8lQHkw7kggGWDsFBLzP4bg+FpZIOeKESBkmLRXjSCQOfDmWXDgeSDut0bw5lDnhbYA6D"
		. "BLoxJ2MOo+wLVSv4yOMLQ+oLNeoL6wUhUgdIgcQwsAldwz6QBwCkKQ8ADwACACJVAG5rbm93bl9PAGJqZWN0XwANCgoQCSLVAHRydWUAAGZhbHNl"
		. "AG4IdWxs5wJWYWx1AGVfADAxMjM0ADU2Nzg5QUJDAERFRgBVSInlAEiDxIBIiU0QAEiJVRhMiUUgaMdF/ANTRcBREVsoAEiNTRhIjVX8AEiJVCQo"
		. "x0QkEiDxAUG5MSxJicgDcRJgAk0Q/9BIx0RF4NIAx0XodADwwbQEIEiJReDgAFOJAaIFTItQMItF/IpIEAVA0wJEJDiFAOIwggCNVeBGB8BXQAcH"
		. "ogdiFXGWTRBB/9Lz0QWE73UeogaBl8IYYAYT5ADRGOtgpwIDdVODtQEBDIBIOdB9QG4V1AK68Bp/Qhs50H9l4FNF8Q/YSXCIUwfooUE2hcB0D6AB"
		. "2LDuBVADUjAGEJBIg+xmgBge8xXsYPEV5BVmo7IREAWJRfigFhSABACLTRiJyrjNzATMzDBTwkjB6CAgicLB6gMmXinBAInKidCDwDCDzLQAbfwB"
		. "icKLRfwASJhmiVRFwIsARRiJwrjNzMwAzEgPr8JIwegAIMHoA4lFGIMAfRgAdalIjVUDAIQArEgBwEgB0ABIi1UgSYnQSACJwkiLTRDoAQD+//+Q"
		. "SIPEYAhdw5AGAFVIieUASIPscEiJTRAASIlVGEyJRSAQx0X8AAAA6a4CAAAASItFEEiLRFAYA1bB4AUBV4k0RdABD2MAYQEdQDAASDnCD42aAQBg"
		. "AGbHRbgCNAAaQAEAUEXwxkXvAEhAg33wAHkIAAoBAEj3XfDHRegUgwBfAJTwSLpnZgMAgEiJyEj36kgArgDB+AJJichJwWD4P0wpwAG8gQngBgIB"
		. "PABrKcFIicoAidCDwDCDbegVgo3og42QmCdIwflSPwAbSCmBXfACR3WAgIB97wB0EIEigYMhx0RFkC0AgKEGkIIHhKGJRcDGRSDnAMdF4IGJi0Uy"
		. "4IAMjRQBcQEPD7cKEAQJDAEJGEgByAAPtwBmOcJ1b4EPFQBmhcB1HokLi4AXhQsGgDIB6zqTGgR0IlMNdAqDReAQAelm/0B2gH3nkAAPhPYCVkUg"
		. "wH6JwC4QuMBkAOkBQAFlCmw4AWyMysMKhWrIqMZF38A52MM52IYb/sjFOYIE0DmNCsU5xwXLOb7fwjlRDcE5UQ3BOdjGORDfAHQSzTjrIIMsRfwA"
		. "cgg5IAI5O/0M//+ApEA6g8RwXWLDwruB7JABBIS8SGvEdsAB6MQB8MEBwLLgAgUCwPIPEADyD6IRQIXHRcCECMjEAXrQwgGNgGdAioADASNIAIsF"
		. "hOb//0iLoABMi1AwQAN2QQMQx0QkQAMNRCQ4hQICiwAfiVQkMMHtlQECKEAGIAEQQbnBBwpBwi26QgWJwUH/sNJIgcQBF/B3QOl3fwAXABmgeKNs"
		. "gSEACOReD0yJm39veW+4MOAHKRzQgyyTv2+pbw+Feg9gOWEIIwhgb8AtAOkegF8T34IfE9qCx0XsCSEu61DgARgAdDYLi6oAC+xCAUyNBAIzYlRg"
		. "K41IQAFhOQpBQQBlZokQ6w/hU4sQAI1QAQEBiRCDWEXsARQJR2OO5VRAWyc85Dsg6TsDExyvD2aAxwAiAOleBEOAKcgP6UpjAhAhDYP4KCJ1ZmMI"
		. "GXIIXADT7hdcDuYDTw7SYwJEDk5cXw5fDsgF6XNQDl8dSg4IXw5fDsYFYgDp2gBQDuxk5EMODF8OXw5hxgVmAOmNwwsqB3l9KgcKLwcvBy8HLwfi"
		. "Am5IAOkaLwfpBioHDR8vBy8HLwcvB+ICcgDptqcwTy0HkzMBJAcJLwcPLwcvBy8H4gJ0AOk0BS8H6aFXD7YFmdZA//+EwHQr1wcfRHYNxwB+dgcT"
		. "ZwVB4jqD4AHrNqkCGoWpAhTFAD2gAHd9A31ABnxfDV8NXg3vAuECdbPvAtQHD7dRUPFyGCBUUInB6IZxCDTDBB43zwRgAGADEo9MAQhFEANxT0IN"
		. "hcAPhab736BtXwnYQT4EQaggJE71TQtgWdVriQBrjQVC8wdwBVBZxKjrMg+3RXAQg+AP0qzAWlBTtrAAZg++kqiSXugRAjBmwegEEQTRgIN9gPwD"
		. "fsjHRfhwOwgA6z9TCiWLRfjASJhED7dE4HwOC5hEicJfD+BbbfjQBDD4AHm7JVr1Cw=="
		static Code := false
		if ((A_PtrSize * 8) != 64) {
			Throw Exception("_LoadLib64Bit does not support " (A_PtrSize * 8) " bit AHK, please run using 64 bit AHK")
		}
		; MCL standalone loader https://github.com/G33kDude/MCLib.ahk
		; Copyright (c) 2021 G33kDude, CloakerSmoker (CC-BY-4.0)
		; https://creativecommons.org/licenses/by/4.0/
		if (!Code) {
			CompressedSize := VarSetCapacity(DecompressionBuffer, 4249, 0)
			if !DllCall("Crypt32\CryptStringToBinary", "Str", CodeBase64, "UInt", 0, "UInt", 1, "Ptr", &DecompressionBuffer, "UInt*", CompressedSize, "Ptr", 0, "Ptr", 0, "UInt")
				throw Exception("Failed to convert MCLib b64 to binary")
			if !(pCode := DllCall("GlobalAlloc", "UInt", 0, "Ptr", 11168, "Ptr"))
				throw Exception("Failed to reserve MCLib memory")
			DecompressedSize := 0
			if (DllCall("ntdll\RtlDecompressBuffer", "UShort", 0x102, "Ptr", pCode, "UInt", 11168, "Ptr", &DecompressionBuffer, "UInt", CompressedSize, "UInt*", DecompressedSize, "UInt"))
				throw Exception("Error calling RtlDecompressBuffer",, Format("0x{:08x}", r))
			OldProtect := 0
			if !DllCall("VirtualProtect", "Ptr", pCode, "Ptr", 11168, "UInt", 0x40, "UInt*", OldProtect, "UInt")
				Throw Exception("Failed to mark MCLib memory as executable")
			Exports := {}
			for ExportName, ExportOffset in {"bBoolsAsInts": 0, "bEscapeUnicode": 16, "dumps": 32, "fnCastString": 2624, "fnGetObj": 2640, "loads": 2656, "objFalse": 7632, "objNull": 7648, "objTrue": 7664} {
				Exports[ExportName] := pCode + ExportOffset
			}
			Code := Exports
		}
		return Code
	}
	_LoadLib() {
		return A_PtrSize = 4 ? this._LoadLib32Bit() : this._LoadLib64Bit()
	}

	Dump(obj, pretty := 0)
	{
		this._init()
		if (!IsObject(obj))
			throw Exception("Input must be object")
		size := 0
		DllCall(this.lib.dumps, "Ptr", &obj, "Ptr", 0, "Int*", size
		, "Int", !!pretty, "Int", 0, "CDecl Ptr")
		VarSetCapacity(buf, size*2+2, 0)
		DllCall(this.lib.dumps, "Ptr", &obj, "Ptr*", &buf, "Int*", size
		, "Int", !!pretty, "Int", 0, "CDecl Ptr")
		return StrGet(&buf, size, "UTF-16")
	}

	Load(ByRef json)
	{
		this._init()

		_json := " " json ; Prefix with a space to provide room for BSTR prefixes
		VarSetCapacity(pJson, A_PtrSize)
		NumPut(&_json, &pJson, 0, "Ptr")

		VarSetCapacity(pResult, 24)

		if (r := DllCall(this.lib.loads, "Ptr", &pJson, "Ptr", &pResult , "CDecl Int")) || ErrorLevel
		{
			throw Exception("Failed to parse JSON (" r "," ErrorLevel ")", -1
			, Format("Unexpected character at position {}: '{}'"
			, (NumGet(pJson)-&_json)//2, Chr(NumGet(NumGet(pJson), "short"))))
		}

		result := ComObject(0x400C, &pResult)[]
		if (IsObject(result))
			ObjRelease(&result)
		return result
	}

	True[]
	{
		get
		{
			static _ := {"value": true, "name": "true"}
			return _
		}
	}

	False[]
	{
		get
		{
			static _ := {"value": false, "name": "false"}
			return _
		}
	}

	Null[]
	{
		get
		{
			static _ := {"value": "", "name": "null"}
			return _
		}
	}
}

class Mather {
	Tokenize(Source) {
		Tokens := []
		
		while (RegexMatch(Source, "Ox)(?<Number>\d+\.\d+|\d+)|(?<Operator>[\+\-\~\!\*\^\/\√\%\&])|(?<Punctuation>[\(\)])", Match)) {
			loop, % Match.Count() {
				Name := Match.Name(A_Index)
				Value := Match[Name]
				
				if (Match.Len(A_Index)) {
					Tokens.Push({"Type": Name, "Value": Value})
				}
			}
			
			Source := SubStr(Source, Match.Pos(0) + Match.Len(0))
		}
		
		return Tokens
	}
	
	static BinaryPrecedence := {"+": 1, "-": 1, "&": 1, "*": 2, "^": 2, "/": 2, "√": 1, "%": 2}
	
	static UnaryPrecedence := 5
	
	EvaluateExpressionOperand(Tokens) {
		NextToken := Tokens.RemoveAt(1)
		
		if (NextToken.Type = "Punctuation" && NextToken.Value = "(") {
			
			Value := this.EvaluateExpression(Tokens)
			
			NextToken := Tokens.RemoveAt(1)
			
			return Value
		}
		else if (NextToken.Type = "Operator") {
			
			Value := this.EvaluateExpression(Tokens, this.UnaryPrecedence)
			
			switch (NextToken.Value) {
				case "+": {
					return Value
				}
				case "-": {
					return -Value
				}
				case "~": {
					return -Value + 1
				}
				case "√": {
					return ZTrim(Sqrt(Value))
				}
				case "&": {
					GuiControl, Text, Button7, % IsPrime(Value)
					Sleep, 1000
					GuiControl, Text, Button7, IsPr
					return Value
				}
			}
			
			Throw "Unary operator " NextToken.Value " is not implemented"
		}
		else if (NextToken.Type = "Number") {
			
			return NextToken.Value * 1
		}
		
	}
	
	EvaluateExpression(Tokens, Precedence := 0) {
		LeftValue := this.EvaluateExpressionOperand(Tokens)
		
		OperatorToken := Tokens.RemoveAt(1)
		
		while (OperatorToken.Type = "Operator" && this.BinaryPrecedence[OperatorToken.Value] >= Precedence) {
			RightValue := this.EvaluateExpression(Tokens, this.BinaryPrecedence[OperatorToken.Value])
			
			switch (OperatorToken.Value) {
				case "+": {
					LeftValue += RightValue
				}
				case "-": {
					LeftValue -= RightValue
				}
				case "*": {
					LeftValue *= RightValue
				}
				case "/": {
					LeftValue := LeftValue/RightValue
				}
				case "%": {
					LeftValue := Per(LeftValue, RightValue)
				}
				case "^": {
					LeftValue := LeftValue**RightValue
				}
			}
			
			OperatorToken := Tokens.RemoveAt(1)
		}
		
		if (OperatorToken) {
			Tokens.InsertAt(1, OperatorToken)
		}
		
		return ZTrim(LeftValue)
	}
	
	Evaluate(Source) {
		return this.EvaluateExpression(this.Tokenize(Source))
	}
}
