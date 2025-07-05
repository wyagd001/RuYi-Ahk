;|2.7|2024.06.20|1625
; Tray Audio Visualizer (by balawi28)
; https://github.com/balawi28
;
; Credits to some functions used in my script:
;
; 1- Windows color picker implementation by rbrtryn
; https://www.autohotkey.com/board/topic/91229-windows-color-picker-plus/
;
; 2- Base64PNG to HICON implementation by SKAN
; By SKAN on D094/D357 @ tiny.cc/t-36636
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=36636 

;#Include Gdip.ahk
;#Include VA.ahk
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, Force
OnExit("ExitApplication")

IconColorPallete := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA0klEQVRYhdXWLQ7CQBiE4Sk/jntwCrAoNFgOgEFxBC5CQq9BuAAGzSGwBEQz5ks23b/uTl+1ZtPOk4o2LZ4/JLRZH1OuY5J0O0Oz3b47tLeyD54f7gAUBHgoJcHlTEeADSVhlzM9AZZLwrWc6QqwWIm+5UxfgPlK+C5n4xFgLonQ5ay6QIPrI+p/YPk6AQC2qzcA4LKYRr1AdYHgb4DLbefPF0C4xHgEXMttoRL6Ar7Lbb4SugKxy219EnoCuZbbXBI6AkMtt1mJ+gKlltsoUV3gDx6yPiizmZYIAAAAAElFTkSuQmCC"

; Start gdi+
If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}

; Prepare GUI
InitializeAboutGui()

; Stored variables
global isRanAtStartup := 1
global mainColor := 0xFFFFFFFF
IniRead, isRanAtStartup, %A_ScriptFullPath%:Stream:$DATA, Settings, Startup, error
IniRead, mainColor, %A_ScriptFullPath%:Stream:$DATA, Settings, MainColor, error 

; Tray
Menu, Tray, NoStandard
Menu, Tray, Add, Color Change, ColorChange
Menu, Tray, Add, About, About
Menu, Tray, Icon, About, Shell32.dll, 157
Menu, Tray, Icon, Color Change, % "HICON:" . Base64PNG_to_HICON(IconColorPallete)
Menu, Tray, Add, Run at Startup, StartupToggle
Menu, Tray, Add, Exit, ExitApplication
Menu, Tray, Icon, Exit, Shell32.dll, 132
Menu, Tray, UnCheck, Run at Startup
if (isRanAtStartup)
    Menu, Tray, Check, Run at Startup

; Actual program
spectrum := []
While 1
{
    VA_IAudioMeterInformation_GetPeakValue(VA_GetAudioMeter(), vPeakValue)
    Loop 5
        spectrum[A_Index] := Clamp(vPeakValue * 32 + ((vPeakValue <  0.001) ? 0 : Random(-8,8)), 2, 32)
    CreateTrayIcon(spectrum)
    Sleep, 70
}

Random(min := 0, max := 1.0)
{
	Random, rand, min, max
	return rand
}

ExitApplication()
{
    Gdip_Shutdown(pToken)
    ExitApp
    Exit
}

InitializeAboutGui()
{
    Gui, +LastFound  +ToolWindow +AlwaysOnTop
    Gui, Add, Pic, w32 h32, % "HBITMAP:*" . LogoPng()
    Gui, Color, White
    Gui, Add, Text, cblack,Tray Audio Visualizer By Balawi28.`n.`nFor Suggestions and Bug Report:
    Gui, Add, Edit,,https://github.com/balawi28/TrayAudioVisualizer/issues
}

About()
{
    Gui, Show, NoActivate, Credits
}

ColorChange()
{
    MyColor := ChooseColor(0x80FF, GuiHwnd, , , Colors*)
    if (MyColor != "cancel")
        mainColor := 0xFF000000 | MyColor
    IniWrite, %mainColor%, %A_ScriptFullPath%:Stream:$DATA, Settings, MainColor 
}

StartupToggle()
{
    isRanAtStartup := !isRanAtStartup
    Menu, Tray, ToggleCheck, Run at Startup
    if(isRanAtStartup)
		FileCreateShortcut,%A_ScriptFullPath%,%A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\TrayAudioAnalyzer.lnk,%A_ScriptDir%
	else
		FileDelete, %A_AppData%\Microsoft\Windows\Start Menu\Programs\Startup\TrayAudioAnalyzer.lnk

    IniWrite, %isRanAtStartup%, %A_ScriptFullPath%:Stream:$DATA, Settings, Startup 
}

Clamp(n, min, max)
{
    return Max(Min(max, n), min)
}

CreateTrayIcon(spectrum)
{
    pBrushBack := Gdip_BrushCreateSolid(mainColor)
    pBitmap := Gdip_CreateBitmap(32, 32)
    G := Gdip_GraphicsFromImage(pBitmap)
    Gdip_SetSmoothingMode(G, 1)
    X := [2,8,14,20,26]
    Loop 5
        Gdip_FillRectangle(G, pBrushBack, X[A_Index], 32-spectrum[A_Index], 4, 32)
    ;tooltip % pBitmap
    hIcon := Gdip_CreateHICONFromBitmap(pBitmap)
    ;msgbox % hIcon
    Gdip_DeleteBrush(pBrushBack)
    Gdip_DeleteGraphics(G)
    Gdip_DisposeImage(pBitmap)
		;tooltip % hIcon
    Menu, Tray, Icon, HICON:*%hIcon%
    if WinExist("AppBarWin ahk_class AutoHotkeyGUI")
    {
      ExecSendToRuyi("HICON:*" hIcon,, 1624)
      sleep 250
    }
    DestroyIcon(hIcon)
}

