;|2.9|2024.12.31|1317
#Include <Ruyi>
#Persistent
#SingleInstance Force
IniMenuInifile := A_ScriptDir "\..\配置文件\外部脚本\Ini_收藏夹.ini"
if !fileexist(IniMenuInifile)
  FileCopy % A_ScriptDir "\..\..\配置文件\外部脚本\Ini_收藏夹_默认配置.ini", % IniMenuInifile
CurrentWebBrowserOpen_IniFile := A_ScriptDir "\..\配置文件\外部脚本\运行选中的文本.ini"
if !fileexist(CurrentWebBrowserOpen_IniFile)
  FileCopy % A_ScriptDir "\..\..\配置文件\外部脚本\运行选中的文本_默认配置.ini", % CurrentWebBrowserOpen_IniFile

IniMenuobj := ini2obj(IniMenuInifile)
SetWorkingDir %A_ScriptDir%
Menu, Tray, Icon, Shell32.dll, 174
Menu, GuiTabMenu, Add, 删除, Remove

Window := {Width: 550, Height: 425, Title: "Ini_Fav"}  ; Version: "0.2"
Navigation := {Label: ["文件", "文件夹", "程序", "命令", "命令2", "网址", "注册表", "对话框", "如意动作", "桌面", "桌面2"]}

Gui +LastFound -Resize +HwndhGui
Gui Color, FFFFFF
Gui Add, Picture, x0 y0 w1699 h1 +0x4E +HWNDhDividerLine1  ; Dividing line From left to right [top menu bar]

Gui Add, Tab2, x-666 y10 w1699 h359 -Wrap +Theme Buttons vTabControl
Gui Tab

Gui Add, Picture, % "x" -9999 " y" -9999 " w" 96 " h" 32 " vpMenuHover +0x4E +HWNDhMenuHover" ; Menu Hover
Gui Add, Picture, % "x" 0 " y" 18 " w" 4 " h" 32 " vpMenuSelect +0x4E +HWNDhMenuSelect" ; Menu Select

Gui Add, Picture, x96 y0 w1 h1340 +0x4E +HWNDhDividerLine3  ; Divider Top to bottom
Gui Add, Progress, x0 y0 w96 h799 +0x4000000 +E0x4 Disabled BackgroundF7F7F7 ; Left side constant background color

; Font size and font boldness for the left Tab header
Gui Font, W600 Q5 c808080, Segoe UI
Loop % Navigation.Label.Length() {
	GuiControl,, TabControl, % Navigation.Label[A_Index] "|"
	If (Navigation.Label[A_Index] = "---")
		Continue

	Gui Add, Text, % "x" 0 " y" (32*A_Index)-24 " h" 32 " w" 96 " Center +0x200 BackgroundTrans gMenuClick vMenuItem" . A_Index, % Navigation.Label[A_Index]
}
Gui Font

; Bottom button and background
Global HtmlButton1

NewButton1 := New HtmlButton("HtmlButton1", "退出", "Button1_", (Window.Width-80)-20, (Window.Height-24)-30)

Gui Add, Picture, x96 y360 w1001 h1 +0x4E +HWNDhDividerLine4  ; Dividing line From left to right [Bottom]
Gui Add, Progress, x0 y360 w1502 h149 +0x4000000 +E0x4 Disabled BackgroundFBFBFB

; Font size of the top right Tab title
Gui Font, s15 Q5 c000000, Segoe UI
Gui Add, Text, % "x" 117 " y" 4 " w" (Window.Width-110)-16 " h32 +0x200 vPageTitle"
Gui Add, Picture, % "x" 110 " y" 38 " w" (Window.Width-110)-16 " h1 +0x4E +HWNDhDividerLine2"  ; Dividing Line
Gui Font

Gui Tab, 1
Gui Font, W560, Segoe UI
loop 24
{
	Btn_IconFile := FileExt_GetIcon(GetStringIndex(IniMenuobj["文件"][a_index]))
	Btn_IconFile := Btn_IconFile ? Btn_IconFile : "C:\Windows\system32\imageres.dll@2"
	Btn_Name := SubStr(GetStringIndex(IniMenuobj["文件"][a_index], 2), 1, 4)
	if !Btn_Name
		break
	if a_index = 1
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite hwndhBtn v文件_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 24, 24, 2, ",5,,,")
	}
	else if a_index in 7,13,19
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v文件_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 24, 24, 2, ",5,,,")
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v文件_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 24, 24, 2, ",5,,,")
	}
}
Gui Font

