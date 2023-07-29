;|2.1|2023.07.10|1344
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}
if InStr(CandySel, "`n")
{
	FileToClipboard(CandySel)
}
Else
{
	if FileExist(CandySel)
		FileToClipboard(CandySel)
}
return

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