;|2.4|2023.09.16|1481
#SingleInstance force
SetBatchLines, -1
CandySel := A_Args[1]
CandySel2 := A_Args[2]
CandySel3 := A_Args[3]
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
	outputFilePath := CandySel_ParentPath "\" CandySel_FileNamenoExt "_其他颜色替换." CandySel_Ext
	PicFile_ReplaceOtherColor(CandySel, CandySel2, CandySel3, outputFilePath)
	msgbox % CandySel "`n" CandySel2  "`n" CandySel3  "`n" outputFilePath
}
else
{
	loop, parse, CandySel, `n, `r
	{
		SplitPath, A_LoopField,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
		outputFilePath := CandySel_ParentPath "\" CandySel_FileNameNoExt "_其他颜色替换." CandySel_Ext
		PicFile_ReplaceOtherColor(A_LoopField, CandySel2, CandySel3, outputFilePath)
	}
}

Gdip_Shutdown(pToken)
Return

PicFile_ReplaceOtherColor(InputFile, whichColor, ReplaceColor, outputFile)
{
	pBitmap := Gdip_CreateBitmapFromFile(InputFile)
msgbox % pBitmap
	Gdip_ColorFilter(pBitmap, whichColor, ReplaceColor)   ; 指定颜色转透明
	Gdip_SaveBitmapToFile(pBitmap, outputFile)
	Gdip_DisposeImage(pBitmap)
}

; 除了 TargetColor 目标颜色不变
; 图片里其余颜色全部替换为 ReplaceColor
Gdip_ColorFilter(pBitmap, TargetColor, ReplaceColor) 
{
	static ColorFilterMCode
	if (ColorFilterMCode = "")
	{
		if (A_PtrSize = 4)
			mCode := ""
			. "2,x86:VVdWU4PsBItUJCSLTCQoi1wkLItsJByNQgOF0g9JwotU"
			. "JCCByQAAAP/B+AKBywAAAP+F0n44he1+NIt0JBjB4ALB5QKJBC"
			. "Qx/420JgAAAACNFC6J8DsIdAKJGIPABDnQdfODxwEDNCQ5fCQg"
			. "deKDxAQxwFteX13D"
        else
            mCode := ""
			. "2,x64:VlNEi1QkQEGNWQNFhclBD0nZRItMJDhBgcoAAAD/wfsC"
			. "QYHJAAAA/0WFwH5QhdJ+TI1C/0hj20Ux20jB4wJIjTSFBAAAAG"
			. "YuDx+EAAAAAABIjRQOSInIZg8fhAAAAAAARDsIdANEiRBIg8AE"
			. "SDnQde9Bg8MBSAHZRTnYddMxwFtew5CQkJA="
		ColorFilterMCode := MCode(mCode)
	}

	Gdip_GetImageDimensions(pBitmap, w, h)
	Gdip_LockBits(pBitmap, 0, 0, w, h, stride, scan, bitmapData)
	DllCall(ColorFilterMCode, "uint", scan, "int", w, "int", h, "int", Stride, "uint", TargetColor, "uint", ReplaceColor, "cdecl")
	Gdip_UnlockBits(pBitmap, bitmapData)
	return pBitmap
}

/*
unsigned int Gdip_ColorFilter(unsigned int * bitmap, int w, int h, int Stride, unsigned int TargetColor, unsigned int ReplaceColor)
{
    int x, y, offset = Stride/4;
	TargetColor = TargetColor | 0xFF000000;
	ReplaceColor = ReplaceColor | 0xFF000000;
	for (y = 0; y < h; ++y) {
		for (x = 0; x < w; ++x) {
			if (bitmap[x+(y*offset)] != TargetColor)    // 不等于目标颜色
				bitmap[x+(y*offset)] = ReplaceColor;
		}
	}
	return 0;
}
*/

MCode(mcode)
{
global _FilterColor
    static e := {1:4, 2:1}, c := (A_PtrSize=8) ? "x64" : "x86"
    if (!regexmatch(mcode, "^([0-9]+),(" c ":|.*?," c ":)([^,]+)", m))
        return
   if (!DllCall("crypt32\CryptStringToBinary", "str", m3, "uint", 0, "uint", e[m1], "ptr", 0, "uint*", s, "ptr", 0, "ptr", 0))
        return
    p := DllCall("GlobalAlloc", "uint", 0, "ptr", s, "ptr")
    if (c="x64")
        DllCall("VirtualProtect", "ptr", p, "ptr", s, "uint", 0x40, "uint*", op)
    if (DllCall("crypt32\CryptStringToBinary", "str", m3, "uint", 0, "uint", e[m1], "ptr", p, "uint*", s, "ptr", 0, "ptr", 0))
        return p
    DllCall("GlobalFree", "ptr", p)
}