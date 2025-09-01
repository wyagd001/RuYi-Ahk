;|2.9|2025.01.17|1694
#Include <Ruyi>
if (A_DDDD = "星期六") or (A_DDDD = "星期日")
  exitapp
if (A_Hour < 9) or (A_Hour > 16) or (A_Hour = 12)
  exitapp
#Include <WinHttp>
settingInifile := A_ScriptDir "\..\..\配置文件\外部脚本\工具类\股价提醒.ini"
if !fileexist(settingInifile)
{
  FileCreateDir, %A_ScriptDir%\..\..\配置文件\外部脚本\工具类
  if fileexist(A_ScriptDir "\..\..\配置文件\外部脚本\工具类\股价提醒_默认配置.ini")
    FileCopy % A_ScriptDir "\..\..\配置文件\外部脚本\工具类\股价提醒_默认配置.ini", % settingInifile
  else
  {
    fileappend,, %settingInifile%
    ;msgbox % ErrorLevel " - " A_LastError 
    IniWrite, 000001|上证指数|>1.5`%|<-1.5`%, %settingInifile%, 监控, 1
  }
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
  if !Tmp_涨幅
    continue
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