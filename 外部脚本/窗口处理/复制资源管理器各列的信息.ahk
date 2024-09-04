;|2.1|2023.07.01|1302
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e16d.ico"
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	WinGetTitle, h_hwnd, 获取当前窗口信息
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !Windy_CurWin_id
		Windy_CurWin_id := WinExist("A")
	if !CandySel or !Windy_CurWin_id
		exitapp
}

WinGetClass, vWinClass, % "ahk_id " Windy_CurWin_id
if !(vWinClass = "CabinetWClass") && !(vWinClass = "ExploreWClass")
	exitapp

oWin := JEE_ExpWinGetObj(Windy_CurWin_id)
JEE_ExpGetInterfaces(oWin, isp, isb, isv, ifv2, icm)
vOutput := JEE_ICMGetColumns(icm, ",",, 1) ; 1 得到的是中文名称例如 名称  ; 0 得到的英文名称例如  System.ItemNameDisplay
isp := isb := isv := ifv2 := icm := ""
ColItem_Array := StrSplit(vOutput, ",")   
;MsgBox % vOutput   ; 例如: 名称,修改日期,类型,大小,创建日期

tmp_str := ""
Loop, Parse, CandySel, `n, `r
{
	obj := Filexpro(A_LoopField,, ColItem_Array*)   ; 传递中文名称
	tmp_fileinfo := ""
	loop % ColItem_Array.Length()
	{
		tmp_fileinfo .= obj[ColItem_Array[A_Index]] "`t"
	}
	tmp_str .= tmp_fileinfo "`n"
}
GuiText(tmp_str, "选中文件各列信息", 500)
tmp_str := ""
return

JEE_ExpWinGetObj(hWnd)
{
	for oWin in ComObjCreate("Shell.Application").Windows
		if (oWin.HWND == hWnd)
			break
	return oWin
}

;来源网址: https://www.autohotkey.com/boards/viewtopic.php?p=153957#p153957
;==================================================

;e.g. JEE_ExpGetInterfaces(oWin, isp, isb, isv, ifv2, icm)
;e.g. isp := isb := isv := ifv2 := icm := ""
JEE_ExpGetInterfaces(oWin, ByRef isp="", ByRef isb="", ByRef isv="", ByRef ifv2="", ByRef icm="")
{
	isp := ComObjQuery(oWin, "{6d5140c1-7436-11ce-8034-00aa006009fa}")
	, isb := ComObjQuery(isp, "{4C96BE40-915C-11CF-99D3-00AA004AE837}", "{000214E2-0000-0000-C000-000000000046}")
	if (DllCall(NumGet(NumGet(isb+0)+15*A_PtrSize), Ptr,isb, PtrP,isv) < 0) ;QueryActiveShellView
		return
	ifv2 := ComObjQuery(isv, "{1af3a467-214f-4298-908e-06b03e0b39f9}")
	icm := ComObjQuery(ifv2, "{d8ec27bb-3f3b-4042-b10a-4acfd924d453}")
}

;==================================================

;custom abbreviation to canonical property name
JEE_ExpColAbbrevToName(vList, vDelim="`n")
{
	oArray := {nam:"System.ItemNameDisplay"
	,siz:"System.Size"
	,typ:"System.ItemTypeText"
	,mod:"System.DateModified"
	,cre:"System.DateCreated"
	,acc:"System.DateAccessed"
	,dat:"System.ItemDate"
	,dur:"System.Calendar.Duration"
	,dim:"System.Image.Dimensions"
	,len:"System.Media.Duration"}

	vOutput := ""
	Loop, Parse, vList, % vDelim
		vOutput .= ((A_Index = 1) ? "" : vDelim) oArray[A_LoopField]
	return vOutput
}

;==================================================

;IColumnManager interface (Windows)
;https://msdn.microsoft.com/en-us/library/windows/desktop/bb776149(v=vs.85).aspx
;methods (8): C:\Program Files (x86)\Windows Kits\8.1\Include\um\ShObjIdl.h

;==================================================

