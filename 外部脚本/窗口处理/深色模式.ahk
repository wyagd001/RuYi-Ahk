;|2.8|2024.11.24|1689
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=94264
Gui, +HWNDhGui +AlwaysOnTop
DllCall("GetWindowBand", "ptr", hGui, "uint*", band)
Gui, Destroy
hGui := ""
Windy_CurWin_id := A_Args[1]
/*
if (band = 1)
{
   If (A_PtrSize = 8)
      RunWait "C:\Program Files\AutoHotkey\AutoHotkeyU64_UIA.exe" "%A_ScriptFullPath%"
   Else If A_IsUnicode
      RunWait "C:\Program Files\AutoHotkey\AutoHotkeyU32_UIA.exe" "%A_ScriptFullPath%"
   Else
      RunWait "C:\Program Files\AutoHotkey\AutoHotkeyA32_UIA.exe" "%A_ScriptFullPath%"
}
*/
#SingleInstance Ignore
#MaxThreadsPerHotkey 2
DetectHiddenWindows, On
SetBatchLines -1
SetWinDelay -1
OnExit, Uninitialize
gosub !q
return

!q::
if !Windy_CurWin_id
{
  hTarget := WinExist("A")
}
else
{
  hTarget := Windy_CurWin_id
  Windy_CurWin_id := ""
}
if (hTarget = hTargetPrev)
{
   hTargetPrev := ""
   count--
   return
}
count++
hTargetPrev := hTarget
if (hGui = "")
{
   DllCall("LoadLibrary", "str", "magnification.dll")
   DllCall("magnification.dll\MagInitialize")
   Matrix := "-1|0|0|0|0|"
           . "0|-1|0|0|0|"
           . "0|0|-1|0|0|"
           . "0|0|0|1|0|"
           . "1|1|1|0|1"
   VarSetCapacity(MAGCOLOREFFECT, 100, 0)
   Loop, Parse, Matrix, |
      NumPut(A_LoopField, MAGCOLOREFFECT, (A_Index - 1) * 4, "float")
   loop 2
   {
      if (A_Index = 2)
         Gui, %A_Index%: +AlwaysOnTop   ; needed for ZBID_UIACCESS
      Gui, %A_Index%: +HWNDhGui%A_Index% -DPIScale +toolwindow -Caption +E0x02000000 +E0x00080000 +E0x20 ;  WS_EX_COMPOSITED := E0x02000000  WS_EX_LAYERED := E0x00080000  WS_EX_CLICKTHROUGH := E0x20
      hChildMagnifier%A_Index% := DllCall("CreateWindowEx", "uint", 0, "str", "Magnifier", "str", "MagnifierWindow", "uint", WS_CHILD := 0x40000000, "int", 0, "int", 0, "int", 0, "int", 0, "ptr", hGui%A_Index%, "uint", 0, "ptr", DllCall("GetWindowLong" (A_PtrSize=8 ? "Ptr" : ""), "ptr", hGui%A_Index%, "int", GWL_HINSTANCE := -6 , "ptr"), "uint", 0, "ptr")
      DllCall("magnification.dll\MagSetColorEffect", "ptr", hChildMagnifier%A_Index%, "ptr", &MAGCOLOREFFECT)
   }
}
Gui, 2: Show, NA   ; needed for removing flickering
hGui := hGui1
hChildMagnifier := hChildMagnifier1
loop
{
   if (count != 1)   ; target window changed
   {
      if (count = 2)
         count--
      WinHide, ahk_id %hGui%
      return
   }
   VarSetCapacity(WINDOWINFO, 60, 0)
   if (DllCall("GetWindowInfo", "ptr", hTarget, "ptr", &WINDOWINFO) = 0) and (A_LastError = 1400)   ; destroyed
   {
      count--
      WinHide, ahk_id %hGui%
      return
   }
   if (NumGet(WINDOWINFO, 36, "uint") & 0x20000000) or !(NumGet(WINDOWINFO, 36, "uint") & 0x10000000)  ; minimized or not visible
   {
      if (wPrev != 0)
      {
         WinHide, ahk_id %hGui%
         wPrev := 0
      }
      sleep 10
      continue
   }
   x := NumGet(WINDOWINFO, 20, "int")
   y := NumGet(WINDOWINFO, 8, "int")
   w := NumGet(WINDOWINFO, 28, "int") - x
   h := NumGet(WINDOWINFO, 32, "int") - y
   if (hGui = hGui1) and ((NumGet(WINDOWINFO, 44, "uint") = 1) or (DllCall("GetAncestor", "ptr", WinExist("A"), "uint", GA_ROOTOWNER := 3, "ptr") = hTarget))   ; activated
   {
      hGui := hGui2
      hChildMagnifier := hChildMagnifier2
      WinMove, ahk_id %hGui%,, x, y, w, h
      WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
      WinShow, ahk_id %hChildMagnifier%
      WinShow, ahk_id %hGui%
      hideGui := hGui1
   }
   else if (hGui = hGui2) and (NumGet(WINDOWINFO, 44, "uint") != 1) and ((hr := DllCall("GetAncestor", "ptr", WinExist("A"), "uint", GA_ROOTOWNER := 3, "ptr")) != hTarget) and hr   ; deactivated
   {
      hGui := hGui1
      hChildMagnifier := hChildMagnifier1
      WinMove, ahk_id %hGui%,, x, y, w, h
      WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
      WinShow, ahk_id %hChildMagnifier%
      DllCall("SetWindowPos", "ptr", hGui, "ptr", hTarget, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0040|0x0010|0x001|0x002)
      DllCall("SetWindowPos", "ptr", hTarget, "ptr", 1, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0040|0x0010|0x001|0x002)   ; some windows can not be z-positioned before setting them to bottom
      DllCall("SetWindowPos", "ptr", hTarget, "ptr", hGui, "int", 0, "int", 0, "int", 0, "int", 0, "uint", 0x0040|0x0010|0x001|0x002)
      hideGui := hGui2 
   }
   else if (x != xPrev) or (y != yPrev) or (w != wPrev) or (h != hPrev)   ; location changed
   {
      WinMove, ahk_id %hGui%,, x, y, w, h
      WinMove, ahk_id %hChildMagnifier%,, 0, 0, w, h
      WinShow, ahk_id %hChildMagnifier%
      WinShow, ahk_id %hGui%
   }
   if (A_PtrSize = 8)
   {
      VarSetCapacity(RECT, 16, 0)
      NumPut(x, RECT, 0, "int")
      NumPut(y, RECT, 4, "int")
      NumPut(w, RECT, 8, "int")
      NumPut(h, RECT, 12, "int")
      DllCall("magnification.dll\MagSetWindowSource", "ptr", hChildMagnifier, "ptr", &RECT)
   }
   else
      DllCall("magnification.dll\MagSetWindowSource", "ptr", hChildMagnifier, "int", x, "int", y, "int", w, "int", h)
   xPrev := x, yPrev := y, wPrev := w, hPrev := h
   if hideGui
   {
      WinHide, ahk_id %hideGui%
      hideGui := ""
   }
}
return

Uninitialize:
if (hGui != "")
   DllCall("magnification.dll\MagUninitialize")
ExitApp
