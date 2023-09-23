;|2.4|2023.09.17|1107
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
	outputFilePath := CandySel_ParentPath "\" CandySel_FileNamenoExt "-0.5.jpg"
	ConvertImage_Quality(CandySel, outputFilePath, 50)
	IfNotExist %outputFilePath%
		TrayTip, 图像转换失败, %outputFilePath%, 3000
}
else
{
	loop, parse, CandySel, `n, `r
	{
		SplitPath, A_LoopField,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
		outputFilePath := CandySel_ParentPath "\" CandySel_FileNameNoExt "-0.5.jpg"
		ConvertImage_Quality(A_LoopField, outputFilePath, 50)
	}
}

Gdip_Shutdown(pToken)
Return

ConvertImage_Quality(sInput, sOutput, Quality)
{
	pBitmap := Gdip_CreateBitmapFromFile(sInput)
	Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality)
	Gdip_DisposeImage(pBitmap)
	return
}