ChooseColor(pRGB := 0, hOwner := 0, DlgX := 0, DlgY := 0, Palette*)
{
    static CustColors    ; Custom colors are remembered between calls
    static SizeOfCustColors := VarSetCapacity(CustColors, 64, 0)
    static StructSize := VarSetCapacity(ChooseColor, 9 * A_PtrSize, 0)
    
    CustData := (DlgX << 16) | DlgY    ; Store X in high word, Y in the low word

;___Load user's custom colors
    for Index, Value in Palette
        NumPut(BGR2RGB(Value), CustColors, (Index - 1) * 4, "UInt")

;___Set up a ChooseColor structure as described in the MSDN
    NumPut(StructSize, ChooseColor, 0, "UInt")
    NumPut(hOwner, ChooseColor, A_PtrSize, "UPtr")
    NumPut(BGR2RGB(pRGB), ChooseColor, 3 * A_PtrSize, "UInt")
    NumPut(&CustColors, ChooseColor, 4 * A_PtrSize, "UPtr")
    NumPut(0x113, ChooseColor, 5 * A_PtrSize, "UInt")
    NumPut(CustData, ChooseColor, 6 * A_PtrSize, "UInt")
    NumPut(RegisterCallback("ColorWindowProc"), ChooseColor, 7 * A_PtrSize, "UPtr")

;___Call the function
    if(! DllCall("comdlg32\ChooseColor", "UPtr", &ChooseColor, "UInt"))
        Return "cancel"

;___Save the changes made to the custom colors
    Loop 16
        Palette[A_Index] := BGR2RGB(NumGet(CustColors, (A_Index - 1) * 4, "UInt"))
        
    return BGR2RGB(NumGet(ChooseColor, 3 * A_PtrSize, "UINT"))
}

ColorWindowProc(hwnd, msg, wParam, lParam)
{
    static WM_INITDIALOG := 0x0110
    
    if (msg <> WM_INITDIALOG)
        return 0
    
    hOwner := NumGet(lParam+0, A_PtrSize, "UPtr")
    if (hOwner)
        return 0

    DetectSetting := A_DetectHiddenWindows
    DetectHiddenWindows On
    CustData := NumGet(lParam+0, 6 * A_PtrSize, "UInt")
    DlgX := CustData >> 16, DlgY := CustData & 0xFFFF
    WinMove ahk_id %hwnd%, , %DlgX%, %DlgY%
    
    DetectHiddenWindows %DetectSetting%
    return 0
}

BGR2RGB(Color)
{
    return  (Color & 0xFF000000) | ((Color & 0xFF0000) >> 16) |  (Color & 0x00FF00) | ((Color & 0x0000FF) << 16)
}

Base64PNG_to_HICON(Base64PNG, W:=0, H:=0)
{     
   BLen:=StrLen(Base64PNG), Bin:=0,     nBytes:=Floor(StrLen(RTrim(Base64PNG,"="))*3/4)                     
   Return DllCall("Crypt32.dll\CryptStringToBinary", "Str",Base64PNG, "UInt",BLen, "UInt",1
               ,"Ptr",&(Bin:=VarSetCapacity(Bin,nBytes)), "UIntP",nBytes, "UInt",0, "UInt",0)
         ? DllCall("CreateIconFromResourceEx", "Ptr",&Bin, "UInt",nBytes, "Int",True, "UInt"
                  ,0x30000, "Int",W, "Int",H, "UInt",0, "UPtr") : 0            
}

LogoPng(NewHandle := False)
{
    Static hBitmap := 0
    If (NewHandle)
        hBitmap := 0
    If (hBitmap)
        Return hBitmap
    VarSetCapacity(B64, 252 << !!A_IsUnicode)
    B64 := "iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAg0lEQVRYhWNgGAUDDBgJKfhzRPI/Mp/F5jlBPaQAJmoaNuoAcgALvSxyYriIkpb2MegzMjAMghAYdcCAO4DsROh0kQE1UekTLtSwgQEPgVEHjDpgwB0Az4YXGVCzlT4RbQVqgAEPgVEHUL89cAy13mew0seblgY8BEYdMOqAUQcMuAMAc2gPQv9TtC4AAAAASUVORK5CYII="
    If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
        Return False
    VarSetCapacity(Dec, DecLen, 0)
    If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
        Return False
    ; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
    ; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
    hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
    pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
    DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
    DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
    DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
    hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
    VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
    DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
    DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
    DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
    DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
    DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
    DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
    DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
    Return hBitmap
}

ExecSendToRuyi(ByRef StringToSend := "", Title := "如一 ahk_class AutoHotkey", wParam := 0, Msg := 0x4a) {
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)

	DetectHiddenWindows, On
	if Title is integer
	{
		SendMessage, Msg, wParam, &CopyDataStruct,, ahk_id %Title%
		;msgbox % ErrorLevel  "qq"
	}
	else if Title is not integer
	{
		SetTitleMatchMode 2
		sendMessage, Msg, wParam, &CopyDataStruct,, %Title%
	}
	DetectHiddenWindows, Off
	return ErrorLevel
}

#!q::
Menu, Tray, show
return