;|2.4|2023.09.19|1503
#SingleInstance force
Windy_CurWin_id := A_Args[1]
picfilepath := A_Args[2]

pToken := Gdip_Startup()
if !Windy_CurWin_id
{
	DetectHiddenWindows, On
	WinGetTitle, h_hwnd, 获取当前窗口信息
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
	if !Windy_CurWin_id
		Windy_CurWin_id := WinExist("A")
}
gosub 窗口截图
exitapp

窗口截图:
if !picfilepath
	picfilepath := A_ScriptDir "\..\..\截图目录\截取窗口_" A_Now ".png"

WinActivate, ahk_id %Windy_CurWin_id%
pBitmap := Gdip_BitmapFromHWND(Windy_CurWin_id)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;窗口左上角坐标不是 0,0 而是 -8,-8, 所以要裁剪
GetWindowRect(Windy_CurWin_id, Width, Height)
WinGetPos, , , nW, nH, ahk_id %Windy_CurWin_id%
cropleftright := (nw - Width) / 2, cropdown := nH - Height
;msgbox % nw "|" Width "," nH "|" Height
WinGet, OutputVar, MinMax, ahk_id %Windy_CurWin_id%
if OutputVar
	pBitmap2 := Gdip_CropBitmap(pBitmap, cropleftright, cropleftright, cropdown, cropdown)
else
	pBitmap2 := Gdip_CropBitmap(pBitmap, cropleftright, cropleftright, 0, cropdown)
Gdip_SaveBitmapToFile(pBitmap2, picfilepath)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Gdip_SaveBitmapToFile(pBitmap, picfilepath)
Gdip_DisposeImage(pBitmap)
Gdip_DisposeImage(pBitmap2)
Gdip_Shutdown(pToken)
return

Gdip_CropBitmap(pBitmap, left, right, up, down, Dispose=1) { ; returns cropped bitmap. Specify how many pixels you want to crop (omit) from each side of bitmap rectangle. By Learning one.
Gdip_GetImageDimensions(pBitmap, origW, origH)
NewWidth := origW-left-right, NewHeight := origH-up-down
pBitmap2 := Gdip_CreateBitmap(NewWidth, NewHeight)
G2 := Gdip_GraphicsFromImage(pBitmap2), Gdip_SetSmoothingMode(G2, 4), Gdip_SetInterpolationMode(G2, 7)
Gdip_DrawImage(G2, pBitmap, 0, 0, NewWidth, NewHeight, left, up, NewWidth, NewHeight)
Gdip_DeleteGraphics(G2)
if Dispose
Gdip_DisposeImage(pBitmap)
return pBitmap2
}