CandySel := A_Args[1]
CandySel := Deref(CandySel)

if (RegExMatch(CandySel,"i)^(\[|HKCU|HKCR|HKCC|HKU|HKLM|HKEY)"))
{
	f_OpenReg(CandySel)
	return
}

if RegExMatch(CandySel, "i)^(https://|http://)+(\w+(-\w+)*\.)+[a-z]{2,}?")
{
	run, %A_ScriptDir%\..\引用程序\AnyToAhk.exe %CandySel%
	return
}

run %CandySel%,, UseErrorLevel
if ErrorLevel
{
	run, %A_ScriptDir%\..\引用程序\AnyToAhk.exe https://www.baidu.com/s?wd=%CandySel%
}
return

f_OpenReg(RegPath)
{
	RegPath:=LTrim(RegPath, "[")
	RegPath:=RTrim(RegPath, "]")
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
	MyComputer:=MyComputer?MyComputer:(A_OSVersion="WIN_XP")?"我的电脑":"计算机"

	IfWinExist, ahk_class RegEdit_RegEdit
	{
		Global s_DontKillReg
		if !s_DontKillReg
		{
			RunWait, % "cmd.exe /c taskkill /IM regedit.exe", , Hide
			RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %MyComputer%\%RegPath%
			Run, regedit.exe
		Return
		}
		IfNotInString, RegPath, %MyComputer%\
			RegPath := MyComputer "\" RegPath
;tooltip % RegPath
		WinActivate, ahk_class RegEdit_RegEdit
		ControlGet, hwnd, hwnd, , edit, ahk_class RegEdit_RegEdit
		
	}
	Else
	{
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %MyComputer%\%RegPath%
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