Gui Tab, 2
loop 24
{
	Btn_IconFile := "C:\Windows\system32\imageres.dll@3"
	Btn_Name := SubStr(GetStringIndex(IniMenuobj["文件夹"][a_index], 2), 1, 4)
	if !Btn_Name
		break
	if a_index = 1
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite hwndhBtn v文件夹_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else if a_index in 7,13,19
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v文件夹_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v文件夹_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
}

Gui Tab, 3
Gui Font, W560, Segoe UI
loop 24
{
	Btn_Name := SubStr(GetStringIndex(IniMenuobj["程序"][a_index], 2), 1, 4)
	Btn_IconFile := GetStringIndex(IniMenuobj["程序"][a_index])
	if !Btn_Name
		break
	if a_index = 1
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite hwndhBtn v程序_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile "@0", 32, 32, 2, ",5,,,")
	}
	else if a_index in 7,13,19
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v程序_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile "@0", 32, 32, 2, ",5,,,")
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v程序_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile "@0", 32, 32, 2, ",5,,,")
	}
}
Gui Font

Gui Tab, 4
Gui Font, W560, Segoe UI
loop 24
{
	Btn_IconFile := GetStringIndex(IniMenuobj["命令"][a_index])
	Btn_IconFile := RegExReplace(Btn_IconFile, "(.*\.exe).*", "$1")
	if !InStr(Btn_IconFile, "exe")
		Btn_IconFile := "C:\Windows\system32\imageres.dll@2"
	Btn_Name := SubStr(GetStringIndex(IniMenuobj["命令"][a_index], 2), 1, 4)
	if !Btn_Name
		break
	if a_index = 1
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite hwndhBtn v命令_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile "@0", 32, 32, 2, ",5,,,")
	}
	else if a_index in 7,13,19
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v命令_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile "@0", 32, 32, 2, ",5,,,")
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v命令_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile "@0", 32, 32, 2, ",5,,,")
	}
}
Gui Font

Gui Tab, 5
Gui Font, W560, Segoe UI
loop 48
{
	if a_index < 25
		Continue
	Btn_IconFile := GetStringIndex(IniMenuobj["命令"][a_index])
	Btn_IconFile := RegExReplace(Btn_IconFile, "(.*\.exe).*", "$1")
	if !InStr(Btn_IconFile, "exe")
		Btn_IconFile := "C:\Windows\system32\imageres.dll@2"
	Btn_Name := SubStr(GetStringIndex(IniMenuobj["命令"][a_index], 2), 1, 4)
	if !Btn_Name
		break
	if a_index = 25
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite hwndhBtn v命令_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile "@0", 32, 32, 2, ",5,,,")
	}
	else if a_index in 31,37,43
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v命令_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile "@0", 32, 32, 2, ",5,,,")
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v命令_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile "@0", 32, 32, 2, ",5,,,")
	}
}
Gui Font

Gui Tab, 6  ; Skipped
Gui Font, W560, Segoe UI
loop 24
{
	Btn_IconFile := "C:\Windows\system32\imageres.dll@20"
	Btn_Name := SubStr(GetStringIndex(IniMenuobj["网址"][a_index], 2), 1, 4)
	if !Btn_Name
		break
	if a_index = 1
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite hwndhBtn v网址_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else if a_index in 7,13,19
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v网址_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v网址_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
}
Gui Font

Gui Tab, 7
loop 24
{
	Btn_IconFile := "regedit.exe@0"
	Btn_Name := SubStr(GetStringIndex(IniMenuobj["注册表"][a_index], 2), 1, 4)
	if !Btn_Name
		break
	if a_index = 1
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite hwndhBtn v注册表_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else if a_index in 7,13,19
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v注册表_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v注册表_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
}

