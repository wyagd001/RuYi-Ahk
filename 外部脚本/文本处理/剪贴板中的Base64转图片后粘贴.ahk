;|2.0|2023.07.01|1341
CandySel := Clipboard
CandySel := StrReplace(CandySel, "`r")
CandySel := StrReplace(CandySel, "`n")
CandySel := StrReplace(CandySel, "`t")
CandySel := StrReplace(CandySel, " ")
CandySel := StrReplace(CandySel, """")
CandySel := StrReplace(CandySel, ".")

Gdip_Startup()
pBitmap := B64ToPBitmap( CandySel )
Gdip_SetBitmapToClipboard(pBitmap)
Sleep 200
Send ^v
return

;Convert a Base 64 string into a pBitmap
B64ToPBitmap( Input ){
	local ptr , uptr , pBitmap , pStream , hData , pData , Dec , DecLen , B64
	VarSetCapacity( B64 , strlen( Input ) << !!A_IsUnicode )
	B64 := Input
	If !DllCall("Crypt32.dll\CryptStringToBinary" ( ( A_IsUnicode ) ? ( "W" ) : ( "A" ) ), Ptr := A_PtrSize ? "Ptr" : "UInt" , &B64, "UInt", 0, "UInt", 0x01, Ptr, 0, "UIntP", DecLen, Ptr, 0, Ptr, 0)
		Return False
	VarSetCapacity( Dec , DecLen , 0 )
	If !DllCall("Crypt32.dll\CryptStringToBinary" (A_IsUnicode ? "W" : "A"), Ptr, &B64, "UInt", 0, "UInt", 0x01, Ptr, &Dec, "UIntP", DecLen, Ptr, 0, Ptr, 0)
		Return False
	DllCall("Kernel32.dll\RtlMoveMemory", Ptr, pData := DllCall("Kernel32.dll\GlobalLock", Ptr, hData := DllCall( "Kernel32.dll\GlobalAlloc", "UInt", 2,  UPtr := A_PtrSize ? "UPtr" : "UInt" , DecLen, UPtr), UPtr) , Ptr, &Dec, UPtr, DecLen)
	DllCall("Kernel32.dll\GlobalUnlock", Ptr, hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", Ptr, hData, "Int", True, Ptr "P", pStream)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  Ptr, pStream, Ptr "P", pBitmap)
	return pBitmap
}