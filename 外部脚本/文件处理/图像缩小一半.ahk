#SingleInstance force
CandySel := A_Args[1]
SplitPath, CandySel,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt

Cando_图像尺寸缩小:
Output := CandySel_ParentPath . "\" . CandySel_FileNamenoExt . "_0.5." . CandySel_Ext
ConvertImage(CandySel, Output, "50", "50", "Percent")
IfNotExist %Output%
	TrayTip, 图像转换失败, %Output%, 3000
Return

ConvertImage(sInput, sOutput, sWidth="", sHeight="", Method="Percent")
{
	pToken := Gdip_Startup()
	pBitmap := Gdip_CreateBitmapFromFile(sInput)
	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)

	If (Method = "Percent")
	{
		Width := (Width = -1) ? Height : Width, Height := (Height = -1) ? Width : Height
		dWidth := Round(Width*(sWidth/100)), dHeight := Round(Height*(sHeight/100))
	}
	else If (Method = "Pixels")
	{
		if (Width = -1)
		dWidth := Round((sHeight/Height)*Width), dHeight := Height
		else if (Height = -1)
		dHeight := Round((sWidth/Width)*Height), dWidth := Width
		else
		dWidth := sWidth, dHeight := sHeight
	}
	else
		return -1
	pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight),G1 := Gdip_GraphicsFromImage(pBitmap1)
	Gdip_SetInterpolationMode(G1, 7)
	Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, Width, Height)

	Gdip_SaveBitmapToFile(pBitmap1, sOutput, 100)
	Gdip_DeleteGraphics(G1)
	Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap1)
	Gdip_Shutdown(pToken)
	return 0
}