Gui Tab, 8
loop 24
{
	Btn_IconFile := "C:\Windows\system32\imageres.dll@3"
	Btn_Name := SubStr(GetStringIndex(IniMenuobj["对话框"][a_index], 2), 1, 4)
	if !Btn_Name
		break
	if a_index = 1
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite hwndhBtn v对话框_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else if a_index in 7,13,19
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v对话框_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v对话框_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
}

Gui Tab, 9
gui, Font, s12, Segoe MDL2 Assets
loop 24
{
	actionnum := GetStringIndex(IniMenuobj["如意动作"][a_index])
	Btn_Name := SubStr(GetStringIndex(IniMenuobj["如意动作"][a_index], 2), 1, 4)
	if actionnum < 5000
	{
		IniRead, OutputVar, % A_ScriptDir "\..\配置文件\内置动作.ini", Name, % actionnum
		Icon_Font := GetStringIndex(OutputVar)
	}
	else
	{
		IniRead, OutputVar, % A_ScriptDir "\..\配置文件\自定义动作.ini", Name, % actionnum
		Icon_Font := GetStringIndex(OutputVar)
	}
	if !Btn_Name
		break
	if a_index = 1
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite v如意动作_%a_index%_btn grunbtn, % Chr("0x" Icon_Font) "`n" Btn_Name
	}
	else if a_index in 7,13,19
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v如意动作_%a_index%_btn grunbtn, %  Chr("0x" Icon_Font) "`n" Btn_Name
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v如意动作_%a_index%_btn grunbtn, %  Chr("0x" Icon_Font) "`n" Btn_Name
	}
}

Gui Tab, 10
IniMenuobj["桌面"] := {}
Loop, Files, %A_Desktop%\*.lnk, F
{
	IniMenuobj["桌面"][a_index] := A_LoopFilePath
	SplitPath, A_LoopFilePath,,,, Name
	FileGetShortcut, % A_LoopFilePath, Targ, OD,,, OI, OIN,
	Btn_IconFile := ((!OI) ? Targ : OI) "@" ((!OIN) ? 0 : OIN-1)
	;Btn_IconFile := StrReplace(Btn_IconFile, ",", "@")
	Btn_Name := SubStr(Name, 1, 4)
	;MsgBox % Btn_IconFile
	if !Btn_Name
		break
	if (a_index > 24)
		break
	if (a_index = 1)
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite hwndhBtn v桌面_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else if a_index in 7,13,19
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v桌面_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v桌面_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
}

