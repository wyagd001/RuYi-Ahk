;|2.9|2025.01.30|1621
CandySel := A_Args[1]
添加单词到翻译文件:
Gui, 66:Default
Gui, Destroy
translistfile := A_ScriptDir "\..\..\配置文件\外部脚本\文本处理\一键替换.ini"
if !fileexist(translistfile)
    FileCopy % A_ScriptDir "\..\..\配置文件\外部脚本\文本处理\一键替换_默认配置.ini", % translistfile
Gui, add, text, x5, 原字符串  :
Gui, Add, edit, x+10 Veword  w250, %CandySel%
Gui, add, text, x5, 替换字符串:
Gui, Add, edit, x+10 Vctrans  w250,
Gui, add, text, x5, 替换类型  :
Gui, Add, combobox, x+10 Vctranstype w250, 翻译||股票基金|合体字
Gui, Add, Button, x250  w65 h20 -Multi Default gwtranslist, 确认写入
Gui, Show,, 一键替换写入文件
return

wtranslist:
Gui, Submit, NoHide
if ctrans
	IniWrite,% ctrans, % translistfile, % ctranstype, % eword
Gui, Destroy
exitapp
return

66GuiClose:
66GuiEscape:
exitapp