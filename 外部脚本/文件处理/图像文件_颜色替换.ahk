;|2.4|2023.09.16|1479, 1480
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
	outputFilePath := CandySel_ParentPath "\" CandySel_FileNamenoExt "_颜色替换." CandySel_Ext
	PicFile_ReplaceColor(CandySel, CandySel2, CandySel3, outputFilePath)
}
else
{
	loop, parse, CandySel, `n, `r
	{
		SplitPath, A_LoopField,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
		outputFilePath := CandySel_ParentPath "\" CandySel_FileNameNoExt "_颜色替换." CandySel_Ext
		PicFile_ReplaceColor(A_LoopField, CandySel2, CandySel3, outputFilePath)
	}
}

Gdip_Shutdown(pToken)
Return


PicFile_ReplaceColor(InputFile, whichColor, ReplaceColor, outputFile)
{
	pBitmap := Gdip_CreateBitmapFromFile(InputFile)
	Gdip_FilterColor(pBitmap, whichColor, ReplaceColor)   ; 指定颜色转透明
	Gdip_SaveBitmapToFile(pBitmap, outputFile)
	Gdip_DisposeImage(pBitmap)
}

; Color  目标颜色, 支持 ARGB 例如 0xff00ff00
; ReplaceColor 替换掉目标颜色 Color 的颜色值
Gdip_FilterColor(pBitmap, Color, ReplaceColor, Variation=0)
{
    static _FilterColor
    if !_FilterColor
    {

_FilterColor := MCode("2,x86:VVdWU4PsMItMJFSLXCRID7b1icqJyIl0JAgPtvGLTCRMiXQkIIt0JFjB6hjB6BDB7hiJdCQki3QkWMHuEIl0JCiLdCRYwe4IhcmJdCQsD47qAAAAhdsPjuIAAADB4wIPtsCLdCREiVwkGItcJFwx7Y0MGonTi1QkXCtcJFwBwitEJFyJVCQEiUQkEJCNdCYAi3wkCAN8JFyLRCQYiRwkiXwkDIt8JAiNFAYrfCRcifCJfCQUD7Z4AznPd2c7PCRyYg+2eAI7fCQEd1g7fCQQclIPtngBO3wkDHdIO3wkFHJCD7YYi3wkXIlcJByLXCQgAd85fCQcdyuJ3yt8JFw5fCQcch8PtlwkJIhYAw+2XCQoiFgCD7ZcJCyIWAEPtlwkWIgYg8AEOcJ1ioPFAQN0JFA5bCRMixwkD4VS////g8QwMcBbXl9dw5CNtCYAAAAAMcDD,x64:QVdBVkFVQVRVV1ZTSIPsOIu0JKgAAABEi6wkoAAAAIu8JKgAAACLrCSwAAAAwe4YRInrRInowe8QwesYD7bEiXQkLIu0JKgAAABBidJEierB6hCJfCQkRYnPRQ+27cHuCESJhCSQAAAAD7bSiXQkKEWFwA+OAQEAAEWF0g+O+AAAAESNNCop6kaNBJUDAAAAMfaJVCQIjRQoKehEjRQriVQkFL8DAAAAKeuJRCQgZpBBjVQtAIn4iVQkDESJ6inqiVQkEA8fQACJwkSNSP1IAcpED7YaRTnTd35EOdt3eUSNWP9JActFD7YjRTnmcmlEOWQkCHdiRI1g/kkBzEyJZCQYRQ+2JCREOWQkFHJKRDlkJCB3Q0kByUUPtiFEOWQkDHI1RDlkJBB3LkQPtmQkLESIIg+2VCQkTItkJBhBiBMPtlQkKEGIFCQPtpQkqAAAAEGIEQ8fQACDwARBOcAPhWT///+DxgFFAfhEAf85tCSQAAAAD4U2////McBIg8Q4W15fXUFcQV1BXkFfww8fADHAww==")

}

    Variation := (Variation > 255) ? 255 : (Variation < 0) ? 0 : Variation
    Gdip_GetImageDimensions(pBitmap, w, h)
    E1 := Gdip_LockBits(pBitmap, 0, 0, w, h, Stride1, Scan01, BitmapData1)
    E := DllCall(_FilterColor, "uint", Scan01, "int", w, "int", h, "int", Stride1, "uint", Color, "uint", ReplaceColor, "int", Variation)
    Gdip_UnlockBits(pBitmap, BitmapData1)
    return (E = "") ? -1 : E
}

/*
int Gdip_FilterColor(unsigned char * Bitmap, int w, int h, int Stride, unsigned int Color, unsigned int ReplaceColor, int v)
{
    unsigned int p, A1, R1, G1, B1, A2, R2, G2, B2, tA, tR, tG, tB;
 
    A1 = (Color & 0xff000000) >> 24;
    R1 = (Color & 0x00ff0000) >> 16;
    G1 = (Color & 0x0000ff00) >> 8;
    B1 = Color & 0x000000ff;
 
    A2 = (ReplaceColor & 0xff000000) >> 24;
    R2 = (ReplaceColor & 0x00ff0000) >> 16;
    G2 = (ReplaceColor & 0x0000ff00) >> 8;
    B2 = ReplaceColor & 0x000000ff;
 
    for (int y = 0; y < h; ++y)
    {
        for (int x = 0; x < w; ++x)
        {
            p = (4*x)+(y*Stride);
 
            tA = Bitmap[3+p];
            tR = Bitmap[2+p];
            tG = Bitmap[1+p];
            tB = Bitmap[p];
            
            if ((tA <= A1+v && tA >= A1-v) && (tR <= R1+v && tR >= R1-v) && (tG <= G1+v && tG >= G1-v) && (tB <= B1+v && tB >= B1-v))
            {
                Bitmap[3+p] = A2;
                Bitmap[2+p] = R2;
                Bitmap[1+p] = G2;
                Bitmap[p] = B2;
            }
            
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