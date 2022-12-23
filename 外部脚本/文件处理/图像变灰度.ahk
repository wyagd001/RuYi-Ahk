#SingleInstance force
Menu, Tray, UseErrorLevel
CandySel := A_Args[1]
SplitPath, CandySel,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt

Cando_图像去色:
Output := CandySel_ParentPath . "\" . CandySel_FileNamenoExt . "_GreyScale." . CandySel_Ext
ConvertImage_GreyScale(CandySel, output)
IfNotExist %Output%
	TrayTip, 图像转换失败, %Output%, 3000
Return

ConvertImage_GreyScale(sInput, sOutput)
{
	SetBatchLines, -1 
	pToken := Gdip_Startup() 
	pBitmap := Gdip_CreateBitmapFromFile(sInput) 
	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap) 
	pBitmap1 := Gdip_CreateBitmap(Width,height), G1 := Gdip_GraphicsFromImage(pBitmap1) 
	Matrix = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1 
	Gdip_DrawImage(G1, pBitmap, 0, 0, Width, Height, 0, 0, Width, Height, Matrix) 
	sleep 200  
	Gdip_SaveBitmapToFile(pBitmap1, sOutput) 
	Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap1)
	Gdip_DeleteGraphics(G1) 
	Gdip_Shutdown(pToken)
	Return 
}