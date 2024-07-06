;|2.6|2024.05.01|1629
;tts.exe 来源  https://gitee.com/onlyclxy/tts_edge/releases
CandySel := A_Args[1]
DetectHiddenWindows, On
if !CandySel
{
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
}
DetectHiddenWindows, Off

Gui, Add, Edit, x10 y10 w400 h400 vtext, %CandySel%
Gui, Add, Text, xp+410 y10, 角色选择:
Gui, Add, DropDownList, xp yp+30 vvolcol, zh-CN-XiaoxiaoNeural||zh-CN-XiaoyiNeural|zh-CN-YunjianNeural|zh-CN-YunxiaNeural|zh-CN-YunyangNeural|zh-CN-YunxiNeural|
Gui, Add, Text, xp yp+30, 语速:
Gui, Add, Slider, vMySlider Range1-10, 3
Gui, Add, Text, xp yp+40, 音调:
Gui, Add, Slider, vMySlider2 Range1-10, 3
Gui, Add, button, xp yp+40 gplay, 试听
Gui, Add, button, xp+50 yp greplay, 重听
Gui, show,, 文本转语音
if CandySel
	gosub play
return

play:
Gui, submit, nohide
FileDelete, %A_temp%\output.mp3
run "%A_ScriptDir%\..\..\引用程序\x32\tts.exe" "%text%" -l %volcol% -p %MySlider2% -r %MySlider% -v 4 -o "%A_temp%\output.mp3", , hide
;msgbox "%A_ScriptDir%\..\..\引用程序\x32\tts.exe" "%text%" -l %volcol% -p %MySlider% -r %MySlider2% -v 4 -o "%A_temp%\output.mp3"
sleep 3000
soundplay %A_temp%\output.mp3
;msgbox "%A_temp%\output.mp3"
;soundplay "%A_temp%\output.mp3"
return

replay:
if fileexist(A_temp "\output.mp3")
	soundplay %A_temp%\output.mp3
return

GuiClose:
Guiescape:
Gui,  Destroy
ExitApp