;|2.4|2023.09.16|1477,1478,多条目
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
	outputFilePath := CandySel_ParentPath "\" CandySel_FileNameNoExt "_转透明." CandySel_Ext
	PicFile_CCTT(CandySel, CandySel2, outputFilePath)
}
else
{
	loop, parse, CandySel, `n, `r
	{
		SplitPath, A_LoopField,, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
		outputFilePath := CandySel_ParentPath "\" CandySel_FileNameNoExt "_转透明." CandySel_Ext
		PicFile_CCTT(A_LoopField, CandySel2, outputFilePath)
	}
}

Gdip_Shutdown(pToken)
Return

PicFile_CCTT(InputFile, whichColor, outputFile)
{
	pBitmap := Gdip_CreateBitmapFromFile(InputFile)
	Gdip_SetBitmapTransColor(pBitmap, whichColor)   ; 指定颜色转透明
	Gdip_SaveBitmapToFile(pBitmap, outputFile)
	Gdip_DisposeImage(pBitmap)
}

;**********************************************************************************
;
; Gdip_SetBitmapTransColor()
; by MasterFocus - 02/APRIL/2013 00:30h BRT
; Requires GDIP
; http://www.autohotkey.com/board/topic/71100-gdip-imagesearch/
;
; Licensed under CC BY-SA 3.0 -> http creativecommons.org /licenses/by-sa/3.0/  Broken Link for safety
; I waive compliance with the "Share Alike" condition of the license EXCLUSIVELY
; for these users: tic , Rseding91 , guest3456
;
;**********************************************************************************

;==================================================================================
;
; This function modifies the Alpha component for all pixels of a certain color to 0
; The returned value is 0 in case of success, or a negative number otherwise
;
; ++ PARAMETERS ++
;
; pBitmap
;   A valid pointer to the bitmap that will be modified
;
; TransColor
;   The color to become transparent
;   Should range from 0 (black) to 0xFFFFFF (white)
;
; ++ RETURN VALUES ++
;
; -2001 ==> invalid bitmap pointer
; -2002 ==> invalid TransColor
; -2003 ==> unable to retrieve bitmap positive dimensions
; -2004 ==> unable to lock bitmap bits
; -2005 ==> DllCall failed (see ErrorLevel)
; any non-negative value ==> the number of pixels modified by this function
;
;==================================================================================

Gdip_SetBitmapTransColor(pBitmap,TransColor) {
    static _SetBmpTrans, Ptr, PtrA
    if !( _SetBmpTrans ) {
        Ptr := A_PtrSize ? "UPtr" : "UInt"
        PtrA := Ptr . "*"
        MCode_SetBmpTrans := "
            (LTrim Join
            8b44240c558b6c241cc745000000000085c07e77538b5c2410568b74242033c9578b7c2414894c24288da424000000
            0085db7e458bc18d1439b9020000008bff8a0c113a4e0275178a4c38013a4e01750e8a0a3a0e7508c644380300ff450083c0
            0483c204b9020000004b75d38b4c24288b44241c8b5c2418034c242048894c24288944241c75a85f5e5b33c05dc3,405
            34c8b5424388bda41c702000000004585c07e6448897c2410458bd84c8b4424304963f94c8d49010f1f800000000085db7e3
            8498bc1488bd3660f1f440000410fb648023848017519410fb6480138087510410fb6083848ff7507c640020041ff024883c
            00448ffca75d44c03cf49ffcb75bc488b7c241033c05bc3
            )"
        if ( A_PtrSize == 8 ) ; x64, after comma
            MCode_SetBmpTrans := SubStr(MCode_SetBmpTrans,InStr(MCode_SetBmpTrans,",")+1)
        else ; x86, before comma
            MCode_SetBmpTrans := SubStr(MCode_SetBmpTrans,1,InStr(MCode_SetBmpTrans,",")-1)
        VarSetCapacity(_SetBmpTrans, LEN := StrLen(MCode_SetBmpTrans)//2, 0)
        Loop, %LEN%
            NumPut("0x" . SubStr(MCode_SetBmpTrans,(2*A_Index)-1,2), _SetBmpTrans, A_Index-1, "uchar")
        MCode_SetBmpTrans := ""
        DllCall("VirtualProtect", Ptr,&_SetBmpTrans, Ptr,VarSetCapacity(_SetBmpTrans), "uint",0x40, PtrA,0)
    }
    If !pBitmap
        Return -2001
    If TransColor not between 0 and 0xFFFFFF
        Return -2002
    Gdip_GetImageDimensions(pBitmap,W,H)
    If !(W && H)
        Return -2003
    If Gdip_LockBits(pBitmap,0,0,W,H,Stride,Scan,BitmapData)
        Return -2004
    ; The following code should be slower than using the MCode approach,
    ; but will the kept here for now, just for reference.
    /*
    Count := 0
    Loop, %H% {
        Y := A_Index-1
        Loop, %W% {
            X := A_Index-1
            CurrentColor := Gdip_GetLockBitPixel(Scan,X,Y,Stride)
            If ( (CurrentColor & 0xFFFFFF) == TransColor )
                Gdip_SetLockBitPixel(TransColor,Scan,X,Y,Stride), Count++
        }
    }
    */
    ; Thanks guest3456 for helping with the initial solution involving NumPut
    Gdip_FromARGB(TransColor,A,R,G,B), VarSetCapacity(TransColor,0), VarSetCapacity(TransColor,3,255)
    NumPut(B,TransColor,0,"UChar"), NumPut(G,TransColor,1,"UChar"), NumPut(R,TransColor,2,"UChar")
    MCount := 0
    E := DllCall(&_SetBmpTrans, Ptr,Scan, "int",W, "int",H, "int",Stride, Ptr,&TransColor, "int*",MCount, "cdecl int")
    Gdip_UnlockBits(pBitmap,BitmapData)
    If ( E != 0 ) {
        ErrorLevel := E
        Return -2005
    }
    Return MCount
}

/*
int Gdip_SetBitmapTransColor(unsigned char * Scan, int Width, int Height, int Stride, unsigned char * Trans, int * MCount)
{
    int x1, y1, index;
    MCount[0] = 0;
    for (y1 = 0; y1 < Height; y1++) {
        for (x1 = 0; x1 < Width; x1++) {
            // using index to calculate the needle index offset only once
            index = (4*x1)+(y1*Stride);
            if ( Scan[index+2] == Trans[2]
            &&   Scan[index+1] == Trans[1]
            &&   Scan[index+0] == Trans[0] ) {
                Scan[index+3] = 0;
                MCount[0]++;
            }
        }
    }
    return 0;
}
*/