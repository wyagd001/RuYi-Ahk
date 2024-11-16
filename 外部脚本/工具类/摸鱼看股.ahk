;|2.7|2024.07.11|1528
#Include <WinHttp>
SetFormat, float, 10.4
CandySel := A_Args[1]
;CandySel := "000001"
Tmp_Obj := Gupiao(CandySel)
Tmp_涨幅 := Tmp_Obj["涨幅"]
Tmp_价格 := Tmp_Obj["价格"]
Tmp_涨幅 := SubStr(trim(Tmp_涨幅), 1, -1)
if WinExist("AppBarWin ahk_class AutoHotkeyGUI")
{
	if (Tmp_涨幅+0>=0)
	{
		;msgbox % Tmp_涨幅
		ExecSendToRuyi("A`n" SubStr(Tmp_价格, 1, 4) "`n" SubStr(Tmp_涨幅, 1, 5) "|red",, 1527)
	}
	if (Tmp_涨幅+0<0)
	{
		;msgbox % Tmp_涨幅+0 "小于0"
		ExecSendToRuyi("A`n" SubStr(Tmp_价格, 1, 4) "`n" SubStr(Tmp_涨幅, 1, 5) "|Lime",, 1527)
	}
}
else
	msgbox, %  Tmp_Obj["名称"] "`n" Tmp_价格 "`n" Tmp_涨幅
Return

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
	GPOBJ["价格"] := Value1
	GPOBJ["涨幅"] := Value2
	GPOBJ["涨跌"] := Value3
	Array := StrSplit(Wtitle1, " ")
	GPOBJ["名称"] := Array[1]
	return GPOBJ
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