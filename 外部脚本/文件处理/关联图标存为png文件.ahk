;|2.0|2023.07.01|1208
;方法来自官网，需要gdip支持
CandySel := A_Args[1], filetype := A_Args[2]
SplitPath, CandySel, CandySel_FileName, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
1208:
Cando_提取图标:
	ptr := A_PtrSize = 8 ? "ptr" : "uint"   ;for AHK Basic
	hIcon := DllCall("Shell32\ExtractAssociatedIcon" (A_IsUnicode ? "W" : "A")
		, ptr, DllCall("GetModuleHandle", ptr, 0, ptr)
		, str, CandySel
		, "ushort*", lpiIcon
		, ptr)   ;only supports 32x32
	SavehIconAsBMP(hIcon, CandySel_ParentPath "\" CandySel_FileNameNoExt (filetype ? filetype : ".png"))
return

SavehIconAsBMP(hIcon, sFile)
{
	if pToken := Gdip_Startup()
	{
		pBitmap := Gdip_CreateBitmapFromHICON(hIcon)
		Gdip_SaveBitmapToFile(pBitmap, sFile)
		Gdip_DisposeImage(pBitmap)
		Gdip_Shutdown(pToken)
		return true
	}
	return false
}