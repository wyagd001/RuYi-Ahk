;|2.9|2025.01.20|1714
#InstallKeybdHook
#include <Gdip>
pToken := Gdip_Startup()
OnClipboardChange("Callback")
curclip := []
curclip_Text := []
curclip_Pic := []
curclip_File := []
12ClipArr := [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5], [6, 6], [7, 7], [8, 8], [9, 9], [10, 10], [11, 11], [12, 12]]
;tooltip % 12ClipArr[2][2]
GUI +AlwaysOnTop +ToolWindow +E0x08000000 +hwndhGui
GUI, Add, Pic, x10 y10 w64 h64 gcopytoclip vhclip Icon71, shell32.dll
GUI, Add, Pic, xp+70 yp w64 h64 gcopytoclip vhtext Icon71, shell32.dll
GUI, Add, Pic, xp+70 yp w64 h64 gcopytoclip vhpic Icon326, shell32.dll
GUI, Add, Pic, xp+70 yp w64 h64 gcopytoclip vhfile Icon4, shell32.dll
GUI, Add, Text, x50 y75 gshowclipmenu vhclipm, ▽
gui, Show, w280 Center NoActivate, 剪贴板中转站
OnMessage(0x0200, "WM_MOUSEMOVE")

;-- DragDrop flags
DRAGDROP_S_DROP   := 0x40100 ; 262400
DRAGDROP_S_CANCEL := 0x40101 ; 262401
;-- DROPEFFECT flags
DROPEFFECT_NONE := 0 ;-- Drop target cannot accept the data.
DROPEFFECT_COPY := 1 ;-- Drop results in a copy. The original data is untouched by the drag source.
DROPEFFECT_MOVE := 2 ;-- Drag source should remove the data.
DROPEFFECT_LINK := 4 ;-- Drag source should create a link to the original data.
;-- Key state values (grfKeyState parameter)
MK_LBUTTON := 0x01   ;-- The left mouse button is down.
MK_RBUTTON := 0x02   ;-- The right mouse button is down.
MK_SHIFT   := 0x04   ;-- The SHIFT key is down.
MK_CONTROL := 0x08   ;-- The CTRL key is down.
MK_MBUTTON := 0x10   ;-- The middle mouse button is down.
MK_ALT     := 0x20   ;-- The ALT key is down.

IDT_LV := IDropTarget_Create(hGui, "_LV", -1)

Gui,2: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs +HwndhPreview
Gui,2: Show, NA
maxStr:=200, maxW:=500, maxH:=500
hbm  := CreateDIBSection(maxW, maxH)
hdc  := CreateCompatibleDC()
obm  := SelectObject(hdc, hbm)
G    := Gdip_GraphicsFromHDC(hdc)
Gdip_SetInterpolationMode(G, 0)
return

GuiClose:
IDT_LV.RevokeDragDrop()
Gui Destroy
exitapp
return

showclipmenu:
show_obj(12ClipArr)
return

WM_MOUSEMOVE()
{
  Gui,1: Default
  static CurrControl, PrevControl
  global hPreview, curclip, curclip_Pic, curclip_File, curclip_Text, hdc, pBitmap

  CurrControl := A_GuiControl
  ;msgbox % A_GuiControl " | " CurrControl " | " PrevControl
    If (CurrControl != PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip  ; 关闭之前的工具提示.
        SetTimer, DisplayToolTip, 1000
        PrevControl := CurrControl
    }
    return

    DisplayToolTip:
    SetTimer, DisplayToolTip, Off

    tooltip % CurrControl " | " curclip[1][1]
    if (CurrControl = "hpic") or ((CurrControl = "hclip") && (curclip[1][1] = "图片"))
    {
      pBitmap := curclip_Pic[1][2]
      gosub displaypic
    }
    else if (CurrControl = "hfile") or ((CurrControl = "hclip") && (curclip[1][1] = "文件"))
    {
      tooltip % SubStr(curclip_File[1][2], 1, 200)
    }
    else if (CurrControl = "htext") or ((CurrControl = "hclip") && (curclip[1][1] = "文本"))
    {
      tooltip % SubStr(curclip_Text[1][2], 1, 200)
    }
    SetTimer, RemoveToolTip, 3000
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    UpdateLayeredWindow(hPreview, hdc, , , , , 0)
    return
}


copytoclip:
;Gui, Submit, NoHide
;tooltip % A_GuiControl
if (A_GuiControl = "htext")
{
  if (curclip[1][1] != "文本")
  {
    if curclip_Text[1][2]
    {
      sleep 20
      try Clipboard := ""
      sleep 20
      try Clipboard := curclip_Text[1][2]
      curclip[1] := ["文本", curclip_Text[1][2]]
      GuiControl,, hclip, *icon71 *w64 *h64 shell32.dll
    }
    else
      return
  }
  else
  {
    if (clipboard != curclip_Text[1][2])
    {
      try Clipboard := curclip_Text[1][2]
    }
  }
}
if (A_GuiControl = "hfile")
{
  if (curclip[1][1] != "文件")
  {
    if curclip_File[1][2]
    {
      sleep 20
      try Clipboard := ""
      sleep 20
      try FileToClipboard(curclip_File[1][2])
      curclip[1] := ["文件", curclip_File[1][2]]
      GuiControl,, hclip, *icon4 *w64 *h64 shell32.dll
    }
    else
      return
  }
  else
  {
    tooltip 文件123123
  }
}
if (A_GuiControl = "hpic") && (curclip[1][1] != "图片")
{
  if curclip_Pic[1][2]
  {
    不记录 := 1
    Gdip_SetBitmapToClipboard(curclip_Pic[1][2])
    curclip[1] := ["图片", curclip_Pic[1][2]]
    GuiControl,, hclip, *icon326 *w64 *h64 shell32.dll
  }
  else
    return
}

/*
if ((A_GuiControl = "hclip")
{
  if (curclip[1][1] = "文本")
  {
    if (Clipboard != curclip_Text[1][2])
    {
      sleep 20
      try Clipboard := ""
      sleep 20
      try Clipboard := curclip_Text[1][2]
    }
  }
  else if (curclip[1][1] = "文件")
  {
    if (Clipboard != curclip_File[1][2])
    {
      sleep 20
      try Clipboard := ""
      sleep 20
      try FileToClipboard(curclip_File[1][2])
      ;tooltip "文件"
    }
  }
  else if (curclip[1][1] = "图片")
  {
    if (Clipboard != curclip_File[1][2])
    {
      sleep 20
      try Clipboard := ""
      sleep 20
      try FileToClipboard(curclip_File[1][2])
      ;tooltip "文件"
    }
  }
}
*/
tooltip % curclip[1][1] "`n" curclip_File[1][2]
if (A_GuiControl = "hfile") or ((A_GuiControl = "hclip") && (curclip[1][1] = "文件"))
{
  Cursors := []
  Cursors[1] := DllCall("LoadCursor", "Ptr", 0, "Ptr", 32515, "UPtr") ; DROPEFFECT_COPY = IDC_CROSS
  Cursors[2] := DllCall("LoadCursor", "Ptr", 0, "Ptr", 32516, "UPtr") ; DROPEFFECT_MOVE = IDC_UPARROW
  Cursors[3] := DllCall("LoadCursor", "Ptr", 0, "Ptr", 32648, "UPtr") ; Copy or Move = IDC_NO
  ;MsgBox, % DoDragDrop(Cursors)
  DoDragDrop(Cursors)
  return
}

CursorHandle := DllCall("LoadCursorFromFile", "Str", A_ScriptDir "\..\..\脚本图标\Cross.CUR")
DllCall("SetSystemCursor", "Uint", CursorHandle, "Int", 32512)

SetTimer, GetPos2, 300
KeyWait, LButton
SetTimer, GetPos2, Off
DllCall("SystemParametersInfo", "UInt", 0x57, "UInt", 0, UInt, 0, UInt, 0)

if WinActive("ahk_id " TmpWin)
  send ^v
else
{
  WinActivate ahk_id %TmpWin%
  send ^v
}
return

;不记录 := 1
;tooltip % Gdip_SetBitmapToClipboard(12ClipArr[A_ThisMenuItemPos][2])
;tooltip % "图片句柄 " 12ClipArr[A_ThisMenuItemPos][2]
;GuiControl,, hclip, *icon326 *w64 *h64 shell32.dll
;curclip_Pic[1] := ["图片", 12ClipArr[A_ThisMenuItemPos][2]]

GetPos2:
MouseGetPos,,, TmpWin
;tooltip %TmpWin%
return

