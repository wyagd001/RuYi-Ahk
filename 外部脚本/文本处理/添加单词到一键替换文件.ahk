;|2.7|2024.06.10|1621
CandySel := A_Args[1]
添加单词到翻译文件:
Gui, 66:Default
Gui, Destroy
Gui, add, text, x5, 原字符串  :
Gui, Add, edit, x+10 Veword  w250, %CandySel%
Gui, add, text, x5, 替换字符串:
Gui, Add, edit, x+10 Vctrans  w250,
Gui, Add, Button, x250  w65 h20 -Multi Default gwtranslist, 确认写入
Gui, Show,, 一键替换写入文件
return

wtranslist:
Gui, Submit, NoHide
if ctrans
	IniWrite,% ctrans, %A_ScriptDir%\..\..\配置文件\外部脚本\一键替换.ini, 翻译, % eword
Gui, Destroy
exitapp
return

66GuiClose:
66GuiEscape:
exitapp