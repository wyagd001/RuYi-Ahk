区域选择方式 = 1
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

#IfWinActive,  ahk_class AutoHotkeyGUI
Rbutton:: ExitApp
#IfWinActive


SelectCaptureArea:
CoordMode, Mouse, Screen
; 区域截图选取截图区域方法1
if(区域选择方式 = 1) {
selobj := GetArea()
aRect := selobj.x "|" selobj.y "|" selobj.w "|" selobj.h

;~ ;快门声音
IfExist, Sound\shutter.wav
SoundPlay, Sound\shutter.wav, wait

Tooltip %aRect%
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
			MouseGetPos, MX, MY
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
					IfExist, Sound\shutter.wav    ; 快门声音
						SoundPlay, Sound\shutter.wav, wait
					Gui, Destroy
					;Gui, Font, s10
					;Gui, Add, Text, , >>>>选定的区域已经截图，回车继续
					;Gui, Destroy
					tooltip % aRect
					break 2
				}
			}
		}
	}
}
pBitmap := Gdip_BitmapFromScreen(aRect)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
Gui, Add, Picture, vprev_pic, HBITMAP:%hBitmap%
Gui Show

Gdip_SaveBitmapToFile(pBitmap, A_Desktop "\ghgh.png")
Gdip_DisposeImage(pBitmap)
Return

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
   static hGui := CreateSelectionGui()
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
        , coords := [], startMouseX, startMouseY, hGui
        , timer := Func("LowLevelMouseProc").Bind("timer", "", "")
   
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
         startMouseX := startMouseY := ""
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
   }
   __Delete() {
      DllCall("UnhookWindowsHookEx", "Ptr", this.hHook)
      DllCall("GlobalFree", "Ptr", this.callBackPtr, "Ptr")
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