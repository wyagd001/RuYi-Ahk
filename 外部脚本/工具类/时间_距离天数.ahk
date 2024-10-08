﻿;|2.7|2024.07.11|1576
#Include <WinHttp>
CandySel := A_Args[1]
目标名称 := A_Args[2]
模式 := A_Args[3]
Today := A_YYYY A_MM A_DD
DaysLeft := CandySel
EnvSub, DaysLeft, %Today%, days

诗Obj := {1:"人生若只如初见，\n何事秋风悲画扇。\n等闲变却故人心，\n却道故人心易变。\n骊山语罢清宵半，\n泪雨霖铃终不怨。\n何如薄幸锦衣郎，\n比翼连枝当日愿。", 2:"我住长江头，\n君住长江尾。\n日日思君不见君，\n共饮长江水。\n此水几时休，\n此恨何时已。\n只愿君心似我心，\n定不负相思意。", 3:"重帏深下莫愁堂，\n卧后清宵细细长。\n神女生涯原是梦，\n小姑居处本无郎。\n风波不信菱枝弱，\n月露谁教桂叶香。\n直道相思了无益，\n未妨惆怅是清狂。", 4:"昨夜星辰昨夜风，\n画楼西畔桂堂东。\n身无彩凤双飞翼，\n心有灵犀一点通。\n隔座送钩春酒暖，\n分曹射覆蜡灯红。\n嗟余听鼓应官去，\n走马兰台类转蓬。", 5:"尊前拟把归期说，\n欲语春容先惨咽。\n人生自是有情痴，\n此恨不关风与月。\n离歌且莫翻新阕，\n一曲能教肠寸结。\n直须看尽洛城花，\n始共春风容易别。", 6:"风急天高猿啸哀，\n渚清沙白鸟飞回。\n无边落木萧萧下，\n不尽长江滚滚来。\n万里悲秋常作客，\n百年多病独登台。\n艰难苦恨繁霜鬓，\n潦倒新停浊酒杯。"}

; 来源网址: https://www.autoahk.com/archives/36793
#SingleInstance Force
Global hGui
Gui +ToolWindow +AlwaysOnTop -Caption +Border +hwndhGui

Gui Color, 0, 0
Gui Add, Text , x305 y3 w10 h10 cffffff g×g,×

Gui, Font, s24, 黑体
Gui Add, Text, x15 y25 w220 h32 cffffff, 距离%目标名称%还有

Gui, Font, s36 cred, 黑体
Gui Add, Text, x45 y65 w100 h45, %DaysLeft%天
Gui, Font

Random, RanVar, 1, 6
Arr := StrSplit(诗Obj[RanVar], "\n")
;msgbox % RanVar "-" Arr.length()
if (Arr.length() = 4)
{
	Gui Add, Text, x15 y125 w300 h40 cffffff vt1 gpMP3, % Arr[1] Arr[2]
	Gui Add, Text, x15 y160 w300 h25 cffffff vt2 gqiehuan, % Arr[3] Arr[4]
	Gui Add, Text, x15 y185 w300 h22 cffffff vt3 gqiehuan
	Gui Add, Text, x15 y220 w300 h22 cffffff vt4 gqiehuan
}
else if (Arr.length() = 8)
{
	Gui Add, Text, x15 y125 w300 h40 cffffff vt1 gpMP3, % Arr[1] Arr[2]
	Gui Add, Text, x15 y160 w300 h22 cffffff vt2 gqiehuan, % Arr[3] Arr[4]
	Gui Add, Text, x15 y185 w300 h22 cffffff vt3 gqiehuan, % Arr[5] Arr[6]
	Gui Add, Text, x15 y220 w300 h22 cffffff vt4 gqiehuan, % Arr[7] Arr[8]
}
gx := A_ScreenWidth - 370
Gui Show, w320 h250 x%gx% y20 NoActivate, 天数倒计时
if (模式 = 1)
{
	pin2desk(hGui)
}
else
{
	SetStyle(hGui, 4)
}
Return

×g:
ExitApp

pMP3:
if !fileexist(ttsfile) && 每日一句_mp3
{
	WinHttp.URLGet(每日一句_mp3,,, ttsfile)
	sleep, 1500
	SoundPlay, %ttsfile%, wait
}
return

qiehuan:
ttsfile := A_SCRIPTDIR "\..\..\临时目录\tts.mp3"
FileDelete, %ttsfile%
每日一句_Str := WinHttp.URLGet("https://open.iciba.com/dsapi/")
每日一句_Text := json(每日一句_Str, "content")
每日一句_fyText := json(每日一句_Str, "note")
每日一句_mp3 := json(每日一句_Str, "tts")
GuiControl,, t1, % 每日一句_Text
GuiControl,, t2, 
GuiControl,, t3, % 每日一句_fyText
GuiControl,, t4
return

WM_MOVE() { ;窗口移动事件·防止Acrylic效果拖动窗口时滞后
global 模式
    Static init:=OnMessage(0x3, "WM_MOVE")
		if !模式
			SetStyle(hGui, 2)
}
WM_EXITSIZEMOVE() { ;窗口结束移动事件·防止Acrylic效果拖动窗口时滞后
global 模式
    Static init:=OnMessage(0x232, "WM_EXITSIZEMOVE")
		if !模式
			SetStyle(hGui, 4)
}
WM_LBUTTONDOWN() { ;窗口鼠标左键按下事件·用于窗口随意拖动
    Static init:=OnMessage(0x201, "WM_LBUTTONDOWN")
    PostMessage, 0xA1, 2
}

SetStyle(hwnd, style) {
    ;【style】1颜色2淡蓝色3模糊4亚克力6透明
    VarSetCapacity(data1, 16) ;开辟一个内存空间   
    NumPut(style, data1, 0)
    NumPut(0x78000000, data1, 8) ;0x78为16进制的Alpha透明度，000000为背景色
    VarSetCapacity(data2, A_PtrSize=4?12:24) ;开辟一个内存空间
    NumPut(19, data2, 0)
    NumPut(&data1, data2, A_PtrSize=4?4:8)
    NumPut(16, data2, A_PtrSize=4?8:16)
    DllCall("user32\SetWindowCompositionAttribute", "ptr", hwnd, "ptr", &data2)
    WinSet, Transparent, 254, ahk_id %hwnd% ;防止鼠标穿透窗体
}

pin2desk(shwnd)
{
	DetectHiddenWindows, Off
	WinGet, DesktopID, ID, ahk_class WorkerW
	if !DesktopID
		WinGet, DesktopID, ID, ahk_class Progman

	DllCall("SetParent", "UInt", shwnd, "UInt", DesktopID)
	DetectHiddenWindows, On
}

json(ByRef js, s, v = "")
{
	j = %js%
	Loop, Parse, s, .
	{
		p = 2
		RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
		Loop {
			If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
				. "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
				Return
			Else If (x2 == q2 or q2 == "*") {
				j = %x3%
				z += p + StrLen(x2) - 2
				If (q3 != "" and InStr(j, "[") == 1) {
					StringTrimRight, q3, q3, 1
					Loop, Parse, q3, ], [
					{
						z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
						j = %x1%
					}
				}
				Break
			}
			Else p += StrLen(x)
		}
	}
	If v !=
	{
		vs = "
		If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
			and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
			vs := "", v := vx1
		StringReplace, v, v, ", \", All
		js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
	}
	Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
		? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
}