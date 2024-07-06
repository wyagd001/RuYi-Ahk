;|2.0|2023.07.01|1631
CandySel := A_Args[1]
; ===============================================================================================================================
; AHK Version ...: AHK_L 1.1.20.03 x64 Unicode
; Win Version ...: Windows 7 Professional x64 SP1
; Description ...: Convert Text to:
;                  Char / Decimal / Octal / Hexadecimal / Binary
; Version .......: v0.2
; Modified ......: 2015.03.22-1732
; Author ........: jNizM
; Licence .......: Unlicense (http://unlicense.org/)
; ===============================================================================================================================
;@Ahk2Exe-SetName TextConverter
;@Ahk2Exe-SetDescription TextConverter
;@Ahk2Exe-SetVersion v0.2
;@Ahk2Exe-SetCopyright Copyright (c) 2013-2015`, jNizM
;@Ahk2Exe-SetOrigFilename TextConverter.ahk
; ===============================================================================================================================

; GLOBAL SETTINGS ===============================================================================================================

#Warn
#NoEnv
#SingleInstance Force

global name        := "TextConverter"
global version     := "v0.2"

; SCRIPT ========================================================================================================================

Gui, Main: +LabelMain
Gui, Main: Margin, 10, 10
Gui, Main: Font, s9, Courier New

Gui, Main: Add, Text, xm ym w80 h22 0x202, Text
Gui, Main: Add, Edit, x+10 ym w390 vTextTo gCONVERT, % CandySel
Gui, Main: Add, Text, xm y+10 w483 h1 0x10

Gui, Main: Add, Text, xm y+10 w80 h22 0x202, % "Char"
Gui, Main: Add, Edit, x+10 yp w390 0x0800 vCHAR
Gui, Main: Add, Text, xm y+6 w80 h22 0x202, % "Decimal"
Gui, Main: Add, Edit, x+10 yp w390 0x0800 vDEC
Gui, Main: Add, Text, xm y+6 w80 h22 0x202, % "Octal"
Gui, Main: Add, Edit, x+10 yp w390 0x0800 vOCT
Gui, Main: Add, Text, xm y+6 w80 h22 0x202, % "Hexadecimal"
Gui, Main: Add, Edit, x+10 yp w390 0x0800 vHEX
Gui, Main: Add, Text, xm y+6 w80 h22 0x202, % "Binary"
Gui, Main: Add, Edit, x+10 yp w390 0x0800 vBIN

Gui, Main: Add, Text, xm y+10 w483 h1 0x10

Gui, Main: Add, Text, xm y+10 w80 h22 0x202, % "Text Length"
Gui, Main: Add, Edit, x+10 yp w40 0x0800 vTXTL

Gui, Main: Add, Button, x+10 yp h23 gGUIChild, % "Chr()"

Gui, Main: Font, cSilver,
Gui, Main: Add, Text, x+10 yp w282 h22 0x202, % "made with " Chr(9829) " and AHK 2013-" A_YYYY ", jNizM"

Gui, Main: Show, AutoSize, % name " " version
Gui, Main: +LastFound
WinSet, Redraw
if CandySel
	gosub CONVERT
return

CONVERT:
    Gui Main: Default
    Gui, Submit, NoHide
    CTCHR := CTDEC := CTOCT := CTHEX := CTBIN := ""
    loop % Lenght := StrLen(TextTo)
    {
        CCHAR := SubStr(TextTo, A_Index, 1)
        CTASC := Asc(CCHAR)
        CTCHR .= "Chr(" CTASC ")"
        CTDEC .= CTASC " "
        CTOCT .= ConvertBase(10, 8, CTASC) " "          ; or  Format("{1:o}", CTASC)
        CTHEX .= "0x" ConvertBase(10, 16, CTASC) " "    ; or  Format("{1:#x}", CTASC)
        CTBIN .= ConvertBase(10, 2, CTASC) " "
    }
    GuiControl,, TXTL, % Lenght
    GuiControl,, CHAR, % CTCHR
    GuiControl,, DEC,  % CTDEC
    GuiControl,, OCT,  % CTOCT
    GuiControl,, HEX,  % CTHEX
    GuiControl,, BIN,  % CTBIN
return

GUIChild:
    Gui, Main: +0x8000000
    Gui, Child: New, +e0x80 -0x20000 +LabelChild +OwnerMain
    Gui, Child: Margin, 10, 10
    Gui, Child: Font, s9, Courier New
    Gui, Child: Add, Text, xm ym w80 h22 0x200, % "Dec / Hex"
    Gui, Child: Add, Edit, x+5 ym w100 gTOCHAR vVarIn
    Gui, Child: Add, Text, xm y+10 w188 h1 0x10
    Gui, Child: Add, Text, xm y+10 w80 h22 0x200, % "Char"
    Gui, Child: Add, Edit, x+5 yp w100 0x0800 vVarOut
    Gui, Child: Show, AutoSize, % "DEC/HEX to Char"
    Gui, Child: -e0x80
return

TOCHAR:
    Gui Child: Default
    Gui, Submit, NoHide
    GuiControl,, VarOut, % Chr(VarIn)
return

; FUNCTIONS =====================================================================================================================

ConvertBase(InputBase, OutputBase, nptr)    ; Base 2 - 36
{
    static u := A_IsUnicode ? "_wcstoui64" : "_strtoui64"
    static v := A_IsUnicode ? "_i64tow"    : "_i64toa"
    VarSetCapacity(s, 66, 0)
    value := DllCall("msvcrt.dll\" u, "Str", nptr, "UInt", 0, "UInt", InputBase, "CDECL Int64")
    DllCall("msvcrt.dll\" v, "Int64", value, "Str", s, "UInt", OutputBase, "CDECL")
    return s
}

; EXIT ==========================================================================================================================

MainClose:
ExitApp

ChildClose:
    Gui, Main: -0x8000000
    Gui, Child: Destroy
return