;|2.4|2023.10.06|1503,1521
#SingleInstance force
; 参数1, 保存路径, 省略表示默认路径
; 参数2, 截图区域, 值为 "Window" 和 "Screen",  省略时默认为 "Screen"
; 参数3, 窗口句柄 表示窗口的句柄, 0 表示屏幕 1
; 参数4, 1 表示截取鼠标光标, 0 则不截取光标
CandySel := A_Args[1]
CaptureArea := (A_Args[2] = "") ? 0 : A_Args[2]
WinIdOrDesktopId := (A_Args[3] = "") ? 0 : A_Args[3]
bCursor := (A_Args[4] = "") ? 0 : A_Args[4]
;msgbox % CandySel "-" CaptureArea "-" WinIdOrDesktopId "-" bCursor

pToken := Gdip_Startup()

if instr(CaptureArea, "|")
{
	Tmp_Arr := StrSplit(CaptureArea,  "|")
	CaptureArea := Tmp_Arr[1]
	WinIdOrDesktopId := Tmp_Arr[2]
	bCursor := Tmp_Arr[3]
	;msgbox % CaptureArea "-" WinIdOrDesktopId "-" bCursor
}
if (CaptureArea = "Window")
{
	if !WinIdOrDesktopId
	{
		DetectHiddenWindows, On
		WinGetTitle, h_hwnd, 获取当前窗口信息
		Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
		if !Windy_CurWin_id
			Windy_CurWin_id := WinExist("A")
	}
	else
		Windy_CurWin_id := WinIdOrDesktopId
	gosub 截取窗口
}
else if (CaptureArea = 0) or (CaptureArea = "Screen")
	gosub 截取屏幕
exitapp

截取窗口:
if !CandySel
	CandySel := A_ScriptDir "\..\..\截图目录\截取窗口_" A_Now ".png"

WinActivate, ahk_id %Windy_CurWin_id%
pBitmap := Gdip_BitmapFromHWND(Windy_CurWin_id, , bCursor) ; 第2个参数为工作区域还是整个窗口, 默认为整个窗口

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
Gdip_SaveBitmapToFile(pBitmap2, CandySel)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;窗口左上角坐标不是 0,0 而是 -8,-8, 所以要裁剪

;Gdip_SaveBitmapToFile(pBitmap, CandySel)
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

截取屏幕:
if !CandySel
	CandySel := A_ScriptDir "\..\..\截图目录\截取屏幕_" A_Now ".png"
pBitmap := Gdip_BitmapFromScreen(WinIdOrDesktopId, , bCursor)
;msgbox % CandySel
Gdip_SaveBitmapToFile(pBitmap, CandySel)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
return