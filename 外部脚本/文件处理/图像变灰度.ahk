;|2.4|2023.09.17|1105
#SingleInstance force
CandySel := A_Args[1]
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
	outputFilePath := CandySel_ParentPath "\" CandySel_FileNamenoExt "_GreyScale." CandySel_Ext
	ConvertImage_GreyScale(CandySel, outputFilePath)
	IfNotExist %outputFilePath%
		TrayTip, 图像转换失败, %outputFilePath%, 3000
}
else
{
	loop, parse, CandySel, `n, `r
	{
		SplitPath, A_LoopField,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
		outputFilePath := CandySel_ParentPath "\" CandySel_FileNamenoExt "_GreyScale." CandySel_Ext
		ConvertImage_GreyScale(A_LoopField, outputFilePath)
	}
}

Gdip_Shutdown(pToken)
Return

ConvertImage_GreyScale(sInput, sOutput)
{
	SetBatchLines, -1 
	pBitmap := Gdip_CreateBitmapFromFile(sInput) 
	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap) 
	pBitmap1 := Gdip_CreateBitmap(Width,height), G1 := Gdip_GraphicsFromImage(pBitmap1) 
	Matrix = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1 
	Gdip_DrawImage(G1, pBitmap, 0, 0, Width, Height, 0, 0, Width, Height, Matrix) 
	sleep 200  
	Gdip_SaveBitmapToFile(pBitmap1, sOutput) 
	Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap1)
	Gdip_DeleteGraphics(G1) 
	Return 
}