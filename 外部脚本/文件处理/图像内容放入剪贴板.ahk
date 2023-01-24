#SingleInstance force
CandySel := A_Args[1]
; 1106
Cando_图像文件放进剪贴板:
pToken := Gdip_Startup()
pbitmap := Gdip_CreateBitmapFromFile(CandySel)
Gdip_SetBitmapToClipboard(pBitmap)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
Return