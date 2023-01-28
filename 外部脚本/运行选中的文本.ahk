CandySel := A_Args[1]
; 1037
if (RegExMatch(CandySel, "i)^(HKCU|HKCR|HKCC|HKU|HKLM|HKEY|计算机\\HK|\[HK)"))
{
	f_OpenReg(CandySel)
	return
}

if RegExMatch(CandySel, "i)^(https://|http://)+(.*\.)+.*")
{
	run, %CandySel%
	return
}

if RegExMatch(CandySel, "^[a-zA-Z0-9\+\-\*/\.\^%]+", Tmp_Out)
{
	if (strlen(Tmp_Out) >= 2)
	{
		if Tmp_Value := Eval(Tmp_Out)
		{
			msgbox % Tmp_Value
			return
		}
	}
}

CandySel := Deref(CandySel)
run %CandySel%,, UseErrorLevel
;msgbox  %CandySel%
if ErrorLevel
{
	run, https://www.baidu.com/s?wd=%CandySel%
}
return

f_OpenReg(RegPath)
{
	RegPath := LTrim(RegPath, "[")
	RegPath := RTrim(RegPath, "]")
	StringLeft, RegPathFirst4, RegPath, 4
	if RegPathFirst4 = HKCR
		StringReplace, RegPath, RegPath, HKCR, HKEY_CLASSES_ROOT
	else if RegPathFirst4 = HKCU
		StringReplace, RegPath, RegPath, HKCU, HKEY_CURRENT_USER
	else if RegPathFirst4 = HKLM
		StringReplace, RegPath, RegPath, HKLM, HKEY_LOCAL_MACHINE
	else if RegPathFirst4 = HKCC
		StringReplace, RegPath, RegPath, HKCC, HKEY_CURRENT_CONFIG
	else if RegPathFirst4 = HKU
		StringReplace, RegPath, RegPath, HKU, HKEY_USERS

	; 将字串中的前两个"＿"(全角) 替换为“_"(半角)
	StringReplace, RegPath, RegPath, ＿, _
	StringReplace, RegPath, RegPath, ＿, _
	; 替换字串中第一个“, ”为"\"
	StringReplace, RegPath, RegPath, `,%A_Space%, \
	; 替换字串中第一个“,”为"\"
	StringReplace, RegPath, RegPath, `,, \
	; 将字串中的所有"/" 替换为“\"
	StringReplace, RegPath, RegPath, /, \, All
	; 将字串中的所有"／"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ／, \, All
	; 将字串中的所有"＼"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ＼, \, All
	StringReplace, RegPath, RegPath, %A_Space%\, \, All
	StringReplace, RegPath, RegPath, \%A_Space%, \, All
	; 将字串中的所有“\\”替换为“\”
	StringReplace, RegPath, RegPath, \\, \, All

	RegRead, MyComputer, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey
	f_Split2(MyComputer, "\", MyComputer, aaa)
	MyComputer := MyComputer ? MyComputer : (A_OSVersion="WIN_XP")?"我的电脑":"计算机"
	IfNotInString, RegPath, %MyComputer%\
		RegPath := MyComputer "\" RegPath
	;tooltip % RegPath

	IfWinExist, ahk_class RegEdit_RegEdit
	{
		RunWait, % "cmd.exe /c taskkill /IM regedit.exe", , Hide
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe
	}
	Else
	{
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe ;-m
	}
return
}

f_Split2(String, Seperator, ByRef LeftStr, ByRef RightStr)
{
	SplitPos := InStr(String, Seperator)
	if SplitPos = 0 ; Seperator not found, L = Str, R = ""
	{
		LeftStr := String
		RightStr:= ""
	}
	else
	{
		SplitPos--
		StringLeft, LeftStr, String, %SplitPos%
		SplitPos++
		StringTrimLeft, RightStr, String, %SplitPos%
	}
	return
}

Deref(String)
{
    spo := 1
    out := ""
    while (fpo:=RegexMatch(String, "(%(.*?)%)|``(.)", m, spo))
    {
        out .= SubStr(String, spo, fpo-spo)
        spo := fpo + StrLen(m)
        if (m1)
            out .= %m2%
        else switch (m3)
        {
            case "a": out .= "`a"
            case "b": out .= "`b"
            case "f": out .= "`f"
            case "n": out .= "`n"
            case "r": out .= "`r"
            case "t": out .= "`t"
            case "v": out .= "`v"
            default: out .= m3
        }
    }
    return out SubStr(String, spo)
}

Eval(x)
{
x := RegExReplace(x,"(.*)=")
x := RegExReplace(x,"\s*")
x := RegExReplace(x,"([\d\)])\-","$1#")
Loop
{
If !RegExMatch(x, "(.*)\(([^\(\)]*)\)(.*)", y)
        Return % RegExReplace(Eval_(x),"\.+0*$")
x := y1 Eval_(y2) y3
}
}

Eval_(x)
{
RegExMatch(x, "(.*)(\+|\#)(.*)", y)
IfEqual y2,+, Return Eval_(y1) + Eval_(y3)
IfEqual y2,#, Return Eval_(y1) - Eval_(y3)
RegExMatch(x, "(.*)(\*|\/|\%)(.*)", y)
IfEqual y2,*, Return Eval_(y1) * Eval_(y3)
IfEqual y2,/, Return Eval_(y1) / Eval_(y3)
IfEqual y2,`%, Return Mod(Eval_(y1),Eval_(y3))
RegExMatch(x, "(.*\d)(e)(.*)", y)
IfEqual y2,e, Return Eval_(y1)*10**Eval_(y3)
StringGetPos i, x, ^, R
IfGreaterOrEqual i,0, Return Eval_(SubStr(x,1,i)) ** Eval_(SubStr(x,2+i))
If !RegExMatch(x,"i)(abs|round|ceil|floor|exp|sqrt|ln|log|sin|cos|tan|tg|ctg|sec|csc|asin|acos|random|hex|d|r|pi)(.*)", y) ;将支持的函数或变量写这里,正则的原因名字简单的要尽量靠后
        Return x
If y1=random
{
        Random, z, 0, y2
        Return z
}
If y1=hex
{
        SetFormat, integer, d
        z := y2+0
        SetFormat, integer, hex
        Return z
}
IfEqual y1, tg,                Return tan(Eval_(y2))
IfEqual y1, ctg,                Return 1/tan(Eval_(y2))
IfEqual y1, sec,                Return asin(Eval_(y2))
IfEqual y1, csc,                Return acos(Eval_(y2))
IfEqual y1, d,                Return Eval_(y2)*57.295779513
IfEqual y1, r,                Return Eval_(y2)/57.295779513
IfEqual y1, pi,        Return 3.141592654
Return %y1%(Eval_(y2))
}

/* 算式计算
http://forum.ahkbbs.cn/thread-1945-1-1.html
1、增加了去掉多余的小数点和0的功能，看着更直观
2、Send模式改为SendInput 可以快一点显示
3、e不再表示2.718，不怎么实用,改为科学计数法，如3.1e-2=0.031
4、修正了十六进制转化的错误 现在才是 hex12=0xc
5.   把Send, +{Home}^c{right}=改为Send, +{Home}^x{right} 【日常使用往往只要结果，比如运算输入年合同额等，所以用剪切替换复制】
6.  把:?*:=?::改为:?*:=\::,热字串启动,输入公式，按=\启用
7.  求余使用%，求幂使用^，(可以用 ^-1求倒数，^0.5求算术平方根、当然 i 是不支持的)
        绝对值abs，四舍五入round、向上取整ceil、向下取整floor、
        e的N次幂exp、算术平方根sqrt、自然对数ln、常用对数log、
        正弦sin、余弦cos、正切tan或tg、余切ctg、正割sec或asin、余割csc或acos（三角函数参数使用弧度）、
        随机数random（接整数出整数，接小数出小数）、
        转化为十六进制hex（hex12=0xc）
        弧度转角度d（如d pi=180.000000、角度转弧度r（如r45=0.785398）、
        常数pi=3.141592654、e=2.718281828
        常数精度不满意可以自己改，函数数量少可以自己定义
8.   十六进制可以直接计算，如 0xFF/5=51.000000、注意减法使用“加相反数”的办法，如 0xCC+-12=192、直接转化为10进制用加0的办法，如 0xFFFFFF+0=16777215
9.   函数的优先级是大于幂运算的，比如：round5.5^2=36
*/