JEE_ICMGetColumnCount(icm, vMode="")
{
	vFlags := InStr(vMode, "a") ? 0x1 : 0x2
	;CM_ENUM_VISIBLE := 0x2 ;CM_ENUM_ALL := 0x1
	DllCall(NumGet(NumGet(icm+0)+5*A_PtrSize), Ptr,icm, UInt,vFlags, UIntP,vCountCol) ;GetColumnCount
	return vCountCol
}

;==================================================

;mode: n (get name), c (get CLSID and property identifier), a (get all)
JEE_ICMGetColumns(icm, vSep="`n", vMode="n", vzh_Name:=0)
{
	vFlags := InStr(vMode, "a") ? 0x1 : 0x2
	DllCall(NumGet(NumGet(icm+0)+5*A_PtrSize), Ptr,icm, UInt,vFlags, UIntP,vCountCol) ;GetColumnCount
	vOutput := ""
	VarSetCapacity(vOutput, vCountCol*100*2)
	vOutput := ""
	;CM_ENUM_VISIBLE := 0x2 ;CM_ENUM_ALL := 0x1
	vArrayPROPERTYKEY := ""
	VarSetCapacity(vArrayPROPERTYKEY, vCountCol*20, 0)
	DllCall(NumGet(NumGet(icm+0)+6*A_PtrSize), Ptr,icm, UInt,vFlags, Ptr,&vArrayPROPERTYKEY, UInt,vCountCol) ;GetColumns
	Loop, % vCountCol
	{
		vOffset := (A_Index-1)*20
		if InStr(vMode, "c")
		{
			DllCall("ole32\StringFromCLSID", Ptr,&vArrayPROPERTYKEY+vOffset, PtrP,vAddrCLSID)
			vCLSID := StrGet(vAddrCLSID, "UTF-16")
			vNum := NumGet(vArrayPROPERTYKEY, vOffset+16, "UInt")
			vOutput .= vCLSID " " vNum
		}
		if InStr(vMode, "n")
		{
			if InStr(vMode, "c")
				vOutput .= "`t"
			DllCall("propsys\PSGetNameFromPropertyKey", Ptr,&vArrayPROPERTYKEY+vOffset, PtrP,vAddrName)
			vName := StrGet(vAddrName, "UTF-16")
			;MsgBox % Vname
			if vzh_Name
			{
				;if (A_OSVersion != "WIN_7")  ; win 10 测试有效
				;	vName := JEE_ICMGetColumnInfo_ZhName(icm, vName)
				;if (A_OSVersion = "WIN_7")
					vName := JEE_IPropertyDescription_ZhName(vName)
			}
			vOutput .= vName
		}
		vOutput .= vSep
	}
	vOutput := SubStr(vOutput, 1, -StrLen(vSep))
	return vOutput
}

; https://learn.microsoft.com/zh-cn/windows/win32/api/shobjidl_core/nf-shobjidl_core-icolumnmanager-getcolumninfo
; https://learn.microsoft.com/zh-cn/windows/win32/api/shobjidl_core/ns-shobjidl_core-cm_columninfo
/*
typedef struct CM_COLUMNINFO {
  DWORD cbSize;
  DWORD dwMask;
  DWORD dwState;
  UINT  uWidth;
  UINT  uDefaultWidth;
  UINT  uIdealWidth;
  WCHAR wszName[80];
} CM_COLUMNINFO;
*/
; https://learn.microsoft.com/en-us/windows/win32/api/shobjidl_core/ne-shobjidl_core-cm_mask
; https://learn.microsoft.com/en-us/windows/win32/api/propsys/nf-propsys-psgetpropertykeyfromname
; https://learn.microsoft.com/en-us/windows/win32/api/wtypes/ns-wtypes-propertykey

