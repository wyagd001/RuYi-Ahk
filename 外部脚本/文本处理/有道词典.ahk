;|2.2|2023.08.03|1408
#SingleInstance force
CandySel := A_Args[1]
;CandySel := "apple"
有道词典网络翻译:
	Youdao_keyword := CandySel
	Youdao_keyword := Trim(Youdao_keyword, " `t`r`n")
	If !Youdao_keyword                          ;如果粘贴板里面没有内容，则判断是否有窗口定义
		Return
	fyText := YouDaoFanyi(Youdao_keyword)
GuiText(fyText, "有道翻译", Youdao_keyword, "Youdao")
gosub soundpaly
return

Youdao:
Gui, GuiText: Submit, NoHide
if myedit1
{
	Youdao_keyword := myedit1
	fyText := YouDaoFanyi(Trim(Youdao_keyword))
	GuiControl,, myedit2, %fyText%
	gosub soundpaly
}
return

YouDaoFanyi(word)
{
	url := "https://www.youdao.com/result?lang=en&word=" . EncodeDecodeURI(word)
	httpRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	httpRequest.Open("GET", url)
	httpRequest.Send()

	HtmlText := httpRequest.ResponseText

	html := ComObjCreate("HTMLFile")
	html.write(SubStr(HtmlText, 30000))

	ul := html.getElementsByTagName("ul")
	span := html.getElementsByTagName("span")

	result := ""
	;音标
	result .= span[17].innerText . " " . span[18].innerText . " " . span[19].innerText . " " . span[20].innerText  . "`n"
	;翻译
	result .= ul[5].innerText . "`n"
	;语法
	; result .= html.getElementsByTagName("ul")[6].innerText . " "
	; network
	result .= ul[8].innerText . "`n"
	; phrase
	result .= ul[9].innerText . "`n"
	result .= ul[11].innerText . "`n"
	result .= ul[13].innerText . "`n"
	return result
}

EncodeDecodeURI(str, encode := true, component := true)
{
	static Doc, JS
	if !Doc
	{
		Doc := ComObjCreate("htmlfile")
		Doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
		JS := Doc.parentWindow
		( Doc.documentMode < 9 && JS.execScript() )
	}
	Return JS[ (encode ? "en" : "de") . "codeURI" . (component ? "Component" : "") ](str)
}

GuiText(Gtext2, Title:="", Gtext1:="", Label:="", w:=300, l:=20)
{
	global myedit1, myedit2, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd
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

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	ExitApp
	Return
}

soundpaly:
	if !IsObject(spovice)
		spovice:=ComObjCreate("sapi.spvoice")
	spovice.Speak(Youdao_keyword)
Return