show_obj(obj, menu_name := "")
{
	if menu_name =
	{
		main = 1
		Random, rand, 100000000, 999999999
		menu_name = %A_Now%%rand%
	}
	;Menu, % menu_name, add,
	;Menu, % menu_name, DeleteAll
	for k,v in obj
	{
    if (v[1] = "文本")
    {
      if strlen(v[2]) > 20
        menuname := k ". " SubStr0(LTrim(v[2], " `t`r`n"), 1, 10) "..." SubStr0(RTrim(v[2], " `t`r`n"), -10)
      else
        menuname := k ". " LTrim(v[2], " `t`r`n")
      Menu, % menu_name, add, % menuname, MenuHandler
      Menu, % menu_name, Icon, % menuname, shell32.dll, 71
    }
    else if (v[1] = "文件")
    {
      if strlen(v[2]) > 20
        menuname := k ". " SubStr0(LTrim(v[2], " `t`r`n"), 1, 10) "..." SubStr0(RTrim(v[2], " `t`r`n"), -10)
      else
        menuname := k ". " LTrim(v[2], " `t`r`n")
      Menu, % menu_name, add, % menuname, MenuHandler
      Menu, % menu_name, Icon, % menuname, shell32.dll, 4
    }
    else if (v[1] = "图片")
    {
      Menu, % menu_name, add, % menuname := k ". " SubStr0(LTrim(v[2], " `t`r`n"), 1, 10), MenuHandler
      Menu, % menu_name, Icon, % menuname, shell32.dll, 326
    }
    else
    {
      Menu, % menu_name, add, % k ". " v[2], MenuHandler
    }
	}
	if main = 1
		menu, % menu_name, show
	return
}

MenuHandler:
;tooltip % 12ClipArr[A_ThisMenuItemPos][1]
if (12ClipArr[A_ThisMenuItemPos][1] = "文本")
{
  if (Clipboard != 12ClipArr[A_ThisMenuItemPos][2])
  {
    try Clipboard := ""
    sleep 20
    try Clipboard := 12ClipArr[A_ThisMenuItemPos][2]
    GuiControl,, hclip, *icon71 *w64 *h64 shell32.dll
    curclip_Text[1] := ["文本", Clipboard]
    curclip[1] := ["文本", Clipboard]
    tooltip % SubStr(Clipboard, 1, 200)
    Sleep 2000
    tooltip
  }
}
else if (12ClipArr[A_ThisMenuItemPos][1] = "文件")
{
  if (Clipboard != 12ClipArr[A_ThisMenuItemPos][2])
  {
    try Clipboard := ""
    sleep 20
    ;Clipboard := 12ClipArr[A_ThisMenuItemPos][2]       ; 切换后不具有文件属性
    FileToClipboard(12ClipArr[A_ThisMenuItemPos][2])
    GuiControl,, hclip, *icon4 *w64 *h64 shell32.dll
    curclip_File[1] := ["文件", 12ClipArr[A_ThisMenuItemPos][2]]
    curclip[1] := ["文件", 12ClipArr[A_ThisMenuItemPos][2]]
  }
}
else if (12ClipArr[A_ThisMenuItemPos][1] = "图片")
{
  不记录 := 1
  Gdip_SetBitmapToClipboard(pBitmap := 12ClipArr[A_ThisMenuItemPos][2])
  ;tooltip % "图片句柄 " 12ClipArr[A_ThisMenuItemPos][2]
  GuiControl,, hclip, *icon326 *w64 *h64 shell32.dll
  curclip_Pic[1] := ["图片", pBitmap]
  curclip[1] := ["图片", pBitmap]
  gosub displaypic
  Sleep 2000
  UpdateLayeredWindow(hPreview, hdc, , , , , 0)
}
return

displaypic:
Width   := Gdip_GetImageWidth(pBitmap)
Height  := Gdip_GetImageHeight(pBitmap)
ratio   := Width/Height

if (ratio>=1)
{
  dw:=maxW
  dh:=dw/ratio
}
else
{
  dh:=maxH
  dw:=ratio*dh
}

Gdip_DrawImage(G, pBitmap, 0, 0, dw, dh)
MouseGetPos, OutputVarX, OutputVarY
UpdateLayeredWindow(hPreview, hdc, OutputVarX+16, OutputVarY+16, dw, dh)
return

Callback(DataType)
{
  global 12ClipArr, 不记录, curclip, curclip_Text, curclip_Pic, curclip_File
  if (DataType = 1)
  {
    for k,v in 12ClipArr
    {
      if (v[2] = Clipboard)   ; 重复值不添加
      {
        ;tooltip 重复值%Clipboard%
        return
      }
    }
    if !DllCall( "IsClipboardFormatAvailable", "UInt", 15)
    {
      12ClipArr.Insertat(1, ["文本", Clipboard])
      12ClipArr.Pop()
      curclip_Text[1] := ["文本", Clipboard]
      curclip[1] := ["文本", Clipboard]
      GuiControl,, hclip, *icon71 *w64 *h64 shell32.dll
    }
    else
    {
      12ClipArr.Insertat(1, ["文件", Clipboard])
      12ClipArr.Pop()
      curclip_File[1] := ["文件", Clipboard]
      curclip[1] := ["文件", Clipboard]
      GuiControl,, hclip, *icon4 *w64 *h64 shell32.dll
    }
  }
  else if (DataType = 2)
  {
    if 不记录
    {
      不记录 := 0
      return
    }
    pBitmap := Gdip_CreateBitmapFromClipboard()
    if (pBitmap > 1)
    {
      12ClipArr.Insertat(1, ["图片", pBitmap])
      12ClipArr.Pop()
      curclip_Pic[1] := ["图片", pBitmap]
      curclip[1] := ["图片", pBitmap]
      GuiControl,, hclip, *icon326 *w64 *h64 shell32.dll
    }
  }
  ;Tooltip % DataType " - " 12ClipArr[1][1]
}

;https://www.autohotkey.com/board/topic/23162-how-to-copy-a-file-to-the-clipboard/page-4
;https://www.autohotkey.com/boards/viewtopic.php?f=76&t=45870
;https://www.autohotkey.com/boards/viewtopic.php?f=76&t=6799
FileToClipboard(FilesPath, DropEffect := "Copy")
{
	Static TCS := A_IsUnicode ? 2 : 1 ; size of a TCHAR
	Static PreferredDropEffect := DllCall("RegisterClipboardFormat", "Str", "Preferred DropEffect")
	Static DropEffects := {1: 1, 2: 2, Copy: 1, Move: 2}
	; -------------------------------------------------------------------------------------------------------------------
	; Count files and total string length
	TotalLength := 0
	FileArray := []
	Loop, Parse, FilesPath, `n, `r
	{
		If (Length := StrLen(A_LoopField))
			FileArray.Push({Path: A_LoopField, Len: Length + 1})
		TotalLength += Length
	}
	FileCount := FileArray.Length()
	If !(FileCount && TotalLength)
		Return False
	; -------------------------------------------------------------------------------------------------------------------
	; Add files to the clipboard
	If DllCall("OpenClipboard", "Ptr", A_ScriptHwnd) && DllCall("EmptyClipboard")
	{
		; HDROP format ---------------------------------------------------------------------------------------------------
		; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
		hDrop := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 20 + (TotalLength + FileCount + 1) * TCS, "UPtr")
		pDrop := DllCall("GlobalLock", "Ptr" , hDrop)
		Offset := 20
		NumPut(Offset, pDrop + 0, "UInt")         ; DROPFILES.pFiles = offset of file list
		NumPut(!!A_IsUnicode, pDrop + 16, "UInt") ; DROPFILES.fWide = 0 --> ANSI, fWide = 1 --> Unicode
		For Each, File In FileArray
			Offset += StrPut(File.Path, pDrop + Offset, File.Len) * TCS
		DllCall("GlobalUnlock", "Ptr", hDrop)
		DllCall("SetClipboardData","UInt", 0x0F, "UPtr", hDrop) ; 0x0F = CF_HDROP
/*
DROPEFFECT_NONE  0   放置目标不能接受数据。
DROPEFFECT_COPY  1   删除会导致副本。 原始数据不受拖动源影响。
DROPEFFECT_MOVE  2   拖动源应删除数据。
DROPEFFECT_LINK  4   拖动源应创建指向原始数据的链接。
*/
		; Preferred DropEffect format ------------------------------------------------------------------------------------
		If (DropEffect := DropEffects[DropEffect])
		{
			; Write Preferred DropEffect structure to clipboard to switch between copy/cut operations
			; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
			hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 4, "UPtr")
			pMem := DllCall("GlobalLock", "Ptr", hMem)
			NumPut(DropEffect, pMem + 0, "UChar")
			DllCall("GlobalUnlock", "Ptr", hMem)
			DllCall("SetClipboardData", "UInt", PreferredDropEffect, "Ptr", hMem)
		}
		DllCall("CloseClipboard")
		Return True
	}
	Return False
}
/*
GuiDropFiles:
12ClipArr.Insertat(1, ["文件", A_GuiEvent])
12ClipArr.Pop()
curclip_File[1] := ["文件", A_GuiEvent]
GuiControl,, hclip, *icon4 *w64 *h64 shell32.dll
return
*/
GetClipboardFormatName(nFormat)
{
  VarSetCapacity(sFormat, 255)
  DllCall("GetClipboardFormatName", "Uint", nFormat, "str", sFormat, "Uint", 256)
  Return sFormat
}

;Read real text (=not filenames, when CF_HDROP is in clipboard) from clipboard
ReadClipboardText()
{
  ; CF_TEXT = 1 ;CF_UNICODETEXT = 13
  If((!A_IsUnicode && DllCall("IsClipboardFormatAvailable", "Uint", 1)) || (A_IsUnicode && DllCall("IsClipboardFormatAvailable", "Uint", 13)))
  {
    DllCall("OpenClipboard", "Ptr", 0)
    htext:=DllCall("GetClipboardData", "Uint", A_IsUnicode ? 13 : 1, "Ptr")
    ptext := DllCall("GlobalLock", "Ptr", htext)
    text := StrGet(pText, A_IsUnicode ? "UTF-16" : "cp0")
    DllCall("GlobalUnlock", "Ptr", htext)
    DllCall("CloseClipboard")
  }
  Return text
}

