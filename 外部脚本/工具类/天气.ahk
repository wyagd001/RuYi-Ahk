;|2.9|2025.06.21|1554
;#Include <WinHttp>
A_iniFile = %A_ScriptDir%\..\..\配置文件\自定义\RY_程序保存_如一.ini
B_iniFile = %A_ScriptDir%\..\..\配置文件\如一.ini

IniRead, 额外任务栏_Pos, %A_iniFile%, 配置, 额外任务栏_Pos, %A_Space%
if !额外任务栏_Pos
  IniRead, 额外任务栏_Pos, %B_iniFile%, 配置, 额外任务栏_Pos, %A_Space%
;msgbox % 额外任务栏_Pos " - " B_iniFile

CandySel := A_Args[1]
; CandySel := 101300501

; 来源网址: https://www.autoahk.com/archives/40039
result := WinHttp.URLGet("http://t.weather.sojson.com/api/weather/city/" CandySel, "Charset:utf-8") ; 101270101为天气预报城市id  api接口https://www.sojson.com/api/weather.html
;msgbox %result% ;检查是否获取
city := json(result, "cityInfo.city")
atmp := json(result, "data.wendu")
quality := json(result, "data.quality")      ; 空气质量
htype0 := json(Result, "data.forecast[0].type")   ;  读取数组中的值 ; 今天的天气
high0 := strreplace(json(Result, "data.forecast[0].high"), "高温 ")
low0 := strreplace(json(Result, "data.forecast[0].low"), "低温 ")
htype1 := json(Result, "data.forecast[1].type")   ; 读取数组中的值   ; 明天的天气
high1 := json(Result, "data.forecast[1].high")
low1 := json(Result, "data.forecast[1].low")

if WinExist("AppBarWin ahk_class AutoHotkeyGUI")
{
	loop 3
	{
    if (额外任务栏_Pos != "上")
      h := ExecSendToRuyi(atmp "`n" htype0 "`n"  strreplace(low0, "℃") "-"  strreplace(high0, "℃") "|red",, 1527)
    else
      h := ExecSendToRuyi(atmp "`n" htype0 "  "  strreplace(low0, "℃") "-"  strreplace(high0, "℃") "|red",, 1527)
		;FileAppend("`n" A_now ": " h)
		if h
			break
	}
	;msgbox % h "|" htype0 "|" json(Result, "data.forecast[0].high") "`n" Result
}
else
	msgbox,, 天气预报, %city%: %tmp%℃ %quality% `n今日 %htype0%  %low0% %high0%`n 明日 %htype1% %low1% %high1%
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
{"message":"success感谢又拍云(upyun.com)提供CDN赞助","status":200,"date":"20240222","time":"2024-02-22 18:45:17","cityInfo":{"city":"桂林市","citykey":"101300501","parent":"广西","updateTime":"18:16"},"data":{"shidu":"80%","pm25":9.0,"pm10":15.0,"quality":"优","wendu":"-2","ganmao":"各类人群可自由活动","forecast":[{"date":"22","high":"高温 5℃","low":"低温 0℃","ymd":"2024-02-22","week":"星期四","sunrise":"07:07","sunset":"18:36","aqi":20,"fx":"东北风","fl":"3级","type":"小雪","notice":"小雪虽美，赏雪别着凉"},{"date":"23","high":"高温 3℃","low":"低温 0℃","ymd":"2024-02-23","week":"星期五","sunrise":"07:07","sunset":"18:37","aqi":23,"fx":"东北风","fl":"3级","type":"小雪","notice":"小雪虽美，赏雪别着凉"},{"date":"24","high":"高温 3℃","low":"低温 1℃","ymd":"2024-02-24","week":"星期六","sunrise":"07:06","sunset":"18:37","aqi":34,"fx":"东北风","fl":"2级","type":"小雪","notice":"小雪虽美，赏雪别着凉"},{"date":"25","high":"高温 5℃","low":"低温 2℃","ymd":"2024-02-25","week":"星期日","sunrise":"07:05","sunset":"18:38","aqi":43,"fx":"东北风","fl":"3级","type":"小雨","notice":"雨虽小，注意保暖别感冒"},{"date":"26","high":"高温 7℃","low":"低温 4℃","ymd":"2024-02-26","week":"星期一","sunrise":"07:04","sunset":"18:38","aqi":47,"fx":"东北风","fl":"2级","type":"小雨","notice":"雨虽小，注意保暖别感冒"},{"date":"27","high":"高温 7℃","low":"低温 5℃","ymd":"2024-02-27","week":"星期二","sunrise":"07:03","sunset":"18:39","aqi":40,"fx":"东北风","fl":"2级","type":"小雨","notice":"雨虽小，注意保暖别感冒"},{"date":"28","high":"高温 14℃","low":"低温 6℃","ymd":"2024-02-28","week":"星期三","sunrise":"07:02","sunset":"18:39","aqi":44,"fx":"东北风","fl":"2级","type":"中雨","notice":"记得随身携带雨伞哦"},{"date":"29","high":"高温 15℃","low":"低温 6℃","ymd":"2024-02-29","week":"星期四","sunrise":"07:01","sunset":"18:40","aqi":33,"fx":"东北风","fl":"3级","type":"小雨","notice":"雨虽小，注意保暖别感冒"},{"date":"01","high":"高温 8℃","low":"低温 5℃","ymd":"2024-03-01","week":"星期五","sunrise":"07:00","sunset":"18:41","aqi":26,"fx":"东北风","fl":"2级","type":"小雨","notice":"雨虽小，注意保暖别感冒"},{"date":"02","high":"高温 8℃","low":"低温 5℃","ymd":"2024-03-02","week":"星期六","sunrise":"06:59","sunset":"18:41","aqi":31,"fx":"东北风","fl":"2级","type":"阴","notice":"不要被阴云遮挡住好心情"},{"date":"03","high":"高温 7℃","low":"低温 5℃","ymd":"2024-03-03","week":"星期日","sunrise":"06:58","sunset":"18:42","aqi":27,"fx":"东北风","fl":"1级","type":"小雨","notice":"雨虽小，注意保暖别感冒"},{"date":"04","high":"高温 10℃","low":"低温 7℃","ymd":"2024-03-04","week":"星期一","sunrise":"06:57","sunset":"18:42","aqi":30,"fx":"北风","fl":"1级","type":"中雨","notice":"记得随身携带雨伞哦"},{"date":"05","high":"高温 12℃","low":"低温 10℃","ymd":"2024-03-05","week":"星期二","sunrise":"06:56","sunset":"18:43","aqi":33,"fx":"东北风","fl":"2级","type":"阴","notice":"不要被阴云遮挡住好心情"},{"date":"06","high":"高温 13℃","low":"低温 12℃","ymd":"2024-03-06","week":"星期三","sunrise":"06:55","sunset":"18:43","aqi":36,"fx":"北风","fl":"1级","type":"阴","notice":"不要被阴云遮挡住好心情"},{"date":"07","high":"高温 17℃","low":"低温 14℃","ymd":"2024-03-07","week":"星期四","sunrise":"06:55","sunset":"18:44","aqi":31,"fx":"北风","fl":"1级","type":"阴","notice":"不要被阴云遮挡住好心情"}],"yesterday":{"date":"21","high":"高温 24℃","low":"低温 5℃","ymd":"2024-02-21","week":"星期三","sunrise":"07:08","sunset":"18:36","aqi":20,"fx":"东北风","fl":"3级","type":"中雨","notice":"记得随身携带雨伞哦"}}}
*/