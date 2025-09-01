;|2.9|2024.12.7|1695
#Include <AutoXYWH>
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

StrCountLines(str)
{
	if(!str)
		return 0
	
	strlfs := RegExReplace(str, "[^\n]", "")
	return strlen(strlfs)+1
}