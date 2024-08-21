;|2.7|2024.08.02|1653
; 需要 自行安装 RapidOCR(老式CPU适用) 或 PaddleOCR
区域选择方式 = 1
OCRMode := "Rapid"
;OCRMode := "Paddle"
pToken := Gdip_Startup()

if(区域选择方式 = 1)
{
	cstip=
	(LTrim
		按住鼠标左键拖选截图区域
		"Esc/右键"键，退出
	)
}
else if(区域选择方式 = 2)
{
	cstip=
  (LTrim
		点击"左键"开始选取，移动鼠标，再次点击"左键"结束
		"Esc/右键"键，退出
	)
}
gosub, Tip_info
gosub, SelectCaptureArea
Return

Esc::ExitApp

#IfWinNotActive,  ahk_class AutoHotkeyGUI
Rbutton:: ExitApp
#IfWinNotActive

SelectCaptureArea:
CoordMode, Mouse, Screen
MouseGetPos,,, quyujt
; 区域截图选取截图区域方法1
if(区域选择方式 = 1)
{
	selobj := GetArea()
	aRect := selobj.x "|" selobj.y "|" selobj.w "|" selobj.h

	;~ ;快门声音
	IfExist, %A_ScriptDir%\..\..\脚本图标\shutter.wav
		SoundPlay, %A_ScriptDir%\..\..\脚本图标\shutter.wav

	;Tooltip %aRect%
	sleep,100
}
; 区域截图选取截图区域方法2
else if(区域选择方式 = 2)
{
	Loop
	{
		Sleep, 10
		KeyIsDown := GetKeyState("LButton")
		if (KeyIsDown = 1)
		{
			TrayTip
			MouseGetPos, MX, MY, quyujt
			Gui, +LastFound
			Gui, +AlwaysOnTop -caption +Border +ToolWindow +LastFound
			WinSet, Transparent, 80
			Gui, Color, EEAA99
			Sleep, 500
			Loop
			{
				sleep, 10
				KeyIsDown := GetKeyState("LButton")
				MouseGetPos, MXend, MYend
				w := abs(MX - MXend), h := abs(MY - MYend)
				X := (MX < MXend) ? MX : MXend
				Y := (MY < MYend) ? MY : MYend
				Gui, Show, x%X% y%Y% w%w% h%h%

				if (KeyIsDown = 1)
				{
					If ((w < 10) or (h < 10))
					{
						TrayTip,警告,两次点击间距过小或者未按提示进行操作，脚本重新启动,3,18
						sleep,3000
						reload
					}
					If ( MX > MXend )
						Swap(MX, MXend)
					If ( MY > MYend )
						Swap(MY, MYend)

					aRect :=  MX "|" MY "|" MXend "|" MYend
					IfExist, %A_ScriptDir%\..\..\脚本图标\shutter.wav
						SoundPlay, %A_ScriptDir%\..\..\脚本图标\shutter.wav
					Gui, Destroy
					;Gui, Font, s10
					;Gui, Add, Text, , >>>>选定的区域已经截图，回车继续
					;Gui, Destroy
					;tooltip % aRect
					break 2
				}
			}
		}
	}
}
ocr:
pBitmap := Gdip_BitmapFromScreen(aRect)
JTFilePath := A_temp "\Vis2_123.bmp"
Gdip_SaveBitmapToFile(pBitmap, JTFilePath)
Gdip_DisposeImage(pBitmap)
; 需在 github 库中自行下载 RapidOcrOnnx.ahk2 或 PaddleOCR_身份证识别验证.ahk 放在脚步同目录下
if (OCRMode = "Rapid")
{
  AutoHotkey64 := A_ScriptDir "\..\..\引用程序\2.0\AutoHotkey64.exe"
  run %AutoHotkey64% "%A_ScriptDir%\RapidOcrOnnx.ahk2" "%JTFilePath%" "%quyujt%"
}
else
{
  B_Autohotkey := A_ScriptDir "\..\..\引用程序\" (A_PtrSize = 8 ? "AutoHotkeyU64.exe" : "AutoHotkeyU32.exe")
  run %B_Autohotkey% "%A_ScriptDir%\PaddleOCR_身份证识别验证.ahk" "%JTFilePath%" "%quyujt%"
}
sleep 2500
exitapp
Return

