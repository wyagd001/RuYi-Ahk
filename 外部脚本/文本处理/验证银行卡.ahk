;|2.6|2024.05.12|1599
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?style=2&f=76&t=15955
; https://en.wikipedia.org/wiki/Luhn_algorithm
;correct_card_number := [7, 9, 9, 2, 7, 3, 9, 8, 7, 1, 3] ; valid
;false_card_number   := [7, 9, 9, 2, 7, 3, 9, 8, 7, 1, 4] ; not valid
;MsgBox, % luhn_checksum(correct_card_number) ;"`n" luhn_checksum(false_card_number)
#SingleInstance force
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}
fyText := luhn_checksum(CandySel)
GuiText2(fyText?"有效":"无效", "验证银行卡有效性", CandySel, "Verify")
return

Verify:
Gui, GuiText2: Submit, NoHide
if myedit1
{
	fyText := luhn_checksum(Trim(myedit1))
	;msgbox % myedit1
	GuiControl,, myedit2, % fyText?"有效":"无效"
}
return


GuiText2(Gtext2, Title:="", Gtext1:="45", Label:="", w:=300, l:=20)
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

;msgbox % luhn_checksum(6222022303000753968)
;--------- Alternate check
;~ res := "i`tvalid`tnum`n"
;~ Loop, 10
;~ {
    ;~ arr := [7, 9, 9, 2, 7, 3, 9, 8, 7, 1, Mod(A_Index, 10)]
    ;~ res .= A_Index "`t" luhn_checksum(arr) "`t"
    ;~ for i, val in arr
        ;~ res .= val
    ;~ res .= "`n"
;~ }
;~ MsgBox, % res
;---------
return

luhn_checksum(card_number){
		if !IsObject(card_number) 
			card_number := StrSplit(card_number)
    len := card_number.Length()
    sum := 0
    Loop, % len - 1 {
        val := card_number[len - A_Index]
        if (Mod(A_Index, 2) = 1) { ; Double every second digit, from the rightmost
            val *= 2
            val := val > 9 ? val - 9 : val
        }
        sum += val ; Sum all the individual digits
    }
    ; If the sum is a multiple of 10, the account number is possibly valid.
    ;msgbox % sum "-" card_number[len] "-" Mod(sum + card_number[len], 10)
    return Mod(sum + card_number[len], 10) = 0 ? true : false
}
