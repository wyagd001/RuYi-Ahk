;|2.1|2023.07.21|1369
#NoEnv
#singleinstance off
SendMode input
SetTitleMatchMode, 1
SetBatchLines, -1
SetMouseDelay, -1

;_____________________________________________________________________________________________
;________ basic variables ____________________________________________________________________


cells =
loop, 9
{
	row = %a_index%
	loop, 9
	{
		column = %a_index%
		cells = %cells%%row%%column%-
		cell%row%%column% = 0
		highlight%row%%column% = 0
		loop, 9
			PencilMark%row%%column%%a_index% = 0
	}
}
stringtrimright, cells, cells, 1

unit1 = 11-12-13-14-15-16-17-18-19	; rows
unit2 = 21-22-23-24-25-26-27-28-29
unit3 = 31-32-33-34-35-36-37-38-39
unit4 = 41-42-43-44-45-46-47-48-49
unit5 = 51-52-53-54-55-56-57-58-59
unit6 = 61-62-63-64-65-66-67-68-69
unit7 = 71-72-73-74-75-76-77-78-79
unit8 = 81-82-83-84-85-86-87-88-89
unit9 = 91-92-93-94-95-96-97-98-99
unit10 = 11-21-31-41-51-61-71-81-91	; columns
unit11 = 12-22-32-42-52-62-72-82-92
unit12 = 13-23-33-43-53-63-73-83-93
unit13 = 14-24-34-44-54-64-74-84-94
unit14 = 15-25-35-45-55-65-75-85-95
unit15 = 16-26-36-46-56-66-76-86-96
unit16 = 17-27-37-47-57-67-77-87-97
unit17 = 18-28-38-48-58-68-78-88-98
unit18 = 19-29-39-49-59-69-79-89-99
unit19 = 11-12-13-21-22-23-31-32-33	; blocks
unit20 = 14-15-16-24-25-26-34-35-36
unit21 = 17-18-19-27-28-29-37-38-39
unit22 = 41-42-43-51-52-53-61-62-63
unit23 = 44-45-46-54-55-56-64-65-66
unit24 = 47-48-49-57-58-59-67-68-69
unit25 = 71-72-73-81-82-83-91-92-93
unit26 = 74-75-76-84-85-86-94-95-96
unit27 = 77-78-79-87-88-89-97-98-99

loop, parse, cells, -
{
	rc = %a_loopfield%
	string =
	loop, 27
		ifinstring, unit%a_index%, %rc%
			loop, parse, unit%a_index%, -
				if a_loopfield <> %rc%
				ifnotinstring, string, %a_loopfield%
					string = %string%%a_loopfield%-
	stringtrimright, ConnectedCells%rc%, string, 1
}

color1name = white
color1value = white
color2name = yellow
color2value = yellow
color3name = orange
color3value = ff8040
color4name = red
color4value = red
color5name = purple
color5value = purple
color6name = blue
color6value = blue
color7name = light blue
color7value = aqua
color8name = green
color8value = green
color9name = black
color9value = black

cBackground1 = FFFFFF  ; background color for numbers
cBackground2 = DDEEFF  ; background color for colors
cNumber1 = black

wCell1 = 80
sNumber1 = 50
sColor1 = 54
sHighlight1 = 60
wPencilMark1 = 22
sPencilNumber1 = 14
sPencilColor1 = 12

cBackground = %cBackground1%
cNumber = %cNumber1%

PlusMinus = 0
switch = numbers

;_____________________________________________________________________________________________
;________ GUI ________________________________________________________________________________


gui, 1:-DPIScale
if (a_screendpi > 96)
{
	sNumber1 := sNumber1*96//a_screendpi
	sColor1 := sColor1*96//a_screendpi
	sHighlight1 := sHighlight1*96//a_screendpi
	sPencilNumber1 := sPencilNumber1*96//a_screendpi
	sPencilColor1 := sPencilColor1*96//a_screendpi
}
if (a_screenheight < 10*wCell1)
	PlusMinus -= 1

loop
{
	winTitle = Sudoku %A_Index%
	IfWinNotExist, %winTitle%
		break
}
GroupAdd, SudokuWindows, %winTitle%

menu, SudokuMenu, add, &Easy and symmetrical, easy
menu, SudokuMenu, add, &Difficult but not symmetrical, difficult
menu, SudokuMenu, add, &Open..., open
menu, SudokuMenu, add, &Save as..., SaveAs
menu, SudokuMenu, add  ; separator line
menu, SudokuMenu, add, house
menu, SudokuMenu, add, Christmas tree, ChristmasTree
menu, SudokuMenu, add, spiral
menu, SudokuMenu, add, M
menu, SudokuMenu, add, crown
menu, SudokuMenu, add, sun
menu, SudokuMenu, add, smiley
menu, SudokuMenu, add, heart
menu, SudokuMenu, add  ; separator line
menu, SudokuMenu, add, &Create from image..., create

menu, ViewMenu, add, &Larger	+, larger
menu, ViewMenu, add, &Smaller	-, smaller
menu, ViewMenu, add, S&witch between numbers and colors, switch

menu, SolveMenu, add, Find &one	Ctrl+page down, FindOne
menu, SolveMenu, add, Find &all, FindAll

menu, PlayMenu, add, &Back	page up, back
menu, PlayMenu, add, &Forward	page down, forward
menu, PlayMenu, add, &Set obvious pencil marks, SetPencilMarks
menu, PlayMenu, add, &Remove pencil marks, RemovePencilMarks
menu, PlayMenu, add, &Clear board, ClearBoard

menu, MenuBar, add, &Sudoku, :SudokuMenu
menu, MenuBar, add, &View, :ViewMenu
menu, MenuBar, add, &Play, :PlayMenu
menu, MenuBar, add, S&olve, :SolveMenu
menu, MenuBar, add, &Help, help

gui, 1:menu, MenuBar

menu, LeftMouseMenu, add
menu, RightMouseMenu, add

loop, parse, cells, -
{
	gui, 1:add, text, vGridCell%a_loopfield% -background, g
	; G in Webdings makes the grid. Without Webdings, -background makes the grid.
	gui, 1:add, text, vhighlight%a_loopfield%
	gui, 1:add, text, vcell%a_loopfield% +center backgroundtrans
	loop, 9
		gui, 1:add, text, vPencilMark%a_loopfield%%a_index% +center backgroundtrans
}

gosub CellsSize
gui, 1:color, %cBackground%
gui, 1:show, w%wGui% h%wGui%, %winTitle%  ; GuiSize is launched

return

;_____________________________________________________________________________________________
;________ gui events _________________________________________________________________________


GuiClose:
something = 0
loop, parse, cells, -
{
	if (cell%a_loopfield% <> 0)
		something += 1
	else loop, 9
		if (PencilMark%a_loopfield%%a_index% = 1)
			something += 1
}
if something > 3
{
	msgbox, 0x2003,, Do you want to save the current situation?
	IfMsgBox Yes
		gosub SaveAs
	IfMsgBox Cancel
		return
}
exitapp

;---------------------------------------------------------------------------------------------

GuiSize:
wingetpos,,,, winheight, %winTitle% ahk_class AutoHotkeyGUI
hTitleMenu := winheight-a_guiheight
return

;_____________________________________________________________________________________________
;________ keyboard hotkeys ___________________________________________________________________


#ifwinactive ahk_group SudokuWindows ahk_class AutoHotkeyGUI

~Esc::
tooltip
return

;---- move the mouse cursor ------------------------------------------------------------------

~left::
~right::
~up::
~down::
stringtrimleft, key, a_thishotkey, 1
if key = left
{
	hor = -1
	ver = 0
}
else if key = right
{
	hor = 1
	ver = 0
}
else if key = up
{
	hor = 0
	ver = -1
}
else if key = down
{
	hor = 0
	ver = 1
}
mousemove hor*wCell, ver*wCell,, R
gosub MouseGetNearestCell
click %xcenter%, %ycenter%, 0
return

;---- set numbers/colors ---------------------------------------------------------------------

1::
2::
3::
4::
5::
6::
7::
8::
9::
numpad1::
numpad2::
numpad3::
numpad4::
numpad5::
numpad6::
numpad7::
numpad8::
numpad9::
stringright, n, a_thislabel, 1
if CreateIndex = 4
	gosub swap
else
{
	gosub MouseGetNearestCell
	valid = 1
	loop, parse, ConnectedCells%rm%%cm%, -
		if (cell%a_loopfield% = n)
		{
			valid = 0
			break
		}
	if valid = 1
	{
		fill(rm . cm, n)
		loop, parse, ConnectedCells%rm%%cm%, -
			PencilMark(a_loopfield, n, 0)
		BackList := GuiToString() . "/" . BackList
		ForwardList =
	}
	else
	{
		fill(rm . cm, n)
		BackList := GuiToString() . "/" . BackList
		sleep 200
		gosub back
		ForwardList =
	}
}
return

swap:
if swap1 =
	swap1 = %n%
else if (n = swap1)
{
	swap1 =
	tooltip
}
else
{
	swap2 = %n%
	tooltip
	loop, parse, cells, -
	{
		if (cell%a_loopfield% = swap1)
			fill(a_loopfield, swap2)
		else if (cell%a_loopfield% = swap2)
			fill(a_loopfield, swap1)
	}
	BackList := GuiToString() . "/" . BackList
	ForwardList =
	swap1 =
	swap2 =
}
return

;---- set/delete pencil marks ----------------------------------------------------------------

+1::  ; set/delete a single pencil mark
+2::
+3::
+4::
+5::
+6::
+7::
+8::
+9::
+numpad1::
+numpad2::
+numpad3::
+numpad4::
+numpad5::
+numpad6::
+numpad7::
+numpad8::
+numpad9::
gosub MouseGetNearestCell
stringright, n, a_thislabel, 1
if cell%rm%%cm% = 0
{
	if PencilMark%rm%%cm%%n% = 0
	{
		valid = 1
		loop, parse, ConnectedCells%rm%%cm%, -
			if (cell%a_loopfield% = n)
			{
				valid = 0
				break
			}
		if valid = 1
		{
			PencilMark(rm . cm, n, 1)
			BackList := GuiToString() . "/" . BackList
			ForwardList =
		}
		else
		{
			PencilMark(rm . cm, n, 1)
			BackList := GuiToString() . "/" . BackList
			sleep 200
			gosub back
			ForwardList =
		}
	}
	else
	{
		PencilMark(rm . cm, n, 0)
		BackList := GuiToString() . "/" . BackList
		ForwardList =
	}
}
return