SafeFileName(String)
{
	IllegalLetter := "<,>,|,/,\,"",?,*,:,`n,`r,`t"
	Loop, parse, IllegalLetter, `,
		String := StrReplace(String, A_LoopField)
	String := LTrim(String, " ")
	return String
}

GetArea() {
   area := []
   StartSelection(area)
   while !area.w
      Sleep, 100
   Return area
}

StartSelection(area) {
   handler := Func("Select").Bind(area)
   Hotkey, LButton, % handler, On
   ReplaceSystemCursors("IDC_CROSS")
}

Select(area) {
	static hGui
	if !hGui
		hGui := CreateSelectionGui()
	;tooltip % hGui
	Hook := new WindowsHook(WH_MOUSE_LL := 14, "LowLevelMouseProc", hGui)  ;  鼠标钩子
	Loop {
		KeyWait, LButton
		WinGetPos, X, Y, W, H, ahk_id %hGui%
	} until w > 0
	ReplaceSystemCursors("")
	Hotkey, LButton, Off
	Hook := ""
	;Gui, %hGui%:Color, 0058EE
	Gui, %hGui%: Destroy
	hGui := 0
   for k, v in ["x", "y", "w", "h"]
      area[v] := %v%
}

ReplaceSystemCursors(IDC = "")
{
   static IMAGE_CURSOR := 2, SPI_SETCURSORS := 0x57
        , exitFunc := Func("ReplaceSystemCursors").Bind("")
        , SysCursors := { IDC_APPSTARTING: 32650
                        , IDC_ARROW      : 32512
                        , IDC_CROSS      : 32515
                        , IDC_HAND       : 32649
                        , IDC_HELP       : 32651
                        , IDC_IBEAM      : 32513
                        , IDC_NO         : 32648
                        , IDC_SIZEALL    : 32646
                        , IDC_SIZENESW   : 32643
                        , IDC_SIZENWSE   : 32642
                        , IDC_SIZEWE     : 32644
                        , IDC_SIZENS     : 32645 
                        , IDC_UPARROW    : 32516
                        , IDC_WAIT       : 32514 }
   if !IDC {
      DllCall("SystemParametersInfo", UInt, SPI_SETCURSORS, UInt, 0, UInt, 0, UInt, 0)
      OnExit(exitFunc, 0)
   }
   else  {
      hCursor := DllCall("LoadCursor", Ptr, 0, UInt, SysCursors[IDC], Ptr)
      for k, v in SysCursors  {
         hCopy := DllCall("CopyImage", Ptr, hCursor, UInt, IMAGE_CURSOR, Int, 0, Int, 0, UInt, 0, Ptr)
         DllCall("SetSystemCursor", Ptr, hCopy, UInt, v)
      }
      OnExit(exitFunc)
   }
}

CreateSelectionGui() {
   Gui, New, +hwndhGui +Alwaysontop -Caption +LastFound +ToolWindow +E0x20 -DPIScale
   WinSet, Transparent, 130
   Gui, Color, EEAA99
   Return hGui
}

LowLevelMouseProc(nCode, wParam, lParam) {
   static WM_MOUSEMOVE := 0x200, WM_LBUTTONUP := 0x202
        , timer := Func("LowLevelMouseProc").Bind("timer", "", "")
        , coords := [], startMouseX, startMouseY, hGui

   if (nCode = "timer") {
      while coords[1] {
         point := coords.RemoveAt(1)
         mouseX := point[1], mouseY := point[2]
         x := startMouseX < mouseX ? startMouseX : mouseX
         y := startMouseY < mouseY ? startMouseY : mouseY
         w := Abs(mouseX - startMouseX)
         h := Abs(mouseY - startMouseY)
         try Gui, %hGUi%: Show, x%x% y%y% w%w% h%h% NA
      }
   }
   else {
      (!hGui && hGui := A_EventInfo)
      if (wParam = WM_LBUTTONUP)
         startMouseX := startMouseY := "", hGui := ""
      if (wParam = WM_MOUSEMOVE)  {
         mouseX := NumGet(lParam + 0, "Int")
         mouseY := NumGet(lParam + 4, "Int")
         if (startMouseX = "") {
            startMouseX := mouseX
            startMouseY := mouseY
         }
         coords.Push([mouseX, mouseY])
         SetTimer, % timer, -10
      }
      Return DllCall("CallNextHookEx", Ptr, 0, Int, nCode, UInt, wParam, Ptr, lParam)
   }
}

class WindowsHook {
   __New(type, callback, eventInfo := "", isGlobal := true) {
      this.callbackPtr := RegisterCallback(callback, "Fast", 3, eventInfo)
      this.hHook := DllCall("SetWindowsHookEx", "Int", type, "Ptr", this.callbackPtr
                                              , "Ptr", !isGlobal ? 0 : DllCall("GetModuleHandle", "UInt", 0, "Ptr")
                                              , "UInt", isGlobal ? 0 : DllCall("GetCurrentThreadId"), "Ptr")
;tooltip  新建
   }
   __Delete() {
      DllCall("UnhookWindowsHookEx", "Ptr", this.hHook)
      DllCall("GlobalFree", "Ptr", this.callBackPtr, "Ptr")
;tooltip  注销
   }
}

Swap(ByRef Left, ByRef Right)
{
   temp := Left
   Left := Right
   Right := temp
}

Tip_info:
  TrayTip,截图进行中...,%cstip%,,17
Return

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd +Resize
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	ExitApp
	Return

	GuiTextGuiSize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	AutoXYWH("wh", "myedit")
	return
}

; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
; ---------------------------------------------------------------------------------
; Version: 2015-5-29 / Added 'reset' option (by tmplinshi)
;          2014-7-03 / toralf
;          2014-1-2  / tmplinshi
; requires AHK version : 1.1.13.01+
; =================================================================================
AutoXYWH(DimSize, cList*){       ; http://ahkscript.org/boards/viewtopic.php?t=1079
  static cInfo := {}
 
  If (DimSize = "reset")
    Return cInfo := {}
 
  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If ( cInfo[ctrlID].x = "" ){
        GuiControlGet, i, %A_Gui%:Pos, %ctrl%
        MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
        fx := fy := fw := fh := 0
        For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
            If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
              f%dim% := 1
        cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
    }Else If ( cInfo[ctrlID].a.1) {
        dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
        For i, dim in cInfo[ctrlID]["a"]
            Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
        GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
} } }