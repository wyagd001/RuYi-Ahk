;|2.2|2023.08.09|1398
;来源网址: https://www.autohotkey.com/boards/viewtopic.php?t=102925
#SingleInstance force
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}
;MsgBox % CandySel
fyText := Deepl(CandySel)
GuiText2(fyText, "Deepl 翻译", CandySel, "Deepl")
return

GuiText2(Gtext2, Title:="", Gtext1:="", Label:="", w:=300, l:=20)
{
	global myedit1, myedit2, TextGuiHwnd
	Gui,GuiText2: Destroy
	Gui,GuiText2: Default
	Gui, +HwndTextGuiHwnd
	if Gtext1
	{
		Gui, Add, Edit, w%w% r%l% -WantReturn vmyedit1
		if Label
		{
			;MsgBox % "Default xp+" w+1 " w100 h1 g" Label
			Gui, Add, Button, % "Default xp+" w+1 " w100 h1 g" Label, 翻译
			Gui, Add, Edit, % "xp+10 w" w " r" l " Multi readonly vmyedit2"
		}
		else
			Gui, Add, Edit, % "xp+" w+10 " w" w " r" l " Multi readonly vmyedit2"
		;MsgBox % "xp+" w+10 " w" w " r" l " Multi readonly vmyedit2"
		GuiControl,, myedit1, %Gtext1%
	}
	else
	{
		Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit2
	}
	GuiControl,, myedit2, %Gtext2%
	gui, Show, AutoSize, % Title
	return

	GuiText2GuiClose:
	GuiText2Guiescape:
	Gui, GuiText2: Destroy
	ExitApp
	Return
}

Deepl:
Gui, GuiText: Submit, NoHide
if myedit1
{
	fyText := Deepl(Trim(myedit1))
	GuiControl,, myedit2, %fyText%
}
return

Deepl(mytext)
{
	RegExReplace(mytext, "[^\x00-\xff]",, zh_Count)
	if zh_Count
		target_lang := "EN"
	else
		target_lang := "ZH"
	StringCaseSense, On
	id := 12340000
	WinHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	WinHTTP.Open("POST", "https://www2.deepl.com/jsonrpc", true)
	WinHTTP.SetRequestHeader("content-type", "application/json")
	WinHTTP.SetRequestHeader("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36 OPR/85.0.4341.75")
	id++
	if (Mod(id+3, 13) = 0) or (Mod(id+5, 29) = 0)
		method = "method" :
	else
		method = "method":
	mytext := StrReplace(mytext, """", "'")   ; 双引号转单引号
	mytext := StrReplace(mytext, "`r`n", "`n")   ; 换行转为空格
	mytext := StrReplace(mytext, "`n", " ")
	mytext .= "i"
	StrReplace(mytext, "i",, i_count)
	i_count++
	timestamp := A_NowUTC
	timestamp -= 19700101000000, S
	timestamp .= A_MSec
	timestamp := timestamp + i_count - Mod(timestamp, i_count)
	json = {"jsonrpc": "2.0", %method% "LMT_handle_texts", "id": %id%, "params": {"texts": [{"text": "%mytext%", "requestAlternatives": 3}], "splitting": "newlines", "lang": {"target_lang": "%target_lang%"}, "timestamp": %timestamp%, "commonJobParams": {"wasSpoken": false}}}
	WinHTTP.Send(json)
	WinHTTP.WaitForResponse()
	gtext := WinHTTP.responsetext
	deshuangyinhao := StrReplace(json(gtext, "result.texts.text"), "\""", "\u0022")
	fyText := substr(decodeu(deshuangyinhao), 1)
	if (strlen(fyText) > 1)
		return fyText
	else
		return gtext
}

json(ByRef js, s, v = "")
{
	j = %js%
	Loop, Parse, s, .
	{
		p = 2
		RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
		Loop {
			If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
				. "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
				Return
			Else If (x2 == q2 or q2 == "*") {
				j = %x3%
				z += p + StrLen(x2) - 2
				If (q3 != "" and InStr(j, "[") == 1) {
					StringTrimRight, q3, q3, 1
					Loop, Parse, q3, ], [
					{
						z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
						j = %x1%
					}
				}
				Break
			}
			Else p += StrLen(x)
		}
	}
	If v !=
	{
		vs = "
		If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
			and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
			vs := "", v := vx1
		StringReplace, v, v, ", \", All
		js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
	}
	Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
		? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
}

decodeu(ustr){
;If A_IsUnicode
;return ustr
ustr := StrReplace(ustr, "[", "")
ustr := StrReplace(ustr, "]", "")
ustr := StrReplace(ustr, "<", "")
ustr := StrReplace(ustr, ">", "")
   Loop
    {
        if !ustr
            break  
        if RegExMatch(ustr,"^\s*\\u([A-Fa-f0-9]{2})([A-Fa-f0-9]{2})(.*)",m)
        {
          word_u := Chr("0x"  m1 m2), ustr := m3, word_a := ""
					;msgbox % m1 "-" m2 "-" m3
					;msgbox % word_a " - " word_u
            out .= word_u
        }
        else if RegExMatch(ustr, "^([(\x20-\x5B)|(\x5D-\x7E)]*)(.*)",n)
        {
            ustr := n2
            out .= n1
        }
				else
					continue
				;msgbox % out
    }
    return out
}