Gui Tab, 11
Loop, Files, %A_Desktop%\*.lnk, F
{
	if (a_index < 25)
		Continue
	IniMenuobj["桌面"][a_index] := A_LoopFilePath
	SplitPath, A_LoopFilePath,,,, Name
	FileGetShortcut, % A_LoopFilePath, Targ, OD,,, OI, OIN,
	Btn_IconFile := ((!OI) ? Targ : OI) "@" ((!OIN) ? 0 : OIN-1)
	;Btn_IconFile := StrReplace(Btn_IconFile, ",", "@")
	Btn_Name := SubStr(Name, 1, 4)
	;MsgBox % Btn_IconFile
	if !Btn_Name
		break
	if (a_index > 48)
		break
	if (a_index = 25)
	{
		Gui Add, Button, x116 y50 w70 h70 BackgroundWhite hwndhBtn v桌面_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else if a_index in 31,37,43
	{
		Gui Add, Button, x116 y+m w70 h70 BackgroundWhite hwndhBtn v桌面_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
	else
	{
		Gui Add, Button, xp+70 yp w70 h70 BackgroundWhite hwndhBtn v桌面_%a_index%_btn grunbtn, % Btn_Name
		ILButton(hBtn, Btn_IconFile, 32, 32, 2, ",5,,,")
	}
}

Gui, Add, StatusBar,,
Gui Show, % " w" Window.Width " h" Window.Height, % Window.Title

SetPixelColor("E9E9E9", hMenuHover)
SetPixelColor("0078D7", hMenuSelect)
Loop 4
  SetPixelColor("D8D8D8", hDividerLine%A_Index%)
SelectMenu("MenuItem1")
OnMessage(0x200, "WM_MOUSEMOVE")
Return

MenuClick:
	SelectMenu(A_GuiControl)
Return

GuiClose:
	ExitApp

runbtn:
TmpArr := StrSplit(A_GuiControl, "_")   ; 文件_6_btn
;msgbox % A_GuiControl
Candy_Cmd := IniMenuobj[TmpArr[1]][TmpArr[2]]
;MsgBox % Candy_Cmd  " - " TmpArr[1] " - " TmpArr[2]
Candy_Cmd := GetStringIndex(Candy_Cmd)
;MsgBox % Candy_Cmd
if (TmpArr[1] = "如意动作")
{
	ExecSendToRuyi("",, Candy_Cmd)
	;MsgBox % Candy_Cmd
	Return
}

; 注册表
if (RegExMatch(Candy_Cmd, "i)^(HKCU|HKCR|HKCC|HKU|HKLM|HKEY|计算机\\HK|\[HK)"))
{
	f_OpenReg(Candy_Cmd)
	return
}

; 网址
if RegExMatch(Candy_Cmd, "i)^(https://|http://)+(.*\.)+.*")
{
	WinGet, Windy_CurWin_Fullpath, ProcessPath, A
	WinGet, OutPID, PID, A
	SplitPath, Windy_CurWin_Fullpath, Windy_CurWin_ProcName
	ATA_filepath := Candy_Cmd
	Gosub CurrentWebOpen
	return
}

; 文件
Candy_Cmd := Deref(Candy_Cmd)
run %Candy_Cmd%,, UseErrorLevel
return

; HtmlButton Event Handling
Button1_OnClick() {
	ExitApp
}

SelectMenu(Control) {
	Global
  Loop % Navigation.Label.Length()
    SetControlColor("808080", Navigation.Label[A_Index])  ; Color of the unchecked button on the left

	CurrentMenu := Control
	, SetControlColor("237FFF", Control)  ; Color of the selected button on the left
	GuiControl, Move, pMenuSelect, % "x" 0 " y" (32*SubStr(Control, 9, 2))-20 " w" 4 " h" 24
	GuiControl, Choose, TabControl, % SubStr(Control, 9, 2)
	GuiControl,, PageTitle, % Navigation.Label[SubStr(Control, 9, 2)]
}

WM_MOUSEMOVE(wParam, lParam, Msg, Hwnd) {
	Global hMenuSelect, IniMenuobj
    Static hover := {}

    if (wParam = "timer") {
        MouseGetPos,,,, hControl, 2
        if (hControl != hwnd) && (hControl != hMenuSelect) {
            SetTimer,, Delete
            GuiControl, Move, pMenuHover, % "x" -9999 " y" -9999
            OnMessage(0x200, "WM_MOUSEMOVE")
            , hover[hwnd] := False
        }
     } else {
        if (InStr(A_GuiControl, "MenuItem") = True) {
            GuiControl, Move, pMenuHover, % "x" 0 " y" (32*SubStr(A_GuiControl, 9, 2))-24
            GuiControl, MoveDraw, pMenuHover
            hover[hwnd] := True
            , OnMessage(0x200, "WM_MOUSEMOVE", 0)
            , timer := Func(A_ThisFunc).Bind("timer", "", "", hwnd)
            SetTimer % timer, 15
        }
				else if (InStr(A_GuiControl, "MenuItem") = False)
				{
            GuiControl, Move, pMenuHover, % "x" -9999 " y" -9999
					if InStr(A_GuiControl, "_btn")
					{
						TmpArr := StrSplit(A_GuiControl, "_")
						Candy_Cmd := IniMenuobj[TmpArr[1]][TmpArr[2]]
						Btn_Cmd := GetStringIndex(Candy_Cmd, 1)
						Btn_Name := GetStringIndex(Candy_Cmd, 2)
						SB_SetText(Btn_Name "(" Btn_Cmd ")")
					}
				}

    }
}

SetControlColor(Color, Control) {
	GuiControl, % "+c" Color, % Control

	; Required due to redrawing issues with the Tab2 control
	GuiControlGet, ControlText,, % Control
	GuiControlGet, ControlHandle, Hwnd, % Control
	DllCall("SetWindowText", "Ptr", ControlHandle, "Str", ControlText)
    GuiControl, MoveDraw, % Control
}

SetPixelColor(Color, Handle) {
	VarSetCapacity(BMBITS, 4, 0), Numput("0x" . Color, &BMBITS, 0, "UInt")
	, hBM := DllCall("Gdi32.dll\CreateBitmap", "Int", 1, "Int", 1, "UInt", 1, "UInt", 24, "Ptr", 0)
	, hBM := DllCall("User32.dll\CopyImage", "Ptr", hBM, "UInt", 0, "Int", 0, "Int", 0, "UInt", 0x2008)
	, DllCall("Gdi32.dll\SetBitmapBits", "Ptr", hBM, "UInt", 3, "Ptr", &BMBITS)
	return DllCall("User32.dll\SendMessage", "Ptr", Handle, "UInt", 0x172, "Ptr", 0, "Ptr", hBM)
}

; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=3851&start=360#p458266
; Replace the standard button with a web button style, compatible to XP system. If Gui turns on -DPIScale, you need to set the last parameter "DPIScale" of HtmlButton to non-0 to fix the match.
Class HtmlButton
{
	__New(ButtonGlobalVar, ButtonName, gLabelFunc, OptionsOrX:="", y:="", w:=78 , h:=26, GuiLabel:="", TextColor:="001C30", DPIScale:=False) {
		Static Count:=0
        f := A_Temp "\" A_TickCount "-tmp" ++Count ".DELETEME.html"

		Html_Str =
		(
			<!DOCTYPE html><html><head>
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<style>body {overflow-x:hidden;overflow-y:hidden;}
				button { color: #%TextColor%;
					background-color: #F4F4F4;
					border-radius:2px;
					border: 1px solid #A7A7A7;
					cursor: pointer; }
				button:hover {background-color: #BEE7FD;}
			</style></head><body>
			<button id="MyButton%Count%" style="position:absolute;left:0px;top:0px;width:%w%px;height:%h%px;font-size:12px;font-family:'Microsoft YaHei UI';">%ButtonName%</button></body></html>
		)
        if (OptionsOrX!="")
            if OptionsOrX is Number
                x := "x" OptionsOrX
             else
                Options := " " OptionsOrX
        (y != "" && y := " y" y)
		Gui, %GuiLabel%Add, ActiveX, %  x . y . " w" w " h" h " v" ButtonGlobalVar . Options, Shell.Explorer
		FileAppend, % Html_Str, % f
		%ButtonGlobalVar%.Navigate("file://" . f)
        , this.Html_Str := Html_Str
        , this.ButtonName := ButtonName
        , this.gLabelFunc := gLabelFunc
        , this.Count := Count 
		, %ButtonGlobalVar%.silent := True
        , this.ConnectEvents(ButtonGlobalVar, f)
        if !DPIScale
            %ButtonGlobalVar%.ExecWB(63, 1, Round((A_ScreenDPI/96*100)*A_ScreenDPI/96) ) ; Fix ActiveX control DPI scaling
	}

    Text(ButtonGlobalVar, ButtonText) {
        Html_Str := StrReplace(this.Html_Str, ">" this.ButtonName "</bu", ">" ButtonText "</bu")
        FileAppend, % Html_Str, % f := A_Temp "\" A_TickCount "-tmp.DELETEME.html"
		%ButtonGlobalVar%.Navigate("file://" . f)
        , this.ConnectEvents(ButtonGlobalVar, f)
    }

    ConnectEvents(ButtonGlobalVar, f) {
		While %ButtonGlobalVar%.readystate != 4 or %ButtonGlobalVar%.busy
			Sleep 5
        this.MyButton := %ButtonGlobalVar%.document.getElementById("MyButton" this.Count)
		, ComObjConnect(this.MyButton, this.gLabelFunc)
		FileDelete, % f
    }
}

/*
Title: ILButton
Version: 1.1
Author: tkoi <https://ahknet.autohotkey.com/~tkoi>
License: GNU GPLv3 <http://www.opensource.org/licenses/gpl-3.0.html>

Function: ILButton()
    Creates an imagelist and associates it with a button.
Parameters:
    hBtn   - handle to a buttton
    images - a pipe delimited list of images in form "file:zeroBasedIndex"
               - file must be of type exe, dll, ico, cur, ani, or bmp
               - there are six states: normal, hot (hover), pressed, disabled, defaulted (focused), and stylushot
                   - ex. "normal.ico:0|hot.ico:0|pressed.ico:0|disabled.ico:0|defaulted.ico:0|stylushot.ico:0"
               - if only one image is specified, it will be used for all the button's states
               - if fewer than six images are specified, nothing is drawn for the states without images
               - omit "file" to use the last file specified
                   - ex. "states.dll:0|:1|:2|:3|:4|:5"
               - omitting an index is the same as specifying 0
               - note: within vista's aero theme, a defaulted (focused) button fades between images 5 and 6
    cx     - width of the image in pixels
    cy     - height of the image in pixels
    align  - an integer between 0 and 4, inclusive. 0: left, 1: right, 2: top, 3: bottom, 4: center
    margin - a comma-delimited list of four integers in form "left,top,right,bottom"

Notes:
    A 24-byte static variable is created for each IL button
    Tested on Vista Ultimate 32-bit SP1 and XP Pro 32-bit SP2.

Changes:
  v1.1
    Updated the function to use the assume-static feature introduced in AHK version 1.0.48
*/

ILButton(hBtn, images, cx=16, cy=16, align=4, margin="1,1,1,1")
{
	static
	static i = 0
	local himl, v0, v1, v2, v3, ext, hbmp, hicon
	i ++

	himl := DllCall("ImageList_Create", "Int", cx, "Int", cy, "UInt", 0x20, "Int", 1, "Int", 5, "UPtr")
	if images is integer
	{
		DllCall("ImageList_AddIcon", "Ptr", himl, "Ptr", images)
		DllCall("DestroyIcon", "Ptr", images)
	}
	else
	{
		Loop, Parse, images, |
		{
			StringSplit, v, A_LoopField, @
			if not v1
				v1 := v3
			v3 := v1
			;MsgBox % v1 " - " v2
			SplitPath, v1, , , ext
			if (ext = "bmp") {
				hbmp := DllCall("LoadImage", "UInt",0, "Str", v1, "UInt", 0, "UInt", cx, "UInt", cy, "UInt", 0x10, "UPtr")
				DllCall("ImageList_Add", "Ptr", himl, "Ptr", hbmp, "Ptr", 0)
				DllCall("DeleteObject", "Ptr", hbmp)
			}
			else {
				DllCall("PrivateExtractIcons", "Str", v1, "Int", v2, "Int", cx, "Int", cy, "PtrP", hicon, "UInt", 0, "UInt", 1, "UInt", 0)
				DllCall("ImageList_AddIcon", "Ptr", himl, "Ptr", hicon)
				DllCall("DestroyIcon", "Ptr", hicon)
			}
		}
	}
	; Create a BUTTON_IMAGELIST structure
	VarSetCapacity(struct%i%, A_PtrSize + (5 * 4) + (A_PtrSize - 4), 0)
	NumPut(himl, struct%i%, 0, "Ptr")
	Loop, Parse, margin, `,
		NumPut(A_LoopField, struct%i%, A_PtrSize + ((A_Index - 1) * 4), "Int")
	NumPut(align, struct%i%, A_PtrSize + (4 * 4), "UInt")
	; BCM_FIRST := 0x1600, BCM_SETIMAGELIST := BCM_FIRST + 0x2
	PostMessage, 0x1602, 0, &struct%i%, , ahk_id %hBtn%
	Sleep 1 ; workaround for a redrawing problem on WinXP
}









GuiDropFiles:
CandySel := A_GuiEvent
Rindex := SubStr(CurrentMenu, 9)
if Rindex in 1,2,3,8
{
  SplitPath, CandySel,,, OutExtension, OutNameNoExt
  if OutExtension
    OutFileName := OutNameNoExt "．" OutExtension
  else
    OutFileName := OutNameNoExt

  SecName := Navigation.Label[Rindex]
  R_index := IniMenuobj[SecName].Count()+1
  IniMenuobj[SecName][R_index] := CandySel "|" OutFileName
  obj2ini(IniMenuobj, IniMenuInifile)
}
return

GuiContextMenu:
MouseGetPos,,, WinH, Contr
If Instr(Contr, "button")
{
	GuiControl, Focus, %Contr%
	Menu, GuiTabMenu, Show
}
return

Remove:
GuiControlGet, OutputVar, FocusV
TabClass := Substr(OutputVar, 1, Instr(OutputVar, "_") - 1)
ButNum := Substr(OutputVar, Instr(OutputVar, "_")+1, Instr(OutputVar, "_", 0, , 2)-Instr(OutputVar, "_")-1)
;msgbox % TabClass "-" ButNum

IniMenuobj[TabClass].RemoveAt(ButNum)
obj2ini(IniMenuobj, IniMenuInifile)
IniDelete, %IniMenuInifile%, %TabClass%, % IniMenuobj[TabClass].Count()+1  ; 删除最后多出的哪一项
return

f_OpenReg(RegPath)
{
	RegPath := LTrim(RegPath, "[")
	RegPath := RTrim(RegPath, "]")
	StringLeft, RegPathFirst4, RegPath, 4
	if RegPathFirst4 = HKCR
		StringReplace, RegPath, RegPath, HKCR, HKEY_CLASSES_ROOT
	else if RegPathFirst4 = HKCU
		StringReplace, RegPath, RegPath, HKCU, HKEY_CURRENT_USER
	else if RegPathFirst4 = HKLM
		StringReplace, RegPath, RegPath, HKLM, HKEY_LOCAL_MACHINE
	else if RegPathFirst4 = HKCC
		StringReplace, RegPath, RegPath, HKCC, HKEY_CURRENT_CONFIG
	else if RegPathFirst4 = HKU
		StringReplace, RegPath, RegPath, HKU, HKEY_USERS

	; 将字串中的前两个"＿"(全角) 替换为“_"(半角)
	StringReplace, RegPath, RegPath, ＿, _
	StringReplace, RegPath, RegPath, ＿, _
	; 替换字串中第一个“, ”为"\"
	StringReplace, RegPath, RegPath, `,%A_Space%, \
	; 替换字串中第一个“,”为"\"
	StringReplace, RegPath, RegPath, `,, \
	; 将字串中的所有"/" 替换为“\"
	StringReplace, RegPath, RegPath, /, \, All
	; 将字串中的所有"／"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ／, \, All
	; 将字串中的所有"＼"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ＼, \, All
	StringReplace, RegPath, RegPath, %A_Space%\, \, All
	StringReplace, RegPath, RegPath, \%A_Space%, \, All
	; 将字串中的所有“\\”替换为“\”
	StringReplace, RegPath, RegPath, \\, \, All

	RegRead, MyComputer, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey
	f_Split2(MyComputer, "\", MyComputer, aaa)
	MyComputer := MyComputer ? MyComputer : (A_OSVersion="WIN_XP")?"我的电脑":"计算机"
	IfNotInString, RegPath, %MyComputer%\
		RegPath := MyComputer "\" RegPath
	;tooltip % RegPath

	IfWinExist, ahk_class RegEdit_RegEdit
	{
		RunWait, % "cmd.exe /c taskkill /IM regedit.exe", , Hide
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe
	}
	Else
	{
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe ;-m
	}
return
}

f_Split2(String, Seperator, ByRef LeftStr, ByRef RightStr)
{
	SplitPos := InStr(String, Seperator)
	if SplitPos = 0 ; Seperator not found, L = Str, R = ""
	{
		LeftStr := String
		RightStr:= ""
	}
	else
	{
		SplitPos--
		StringLeft, LeftStr, String, %SplitPos%
		SplitPos++
		StringTrimLeft, RightStr, String, %SplitPos%
	}
	return
}

CurrentWebOpen:
; ATA_filepath 含有 "/" 字符时, 使用浏览器打开, 网址中不支持中文字符
IniRead, Default_Browser, %CurrentWebBrowserOpen_IniFile%, Browser, Default_Browser, %A_Space%
IniRead, url, %CurrentWebBrowserOpen_IniFile%, Browser, Default_Url
IniRead, InUse_Browser, %CurrentWebBrowserOpen_IniFile%, Browser, InUse_Browser
;msgbox % Default_Browser " - " ATA_filepath
If Default_Browser
{
	Loop, parse, url, |
	{
		IfInString, ATA_filepath, %A_LoopField%    ;ATA_filepath有特定字符时使用默认浏览器打开
		{
			Loop, parse, Default_Browser, `,
			{
				run %A_LoopField% "%ATA_filepath%",, UseErrorLevel
				if !ErrorLevel
				break
			}
			if (ErrorLevel = "error")
				msgbox A_LastError
			return
		}
	}
}
br := 0
if InStr(InUse_Browser, Windy_CurWin_ProcName)   ;当前窗口在使用的浏览器列表当中
{
	If(Windy_CurWin_ProcName = "chrome.exe" or Windy_CurWin_ProcName = "firefox.exe")
	{
			pid := GetCommandLine2(OutPID)
			run, %pid% "%ATA_filepath%"
			br :=1
	}
	else
	{
			pid := GetModuleFileNameEx(OutPID)
			;msgbox %pid% "%ATA_filepath%"
			run, %pid% "%ATA_filepath%"
			br := 1
	}
}
StringSplit, BApp, InUse_Browser, `,     ;当前窗口进程名不在使用的浏览器列表当中
LoopN := 1
if !br
{
	Loop, %BApp0%
	{
		BCtrApp := BApp%LoopN%
		LoopN++
		Process, Exist, %BCtrApp%
		If (errorlevel<>0)    ;  使用的浏览器列表当中的浏览器进程是否存在
		{
			NewPID = %ErrorLevel%
			If(BCtrApp = "chrome.exe" or BCtrApp = "firefox.exe")
			{
				pid := GetCommandLine2(NewPID)
				;pid := GetCommandLine(NewPID)
				;FileAppend , %pid%`n, %A_desktop%\123.txt
				run, %pid% "%ATA_filepath%"
				br :=1
				break
			}
			else
			{
				pid := GetModuleFileNameEx(NewPID)
				;FileAppend , %pid%`n, %A_desktop%\123.txt
				run, %pid% "%ATA_filepath%"
				br := 1
				break
			}
		}
	}
}
if !br   ; 没有打开的浏览器时使用默认的浏览器
{
	If Default_Browser
	{
		Loop, parse, Default_Browser, `,
		{
			run %A_LoopField% "%ATA_filepath%",, UseErrorLevel
			if !ErrorLevel
			break
		}
		if (ErrorLevel = "error") && (A_LastError = 2)
		{
			msgbox % "找不到默认的浏览器, 请检查设置文件的 Default_Browser 条目, 指定默认的浏览器位置或名称."
		}
	}
	else
	{
		run iexplore.exe %ATA_filepath%,, UseErrorLevel
		if (ErrorLevel = "error")
		msgbox 请检查网址: %ATA_filepath%
	}
}
return

