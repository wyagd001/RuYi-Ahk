;|2.9|2024.12.7|1695
;==============================================================
; 2016-09-27: devmgmt.msc hotkeys
;==============================================================
Windy_CurWin_id := A_Args[1]

if Is_mmc_window(Windy_CurWin_id)
  devmgmt_DetailTabShowAllProperties()
return

Is_mmc_window(Winid := "")
{
	return dev_IsExeActive("mmc.exe", Winid)
}

dev_IsExeActive(exefile, Winid := "")
{
	; exefilename sample :
	; 	"notepad.exe"
	; or 
	;   "D:\portableapps\MPC-HC-Portable\App\MPC-HC\mpc-hc.exe"
	if Winid
    Awinid := Winid
  else
    Awinid := dev_GetActiveHwnd() ; cache active window unique id
	WinGet, exepath, ProcessPath, ahk_id %Awinid%

	if(InStr(exefile, "\"))
	{
		; consider exefile as fullpath, need exact match
		if(exepath==exefile)
			return true
		else
			return false
	}
	else
	{
		; consider exefile as filenam only, match only final component.
		if( StrIsEndsWith(exepath, "\" . exefile) )
			return true
		else
			return false
	}
}

StrIsEndsWith(str, suffix, anycase:=false)
{
	if(anycase)
	{
		StringLower, str, str
		StringLower, prefix, prefix
	}
	
	suffix_len := strlen(suffix)
	if(suffix_len==0)
		return false
	if(substr(str, 1-suffix_len)==suffix)
		return true
	else
		return false
}

dev_GetActiveHwnd()
{
	WinGet, Awinid, ID, A
	return Awinid
}

devmgmt_IsViewingDetailTab(Awinid)
{
	; Surprise! This can succeed as long as the/a device property dialog is open 
	; and you have displayed the Details tab at least once.
	
	; Check Combobox1(device property list) exists and there is at least 10 entries.
	ControlGet, otext, List, , Combobox1, ahk_id %Awinid%
	if(!otext)
		return false

	lines := StrCountLines(otext)
	if(lines<10)
		return false

	ControlGet, otext, List, , SysListView321, ahk_id %Awinid%
	if(!otext)
		return false

	return true
}

#If Is_mmc_window()
F12:: devmgmt_DetailTabShowAllProperties()
#If ;Is_mmc_window()

devmgmt_DetailTabShowAllProperties()
{
	WinGet, Awinid, ID, A ; cache active window unique id
	WinGetTitle, title, ahk_id %Awinid%

	if(!devmgmt_IsViewingDetailTab(Awinid))
	{
		Msgbox, % "devmgmt.ahk: You're not viewing a device property Details tab."
		return false
	}
	
	text_result := "== " . title . " ==`n`n"

	; Iterate each Combobox1(device property list) item, and grab each corresponding ListView321 text.

	ControlGet, all_props, List,, Combobox1, ahk_id %Awinid%
	count_props := StrCountLines(all_props)

	Loop, %count_props%
	{
		Control, Choose, %A_Index%, Combobox1, ahk_id %Awinid%

		ControlGetText, text_prop, Combobox1, ahk_id %Awinid%
		ControlGet, text_val, List, , SysListView321, ahk_id %Awinid%
		
		text_result .= A_Index . ".[" . text_prop . "]`n" . text_val . "`n`n"
	}

;	dev_WriteLogFile("_log1.txt", text_result, true)
;	dev_SetClipboardWithTimeout(text_result)
;	Msgbox, % title . " (" . count_props . " items) sent to clipboard." 
GuiText(text_result, Title)

}

; Q: How can I avoid using the *exclusive* GuiEscape label, and at the same time
; allow multiple popups of the my GUI window?
DevmpGuiClose:
DevmpGuiEscape:
	; This enables ESC to close AHK window.
	Gui, Devmp:Destroy
	return 

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
;             add a 't' to DimSize to tell AutoXYWH that the controls in cList are on/in a tab3 control
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
;   AutoXYWH("t x h0.5", "Btn1")
; ---------------------------------------------------------------------------------
; Version: 2020-5-20 / small code improvements (toralf)
;          2018-1-31 / added a line to prevent warnings (pramach)
;          2018-1-13 / added t option for controls on Tab3 (Alguimist)
;          2015-5-29 / added 'reset' option (tmplinshi)
;          2014-7-03 / mod by toralf
;          2014-1-02 / initial version tmplinshi
; requires AHK version : 1.1.13.01+    due to SprSplit()
; =================================================================================

AutoXYWH(DimSize, cList*){   ;https://www.autohotkey.com/boards/viewtopic.php?t=1079
  Static cInfo := {}

  If (DimSize = "reset")
    Return cInfo := {}

  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If !cInfo.hasKey(ctrlID) {
      ix := iy := iw := ih := 0	
      GuiControlGet i, %A_Gui%: Pos, %ctrl%
      MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
      fx := fy := fw := fh := 0
      For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) 
        If !RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)
          f%dim% := 1

      If (InStr(DimSize, "t")) {
        GuiControlGet hWnd, %A_Gui%: hWnd, %ctrl%
        hParentWnd := DllCall("GetParent", "Ptr", hWnd, "Ptr")
        VarSetCapacity(RECT, 16, 0)
        DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", &RECT)
        DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", &RECT, "UInt", 1)
        ix := ix - NumGet(RECT, 0, "Int")
        iy := iy - NumGet(RECT, 4, "Int")
      }

      cInfo[ctrlID] := {x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a, m:MMD}
    } Else {
      dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw, dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
      Options := ""
      For i, dim in cInfo[ctrlID]["a"]
        Options .= dim (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) A_Space
      GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
} } }

StrCountLines(str)
{
	if(!str)
		return 0
	
	strlfs := RegExReplace(str, "[^\n]", "")
	return strlen(strlfs)+1
}
