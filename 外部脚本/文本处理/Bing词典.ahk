;|2.2|2023.08.03|1407
#SingleInstance force
CandySel := A_Args[1]
Bing词典网络翻译:
	Bing_keyword := CandySel
	Bing_keyword := Trim(Bing_keyword, " `t`r`n")
	If !Bing_keyword                          ;如果粘贴板里面没有内容，则判断是否有窗口定义
		Return
fyText := BingFanyi(Bing_keyword)
GuiText2(fyText, "Bing 翻译", Bing_keyword, "Bing")
gosub soundpaly
return

Bing:
Gui, GuiText2: Submit, NoHide
if myedit1
{
	Bing_keyword := myedit1
	fyText := BingFanyi(Trim(Bing_keyword))
	GuiControl,, myedit2, %fyText%
	gosub soundpaly
}
return

BingFanyi(word)
{
	url := "https://cn.bing.com/dict/search?q=" . EncodeDecodeURI(word)
	
	httpRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	httpRequest.Open("GET", url)
	httpRequest.Send()
	
	responseBody := httpRequest.ResponseText
	
	; return BingExtract(SubStr(responseBody, 1, 2000))
	
	html := ComObjCreate("HTMLFile")
	html.write(responseBody)
	;FileAppend, % responseBody, %A_Desktop%\7890.txt, UTF-8
	div := html.getElementsByTagName("div")
	
	; 翻译
	result .= div[14].innerText
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

GuiText2(Gtext2, Title:="", Gtext1:="", Label:="", w:=300, l:=20)
{
	global myedit1, myedit2, TextGuiHwnd
	Gui,GuiText2: Destroy
	Gui,GuiText2: Default
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

	GuiText2GuiClose:
	GuiText2Guiescape:
	Gui, GuiText2: Destroy
	ExitApp
	Return
}

soundpaly:
	if !IsObject(spovice)
		spovice:=ComObjCreate("sapi.spvoice")
	spovice.Speak(Bing_keyword)
Return