JEE_ICMGetColumnInfo_ZhName(icm, vName)
{
	VarSetCapacity(PROPERTYKEY, 20, 0)
	DllCall("propsys\PSGetPropertyKeyFromName", "Ptr", &vName, "Ptr", &PROPERTYKEY)
	;MsgBox % NumGet(PROPERTYKEY, 0, "UInt")
	;MsgBox % NumGet(PROPERTYKEY, 16, "UInt")
	VarSetCapacity(CM_COLUMNINFO, 184, 0)
	NumPut(184, CM_COLUMNINFO, 0, "UInt") ;cbSize
	;CM_MASK_WIDTH := 0x1 ;CM_MASK_IDEALWIDTH := 0x4
	NumPut(0x1F, CM_COLUMNINFO, 4, "UInt") ;dwMask
	; win7 32  7FFF0001  2147418113
	; win10 64  0
	DllCall(NumGet(NumGet(icm+0)+4*A_PtrSize), "Ptr", icm, "Ptr", &PROPERTYKEY, "Ptr", &CM_COLUMNINFO) ;GetColumnInfo
;MsgBox % ErrorLevel 
	;MsgBox % NumGet(CM_COLUMNINFO, 0, "UInt") ;uIdealWidth
	;MsgBox % NumGet(CM_COLUMNINFO, 4, "UInt")
;MsgBox % NumGet(CM_COLUMNINFO, 8, "UInt")
;MsgBox % NumGet(CM_COLUMNINFO, 12, "UInt")
;MsgBox % NumGet(CM_COLUMNINFO, 16, "UInt")
;MsgBox % NumGet(CM_COLUMNINFO, 20, "UInt")
;MsgBox % StrGet(&CM_COLUMNINFO+24, 160, "UTF-8")
;MsgBox % StrGet(&CM_COLUMNINFO+24, 160, "CP936")
	return StrGet(&CM_COLUMNINFO+24, 160, "UTF-16")
}

JEE_IPropertyDescription_ZhName(vName)
{
	VarSetCapacity(IID_IPropertyDescription, 16)
DllCall("ole32\CLSIDFromString", "WStr", "{6f79d558-3e96-4549-a1d1-7d75d2288814}", "Ptr", &IID_IPropertyDescription)

; use PSGetPropertyDescription for the same from an already-initialised PROPERTYKEY
if (!DllCall("propsys\PSGetPropertyDescriptionByName", "WStr", vName, "Ptr", &IID_IPropertyDescription, "Ptr*", iprop)) { 
	if (!DllCall(NumGet(NumGet(iprop+0)+6*A_PtrSize), "Ptr", iprop, "Ptr*", pszDisplayName)) { ; IPropertyDescription::GetDisplayName
		DisplayName := StrGet(pszDisplayName, "UTF-16")
		DllCall("ole32\CoTaskMemFree", "Ptr", pszDisplayName)
	}
	ObjRelease(iprop)
	Return DisplayName
}
Return
}
;==================================================

JEE_ICMSetColumns(icm, vList, vSep="`n")
{
	DllCall(NumGet(NumGet(icm+0)+5*A_PtrSize), Ptr,icm, UInt,vFlags, UIntP,vCountCol) ;GetColumnCount
	vList := StrReplace(vList, vSep, vSep, vCountCol)
	vCountCol++
	vArrayPROPERTYKEY := ""
	VarSetCapacity(vArrayPROPERTYKEY, vCountCol*20, 0)
	Loop, Parse, vList, % vSep
	{
		vOffset := (A_Index-1)*20
		DllCall("propsys\PSGetPropertyKeyFromName", Str,A_LoopField, Ptr,&vArrayPROPERTYKEY+vOffset)
	}
	DllCall(NumGet(NumGet(icm+0)+7*A_PtrSize), Ptr,icm, Ptr,&vArrayPROPERTYKEY, UInt,vCountCol) ;SetColumns
	return
}

;==================================================

;not working (error 0x8000FFFF)
;is 'ideal' width, the autosize width?
JEE_ICMGetColumnWidth(icm, vName, ByRef vWidthIdeal="")
{
	VarSetCapacity(PROPERTYKEY, 20, 0)
	DllCall("propsys\PSGetPropertyKeyFromName", Ptr,&vName, Ptr,&PROPERTYKEY)
	VarSetCapacity(CM_COLUMNINFO, 184, 0)
	NumPut(184, CM_COLUMNINFO, 0, "UInt") ;cbSize
	;CM_MASK_WIDTH := 0x1 ;CM_MASK_IDEALWIDTH := 0x4
	NumPut(0x5, CM_COLUMNINFO, 4, "UInt") ;dwMask
	DllCall(NumGet(NumGet(icm+0)+4*A_PtrSize), Ptr,icm, Ptr,&PROPERTYKEY, Ptr,&CM_COLUMNINFO) ;GetColumnInfo
	vWidthIdeal := NumGet(CM_COLUMNINFO, 20, "UInt") ;uIdealWidth
	return NumGet(CM_COLUMNINFO, 12, "UInt") ;uWidth
}

