﻿;|2.8|2024.09.20|1297
CandySel := A_Args[1]

Gui,66: Destroy
Gui,66: Default
Gui, +Resize
Gui, Add, text, x10 y10, 文件夹:
Gui, Add, edit, xp+70 y10 w550 h25 vfolder1, % CandySel
Gui, Add, Button, xp+560 yp h25 gfolderfilelist default, 文件列表
Gui, Add, text, x10 yp+40, 排序选项:
Gui, Add, DropDownList, xp+70 yp-3 w80 h120 vlistordermode, 默认||创建日期|修改日期|文件大小
Gui, Add, DropDownList, xp+90 yp w80 h60 vlistorderR, 升序||降序
Gui, Add, CheckBox, xp+90 yp h30 vdelfolderpath gdelfolderpath, 只显示相对路径(删除文件夹的路径)
Gui, Add, Edit, x10 yp+40 Multi readonly w690 r20 vmyedit
Gui, Show, AutoSize, 文件夹文件列表
sleep 300
if CandySel
	Gosub folderfilelist
return

folderfilelist:
Gui,66: Default
Gui, Submit, NoHide
Gtext := getfolderfilelist(folder1, listordermode, listorderR)
if delfolderpath
	Gtext := StrReplace(Gtext, CandySel "\")
GuiControl,, myedit, %Gtext%
Gtext := ""
Return

delfolderpath:
Gui,66: Default
Gui, Submit, NoHide
if delfolderpath
{
	Gtext := StrReplace(myedit, CandySel "\")
}
else
{
	Gtext := ""
	Loop, parse, myedit, `n, `r
	{
		line_str := CandySel "\" A_LoopField
		Gtext .= line_str "`r`n"
	}

}
GuiControl,, myedit, %Gtext%
return

getfolderfilelist(sfolder, optionmode := "", optionR := "")
{
	optstr2 := 0
	if (optionmode = "默认")
	{
		Loop, Files, %sfolder%\*.*, DFR  ; 包含文件
		{
			tmp_Str .= A_LoopFileLongPath "`n"
			if (A_index > 500)
				break
		}
	}
	Else if (optionmode = "创建日期")
	{
		Loop, Files, %sfolder%\*.*, DFR  ; 包含文件
		{
			tmp_Str .= A_LoopFileTimeCreated "`t" A_LoopFileLongPath "`n"
			if (A_index > 500)
				break
		}
	}
	Else if (optionmode = "修改日期")
	{
		Loop, Files, %sfolder%\*.*, DFR  ; 包含文件
		{
			tmp_Str .= A_LoopFileTimeModified "`t" A_LoopFileLongPath "`n"
			if (A_index > 500)
				break
		}
	}
	Else if (optionmode = "文件大小")
	{
		Loop, Files, %sfolder%\*.*, DFR  ; 包含文件
		{
			tmp_Str .= A_LoopFileSize "`t" A_LoopFileLongPath "`n"
			if (A_index > 500)
				break
		}
		optstr2 := 1
	}

	if !optstr2 
	{
		if (optionR = "升序")
			Sort, tmp_Str
		Else if (optionR = "降序")
			Sort, tmp_Str, R
	}
	if optstr2 
	{
		if (optionR = "升序")
			Sort, tmp_Str, N
		Else if (optionR = "降序")
			Sort, tmp_Str, N R
	}

	if (optionmode = "默认")
		Return tmp_Str
	Loop, Parse, tmp_Str, `n
	{
		if (A_LoopField = "")  ; 忽略列表末尾的最后一个换行符(空项).
			continue
		StringSplit, FileItem, A_LoopField, %A_Tab%  ; 用 tab 作为分隔符将其分为两部分.
		FileList .= FileItem2 "`n"
	}
	Return FileList
}

66GuiClose:
66Guiescape:
Gui, 66: Destroy
exitapp

66GuiSize:
If (A_EventInfo = 1) ; The window has been minimized.
	Return
AutoXYWH("wh", "myedit")
return

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