p::  ; set/delete all pencil marks from one cell
if CreateIndex = 1
{
	gosub MouseGetNearestCell
	fill(rm . cm, 0)
	loop, 9
	{
		i = %a_index%
		valid = 1
		loop, parse, ConnectedCells%rm%%cm%, -
			if (cell%a_loopfield% = i)
			{
				valid = 0
				break
			}
		if valid = 1
			PencilMark(rm . cm, i, 1)
	}
	BackList := GuiToString() . "/" . BackList
	ForwardList =
}
return

del & 1::  ; delete one pencil mark from all cells
del & 2::
del & 3::
del & 4::
del & 5::
del & 6::
del & 7::
del & 8::
del & 9::
del & numpad1::
del & numpad2::
del & numpad3::
del & numpad4::
del & numpad5::
del & numpad6::
del & numpad7::
del & numpad8::
del & numpad9::
if CreateIndex = 1
{
	stringright, n, a_thislabel, 1
	loop, parse, cells, -
		PencilMark(a_loopfield, n, 0)
	BackList := GuiToString() . "/" . BackList
	ForwardList =
}
return

;---- delete number/color/pencil marks from one cell -----------------------------------------

space::
gosub MouseGetNearestCell
fill(rm . cm, 0)
BackList := GuiToString() . "/" . BackList
ForwardList =
return

;_____________________________________________________________________________________________
;________ mouse hotkeys ______________________________________________________________________


;---- set and delete numbers and colors and pencil marks -------------------------------------

~lbutton::
gosub MouseGetNearestCell
wingetpos,,, width, height, %winTitle% ahk_class AutoHotkeyGUI
if (xm > 0 and xm < width and ym > hTitleMenu and ym < height)
{
	sleep 40  ; doesn't work without, don't know why
	empty = 1
	single = 0
	if cell%rm%%cm% <> 0
		empty = 0
	else loop, 9
		if PencilMark%rm%%cm%%a_index% = 1
		{
			empty = 0
			single += 1
		}
	if (CreateIndex = 1 and empty = 1)
	{
		loop, 9
		{
			i = %a_index%
			valid = 1
			loop, parse, ConnectedCells%rm%%cm%, -
				if (cell%a_loopfield% = i)
				{
					valid = 0
					break
				}
			if valid = 1
				PencilMark(rm . cm, i, 1)
		}
		BackList := GuiToString() . "/" . BackList
		ForwardList =
	}
	else if CreateIndex = 4
	{
		if (cell%rm%%cm% <> 0 and swap1 = "")
		{
			swap1 := cell%rm%%cm%
			if switch = numbers
				text = %swap1%
			else
				text := color%swap1%name
			tooltip, Swap %text% and ...
		}
		else if (cell%rm%%cm% <> 0 and cell%rm%%cm% = swap1)
		{
			swap1 =
			tooltip
		}
		else if (cell%rm%%cm% <> 0 and swap1 <> "" and cell%rm%%cm% <> swap1)
		{
			swap2 := cell%rm%%cm%
			tooltip
			loop, parse, cells, -
			{
				if (cell%a_loopfield% = swap1)
					fill(a_loopfield, swap2)
				else if (cell%a_loopfield% = swap2)
					fill(a_loopfield, swap1)
			}
			BackList := GuiToString() . "/" . BackList
			ForwardList =
			swap1 =
			swap2 =
		}
	}
	else if single = 1
	{
		loop, 9
			if PencilMark%rm%%cm%%a_index% = 1
			{
				n = %a_index%
				fill(rm . cm, n)
				loop, parse, ConnectedCells%rm%%cm%, -
					PencilMark(a_loopfield, n, 0)
				BackList := GuiToString() . "/" . BackList
				ForwardList =
				break
			}
	}
	else
	{
		menu, LeftMouseMenu, deleteall
		loop, 9
		{
			n = %a_index%
			valid = 1
			loop, parse, ConnectedCells%rm%%cm%, -
				if cell%a_loopfield% = %n%
			{
				valid = 0
				break
			}
			if valid = 1
			{
				if switch = colors
					item := color%n%name
				else
					item = %n%
				menu, LeftMouseMenu, add, %item%, SetDeleteNumber
				if (cell%rm%%cm% = n)
					menu, LeftMouseMenu, check, %item%
			}
		}
		menu, LeftMouseMenu, show
	}
}
return

~rbutton::
gosub MouseGetNearestCell
wingetpos,,, width, height, %winTitle% ahk_class AutoHotkeyGUI
if (xm > 0 and xm < width and ym > hTitleMenu and ym < height)
{
	sleep 40
	menu, RightMouseMenu, deleteall
	if (cell%rm%%cm% = 0)  ; menu to set/delete pencil marks
	{
		loop, 9
		{
			n = %a_index%
			valid = 1
			loop, parse, ConnectedCells%rm%%cm%, -
				if cell%a_loopfield% = %n%
			{
				valid = 0
				break
			}
			if valid = 1
			{
				if switch = colors
					item := "pencil mark " . color%a_index%name
				else
					item := "pencil mark " . a_index
				menu, RightMouseMenu, add, %item%, SetDeletePencilMark
				if PencilMark%rm%%cm%%a_index% = 0
					menu, RightMouseMenu, uncheck, %item%
				else
					menu, RightMouseMenu, check, %item%
			}
		}
	}
	menu, RightMouseMenu, show
}
return

SetDeleteNumber:
loop, 9
	if (a_thismenuitem = a_index or a_thismenuitem = color%a_index%name)
{
	n = %a_index%
	if (cell%rm%%cm% <> n)
	{
		fill(rm . cm, n)
		loop, parse, ConnectedCells%rm%%cm%, -
			PencilMark(a_loopfield, n, 0)
	}
	else
		fill(rm . cm, 0)
	BackList := GuiToString() . "/" . BackList
	ForwardList =
	break
}
return

SetDeletePencilMark:
stringtrimleft, NumberOrColor, a_thismenuitem, 12  ; omit "pencil mark "
loop, 9
	if (NumberOrColor = a_index or NumberOrColor = color%a_index%name)
{
	if PencilMark%rm%%cm%%a_index% = 0
		PencilMark(rm . cm, a_index, 1)
	else
		PencilMark(rm . cm, a_index, 0)
	BackList := GuiToString() . "/" . BackList
	ForwardList =
	break
}
return

;_____________________________________________________________________________________________
;________ gui subroutines and hotkeys ________________________________________________________


;---- generate an easy Sudoku ----------------------------------------------------------------

easy:
progress, b zh0 fm20 wm400,, Please wait ...
loop, parse, cells, -
	fill(a_loopfield, 0)
gosub FillRandom
loop, parse, cells, -
	full%a_loopfield% := cell%a_loopfield%
NotYetOmitted = %cells%-  ; The trailing - is needed for stringreplace. <----
;---- omit numbers ----
; Omit numbers found by FillRandom if there was no choice.
sort, NotYetOmitted, random d-
AlreadyLooped =
loop, parse, NotYetOmitted, -
	if a_loopfield <>
	ifnotinstring, AlreadyLooped, %a_loopfield%
{
	stringleft, r, a_loopfield, 1
	stringright, c, a_loopfield, 1
	sym1 := r . 10-c
	sym2 := 10-r . c
	sym3 := 10-r . 10-c
	sym4 := c . r
	sym5 := c . 10-r
	sym6 := 10-c . r
	sym7 := 10-c . 10-r
	AlreadyLooped = %AlreadyLooped%%sym1%-%sym2%-%sym3%-%sym4%-%sym5%-%sym6%-%sym7%-
	ifinstring, NoChoice, %a_loopfield%
	ifinstring, NoChoice, %sym1%
	ifinstring, NoChoice, %sym2%
	ifinstring, NoChoice, %sym3%
	ifinstring, NoChoice, %sym4%
	ifinstring, NoChoice, %sym5%
	ifinstring, NoChoice, %sym6%
	ifinstring, NoChoice, %sym7%
	{
		fill(a_loopfield, 0)
		fill(sym1, 0)
		fill(sym2, 0)
		fill(sym3, 0)
		fill(sym4, 0)
		fill(sym5, 0)
		fill(sym6, 0)
		fill(sym7, 0)
		stringreplace, NotYetOmitted, NotYetOmitted, %a_loopfield%-,  ; <----
		stringreplace, NotYetOmitted, NotYetOmitted, %sym1%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym2%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym3%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym4%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym5%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym6%-,
		stringreplace, NotYetOmitted, NotYetOmitted, %sym7%-,
	}
}
; Omit numbers found by GetPossibleNumbers if there was no choice.
AlreadyLooped =
loop, parse, NotYetOmitted, -
	if a_loopfield <>
	ifnotinstring, AlreadyLooped, %a_loopfield%
{
	stringleft, r, a_loopfield, 1
	stringright, c, a_loopfield, 1
	sym1 := r . 10-c
	sym2 := 10-r . c
	sym3 := 10-r . 10-c
	sym4 := c . r
	sym5 := c . 10-r
	sym6 := 10-c . r
	sym7 := 10-c . 10-r
	AlreadyLooped = %AlreadyLooped%%sym1%-%sym2%-%sym3%-%sym4%-%sym5%-%sym6%-%sym7%-
	cell%a_loopfield% = 0
	cell%sym1% = 0
	cell%sym2% = 0
	cell%sym3% = 0
	cell%sym4% = 0
	cell%sym5% = 0
	cell%sym6% = 0
	cell%sym7% = 0
	GetAll = 1
	gosub GetPossibleNumbers
	GetAll = 0
	AllSym = 0
	ifinstring, WhatNext, 1%a_loopfield%
	ifinstring, WhatNext, 1%sym1%
	ifinstring, WhatNext, 1%sym2%
	ifinstring, WhatNext, 1%sym3%
	ifinstring, WhatNext, 1%sym4%
	ifinstring, WhatNext, 1%sym5%
	ifinstring, WhatNext, 1%sym6%
	ifinstring, WhatNext, 1%sym7%
		AllSym = 1
	if AllSym = 1
	{
		fill(a_loopfield, 0)
		fill(sym1, 0)
		fill(sym2, 0)
		fill(sym3, 0)
		fill(sym4, 0)
		fill(sym5, 0)
		fill(sym6, 0)
		fill(sym7, 0)
	}
	else
	{
		cell%a_loopfield% := full%a_loopfield%
		cell%sym1% := full%sym1%
		cell%sym2% := full%sym2%
		cell%sym3% := full%sym3%
		cell%sym4% := full%sym4%
		cell%sym5% := full%sym5%
		cell%sym6% := full%sym6%
		cell%sym7% := full%sym7%
	}
}
BackList := GuiToString() . "/" . BackList
ForwardList =
progress, off
return