;==================================================

JEE_ICMSetColumnWidth(icm, vName, vWidth)
{
	VarSetCapacity(PROPERTYKEY, 20, 0)
	DllCall("propsys\PSGetPropertyKeyFromName", Ptr,&vName, Ptr,&PROPERTYKEY)
	VarSetCapacity(CM_COLUMNINFO, 184, 0)
	NumPut(184, CM_COLUMNINFO, 0, "UInt") ;cbSize
	;CM_MASK_WIDTH := 0x1
	NumPut(0x1, CM_COLUMNINFO, 4, "UInt") ;dwMask
	NumPut(vWidth, CM_COLUMNINFO, 12, "UInt") ;dwMask
	DllCall(NumGet(NumGet(icm+0)+3*A_PtrSize), Ptr,icm, Ptr,&PROPERTYKEY, Ptr,&CM_COLUMNINFO) ;SetColumnInfo
}

;==================================================

;IFolderView2 interface (Windows)
;https://msdn.microsoft.com/en-us/library/windows/desktop/bb775541(v=vs.85).aspx
;methods (42): C:\Program Files (x86)\Windows Kits\8.1\Include\um\ShObjIdl.h

;==================================================

JEE_IFV2GetSortColumnCount(ifv2)
{
	DllCall(NumGet(NumGet(ifv2+0)+26*A_PtrSize), Ptr,ifv2, IntP,vCountCol) ;GetSortColumnCount
	return vCountCol
}

;==================================================

JEE_IFV2GetSortColumns(ifv2, vSep="`n", vMode="n")
{
	DllCall(NumGet(NumGet(ifv2+0)+26*A_PtrSize), Ptr,ifv2, IntP,vCountCol) ;GetSortColumnCount
	vOutput := ""
	vArraySORTCOLUMN := ""
	VarSetCapacity(vArraySORTCOLUMN, vCountCol*24, 0)
	DllCall(NumGet(NumGet(ifv2+0)+28*A_PtrSize), Ptr,ifv2, Ptr,&vArraySORTCOLUMN, Int,vCountCol) ;GetSortColumns
	Loop, % vCountCol
	{
		vOffset := (A_Index-1)*24
		if (vMode = "n")
		{
			DllCall("propsys\PSGetNameFromPropertyKey", Ptr,&vArraySORTCOLUMN+vOffset, PtrP,vAddrName)
			vName := StrGet(vAddrName, "UTF-16")
			;SORT_ASCENDING := 1 ;SORT_DESCENDING := -1
			vDirection := NumGet(vArraySORTCOLUMN, vOffset+20, "Int")
			vOutput .= vName " " vDirection vSep
		}
		else if (vMode = "c")
		{
			DllCall("ole32\StringFromCLSID", Ptr,&vArraySORTCOLUMN+vOffset, PtrP,vAddrCLSID)
			vCLSID := StrGet(vAddrCLSID, "UTF-16")
			vNum := NumGet(vArraySORTCOLUMN, vOffset+16, "UInt")
			vDirection := NumGet(vArraySORTCOLUMN, vOffset+20, "Int")
			vOutput .= vCLSID " " vNum " " vDirection vSep
		}
	}
	vOutput := SubStr(vOutput, 1, -StrLen(vSep))
	return vOutput
}

;==================================================

JEE_IFV2SetSortColumns(ifv2, vList, vSep="`n")
{
	vList := StrReplace(vList, vSep, vSep, vCountCol)
	vCountCol++
	vArraySORTCOLUMN := ""
	VarSetCapacity(vArraySORTCOLUMN, vCountCol*24, 0)
	Loop, Parse, vList, % vSep
	{
		vOffset := (A_Index-1)*24
		vPos := InStr(A_LoopField, " ", 0, -1)
		vName := SubStr(A_LoopField, 1, vPos-1)
		vDirection := SubStr(A_LoopField, vPos+1)
		DllCall("propsys\PSGetPropertyKeyFromName", Str,vName, Ptr,&vArraySORTCOLUMN+vOffset)
		;SORT_ASCENDING := 1 ;SORT_DESCENDING := -1
		NumPut(vDirection, vArraySORTCOLUMN, vOffset+20, "Int")
	}
	DllCall(NumGet(NumGet(ifv2+0)+27*A_PtrSize), Ptr,ifv2, Ptr,&vArraySORTCOLUMN, Int,vCountCol) ;SetSortColumns
}

