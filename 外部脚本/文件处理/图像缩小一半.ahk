;|2.4|2023.09.17|1104,1484,1485
#SingleInstance force
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
	if (CandySel2 = "") or (CandySel2 = 50)
	{
		outputFilePath := CandySel_ParentPath "\" CandySel_FileNamenoExt "_0.5." CandySel_Ext
		ConvertImage(CandySel, outputFilePath, 50, 50, "Percent")
	}
	else if (CandySel_Ext != CandySel2)
	{
		outputFilePath := CandySel_ParentPath "\" CandySel_FileNamenoExt "." CandySel2
		ConvertImage(CandySel, outputFilePath)
	}
	IfNotExist %outputFilePath%
		TrayTip, 图像转换失败, %outputFilePath%, 3000
}
else
{
	loop, parse, CandySel, `n, `r
	{
		SplitPath, A_LoopField,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
		if (CandySel2 = "") or (CandySel2 = 50)
		{
			outputFilePath := CandySel_ParentPath "\" CandySel_FileNamenoExt "_0.5." CandySel_Ext
			ConvertImage(A_LoopField, outputFilePath, 50, 50, "Percent")
		}
		else if (CandySel_Ext != CandySel2)
		{
			outputFilePath := CandySel_ParentPath "\" CandySel_FileNamenoExt "." CandySel2
			ConvertImage(A_LoopField, outputFilePath)
		}
	}
}

Gdip_Shutdown(pToken)
Return

ConvertImage(InputFile, OutputFile, OWidth="", OHeight="", Method="Percent")
{
	pBitmap := Gdip_CreateBitmapFromFile(InputFile)
	If !pBitmap
		Return, -1

	Width := Gdip_GetImageWidth(pBitmap), Height := Gdip_GetImageHeight(pBitmap)
	If !(Width && Height)
	{
		Gdip_DisposeImage(pBitmap)
		Return, -2
	}

	If (Method = "Percent")
	{
		OWidth := (OWidth = "") ? 100 : OWidth,  OHeight := (OHeight = "") ? 100 : OHeight
		OWidth := (OWidth = -1) ? OHeight : OWidth, OHeight := (OHeight = -1) ? OWidth : OHeight
		dWidth := Round(Width*(OWidth/100)), dHeight := Round(Height*(OHeight/100))
	}
	else If (Method = "Pixels")  ; -1 表示保持长宽比
	{
		if (OWidth = -1)
			dWidth := Round((OHeight/Height)*Width), dHeight := OHeight
		else if (OHeight = -1)
			dHeight := Round((OWidth/Width)*Height), dWidth := OWidth
		else
			dWidth := OWidth, dHeight := OHeight
	}
	else
	{
		Gdip_DisposeImage(pBitmap)
		return -3
	}

	pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight), G1 := Gdip_GraphicsFromImage(pBitmap1)
	Gdip_SetInterpolationMode(G1, 7)
	Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, Width, Height)

	Gdip_SaveBitmapToFile(pBitmap1, OutputFile, 100)
	Gdip_DeleteGraphics(G1)
	Gdip_DisposeImage(pBitmap), Gdip_DisposeImage(pBitmap1)
	return 0
}