;---- generate a difficult Sudoku ------------------------------------------------------------

difficult:
progress, b fm20 wm400 R0-276,, Please wait ...
pos = 0
loop, parse, cells, -
	fill(a_loopfield, 0)
gosub FillRandom
loop, parse, cells, -
	full%a_loopfield% := cell%a_loopfield%
;---- Try for each number if there is still only one solution when omitted. ----
RandomCells = %cells%
sort, RandomCells, random d-
loop, parse, RandomCells, -
{
	if a_index < 4
	{
		fill(a_loopfield, 0)
		continue
	}
	TryOmit = %a_loopfield%
	cell%TryOmit% = 0
	DontDisplay = 1
	StopAt = 1
	gosub FillMinimumFirst
	DontDisplay = 0
	StopAt = 0
	Still1Solution = 0
	if (filled = NoChoice)
		Still1Solution = 1
	else
	{
		FirstSolutionIdentical = 1
		loop, parse, cells, -
			if (FirstSolution%a_loopfield% <> full%a_loopfield%)
		{
			FirstSolutionIdentical = 0
			break
		}
		if FirstSolutionIdentical = 1
		{
			DontDisplay = 1
			gosub FillMaximumFirst
			DontDisplay = 0
			if SecondSolutionIdentical = 1
				Still1Solution = 1
		}
	}
	loop, parse, cells, -
	{
		if (a_loopfield = TryOmit)
		{
			if Still1Solution = 1
				fill(a_loopfield, 0)
			else
				cell%a_loopfield% := full%a_loopfield% 
		}
		else
			cell%a_loopfield% := FillMinimumFirst%a_loopfield%
	}
	if a_index < 60
		pos += 1
	else
		pos += 10
	progress, %pos%
}
BackList := GuiToString() . "/" . BackList
ForwardList =
progress, off
return

;---- open -----------------------------------------------------------------------------------

open:
ifnotexist, %a_desktop%\Sudoku
	FileCreateDir, %a_desktop%\Sudoku
FileSelectFile, Sudoku,, %a_desktop%\Sudoku,, *.txt
if errorlevel = 0
{
	fileread, string, %Sudoku%
	StringToGui(string)
	BackList := GuiToString() . "/" . BackList
	ForwardList =
}
return

;---- save as --------------------------------------------------------------------------------

SaveAs:
ifnotexist, %a_desktop%\Sudoku
	FileCreateDir, %a_desktop%\Sudoku
FileSelectFile, Sudoku, S16, %a_desktop%\Sudoku,, *.txt
if errorlevel = 0
{
	string := GuiToString()
	stringright, extension, Sudoku, 4
	if (extension <> ".txt")
		Sudoku = %Sudoku%.txt
	ifexist, %Sudoku%
		filedelete, %Sudoku%
	fileappend, %string%, %Sudoku%
}
return

;---- house ----------------------------------------------------------------------------------

house:
string =
(
numbers-%cBackground1%-%cNumber1%-152-244-261-334-371-424-481-528-567-579
-584-622-633-649-668-685-723-742-769-778
-786-825-846-883-929-943-982
)
StringToGui(string)
BackList = %string%/%BackList%
ForwardList =
return

;---- Christmas tree -------------------------------------------------------------------------

ChristmasTree:
string =
(
colors-%cBackground2%--114-152-196-251-343-364-448-465-532-578
-637-673-721-788-828-835-842-857-863-871
-884-959
)
StringToGui(string)
BackList = %string%/%BackList%
ForwardList =
return

;---- spiral ---------------------------------------------------------------------------------

spiral:
string =
(
numbers-%cBackground1%-%cNumber1%-248-257-262-331-379-425-456-483-528-541
-563-582-624-669-687-735-742-753-786-874
-961
)
StringToGui(string)
BackList = %string%/%BackList%
ForwardList =
return

;---- M --------------------------------------------------------------------------------------

M:
string =
(
numbers-%cBackground1%-%cNumber1%-212-224-286-293-313-326-337-374-381-399
-411-423-432-444-465-477-488-496-515-528
-542-557-561-583-594-614-627-658-682-695
-719-722-784-791-816-825-887-892
)
StringToGui(string)
BackList = %string%/%BackList%
ForwardList =
return

;---- crown ----------------------------------------------------------------------------------

crown:
string =
(
colors-DDEEFF--216-254-298-312-323-345-368-384-396-413
-432-476-495-514-592-618-651-694-717-791
-811-828-834-842-859-866-873-885-897
)
StringToGui(string)
BackList = %string%/%BackList%
ForwardList =
return

;---- sun ------------------------------------------------------------------------------------

sun:
string =
(
colors-%cBackground2%--136-168-193-242-263-287-351-372-411-426
-435-443-482-498-552-571-644-661-683-734
-762-797-823-866-912-967
)
StringToGui(string)
BackList = %string%/%BackList%
ForwardList =
return

;---- smiley ----------------------------------------------------------------------------------

smiley:
string =
(
numbers-FFFF80-black-147-155-161-231-278-327-346-369-381-428
-484-525-536-573-587-621-642-657-664-685
-733-771-845-853-862
)
StringToGui(string)
BackList = %string%/%BackList%
ForwardList =
return

;---- heart ----------------------------------------------------------------------------------

heart:
string =
(
numbers-%cBackground1%-CC0000-224-235-276-283-317-342-368-391-415-458
-492-511-597-626-681-734-778-841-867-954
)
StringToGui(string)
BackList = %string%/%BackList%
ForwardList =
return

;---- create ---------------------------------------------------------------------------------

create:
CreateIndex = 1
gui, 3:destroy
gui, 2:font, s12
gui, 2:add, text,,
(
Paint an image with pencil marks. You can preset some %switch%.
There must be pencil marks or preset %switch% in at least 17 cells.
The program will try to create a Sudoku from your image:
Empty cells will be left empty, preset %switch% will not be changed,
cells with pencil marks will be filled with one of the pencil mark %switch%.
The left mouse button and the P key are the main painting tools:
They set all possible pencil marks in a cell.
Preset %switch% with the left mouse button or the number keys.
Delete preset %switch% with the left mouse button or the spacebar.
Set and delete single pencil marks with the right mouse button or Shift+number key.
You can delete one pencil mark from all cells with Delete+number key.
)
gui, 2:add, text, xs, 1 = %color1name%
gui, 2:add, text, xp+120, 2 = %color2name%
gui, 2:add, text, xp+120, 3 = %color3name%
gui, 2:add, text, xp+120, 4 = %color4name%
gui, 2:add, text, xp+120, 5 = %color5name%
gui, 2:add, text, xs, 6 = %color6name%
gui, 2:add, text, xp+120, 7 = %color7name%
gui, 2:add, text, xp+120, 8 = %color8name%
gui, 2:add, text, xp+120, 9 = %color9name%

gui, 2:add, button, xs y+20, Create Sudoku
gui, 2:add, button, x+20, Cancel
if guiX =
	guiX = 10
if guiY =
	guiY = 10
gui, 2:show, x%guiX% y%guiY%, Paint an image ...
return

2GuiClose:
2ButtonCancel:
wingetpos, guiX, guiY,,, A
gui, 2:destroy
CreateIndex = 0
return

2ButtonCreateSudoku:
wingetpos, guiX, guiY,,, A
winactivate, %winTitle%
CreateIndex = 2
image =
loop, parse, cells, -
{
	if (cell%a_loopfield% <> 0)
		image = %image%%a_loopfield%-
	else loop, 9
		if (PencilMark%a_loopfield%%a_index% = 1)
	{
		image = %image%%a_loopfield%-
		break
	}
}
stringtrimright, image, image, 1
ImageLen = 0  ;---- less than 17 cells? ----
loop, parse, image, -
	ImageLen += 1