;==================================================
/*
; 注意一些信息无法正确获取, 如 "日期", 请使用其他值来代替
Parameters:

sFile: Filepath. Relative path will be resolved to fullpath. Function will return null if Root drive is passed.
Kind: Optional. The "kind" of file. Eg: Music Picture etc. The function will test for Kind before attempting to retrieve properties.
*p: Varadic parameters. Pass property names as strings. I'm able to pass 1317 element linear array as params.
if last variadic parameter is xInfo the function will return extra file props like A_LoopFileExt, A_LoopFileFullPath etc
*/
Filexpro( sFile := "", Kind := "", P* ) {           ; v.90 By SKAN on D1CC @ goo.gl/jyXFo9
Local
Static xDetails 

  If ( sFile = "" )
    {                                                           ;   Deinit static variable
        xDetails := ""
        Return
    }
  
  fex := {}, _FileExt := "" 

  Loop, Files, % RTrim(sfile,"\*/."), DF 
    {
        If not FileExist( sFile:=A_LoopFileLongPath )
          {
              Return
          } 

        SplitPath, sFile, _FileExt, _Dir, _Ext, _File, _Drv

        If ( p[p.length()] = "xInfo" )                          ;  Last parameter is xInfo 
          {
              p.Pop()                                           ;         Delete parameter
              fex.SetCapacity(11)                               ; Make room for Extra info
              fex["_Attrib"]    := A_LoopFileAttrib
              fex["_Dir"]       := _Dir
              fex["_Drv"]       := _Drv
              fex["_Ext"]       := _Ext
              fex["_File"]      := _File
              fex["_File.Ext"]  := _FileExt
              fex["_FilePath"]  := sFile
              fex["_FileSize"]  := A_LoopFileSize
              fex["_FileTimeA"] := A_LoopFileTimeAccessed
              fex["_FileTimeC"] := A_LoopFileTimeCreated
              fex["_FileTimeM"] := A_LoopFileTimeModified
          }              
        Break            
    }

  If Not ( _FileExt )                                   ;    Filepath not resolved
    {
        Return
    }        

  
  objShl := ComObjCreate("Shell.Application")
  objDir := objShl.NameSpace(_Dir) 
  objItm := objDir.ParseName(_FileExt) 
                                                                
  If ( VarSetCapacity(xDetails) = 0 )                           ;     Init static variable
    {
        i:=-1,  xDetails:={},  xDetails.SetCapacity(309)
        
        While ( i++ < 328 )
          {
              xDetails[ objDir.GetDetailsOf(0,i) ] := i   ; 获取名称的数组(得到的是中文的名称)
          } 

        xDetails.Delete("")
    }

  If ( Kind and Kind <> objDir.GetDetailsOf(objItm,11) )        ;  File isn't desired kind  
    {
        Return
    }

  i:=0,  nParams:=p.Count(),  fex.SetCapacity(nParams + 11) 

  While ( i++ < nParams )
    {
        Prop := p[i]
        ; MsgBox % xDetails[Prop] " - " prop
        If ( PropNum := xDetails[Prop] ) > -1
          {
              if (Prop = "大小")
							{
	                FileGetSize, OutputVar, % sFile
                  fex[Prop] := Ceil(OutputVar / 1024) "KB"
							}
              Else
                  fex[Prop] := ObjDir.GetDetailsOf(objItm, PropNum)
              Continue 
          }

        ;  时间会与当地时间差8个小时
        If ( (Dot:=InStr(Prop,".")) and (Prop:=(Dot=1 ? "System":"") . Prop) )
          {
              fex[Prop] := objItm.ExtendedProperty(Prop)   
              Continue 
          }
    }
  
  fex.SetCapacity(-1)
Return fex  

}

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