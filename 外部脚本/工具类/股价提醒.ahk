;|2.9|2024.12.31|1694
if (A_DDDD = "星期六") or (A_DDDD = "星期日")
  exitapp
if (A_Hour < 9) or (A_Hour > 16)
  exitapp
#Include <WinHttp>
settingInifile := A_ScriptDir "\..\..\配置文件\外部脚本\工具类\股价提醒.ini"
if !fileexist(settingInifile)
{
  FileCreateDir, %A_ScriptDir%\..\..\配置文件\外部脚本\工具类
  fileappend,, %settingInifile%
  ;msgbox % ErrorLevel " - " A_LastError 
  IniWrite, 000001|上证指数|>1.5`%|<-1.5`%, %settingInifile%, 监控, 1
}
settingobj := ini2obj(settingInifile)
SetFormat, float, 10.4

for k, v in settingobj["监控"]
{
  TmpArr := GetStringIndex(v)
  股票名称 := TmpArr[2]
  Tmp_Obj := Gupiao(TmpArr[1])
  Tmp_涨幅 := Tmp_Obj["涨幅"]
  Tmp_涨幅 := strreplace(Tmp_涨幅, "%")
  Tmp_价格 := Tmp_Obj["价格"]
  ;msgbox % Tmp_涨幅 "-" Tmp_价格
  b_ind := 3
  loop 3
  {
    if !TmpArr[b_ind]
      break
    RegExMatch(TmpArr[b_ind], "([^\d-]*)([-\d\.%]*)", Out)
    ;msgbox % out1 "-"  out2
    fh := out1
    if InStr(out2, "%")
    {
      nout2 := strreplace(out2, "%")
      ;msgbox % out2
      cur := Tmp_涨幅
      it := "涨幅"
    }
    else
    {
      nout2 := out2
      cur := Tmp_价格
      it := "股价"
    }
    ;msgbox % cur " | " fh " | " Out2
    if (fh = ">")
    {
      if (cur > nOut2)
      {
        MSGBOX, 515, 股价提醒, %股票名称%%it% %cur% 大于预警值 %out2%!`n点击按钮“是”修改预警条件.
        IfMsgBox, Yes
          run notepad "%settingInifile%"
      }
    }
    else if (fh = "<")
    {
      ;msgbox % cur " | " Out2
      if (cur < nOut2)
      {
        MSGBOX, 515, 股价提醒, %股票名称%%it% %cur% 小于预警值 %out2%!`n点击按钮“是”修改预警条件.
        IfMsgBox, Yes
          run notepad "%settingInifile%"
      }
    }
    else if (fh = "=")
    {
      if (cur = nOut2)
      {
        MSGBOX, 515, 股价提醒, %股票名称%%it% %cur% 等于预警值 %out2%!`n点击按钮“是”修改预警条件.
        IfMsgBox, Yes
          run notepad "%settingInifile%"
      }
    }
    else if (fh = ">=")
    {
      if (cur >= Out2)
      {
        MSGBOX, 515, 股价提醒, %股票名称%%it% %cur% 大于等于预警值 %out2%!`n点击按钮“是”修改预警条件.
        IfMsgBox, Yes
          run notepad "%settingInifile%"
      }
    }
    else if (fh = "<=")
    {
      if (cur <= nOut2)
      {
        MSGBOX, 515, 股价提醒, %股票名称%%it% %cur% 小于等于预警值 %out2%!`n点击按钮“是”修改预警条件.
        IfMsgBox, Yes
          run notepad "%settingInifile%"
      }
    }
    b_ind ++
  }
}
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