#SingleInstance force
Menu, Tray, UseErrorLevel
CandySel := A_Args[1]

Cando_图像文件放进剪贴板:
pToken := Gdip_Startup()
pbitmap := Gdip_CreateBitmapFromFile(CandySel)
Gdip_SetBitmapToClipboard(pBitmap)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
Return