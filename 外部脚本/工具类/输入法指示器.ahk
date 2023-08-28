;|2.3|2023.08.19|1428
#SingleInstance, Force
#NoEnv
;~ #Persistent
;~ #NoTrayIcon
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e775.ico"

CoordMode, Mouse, Screen
SetWinDelay, -1
SetBatchLines, -1

global UsrTxt, UsrPic, TransC:="F0F0F0"
    , thisFileName := RegExReplace(A_ScriptName, "\.([^\.]*)")
    , DFIcon := thisFileName ".ico"

;~ ************************** 基本设置 **************************
    , TGUI := 15            ;   拖曳数量             (默认8)
    , LagTime := 30         ;   拖曳时留影时间间隔   (ms)
    , TransP := 150         ;   曳影透明度           (0~255)
    , ClearFrame := 5       ;   曳影消除延迟帧数     (默认 4 帧)
    , FrameX := 5           ;   曳影帧左上相对鼠标热点偏移量，同时也是图像左上角位置
    , FrameY := 5           ;       只需设置文字左上角与其相对位置即可

;~ ************************** 曳影设置 **************************
; ♡♥♣◐◑☆★○●♫♬❉*✿❃❀❤⋚⋛†❥
    , DFTxt := "❤"       ;   默认曳影文字
    , UseTxt := 1           ;   是否使用文字
    , FntX := 6             ;   文字偏移
    , FntY := 10
    , FntType := "微软雅黑" ;   设置曳影字体
    , FntSize := 12
    , FntEx := "Bold"
    , FntQuality := 
    , RandomColor := 1
    , FntColor := "Red"     ;   字体设置，标准 Windows 字形设置
    , DFPic := DFIcon
                            ;   曳影图像文件，Windows 支持为准，默认为同名 .ico
    , UsePic := 0           ;   是否使用图像
    , PicW := 32            ;   图像尺寸
    , PicH := -1            ;   其中一个设置 -1 则以另一个为比例缩放
;~ ************************** 设置结束 **************************

if A_IsCompiled
	Menu, Tray, Icon , % thisFileName ".exe"
Menu, Tray, Tip, % exeName " - " exeVer (exeVerSub?"(" exeVerSub ")":)

biuldFollow()
SetTimer, FollowMonitor, 300
SetTimer, IMEchangeDFTxt, 300
return

biuldFollow()
{
	if RandomColor
	{
	  Random, R, 0, 255
	  Random, G, 0, 255
	  Random, B, 0, 255
	  FntColor := Format("{1:x}{2:x}{3:x}", R, G, B)
	}
	gui, WinName1:New, HwndFollowID1 AlwaysOnTop ToolWindow Disabled -Caption
	gui, font, % "s" FntSize " " FntEx " q" FntQuality " c" FntColor, % FntType
	if (FileExist(DFPic) && UsePic)
		Gui, WinName1:Add, Picture, % "x0 y0 w" PicW " h" PicH " vUsrPic gFrameClick", % DFPic
	if UseTxt
		Gui, WinName1:Add, Text, % "x" FntX " y" FntY " vUsrTxt ", % DFTxt
	Gui, WinName1:Color, % TransC
	WinSet, Style, -0xC00000, % "ahk_id " FollowID1
	Gui, WinName1:Show, % "NA AutoSize"
	WinSet, TransColor, % TransC " " TransP, % "ahk_id " FollowID1
	;Gui, WinName1:Hide
}
return

IMEchangeDFTxt:
if (GetKeyState("CapsLock", "T") = 1)
{
	DFTxt := "A"
	laststa := DFTxt
	GuiControl WinName1:, UsrTxt, % DFTxt
	return
}
if IME_IsENG()
{
	DFTxt := "英"
}
else
{
	DFTxt := "中"
}
if (laststa != DFTxt)
{
	laststa := DFTxt
	if RandomColor
	{
		Random, R, 0, 255
		Random, G, 0, 255
		Random, B, 0, 255
		FntColor := Format("{1:x}{2:x}{3:x}", R, G, B)
	}
	gui, WinName1: font, % "c" FntColor
	GuiControl, WinName1: Font, UsrTxt
	GuiControl WinName1:, UsrTxt, % DFTxt
}
return

FollowMonitor:
FollowDrawGui()
return

FollowDrawGui()
{
	static X, Y
	;Gui, WinName1:Hide
	MouseGetPos, OutputVarX, OutputVarY
	if (X != OutputVarX) or (Y != OutputVarY)
	{
		X := OutputVarX, Y := OutputVarY
		Gui, WinName1:Show, % "NA X" OutputVarX + 35 " Y" OutputVarY - 10
	}
}

IME_IsENG()
{
	if !IME_Get()
		return true

	Tmp_Val:=IME_GetConvMode(_mhwnd())
	;msgbox % Tmp_Val
	if Tmp_Val=0
		return true
	else if (Tmp_Val=1024)
		return true
	else 
		return false
}

_mhwnd()
{
	;background test
	;MouseGetPos,x,,hwnd
	Hwnd := WinActive("A")
Return "ahk_id " . hwnd
}

IME_GET(WinTitle="A")  {
    hwnd := GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , Ptr, DllCall("imm32\ImmGetDefaultIMEWnd", Ptr,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          , UPtr, 0x0005  ;wParam  : IMC_GETOPENSTATUS
          ,  Ptr, 0)      ;lParam  : 0
}

IME_GetConvMode(WinTitle="A")   {
    hwnd := GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
          , "UInt", 0x0283  ;Message : WM_IME_CONTROL
          ,  "Int", 0x001   ;wParam  : IMC_GETCONVERSIONMODE
          ,  "Int", 0) & 0xffff     ;lParam  : 0 ， & 0xffff 表示只取低16位
}

GetGUIThreadInfo_hwndActive(WinTitle="A")
{
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
	  ptrSize := !A_PtrSize ? 4 : A_PtrSize
	  VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	  NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	return  hwnd := DllCall("GetGUIThreadInfo", "Uint", 0, "Ptr", &stGTI)
	             ? NumGet(stGTI, 8+PtrSize, "Ptr") : hwnd
  }
  else
  return  hwnd
}