GetModuleFileNameEx(p_pid)
{
	if A_OSVersion in WIN_95,WIN_98,WIN_ME,WIN_XP
	{
		MsgBox, Windows 版本 (%A_OSVersion%) 不支持。Win 7 及以上系统才能正常使用。
		return
	}

	h_process := DllCall("OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid)
	if ( ErrorLevel or h_process = 0 )
		return

	name_size = 255
	VarSetCapacity(name, name_size)

	result := DllCall("psapi.dll\GetModuleFileNameEx", "uint", h_process, "uint", 0, "str", name, "uint", name_size)

	DllCall("CloseHandle", h_process)
	return, name
}

GetCommandLine2(pid)
{
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where ProcessId=" pid)
		Return sCmdLine := process.CommandLine
}

FileExt_GetIcon(File)
{
	; Allocate memory for a SHFILEINFOW struct.
	VarSetCapacity(fileinfo, fisize := A_PtrSize + 688)
	
	; Get the file's icon.
	if DllCall("shell32\SHGetFileInfoW", "wstr", File
		, "uint", 0, "ptr", &fileinfo, "uint", fisize, "uint", 0x100 | 0x000000001)
	{
		Return hicon := NumGet(fileinfo, 0, "ptr")
		; Set the menu item's icon.
		; Because we used ":" and not ":*", the icon will be automatically
		; freed when the program exits or if the menu or item is deleted.
	}
}