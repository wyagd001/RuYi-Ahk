;来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=96765&sid=0fd812781855bbe230c9449de71ce312
; Click the middle button to shrink window - support multiple windows and display contents dynamically.
; 鼠标中键点击窗口后微缩——支持多窗口并可动态显示窗口内容。

#NoEnv
#SingleInstance Ignore
SetBatchLines -1
CoordMode, Mouse, Screen
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e97b.png"
SysGet, SM_CXSIZEFRAME, 32
SysGet, SM_CYSIZEFRAME, 33
SM_CXSIZEFRAME:=SM_CXSIZEFRAME="" ? 0 : SM_CXSIZEFRAME
SM_CYSIZEFRAME:=SM_CYSIZEFRAME="" ? 0 : SM_CYSIZEFRAME
GuiLable:=0, Windows:={}
OnExit, ExitShrink
SetTimer, Repaint, 100

Windy_CurWin_id := A_Args[1]
zoom := A_Args[2]
if !Windy_CurWin_id
{
	DetectHiddenWindows, On
	WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
}
if Windy_CurWin_id
{
	WinGetClass, MouseClass, % "ahk_id " Win
	Win := Windy_CurWin_id
	gosub 窗口动态微缩
}
OnMessage(0x4a, "Receive_WM_COPYDATA")
return

Receive_WM_COPYDATA(wParam, lParam)
{
	Global Win
	StringAddress := NumGet(lParam + 2*A_PtrSize)  ; 获取 CopyDataStruct 的 lpData 成员.
	Win := StrGet(StringAddress)  ; 从结构中复制字符串.
	;tooltip % Win " - 1000" 
	SetTimer 窗口动态微缩, -300 
return true
}

!q::
  MouseGetPos, x, y, Win
  WinGetClass, MouseClass, % "ahk_id " Win
窗口动态微缩:
  ; Ignore specific windows
  If (MouseClass ~= "Progman|WorkerW|Windows.UI.Core.CoreWindow|Shell_TrayWnd") {
    return
  }
  
  if (Windows.HasKey("h" Win))
	{
		;MsgBox % Win
    RestoreShrink("h" Win)
	}
  else
  {
    zoom:=zoom?zoom:0.5

    WinSet, ExStyle, +0x00000080, ahk_id %Win%
    WinSet, Transparent, 0,       ahk_id %Win%
    WinGetPos, , , sw, sh,        ahk_id %Win%

    ratio:=sw/sh, dw:=sw*zoom, dh:=dw/ratio, GuiLable+=1
		if !dw or !dh
			return
    Gui, %GuiLable%:+LabelMyGui +ToolWindow +AlwaysOnTop +Border +HwndShrinkID  ; -Caption
    Gui, %GuiLable%:Show,Center w%dw% h%dh%, 微缩窗口

    dest_hdc   := DllCall("GetDC", "UInt", ShrinkID)
    source_hdc := DllCall("GetWindowDC", "UInt", Win)
    DllCall("gdi32\SetStretchBltMode", "UPtr", dest_hdc, "Int", 4)

      Windows["h" ShrinkID, "GuiLable"]   := GuiLable
    , Windows["h" ShrinkID, "hwnd"]       := Win
    , Windows["h" ShrinkID, "source_hdc"] := source_hdc
    , Windows["h" ShrinkID, "dest_hdc"]   := dest_hdc
    , Windows["h" ShrinkID, "sw"]         := sw
    , Windows["h" ShrinkID, "sh"]         := sh
    , Windows["h" ShrinkID, "dw"]         := dw
    , Windows["h" ShrinkID, "dh"]         := dh
  }
return

Repaint:
  for k, v in Windows
    DllCall("gdi32\StretchBlt"
          , "UInt", v.dest_hdc
          , "Int",  0
          , "Int",  0
          , "Int",  v.dw
          , "Int",  v.dh
          , "UInt", v.source_hdc
          , "UInt", SM_CXSIZEFRAME
          , "UInt", 0
          , "Int",  v.sw-2*SM_CXSIZEFRAME
          , "Int",  v.sh-SM_CYSIZEFRAME
          , "UInt", 0xCC0020)
return

ExitShrink:
  SetTimer, Repaint, Off
  for k, v in Windows.Clone()
    RestoreShrink(k)
  ExitApp
return

RestoreShrink(Win)
{
  global Windows
  o:=Windows[Win], GuiLable:=o.GuiLable
	;FileAppend, %GuiLable%-%Win%`n, %A_Desktop%\123.txt

  WinSet, ExStyle, -0x00000080, % "ahk_id " o.hwnd   ; 窗口窄标题栏, 任务栏没按钮
  WinSet, Transparent, 255,     % "ahk_id " o.hwnd
  WinSet, Transparent, Off,     % "ahk_id " o.hwnd
  WinSet, Redraw, ,             % "ahk_id " o.hwnd
  WinActivate,                  % "ahk_id " o.hwnd

  DllCall("gdi32\DeleteDC", "UInt", o.dest_hdc)
  DllCall("gdi32\DeleteDC", "UInt", o.source_hdc)
  Gui, %GuiLable%:Destroy

  Windows.Delete(Win)
}

MyGuiclose:
UniqueID := WinExist("A")
for k,v in Windows
{
	;MsgBox % Windows[k].GuiLable
	if (k = "h" UniqueID)
	{
		RestoreShrink(k)
		break
	}
}
i := 0
for k,v in Windows
{
	i++
}
if !i
	exitapp
return

/*
!w::
for k, v in Windows.Clone()
MsgBox % k
return

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd) {
	static init := OnMessage(0x0201, "WM_LButtonDOWN")
	PostMessage, 0xA1, 2,,, A
}
*/