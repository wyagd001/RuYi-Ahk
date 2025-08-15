;|2.7|2024.07.11|1605
#Include <WinHttp>
CandySel := A_Args[1]

if CandySel
	URL := "https://api.vvhan.com/api/weather?city=" CandySel   ; 城市中文名
else
	URL := "https://api.vvhan.com/api/weather"             ; 根据ip自动判断
result := WinHttp.URLGet(URL, "Charset:utf-8")
;msgbox %result% ;检查是否获取
city := json(result, "city")
quality := json(result, "air.aqi_name")     ; 空气质量
htype0 := json(Result, "data.type") ; 读取天气类型
if !htype0
	htype0 := json(Result, "data.night.type")
high0 := strreplace(json(Result, "data.high"), "高温 ")
low0 := strreplace(json(Result, "data.low"), "低温 ")

if WinExist("AppBarWin ahk_class AutoHotkeyGUI")
{
	loop 3
	{
		h := ExecSendToRuyi(htype0 "`n" strreplace(low0, "°C") "-"  strreplace(high0, "°C") "|red",, 1527)
		if h
			break
	}
	;msgbox % h "|" htype0 "|" json(Result, "data.forecast[0].high") "`n" Result
}
else
	msgbox,, 天气预报, %city%: %quality% `n今日 %htype0% %low0% ~ %high0%`n
Return

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

ExecSendToRuyi(ByRef StringToSend := "", Title := "如一 ahk_class AutoHotkey", wParam := 0, Msg := 0x4a) {
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)

	DetectHiddenWindows, On
	if Title is integer
	{
		SendMessage, Msg, wParam, &CopyDataStruct,, ahk_id %Title%
		;msgbox % ErrorLevel  "qq"
	}
	else if Title is not integer
	{
		SetTitleMatchMode 2
		sendMessage, Msg, wParam, &CopyDataStruct,, %Title%
	}
	DetectHiddenWindows, Off
	return ErrorLevel
}

/*
{
  "success": true,
  "city": "桂林市",
  "data": {
    "date": "2024-05-17",
    "week": "星期五",
    "type": "阴",
    "low": "20°C",
    "high": "26°C",
    "fengxiang": "东风",
    "fengli": "1-3级",
    "night": {
      "type": "小雨",
      "fengxiang": "南风",
      "fengli": "1-3级"
    }
  },
  "air": {
    "aqi": 70,
    "aqi_level": 2,
    "aqi_name": "良",
    "co": "1",
    "no2": "24",
    "o3": "72",
    "pm10": "63",
    "pm2.5": "51",
    "so2": "19"
  },
  "tip": "现在的温度比较舒适~"
}
*/