if (ImageLen < 17)
{
	msgbox There must be %switch% or pencil marks in at least 17 cells.
	CreateIndex = 1
	return
}
missing = 123456789  ;---- two numbers missing completely? ----
loop, parse, Image, -
{
	n := cell%a_loopfield%
	stringreplace, missing, missing, %n%,
	loop, 9
	{
		n := PencilMark%a_loopfield%%a_index% 
		if (n = 1)
			stringreplace, missing, missing, %a_index%,
	}
}
stringlen, missingLen, missing
if (missingLen >= 2)
{
	stringleft, missing1, missing, 1
	stringmid, missing2, missing, 2, 1
	if switch = colors
	{
		missing1 := color%missing1%name
		missing2 := color%missing2%name
	}
	msgbox, There can be no unique solution because %missing1% and %missing2% are missing completely and could be swapped.
	CreateIndex = 1
	return
}
loop, 6  ;---- two rows or columns in the same blocks completely empty? ----
{
	i1 := a_index * 3 - 3
	unitA =
	loop, 3
	{
		i2 := i1 + a_index
		empty = 1
		loop, parse, unit%i2%, -
			ifinstring, image, %a_loopfield%
		{
			empty = 0
			break
		}
		if empty = 1
		{
			if (i2 > 9)
				unitB := "column " . (i2 - 9)
			else
				unitB = row %i2%
			if unitA =
				unitA = %unitB%
			else
			{
				msgbox, There can be no unique solution because %unitA% and %unitB% are completely empty and could be swapped.
				CreateIndex = 1
				return
			}
		}
	}
}
loop, 27  ;---- more than n cells with only n possible numbers in one unit? ----
{
	u = %a_index%
	loop, 8
	{
		lenPencilCells := a_index+1
		PencilCells =
		loop, %lenPencilCells%
			PencilCells = %PencilCells%%a_index%
		loop
		{
			InImage = 1
			NotEmpty = 1
			PencilMarks =
			loop, parse, PencilCells
			{
				if (u <= 9)
				{
					row = %u%
					column := a_loopfield
				}
				else if (u <= 18)
				{
					row := a_loopfield
					column := u-9
				}
				else
				{
					block := u-18
					if (block <= 3)
						row = 1
					else if (block <= 6)
						row = 4
					else
						row = 7
					if (block = 1 or block = 4 or block = 7)
						column = 1
					else if (block = 2 or block = 5 or block = 8)
						column = 4
					else
						column = 7
					if (a_loopfield > 6)
						row += 2
					else if (a_loopfield > 3)
						row += 1
					if (a_loopfield = 2 or a_loopfield = 5 or a_loopfield = 8)
						column += 1
					else if (a_loopfield = 3 or a_loopfield = 6 or a_loopfield = 9)
						column += 2
				}
				ifnotinstring, image, %row%%column%
				{
					InImage = 0
					break
				}
				if cell%row%%column% <> 0
				{
					NotEmpty = 0
					break
				}
				loop, 9
					if PencilMark%row%%column%%a_index% = 1
					ifnotinstring, PencilMarks, %a_index%
						PencilMarks = %PencilMarks%%a_index%
			}
			if (InImage = 1 and NotEmpty = 1)
			{
				stringlen, lenPencilMarks, PencilMarks
				if (lenPencilMarks < lenPencilCells)
				{
					PencilCellsText = cells
					loop, parse, PencilCells
						PencilCellsText = %PencilCellsText% %a_loopfield% and
					stringtrimright, PencilCellsText, PencilCellsText, 4
					if (u <= 9)
						unit := "row " . u
					else if (u <= 18)
						unit := "column " . u-9
					else
						unit := "block " . u-18
					msgbox, In %PencilCellsText% in %unit% there are only %lenPencilMarks% possible %switch%, so one cell can't be filled.
					CreateIndex = 1
					return
				}
			}
			PencilCellsR =
			loop, parse, PencilCells
				PencilCellsR := a_loopfield . PencilCellsR
			FirstPossibleIncrease =
			loop, parse, PencilCellsR
				if (a_loopfield < 10-a_index)
				{
					FirstPossibleIncrease := lenPencilCells+1-a_index
					break
				}
			if FirstPossibleIncrease =
				break
			PencilCellsNew =
			loop, parse, PencilCells
			{
				if (a_index < FirstPossibleIncrease)
					PencilCellsNew := PencilCellsNew . a_loopfield
				else if (a_index = FirstPossibleIncrease)
				{
					increase := a_loopfield+1
					PencilCellsNew := PencilCellsNew . increase
				}
				else
				{
					increase += 1
					PencilCellsNew := PencilCellsNew . increase
				}
			}
			PencilCells = %PencilCellsNew%
		}
	}
}
PresetImage =
PencilImage =
loop, parse, image, -
	if (cell%a_loopfield% <> 0)
		PresetImage = %PresetImage%%a_loopfield%-
	else
		PencilImage = %PencilImage%%a_loopfield%-
stringtrimright, PresetImage, PresetImage, 1
stringtrimright, PencilImage, PencilImage, 1
if PencilImage =  ;---- no pencil marks? ----
{
	msgbox,
(
There are no pencil marks.
There have to be pencil marks so that the Sudoku creator can try different %switch%.
)
	CreateIndex = 1
	return
}
loop, parse, cells, -
	DeletedNumbers%a_loopfield% =
loop, parse, PencilImage, -
	loop, 9
		if (PencilMark%a_loopfield%%a_index% = 0)
			DeletedNumbers%a_loopfield% := DeletedNumbers%a_loopfield% . a_index
