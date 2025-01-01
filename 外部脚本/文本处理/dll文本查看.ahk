;|2.3|2023.09.01|1450
; %SystemRoot%\system32\shell32.dll,-16769
; @shell32.dll,-30397
; @shell32.dll,-30318
; @%SystemRoot%\system32\shell32.dll,-4153
; @%SystemRoot%\system32\zipfldr.dll,-10194
; @Windows.UI.Immersive.dll,-38306
; %SystemRoot%\System32\imageres.dll,-5203
; @%SystemRoot%\system32\cscui.dll,-7006
; @C:\Windows\System32\dfshim.dll,-200
; @%SystemRoot%\System32\shell32.dll,-34649
; @wmploc.dll,-102
; %SystemRoot%\system32\wmploc.dll,-730
; @shell32.dll,-22069
; @%SystemRoot%\system32\WpcRefreshTask.dll,-32000
; notepad.exe, 470

CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}

Tmp_Arr := StrSplit(CandySel, ",")
dllfile := Trim(Tmp_Arr[1], " """)
dllfile := Deref(dllfile)
GuiText2(TranslateMUI(StrReplace(dllfile, "@"), Abs(Tmp_Arr[2])), "文件文本资源查看", CandySel, "转换",450)
return

转换:
Gui, GuiText2: Submit, NoHide
if myedit1
{
	Tmp_Arr := StrSplit(myedit1, ",")
	dllfile := Trim(Tmp_Arr[1], " """)
	dllfile := Deref(dllfile)
	;MsgBox % dllfile " - " Tmp_Arr[2]
	GuiControl,, myedit2, % TranslateMUI(StrReplace(dllfile, "@"), Abs(Tmp_Arr[2]))
}
return

GuiText2(Gtext2, Title:="", Gtext1:="", Label:="", w:=300, l:=20)
{
	global myedit1, myedit2, TextGuiHwnd
	Gui,GuiText2: Destroy
	Gui,GuiText2: Default
	Gui, +HwndTextGuiHwnd
	;MsgBox % Gtext1
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
	Gui, GuiText: Destroy
	ExitApp
	Return
}

TranslateMUI(resDll, resID)
{
	VarSetCapacity(buf, 256)
	hDll := DllCall("LoadLibrary", "str", resDll, "Ptr")
	Result := DllCall("LoadString", "uint", hDll, "uint", resID, "uint", &buf, "int", 128)
	;msgbox % StrGet(&buf, Result)
	VarSetCapacity(buf, -1)  ; 去除多余的 00
	Return buf
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