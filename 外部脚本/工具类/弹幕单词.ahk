;|2.7|2024.05.23|1608
; 来源网址: https://www.autohotkey.com/board/topic/10997-text-ticker-display/
/*

NAME:								TickerDisplay.ahk

AUTHOR:							Colin Edwards

VERSION:						1.0
										Aug. 27th 2006

DESCRIPTION:				Overlays a Window on the screen containing scrolling text.

USAGE:							Add the line '#Include TickerDisplay.ahk' to your AHK script
										Call with	DisplayTicker(Scroll Text, Padding Character, FontFormat, GuiSizePos)

PARAMTERS:
==========
Scroll Text:				The message you want to scrolll across the screen 
										(Optional) If omitted, the currently scrolling message window is detroyed

Padding Character:	(Optional) The character that lead and trails the Scroll Text. 
										Default is a space.

FontFormat:					(Optional) Any valid AHK Font settings
										Default is "s30, Verdana, w700, cFFFFFF"

GuiSizePos:					(Optional And valid AHK Gui settings										
										Default is "x0 y0 w%A_ScreenWidth% h60"

*/
Filename := A_scriptdir "\..\..\引用程序\其它资源\8000.txt"
Random, Rand, 1, 7744
FileReadLine, Rand_word, % Filename, % Rand
Rand_FontArr := ["微软雅黑", "宋体", "Arial", "Courier New"]
DisplayTicker(Rand_word,"","s30, c00FF00, Courier New")
return

ScrollText:
	GuiControl,, ScrollDisplay, %ScrollText%
	StringLeft, sTrimmedChar, ScrollText, 1

	If iRedundantPadChars > 0
		iRedundantPadChars --
	else
		ScrollText = %ScrollText%%sTrimmedChar%
		
	StringTrimLeft, ScrollText, ScrollText, 1

if (sTrimmedChar = "[")
	Wordpaly(Rand_word)
if (sTrimmedChar = "。")
{
	Gui, Destroy
	SetTimer, ScrollText, Off
	Random, Rand, 1, 7744
	FileReadLine, Rand_word, % Filename, % Rand
	Random, RandY, 1, % A_ScreenHeight - 32
	Random, RandW, 300, %A_ScreenWidth%
	Random, Rand_FontSize, 15, 30
	Random, Rand_FontColor, 0, 16777215
	Rand_FontColor := SubStr(dec2hex(Rand_FontColor), 3)
	Random, Rand_FontIndex, 1, 4
	Rand_Font := Rand_FontArr[Rand_FontIndex]

	FontFormat = s%Rand_FontSize%, c%Rand_FontColor%, %Rand_Font%
	;tooltip % FontFormat
	DisplayTicker(Rand_word,"", FontFormat, "x0 y" RandY " w" RandW " h50")
}
return

DisplayTicker(pScrollText=0, pPadChar=0, pFontFormat=0, pGuiSizePos=0)
{
	global ScrollText, sGuiSizePos, sFontFormat, sPadChar
	global iScrollTextSize, ScrollDisplay, MsgW, PadCharW
	global iRedundantPadChars
	
	if Not pScrollText
		Gosub, GuiClose

	;defaults
	iGuiWidth := A_ScreenWidth
	iGuiHeight := 60
	sFontFormat = s30, Verdana, w700, cFFFFFF
	sGuiSizePos = x0 y0 w%A_ScreenWidth% h60
	sPadChar := A_Space

	if pFontFormat
		sFontFormat := pFontFormat

	if pGuiSizePos
		sGuiSizePos := pGuiSizePos

	;Get the width paramter if passed as part of the size/pos string - if not passed remains set to screen width
	Loop, parse, sGuiSizePos, %A_Space% 
	{
		StringLeft, sChar, A_LoopField, 1
		if sChar = w
		{
			StringTrimLeft, iGuiWidth, A_LoopField, 1
		}
	}

	if pPadChar
		sPadChar := pPadChar

	ScrollText := pScrollText
	
	Gosub, SizeObjects

	iPadLength := iGuiWidth - MsgW
	iTotalPadChars := Ceil( iGuiWidth / PadCharW)
	iReqdPadChars := Ceil( iPadLength / PadCharW)
	if iReqdPadChars < 0
		iReqdPadChars = iTotalPadChars
	iRedundantPadChars := iTotalPadChars - iReqdPadChars
	iScrollTextSize := iGuiWidth + MsgW

	AutoTrim, Off
	Loop, %iTotalPadChars%
		ScrollPadding = %ScrollPadding%%sPadChar%

	ScrollText =  %ScrollPadding%%ScrollText%

	GoSub, MainGui
	Wordpaly(pScrollText)

	Random, RandTime, 150, 330
	;tooltip % RandTime
	SetTimer, ScrollText, % RandTime
	return
}

MainGui:
	Gui, +AlwaysOnTop -Caption +LastFound +toolwindow
	hwndgui := "ahk_id " WinExist() 

	;WinSet, Transparent, 230, %hwndgui%
	TransArr := [0, 0, 0, 0, 0, 1, 0, 0, 0, 0]
	Random, Rand_Trans, 1, 10
	if !TransArr[Rand_Trans]
		WinSet, TransColor, F0F0F0
	else
	{
		Random, Rand_Color, 0, 16777215
		Rand_Color := dec2hex(Rand_Color)
		Gui, Color, %Rand_Color%
	}
	Gui, Font, %sFontFormat%
	Gui, Add, Text,  x0 y10 w%iScrollTextSize% vScrollDisplay
	Gui, Show, %sGuiSizePos% NoActivate, %hwndgui%
return

dec2hex(d)
{
	BackUp_FmtInt := A_FormatInteger
	SetFormat, integer, H
	h := d+0
	SetFormat, IntegerFast, %BackUp_FmtInt%
return h
}

SizeObjects:
	Gui, +LastFound
	
	Gui, Font, %sFontFormat%
	Gui, Add, Text, x0 y10  vPadChar, %sPadChar%
	Gui, Add, Text, x0 y10 R1 h50 vMsg, %ScrollText%
	GuiControlGet, PadChar, Pos
	GuiControlGet, Msg, Pos
	Gui, Destroy
return

Wordpaly(Word)
{
	static spovice
	if !IsObject(spovice)
		spovice := ComObjCreate("sapi.spvoice")
	Rand_word := 	SubStr(Word, 1, Instr(Word, " ["))
	spovice.Speak(Rand_word)
}

GuiClose:
	Gui, Destroy
	Exit
Return
