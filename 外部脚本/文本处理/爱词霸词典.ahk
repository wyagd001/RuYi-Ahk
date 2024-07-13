;|2.7|2024.07.11|1378
#Include <WinHttp>
#SingleInstance force
CandySel := A_Args[1]
爱词霸词典网络翻译:
	Youdao_keyword := CandySel
	Youdao_keyword := Trim(Youdao_keyword, " `t`r`n")
	If !Youdao_keyword                          ;如果粘贴板里面没有内容，则判断是否有窗口定义
		Return
	Youdao_译文 := iciba(Youdao_keyword)
	;msgbox % Youdao_译文
	Youdao_基本释义 := json(Youdao_译文, "message.paraphrase")
	;msgbox % Youdao_基本释义
	If Youdao_基本释义<>
	{
		ToolTip, %Youdao_keyword%:`n基本释义:%Youdao_基本释义%`n
		sleep 1900
		;gosub, soundpaly
		sleep, 100
		ToolTip
		Youdao_译文 := Youdao_基本释义 := Youdao_keyword := ""
	}
else
	MsgBox,, 爱词霸网络翻译, 网络错误或查询不到该单词的翻译。, 5
return

iciba(KeyWord)
{
	url := "https://dict.iciba.com/dictionary/word/suggestion?word=" SkSub_UrlEncode(KeyWord, "utf-8")
	Return WinHttp.URLGet(url)
}

SkSub_UrlEncode(str, enc="UTF-8")       ;From Ahk Forum
{
    enc:=trim(enc)
    If enc=
        Return str
   hex := "00", func := "msvcrt\" . (A_IsUnicode ? "swprintf" : "sprintf")
   VarSetCapacity(buff, size:=StrPut(str, enc)), StrPut(str, &buff, enc)
   While (code := NumGet(buff, A_Index - 1, "UChar")) && DllCall(func, "Str", hex, "Str", "%%%02X", "UChar", code, "Cdecl")
   encoded .= hex
   Return encoded
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

soundpaly:
	if !IsObject(spovice)
		spovice:=ComObjCreate("sapi.spvoice")
	spovice.Speak(Youdao_keyword)
Return