gosub FillMinimumFirst
if SolutionAtAll = 0
{
	msgbox, There is no solution.
	CreateIndex = 1
	return
}
gosub LeaveImage
gui, 2:destroy
CreateIndex = 3
interrupt = 0
examined = 0
NoSolution = 0
LastPossible = 0
DontRepeatList =
loop							;---- START CHANGING NUMBERS ----
{
	FirstIndex = %a_index%
	if (FirstIndex - LastPossible > 2)
	{
		CreateIndex = 4
		BackList := GuiToString() . "/" . BackList
		gosub back
		ForwardList =
SoundBeep, 480, 240
sleep 80
SoundBeep, 480, 240
sleep 80
SoundBeep, 720, 240
sleep 80
SoundBeep, 720, 240
sleep 80
SoundBeep, 768, 240
sleep 80
SoundBeep, 768, 240
sleep 80
SoundBeep, 720, 400
		guicontrol, 3:text, Gui3Text, Can't create a Sudoku with a unique solution.
		return
	}
	loop, parse, PencilImage, -
	{
		PencilImageLoopfield = %a_loopfield%
		PencilImageIndex = %a_index%
		stringleft, PencilImageLoopfieldL, PencilImageLoopfield, 1
		stringright, PencilImageLoopfieldR, PencilImageLoopfield, 1
		if (FirstIndex = 1 and PencilImageIndex = 1)
		{
			gui, 3:font, s12
			gui, 3:add, text, vGui3Text w500,
(
Loop 1, row %PencilImageLoopfieldL%, column %PencilImageLoopfieldR%
Examined positions:
Cells with no unique solution:

Please wait, this can take some time ...
)
			gui, 3:add, button,, Cancel
			gui, 3:show, x%guiX% y%guiY% w520, Create a Sudoku ...
		}
		else
			guicontrol, 3:text, Gui3Text,
(
Loop %FirstIndex%, row %PencilImageLoopfieldL%, column %PencilImageLoopfieldR%
Examined positions: %examined%
Cells with no unique solution: %DiffMin%

Please wait, this can take some time ...
)
		if interrupt = 1
		{
			gui, 3:destroy
			CreateIndex = 0
			BackList := GuiToString() . "/" . BackList
			ForwardList =
			return
		}
		else if interrupt = 2
		{
			BackList := GuiToString() . "/" . BackList
			gosub back
			ForwardList =
			gosub create
			return
		}
		DontRepeatString =
		loop, parse, PencilImage, -
			if (a_loopfield <> PencilImageLoopfield)
				DontRepeatString := DontRepeatString . cell%a_loopfield%
			else
				DontRepeatString = %DontRepeatString%X
		ifinstring, DontRepeatList, %DontRepeatString%
		{
			results := %DontRepeatString%  ; results is the value of the value of DontRepeatString!
			if (results <> "")
			{
				LastPossible := FirstIndex
				loop, parse, results, -
				{
					NextResult = %a_loopfield%
					break
				}
				loop, parse, NextResult, /
					if (a_index = 1)
						DiffMin = %a_loopfield%
					else
						PencilImageString = %a_loopfield%
				loop, parse, PencilImage, -
				{
					stringmid, n, PencilImageString, a_index, 1
					fill(a_loopfield, n)
				}
				stringlen, len, NextResult
				stringtrimleft, results, results, len+1
				%DontRepeatString% := results
			}
			continue
		}
		DontRepeatList = %DontRepeatList%%DontRepeatString%`n
		missing = 123456789
		loop, parse, Image, -
			if (a_loopfield <> PencilImageLoopfield)
			{
				n := cell%a_loopfield%
				stringreplace, missing, missing, %n%,
			}
		stringlen, missingLen, missing
		if (missingLen >= 2)
			possible = %missing%
		else
			possible = 123456789
		if (FirstIndex = 1 and PencilImageIndex = 1)
			results =
		else
		{
			if DiffMin <>
			{
				PencilImageString =
				loop, parse, PencilImage, -
					PencilImageString := PencilImageString . cell%a_loopfield%
				results := DiffMin . "/" . PencilImageString . "-"
			}
			else
				results =
			n := cell%PencilImageLoopfield%
			stringreplace, possible, possible, %n%,
		}
		if DeletedNumbers%PencilImageLoopfield% <>
			loop, parse, DeletedNumbers%PencilImageLoopfield%
				stringreplace, possible, possible, %a_loopfield%,
		loop, parse, PresetImage, -
			ifinstring, ConnectedCells%PencilImageLoopfield%, %a_loopfield%
			{
				n := cell%a_loopfield%
				stringreplace, possible, possible, %n%,
			}
		if possible <>
		{
			LastPossible := FirstIndex
			loop, parse, PencilImage, -
			{
				stringlen, possibleLen, possible
				if (possibleLen <= 2)
					break
				ifinstring, ConnectedCells%PencilImageLoopfield%, %a_loopfield%
				{
					n := cell%a_loopfield%
					stringreplace, possible, possible, %n%,
				}
			}
		}
		if possible <>
		{
			PencilImageString1 =
			loop, parse, PencilImage, -
				PencilImageString1 := PencilImageString1 . cell%a_loopfield%
			loop, parse, possible
			{
				if interrupt = 1
				{
					gui, 3:destroy
					CreateIndex = 0
					BackList := GuiToString() . "/" . BackList
					ForwardList =
					return
				}
				else if interrupt = 2
				{
					BackList := GuiToString() . "/" . BackList
					gosub back
					ForwardList =
					gosub create
					return
				}
				if SwitchAfterLoopIteration = 1
				{
					SwitchAfterLoopIteration = 0
					gosub switch2
				}
				PossLoopfield = %a_loopfield%
				fill(PencilImageLoopfield, PossLoopfield)
				ChangeConnectedCells = 0
				loop, parse, PencilImage, -
					ifinstring, ConnectedCells%PencilImageLoopfield%, %a_loopfield%
					if (cell%a_loopfield% = PossLoopfield)
					{
						fill(a_loopfield, 0)
						ChangeConnectedCells = 1
					}
				if ChangeConnectedCells = 1
				{
					gosub FillMinimumFirst
					gosub LeaveImage
				}
				examined += 1
				ChangePencilImage = 0
				gosub FillMinimumFirst
				if SolutionAtAll = 0
				{
					NoSolution += 1
					if (NoSolution/examined > 1/2)
						loop, parse, PencilImage, -
							if cell%a_loopfield% <> 0
							{
								fill(a_loopfield, 0)
								ChangePencilImage = 1
								gosub FillMinimumFirst
								if SolutionAtAll = 1
								{
									gosub LeaveImage
									gosub FillMinimumFirst
									break
								}
							}
				}
				if SolutionAtAll = 1
				{
					gosub FillMaximumFirst
					gosub LeaveImage
					if SecondSolutionIdentical = 1
					{
						CreateIndex = 4
						BackList := GuiToString() . "/" . BackList
						ForwardList =
SoundBeep, 480, 240
sleep 80
SoundBeep, 480, 240
sleep 80
SoundBeep, 720, 240
sleep 80
SoundBeep, 720, 240
sleep 80
SoundBeep, 800, 240
sleep 80
SoundBeep, 800, 240
sleep 80
SoundBeep, 720, 400
						guicontrol, 3:text, Gui3Text,
(
Loop %FirstIndex%, row %PencilImageLoopfieldL%, column %PencilImageLoopfieldR%
Examined positions: %examined%

Ready! Maybe you can improve the image by swapping %switch%:
Click on %switch% you want to swap.
)
						gui, 3:add, button, x+20, Save
						return
					}
					else
					{
						PencilImageString =
						loop, parse, PencilImage, -
							PencilImageString := PencilImageString . cell%a_loopfield%
						results := results . different . "/" . PencilImageString . "-"
					}
				}
				if (ChangeConnectedCells = 1 or ChangePencilImage = 1)
					loop, parse, PencilImage, -
					{
						stringmid, n, PencilImageString1, a_index, 1
						fill(a_loopfield, n)
					}
			}
			if results <>
			{
				sort, results, N D-
				loop, parse, results, -
				{
					NextResult = %a_loopfield%
					break
				}
				loop, parse, NextResult, /
					if (a_index = 1)
						DiffMin = %a_loopfield%
					else
						PencilImageString = %a_loopfield%
					loop, parse, PencilImage, -
					{
						stringmid, n, PencilImageString, a_index, 1
						fill(a_loopfield, n)
					}
				stringlen, len, NextResult
				stringtrimleft, results, results, len+1
				%DontRepeatString% := results
			}
		}
	}
}
return

3GuiClose:
wingetpos, guiX, guiY,,, A
if CreateIndex = 3
	interrupt = 1
else
{
	gui, 3:destroy
	CreateIndex = 0
}
return

3ButtonCancel:
wingetpos, guiX, guiY,,, A
if CreateIndex = 3
	interrupt = 2
else
{
	gui, 3:destroy
	CreateIndex = 0
}
return

3ButtonSave:
wingetpos, guiX, guiY,,, A
gui, 3:destroy
CreateIndex = 0
gosub SaveAs
return

LeaveImage:
loop, parse, cells, -
	ifnotinstring, image, %a_loopfield%
		fill(a_loopfield, 0)
return

;---- larger ---------------------------------------------------------------------------------

larger:
+::
NumpadAdd::
if PlusMinus < 6
{
	PlusMinus += 1
	gosub CellsSize
	gui, 1:show, w%wGui% h%wGui%
}
return

;---- smaller --------------------------------------------------------------------------------

smaller:
-::
NumpadSub::
if PlusMinus > -2
{
	PlusMinus -= 1
	gosub CellsSize
	gui, 1:show, w%wGui% h%wGui%
}
return

;---- switch between numbers and colors -------------------------------------------------------

switch:
if CreateIndex = 3
{
	SwitchAfterLoopIteration = 1
	return
}
switch2:
if switch = colors
{
	switch = numbers
	cBackground = %cBackground1%
	gui, 1:color, %cBackground1%
	cNumber = %cNumber1%
}
else
{
	switch = colors
	cBackground = %cBackground2%
	gui, 1:color, %cBackground2%
}
loop, parse, cells, -
{
	if cell%a_loopfield% <> 0
		fill(a_loopfield, cell%a_loopfield%)
	else loop, 9
		PencilMark(a_loopfield, a_index, PencilMark%a_loopfield%%a_index%)
}
BackList := GuiToString() . "/" . BackList
ForwardList =
return

;---- back -----------------------------------------------------------------------------------

pgup::
back:
if BackList <>
{
	loop, parse, BackList, /
	{
		if a_index = 1
		{
			NowOnGui = %a_loopfield%
			stringlen, len, a_loopfield
		}
		else if a_index = 2
		{
			StringToGui(a_loopfield)
			break
		}
	}
	stringtrimleft, BackList, BackList, %len%  ; trim first a_loopfield
	stringtrimleft, BackList, BackList, 1  ; trim slash
	ForwardList = %NowOnGui%/%ForwardList%
}
return

;---- forward --------------------------------------------------------------------------------

pgdn::
forward:
if ForwardList <>
{
	loop, parse, ForwardList, /
	{
		StringToGui(a_loopfield)
		NowOnGui = %a_loopfield%
		stringlen, len, a_loopfield
		break
	}
	stringtrimleft, ForwardList, ForwardList, %len%  ; trim first a_loopfield
	stringtrimleft, ForwardList, ForwardList, 1  ; trim slash
	BackList = %NowOnGui%/%BackList%
}
return

;---- set obvious pencil marks ---------------------------------------------------------------

SetPencilMarks:
loop, parse, cells, -
	if cell%a_loopfield% = 0
{
	PencilMarks = 123456789
	loop, parse, ConnectedCells%a_loopfield%, -
		if cell%a_loopfield% <> 0
	{
		n := cell%a_loopfield%
		stringreplace, PencilMarks, PencilMarks, %n%,
	}
	loop, 9
	{
		ifinstring, PencilMarks, %a_index%
			PencilMark(a_loopfield, a_index, 1)
		else
			PencilMark(a_loopfield, a_index, 0)
	}
}
BackList := GuiToString() . "/" . BackList
ForwardList =
return

;---- remove pencil marks --------------------------------------------------------------------

RemovePencilMarks:
loop, parse, cells, -
	loop, 9
		PencilMark(a_loopfield, a_index, 0)
BackList := GuiToString() . "/" . BackList
ForwardList =
return

;---- clear board ----------------------------------------------------------------------------

ClearBoard:
loop, parse, cells, -
	fill(a_loopfield, 0)
if switch = numbers
{
	if (cBackground <> cBackground1)
	{
		cBackground = %cBackground1%
		gui, 1:color, %cBackground1%
	}
	cNumber = %cNumber1%
}
else
{
	if (cBackground <> cBackground2)
	{
		cBackground = %cBackground2%
		gui, 1:color, %cBackground2%
	}
}
BackList := GuiToString() . "/" . BackList
ForwardList =
return

;---- find one -------------------------------------------------------------------------------

^pgdn::
FindOne:
text =
explain = 1
gosub GetPossibleNumbers
explain = 0
stringleft, p, WhatNext, 1
if p = x  ; no possible cell
{
	stringtrimleft, WhatNext, WhatNext, 1
	stringright, n, WhatNext, 1
	stringtrimright, u, WhatNext, 1
	loop, parse, unit%u%, -
		if cell%a_loopfield% = 0
	{
		stringleft, r, a_loopfield, 1
		stringright, c, a_loopfield, 1
		xm := pos%c%+wCell/2
		ym := pos%r%+wCell/2+hTitleMenu
		click %xm%, %ym%, 0
		highlight(r . c, "red")
		sleep 400
	}
	text = Number %n%# can't be set anywhere in unit %u%.
	loop, parse, unit%u%, -
		if explain%a_loopfield%%n% <>
			text := text . explain%a_loopfield%%n%
}
else if p = 0  ; no possible number
{
	stringmid, r, WhatNext, 2, 1
	stringmid, c, WhatNext, 3, 1
	xm := pos%c%+wCell/2
	ym := pos%r%+wCell/2+hTitleMenu
	click %xm%, %ym%, 0
	highlight(r . c, "red")
	text = This cell can't be filled.
	loop, 9
		if explain%r%%c%%a_index% <>
			text := text . explain%r%%c%%a_index%
}
else if p = 1  ; one possible number
{
	stringmid, r, WhatNext, 2, 1
	stringmid, c, WhatNext, 3, 1
	n := PossibleNumbers%r%%c%
	xm := pos%c%+wCell/2
	ym := pos%r%+wCell/2+hTitleMenu
	click %xm%, %ym%, 0
	fill(r . c, n)
	highlight(r . c, "green")
	loop, parse, ConnectedCells%r%%c%, -
		PencilMark(a_loopfield, n, 0)
	BackList := GuiToString() . "/" . BackList
	ForwardList =
	if explain%r%%c%%n% =
	{
		text = %n%# is the only possible number in this cell.
		loop, 9
			if explain%r%%c%%a_index% <>
				text := text . explain%r%%c%%a_index%
	}
	else
	{
		u := explain%r%%c%%n%
		text = This is the only possible cell for number %n%# in unit %u%.
		loop, parse, unit%u%, -
			if a_loopfield <> %r%%c%
			if explain%a_loopfield%%n% <>
				text := text . explain%a_loopfield%%n%
	}
}
else if p > 1  ; several possible numbers
{
	stringmid, r0, WhatNext, 2, 1  ; r and c are used by FillMinimumFirst. <---------
	stringmid, c0, WhatNext, 3, 1
	xm := pos%c0%+wCell/2
	ym := pos%r0%+wCell/2+hTitleMenu
	click %xm%, %ym%, 0
	ProvedNumbers =
	loop, parse, PossibleNumbers%r0%%c0%
	{
		fill(r0 . c0, a_loopfield)
		gosub FillMinimumFirst  ; <---------
		if SolutionAtAll = 1
			ProvedNumbers = %ProvedNumbers%%a_loopfield%
		BackList := GuiToString() . "/" . BackList
		gosub back
	}
	stringlen, p, ProvedNumbers
	if p = 0
	{
		highlight(r0 . c0, "red")
		text := "This cell could be filled with"
		loop, parse, PossibleNumbersAll%r0%%c0%
			text = %text% %a_loopfield%# or
		stringtrimright, text, text, 3
		text := text . " but there is no solution with any of them."
	}
	else
	{
		if p = 1
		{
			fill(r0 . c0, ProvedNumbers)
			highlight(r0 . c0, "green")
			loop, parse, ConnectedCells%r0%%c0%, -
				PencilMark(a_loopfield, ProvedNumbers, 0)
			BackList := GuiToString() . "/" . BackList
		}
		else
			highlight(r0 . c0, "blue")
		text := "Possible numbers:"
		loop, parse, PossibleNumbersAll%r0%%c0%
			text = %text% %a_loopfield%#,
		stringtrimright, text, text, 1
		text := text . ".There is a solution with:"
		loop, parse, ProvedNumbers
			text = %text% %a_loopfield%#,
		stringtrimright, text, text, 1
		text := text . "."
	}
	ForwardList =
}
if text <>
{
	loop, parse, cells, -
		if highlight%a_loopfield% <> green
			ifinstring, text, %a_loopfield%<red>
				highlight(a_loopfield, "red")
			else ifinstring, text, %a_loopfield%<blue>
				highlight(a_loopfield, "blue")
	stringreplace, text, text, <red>,, all
	stringreplace, text, text, <blue>,, all
	if switch = colors
	{
		loop, 9
		{
			color := color%a_index%name
			stringreplace, text, text, number %a_index%#, %color%, all
			stringreplace, text, text, %a_index%#, %color%, all
		}
		stringreplace, text, text, number, color
	}
	else
		stringreplace, text, text, #,, all
	text2 =
	loop, parse, text, .
		if a_loopfield <>
		ifnotinstring, text2, %a_loopfield%
			text2 = %text2%%a_loopfield%.
	text =
	loop, parse, text2, .
		if a_loopfield <>
	{
		stringleft, x, a_loopfield, 1
		if (x = "`n")
			text = %text%%a_loopfield%.
		else
		{
			stringupper, x, x
			stringtrimleft, line, a_loopfield, 1
			text = %text%`n%x%%line%.
		}
	}
	stringtrimleft, text, text, 1
	loop, 27
		ifinstring, text, RelCell %a_index%
		{
			u = %a_index%
			loop, 9
			{
				r = %a_index%
				loop, 9
				{
					c = %a_index%
					loop, parse, unit%u%, -
						if a_loopfield = %r%%c%
						{
							stringreplace, text, text, RelCell %u% %r%%c%, cell %a_index%, all
							break
						}
				}
			}
		}
	loop, 9
		stringreplace, text, text, AbsCell %a_index%, row %a_index% column%a_space%, all
	loop, 9
	{
		u := a_index+9
		stringreplace, text, text, unit %u%, column %a_index%, all
		u := a_index+18
		stringreplace, text, text, unit %u%, block %a_index%, all
	}
	loop, 9
		stringreplace, text, text, unit %a_index%, row %a_index%, all
	tooltip %text%
}
return

;---- find all -------------------------------------------------------------------------------

FindAll:
gosub FillMinimumFirst
ForwardList =
if SolutionAtAll = 0
	msgbox, There is no solution!
else if SolutionAtAll = 1
{
	BackList := GuiToString() . "/" . BackList
	sleep 1000
	gosub FillMaximumFirst
	if SecondSolutionIdentical = 1
		msgbox, There is only one solution!
	else
	{
		BackList := GuiToString() . "/" . BackList
		msgbox, There is a second solution!
	}
}
return

;---- help -----------------------------------------------------------------------------------

help:
gui, 4:destroy
gui, 4:font, s12
gui, 4:add, text,, Set %switch% with the left mouse button or the number keys.
if switch = colors
{
	gui, 4:add, text, xs, 1 = %color1name%
	gui, 4:add, text, xp+120, 2 = %color2name%
	gui, 4:add, text, xp+120, 3 = %color3name%
	gui, 4:add, text, xp+120, 4 = %color4name%
	gui, 4:add, text, xp+120, 5 = %color5name%
	gui, 4:add, text, xs, 6 = %color6name%
	gui, 4:add, text, xp+120, 7 = %color7name%
	gui, 4:add, text, xp+120, 8 = %color8name%
	gui, 4:add, text, xp+120, 9 = %color9name%
	pos = m
}
else
	pos = 0
gui, 4:add, text, xs y+%pos%,
(
Delete %switch% with the left mouse button or the spacebar.
Set/delete pencil marks with the right mouse button or with Shift+number key.
The arrow keys also move the mouse cursor.

If you run this program with Wine in Linux, colors will probably appear as = or g.
To fix this, copy webdings.ttf from the Windows fonts folder (C:\Windows\Fonts)
to the Linux truetype folder (/usr/share/fonts/truetype - open as administrator!).
)
gui, 4:show, x10 y10, Help
return

4GuiClose:
gui, 4:destroy
return

;_____________________________________________________________________________________________
;________ hotkey variants for the swap gui ___________________________________________________


#ifwinactive Create ahk_class AutoHotkeyGUI
1::
2::
3::
4::
5::
6::
7::
8::
9::
numpad1::
numpad2::
numpad3::
numpad4::
numpad5::
numpad6::
numpad7::
numpad8::
numpad9::
stringright, n, a_thislabel, 1
gosub swap
return

;_____________________________________________________________________________________________
;________ other subroutines __________________________________________________________________


CellsSize:
parameters = wCell-sNumber-sColor-sHighlight-wPencilMark-sPencilNumber-sPencilColor
loop, parse, parameters, -
	%a_loopfield% := %a_loopfield%1 + (PlusMinus * %a_loopfield%1)//4
wLine := PlusMinus//2+2
loop, 9
{
	pos%a_index% := (a_index-1)*(wCell+wLine)  ; position of column/row
	if (a_index > 6)
		pos%a_index% += 2*wLine
	else if (a_index > 3)
		pos%a_index% += wLine
}
wGui := pos9+wCell
loop, parse, cells, -
{
	stringleft, r, a_loopfield, 1
	stringright, c, a_loopfield, 1
	x := pos%c%
	y := pos%r%
	wGridCell := pos4-pos3
	sSquare := wGridCell*4//5
	gui, 1:font, s%sSquare% c888888, Webdings
	guicontrol, 1:font, GridCell%a_loopfield%
	guicontrol, 1:movedraw, GridCell%a_loopfield%, x%x% y%y% w%wGridCell% h%wGridCell%
	guicontrol, 1:movedraw, highlight%a_loopfield%, x%x% y%y% w%wCell% h%wCell%
	guicontrol, 1:movedraw, cell%a_loopfield%, x%x% y%y% w%wCell% h%wCell%
	loop, 3
		posP%a_index% := (wCell-3*wPencilMark)//2 + (a_index-1)*wPencilMark  ; position of pencil mark column/row
	x1 := x+posP1
	y1 := y+posP1
	x2 := x+posP2
	y2 := y+posP1
	x3 := x+posP3
	y3 := y+posP1
	x4 := x+posP1
	y4 := y+posP2
	x5 := x+posP2
	y5 := y+posP2
	x6 := x+posP3
	y6 := y+posP2
	x7 := x+posP1
	y7 := y+posP3
	x8 := x+posP2
	y8 := y+posP3
	x9 := x+posP3
	y9 := y+posP3
	loop, 9
	{
		x := x%a_index%
		y := y%a_index%
		guicontrol, 1:movedraw, PencilMark%a_loopfield%%a_index%, x%x% y%y% w%wPencilMark% h%wPencilMark%
	}
	if cell%a_loopfield% <> 0
		fill(a_loopfield, cell%a_loopfield%)
	else loop, 9
		PencilMark(a_loopfield, a_index, PencilMark%a_loopfield%%a_index%)
	if highlight%a_loopfield% <> 0
		highlight(a_loopfield, highlight%a_loopfield%)
}
return

;---------------------------------------------------------------------------------------------

MouseGetNearestCell:
mousegetpos, xm, ym
rm = 1
cm = 1
loop, 9
	if a_index > 1
{
	if abs(xm-(pos%a_index%+wCell/2)) < abs(xm-(pos%cm%+wCell/2))
		cm = %a_index%
	if abs(ym-(pos%a_index%+wCell/2+hTitleMenu)) < abs(ym-(pos%rm%+wCell/2+hTitleMenu))
		rm = %a_index%
}
xcenter := pos%cm%+wCell/2
ycenter := pos%rm%+wCell/2+hTitleMenu
return

;---------------------------------------------------------------------------------------------

fill(rc, n)
{
	global
	if (cell%rc% <> n)
		tooltip
	if (JustHighlighted <> 1 and cell%rc% <> n)
		loop, parse, cells, -
			highlight(a_loopfield, 0)
	cell%rc% = %n%
	if CreateIndex = 3
	ifnotinstring, image, %rc%
		return
	if DontDisplay = 1
		return
	loop, 9
		PencilMark(rc, a_index, 0)
	if n = 0
	{
		if (LastFill%rc% <> 0)
		{
			guicontrol, 1:text, cell%rc%
			LastFill%rc% = 0
		}
	}
	else
	{
		if switch = colors
		{
			if (LastFill%rc% <> color%n%value . sColor . "Webdings" . "=" or JustHighlighted = 1)
			{
				color := color%n%value
				gui, 1:font, c%color% s%sColor%, Webdings
				guicontrol, 1:font, cell%rc%
				guicontrol, 1:text, cell%rc%, =
				LastFill%rc% := color%n%value . sColor . "Webdings" . "="
			}
		}
		else
		{
			if (LastFill%rc% <> cNumber . sNumber . "Ubuntu Arial" . n or JustHighlighted = 1)
			{
				gui, 1:font, c%cNumber% s%sNumber%
				gui, 1:font,, Ubuntu
				gui, 1:font,, Arial
				guicontrol, 1:font, cell%rc%
				guicontrol, 1:text, cell%rc%, %n%
				LastFill%rc% := cNumber . sNumber . "Ubuntu Arial" . n
			}
		}
	}
}

;---------------------------------------------------------------------------------------------

highlight(rc, color)
{
	global
	highlight%rc% = %color%
	if highlight%rc% = 0
	{
		if LastHighlight%rc% <> 0
		{
			guicontrol, 1:text, highlight%rc%
			LastHighlight%rc% = 0
			JustHighlighted = 1
			if cell%rc% <> 0
				fill(rc, cell%rc%)
			else loop, 9
				PencilMark(rc, a_index, PencilMark%rc%%a_index%)
			JustHighlighted = 0
		}
	}
	else
	{
		if (LastHighlight%rc% <> highlight%rc% . sHighlight)
		{
			if highlight%rc% = red
				RealColor = 0xFFCCCC
			else if highlight%rc% = green
				RealColor = 0xCCFFCC
			else if highlight%rc% = blue
				RealColor = 0xCCCCFF
			gui, 1:font, c%RealColor% s%sHighlight%, Webdings
			guicontrol, 1:font, highlight%rc%
			guicontrol, 1:text, highlight%rc%, g
			LastHighlight%rc% := highlight%rc% . sHighlight
			JustHighlighted = 1
			if cell%rc% <> 0
				fill(rc, cell%rc%)
			else loop, 9
				PencilMark(rc, a_index, PencilMark%rc%%a_index%)
			JustHighlighted = 0
		}
	}
}

;---------------------------------------------------------------------------------------------

PencilMark(rc, n, value)
{
	global
	PencilMark%rc%%n% = %value%
	if value = 0
	{
		if (LastPencilMark%rc%%n% <> 0)
		{
			guicontrol, 1:text, PencilMark%rc%%n%
			LastPencilMark%rc%%n% = 0
		}
	}
	else if value = 1
	{
		if switch = colors
		{
			if (LastPencilMark%rc%%n% <> color%n%value . sPencilColor . "Webdings" . "=" or JustHighlighted = 1)
			{
				color := color%n%value
				gui, 1:font, c%color% s%sPencilColor%, Webdings
				guicontrol, 1:font, PencilMark%rc%%n%
				guicontrol, 1:text, PencilMark%rc%%n%, =
				LastPencilMark%rc%%n% := color%n%value . sPencilColor . "Webdings" . "="
			}
		}
		else
		{
			if (LastPencilMark%rc%%n% <> cNumber . sPencilNumber . "Ubuntu Arial" . n or JustHighlighted = 1)
			{
				gui, 1:font, c%cNumber% s%sPencilNumber%
				gui, 1:font,, Ubuntu
				gui, 1:font,, Arial
				guicontrol, 1:font, PencilMark%rc%%n%
				guicontrol, 1:text, PencilMark%rc%%n%, %n%
				LastPencilMark%rc%%n% := cNumber . sPencilNumber . "Ubuntu Arial" . n
			}
		}
	}
}

;---------------------------------------------------------------------------------------------

GuiToString()
{
	global
	string = %switch%-%cBackground%-%cNumber%
	StringIndex = 0
	loop, parse, cells, -
		if (cell%a_loopfield% <> 0)
	{
		string := string . "-" . a_loopfield . cell%a_loopfield%
		StringIndex += 1
		if StringIndex = 10
		{
			string = %string%`n
			StringIndex = 0
		}
	}
	loop, parse, cells, -
		if (cell%a_loopfield% = 0)
			loop, 9
				if (PencilMark%a_loopfield%%a_index% = 1)
	{
		string := string . "-" . a_loopfield . "p" . a_index
		StringIndex += 1
		if StringIndex = 10
		{
			string = %string%`n
			StringIndex = 0
		}
	}
	return string
}

;---------------------------------------------------------------------------------------------

StringToGui(string)
{
	global
	loop, parse, cells, -
	{
		cell%a_loopfield%new = 0
		loop, 9
			PencilMark%a_loopfield%%a_index%new = 0
	}
	loop, parse, string, -, `n `r
	{
		if a_index = 1
			switch = %a_loopfield%
		else if a_index = 2
		{
			if (a_loopfield <> cBackground)
				gui, 1:color, %a_loopfield%
			cBackground = %a_loopfield%
		}
		else if a_index = 3
			cNumber = %a_loopfield%
		else
		{
			stringleft, rc, a_loopfield, 2
			stringright, n, a_loopfield, 1
			ifnotinstring, a_loopfield, p
				cell%rc%new = %n%
			else
				PencilMark%rc%%n%new = 1
		}
	}
	loop, parse, cells, -
	{
		if (cell%a_loopfield%new <> 0)
			fill(a_loopfield, cell%a_loopfield%new)
		else
		{
			if cell%a_loopfield% <> 0
				fill(a_loopfield, 0)
			loop, 9
				PencilMark(a_loopfield, a_index, PencilMark%a_loopfield%%a_index%new)
		}
	}
}

;---------------------------------------------------------------------------------------------

GetPossibleNumbers:
loop, parse, cells, -
	if cell%a_loopfield% = 0
		PossibleNumbers%a_loopfield% = 123456789
if explain = 1
	loop, parse, cells, -
		loop, 9
			explain%a_loopfield%%a_index% =
; explainRCN will be a text string, explaining why N can't be set in cell RC,
; or the index of a unit where N can only be set in cell RC.
;---- Get possible numbers for every cell. ----
loop, parse, cells, -
{
	rc = %a_loopfield%
	if cell%rc% = 0
	{
		loop, parse, ConnectedCells%rc%, -
			if cell%a_loopfield% <> 0
		{
			n := cell%a_loopfield%
			stringreplace, PossibleNumbers%rc%, PossibleNumbers%rc%, %n%,
		}
		if (CreateIndex = 2 or CreateIndex = 3)
		if DeletedNumbers%rc% <>
			loop, parse, DeletedNumbers%rc%
				stringreplace, PossibleNumbers%rc%, PossibleNumbers%rc%, %a_loopfield%,
		PossibleNumbersRev%rc% =
		loop, parse, PossibleNumbers%rc%
			PossibleNumbersRev%rc% := a_loopfield . PossibleNumbersRev%rc%
		PossibleNumbersAll%rc% := PossibleNumbers%rc%
		stringlen, p, PossibleNumbers%rc%
		if (p = 0 or p = 1 and GetAll <> 1)
		{
			WhatNext = %p%%rc%
			return
		}
	}
}
;---- Get possible cells for every number in every unit. ----
loop, 2
	loop, 27  ; units
{
	u = %a_index%
	loop, 9  ; numbers
	{
		n = %a_index%
		i = 0
		PossibleCells%u%%n% =
		loop, parse, unit%u%, -
		{
			if cell%a_loopfield% = %n%
			{
				i = 1
				break
			}
			else if cell%a_loopfield% = 0
			{
				ifinstring, PossibleNumbers%a_loopfield%, %n%
					PossibleCells%u%%n% := PossibleCells%u%%n% . a_loopfield . "-"
			}
		}
		stringlen, p, PossibleCells%u%%n%
		if (i = 0 and p = 0)  ; Number n is not and can not be set in unit u.
		{
			WhatNext = x%u%%n%
			return
		}
		else if p = 3  ; In unit u number n must be ...
		{
			stringleft, rc, PossibleCells%u%%n%, 2  ; ... in cell rc.
			PossibleNumbers%rc% = %n%
			if explain = 1
				explain%rc%%n% = %u%
			if GetAll <> 1
			{
				WhatNext = 1%rc%
				return
			}
		}
		else
		{
			;---- If there are two numbers with the same two possible cells
			; then these two numbers are the only possible numbers in these two cells. ----
			if p = 6
				loop, % n-1
					if (PossibleCells%u%%a_index% = PossibleCells%u%%n%)
			{
				n2 = %a_index%
				loop, parse, PossibleCells%u%%n%, -
					if a_loopfield <>
				{
					rc = %a_loopfield%
					if explain = 1
						loop, parse, PossibleNumbers%rc%
							if (a_loopfield <> n and a_loopfield <> n2)
					{
						n3 = %a_loopfield%
						stringleft, rc1, PossibleCells%u%%n%, 2
						stringmid, rc2, PossibleCells%u%%n%, 4, 2
						explain%rc%%n3% = %n3%# can't be in AbsCell %rc%<red> because in unit %u% %n2%# and %n%# must be in RelCell %u% %rc1%<blue> and RelCell %u% %rc2%<blue>.
						loop, parse, unit%u%, -
						{
							if explain%a_loopfield%%n% <>
								explain%rc%%n3% := explain%rc%%n3% . explain%a_loopfield%%n%
							if explain%a_loopfield%%n2% <>
								explain%rc%%n3% := explain%rc%%n3% . explain%a_loopfield%%n2%
						}
					}
					PossibleNumbers%rc% = %n2%%n%
					PossibleNumbersRev%rc% = %n%%n2%
				}
				break
			}
			;---- If number n has two or three possible cells in unit u and all of them are also
			; in another unit then number n can't be set anywhere else in the other unit
			; because otherwise number n couldn't be set anywhere in unit u. ----
			if (p = 6 or p = 9)
				loop, 27
			{
				u2 = %a_index%
				if u2 <> %u%
				{
					AllInU2 = 1
					loop, parse, PossibleCells%u%%n%, -
						if a_loopfield <>
						ifnotinstring, unit%u2%, %a_loopfield%
					{
						AllInU2 = 0
						break
					}
					if AllInU2 = 1
					{
						loop, parse, unit%u2%, -
							if cell%a_loopfield% = 0
							ifnotinstring, PossibleCells%u%%n%, %a_loopfield%
							ifinstring, PossibleNumbers%a_loopfield%, %n%
						{
							rc = %a_loopfield%
							if explain = 1
							{
								string = %n%# can't be in AbsCell %rc%<red> because in unit %u% it must be in
								loop, parse, PossibleCells%u%%n%, -
									if a_loopfield <>
										string = %string% RelCell %u% %a_loopfield%<blue> or
								stringtrimright, string, string, 3
								explain%rc%%n% = %string%.
								loop, parse, unit%u%, -
									if explain%a_loopfield%%n% <>
										explain%rc%%n% := explain%rc%%n% . explain%a_loopfield%%n%
							}
							stringreplace, PossibleNumbers%rc%, PossibleNumbers%rc%, %n%,
							stringreplace, PossibleNumbersRev%rc%, PossibleNumbersRev%rc%, %n%,
							stringlen, pn, PossibleNumbers%rc%
							if (pn = 0 or pn = 1 and GetAll <> 1)
							{
								WhatNext = %pn%%rc%
								return
							}
						}
						break
					}
				}
			}
			;---- "skyscraper" ----
			if (p = 6 and (explain = 1 or GetAll = 1))
			{
				stringleft, A, PossibleCells%u%%n%, 2
				stringmid, B, PossibleCells%u%%n%, 4, 2
				loop, % u-1  ; iterations u+1 to 27 would get earlier PossibleCells
				{
					u2 = %a_index%
					stringlen, p2, PossibleCells%u2%%n%
					stringleft, C, PossibleCells%u2%%n%, 2
					stringmid, D, PossibleCells%u2%%n%, 4, 2
					if (p2 = 6 and A <> C and A <> D and B <> C and B <> D)
					{
						positions = %A%%B%%C%%D%/%B%%A%%C%%D%/%A%%B%%D%%C%/%B%%A%%D%%C%
						loop, parse, positions, /
						{
							stringleft, uCell1, a_loopfield, 2
							stringmid, uCell2, a_loopfield, 3, 2
							stringmid, u2Cell1, a_loopfield, 5, 2
							stringright, u2Cell2, a_loopfield, 2
							ifinstring, ConnectedCells%uCell1%, %u2Cell1%
							ifnotinstring, ConnectedCells%uCell2%, %u2Cell1%
							ifnotinstring, ConnectedCells%u2Cell2%, %uCell1%
							{
								loop, parse, ConnectedCells%uCell2%, -
									if cell%a_loopfield% = 0
									ifinstring, ConnectedCells%u2Cell2%, %a_loopfield%
									ifinstring, PossibleNumbers%a_loopfield%, %n%
									{
										rc = %a_loopfield%
										if explain = 1
										{
											explain%rc%%n% =
(
%n%# can't be in AbsCell %rc%<red> because
- if in unit %u2% it is in RelCell %u2% %u2Cell1%<blue> then in unit %u% it must be in RelCell %u% %uCell2%<blue>
- if in unit %u% it is in RelCell %u% %uCell1%<blue> then in unit %u2% it must be in RelCell %u2% %u2Cell2%<blue>.
Either way %n%# can't be in AbsCell %rc% because AbsCell %rc% is connected with both AbsCell %uCell2% and AbsCell %u2Cell2%.
)
											loop, parse, unit%u%, -
												ifnotinstring, PossibleCells%u%%n%, %a_loopfield%
												if explain%a_loopfield%%n% <>
													explain%rc%%n% := explain%rc%%n% . explain%a_loopfield%%n%
											loop, parse, unit%u2%, -
												ifnotinstring, PossibleCells%u2%%n%, %a_loopfield%
												if explain%a_loopfield%%n% <>
													explain%rc%%n% := explain%rc%%n% . explain%a_loopfield%%n%
										}
										stringreplace, PossibleNumbers%rc%, PossibleNumbers%rc%, %n%,
										stringreplace, PossibleNumbersRev%rc%, PossibleNumbersRev%rc%, %n%,
										stringlen, p, PossibleNumbers%rc%
										if (p = 0 or p = 1 and GetAll <> 1)
										{
											WhatNext = %p%%rc%
											return
										}
									}
							}
						}
					}
				}
			}
		}
	}
}
ParseWhat = %cells%
if CreateIndex = 2
	loop, parse, image, -
		if cell%a_loopfield% = 0
		{
			ParseWhat = %image%
			break
; FillMinimumFirst in create needs less loops if cells with pencil marks are filled up first.
		}
WhatNext =
loop, parse, ParseWhat, -
	if cell%a_loopfield% = 0
	{
		stringlen, p, PossibleNumbers%a_loopfield%
		WhatNext = %WhatNext%%p%%a_loopfield%-
	}
sort, WhatNext, d-
return

;---------------------------------------------------------------------------------------------

FillMinimumFirst:
filled =
NoChoice =
loop, parse, cells, -
{
	FillMinimumFirst%a_loopfield% := cell%a_loopfield%
	minimum%a_loopfield% = 1
}
loop, 2000
{
	gosub GetPossibleNumbers
	if WhatNext =
	{
		SolutionAtAll = 1
		loop, parse, cells, -
			FirstSolution%a_loopfield% := cell%a_loopfield%
		return
	}
	stringleft, p, WhatNext, 1
	if (p = "x" or p = 0)
	{
		if filled =
		{
			SolutionAtAll = 0
			return
		}
		stringtrimright, filled, filled, 1
		stringright, rc, filled, 2
		minimum%rc% := cell%rc%+1
		fill(rc, 0)
		stringtrimright, filled, filled, 2
	}
	else if p = 1
	{
		stringmid, rc, WhatNext, 2, 2
		if (PossibleNumbers%rc% < minimum%rc%)
		{
			if filled =
			{
				SolutionAtAll = 0
				return
			}
			minimum%rc% = 1
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			minimum%rc% := cell%rc%+1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
		else
		{
			fill(rc, PossibleNumbers%rc%)
			filled = %filled%%rc%-
			ifnotinstring, NoChoice, %rc%
				NoChoice = %NoChoice%%rc%-
			if (StopAt = 1 and rc = TryOmit and filled = NoChoice)
				return
		}
	}
	else if p > 1
	{
		stringmid, rc, WhatNext, 2, 2
		CouldFill = 0
		loop, parse, PossibleNumbers%rc%
		{
			if (a_loopfield < minimum%rc%)
				continue
			fill(rc, a_loopfield)
			filled = %filled%%rc%-
			stringreplace, NoChoice, NoChoice, %rc%-,
			CouldFill = 1
			break
		}
		if CouldFill = 0
		{
			if filled =
			{
				SolutionAtAll = 0
				return
			}
			minimum%rc% = 1
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			minimum%rc% := cell%rc%+1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
	}
}
return

;---------------------------------------------------------------------------------------------

FillMaximumFirst:
filled =
loop, parse, cells, -
{
	fill(a_loopfield, FillMinimumFirst%a_loopfield%)
	maximum%a_loopfield% = 9
}
loop, 2000
{
	gosub GetPossibleNumbers
	if WhatNext =
	{
		SecondSolutionIdentical = 1
		different = 0
		loop, parse, cells, -
			if (cell%a_loopfield% <> FirstSolution%a_loopfield%)
		{
			SecondSolutionIdentical = 0
			different += 1
		}
		return
	}
	stringleft, p, WhatNext, 1
	if (p = "x" or p = 0)
	{
		stringtrimright, filled, filled, 1
		stringright, rc, filled, 2
		maximum%rc% := cell%rc%-1
		fill(rc, 0)
		stringtrimright, filled, filled, 2
	}
	else if p = 1
	{
		stringmid, rc, WhatNext, 2, 2
		if (PossibleNumbers%rc% > maximum%rc%)
		{
			maximum%rc% = 9
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			maximum%rc% := cell%rc%-1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
		else
		{
			fill(rc, PossibleNumbers%rc%)
			filled = %filled%%rc%-
		}
	}
	else if p > 1
	{
		stringmid, rc, WhatNext, 2, 2
		CouldFill = 0
		loop, parse, PossibleNumbersRev%rc%
		{
			if (a_loopfield > maximum%rc%)
				continue
			fill(rc, a_loopfield)
			filled = %filled%%rc%-
			CouldFill = 1
			break
		}
		if CouldFill = 0
		{
			maximum%rc% = 9
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			maximum%rc% := cell%rc%-1
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
	}
}
return

;---------------------------------------------------------------------------------------------

FillRandom:
filled =
NoChoice =
loop, parse, cells, -
	remaining%a_loopfield% = 123456789
loop, 2000
{
	gosub GetPossibleNumbers
	if WhatNext =
		return
	stringleft, p, WhatNext, 1
	if (p = "x" or p = 0)
	{
		stringtrimright, filled, filled, 1
		stringright, rc, filled, 2
		cellRC := cell%rc%
		stringreplace, remaining%rc%, remaining%rc%, %cellRC%,
		fill(rc, 0)
		stringtrimright, filled, filled, 2
	}
	else if p = 1
	{
		stringmid, rc, WhatNext, 2, 2
		PossibleNumbersRC := PossibleNumbers%rc%
		ifnotinstring, remaining%rc%, %PossibleNumbersRC%
		{
			remaining%rc% = 123456789
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			cellRC := cell%rc%
			stringreplace, remaining%rc%, remaining%rc%, %cellRC%,
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
		else
		{
			fill(rc, PossibleNumbers%rc%)
			filled = %filled%%rc%-
			ifnotinstring, NoChoice, %rc%
				NoChoice = %NoChoice%%rc%-
		}
	}
	else if p > 1
	{
		stringmid, rc, WhatNext, 2, 2
		CouldFill = 0
		PossibleNumbersRC =
		loop, parse, PossibleNumbers%rc%
			PossibleNumbersRC = %PossibleNumbersRC%%a_loopfield%-
		stringtrimright, PossibleNumbersRC, PossibleNumbersRC, 1
		sort, PossibleNumbersRC, random d-
		loop, parse, PossibleNumbersRC, -
		{
			ifnotinstring, remaining%rc%, %a_loopfield%
				continue
			fill(rc, a_loopfield)
			filled = %filled%%rc%-
			stringreplace, NoChoice, NoChoice, %rc%-,
			CouldFill = 1
			break
		}
		if CouldFill = 0
		{
			remaining%rc% = 123456789
			stringtrimright, filled, filled, 1
			stringright, rc, filled, 2
			cellRC := cell%rc%
			stringreplace, remaining%rc%, remaining%rc%, %cellRC%,
			fill(rc, 0)
			stringtrimright, filled, filled, 2
		}
	}
}
return
