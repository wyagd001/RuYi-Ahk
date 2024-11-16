;|2.8|2024.1.6|1686
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
	outputFilePath := CandySel_ParentPath "\" CandySel_FileNameNoExt "_透明转红色." CandySel_Ext
  Gdip_SetBitmapTransColor(CandySel, CandySel2, outputFilePath)
}
else
{
	loop, parse, CandySel, `n, `r
	{
		SplitPath, A_LoopField,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
		outputFilePath := CandySel_ParentPath "\" CandySel_FileNameNoExt "_透明转红色." CandySel_Ext
    Gdip_SetBitmapTransColor(A_LoopField, CandySel2, outputFilePath)
	}
}

Gdip_Shutdown(pToken)
Return

Gdip_SetBitmapTransColor(InputFile, whichColor, outputFile)
{
  pBitmap := Gdip_CreateBitmapFromFile(InputFile)
  Gdip_GetImageDimensions(pBitmap, vPosW, vPosH)
  Loop, % vPosH
  {
    vIndexY := A_Index-1
    Loop, % vPosW
    {
      vIndexX := A_Index-1
      vCol := Gdip_GetPixel(pBitmap, vIndexX, vIndexY)
      if (vCol & 0xFF000000 = 0)
        Gdip_SetPixel(pBitmap, vIndexX, vIndexY, whichColor)
    }
  }
  Gdip_SaveBitmapToFile(pBitmap, outputFile)
  Gdip_DisposeImage(pBitmap)
}