;q::
;FileAppend, %ClipboardAll%, % A_Desktop "\debug.bin"
;return

StrLenW(String)
{
	RegExReplace(String, "(?:[^[:ascii:]]{2}|[[:ascii:]])", "", ErrorLevel)
return ErrorLevel
}

SubStr0(String, Pos0, Len0 = 360, StrCheck = 3)
{
	If (Pos0 <> 1 && Pos0+StrLen(String) <> 1 && StrLenW(String0 := SubStr(String, 1, Pos0 > 0 ? Pos0-1 : StrLen(String) + Pos0 - 1)) = StrLenW(SubStr(String0, 1, StrLen(String0)-1)))
		Len0 := Mod(StrCheck, 2) = 1 ? Len0 + 1 : Pos0 = 0 ? 0 : Len0 - 1, Pos0 := Mod(StrCheck, 2) = 1 ? Pos0 - 1 : Pos0 + 1
return SubStr(String, Pos0, (StrLenW(SubStr(String, Pos0, Len0-1)) = StrLenW(SubStr(String, Pos0, Len0))) ? StrCheck // 2 = 1 ? Len0+1 : Len0-1 : Len0)
}

DeBugBin(ByRef Var, Size := 20, FileName := "")
{
	if !FileName
		FilePath := A_Desktop "\debug.bin"
	else
	{
		If !instr(fileName, "\")
			FilePath := A_Desktop "\" FileName
		else
			FilePath := FileName
	}
	File := FileOpen(FilePath, "rw")
	hSize := File.RawWrite(Var, Size)
	File.Close()
	return hSize
}

GetClipboardFormat(type=1)  ;Thanks nnnik
{
	Critical, On  
	DllCall("OpenClipboard", "int", "")
	while c := DllCall("EnumClipboardFormats", "Int", c?c:0)
		x .= "," c
	DllCall("CloseClipboard")
	Critical, OFF    ; 在开始执行段使用该函数，使所有后续线程变为不可中断，脚本会卡死，所以需要关闭
	if (type=1)
  {
		if Instr(x, ",1") and (Instr(x, ",13") or Instr(x, "13,"))
    {
      ;tooltip 文本
      return 1
    }
		else If Instr(x, ",15")
    {
      ;ToolTip % "值为2: " x
      return 2
    }
		else
    {
      ;CF_ToolTip("空值 " x, 3000)   ; 文件剪切时, 显示空值 
      return ""
    }
  }
	else
  {
    ;CF_ToolTip(x, 3000)
		return x
  }
}
; DllCall("IsClipboardFormatAvailable", "UInt", 15) ; 判断是否是文件类型

IEnumFormatEtc(this)
{
    DllCall(NumGet(NumGet(1*this)+8*A_PtrSize),"Uint",this,"Uint",1,"UintP",penum) ; DATADIR_GET=1, DATADIR_SET=2
    Loop
    {
        VarSetCapacity(FormatEtc, A_PtrSize = 8 ? 32 : 20, 0)
        If  DllCall(NumGet(NumGet(1*penum)+A_PtrSize * 3), "Ptr", penum, "Uint",1, "Ptr", &FormatEtc, "Uint",0)
            Break
        0+(nFormat:=NumGet(FormatEtc,0,"Ushort"))<18 ? RegExMatch(__cfList, "(?:\w+\s+){" . nFormat-1 . "}(?<FORMAT>\w+\b)", CF_) : nFormat>=0x80&&nFormat<=0x83 ? RegExMatch("CF_OWNERDISPLAY CF_DSPTEXT CF_DSPBITMAP CF_DSPMETAFILEPICT", "(?:\w+\s+){" . nFormat-0x80 . "}(?<FORMAT>\w+\b)", CF_) : nFormat=0x8E ? CF_FORMAT:="CF_DSPENHMETAFILE" : CF_FORMAT:=GetClipboardFormatName(nFormat)
        VarSetCapacity(StgMedium,A_PtrSize * 3,0)
        If  DllCall(NumGet(NumGet(1*this)+A_PtrSize * 3), "Ptr", this, "Ptr", &FormatEtc, "Ptr", &StgMedium)
            Continue
        If  NumGet(StgMedium,0)=1   ; TYMED_HGLOBAL=1
        {
            hData:=NumGet(StgMedium,A_PtrSize)
            pData:=DllCall("GlobalLock", "Uint", hData)
            nSize:=DllCall("GlobalSize", "Uint", hData)
            VarSetCapacity(sData,1023), DllCall("wsprintf", "str", sData, "str", (DllCall("advapi32\IsTextUnicode", "Uint", pData, "Uint", nSize, "Uint", 0) & A_IsUnicode) ? "%s" : "%S", "Uint", pData, "Cdecl")
            DllCall("GlobalUnlock", "Uint", hData)

            If (CF_FORMAT = "FileNameW")
                FileNameW := sData
        }
        Else {
            RegExMatch("TYMED_NULL TYMED_FILE TYMED_ISTREAM TYMED_ISTORAGE TYMED_GDI TYMED_MFPICT TYMED_ENHMF", "(?:\w+\s+){" . Floor(ln(NumGet(StgMedium)+1)/ln(2)) . "}(?<STGMEDIUM>\w+\b)", TYMED_)
        }
    
        DllCall("ole32\ReleaseStgMedium","Uint",&StgMedium)
    }
    DllCall(NumGet(NumGet(1*penum)+2*A_PtrSize), "Uint", penum)
    Return FileNameW
}

; #Include DoDragDrop.ahk
; Drop user function called by IDropTarget on drop
; ==================================================================================================================================
IDropTargetOnDrop_LV(TargetObject, pDataObj, KeyState, X, Y, DropEffect) {
   ; Standard clipboard formats
   Static CF := {1:  "CF_TEXT"
               , 2:  "CF_BITMAP"
               , 3:  "CF_METAFILEPICT"
               , 4:  "CF_SYLK"
               , 5:  "CF_DIF"
               , 6:  "CF_TIFF"
               , 7:  "CF_OEMTEXT"
               , 8:  "CF_DIB"
               , 9:  "CF_PALETTE"
               , 10: "CF_PENDATA"
               , 11: "CF_RIFF"
               , 12: "CF_WAVE"
               , 13: "CF_UNICODETEXT"
               , 14: "CF_ENHMETAFILE"
               , 15: "CF_HDROP"
               , 16: "CF_LOCALE"
               , 17: "CF_DIBV5"
               , 0x0080: "CF_OWNERDISPLAY"
               , 0x0081: "CF_DSPTEXT"
               , 0x0082: "CF_DSPBITMAP"
               , 0x0083: "CF_DSPMETAFILEPICT"
               , 0x008E: "CF_DSPENHMETAFILE"}
   ; TYMED enumeration
   Static TM := {1:  "HGLOBAL"
               , 2:  "FILE"
               , 4:  "ISTREAM"
               , 8:  "ISTORAGE"
               , 16: "GDI"
               , 32: "MFPICT"
               , 64: "ENHMF"}
   Static CF_NATIVE := A_IsUnicode ? 13 : 1 ; CF_UNICODETEXT  : CF_TEXT
   ; "Private" formats don't get GlobalFree()'d
   Static CF_PRIVATEFIRST := 0x0200
   Static CF_PRIVATELAST  := 0x02FF
   ; "GDIOBJ" formats do get DeleteObject()'d
   Static CF_GDIOBJFIRST  := 0x0300
   Static CF_GDIOBJLAST   := 0x03FF
   ; "Registered" formats
   Static CF_REGISTEREDFIRST := 0xC000
   Static CF_REGISTEREDLAST  := 0xFFFF
  global 12ClipArr, curclip_File, curclip, curclip_Text
   Gui, +OwnDialogs
   ; IDataObject_SetPerformedDropEffect(pDataObj, DropEffect)
   If (pEnumObj := IDataObject_EnumFormatEtc(pDataObj)) {
      While IEnumFORMATETC_Next(pEnumObj, FORMATETC) {
         IDataObject_ReadFormatEtc(FORMATETC, Format, Device, Aspect, Index, Type)
         TYMED := "NONE"
         For Index, Value In TM {
            If (Type & Index) {
               TYMED := Value
               Break
            }
         }
         If (Format >= CF_REGISTEREDFIRST) && (Format <= CF_REGISTEREDLAST) {
            VarSetCapacity(Name, 520, 0)
            If !DllCall("GetClipboardFormatName", "UInt", Format, "Str", Name, "UInt", 260)
               Name := "*REGISTERED"
         }
         Else If (Format >= CF_GDIOBJFIRST) && (Format <= CF_GDIOBJLAST)
            Name := "*GDIOBJECT"
         Else If (Format >= CF_PRIVATEFIRST) && (Format <= CF_PRIVATELAST)
            Name := "*PRIVATE"
         Else If !(Name := CF[Format])
            Name := "*UNKNOWN"
         IDataObject_GetData(pDataObj, FORMATETC, Size, Data)
         If (Size = -1)
            Size := "N/S"
         ; Example for getting values out of the returned binary Data
         Value := "N/S"
         If Format In 1,7,13,15,16
         {
            If (Format = CF_NATIVE)       ; CF_TEXT or CF_UNICODETEXT
            {
              Value := StrGet(&Data)
              12ClipArr.Insertat(1, ["文本", Value])
                  12ClipArr.Pop()
                  curclip_Text[1] := ["文本", Value]
curclip[1] := ["文本", Value]
                  GuiControl,, hclip, *icon71 *w64 *h64 shell32.dll
return
            }
            Else If (Format = 16)         ; CF_LOCALE
               Value := NumGet(Data, "UInt")
            Else If (Format = 15) {       ; CF_HDROP
               ;LV_Add("", A_Index, Format, Name, TYMED, Size, "")
               If IDataObject_GetDroppedFiles(pDataObj, Files) {
                  For Each, File In Files
                  {
                    Tmp_Str .= File "`n"
                  }
                  
                  12ClipArr.Insertat(1, ["文件", Tmp_Str])
                  12ClipArr.Pop()
                  curclip_File[1] := ["文件", Tmp_Str]
curclip[1] := ["文件", Tmp_Str]
                  GuiControl,, hclip, *icon4 *w64 *h64 shell32.dll
                  return
               }
               Continue
            }
         }
         Else If (Size = 4)
            Value := NumGet(Data, 0, "UInt")

         ;LV_Add("", A_Index, Format, Name, TYMED, Size, Value)
      }
      ObjRelease(pEnumObj)
   }
   ;Effect := {0: "NONE", 1: "COPY", 2: "MOVE", 4: "LINK"}[DropEffect]
   ;SB_SetText("   DropEffect: " . Effect)
  ;msgbox % Effect
   ;Return DropEffect
}

; ==================================================================================================================================
; DoDragDrop -> msdn.microsoft.com/en-us/library/ms678486(v=vs.85).aspx
; Requires: IDataObject.ahk, IDropSource.ahk and IDragSourceHelper.ahk
; ==================================================================================================================================
; Carries out an OLE drag and drop operation using the current contents of the clipboard.
; Param1    -  A bitmap handle (HBITMAP) used by IDragSourceHelper_CreateFromBitmap() or
;           -  A window handle (HWND) used by IDragSourceHelper_CreateFromWindow() or
;           -  An array of user-defined cursors to use instead of the default cursors during the drag operation.
;              Index:   Used in case:
;              0        Drop target cannot accept the data.
;              1        Drop results in a copy.
;              2        Drop results in a move.
;              3        Drop results in a copy or move.
; OffCX     -  Cursor offset within the drag image (ignored if Param1 is an array of cursors).
; OffCY     -  Cursor offset within the drag image (ignored if Param1 is an array of cursors).
; ColorKey  -  The color used to fill the background of the drag image (ignored if Param1 isn't a HBITMAP handle).
; Return values:
;     If the data have been dropped successfully, the functions returns the performed drop operation (i.e. 1 for
;     DROPEFFECT_COPY or 2 for DROPEFFECT_MOVE). In all other cases the function returns 0.
;     If DROPEFFECT_MOVE is returned, the drag source should remove the data.
; ==================================================================================================================================
DoDragDrop(Param1 := "", OffCX := 0, OffCY := 0, ColorKey := 0x00FFFFFF) {
   ; DRAGDROP_S_DROP = 0x40100
   Static DropEffects := 0x03 ; DROPEFFECT_COPY | DROPEFFECT_MOVE
   IDS := IDropSource_Create()
   If !DllCall("Ole32.dll\OleGetClipboard", "PtrP", pDataObj, "UInt") {
      IDSH := Bitmap := False
      If IsObject(Param1)
         IDropSource_Cursors := Param1
      Else If (Param1 <> "") {
         If DllCall("IsWindow", "Ptr", Param1, "UInt")
            IDSH := IDragSourceHelper_CreateFromWindow(pDataObj, Param1)
         Else If DoDragDrop_GetBitmapSize(Param1, W, H)
            IDSH := IDragSourceHelper_CreateFromBitmap(pDataObj, Param1, W, H, W // 2, H)
      }
      RC := DllCall("Ole32.dll\DoDragDrop","Ptr", pDataObj, "Ptr", IDS, "UInt", DropEffects, "PtrP", Effect, "Int")
      If IDataObject_GetPerformedDropEffect(pDataObj, PerformedDropEffect)
         Effect := PerformedDropEffect
      ObjRelease(pDataObj)
      If (IDSH)
         ObjRelease(IDSH)
   }
   IDropSource_Free(IDS)
   IDropSource_Cursors := ""
   Return (RC = 0x40100 ? Effect : 0)
}
; ==================================================================================================================================
; Auxiliary functions.
; ==================================================================================================================================
DoDragDrop_GetBitmapSize(HBITMAP, ByRef W, ByRef H) {
   VarSetCapacity(BM, 32, 0)
   If DllCall("GetObject", "Ptr", HBITMAP, "Int", A_PtrSize = 8 ? 32 : 24, "Ptr", &BM, "Int") {
      W := NumGet(BM, 4, "Int"), H := NumGet(BM, 8, "Int")
      Return True
   }
   Return False
}
; ==================================================================================================================================
;#Include *i IDataObject.ahk
; ==================================================================================================================================
; IDataObject interface -> msdn.microsoft.com/en-us/library/ms688421(v=vs.85).aspx
; Partial implementation.
; Requires: IEnumFORMATETC.ahk
; ==================================================================================================================================
IDataObject_GetData(pDataObj, ByRef FORMATETC, ByRef Size, ByRef Data) {
   ; GetData -> msdn.microsoft.com/en-us/library/ms678431(v=vs.85).aspx
   Static GetData := A_PtrSize * 3
   Data := ""
   , Size := -1
   , VarSetCapacity(STGMEDIUM, 24, 0) ; 64-bit
   , pVTBL := NumGet(pDataObj + 0, "UPtr")
   If !DllCall(NumGet(pVTBL + GetData, "UPtr"), "Ptr", pDataObj, "Ptr", &FORMATETC, "Ptr", &STGMEDIUM, "Int") {
      If (NumGet(STGMEDIUM, "UInt") = 1) { ; TYMED_HGLOBAL
         hGlobal := NumGet(STGMEDIUM, A_PtrSize, "UPtr")
         , pGlobal := DllCall("GlobalLock", "Ptr", hGlobal, "UPtr")
         , Size := DllCall("GlobalSize", "Ptr", hGlobal, "UPtr")
         , VarSetCapacity(Data, Size, 0)
         , DllCall("RtlMoveMemory", "Ptr", &Data, "Ptr", pGlobal, "Ptr", Size)
         , DllCall("GlobalUnlock", "Ptr", hGlobal)
         , DllCall("Ole32.dll\ReleaseStgMedium", "Ptr", &STGMEDIUM)
         Return True
      }
      DllCall("Ole32.dll\ReleaseStgMedium", "Ptr", &STGMEDIUM)
   }
   Return False
}
; ==================================================================================================================================
IDataObject_QueryGetData(pDataObj, ByRef FORMATETC) {
   ; QueryGetData -> msdn.microsoft.com/en-us/library/ms680637(v=vs.85).aspx
   Static QueryGetData := A_PtrSize * 5
   pVTBL := NumGet(pDataObj + 0, "UPtr")
   Return !DllCall(NumGet(pVTBL + QueryGetData, "UPtr"), "Ptr", pDataObj, "Ptr", &FORMATETC, "Int")
}
; ==================================================================================================================================
IDataObject_SetData(pDataObj, ByRef FORMATETC, ByRef STGMEDIUM) {
   ; SetData -> msdn.microsoft.com/en-us/library/ms686626(v=vs.85).aspx
   Static SetData := A_PtrSize * 7
   pVTBL := NumGet(pDataObj + 0, "UPtr")
   Return !DllCall(NumGet(pVTBL + SetData, "UPtr"), "Ptr", pDataObj, "Ptr", &FORMATETC, "Ptr", &STGMEDIUM, "Int", True, "Int")
}
; ==================================================================================================================================
IDataObject_EnumFormatEtc(pDataObj, DataDir := 1) {
   ; EnumFormatEtc -> msdn.microsoft.com/en-us/library/ms683979(v=vs.85).aspx
   ; DATADIR_GET = 1, DATADIR_SET = 2
   Static EnumFormatEtc := A_PtrSize * 8
   pVTBL := NumGet(pDataObj + 0, "UPtr")
   If !DllCall(NumGet(pVTBL + EnumFormatEtc, "UPtr"), "Ptr", pDataObj, "UInt", DataDir, "PtrP", ppenumFormatEtc, "Int")
      Return ppenumFormatEtc
   Return False
}
; ==================================================================================================================================
; Auxiliary functions to get/set data of the data object.
; ==================================================================================================================================
; FORMATETC structure -> msdn.microsoft.com/en-us/library/ms682242(v=vs.85).aspx
; ==================================================================================================================================
IDataObject_CreateFormatEtc(ByRef FORMATETC, Format, Aspect := 1, Index := -1, Tymed := 1) {
   ; DVASPECT_CONTENT = 1, Index all data = -1, TYMED_HGLOBAL = 1
   VarSetCapacity(FORMATETC, 32, 0) ; 64-bit
   , NumPut(Format, FORMATETC, 0, "UShort")
   , NumPut(Aspect, FORMATETC, A_PtrSize = 8 ? 16 : 8 , "UInt")
   , NumPut(Index, FORMATETC, A_PtrSIze = 8 ? 20 : 12, "Int")
   , NumPut(Tymed, FORMATETC, A_PtrSize = 8 ? 24 : 16, "UInt")
   Return &FORMATETC
}
; ==================================================================================================================================
IDataObject_ReadFormatEtc(ByRef FORMATETC, ByRef Format, ByRef Device, ByRef Aspect, ByRef Index, ByRef Tymed) {
   Format := NumGet(FORMATETC, OffSet := 0, "UShort")
   , Device := NumGet(FORMATETC, Offset += A_PtrSize, "UPtr")
   , Aspect := NumGet(FORMATETC, Offset += A_PtrSize, "UInt")
   , Index  := NumGet(FORMATETC, Offset += 4, "Int")
   , Tymed  := NumGet(FORMATETC, Offset += 4, "UInt")
}
; ==================================================================================================================================
; Get/Set format data.
; ==================================================================================================================================
IDataObject_GetDroppedFiles(pDataObj, ByRef DroppedFiles) {
   ; msdn.microsoft.com/en-us/library/bb773269(v=vs.85).aspx
   IDataObject_CreateFormatEtc(FORMATETC, 15) ; CF_HDROP
   DroppedFiles := []
   If IDataObject_GetData(pDataObj, FORMATETC, Size, Data) {
      Offset := NumGet(Data, 0, "UInt")
      CP := NumGet(Data, 16, "UInt") ? "UTF-16" : "CP0"
      Shift := (CP = "UTF-16")
      While (File := StrGet(&Data + Offset, CP)) {
         DroppedFiles.Push(File)
         Offset += (StrLen(File) + 1) << Shift
      }
   }
   Return DroppedFiles.Length()
}
; ==================================================================================================================================
IDataObject_GetLogicalDropEffect(pDataObj, ByRef DropEffect) {
   Static LogicalDropEffect := DllCall("RegisterClipboardFormat", "Str", "Logical Performed DropEffect")
   IDataObject_CreateFormatEtc(FORMATETC, LogicalDropEffect)
   DropEffect := ""
   If IDataObject_GetData(pDataObj, FORMATETC, Size, Data) {
      DropEffect := NumGet(Data, "UChar")
      Return True
   }
   Return False
}
; ==================================================================================================================================
IDataObject_GetPerformedDropEffect(pDataObj, ByRef DropEffect) {
   Static PerformedDropEffect := DllCall("RegisterClipboardFormat", "Str", "Performed DropEffect")
   IDataObject_CreateFormatEtc(FORMATETC, PerformedDropEffect)
   DropEffect := ""
   If IDataObject_GetData(pDataObj, FORMATETC, Size, Data) {
      DropEffect := NumGet(Data, "UChar")
      Return True
   }
   Return False
}
; ==================================================================================================================================
IDataObject_GetPreferredDropEffect(pDataObj, ByRef DropEffect) {
   Static PreferredDropEffect := DllCall("RegisterClipboardFormat", "Str", "Preferred DropEffect")
   IDataObject_CreateFormatEtc(FORMATETC, PreferredDropEffect)
   DropEffect := ""
   If IDataObject_GetData(pDataObj, FORMATETC, Size, Data) {
      DropEffect := NumGet(Data, "UChar")
      Return True
   }
   Return False
}
; ==================================================================================================================================
IDataObject_GetText(pDataObj, ByRef Txt) {
   Static CF_NATIVE := A_IsUnicode ? 13 : 1 ; CF_UNICODETEXT : CF_TEXT
   IDataObject_CreateFormatEtc(FORMATETC, CF_NATIVE)
   Txt := ""
   If IDataObject_GetData(pDataObj, FORMATETC, Size, Data) {
      Txt := StrGet(Data, Size >> !!A_IsUnicode)
      Return True
   }
   Return False
}
; ==================================================================================================================================
IDataObject_SetLogicalDropEffect(pDataObj, DropEffect) {
   Static LogicalDropEffect := DllCall("RegisterClipboardFormat", "Str", "Logical Performed DropEffect")
   IDataObject_CreateFormatEtc(FORMATETC, LogicalDropEffect)
   , VarSetCapacity(STGMEDIUM, 24, 0) ; 64-bit
   , NumPut(1, STGMEDIUM, "UInt") ; TYMED_HGLOBAL
   , hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 4, "UPtr") ; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
   , pMem := DllCall("GlobalLock", "Ptr", hMem, "UPtr")
   , NumPut(DropEffect, pMem + 0, "UChar")
   , DllCall("GlobalUnlock", "Ptr", hMem)
   , NumPut(hMem, STGMEDIUM, A_PtrSize, "UPtr")
   Return IDataObject_SetData(pDataObj, FORMATETC, STGMEDIUM)
}
; ==================================================================================================================================
IDataObject_SetPerformedDropEffect(pDataObj, DropEffect) {
   Static PerformedDropEffect := DllCall("RegisterClipboardFormat", "Str", "Performed DropEffect")
   IDataObject_CreateFormatEtc(FORMATETC, PerformedDropEffect)
   , VarSetCapacity(STGMEDIUM, 24, 0) ; 64-bit
   , NumPut(1, STGMEDIUM, "UInt") ; TYMED_HGLOBAL
   , hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 4, "UPtr") ; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
   , pMem := DllCall("GlobalLock", "Ptr", hMem, "UPtr")
   , NumPut(DropEffect, pMem + 0, "UChar")
   , DllCall("GlobalUnlock", "Ptr", hMem)
   , NumPut(hMem, STGMEDIUM, A_PtrSize, "UPtr")
   Return IDataObject_SetData(pDataObj, FORMATETC, STGMEDIUM)
}
; ==================================================================================================================================
IDataObject_SetPreferredDropEffect(pDataObj, DropEffect) {
   Static PreferredDropEffect := DllCall("RegisterClipboardFormat", "Str", "Preferred DropEffect")
   IDataObject_CreateFormatEtc(FORMATETC, PreferredDropEffect)
   , VarSetCapacity(STGMEDIUM, 24, 0) ; 64-bit
   , NumPut(1, STGMEDIUM, "UInt") ; TYMED_HGLOBAL
   , hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 4, "UPtr") ; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
   , pMem := DllCall("GlobalLock", "Ptr", hMem, "UPtr")
   , NumPut(DropEffect, pMem + 0, "UChar")
   , DllCall("GlobalUnlock", "Ptr", hMem)
   , NumPut(hMem, STGMEDIUM, A_PtrSize, "UPtr")
   Return IDataObject_SetData(pDataObj, FORMATETC, STGMEDIUM)
}
; ==================================================================================================================================
IDataObject_SetText(pDataObj, ByRef Txt) {
   Static SizeT := A_IsUnicode ? 2 : 1
   Static CF_NATIVE := A_IsUnicode ? 13 : 1 ; CF_UNICODETEXT : CF_TEXT
   Size := (StrLen(Txt)+ 1) * SizeT
   IDataObject_CreateFormatEtc(FORMATETC, CF_NATIVE)
   , VarSetCapacity(STGMEDIUM, 24, 0) ; 64-bit
   , NumPut(1, STGMEDIUM, "UInt") ; TYMED_HGLOBAL
   , hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", Size, "UPtr") ; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
   , pMem := DllCall("GlobalLock", "Ptr", hMem, "UPtr")
   , StrPut(Txt, pMem + 0)
   , DllCall("GlobalUnlock", "Ptr", hMem)
   , NumPut(hMem, STGMEDIUM, A_PtrSize, "UPtr")
   Return IDataObject_SetData(pDataObj, FORMATETC, STGMEDIUM)
}
; ==================================================================================================================================
IDataObject_SHFileOperation(pDataObj, TargetPath, Operation, HWND := 0) {
   ; SHFileOperation -> msdn.microsoft.com/en-us/library/bb762164(v=vs.85).aspx
   If Operation Not In 1,2
      Return False
   IDataObject_CreateFormatEtc(FORMATETC, 15) ; CF_HDROP
   If IDataObject_GetData(pDataObj, FORMATETC, Size, Data) {
      Offset := NumGet(Data, 0, "UInt") ; offset of the file list
      IsUnicode := NumGet(Data, 16, "UInt") ; 1: Unicode, 0: ANSI
      TargetLen := StrPut(TargetPath, IsUnicode ? "UTF-16" : "CP0") + 2
      VarSetCapacity(Target, TargetLen << !!IsUnicode, 0)
      StrPut(TargetPath, &Target, IsUnicode ? "UTF-16" : "CP0")
      SHFOSLen := A_PtrSize * (A_PtrSize = 8 ? 7 : 8)
      VarSetCapacity(SHFOS, SHFOSLen, 0) ; SHFILEOPSTRUCT
      NumPut(HWND, SHFOS, 0, "UPtr")
      NumPut(Operation, SHFOS, A_PtrSize, "UInt") ; FO_MOVE = 1, FO_COPY = 2, so we have to swap the DropEffect
      NumPut(&Data + Offset, SHFOS, A_PtrSize * 2, "UPtr")
      NumPut(&Target, SHFOS, A_PtrSize * 3, "UPtr")
      NumPut(0x0200, SHFOS, A_PtrSize * 4, "UInt") ; FOF_NOCONFIRMMKDIR
      If (IsUnicode)
         Return DllCall("Shell32.dll\SHFileOperationW", "Ptr", &SHFOS, "Int")
      Else
         Return DllCall("Shell32.dll\SHFileOperationA", "Ptr", &SHFOS, "Int")
   }
}
; ==================================================================================================================================

; ==================================================================================================================================

;#Include *i IDropSource.ahk
; ==================================================================================================================================
; IDropSource interface -> msdn.microsoft.com/en-us/library/ms690071(v=vs.85).aspx
; Note: Right-drag is not supported as yet!
; ==================================================================================================================================
; Super-global object to store user-defined cursors used by IDropSource_GiveFeedback().
; The cursor handles (HCURSOR) for the different drop-effects have to be stored using the following indices:
; 0 : DROPEFFECT_NONE - Drop target cannot accept the data.
; 1 : DROPEFFECT_COPY - Drop results in a copy.
; 2 : DROPEFFECT_MOVE - Drop results in a move.
; 3 : Copy or move.
; 4 : DROPEFFECT_LINK - Drop should result in creating a link.
Global IDropSource_Cursors
; ==================================================================================================================================
IDropSource_Create() {
   Static Methods := ["QueryInterface", "AddRef", "Release", "QueryContinueDrag", "GiveFeedback"]
   Static Params  := [3, 1, 1, 3, 2]
   Static VTBL, Dummy := VarSetCapacity(VTBL, A_PtrSize, 0)
   If (NumGet(VTBL, "UPtr") = 0) {
      VarSetCapacity(VTBL, (Methods.Length() + 2) * A_PtrSize, 0)
      NumPut(&VTBL + A_PtrSize, VTBL, "UPtr")
      For Index, Method In Methods {
         CB := RegisterCallback("IDropSource_" . Method, "", Params[Index])
         NumPut(CB, VTBL, Index * A_PtrSize, "UPtr")
      }
   }
   Return &VTBL
}
; ----------------------------------------------------------------------------------------------------------------------------------
IDropSource_Free(IDropSource) {
   IDropSource := 0
   Return True
}
; ==================================================================================================================================
; The following functions must not be called directly, they are reserved for internal and system use.
; ==================================================================================================================================
IDropSource_QueryInterface(IDropSource, RIID, PPV) {
   ; IUnknown.QueryInterface -> msdn.microsoft.com/en-us/library/ms682521(v=vs.85).aspx
   Static IID := "{00000121-0000-0000-C000-000000000046}", IID_IDropSource := 0
        , Init := VarSetCapacity(IID_IDropSource, 16, 0) + DllCall("Ole32.dll\IIDFromString", "WStr", IID, "Ptr", &IID_IDropSource)
   If DllCall("Ole32.dll\IsEqualGUID", "Ptr", RIID, "Ptr", &IID_IDropSource) {
      NumPut(IDropSource, PPV + 0, "Ptr")
      Return 0 ; S_OK
   }
   Else {
      NumPut(0, PPV + 0, "Ptr")
      Return 0x80004002 ; E_NOINTERFACE
   }
}
; ----------------------------------------------------------------------------------------------------------------------------------
IDropSource_AddRef(IDropSource) {
   ; IUnknown.AddRef -> msdn.microsoft.com/en-us/library/ms691379(v=vs.85).aspx
   ; Reference counting is not needed in this case.
   Return 1
}
; ----------------------------------------------------------------------------------------------------------------------------------
IDropSource_Release(IDropSource) {
   ; IUnknown.Release -> msdn.microsoft.com/en-us/library/ms682317(v=vs.85).aspx
   ; Reference counting is not needed in this case.
   Return 0
}
; ----------------------------------------------------------------------------------------------------------------------------------
IDropSource_QueryContinueDrag(IDropSource, fEscapePressed, grfKeyState) {
   ; QueryContinueDrag -> msdn.microsoft.com/en-us/library/ms690076(v=vs.85).aspx
   ; DRAGDROP_S_CANCEL : S_OK : DRAGDROP_S_DROP
   Return (fEscapePressed ? 0x40101 : (grfKeyState & 0x01) ? 0 : 0x40100)
}
; ----------------------------------------------------------------------------------------------------------------------------------
IDropSource_GiveFeedback(IDropSource, dwEffect) {
   ; GiveFeedback -> msdn.microsoft.com/en-us/library/ms693723(v=vs.85).aspx
   If (DragCursor := IDropSource_Cursors[dwEffect & 0x07]) {
      DllCall("SetCursor", "Ptr", DragCursor)
      Return 0
   }
   Return 0x40102 ; DRAGDROP_S_USEDEFAULTCURSORS
}
; ==================================================================================================================================

;#Include *i IDragSourceHelper.ahk
; ==================================================================================================================================
; IDragSourceHelper interface -> msdn.microsoft.com/en-us/library/bb762034(v=vs.85).aspx
; CLSID_DragDropHelper     "{4657278A-411B-11D2-839A-00C04FD918D0}"
; IID_IDropSourcetHelper   "{DE5BF786-477A-11D2-839D-00C04FD918D0}"
; Both methods need a suitable data object to work. Otherwise, the VTBL calls will return E_FAIL.
; ==================================================================================================================================
; Initializes the drag-image manager for a windowless control.
; ==================================================================================================================================
IDragSourceHelper_CreateFromBitmap(pDataObj, HBITMAP, Width, Height, ColorKey := 0x00FFFFFF, OffCX := 0, OffCY := 0) {
   Static InitializeFromBitmap := A_PtrSize * 3
   VarSetCapacity(SHDI, 32, 0) ; SHDRAGIMAGE structure, 64-bit size
   NumPut(Width, SHDI, 0, "Int")
   NumPut(Height, SHDI, 4, "Int")
   NumPut(Width // 2, SHDI, 8, "Int")
   NumPut(Height, SHDI, 12, "Int")
   NumPut(HBITMAP, SHDI, 16, "UPtr")
   NumPut(ColorKey, SHDI, 16 + A_PtrSize, "UInt")
   If (pIDSH := ComObjCreate("{4657278A-411B-11D2-839A-00C04FD918D0}", "{DE5BF786-477A-11D2-839D-00C04FD918D0}")) {
      pVTBL := NumGet(pIDSH + 0, "UPtr")
      If !DllCall(NumGet(pVTBL + InitializeFromBitmap, "UPtr"), "Ptr", pIDSH, "Ptr", &SHDI, "Ptr", pDataObj, "Int")
         Return pIDSH
   }
   Return False
}
; ==================================================================================================================================
; Initializes the drag-image manager for a control with a window.
; ==================================================================================================================================
IDragSourceHelper_CreateFromWindow(pDataObj, HWND, OffCX := 0, OffCY := 0) {
   Static InitializeFromWindow := A_PtrSize * 4
   If (pIDSH := ComObjCreate("{4657278A-411B-11D2-839A-00C04FD918D0}", "{DE5BF786-477A-11D2-839D-00C04FD918D0}")) {
      pVTBL := NumGet(pIDSH + 0, "UPtr")
      VarSetCapacity(PT,  8, 0)
      NumPut(OffCX, PT, 0, "Int")
      NumPut(OffCY, PT, 4, "Int")
      If !DllCall(NumGet(pVTBL + InitializeFromWindow, "UPtr"), "Ptr", pIDSH, "Ptr", HWND, "Ptr", &PT, "Ptr", pDataObj, "Int")
         Return pIDSH
   }
   Return False
}
; ==================================================================================================================================
; Auxiliary functions - deprecated, use LoadPicture() instead.
; ==================================================================================================================================
IDragSourceHelper_LoadImage(ImagePath, W := 0, H := 0) {
   HBITMAP := 0
   GDIPModule := DllCall("LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
   VarSetCapacity(SI, 24, 0)
   NumPut(1, SI, 0, "UInt")
   DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", GDIPToken, "Ptr", &SI, "Ptr", 0)
   DllCall("Gdiplus.dll\GdipCreateBitmapFromFile", "WStr", ImagePath, "PtrP", GDIPBitmap)
	DllCall("Gdiplus.dll\GdipGetImageWidth", "Ptr", GDIPBitmap, "UIntP", PW)
	DllCall("Gdiplus.dll\GdipGetImageHeight", "Ptr", GDIPBitmap, "UIntP", PH)
   DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", GDIPBitmap, "PtrP", HBITMAP, "UInt", 0xFFFFFFFF)
   DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", GDIPBitmap)
   DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", GDIPToken)
   DllCall("FreeLibrary", "Ptr", GDIPModule)
   If (W = 0)
      W := PW
   If (H = 0)
      H := PH
   If (W <> PW) || (H <> PH)
      HBITMAP := DllCall("CopyImage", "Ptr", HBITMAP, "UInt", 0, "Int", W, "Int", H, "UInt", 0x000A, "UPtr") ; 0x200A
   Return HBITMAP
}

;#Include *i IDropTarget.ahk
; ==================================================================================================================================
; IDropTarget interface -> msdn.microsoft.com/en-us/library/ms679679(v=vs.85).aspx
; Requires: IDataObject.ahk
; ==================================================================================================================================
; Creates a new instance of the IDropTarget object.
; Parameters:
;     HWND              -  HWND of the Gui window or control which shall be used as a drop target.
;     UserFuncSuffix    -  The suffix for the names of the user-defined functions which will be called on events (see Remarks).
;     RequiredFormats   -  An array containing the numeric clipboard formats required to permit drop.
;                          If omitted, only 15 (CF_HDROP) used for dropping files will be required.
;     Register          -  If set to True the target will be registered as a drop target on creation.
;                          Otherwise you have to call the RegisterDragDrop() method manually to activate the drop target.
;     UseHelper         -  Use the shell helper object if available (True/False).
; Return value:
;     New IDropTarget instance on success; in case of parameter errors, False.
; Remarks:
;     The interface permits up to 4 user-defined functions which will be called from the related methods:
;        IDropTargetOnEnter      Optional, called from IDropTarget.DragEnter()
;        IDropTargetOnOver       Optional, called from IDropTarget.DragOver()
;        IDropTargetOnLeave      Optional, called from IDropTarget.DragLeave()
;        IDropTargetOnDrop       Mandatory, called from IDropTarget.Drop()
;     The suffix passed in UserFuncSuffix which will be appended to this names to identify the instance specific functions.
;
;     Function parameters:
;        IDropTargetOnDrop and IDropTargetOnEnter must accept at least 6 parameters:
;           TargetObject   -  This instance.
;           pDataObj       -  A pointer to the IDataObject interface on the data object being dropped.
;           KeyState       -  The current state of the mouse buttons and keyboard modifier keys.
;           X              -  The current X coordinate of the cursor in screen coordinates.
;           Y              -  The current Y coordinate of the cursor in screen coordinates.
;           DropEffect     -  The drop effect determined by the Drop() method.
;        IDropTargetOnOver must accept at least 5 parameters:
;           TargetObject   -  This instance.
;           KeyState       -  The current state of the mouse buttons and keyboard modifier keys.
;           X              -  The current X coordinate of the cursor in screen coordinates.
;           Y              -  The current Y coordinate of the cursor in screen coordinates.
;           DropEffect     -  The drop effect determined by the Drop() method.
;        IDropTargetOnLeave must accept at least 1 parameter:
;           TargetObject   -  This instance.
;
;     What the functions must return:
;        The return value of IDropTargetOnDrop, IDropTargetOnEnter, and IDropTargetOnOver is used as the drop effect reported
;        as the result of the drop operation. In the easiest case the function returns the value passed in DropEffect.
;        Otherwise, it must return one of the following values:
;           0 (DROPEFFECT_NONE)
;           1 (DROPEFFECT_COPY)
;           2 (DROPEFFECT_MOVE)
;        The return value of IDropTargetOnLeave is not used.
;
;     As is the interface supports only left-dragging and permits DROPEFFECT_COPY and DROPEFFECT_MOVE. The default effect is
;     DROPEFFECT_COPY. It will be switched to DROPEFFECT_MOVE if either Ctrl or Shift is pressed. You can overwrite the default
;     from the IDropTargetOnEnter user function.
;
;     The dropped data have to be processed completely by the IDropTargetOnDrop user function.
; ==================================================================================================================================
IDropTarget_Create(HWND, UserFuncSuffix, RequiredFormats := "", Register := True, UseHelper := True) {
   Return New IDropTarget(HWND, UserFuncSuffix, RequiredFormats, Register, UseHelper)
}
; ==================================================================================================================================
Class IDropTarget {
   __New(HWND, UserFuncSuffix, RequiredFormats := "", Register := True, UseHelper := True) {
      Static Methods := ["QueryInterface", "AddRef", "Release", "DragEnter", "DragOver", "DragLeave", "Drop"]
      Static Params := (A_PtrSize = 8 ? [3, 1, 1, 5, 4, 1, 5] : [3, 1, 1, 6, 5, 1, 6])
      Static DefaultFormat := 15 ; CF_HDROP
      Static DropFunc := "IDropTargetOnDrop"
      Static EnterFunc := "IDropTargetOnEnter"
      Static OverFunc := "IDropTargetOnOver"
      Static LeaveFunc := "IDropTargetOnLeave"
      Static CLSID_IDTH := "{4657278A-411B-11D2-839A-00C04FD918D0}" ; CLSID_DragDropHelper
      Static IID_IDTH := "{4657278B-411B-11D2-839A-00C04FD918D0}"   ; IID_IDropTargetHelper
      If This.Base.HasKey("Ptr")
         Return False
      UserFunc := DropFunc . UserFuncSuffix
      If !IsFunc(UserFunc) || (Func(UserFunc).MinParams < 6)
         Return False
      This.DropUserFunc := Func(UserFunc)
      UserFunc := EnterFunc . UserFuncSuffix
      If (IsFunc(UserFunc) && (Func(UserFunc).MinParams > 5))
         This.EnterUserFunc := Func(UserFunc)
      UserFunc := OverFunc . UserFuncSuffix
      If (IsFunc(UserFunc) && (Func(UserFunc).MinParams > 4))
         This.OverUserFunc := Func(UserFunc)
      UserFunc := LeaveFunc . UserFuncSuffix
      If (IsFunc(UserFunc) && (Func(UserFunc).MinParams > 0))
         This.LeaveUserFunc := Func(UserFunc)
      This.HWND := HWND
      This.Registered := False
      If (RequiredFormats = -1)
         This.Required := 0
      Else If IsObject(RequiredFormats)
         This.Required := RequiredFormats
      Else
         This.Required := [DefaultFormat]
      This.PreferredDropEffect := 0
      SizeOfVTBL := (Methods.Length() + 2) * A_PtrSize
      This.SetCapacity("VTBL", SizeOfVTBL)
      This.Ptr := This.GetAddress("VTBL")
      DllCall("RtlZeroMemory", "Ptr", This.Ptr, "Ptr", SizeOfVTBL)
      NumPut(This.Ptr + A_PtrSize, This.Ptr + 0, "UPtr")
      For Index, Method In Methods {
         CB := RegisterCallback("IDropTarget." . Method, "", Params[Index], &This)
         NumPut(CB, This.Ptr + 0, A_Index * A_PtrSize, "UPtr")
      }
      This.Helper := ComObjCreate(CLSID_IDTH, IID_IDTH)
      If (Register)
         If !This.RegisterDragDrop()
            Return False
   }
   ; -------------------------------------------------------------------------------------------------------------------------------
   ; Registers window/control as a drop target.
   ; -------------------------------------------------------------------------------------------------------------------------------
   RegisterDragDrop() {
      If !(This.Registered)
         If DllCall("Ole32.dll\RegisterDragDrop", "Ptr", This.HWND, "Ptr", This.Ptr, "Int")
            Return False
      Return (This.Registered := True)
   }
   ; -------------------------------------------------------------------------------------------------------------------------------
   ; Revokes registering of the window/control as a drop target.
   ; This method should be called before the window/control will be destroyed.
   ; -------------------------------------------------------------------------------------------------------------------------------
   RevokeDragDrop() {
      If (This.Registered)
         DllCall("Ole32.dll\RevokeDragDrop", "Ptr", This.HWND)
      Return !(This.Registered := False)
   }
   ; -------------------------------------------------------------------------------------------------------------------------------
   ; Notifies the drag-image manager, if used, to show or hide the drag image.
   ; Parameter:
   ;     Show  -  If true, the drag image will be shown; otherwise it will be hidden.
   ; -------------------------------------------------------------------------------------------------------------------------------
   HelperShow(Show := True) {
      Static HelperShow := A_PtrSize * 7
      If (This.Helper) {
         pVTBL := NumGet(This.Helper + 0, "UPtr")
         , DllCall(NumGet(pVTBL + HelperShow, "UPtr"), "Ptr", This.Helper, "UInt", !!Show)
         Return True
      }
      Return False
   }
   ; ===============================================================================================================================
   ; The following methods must not be called directly, they are reserved for internal and system use.
   ; ===============================================================================================================================
   __Delete() {
      This.RevokeDragDrop()
      While (CB := NumGet(This.Ptr + (A_PtrSize * A_Index), "Ptr"))
         DllCall("GlobalFree", "Ptr", CB)
      If (This.Helper)
         ObjRelease(This.Helper)
   }
   ; -------------------------------------------------------------------------------------------------------------------------------
   QueryInterface(RIID, PPV) {
      ; IUnknown -> msdn.microsoft.com/en-us/library/ms682521(v=vs.85).aspx
      Static IID := "{00000122-0000-0000-C000-000000000046}"
      VarSetCapacity(QID, 80, 0)
      QIDLen := DllCall("Ole32.dll\StringFromGUID2", "Ptr", RIID, "Ptr", &QID, "Int", 40, "Int")
      If (StrGet(&QID, QIDLen, "UTF-16") = IID) {
         NumPut(This, PPV + 0, "Ptr")
         Return 0 ; S_OK
      }
      Else {
         NumPut(0, PPV + 0, "Ptr")
         Return 0x80004002 ; E_NOINTERFACE
      }
   }
   ; -------------------------------------------------------------------------------------------------------------------------------
   AddRef() {
      ; IUnknown -> msdn.microsoft.com/en-us/library/ms691379(v=vs.85).aspx
      ; Reference counting is not needed in this case.
      Return 1
   }
   ; -------------------------------------------------------------------------------------------------------------------------------
   Release() {
      ; IUnknown -> msdn.microsoft.com/en-us/library/ms682317(v=vs.85).aspx
      ; Reference counting is not needed in this case.
      Return 0
   }
   ; -------------------------------------------------------------------------------------------------------------------------------
   DragEnter(pDataObj, grfKeyState, P3 := "", P4 := "", P5 := "") {
      ; DragEnter -> msdn.microsoft.com/en-us/library/ms680106(v=vs.85).aspx
      ; Params 32: IDataObject *pDataObj, DWORD grfKeyState, LONG x, LONG y, DWORD *pdwEffect
      ; Params 64: IDataObject *pDataObj, DWORD grfKeyState, POINTL pt, DWORD *pdwEffect
      Static HelperEnter := A_PtrSize * 3
      Instance := Object(A_EventInfo)
      Instance.PreferredDropEffect := 0
      If (A_PtrSize = 8)
         X := P2 & 0xFFFFFFFF, Y := P2 >> 32
      Else
         X := P2, Y := P3
      Effect := 0
      If !(grfKeyState & 0x02) { ; right-drag isn't supported by default
         If IDataObject_GetPreferredDropEffect(pDataObj, DropEffect)
            Effect := DropEffect
         Else
            Effect := NumGet((A_PtrSize = 8 ? P4 : P5) + 0, "UInt")
         Effect := (Effect & 0x01) ? 1 : (Effect & 0x02)
         If IsObject(Instance.Required) {
            Found := False
            For Each, Format In Instance.Required {
               IDataObject_CreateFormatEtc(FORMATETC, Format)
               If (Found := IDataObject_QueryGetData(pDataObj, FORMATETC))
                  Break
            }
            If !(Found)
               Effect := 0
         }
      }
      If (Effect) && (Instance.EnterUserFunc)
         Effect := Instance.EnterUserFunc.Call(Instance, pDataObj, grfKeyState, X, Y, Effect)
      Instance.PreferredDropEffect := Effect
      ; If Ctrl and/or Shift is pressed swap the effect
      Effect ^= grfKeyState & 0x0C ? 3 : 0
      ; Call IDropTargetHelper, if created
      If (Instance.Helper) {
         VarSetCapacity(PT, 8, 0)
         , NumPut(X, PT, 0, "Int")
         , NumPut(Y, PT, 0, "Int")
         , pVTBL := NumGet(Instance.Helper + 0, "UPtr")
         , DllCall(NumGet(pVTBL + HelperEnter, "UPtr")
                 , "Ptr", Instance.Helper, "Ptr", Instance.HWND, "Ptr", pDataObj, "Ptr", &PT, "UInt", Effect, "Int")
      }
      NumPut(Effect, (A_PtrSize = 8 ? P4 : P5) + 0, "UInt")
      Return 0 ; S_OK
   }
   ; -------------------------------------------------------------------------------------------------------------------------------
   DragOver(grfKeyState, P2 := "", P3 := "", P4 := "") {
      ; DragOver -> msdn.microsoft.com/en-us/library/ms680129(v=vs.85).aspx
      ; Params 32: DWORD grfKeyState, LONG x, LONG y, DWORD *pdwEffect
      ; Params 64: DWORD grfKeyState, POINTL pt, DWORD *pdwEffect
      Static HelperOver := A_PtrSize * 5
      Instance := Object(A_EventInfo)
      If (A_PtrSize = 8)
         X := P2 & 0xFFFFFFFF, Y := P2 >> 32
      Else
         X := P2, Y := P3
      ; If Ctrl and/or Shift is pressed swap the effect
      Effect := Instance.PreferredDropEffect ^ (grfKeyState & 0x0C ? 3 : 0)
      If (Effect) && (Instance.OverUserFunc)
         Effect := Instance.OverUserFunc.Call(Instance, grfKeyState, X, Y, Effect)
      If (Instance.Helper) {
         VarSetCapacity(PT, 8, 0)
         , NumPut(X, PT, 0, "Int")
         , NumPut(Y, PT, 0, "Int")
         , pVTBL := NumGet(Instance.Helper + 0, "UPtr")
         , DllCall(NumGet(pVTBL + HelperOver, "UPtr"), "Ptr", Instance.Helper, "Ptr", &PT, "UInt", Effect, "Int")
      }
      NumPut(Effect, (A_PtrSize = 8 ? P3 : P4) + 0, "UInt")
      Return 0 ; S_OK
   }
   ; -------------------------------------------------------------------------------------------------------------------------------
   DragLeave() {
      ; DragLeave -> msdn.microsoft.com/en-us/library/ms680110(v=vs.85).aspx
      Static HelperLeave := A_PtrSize * 4
      Instance := Object(A_EventInfo)
      Instance.PreferredDropEffect := 0
      If (Instance.LeaveUserFunc)
         Instance.LeaveUserFunc.Call(Instance)
      If (Instance.Helper) {
         pVTBL := NumGet(Instance.Helper + 0, "UPtr"), DllCall(NumGet(pVTBL + HelperLeave, "UPtr"), "Ptr", Instance.Helper)
      }
      Return 0 ; S_OK
   }
   ; -------------------------------------------------------------------------------------------------------------------------------
   Drop(pDataObj, grfKeyState, P3 := "", P4 := "", P5 := "") {
      ; Drop -> msdn.microsoft.com/en-us/library/ms687242(v=vs.85).aspx
      ; Params 32: IDataObject *pDataObj, DWORD grfKeyState, LONG x, LONG y, DWORD *pdwEffect
      ; Params 64: IDataObject *pDataObj, DWORD grfKeyState, POINTL pt, DWORD *pdwEffect
      Static HelperDrop := A_PtrSize * 6
      Instance := Object(A_EventInfo)
      If (A_PtrSize = 8)
         X := P3 & 0xFFFFFFFF, Y := P3 >> 32
      Else
         X := P3, Y := P4
      Effect := Instance.PreferredDropEffect ^ (grfKeyState & 0x0C ? 3 : 0)
      Effect := Instance.DropUserFunc.Call(Instance, pDataObj, grfKeyState, X, Y, Effect)
      NumPut(Effect, (A_PtrSize = 8 ? P4 : P5) + 0, "UInt")
      If (Instance.Helper) {
         VarSetCapacity(PT, 8, 0)
         , NumPut(X, PT, 0, "Int")
         , NumPut(Y, PT, 0, "Int")
         , pVTBL := NumGet(Instance.Helper + 0, "UPtr")
         , DllCall(NumGet(pVTBL + HelperDrop, "UPtr"), "Ptr", Instance.Helper, "Ptr", pDataObj, "Ptr", &PT, "UInt", Effect, "Int")
      }
      Return 0 ; S_OK
   }
}
; ==================================================================================================================================
;#Include *i IDataObject.ahk
; ==================================================================================================================================

;#Include *i IEnumFORMATETC.ahk
; ==================================================================================================================================
; IEnumFORMATETC interface -> msdn.microsoft.com/en-us/library/ms682337(v=vs.85).aspx
; Partial implementation, 'Clone' method is missing.
; ==================================================================================================================================
IEnumFORMATETC_Next(pEnumObj, ByRef FORMATETC) {
   ; Next -> msdn.microsoft.com/en-us/library/dd542673(v=vs.85).aspx
   Static Next := A_PtrSize * 3
   VarSetCapacity(FORMATETC, A_PtrSize = 8 ? 32 : 20, 0)
   , pVTBL := NumGet(pEnumObj + 0, "UPtr")
   Return !DllCall(NumGet(pVTBL + Next, "UPtr"), "Ptr", pEnumObj, "UInt", 1, "Ptr", &FORMATETC, "Ptr", 0, "Int")
}
; ----------------------------------------------------------------------------------------------------------------------------------
IEnumFORMATETC_Reset(pEnumObj) {
   ; Reset -> msdn.microsoft.com/en-us/library/dd542674(v=vs.85).aspx
   Static Reset := A_PtrSize * 5
   pVTBL := NumGet(pEnumObj + 0, "UPtr")
   Return !DllCall(NumGet(pVTBL + Reset, "UPtr"), "Ptr", pEnumObj, "Int")
}
; ----------------------------------------------------------------------------------------------------------------------------------
IEnumFORMATETC_Skip(pEnumObj, ItemCount) {
   ; Skip -> msdn.microsoft.com/en-us/library/dd542674(v=vs.85).aspx
   Static Skip := A_PtrSize * 4
   pVTBL := NumGet(pEnumObj + 0, "UPtr")
   Return !DllCall(NumGet(pVTBL + Skip, "UPtr"), "Ptr", pEnumObj, "UInt", ItemCount, "Int")
}
; ==================================================================================================================================