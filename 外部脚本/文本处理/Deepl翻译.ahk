;|2.1|2023.07.28|1398
;来源网址: https://www.autohotkey.com/boards/viewtopic.php?t=102925
#SingleInstance force
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}

StringCaseSense, On
text := CandySel
;text := substr(CandySel, 1, 250)
;ToolTip % text
id := 12340000
WinHTTP := ComObjCreate("WinHttp.WinHttpRequest.5.1")
loop 1
{
   WinHTTP.Open("POST", "https://www2.deepl.com/jsonrpc", true)
   WinHTTP.SetRequestHeader("content-type", "application/json")
   WinHTTP.SetRequestHeader("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36 OPR/85.0.4341.75")
   id++
   if (Mod(id+3, 13) = 0) or (Mod(id+5, 29) = 0)
      method = "method" :
   else
      method = "method":
   text .= "i"
   StrReplace(text, "i",, i_count)
   i_count++
   timestamp := A_NowUTC
   timestamp -= 19700101000000, S
   timestamp .= A_MSec
   timestamp := timestamp + i_count - Mod(timestamp, i_count)
   json = {"jsonrpc": "2.0", %method% "LMT_handle_texts", "id": %id%, "params": {"texts": [{"text": "%text%", "requestAlternatives": 3}], "splitting": "newlines", "lang": {"target_lang": "ZH"}, "timestamp": %timestamp%, "commonJobParams": {"wasSpoken": false}}}
   WinHTTP.Send(json)
   WinHTTP.WaitForResponse()
   gtext := WinHTTP.responsetext
}
;msgbox % gtext
;msgbox % json(gtext, "result.texts.text")
;msgbox % substr(decodeu(json(gtext, "result.texts.text")), 1)
fyText := substr(decodeu(json(gtext, "result.texts.text")), 1)
if (strlen(fyText) > 2)
{
	GuiText(fyText, "Deepl 翻译")
}
else
	GuiText(gtext, "Deepl 翻译")
return

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	ExitApp
	Return
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
				;msgbox % out
    }
    return out
}