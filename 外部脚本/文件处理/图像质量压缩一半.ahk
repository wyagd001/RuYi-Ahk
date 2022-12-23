#SingleInstance force
Menu, Tray, UseErrorLevel
CandySel := A_Args[1]
SplitPath, CandySel,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt

Cando_图像转为JPG:
Output := CandySel_ParentPath . "\" . CandySel_FileNamenoExt . "-0.5.jpg"
ConvertImage_Quality(CandySel, Output, 50)
IfNotExist %Output%
	TrayTip, 图像转换失败, %Output%, 3000
Return

ConvertImage_Quality(sInput, sOutput, Quality)
{
	pToken := Gdip_Startup()
	pBitmap := Gdip_CreateBitmapFromFile(sInput)
	Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality)
	Gdip_DisposeImage(pBitmap)
	Gdip_Shutdown(pToken)
	return
}