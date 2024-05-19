;|2.6|2024.05.12|1249,1250,1597
CandySel :=  A_Args[1]
CandySel2 :=  A_Args[2]
if (StrLen(CandySel) < 4)
	Return
if (CandySel2 = 1)
	CopyDirStructure(CandySel, 1)
else if (CandySel2 = "")
	CopyDirStructure(CandySel)
else
	CopyDirStructureToClip(CandySel, CandySel2)
Return

CopyDirStructure(_inpath, blankfile := 0)
{
	if !CF_IsFolder(_inpath)
		Return
	SplitPath, _inpath, _inpath_FileName, _inpath_ParentPath
	_outpath := _inpath_ParentPath "\" _inpath_FileName "(目录结构)"
	_outpath := PathU(_outpath)
	Loop, Files, %_inpath%\*.*, DR
	{
		StringReplace, _temp, A_LoopFileLongPath, %_inpath%\,, All
		FileCreateDir, %_outpath%\%_temp%
		If errorlevel
			_problem = 1
	}
	if blankfile
	{
		Loop, Files, %_inpath%\*.*, FR
		{
			StringReplace, _temp, A_LoopFileLongPath, %_inpath%\,, All
			FileAppend,, %_outpath%\%_temp%
		}
	}
	Return _problem
}

CopyDirStructureToClip(_inpath, subcounter := 0)
{
	if !CF_IsFolder(_inpath)
		Return
	SplitPath, _inpath, _inpath_FileName, _inpath_ParentPath
	_outpath := A_Temp "\" _inpath_FileName
	if FileExist(_outpath)
	{
		FileRemoveDir, % _outpath, 1
	}
	Loop, Files, %_inpath%\*.*, DR
	{
		subpath := StrReplace(A_LoopFileFullPath, _inpath)
		if (subcounter != 0)
		{   
			arr := StrSplit(subpath, "\")
			if (arr.Length() > subcounter)
				Continue
		}
		FileCreateDir, % _outpath . subpath
		If errorlevel
			_problem = 1
	}
	FileToClipboard(_outpath)
	Return _problem
}

CF_IsFolder(sfile){
	if InStr(FileExist(sfile), "D")
	|| (sfile = """::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
	;|| (SubStr(sfile, 1, 2) = "\\")
		return 1
	else
		return 0
}

PathU(Filename) { ;  PathU v0.91 by SKAN on D35E/D68M @ tiny.cc/pathu
Local OutFile
  VarSetCapacity(OutFile, 520)
  DllCall("Kernel32\GetFullPathNameW", "WStr",Filename, "UInt",260, "Str",OutFile, "Ptr",0)
  DllCall("Shell32\PathYetAnotherMakeUniqueName", "Str",OutFile, "Str",Outfile, "Ptr",0, "Ptr",0)
Return A_IsUnicode ? OutFile : StrGet(&OutFile, "UTF-16")
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