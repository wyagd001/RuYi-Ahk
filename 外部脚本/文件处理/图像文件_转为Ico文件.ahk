;|2.4|2023.09.16|1482
#SingleInstance force
SetBatchLines, -1
CandySel := A_Args[1]
CandySel2 := A_Args[2]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}

pToken := Gdip_Startup()

if !instr(CandySel, "`n")
{
	SplitPath, CandySel,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
	outputFilePath := CandySel_ParentPath "\" CandySel_FileNamenoExt ".ico"
	Png2Icon(CandySel, outputFilePath)
}
else
{
	loop, parse, CandySel, `n, `r
	{
		SplitPath, A_LoopField,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
		outputFilePath := CandySel_ParentPath "\" CandySel_FileNameNoExt ".ico"
		Png2Icon(A_LoopField, outputFilePath)
	}
}

Gdip_Shutdown(pToken)
Return

Png2Icon(sourcePng, destIco) {
	pBitmap := Gdip_CreateBitmapFromFile(sourcePng)
	hIcon := Gdip_CreateHICONFromBitmap(pBitmap)
	HiconToFile(hIcon, destIco)
	DllCall("DestroyIcon", "Ptr", hIcon), Gdip_DisposeImage(pBitmap)
}

HiconToFile(hIcon, destFile) {
   static szICONHEADER := 6, szICONDIRENTRY := 16, szBITMAP := 16 + A_PtrSize*2, szBITMAPINFOHEADER := 40
        , IMAGE_BITMAP := 0, flags := (LR_COPYDELETEORG := 0x8) | (LR_CREATEDIBSECTION := 0x2000)
        , szDIBSECTION := szBITMAP + szBITMAPINFOHEADER + 8 + A_PtrSize*3
        , copyImageParams := ["UInt", IMAGE_BITMAP, "Int", 0, "Int", 0, "UInt", flags, "Ptr"]

   VarSetCapacity(ICONINFO, 8 + A_PtrSize*3, 0)
   DllCall("GetIconInfo", "Ptr", hIcon, "Ptr", &ICONINFO)
   if !hbmMask  := DllCall("CopyImage", "Ptr", NumGet(ICONINFO, 8 + A_PtrSize), copyImageParams*) {
      MsgBox, % "CopyImage failed. LastError: " . A_LastError
      Return
   }
   hbmColor := DllCall("CopyImage", "Ptr", NumGet(ICONINFO, 8 + A_PtrSize*2), copyImageParams*)
   VarSetCapacity(mskDIBSECTION, szDIBSECTION, 0)
   VarSetCapacity(clrDIBSECTION, szDIBSECTION, 0)
   DllCall("GetObject", "Ptr", hbmMask , "Int", szDIBSECTION, "Ptr", &mskDIBSECTION)
   DllCall("GetObject", "Ptr", hbmColor, "Int", szDIBSECTION, "Ptr", &clrDIBSECTION)

   clrWidth        := NumGet(clrDIBSECTION,  4, "UInt")
   clrHeight       := NumGet(clrDIBSECTION,  8, "UInt")
   clrBmWidthBytes := NumGet(clrDIBSECTION, 12, "UInt")
   clrBmPlanes     := NumGet(clrDIBSECTION, 16, "UShort")
   clrBmBitsPixel  := NumGet(clrDIBSECTION, 18, "UShort")
   clrBits         := NumGet(clrDIBSECTION, 16 + A_PtrSize)
   colorCount := clrBmBitsPixel >= 8 ? 0 : 1 << (clrBmBitsPixel * clrBmPlanes)
   clrDataSize := clrBmWidthBytes * clrHeight

   mskHeight       := NumGet(mskDIBSECTION,  8, "UInt")
   mskBmWidthBytes := NumGet(mskDIBSECTION, 12, "UInt")
   mskBits         := NumGet(mskDIBSECTION, 16 + A_PtrSize)
   mskDataSize := mskBmWidthBytes * mskHeight

   iconDataSize := clrDataSize + mskDataSize
   dwBytesInRes := szBITMAPINFOHEADER + iconDataSize
   dwImageOffset := szICONHEADER + szICONDIRENTRY

   VarSetCapacity(ICONHEADER, szICONHEADER, 0)
   NumPut(1, ICONHEADER, 2, "UShort")
   NumPut(1, ICONHEADER, 4, "UShort")

   VarSetCapacity(ICONDIRENTRY, szICONDIRENTRY, 0)
   NumPut(clrWidth      , ICONDIRENTRY,  0, "UChar")
   NumPut(clrHeight     , ICONDIRENTRY,  1, "UChar")
   NumPut(colorCount    , ICONDIRENTRY,  2, "UChar")
   NumPut(clrBmPlanes   , ICONDIRENTRY,  4, "UShort")
   NumPut(clrBmBitsPixel, ICONDIRENTRY,  6, "UShort")
   NumPut(dwBytesInRes  , ICONDIRENTRY,  8, "UInt")
   NumPut(dwImageOffset , ICONDIRENTRY, 12, "UInt")

   NumPut(clrHeight*2 , clrDIBSECTION, szBITMAP +  8, "UInt")
   NumPut(iconDataSize, clrDIBSECTION, szBITMAP + 20, "UInt")
   
   File := FileOpen(destFile, "w", "cp0")
   File.RawWrite(ICONHEADER, szICONHEADER)
   File.RawWrite(ICONDIRENTRY, szICONDIRENTRY)
   File.RawWrite(&clrDIBSECTION + szBITMAP, szBITMAPINFOHEADER)
   File.RawWrite(clrBits + 0, clrDataSize)
   File.RawWrite(mskBits + 0, mskDataSize)
   File.Close()

   DllCall("DeleteObject", "Ptr", hbmColor)
   DllCall("DeleteObject", "Ptr", hbmMask)
}