; Gdip_All.ahk - GDI+ library compilation of user contributed GDI+ functions
; made by Marius Șucan: https://github.com/marius-sucan/AHK-GDIp-Library-Compilation
; a fork from: https://github.com/mmikeww/AHKv2-Gdip
; based on https://github.com/tariqporter/Gdip
; Supports: AHK_L / AHK_H Unicode/ANSI x86/x64 and AHK v2 alpha
; This file is the AHK v2 edition; for AHK v1.1 compatible edition, please see the repository.
;
; NOTES: The drawing of GDI+ Bitmaps is limited to a size
; of 32767 pixels in either direction (width, height).
; To calculate the largest bitmap you can create:
;    The maximum object size is 2GB = 2,147,483,648 bytes
;    Default bitmap is 32bpp (4 bytes), the largest area we can have is 2GB / 4 = 536,870,912 bytes
;    If we want a square, the largest we can get is sqrt(2GB/4) = 23,170 pixels
;
; Gdip standard library versions:
; by Marius Șucan - gathered user-contributed functions and implemented hundreds of new functions
; - v1.84 on 05/06/2020
; - v1.83 on 24/05/2020
; - v1.82 on 11/03/2020
; - v1.81 on 25/02/2020
; - v1.80 on 11/01/2019
; - v1.79 on 10/28/2019
; - v1.78 on 10/27/2019
; - v1.77 on 10/06/2019
; - v1.76 on 09/27/2019
; - v1.75 on 09/23/2019
; - v1.74 on 09/19/2019
; - v1.73 on 09/17/2019
; - v1.72 on 09/16/2019
; - v1.71 on 09/15/2019
; - v1.70 on 09/13/2019
; - v1.69 on 09/12/2019
; - v1.68 on 09/11/2019
; - v1.67 on 09/10/2019
; - v1.66 on 09/09/2019
; - v1.65 on 09/08/2019
; - v1.64 on 09/07/2019
; - v1.63 on 09/06/2019
; - v1.62 on 09/05/2019
; - v1.61 on 09/04/2019
; - v1.60 on 09/03/2019
; - v1.59 on 09/01/2019
; - v1.58 on 08/29/2019
; - v1.57 on 08/23/2019
; - v1.56 on 08/21/2019
; - v1.55 on 08/14/2019
;
; bug fixes and AHK v2 compatibility by mmikeww and others
; - v1.54 on 11/15/2017
; - v1.53 on 06/19/2017
; - v1.52 on 06/11/2017
; - v1.51 on 01/27/2017
; - v1.50 on 11/20/2016
;
; - v1.47 on 02/20/2014 [?]
;
; modified by Rseding91 using fincs 64 bit compatible
; - v1.45 on 05/01/2013 
;
; by tic (Tariq Porter)
; - v1.45 on 07/09/2011 
; - v1.01 on 31/05/2008
;
; Detailed history:
; - 05/06/2020 = Synchronized with mmikeww's repository and fixed a few bugs
; - 24/05/2020 = Added a few more functions and fixed or improved already exiting functions
; - 11/02/2020 = Imported updated MDMF functions from mmikeww, and AHK v2 examples, and other minor changes
; - 25/02/2020 = Added several new functions, including for color conversions [from Tidbit], improved/fixed several functions
; - 11/01/2019 = Implemented support for a private font file for Gdip_AddPathStringSimplified()
; - 10/28/2019 = Added 7 new GDI+ functions and fixes related to Gdip_CreateFontFamilyFromFile()
; - 10/27/2019 = Added 5 new GDI+ functions and bug fixes for Gdip_TestBitmapUniformity(), Gdip_RotateBitmapAtCenter() and Gdip_ResizeBitmap()
; - 10/06/2019 = Added more parameters to Gdip_GraphicsFromImage/HDC/HWND and added Gdip_GetPixelColor()
; - 09/27/2019 = bug fixes...
; - 09/23/2019 = Added 4 new functions and improved Gdip_CreateBitmap() [ Marius Șucan ]
; - 09/19/2019 = Added 4 new functions and improved Gdip_RotateBitmapAtCenter() [ Marius Șucan ]
; - 09/17/2019 = Added 6 new GDI+ functions and renamed curve related functions [ Marius Șucan ]
; - 09/16/2019 = Added 10 new GDI+ functions [ Marius Șucan ]
; - 09/15/2019 = Added 3 new GDI+ functions and improved Gdip_DrawStringAlongPolygon() [ Marius Șucan ]
; - 09/13/2019 = Added 10 new GDI+ functions [ Marius Șucan ]
; - 09/12/2019 = Added 6 new GDI+ functions [ Marius Șucan ]
; - 09/11/2019 = Added 10 new GDI+ functions [ Marius Șucan ]
; - 09/10/2019 = Added 17 new GDI+ functions [ Marius Șucan ]
; - 09/09/2019 = Added 14 new GDI+ functions [ Marius Șucan ]
; - 09/08/2019 = Added 3 new functions and fixed Gdip_SetPenDashArray() [ Marius Șucan ]
; - 09/07/2019 = Added 12 new functions [ Marius Șucan ]
; - 09/06/2019 = Added 14 new GDI+ functions [ Marius Șucan ]
; - 09/05/2019 = Added 27 new GDI+ functions [ Marius Șucan ]
; - 09/04/2019 = Added 36 new GDI+ functions [ Marius Șucan ]
; - 09/03/2019 = Added about 37 new GDI+ functions [ Marius Șucan ]
; - 08/29/2019 = Fixed Gdip_GetPropertyTagName() [on AHK v2], Gdip_GetPenColor() and Gdip_GetSolidFillColor(), added Gdip_LoadImageFromFile()
; - 08/23/2019 = Added Gdip_FillRoundedRectangle2() and Gdip_DrawRoundedRectangle2(); extracted from Gdip2 by Tariq [tic] and corrected functions names
; - 08/21/2019 = Added GenerateColorMatrix() by Marius Șucan
; - 08/19/2019 = Added 12 functions. Extracted from a class wrapper for GDI+ written by nnnik in 2017.
; - 08/18/2019 = Added Gdip_AddPathRectangle() and eight PathGradient related functions by JustMe
; - 08/16/2019 = Added Gdip_DrawImageFX(), Gdip_CreateEffect() and other related functions [ Marius Șucan ]
; - 08/15/2019 = Added Gdip_DrawRoundedLine() by DevX and Rabiator
; - 08/15/2019 = Added 11 GraphicsPath related functions by "Learning one" and updated by Marius Șucan
; - 08/14/2019 = Added Gdip_IsVisiblePathPoint() and RotateAtCenter() by RazorHalo
; - 08/08/2019 = Added Gdi_GetDIBits() and Gdi_CreateDIBitmap() by Marius Șucan
; - 07/19/2019 = Added Gdip_GetHistogram() by swagfag and GetProperty GDI+ functions by JustMe
; - 11/15/2017 = compatibility with both AHK v2 and v1, restored by nnnik
; - 06/19/2017 = Fixed few bugs from old syntax by Bartlomiej Uliasz
; - 06/11/2017 = made code compatible with new AHK v2.0-a079-be5df98 by Bartlomiej Uliasz
; - 01/27/2017 = fixed some bugs and made #Warn All compatible by Bartlomiej Uliasz
; - 11/20/2016 = fixed Gdip_BitmapFromBRA() by 'just me'
; - 11/18/2016 = backward compatible support for both AHK v1.1 and AHK v2
; - 11/15/2016 = initial AHK v2 support by guest3456
; - 02/20/2014 = fixed Gdip_CreateRegion() and Gdip_GetClipRegion() on AHK Unicode x86
; - 05/13/2013 = fixed Gdip_SetBitmapToClipboard() on AHK Unicode x64
; - 07/09/2011 = v1.45 release by tic (Tariq Porter)
; - 31/05/2008 = v1.01 release by tic (Tariq Porter)
;
;#####################################################################################
; STATUS ENUMERATION
; Return values for functions specified to have status enumerated return type
;#####################################################################################
;
; Ok =                  = 0
; GenericError          = 1
; InvalidParameter      = 2
; OutOfMemory           = 3
; ObjectBusy            = 4
; InsufficientBuffer    = 5
; NotImplemented        = 6
; Win32Error            = 7
; WrongState            = 8
; Aborted               = 9
; FileNotFound          = 10
; ValueOverflow         = 11
; AccessDenied          = 12
; UnknownImageFormat    = 13
; FontFamilyNotFound    = 14
; FontStyleNotFound     = 15
; NotTrueTypeFont       = 16
; UnsupportedGdiplusVersion= 17
; GdiplusNotInitialized    = 18
; PropertyNotFound         = 19
; PropertyNotSupported     = 20
; ProfileNotFound          = 21
;
;#####################################################################################
; FUNCTIONS LIST
; See functions-list.txt file.
;#####################################################################################

; Function:             UpdateLayeredWindow
; Description:          Updates a layered window with the handle to the DC of a gdi bitmap
;
; hwnd                  Handle of the layered window to update
; hdc                   Handle to the DC of the GDI bitmap to update the window with
; x, y                  x, y coordinates to place the window
; w, h                  Width and height of the window
; Alpha                 Default = 255 : The transparency (0-255) to set the window transparency
;
; return                If the function succeeds, the return value is nonzero
;
; notes                 If x or y are omitted, the layered window will use its current coordinates
;                       If w or h are omitted, the current width and height will be used

UpdateLayeredWindow(hwnd, hdc, x:="", y:="", w:="", h:="", Alpha:=255)
{
	if ((x != "") && (y != "")) {
		pt := Buffer(8)
		NumPut("UInt", x, "UInt", y, pt)
	}

	if (w = "") || (h = "") {
		WinGetRect(hwnd,,, &w, &h)
	}

	return DllCall("UpdateLayeredWindow"
		, "UPtr", hwnd
		, "UPtr", 0
		, "UPtr", ((x = "") && (y = "")) ? 0 : pt.Ptr
		, "Int64*", w|h<<32
		, "UPtr", hdc
		, "Int64*", 0
		, "UInt", 0
		, "UInt*", Alpha<<16|1<<24
		, "UInt", 2)
}

;#####################################################################################

; Function        BitBlt
; Description     The BitBlt function performs a bit-block transfer of the color data corresponding to a rectangle
;                 of pixels from the specified source device context into a destination device context.
;
; dDC             handle to destination DC
; dX, dY          x, y coordinates of the destination upper-left corner
; dW, dH          width and height of the area to copy
; sDC             handle to source DC
; sX, sY          x, y coordinates of the source upper-left corner
; Raster          raster operation code
;
; return          If the function succeeds, the return value is nonzero
;
; notes           If no raster operation is specified, then SRCCOPY is used, which copies the source directly to the destination rectangle
;
; Raster operation codes:
; BLACKNESS          = 0x00000042
; NOTSRCERASE        = 0x001100A6
; NOTSRCCOPY         = 0x00330008
; SRCERASE           = 0x00440328
; DSTINVERT          = 0x00550009
; PATINVERT          = 0x005A0049
; SRCINVERT          = 0x00660046
; SRCAND             = 0x008800C6
; MERGEPAINT         = 0x00BB0226
; MERGECOPY          = 0x00C000CA
; SRCCOPY            = 0x00CC0020
; SRCPAINT           = 0x00EE0086
; PATCOPY            = 0x00F00021
; PATPAINT           = 0x00FB0A09
; WHITENESS          = 0x00FF0062
; CAPTUREBLT         = 0x40000000
; NOMIRRORBITMAP     = 0x80000000

BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, raster:="") {
; This function works only with GDI hBitmaps that 
; are Device-Dependent Bitmaps [DDB].

   
   return DllCall("gdi32\BitBlt"
               , "UPtr", dDC
               , "int", dX, "int", dY
               , "int", dW, "int", dH
               , "UPtr", sDC
               , "int", sX, "int", sY
               , "uint", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function        StretchBlt
; Description     The StretchBlt function copies a bitmap from a source rectangle into a destination rectangle,
;                 stretching or compressing the bitmap to fit the dimensions of the destination rectangle, if necessary.
;                 The system stretches or compresses the bitmap according to the stretching mode currently set in the destination device context.
;
; ddc             handle to destination DC
; dX, dY          x, y coordinates of the destination upper-left corner
; dW, dH          width and height of the destination rectangle
; sdc             handle to source DC
; sX, sY          x, y coordinates of the source upper-left corner
; sW, sH          width and height of the source rectangle
; Raster          raster operation code
;
; return          If the function succeeds, the return value is nonzero
;
; notes           If no raster operation is specified, then SRCCOPY is used. It uses the same raster operations as BitBlt

StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster:="")
{
	return DllCall("gdi32\StretchBlt"
					, "UPtr", ddc
					, "Int", dx
					, "Int", dy
					, "Int", dw
					, "Int", dh
					, "UPtr", sdc
					, "Int", sx
					, "Int", sy
					, "Int", sw
					, "Int", sh
					, "UInt", Raster ? Raster : 0x00CC0020)
}

;#####################################################################################

; Function           SetStretchBltMode
; Description        The SetStretchBltMode function sets the bitmap stretching mode in the specified device context
;
; hdc                handle to the DC
; iStretchMode       The stretching mode, describing how the target will be stretched
;
; return             If the function succeeds, the return value is the previous stretching mode. If it fails it will return 0
;
; iStretchMode options:
; BLACKONWHITE = 1
; COLORONCOLOR = 3
; HALFTONE = 4
; WHITEONBLACK = 2
; STRETCH_ANDSCANS = BLACKONWHITE
; STRETCH_DELETESCANS = COLORONCOLOR
; STRETCH_HALFTONE = HALFTONE
; STRETCH_ORSCANS = WHITEONBLACK

SetStretchBltMode(hdc, iStretchMode:=4)
{
	return DllCall("gdi32\SetStretchBltMode"
					, "UPtr", hdc
					, "Int", iStretchMode)
}

;#####################################################################################

; Function           SetImage
; Description        Associates a new image with a static control
;
; hwnd               handle of the control to update
; hBitmap            a gdi bitmap to associate the static control with
;
; return             If the function succeeds, the return value is nonzero

SetImage(hwnd, hBitmap)
{
	_E := DllCall( "SendMessage", "UPtr", hwnd, "UInt", 0x172, "UInt", 0x0, "UPtr", hBitmap )
	DeleteObject(_E)
	return _E
}

;#####################################################################################

; Function				SetSysColorToControl
; Description			Sets a solid colour to a control
;
; hwnd					handle of the control to update
; SysColor				A system colour to set to the control
;
; return				if the function succeeds, the return value is zero
;
; notes					A control must have the 0xE style set to it so it is recognised as a bitmap
;						By default SysColor=15 is used which is COLOR_3DFACE. This is the standard background for a control
;
; COLOR_3DDKSHADOW				= 21
; COLOR_3DFACE					= 15
; COLOR_3DHIGHLIGHT				= 20
; COLOR_3DHILIGHT				= 20
; COLOR_3DLIGHT					= 22
; COLOR_3DSHADOW				= 16
; COLOR_ACTIVEBORDER			= 10
; COLOR_ACTIVECAPTION			= 2
; COLOR_APPWORKSPACE			= 12
; COLOR_BACKGROUND				= 1
; COLOR_BTNFACE					= 15
; COLOR_BTNHIGHLIGHT			= 20
; COLOR_BTNHILIGHT				= 20
; COLOR_BTNSHADOW				= 16
; COLOR_BTNTEXT					= 18
; COLOR_CAPTIONTEXT				= 9
; COLOR_DESKTOP					= 1
; COLOR_GRADIENTACTIVECAPTION	= 27
; COLOR_GRADIENTINACTIVECAPTION	= 28
; COLOR_GRAYTEXT				= 17
; COLOR_HIGHLIGHT				= 13
; COLOR_HIGHLIGHTTEXT			= 14
; COLOR_HOTLIGHT				= 26
; COLOR_INACTIVEBORDER			= 11
; COLOR_INACTIVECAPTION			= 3
; COLOR_INACTIVECAPTIONTEXT		= 19
; COLOR_INFOBK					= 24
; COLOR_INFOTEXT				= 23
; COLOR_MENU					= 4
; COLOR_MENUHILIGHT				= 29
; COLOR_MENUBAR					= 30
; COLOR_MENUTEXT				= 7
; COLOR_SCROLLBAR				= 0
; COLOR_WINDOW					= 5
; COLOR_WINDOWFRAME				= 6
; COLOR_WINDOWTEXT				= 8

SetSysColorToControl(hwnd, SysColor:=15)
{
	WinGetRect(hwnd,,, &w, &h)
	bc := DllCall("GetSysColor", "Int", SysColor, "UInt")
	pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
	pBitmap := Gdip_CreateBitmap(w, h), G := Gdip_GraphicsFromImage(pBitmap)
	Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	SetImage(hwnd, hBitmap)
	Gdip_DeleteBrush(pBrushClear)
	Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
	return 0
}

;#####################################################################################

; Function        Gdip_BitmapFromScreen
; Description     Gets a gdi+ bitmap from the screen
;
; Screen          0 = All screens
;                 Any numerical value = Just that screen
;                 x|y|w|h = Take specific coordinates with a width and height
; Raster          raster operation code
;
; return          If the function succeeds, the return value is a pointer to a gdi+ bitmap
;                 -1: one or more of x,y,w,h parameters were not passed properly
;
; notes           If no raster operation is specified, then SRCCOPY is used to the returned bitmap

Gdip_BitmapFromScreen(Screen:=0, Raster:="")
{
	hhdc := 0
	if (Screen = 0) {
		_x := DllCall( "GetSystemMetrics", "Int", 76 )
		_y := DllCall( "GetSystemMetrics", "Int", 77 )
		_w := DllCall( "GetSystemMetrics", "Int", 78 )
		_h := DllCall( "GetSystemMetrics", "Int", 79 )
	}
	else if (SubStr(Screen, 1, 5) = "hwnd:") {
		Screen := SubStr(Screen, 6)
		if !WinExist("ahk_id " Screen) {
			return -2
		}
		WinGetRect(Screen,,, &_w, &_h)
		_x := _y := 0
		hhdc := GetDCEx(Screen, 3)
	}
	else if IsInteger(Screen) {
		M := GetMonitorInfo(Screen)
		_x := M.Left, _y := M.Top, _w := M.Right-M.Left, _h := M.Bottom-M.Top
	}
	else {
		S := StrSplit(Screen, "|")
		_x := S[1], _y := S[2], _w := S[3], _h := S[4]
	}

	if (_x = "") || (_y = "") || (_w = "") || (_h = "") {
		return -1
	}

	chdc := CreateCompatibleDC()
	hbm := CreateDIBSection(_w, _h, chdc)
	obm := SelectObject(chdc, hbm)
	hhdc := hhdc ? hhdc : GetDC()
	BitBlt(chdc, 0, 0, _w, _h, hhdc, _x, _y, Raster)
	ReleaseDC(hhdc)

	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)

	SelectObject(chdc, obm)
	DeleteObject(hbm)
	DeleteDC(hhdc)
	DeleteDC(chdc)
	return pBitmap
}

;#####################################################################################

; Function           Gdip_BitmapFromHWND
; Description        Uses PrintWindow to get a handle to the specified window and return a bitmap from it
;
; hwnd               handle to the window to get a bitmap from
; clientOnly         capture only the client area of the window, without title bar and border
;
; return             If the function succeeds, the return value is a pointer to a gdi+ bitmap

Gdip_BitmapFromHWND(hwnd)
{
	WinGetRect(hwnd,,, &Width, &Height)
	hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
	PrintWindow(hwnd, hdc)
	pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
	SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
	return pBitmap
}

;#####################################################################################

; Function           CreateRectF
; Description        Creates a RectF object, containing a the coordinates and dimensions of a rectangle
;
; RectF              Name to call the RectF object
; x, y               x, y coordinates of the upper left corner of the rectangle
; w, h               Width and height of the rectangle
;
; return             No return value

CreateRectF(&RectF, x, y, w, h)
{
	RectF := Buffer(16)
	NumPut(
		"Float", x, 
		"Float", y, 
		"Float", w, 
		"Float", h, 
		RectF)
}

;#####################################################################################

; Function           CreateRect
; Description        Creates a Rect object, containing a the coordinates and dimensions of a rectangle
;
; Rect               Name to call the Rect object
; x, y               x, y coordinates of the upper left corner of the rectangle
; x2, y2             x, y coordinates of the bottom right corner of the rectangle

; return             No return value

CreateRect(&Rect, x, y, w, h)
{
	Rect := Buffer(16)
	NumPut("UInt", x, "UInt", y, "UInt", w, "UInt", h, Rect)
}

;#####################################################################################

; Function           CreateSizeF
; Description        Creates a SizeF object, containing an 2 values
;
; SizeF              Name to call the SizeF object
; w, h               width and height values for the SizeF object
;
; return             No Return value

CreateSizeF(&SizeF, w, h)
{
	SizeF := Buffer(8)
	NumPut("Float", w, "Float", h, SizeF)
}

;#####################################################################################

; Function           CreatePointF
; Description        Creates a SizeF object, containing two values
;
; SizeF              Name to call the SizeF object
; x, y               x, y values for the SizeF object
;
; return             No Return value

CreatePointF(&PointF, x, y)
{
	PointF := Buffer(8)
	NumPut("Float", x, "Float", y, PointF)
}

CreatePointsF(&PointsF, inPoints) {
   Points := StrSplit(inPoints, "|")
   PointsCount := Points.Length
   PointsF := Buffer(8 * PointsCount)
   for eachPoint, Point in Points
   {
       Coord := StrSplit(Point, ",")
       NumPut(Coord[1], PointsF, 8*(A_Index-1), "float")
       NumPut(Coord[2], PointsF, (8*(A_Index-1))+4, "float")
   }
   Return PointsCount
}

;#####################################################################################

; Function           CreateDIBSection
; Description        The CreateDIBSection function creates a DIB (Device Independent Bitmap) that applications can write to directly
;
; w, h               width and height of the bitmap to create
; hdc                a handle to the device context to use the palette from
; bpp                bits per pixel (32 = ARGB)
; ppvBits            A pointer to a variable that receives a pointer to the location of the DIB bit values
;
; return             returns a DIB. A gdi bitmap
;
; notes              ppvBits will receive the location of the pixels in the DIB

CreateDIBSection(w, h, hdc:="", bpp:=32, &ppvBits:=0)
{
	hdc2 := hdc ? hdc : GetDC()
	bi := Buffer(40, 0)

	NumPut("UInt", 40, "UInt", w, "UInt", h, "ushort", 1, "ushort", bpp, "UInt", 0, bi)

	hbm := DllCall("CreateDIBSection"
					, "UPtr", hdc2
					, "UPtr", bi.Ptr
					, "UInt", 0
					, "UPtr*", &ppvBits
					, "UPtr", 0
					, "UInt", 0, "UPtr")

	if (!hdc) {
		ReleaseDC(hdc2)
	}
	return hbm
}

;#####################################################################################

; Function           PrintWindow
; Description        The PrintWindow function copies a visual window into the specified device context (DC), typically a printer DC
;
; hwnd               A handle to the window that will be copied
; hdc                A handle to the device context
; Flags              Drawing options
;
; return             If the function succeeds, it returns a nonzero value
;
; PW_CLIENTONLY      = 1

PrintWindow(hwnd, hdc, Flags:=0)
{
	return DllCall("PrintWindow", "UPtr", hwnd, "UPtr", hdc, "UInt", Flags)
}

;#####################################################################################

; Function           DestroyIcon
; Description        Destroys an icon and frees any memory the icon occupied
;
; hIcon              Handle to the icon to be destroyed. The icon must not be in use
;
; return             If the function succeeds, the return value is nonzero

DestroyIcon(hIcon) {
   return DllCall("DestroyIcon", "UPtr", hIcon)
}

;#####################################################################################

; Function:          GetIconDimensions
; Description:       Retrieves a given icon/cursor's width and height 
;
; hIcon              Pointer to an icon or cursor
; Width, Height      ByRef variables. These variables are set to the icon's width and height
;
; return             If the function succeeds, the return value is zero, otherwise:
;                    -1 = Could not retrieve the icon's info. Check A_LastError for extended information
;                    -2 = Could not delete the icon's bitmask bitmap
;                    -3 = Could not delete the icon's color bitmap

GetIconDimensions(hIcon, &Width:=0, &Height:=0) {
	ICONINFO := Buffer(size := 16 + 2 * A_PtrSize, 0)

	if !DllCall("user32\GetIconInfo", "UPtr", hIcon, "UPtr", ICONINFO.Ptr) {
		return -1
	}

	hbmMask := NumGet(ICONINFO.Ptr, 16, "UPtr")
	hbmColor := NumGet(ICONINFO.Ptr, 16 + A_PtrSize, "UPtr")
	BITMAP := Buffer(size, 0)

	if DllCall("gdi32\GetObject", "UPtr", hbmColor, "Int", size, "UPtr", BITMAP.Ptr) {
		Width := NumGet(BITMAP.Ptr, 4, "Int")
		Height := NumGet(BITMAP.Ptr, 8, "Int")
	}

	if !DllCall("gdi32\DeleteObject", "UPtr", hbmMask) {
		return -2
	}

	if !DllCall("gdi32\DeleteObject", "UPtr", hbmColor) {
		return -3
	}

	return 0
}

PaintDesktop(hdc) {
   return DllCall("PaintDesktop", "UPtr", hdc)
}

;#####################################################################################

; Function        CreateCompatibleDC
; Description     This function creates a memory device context (DC) compatible with the specified device
;
; hdc             Handle to an existing device context
;
; return          returns the handle to a device context or 0 on failure
;
; notes           If this handle is 0 (by default), the function creates a memory device context compatible with the application's current screen

CreateCompatibleDC(hdc:=0) {
   return DllCall("CreateCompatibleDC", "UPtr", hdc)
}

;#####################################################################################

; Function        SelectObject
; Description     The SelectObject function selects an object into the specified device context (DC). The new object replaces the previous object of the same type
;
; hdc             Handle to a DC
; hgdiobj         A handle to the object to be selected into the DC
;
; return          If the selected object is not a region and the function succeeds, the return value is a handle to the object being replaced
;
; notes           The specified object must have been created by using one of the following functions
;                 Bitmap - CreateBitmap, CreateBitmapIndirect, CreateCompatibleBitmap, CreateDIBitmap, CreateDIBSection (A single bitmap cannot be selected into more than one DC at the same time)
;                 Brush - CreateBrushIndirect, CreateDIBPatternBrush, CreateDIBPatternBrushPt, CreateHatchBrush, CreatePatternBrush, CreateSolidBrush
;                 Font - CreateFont, CreateFontIndirect
;                 Pen - CreatePen, CreatePenIndirect
;                 Region - CombineRgn, CreateEllipticRgn, CreateEllipticRgnIndirect, CreatePolygonRgn, CreateRectRgn, CreateRectRgnIndirect
;
; notes           If the selected object is a region and the function succeeds, the return value is one of the following value
;
; SIMPLEREGION    = 2 Region consists of a single rectangle
; COMPLEXREGION   = 3 Region consists of more than one rectangle
; NULLREGION      = 1 Region is empty

SelectObject(hdc, hgdiobj)
{
	return DllCall("SelectObject", "UPtr", hdc, "UPtr", hgdiobj)
}

;#####################################################################################

; Function           DeleteObject
; Description        This function deletes a logical pen, brush, font, bitmap, region, or palette, freeing all system resources associated with the object
;                    After the object is deleted, the specified handle is no longer valid
;
; hObject            Handle to a logical pen, brush, font, bitmap, region, or palette to delete
;
; return             Nonzero indicates success. Zero indicates that the specified handle is not valid or that the handle is currently selected into a device context

DeleteObject(hObject) {
   return DllCall("DeleteObject", "UPtr", hObject)
}

;#####################################################################################

; Function           GetDC
; Description        This function retrieves a handle to a display device context (DC) for the client area of the specified window.
;                    The display device context can be used in subsequent graphics display interface (GDI) functions to draw in the client area of the window.
;
; hwnd               Handle to the window whose device context is to be retrieved. If this value is NULL, GetDC retrieves the device context for the entire screen
;
; return             The handle the device context for the specified window's client area indicates success. NULL indicates failure

GetDC(hwnd:=0) {
   return DllCall("GetDC", "UPtr", hwnd)
}

; Device Context extended flags:
; DCX_CACHE = 0x2
; DCX_CLIPCHILDREN = 0x8
; DCX_CLIPSIBLINGS = 0x10
; DCX_EXCLUDERGN = 0x40
; DCX_EXCLUDEUPDATE = 0x100
; DCX_INTERSECTRGN = 0x80
; DCX_INTERSECTUPDATE = 0x200
; DCX_LOCKWINDOWUPDATE = 0x400
; DCX_NORECOMPUTE = 0x100000
; DCX_NORESETATTRS = 0x4
; DCX_PARENTCLIP = 0x20
; DCX_VALIDATE = 0x200000
; DCX_WINDOW = 0x1

GetDCEx(hwnd, flags:=0, hrgnClip:=0)
{
	return DllCall("GetDCEx", "UPtr", hwnd, "UPtr", hrgnClip, "Int", flags)
}

;#####################################################################################

; Function        ReleaseDC
; Description     This function releases a device context (DC), freeing it for use by other applications. The effect of ReleaseDC depends on the type of device context
;
; hdc             Handle to the device context to be released
; hwnd            Handle to the window whose device context is to be released
;
; return          1 = released
;                 0 = not released
;
; notes           The application must call the ReleaseDC function for each call to the GetWindowDC function and for each call to the GetDC function that retrieves a common device context
;                 An application cannot use the ReleaseDC function to release a device context that was created by calling the CreateDC function; instead, it must use the DeleteDC function.

ReleaseDC(hdc, hwnd:=0)
{
	return DllCall("ReleaseDC", "UPtr", hwnd, "UPtr", hdc)
}

;#####################################################################################

; Function           DeleteDC
; Description        The DeleteDC function deletes the specified device context (DC)
;
; hdc                A handle to the device context
;
; return             If the function succeeds, the return value is nonzero
;
; notes              An application must not delete a DC whose handle was obtained by calling the GetDC function. Instead, it must call the ReleaseDC function to free the DC

DeleteDC(hdc) {
   return DllCall("DeleteDC", "UPtr", hdc)
}

;#####################################################################################

; Function           Gdip_LibraryVersion
; Description        Get the current library version
;
; return             the library version
;
; notes              This is useful for non compiled programs to ensure that a person doesn't run an old version when testing your scripts

Gdip_LibraryVersion() {
   return 1.45
}

;#####################################################################################

; Function        Gdip_LibrarySubVersion
; Description     Get the current library sub version
;
; return          the library sub version
;
; notes           This is the sub-version currently maintained by Rseding91
;                 Updated by guest3456 preliminary AHK v2 support
;                 Updated by Marius Șucan reflecting the work on Gdip_all extended compilation

Gdip_LibrarySubVersion() {
   return 1.84
}

;#####################################################################################

; Function:          Gdip_BitmapFromBRA
; Description:       Gets a pointer to a gdi+ bitmap from a BRA file
;
; BRAFromMemIn       The variable for a BRA file read to memory
; File               The name of the file, or its number that you would like (This depends on alternate parameter)
; Alternate          Changes whether the File parameter is the file name or its number
;
; return             If the function succeeds, the return value is a pointer to a gdi+ bitmap
;                    -1 = The BRA variable is empty
;                    -2 = The BRA has an incorrect header
;                    -3 = The BRA has information missing
;                    -4 = Could not find file inside the BRA

Gdip_BitmapFromBRA(BRAFromMemIn, File, Alternate := 0) {
	if (!BRAFromMemIn) {
		return -1
	}

	Headers := StrSplit(StrGet(BRAFromMemIn.Ptr, 256, "CP0"), "`n")
	Header := StrSplit(Headers[1], "|")
	HeaderLength := Header.Length

	if (HeaderLength != 4) || (Header[2] != "BRA!") {
		return -2
	}

	_Info := StrSplit(Headers[2], "|")
	_InfoLength := _Info.Length

	if (_InfoLength != 3) {
		return -3
	}

	OffsetTOC := StrPut(Headers[1], "CP0") + StrPut(Headers[2], "CP0") ;  + 2
	OffsetData := _Info[2]
	SearchIndex := Alternate ? 1 : 2
	TOC := StrGet(BRAFromMemIn.Ptr + OffsetTOC, OffsetData - OffsetTOC - 1, "CP0")
	RX1 := "mi`n)^"
	Offset := Size := 0

	if RegExMatch(TOC, RX1 . (Alternate ? File "\|.+?" : "\d+\|" . File) . "\|(\d+)\|(\d+)$", &FileInfo:="") {
		Offset := OffsetData + FileInfo[1]
		Size := FileInfo[2]
	}

	if (Size = 0) {
		return -4
	}

	hData := DllCall("GlobalAlloc", "UInt", 2, "UInt", Size, "UPtr")
	pData := DllCall("GlobalLock", "Ptr", hData, "UPtr")
	DllCall("RtlMoveMemory", "Ptr", pData, "Ptr", BRAFromMemIn.Ptr + Offset, "Ptr", Size)
	DllCall("GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", 1, "Ptr*", &pStream:=0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream", "Ptr", pStream, "Ptr*", &pBitmap:=0)
	ObjRelease(pStream)

	return pBitmap
}

;#####################################################################################

; Function:        Gdip_BitmapFromBase64
; Description:     Creates a bitmap from a Base64 encoded string
;
; Base64           ByRef variable. Base64 encoded string. Immutable, ByRef to avoid performance overhead of passing long strings.
;
; return           If the function succeeds, the return value is a pointer to a bitmap, otherwise:
;                 -1 = Could not calculate the length of the required buffer
;                 -2 = Could not decode the Base64 encoded string
;                 -3 = Could not create a memory stream

Gdip_BitmapFromBase64(&Base64)
{
	; calculate the length of the buffer needed
	if !(DllCall("crypt32\CryptStringToBinary", "UPtr", StrPtr(Base64), "UInt", 0, "UInt", 0x01, "UPtr", 0, "UInt*", &DecLen:=0, "UPtr", 0, "UPtr", 0)) {
		return -1
	}

	Dec := Buffer(DecLen, 0)

	; decode the Base64 encoded string
	if !(DllCall("crypt32\CryptStringToBinary", "UPtr", StrPtr(Base64), "UInt", 0, "UInt", 0x01, "UPtr", Dec.Ptr, "UInt*", &DecLen, "UPtr", 0, "UPtr", 0)) {
		return -2
	}

	; create a memory stream
	if !(pStream := DllCall("shlwapi\SHCreateMemStream", "UPtr", Dec.Ptr, "UInt", DecLen, "UPtr")) {
		return -3
	}

	DllCall("gdiplus\GdipCreateBitmapFromStreamICM", "UPtr", pStream, "Ptr*", &pBitmap:=0)
	ObjRelease(pStream)

	return pBitmap
}

;#####################################################################################

; Function:				Gdip_EncodeBitmapTo64string
; Description:			Encode a bitmap to a Base64 encoded string
;
; pBitmap				Pointer to a bitmap
; sOutput				The name of the file that the bitmap will be saved to. Supported extensions are: .BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.JFIF,.GIF,.TIF,.TIFF,.PNG
; Quality				if saving as jpg (.JPG,.JPEG,.JPE,.JFIF) then quality can be 1-100 with default at maximum quality
;
; return				if the function succeeds, the return value is a Base64 encoded string of the pBitmap

Gdip_EncodeBitmapTo64string(pBitmap, extension := "png", quality := "") {

    ; Fill a buffer with the available image codec info.
    DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", &count:=0, "uint*", &size:=0)
    DllCall("gdiplus\GdipGetImageEncoders", "uint", count, "uint", size, "ptr", ci := Buffer(size))

    ; struct ImageCodecInfo - http://www.jose.it-berater.org/gdiplus/reference/structures/imagecodecinfo.htm
    loop {
        if (A_Index > count)
        throw Error("Could not find a matching encoder for the specified file format.")

        idx := (48+7*A_PtrSize)*(A_Index-1)
    } until InStr(StrGet(NumGet(ci, idx+32+3*A_PtrSize, "ptr"), "UTF-16"), extension) ; FilenameExtension

    ; Get the pointer to the clsid of the matching encoder.
    pCodec := ci.ptr + idx ; ClassID

    ; JPEG default quality is 75. Otherwise set a quality value from [0-100].
    if (quality ~= "^-?\d+$") and ("image/jpeg" = StrGet(NumGet(ci, idx+32+4*A_PtrSize, "ptr"), "UTF-16")) { ; MimeType
        ; Use a separate buffer to store the quality as ValueTypeLong (4).
        v := Buffer(4)
		NumPut("uint", quality, v)

        ; struct EncoderParameter - http://www.jose.it-berater.org/gdiplus/reference/structures/encoderparameter.htm
        ; enum ValueType - https://docs.microsoft.com/en-us/dotnet/api/system.drawing.imaging.encoderparametervaluetype
        ; clsid Image Encoder Constants - http://www.jose.it-berater.org/gdiplus/reference/constants/gdipimageencoderconstants.htm
        ep := Buffer(24+2*A_PtrSize)                  ; sizeof(EncoderParameter) = ptr + n*(28, 32)
        NumPut(  "uptr",     1, ep,            0)  ; Count
        DllCall("ole32\CLSIDFromString", "wstr", "{1D5BE4B5-FA4A-452D-9CDD-5DB35105E7EB}", "ptr", ep.ptr+A_PtrSize, "HRESULT")
        NumPut(  "uint",     1, ep, 16+A_PtrSize)  ; Number of Values
        NumPut(  "uint",     4, ep, 20+A_PtrSize)  ; Type
        NumPut(   "ptr", v.ptr, ep, 24+A_PtrSize)  ; Value
    }

    ; Create a Stream.
    DllCall("ole32\CreateStreamOnHGlobal", "ptr", 0, "int", True, "ptr*", &pStream:=0, "HRESULT")
    DllCall("gdiplus\GdipSaveImageToStream", "ptr", pBitmap, "ptr", pStream, "ptr", pCodec, "ptr", IsSet(ep) ? ep : 0)

    ; Get a pointer to binary data.
    DllCall("ole32\GetHGlobalFromStream", "ptr", pStream, "ptr*", &hbin:=0, "HRESULT")
    bin := DllCall("GlobalLock", "ptr", hbin, "ptr")
    size := DllCall("GlobalSize", "uint", bin, "uptr")

    ; Calculate the length of the base64 string.
    flags := 0x40000001 ; CRYPT_STRING_NOCRLF | CRYPT_STRING_BASE64
    length := 4 * Ceil(size/3) + 1 ; An extra byte of padding is required.
    str := Buffer(length)

    ; Using CryptBinaryToStringA saves about 2MB in memory.
    DllCall("crypt32\CryptBinaryToStringA", "ptr", bin, "uint", size, "uint", flags, "ptr", str, "uint*", &length)

    ; Release binary data and stream.
    DllCall("GlobalUnlock", "ptr", hbin)
    ObjRelease(pStream)
    
    ; Return encoded string length minus 1.
    return StrGet(str, length, "CP0")
}

;#####################################################################################

; Function           Gdip_DrawRectangle
; Description        This function uses a pen to draw the outline of a rectangle into the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pPen               Pointer to a pen
; x, y               x, y coordinates of the top left of the rectangle
; w, h               width and height of the rectangle
;
; return             status enumeration. 0 = success
;
; notes              as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
	return DllCall("gdiplus\GdipDrawRectangle", "UPtr", pGraphics, "UPtr", pPen, "Float", x, "Float", y, "Float", w, "Float", h)
}
;#####################################################################################

; Function           Gdip_DrawRoundedRectangle
; Description        This function uses a pen to draw the outline of a rounded rectangle into the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pPen               Pointer to a pen
; x, y               x, y coordinates of the top left of the rounded rectangle
; w, h               width and height of the rectanlge
; r                  radius of the rounded corners
;
; return             status enumeration. 0 = success
;
; notes              as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r) {
   Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
   Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
   Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
   Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
   _E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
   Gdip_ResetClip(pGraphics)
   Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
   Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
   Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
   Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
   Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
   Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
   Gdip_ResetClip(pGraphics)
   return _E
}

Gdip_DrawRoundedRectangle2(pGraphics, pPen, x, y, w, h, r, Angle:=0) {
; extracted from: https://github.com/tariqporter/Gdip2/blob/master/lib/Object.ahk
; and adapted by Marius Șucan

   penWidth := Gdip_GetPenWidth(pPen)
   pw := penWidth / 2
   if (w <= h && (r + pw > w / 2))
   {
      r := (w / 2 > pw) ? w / 2 - pw : 0
   } else if (h < w && r + pw > h / 2)
   {
      r := (h / 2 > pw) ? h / 2 - pw : 0
   } else if (r < pw / 2)
   {
      r := pw / 2
   }

   r2 := r * 2
   path1 := Gdip_CreatePath(0)
   Gdip_AddPathArc(path1, x + pw, y + pw, r2, r2, 180, 90)
   Gdip_AddPathLine(path1, x + pw + r, y + pw, x + w - r - pw, y + pw)
   Gdip_AddPathArc(path1, x + w - r2 - pw, y + pw, r2, r2, 270, 90)
   Gdip_AddPathLine(path1, x + w - pw, y + r + pw, x + w - pw, y + h - r - pw)
   Gdip_AddPathArc(path1, x + w - r2 - pw, y + h - r2 - pw, r2, r2, 0, 90)
   Gdip_AddPathLine(path1, x + w - r - pw, y + h - pw, x + r + pw, y + h - pw)
   Gdip_AddPathArc(path1, x + pw, y + h - r2 - pw, r2, r2, 90, 90)
   Gdip_AddPathLine(path1, x + pw, y + h - r - pw, x + pw, y + r + pw)
   Gdip_ClosePathFigure(path1)
   If (Angle>0)
      Gdip_RotatePathAtCenter(path1, Angle)
   _E := Gdip_DrawPath(pGraphics, pPen, path1)
   Gdip_DeletePath(path1)
   return _E
}

;#####################################################################################

; Function           Gdip_DrawEllipse
; Description        This function uses a pen to draw the outline of an ellipse into the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pPen               Pointer to a pen
; x, y               x, y coordinates of the top left of the rectangle the ellipse will be drawn into
; w, h               width and height of the ellipse
;
; return             status enumeration. 0 = success
;
; notes              as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
	return DllCall("gdiplus\GdipDrawEllipse", "UPtr", pGraphics, "UPtr", pPen, "Float", x, "Float", y, "Float", w, "Float", h)
}

;#####################################################################################

; Function        Gdip_DrawBezier
; Description     This function uses a pen to draw the outline of a bezier (a weighted curve) into the Graphics of a bitmap
; A Bezier spline does not pass through its control points. The control points act as magnets, pulling the curve
; in certain directions to influence the way the spline bends.

; pGraphics       Pointer to the Graphics of a bitmap
; pPen            Pointer to a pen
; x1, y1          x, y coordinates of the start of the bezier
; x2, y2          x, y coordinates of the first arc of the bezier
; x3, y3          x, y coordinates of the second arc of the bezier
; x4, y4          x, y coordinates of the end of the bezier
;
; return          status enumeration. 0 = success
;
; notes           as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4)
{
	return DllCall("gdiplus\GdipDrawBezier"
					, "UPtr", pgraphics
					, "UPtr", pPen
					, "Float", x1
					, "Float", y1
					, "Float", x2
					, "Float", y2
					, "Float", x3
					, "Float", y3
					, "Float", x4
					, "Float", y4)
}

;#####################################################################################

; Function           Gdip_DrawBezierCurve
; Description        This function uses a pen to draw beziers
; Parameters:
; pGraphics          Pointer to the Graphics of a bitmap
; pPen               Pointer to a pen
; Points
;   An array of starting and control points of a Bezier line
;   A single Bezier line consists of 4 points a starting point 2 control
;   points and an end point.
;   The line never actually goes through the control points.
;   The control points define the tangent in the starting and end points and their
;   distance controls how strongly the curve follows there.
;
; Return: status enumeration. 0 = success
;
; This function was extracted and modified by Marius Șucan from
; a class based wrapper around the GDI+ API made by nnnik.
; Source: https://github.com/nnnik/classGDIp
;
; Points array format:
; Points := "x1,y1|x2,y2|x3,y3|x4,y4" [... and so on]

Gdip_DrawBezierCurve(pGraphics, pPen, Points) {
   iCount := CreatePointsF(PointsF, Points)
   return DllCall("gdiplus\GdipDrawBeziers", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount)
}

Gdip_DrawClosedCurve(pGraphics, pPen, Points, Tension:="") {
; Draws a closed cardinal spline on a pGraphics object using a pPen object.
; A cardinal spline is a curve that passes through each point in the array.

; Tension: Non-negative real number that controls the length of the curve and how the curve bends. A value of
; zero specifies that the spline is a sequence of straight lines. As the value increases, the curve becomes fuller.
; Number that specifies how tightly the curve bends through the coordinates of the closed cardinal spline.

; Example points array:
; Points := "x1,y1|x2,y2|x3,y3" [and so on]
; At least three points must be defined.

   iCount := CreatePointsF(PointsF, Points)
   If Tension
      return DllCall("gdiplus\GdipDrawClosedCurve2", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount, "float", Tension)
   Else
      return DllCall("gdiplus\GdipDrawClosedCurve", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount)
}

Gdip_DrawCurve(pGraphics, pPen, Points, Tension:="") {
; Draws an open spline on a pGraphics object using a pPen object.
; A cardinal spline is a curve that passes through each point in the array.

; Tension: Non-negative real number that controls the length of the curve and how the curve bends. A value of
; zero specifies that the spline is a sequence of straight lines. As the value increases, the curve becomes fuller.
; Number that specifies how tightly the curve bends through the coordinates of the closed cardinal spline.

; Example points array:
; Points := "x1,y1|x2,y2|x3,y3" [and so on]
; At least three points must be defined.

   iCount := CreatePointsF(PointsF, Points)
   If Tension
      return DllCall("gdiplus\GdipDrawCurve2", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount, "float", Tension)
   Else
      return DllCall("gdiplus\GdipDrawCurve", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount)
}

Gdip_DrawPolygon(pGraphics, pPen, Points) {
; Draws a closed polygonal line on a pGraphics object using a pPen object.
;
; Example points array:
; Points := "x1,y1|x2,y2|x3,y3" [and so on]

   iCount := CreatePointsF(PointsF, Points)
   return DllCall("gdiplus\GdipDrawPolygon", "UPtr", pGraphics, "UPtr", pPen, "UPtr", &PointsF, "UInt", iCount)
}

;#####################################################################################

; Function           Gdip_DrawArc
; Description        This function uses a pen to draw the outline of an arc into the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pPen               Pointer to a pen
; x, y               x, y coordinates of the start of the arc
; w, h               width and height of the arc
; StartAngle         specifies the angle between the x-axis and the starting point of the arc
; SweepAngle         specifies the angle between the starting and ending points of the arc
;
; return             status enumeration. 0 = success
;
; notes              as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
	return DllCall("gdiplus\GdipDrawArc"
					, "UPtr", pGraphics
					, "UPtr", pPen
					, "Float", x
					, "Float", y
					, "Float", w
					, "Float", h
					, "Float", StartAngle
					, "Float", SweepAngle)
}

;#####################################################################################

; Function           Gdip_DrawPie
; Description        This function uses a pen to draw the outline of a pie into the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pPen               Pointer to a pen
; x, y               x, y coordinates of the start of the pie
; w, h               width and height of the pie
; StartAngle         specifies the angle between the x-axis and the starting point of the pie
; SweepAngle         specifies the angle between the starting and ending points of the pie
;
; return             status enumeration. 0 = success
;
; notes              as all coordinates are taken from the top left of each pixel, then the entire width/height should be specified as subtracting the pen width

Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
	return DllCall("gdiplus\GdipDrawPie", "UPtr", pGraphics, "UPtr", pPen, "Float", x, "Float", y, "Float", w, "Float", h, "Float", StartAngle, "Float", SweepAngle)
}

;#####################################################################################

; Function        Gdip_DrawLine
; Description     This function uses a pen to draw a line into the Graphics of a bitmap
;
; pGraphics       Pointer to the Graphics of a bitmap
; pPen            Pointer to a pen
; x1, y1          x, y coordinates of the start of the line
; x2, y2          x, y coordinates of the end of the line
;
; return          status enumeration. 0 = success

Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
	return DllCall("gdiplus\GdipDrawLine"
					, "UPtr", pGraphics
					, "UPtr", pPen
					, "Float", x1
					, "Float", y1
					, "Float", x2
					, "Float", y2)
}

;#####################################################################################

; Function           Gdip_DrawLines
; Description        This function uses a pen to draw a series of joined lines into the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pPen               Pointer to a pen
; Points             the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return             status enumeration. 0 = success

Gdip_DrawLines(pGraphics, pPen, points)
{
	points := StrSplit(points, "|")
	pointF := Buffer(8*points.Length)
	pointsLength := 0
	for point in points {
		coords := StrSplit(point, ",")
		if (coords.Length != 2) {
			if (coords.Length > 0) {
				MsgBox("Skipping wrong points of length " coords.Length)
			}
			continue
		}
		NumPut("Float", coords[1], pointF, 8*(A_Index-1))
		NumPut("Float", coords[2], pointF, (8*(A_Index-1))+4)
		pointsLength += 1
	}
	return DllCall("gdiplus\GdipDrawLines", "UPtr", pGraphics, "UPtr", pPen, "UPtr", pointF.Ptr, "Int", pointsLength)
}

;#####################################################################################

; Function           Gdip_FillRectangle
; Description        This function uses a brush to fill a rectangle in the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pBrush             Pointer to a brush
; x, y               x, y coordinates of the top left of the rectangle
; w, h               width and height of the rectangle
;
; return             status enumeration. 0 = success

Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
	return DllCall("gdiplus\GdipFillRectangle"
					, "UPtr", pGraphics
					, "UPtr", pBrush
					, "Float", x
					, "Float", y
					, "Float", w
					, "Float", h)
}

;#####################################################################################

; Function           Gdip_FillRoundedRectangle
; Description        This function uses a brush to fill a rounded rectangle in the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pBrush             Pointer to a brush
; x, y               x, y coordinates of the top left of the rounded rectangle
; w, h               width and height of the rectanlge
; r                  radius of the rounded corners
;
; return             status enumeration. 0 = success

Gdip_FillRoundedRectangle2(pGraphics, pBrush, x, y, w, h, r) {
; extracted from: https://github.com/tariqporter/Gdip2/blob/master/lib/Object.ahk
; and adapted by Marius Șucan

   r := (w <= h) ? (r < w // 2) ? r : w // 2 : (r < h // 2) ? r : h // 2
   path1 := Gdip_CreatePath(0)
   Gdip_AddPathRectangle(path1, x+r, y, w-(2*r), r)
   Gdip_AddPathRectangle(path1, x+r, y+h-r, w-(2*r), r)
   Gdip_AddPathRectangle(path1, x, y+r, r, h-(2*r))
   Gdip_AddPathRectangle(path1, x+w-r, y+r, r, h-(2*r))
   Gdip_AddPathRectangle(path1, x+r, y+r, w-(2*r), h-(2*r))
   Gdip_AddPathPie(path1, x, y, 2*r, 2*r, 180, 90)
   Gdip_AddPathPie(path1, x+w-(2*r), y, 2*r, 2*r, 270, 90)
   Gdip_AddPathPie(path1, x, y+h-(2*r), 2*r, 2*r, 90, 90)
   Gdip_AddPathPie(path1, x+w-(2*r), y+h-(2*r), 2*r, 2*r, 0, 90)
   E := Gdip_FillPath(pGraphics, pBrush, path1)
   Gdip_DeletePath(path1)
   return E
}

Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
	Region := Gdip_GetClipRegion(pGraphics)
	Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
	Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
	_E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
	Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
	Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
	Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
	Gdip_SetClipRegion(pGraphics, Region, 0)
	Gdip_DeleteRegion(Region)
	return _E
}

;#####################################################################################

; Function           Gdip_FillPolygon
; Description        This function uses a brush to fill a polygon in the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pBrush             Pointer to a brush
; Points             the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; return             status enumeration. 0 = success
;
; notes              Alternate will fill the polygon as a whole, wheras winding will fill each new "segment"
; Alternate          = 0
; Winding            = 1

Gdip_FillPolygon(pGraphics, pBrush, Points, FillMode:=0)
{
	Points := StrSplit(Points, "|")
	PointsLength := Points.Length
	PointF := Buffer(8*PointsLength)
	For eachPoint, Point in Points
	{
		Coord := StrSplit(Point, ",")
		NumPut("Float", Coord[1], PointF, 8*(A_Index-1))
		NumPut("Float", Coord[2], PointF, (8*(A_Index-1))+4)
	}
	return DllCall("gdiplus\GdipFillPolygon", "UPtr", pGraphics, "UPtr", pBrush, "UPtr", PointF.Ptr, "Int", PointsLength, "Int", FillMode)
}

;#####################################################################################

; Function           Gdip_FillPie
; Description        This function uses a brush to fill a pie in the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pBrush             Pointer to a brush
; x, y               x, y coordinates of the top left of the pie
; w, h               width and height of the pie
; StartAngle         specifies the angle between the x-axis and the starting point of the pie
; SweepAngle         specifies the angle between the starting and ending points of the pie
;
; return             status enumeration. 0 = success

Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle) {
   
   return DllCall("gdiplus\GdipFillPie"
               , "UPtr", pGraphics
               , "UPtr", pBrush
               , "float", x
               , "float", y
               , "float", w
               , "float", h
               , "float", StartAngle
               , "float", SweepAngle)
}

;#####################################################################################

; Function           Gdip_FillEllipse
; Description        This function uses a brush to fill an ellipse in the Graphics of a bitmap
;
; pGraphics          Pointer to the Graphics of a bitmap
; pBrush             Pointer to a brush
; x, y               x, y coordinates of the top left of the ellipse
; w, h               width and height of the ellipse
;
; return             status enumeration. 0 = success

Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h)
{
	return DllCall("gdiplus\GdipFillEllipse", "UPtr", pGraphics, "UPtr", pBrush, "Float", x, "Float", y, "Float", w, "Float", h)
}

;#####################################################################################

; Function        Gdip_FillRegion
; Description     This function uses a brush to fill a region in the Graphics of a bitmap
;
; pGraphics       Pointer to the Graphics of a bitmap
; pBrush          Pointer to a brush
; Region          Pointer to a Region
;
; return          status enumeration. 0 = success
;
; notes           You can create a region Gdip_CreateRegion() and then add to this

Gdip_FillRegion(pGraphics, pBrush, Region)
{
	return DllCall("gdiplus\GdipFillRegion", "UPtr", pGraphics, "UPtr", pBrush, "UPtr", Region)
}

;#####################################################################################

; Function        Gdip_FillPath
; Description     This function uses a brush to fill a path in the Graphics of a bitmap
;
; pGraphics       Pointer to the Graphics of a bitmap
; pBrush          Pointer to a brush
; Region          Pointer to a Path
;
; return          status enumeration. 0 = success

Gdip_FillPath(pGraphics, pBrush, pPath)
{
	return DllCall("gdiplus\GdipFillPath", "UPtr", pGraphics, "UPtr", pBrush, "UPtr", pPath)
}

;#####################################################################################

; Function        Gdip_FillClosedCurve
; Description     This function fills a closed cardinal spline on a pGraphics object
;                 using a pBrush object.
;                 A cardinal spline is a curve that passes through each point in the array.
;
; pGraphics       Pointer to the Graphics of a bitmap
; pBrush          Pointer to a brush
;
; Points array format:
; Points := "x1,y1|x2,y2|x3,y3|x4,y4" [... and so on]
;
; Tension         Non-negative real number that controls the length of the curve and how the curve bends. A value of
;                 zero specifies that the spline is a sequence of straight lines. As the value increases, the curve becomes fuller.
;                 Number that specifies how tightly the curve bends through the coordinates of the closed cardinal spline.
;
; Fill mode:      0 - [Alternate] The areas are filled according to the even-odd parity rule
;                 1 - [Winding] The areas are filled according to the non-zero winding rule
;
; return          status enumeration. 0 = success

Gdip_FillClosedCurve(pGraphics, pBrush, Points, Tension:="", FillMode:=0) {
   
   iCount := CreatePointsF(PointsF, Points)
   If Tension
      Return DllCall("gdiplus\GdipFillClosedCurve2", "UPtr", pGraphics, "UPtr", pBrush, "UPtr", &PointsF, "int", iCount, "float", Tension, "int", FillMode)
   Else
      Return DllCall("gdiplus\GdipFillClosedCurve", "UPtr", pGraphics, "UPtr", pBrush, "UPtr", &PointsF, "int", iCount)
}

;#####################################################################################

; Function        Gdip_DrawImagePointsRect
; Description     This function draws a bitmap into the Graphics of another bitmap and skews it
;
; pGraphics       Pointer to the Graphics of a bitmap
; pBitmap         Pointer to a bitmap to be drawn
; Points          Points passed as x1,y1|x2,y2|x3,y3 (3 points: top left, top right, bottom left) describing the drawing of the bitmap
; sX, sY          x, y coordinates of the source upper-left corner
; sW, sH          width and height of the source rectangle
; Matrix          a color matrix used to alter image attributes when drawing
; Unit            see Gdip_DrawImage()
; Return          status enumeration. 0 = success
;
; Notes           If sx, sy, sw, sh are omitted the entire source bitmap will be used.
;                 Matrix can be omitted to just draw with no alteration to ARGB.
;                 Matrix may be passed as a digit from 0 - 1 to change just transparency.
;                 Matrix can be passed as a matrix with "|" delimiter.
;                 To generate a color matrix using user-friendly parameters,
;                 use GenerateColorMatrix()

Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points, sx:="", sy:="", sw:="", sh:="", Matrix:=1)
{
	Points := StrSplit(Points, "|")
	PointsLength := Points.Length
	PointF := Buffer(8*PointsLength)
	For eachPoint, Point in Points
	{
		Coord := StrSplit(Point, ",")
		NumPut("Float", Coord[1], PointF, 8*(A_Index-1))
		NumPut("Float", Coord[2], PointF, (8*(A_Index-1))+4)
	}

	if !IsNumber(Matrix)
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
	else
		ImageAttr := 0

	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		sx := 0, sy := 0
		sw := Gdip_GetImageWidth(pBitmap)
		sh := Gdip_GetImageHeight(pBitmap)
	}

	_E := DllCall("gdiplus\GdipDrawImagePointsRect"
				, "UPtr", pGraphics
				, "UPtr", pBitmap
				, "UPtr", PointF.Ptr
				, "Int", PointsLength
				, "Float", sx
				, "Float", sy
				, "Float", sw
				, "Float", sh
				, "Int", 2
				, "UPtr", ImageAttr
				, "UPtr", 0
				, "UPtr", 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return _E
}

;#####################################################################################

; Function        Gdip_DrawImage
; Description     This function draws a bitmap into the Graphics of another bitmap
;
; pGraphics       Pointer to the Graphics of a bitmap
; pBitmap         Pointer to a bitmap to be drawn
; dX, dY          x, y coordinates of the destination upper-left corner
; dW, dH          width and height of the destination image
; sX, sY          x, y coordinates of the source upper-left corner
; sW, sH          width and height of the source image
; Matrix          a color matrix used to alter image attributes when drawing
; Unit            Unit of measurement:
;                 0 - World coordinates, a nonphysical unit
;                 1 - Display units
;                 2 - A unit is 1 pixel
;                 3 - A unit is 1 point or 1/72 inch
;                 4 - A unit is 1 inch
;                 5 - A unit is 1/300 inch
;                 6 - A unit is 1 millimeter
;
; return          status enumeration. 0 = success
;
; notes           When sx,sy,sw,sh are omitted the entire source bitmap will be used
;                 Gdip_DrawImage performs faster.
;                 Matrix can be omitted to just draw with no alteration to ARGB
;                 Matrix may be passed as a digit from 0.0 - 1.0 to change just transparency
;                 Matrix can be passed as a matrix with "|" as delimiter. For example:
;                 MatrixBright=
;                 (
;                 1.5   |0    |0    |0    |0
;                 0     |1.5  |0    |0    |0
;                 0     |0    |1.5  |0    |0
;                 0     |0    |0    |1    |0
;                 0.05  |0.05 |0.05 |0    |1
;                 )
;
; example color matrix:
;                 MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;                 MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;                 MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|1|1|1|0|1
;                 To generate a color matrix using user-friendly parameters,
;                 use GenerateColorMatrix()

Gdip_DrawImage(pGraphics, pBitmap, dx:="", dy:="", dw:="", dh:="", sx:="", sy:="", sw:="", sh:="", Matrix:=1)
{
	if !IsNumber(Matrix)
		ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
	else if (Matrix != 1)
		ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
	else
		ImageAttr := 0

	if (sx = "" && sy = "" && sw = "" && sh = "")
	{
		if (dx = "" && dy = "" && dw = "" && dh = "")
		{
			sx := dx := 0, sy := dy := 0
			sw := dw := Gdip_GetImageWidth(pBitmap)
			sh := dh := Gdip_GetImageHeight(pBitmap)
		}
		else
		{
			sx := sy := 0
			sw := Gdip_GetImageWidth(pBitmap)
			sh := Gdip_GetImageHeight(pBitmap)
		}
	}

	_E := DllCall("gdiplus\GdipDrawImageRectRect"
				, "UPtr", pGraphics
				, "UPtr", pBitmap
				, "Float", dx
				, "Float", dy
				, "Float", dw
				, "Float", dh
				, "Float", sx
				, "Float", sy
				, "Float", sw
				, "Float", sh
				, "Int", 2
				, "UPtr", ImageAttr
				, "UPtr", 0
				, "UPtr", 0)
	if ImageAttr
		Gdip_DisposeImageAttributes(ImageAttr)
	return _E
}

Gdip_DrawImageFast(pGraphics, pBitmap, X:=0, Y:=0) {
; This function performs faster than Gdip_DrawImage().
; X, Y - the coordinates of the destination upper-left corner
; where the pBitmap will be drawn.

   
   _E := DllCall("gdiplus\GdipDrawImage"
            , "UPtr", pGraphics
            , "UPtr", pBitmap
            , "float", X
            , "float", Y)
   return _E
}

Gdip_DrawImageRect(pGraphics, pBitmap, X, Y, W, H) {
; X, Y - the coordinates of the destination upper-left corner
; where the pBitmap will be drawn.
; W, H - the width and height of the destination rectangle, where the pBitmap will be drawn.

   
   _E := DllCall("gdiplus\GdipDrawImageRect"
            , "UPtr", pGraphics
            , "UPtr", pBitmap
            , "float", X, "float", Y
            , "float", W, "float", H)
   return _E
}

;#####################################################################################

; Function        Gdip_SetImageAttributesColorMatrix
; Description     This function creates an image color matrix ready for drawing if no ImageAttr is given.
;                 It can set or clear the color and/or grayscale-adjustment matrices for a specified ImageAttr object.
;
; clrMatrix       A color-adjustment matrix used to alter image attributes when drawing
;                 passed with "|" as delimeter.
; grayMatrix      A grayscale-adjustment matrix used to alter image attributes when drawing
;                 passed with "|" as delimeter. This applies only when ColorMatrixFlag=2.
;
; ColorAdjustType The category for which the color and grayscale-adjustment matrices are set or cleared.
;                 0 - adjustments apply to all categories that do not have adjustment settings of their own
;                 1 - adjustments apply to bitmapped images
;                 2 - adjustments apply to brush operations in metafiles
;                 3 - adjustments apply to pen operations in metafiles
;                 4 - adjustments apply to text drawn in metafiles
;
; fEnable         If True, the specified matrices (color, grayscale or both) adjustments for the specified
;                 category are applied; otherwise the category is cleared
;
; ColorMatrixFlag Type of image and color that will be affected by the adjustment matrices:
;                 0 - All color values (including grays) are adjusted by the same color-adjustment matrix.
;                 1 - Colors are adjusted but gray shades are not adjusted.
;                     A gray shade is any color that has the same value for its red, green, and blue components.
;                 2 - Colors are adjusted by one matrix and gray shades are adjusted by another matrix.

; ImageAttr       A pointer to an ImageAttributes object.
;                 If this parameter is omitted, a new one is created.

; return          It return 0 on success, if an ImageAttr object was given,
;                 otherwise, it returns the handle of a new ImageAttr object [if succesful].
;
; notes           MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;                 MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;                 MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|1|1|1|0|1
;                 To generate a color matrix using user-friendly parameters,
;                 use GenerateColorMatrix()
; additional remarks:
; In my tests, it seems that the grayscale matrix is not functioning properly.
; Grayscale images are rendered invisible [with zero opacity] for some reason...
; TO DO: fix this?

Gdip_SetImageAttributesColorMatrix(Matrix)
{
	ColourMatrix := Buffer(100, 0)
	Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", , 1), "[^\d-\.]+", "|")
	Matrix := StrSplit(Matrix, "|")

	loop 25 {
		M := (Matrix[A_Index] != "") ? Matrix[A_Index] : Mod(A_Index-1, 6) ? 0 : 1
		NumPut("Float", M, ColourMatrix, (A_Index-1)*4)
	}

	DllCall("gdiplus\GdipCreateImageAttributes", "UPtr*", &ImageAttr:=0)
	DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "UPtr", ImageAttr, "Int", 1, "Int", 1, "UPtr", ColourMatrix.Ptr, "UPtr", 0, "Int", 0)

	return ImageAttr
}

Gdip_CreateImageAttributes() {
   ImageAttr := 0
   DllCall("gdiplus\GdipCreateImageAttributes", "UPtr*", ImageAttr)
   return ImageAttr
}

Gdip_CloneImageAttributes(ImageAttr) {
   
   newImageAttr := 0
   DllCall("gdiplus\GdipCloneImageAttributes", "UPtr", ImageAttr, "UPtr*", newImageAttr)
   return newImageAttr
}

Gdip_SetImageAttributesThreshold(ImageAttr, Threshold, ColorAdjustType:=1, fEnable:=1) {
; Sets or clears the threshold (transparency range) for a specified category by ColorAdjustType
; The threshold is a value from 0 through 1 that specifies a cutoff point for each color component. For example,
; suppose the threshold is set to 0.7, and suppose you are rendering a color whose red, green, and blue
; components are 230, 50, and 220. The red component, 230, is greater than 0.7ª255, so the red component will
; be changed to 255 (full intensity). The green component, 50, is less than 0.7ª255, so the green component will
; be changed to 0. The blue component, 220, is greater than 0.7ª255, so the blue component will be changed to 255.

   
   return DllCall("gdiplus\GdipSetImageAttributesThreshold", "UPtr", ImageAttr, "int", ColorAdjustType, "int", fEnable, "float", Threshold)
}

Gdip_SetImageAttributesResetMatrix(ImageAttr, ColorAdjustType) {
; Sets the color-adjustment matrix of a specified category to the identity matrix.

   
   return DllCall("gdiplus\GdipSetImageAttributesToIdentity", "UPtr", ImageAttr, "int", ColorAdjustType)
}

Gdip_SetImageAttributesGamma(ImageAttr, Gamma, ColorAdjustType:=1, fEnable:=1) {
; Gamma from 0.1 to 5.0

   
   return DllCall("gdiplus\GdipSetImageAttributesGamma", "UPtr", ImageAttr, "int", ColorAdjustType, "int", fEnable, "float", Gamma)
}

Gdip_SetImageAttributesToggle(ImageAttr, ColorAdjustType, fEnable) {
; Turns on or off color adjustment for a specified category defined by ColorAdjustType
; fEnable - 0 or 1

   
   return DllCall("gdiplus\GdipSetImageAttributesNoOp", "UPtr", ImageAttr, "int", ColorAdjustType, "int", fEnable)
}

Gdip_SetImageAttributesOutputChannel(ImageAttr, ColorChannelFlags, ColorAdjustType:=1, fEnable:=1) {
; ColorChannelFlags - The output channel, can be any combination:
; 0 - Cyan color channel
; 1 - Magenta color channel
; 2 - Yellow color channel
; 3 - Black color channel
; 4 - The previous selected channel

   
   return DllCall("gdiplus\GdipSetImageAttributesOutputChannel", "UPtr", ImageAttr, "int", ColorAdjustType, "int", fEnable, "int", ColorChannelFlags)
}

Gdip_SetImageAttributesColorKeys(ImageAttr, ARGBLow, ARGBHigh, ColorAdjustType:=1, fEnable:=1) {
; initial tests of this function lead to a crash of the application ...

   
   Return DllCall("gdiplus\GdipSetImageAttributesColorKeys", "UPtr", ImageAttr, "int", ColorAdjustType, "int", fEnable, "uint", ARGBLow, "uint", ARGBHigh)
}

Gdip_SetImageAttributesWrapMode(ImageAttr, WrapMode, ARGB) {
; ImageAttr - Pointer to an ImageAttribute object
; WrapMode  - Specifies how repeated copies of an image are used to tile an area:
;             0 - Tile - Tiling without flipping
;             1 - TileFlipX - Tiles are flipped horizontally as you move from one tile to the next in a row
;             2 - TileFlipY - Tiles are flipped vertically as you move from one tile to the next in a column
;             3 - TileFlipXY - Tiles are flipped horizontally as you move along a row and flipped vertically as you move along a column
;             4 - Clamp - No tiling takes place
; ARGB      - Alpha, Red, Green and Blue components of the color of pixels outside of a rendered image.
;             This color is visible if the wrap mode is set to 4 and the source rectangle of the image is greater than the
;             image itself.

   
   Return DllCall("gdiplus\GdipSetImageAttributesWrapMode", "UPtr", ImageAttr, "int", WrapMode, "uint", ARGB, "int", 0)
}

Gdip_ResetImageAttributes(ImageAttr, ColorAdjustType) {
; Clears all color and grayscale-adjustment settings for a specified category defined by ColorAdjustType.
;
; ImageAttr - a pointer to an ImageAttributes object.
; ColorAdjustType - The category for which color adjustment is reset:
; see Gdip_SetImageAttributesColorMatrix() for details.

   
   DllCall("gdiplus\GdipResetImageAttributes", "UPtr", ImageAttr, "int", ColorAdjustType)
}

;#####################################################################################

; Function           Gdip_GraphicsFromImage
; Description        This function gets the graphics for a bitmap used for drawing functions
;
; pBitmap            Pointer to a bitmap to get the pointer to its graphics
;
; return             returns a pointer to the graphics of a bitmap
;
; notes              a bitmap can be drawn into the graphics of another bitmap

Gdip_GraphicsFromImage(pBitmap)
{
	DllCall("gdiplus\GdipGetImageGraphicsContext", "UPtr", pBitmap, "UPtr*", &pGraphics:=0)
	return pGraphics
}

;#####################################################################################

; Function           Gdip_GraphicsFromHDC
; Description        This function gets the graphics from the handle of a device context.
;
; hDC                The handle to the device context.
; hDevice            Handle to a device that will be associated with the new Graphics object.
;
; return             A pointer to the graphics of a bitmap.
;
; notes              You can draw a bitmap into the graphics of another bitmap.

Gdip_GraphicsFromHDC(hdc)
{
	DllCall("gdiplus\GdipCreateFromHDC", "UPtr", hdc, "UPtr*", &pGraphics:=0)
	return pGraphics
}

Gdip_GraphicsFromHWND(HWND, useICM:=0, InterpolationMode:="", SmoothingMode:="", PageUnit:="", CompositingQuality:="") {
; Creates a pGraphics object that is associated with a specified window handle [HWND]
; If useICM=1, the created graphics uses ICM [color management - (International Color Consortium = ICC)].
   pGraphics := 0
   function2call := (useICM=1) ? "GdipCreateFromHWNDICM" : "GdipCreateFromHWND"
   DllCall("gdiplus\" function2call, "UPtr", HWND, "UPtr*", pGraphics)

   If pGraphics
   {
      If (InterpolationMode!="")
         Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
      If (SmoothingMode!="")
         Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
      If (PageUnit!="")
         Gdip_SetPageUnit(pGraphics, PageUnit)
      If (CompositingQuality!="")
         Gdip_SetCompositingMode(pGraphics, CompositingQuality)
   }
   return pGraphics
}

;#####################################################################################

; Function           Gdip_GetDC
; Description        This function gets the device context of the passed Graphics
;
; hDC                This is the handle to the device context
;
; return             returns the device context for the graphics of a bitmap

Gdip_GetDC(pGraphics)
{
	DllCall("gdiplus\GdipGetDC", "UPtr", pGraphics, "UPtr*", &hdc:=0)
	return hdc
}

;#####################################################################################

; Function           Gdip_ReleaseDC
; Description        This function releases a device context from use for further use
;
; pGraphics          Pointer to the graphics of a bitmap
; hdc                This is the handle to the device context
;
; return             status enumeration. 0 = success

Gdip_ReleaseDC(pGraphics, hdc)
{
	return DllCall("gdiplus\GdipReleaseDC", "UPtr", pGraphics, "UPtr", hdc)
}

;#####################################################################################

; Function           Gdip_GraphicsClear
; Description        Clears the graphics of a bitmap ready for further drawing
;
; pGraphics          Pointer to the graphics of a bitmap
; ARGB               The colour to clear the graphics to
;
; return             status enumeration. 0 = success
;
; notes              By default this will make the background invisible
;                    Using clipping regions you can clear a particular area on the graphics rather than clearing the entire graphics

Gdip_GraphicsClear(pGraphics, ARGB:=0x00ffffff) {
   return DllCall("gdiplus\GdipGraphicsClear", "UPtr", pGraphics, "int", ARGB)
}

Gdip_GraphicsFlush(pGraphics, intent) {
; intent - Specifies whether the method returns immediately or waits for any existing operations to finish:
; 0 - Flush all batched rendering operations and return immediately
; 1 - Flush all batched rendering operations and wait for them to complete

   return DllCall("gdiplus\GdipFlush", "UPtr", pGraphics, "int", intent)
}

;#####################################################################################

; Function           Gdip_BlurBitmap
; Description        Gives a pointer to a blurred bitmap from a pointer to a bitmap
;
; pBitmap            Pointer to a bitmap to be blurred
; BlurAmount         The Amount to blur a bitmap by from 1 (least blur) to 100 (most blur)
;
; return             If the function succeeds, the return value is a pointer to the new blurred bitmap
;                    -1 = The blur parameter is outside the range 1-100
;
; notes              This function will not dispose of the original bitmap

Gdip_BlurBitmap(pBitmap, Blur)
{
	if (Blur > 100 || Blur < 1) {
		return -1
	}

	sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
	dWidth := sWidth//Blur, dHeight := sHeight//Blur

	pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
	G1 := Gdip_GraphicsFromImage(pBitmap1)
	Gdip_SetInterpolationMode(G1, 7)
	Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)

	Gdip_DeleteGraphics(G1)

	pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
	G2 := Gdip_GraphicsFromImage(pBitmap2)
	Gdip_SetInterpolationMode(G2, 7)
	Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)

	Gdip_DeleteGraphics(G2)
	Gdip_DisposeImage(pBitmap1)

	return pBitmap2
}

;#####################################################################################

; Function:				Gdip_SaveBitmapToFile
; Description:			Saves a bitmap to a file in any supported format onto disk
;
; pBitmap				Pointer to a bitmap
; sOutput				The name of the file that the bitmap will be saved to. Supported extensions are: .BMP,.DIB,.RLE,.JPG,.JPEG,.JPE,.JFIF,.GIF,.TIF,.TIFF,.PNG
; Quality				if saving as jpg (.JPG,.JPEG,.JPE,.JFIF) then quality can be 1-100 with default at maximum quality
;
; return				if the function succeeds, the return value is zero, otherwise:
;						-1 = Extension supplied is not a supported file format
;						-2 = Could not get a list of encoders on system
;						-3 = Could not find matching encoder for specified file format
;						-4 = Could not get WideChar name of output file
;						-5 = Could not save file to disk
;
; notes					This function will use the extension supplied from the sOutput parameter to determine the output format

Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality:=75)
{
	_p := 0

	SplitPath sOutput,,, &extension:=""
	if (!RegExMatch(extension, "^(?i:BMP|DIB|RLE|JPG|JPEG|JPE|JFIF|GIF|TIF|TIFF|PNG)$")) {
		return -1
	}
	extension := "." extension

	DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", &nCount:=0, "uint*", &nSize:=0)
	ci := Buffer(nSize)
	DllCall("gdiplus\GdipGetImageEncoders", "UInt", nCount, "UInt", nSize, "UPtr", ci.Ptr)
	if !(nCount && nSize) {
		return -2
	}

	loop nCount {
		address := NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize, "UPtr")
		sString := StrGet(address, "UTF-16")
		if !InStr(sString, "*" extension)
			continue

		pCodec := ci.Ptr+idx
		break
	}

	if !pCodec {
		return -3
	}

	if (Quality != 75) {
		Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality

		if RegExMatch(extension, "^\.(?i:JPG|JPEG|JPE|JFIF)$") {
			DllCall("gdiplus\GdipGetEncoderParameterListSize", "UPtr", pBitmap, "UPtr", pCodec, "uint*", &nSize)
			EncoderParameters := Buffer(nSize, 0)
			DllCall("gdiplus\GdipGetEncoderParameterList", "UPtr", pBitmap, "UPtr", pCodec, "UInt", nSize, "UPtr", EncoderParameters.Ptr)
			nCount := NumGet(EncoderParameters, "UInt")
			loop nCount
			{
				elem := (24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
				if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
				{
					_p := elem + EncoderParameters.Ptr - pad - 4
					NumPut("UInt", Quality, NumGet(NumPut("UInt", 4, NumPut("UInt", 1, _p+0)+20), "UInt"))
					break
				}
			}
		}
	}

	_E := DllCall("gdiplus\GdipSaveImageToFile", "UPtr", pBitmap, "UPtr", StrPtr(sOutput), "UPtr", pCodec, "UInt", _p ? _p : 0)

	return _E ? -5 : 0
}

;#####################################################################################

; Function           Gdip_GetPixel
; Description        Gets the ARGB of a pixel in a bitmap
;
; pBitmap            Pointer to a bitmap
; x, y               x, y coordinates of the pixel
;
; return             Returns the ARGB value of the pixel

Gdip_GetPixel(pBitmap, x, y)
{
	DllCall("gdiplus\GdipBitmapGetPixel", "UPtr", pBitmap, "Int", x, "Int", y, "uint*", &ARGB:=0)
	return ARGB
}

Gdip_GetPixelColor(pBitmap, x, y, Format) {
   ARGBdec := Gdip_GetPixel(pBitmap, x, y)
   If (format=1)  ; in ARGB [HEX; 00-FF] with 0x prefix
   {
      Return Format("{1:#x}", ARGBdec)
   } Else If (format=2)  ; in RGBA [0-255]
   {
      Gdip_FromARGB(ARGBdec, &A, &R, &G, &B)
      Return R "," G "," B "," A
   } Else If (format=3)  ; in BGR [HEX; 00-FF] with 0x prefix
   {
      clr := Format("{1:#x}", ARGBdec)
      Return "0x" SubStr(clr, -1) SubStr(clr, 7, 2) SubStr(clr, 5, 2)
   } Else If (format=4)  ; in RGB [HEX; 00-FF] with no prefix
   {
      Return SubStr(Format("{1:#x}", ARGBdec), 5)
   } Else Return ARGBdec
}

;#####################################################################################

; Function           Gdip_SetPixel
; Description        Sets the ARGB of a pixel in a bitmap
;
; pBitmap            Pointer to a bitmap
; x, y               x, y coordinates of the pixel
;
; return             status enumeration. 0 = success

Gdip_SetPixel(pBitmap, x, y, ARGB) {
   return DllCall("gdiplus\GdipBitmapSetPixel", "UPtr", pBitmap, "int", x, "int", y, "int", ARGB)
}

;#####################################################################################

; Function           Gdip_GetImageWidth
; Description        Gives the width of a bitmap
;
; pBitmap            Pointer to a bitmap
;
; return             Returns the width in pixels of the supplied bitmap

Gdip_GetImageWidth(pBitmap)
{
	DllCall("gdiplus\GdipGetImageWidth", "UPtr", pBitmap, "uint*", &Width:=0)
	return Width
}

;#####################################################################################

; Function           Gdip_GetImageHeight
; Description        Gives the height of a bitmap
;
; pBitmap            Pointer to a bitmap
;
; return             Returns the height in pixels of the supplied bitmap

Gdip_GetImageHeight(pBitmap)
{
	DllCall("gdiplus\GdipGetImageHeight", "UPtr", pBitmap, "uint*", &Height:=0)
	return Height
}

;#####################################################################################

; Function           Gdip_GetImageDimensions
; Description        Gives the width and height of a bitmap
;
; pBitmap            Pointer to a bitmap
; Width              ByRef variable. This variable will be set to the width of the bitmap
; Height             ByRef variable. This variable will be set to the height of the bitmap
;
; return             GDI+ status enumeration return value

Gdip_GetImageDimensions(pBitmap, &Width, &Height)
{
	DllCall("gdiplus\GdipGetImageWidth", "UPtr", pBitmap, "uint*", &Width:=0)
	DllCall("gdiplus\GdipGetImageHeight", "UPtr", pBitmap, "uint*", &Height:=0)
}

Gdip_GetImageDimension(pBitmap, &w, &h) {
   
   return DllCall("gdiplus\GdipGetImageDimension", "UPtr", pBitmap, "float*", w, "float*", h)
}

Gdip_GetDimensions(pBitmap, &Width, &Height)
{
	Gdip_GetImageDimensions(pBitmap, &Width, &Height)
}

Gdip_GetImageBounds(pBitmap) {
  
  rData := {}

  RectF := Buffer(16)
  status := DllCall("gdiplus\GdipGetImageBounds", "UPtr", pBitmap, "UPtr", RectF.Ptr, "Int*", 0)

  If (!status) {
        rData.x := NumGet(RectF, 0, "float")
      , rData.y := NumGet(RectF, 4, "float")
      , rData.w := NumGet(RectF, 8, "float")
      , rData.h := NumGet(RectF, 12, "float")
  } Else {
    Return status
  }

  return rData
}

; Gets a set of flags that indicate certain attributes of this Image object.
; Returns an element of the ImageFlags Enumeration that holds a set of single-bit flags.
; ImageFlags enumeration
   ; None              := 0x0000  ; Specifies no format information.
   ; ; Low-word: shared with SINKFLAG_x:
   ; Scalable          := 0x00001  ; the image can be scaled.
   ; HasAlpha          := 0x00002  ; the pixel data contains alpha values.
   ; HasTranslucent    := 0x00004  ; the pixel data has alpha values other than 0 (transparent) and 255 (opaque).
   ; PartiallyScalable := 0x00008  ; the pixel data is partially scalable with some limitations.
   ; ; Low-word: color space definition:
   ; ColorSpaceRGB     := 0x00010  ; the image is stored using an RGB color space.
   ; ColorSpaceCMYK    := 0x00020  ; the image is stored using a CMYK color space.
   ; ColorSpaceGRAY    := 0x00040  ; the image is a grayscale image.
   ; ColorSpaceYCBCR   := 0x00080  ; the image is stored using a YCBCR color space.
   ; ColorSpaceYCCK    := 0x00100  ; the image is stored using a YCCK color space.
   ; ; Low-word: image size info:
   ; HasRealDPI        := 0x01000  ; dots per inch information is stored in the image.
   ; HasRealPixelSize  := 0x02000  ; the pixel size is stored in the image.
   ; ; High-word:
   ; ReadOnly          := 0x10000  ; the pixel data is read-only.
   ; Caching           := 0x20000  ; the pixel data can be cached for faster access.
; function extracted from : https://github.com/flipeador/Library-AutoHotkey/tree/master/graphics
; by flipeador
Gdip_GetImageFlags(pBitmap) {
   DllCall("Gdiplus.dll\GdipGetImageFlags", "Ptr", pBitmap, "UInt*", &Flags:=0)
   Return Flags
}

;#####################################################################################

/*
; v2 属性名不能带有 "{, }" 这两个符号
Gdip_GetImageRawFormat(pBitmap) {
; retrieves the pBitmap [file] format

  Static RawFormatsList := {`{B96B3CA9-0728-11D3-9D7B-0000F81EF32E`}:"Undefined", `{B96B3CAA-0728-11D3-9D7B-0000F81EF32E`}:"MemoryBMP", `{B96B3CAB-0728-11D3-9D7B-0000F81EF32E`}:"BMP", `{B96B3CAC-0728-11D3-9D7B-0000F81EF32E`}:"EMF", `{B96B3CAD-0728-11D3-9D7B-0000F81EF32E`}:"WMF", `{B96B3CAE-0728-11D3-9D7B-0000F81EF32E`}:"JPEG", `{B96B3CAF-0728-11D3-9D7B-0000F81EF32E`}:"PNG", `{B96B3CB0-0728-11D3-9D7B-0000F81EF32E`}:"GIF", `{B96B3CB1-0728-11D3-9D7B-0000F81EF32E`}:"TIFF", `{B96B3CB2-0728-11D3-9D7B-0000F81EF32E`}:"EXIF", `{B96B3CB5-0728-11D3-9D7B-0000F81EF32E`}:"Icon"}
  
  pGuid:=buffer( 16, 0)
  E1 := DllCall("gdiplus\GdipGetImageRawFormat", "UPtr", pBitmap, "Ptr", &pGuid)

  size := sguid:=buffer( (38 << !!A_IsUnicode) + 1, 0)
  E2 := DllCall("ole32.dll\StringFromGUID2", "ptr", &pguid, "ptr", &sguid, "int", size)
  R1 := E2 ? StrGet(&sguid) : E2
  R2 := RawFormatsList[R1]
  Return R2 ? R2 : R1
}
*/


; Mode options 
; 0 - in decimal
; 1 - in hex
; 2 - in human readable format
;
; PXF01INDEXED = 0x00030101  ; 1 bpp, indexed
; PXF04INDEXED = 0x00030402  ; 4 bpp, indexed
; PXF08INDEXED = 0x00030803  ; 8 bpp, indexed
; PXF16GRAYSCALE = 0x00101004; 16 bpp, grayscale
; PXF16RGB555 = 0x00021005   ; 16 bpp; 5 bits for each RGB
; PXF16RGB565 = 0x00021006   ; 16 bpp; 5 bits red, 6 bits green, and 5 bits blue
; PXF16ARGB1555 = 0x00061007 ; 16 bpp; 1 bit for alpha and 5 bits for each RGB component
; PXF24RGB = 0x00021808   ; 24 bpp; 8 bits for each RGB
; PXF32RGB = 0x00022009   ; 32 bpp; 8 bits for each RGB, no alpha.
; PXF32ARGB = 0x0026200A  ; 32 bpp; 8 bits for each RGB and alpha
; PXF32PARGB = 0x000E200B ; 32 bpp; 8 bits for each RGB and alpha, pre-mulitiplied
; PXF48RGB = 0x0010300C   ; 48 bpp; 16 bits for each RGB
; PXF64ARGB = 0x0034400D  ; 64 bpp; 16 bits for each RGB and alpha
; PXF64PARGB = 0x001A400E ; 64 bpp; 16 bits for each RGB and alpha, pre-multiplied

; INDEXED [1-bits, 4-bits and 8-bits] pixel formats rely on color palettes.
; The color information for the pixels is stored in palettes.
; Indexed images always contain a palette - a special table of colors.
; Each pixel is an index in this table. Usually a palette contains 256
; or less entries. That's why the maximum depth of an indexed pixel is 8 bpp.
; Using palettes is a common practice when working with small color depths.

; modified by Marius Șucan

Gdip_GetImagePixelFormat(pBitmap, mode:=0) {

   Static PixelFormatsList := {0x30101:"1-INDEXED", 0x30402:"4-INDEXED", 0x30803:"8-INDEXED", 0x101004:"16-GRAYSCALE", 0x021005:"16-RGB555", 0x21006:"16-RGB565", 0x61007:"16-ARGB1555", 0x21808:"24-RGB", 0x22009:"32-RGB", 0x26200A:"32-ARGB", 0xE200B:"32-PARGB", 0x10300C:"48-RGB", 0x34400D:"64-ARGB", 0x1A400E:"64-PARGB"}
   PixelFormat := 0
   E := DllCall("gdiplus\GdipGetImagePixelFormat", "UPtr", pBitmap, "UPtr*", PixelFormat)
   If E
      Return -1

   If (mode=0)
      Return PixelFormat

   inHEX := Format("{1:#x}", PixelFormat)
   If (PixelFormatsList.Haskey(inHEX) && mode=2)
      result := PixelFormatsList[inHEX]
   Else
      result := inHEX
   return result
}

/*
;#####################################################################################

Gdip_GetImagePixelFormat(pBitmap)
{
	DllCall("gdiplus\GdipGetImagePixelFormat", "UPtr", pBitmap, "UPtr*", &_Format:=0)
	return _Format
}
*/

Gdip_GetImageType(pBitmap) {
; RETURN VALUES:
; UNKNOWN = 0
; BITMAP = 1
; METAFILE = 2
; ERROR = -1
   result := 0
   E := DllCall("gdiplus\GdipGetImageType", "UPtr", pBitmap, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_GetDPI(pGraphics, &DpiX, &DpiY) {
   DpiX := Gdip_GetDpiX(pGraphics)
   DpiY := Gdip_GetDpiY(pGraphics)
}

Gdip_GetDpiX(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiX", "UPtr", pGraphics, "float*", &dpix:=0)
	return Round(dpix)
}

Gdip_GetDpiY(pGraphics)
{
	DllCall("gdiplus\GdipGetDpiY", "UPtr", pGraphics, "float*", &dpiy:=0)
	return Round(dpiy)
}

Gdip_GetImageHorizontalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageHorizontalResolution", "UPtr", pBitmap, "float*", &dpix:=0)
	return Round(dpix)
}

Gdip_GetImageVerticalResolution(pBitmap)
{
	DllCall("gdiplus\GdipGetImageVerticalResolution", "UPtr", pBitmap, "float*", &dpiy:=0)
	return Round(dpiy)
}

Gdip_BitmapSetResolution(pBitmap, dpix, dpiy) {
   return DllCall("gdiplus\GdipBitmapSetResolution", "UPtr", pBitmap, "float", dpix, "float", dpiy)
}

Gdip_BitmapGetDPIResolution(pBitmap, &dpix, &dpiy) {
   dpix := dpiy := 0
   If StrLen(pBitmap)<3
      Return

   dpix := Gdip_GetImageHorizontalResolution(pBitmap)
   dpiy := Gdip_GetImageVerticalResolution(pBitmap)
}

Gdip_CreateBitmapFromGraphics(pGraphics, Width, Height) {
  
  PtrA := "UPtr*"
  pBitmap := 0
  DllCall("gdiplus\GdipCreateBitmapFromGraphics", "int", Width, "int", Height, "UPtr", pGraphics, PtrA, pBitmap)
  Return pBitmap
}

Gdip_CreateBitmapFromFile(sFile, IconNumber:=1, IconSize:="")
{
	SplitPath sFile,,, &extension:=""
	if RegExMatch(extension, "^(?i:exe|dll)$") {
		Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
		BufSize := 16 + (2*(A_PtrSize ? A_PtrSize : 4))

		buf := Buffer(BufSize, 0)
		hIcon := 0

		for eachSize, Size in StrSplit( Sizes, "|" ) {
			DllCall("PrivateExtractIcons", "str", sFile, "Int", IconNumber-1, "Int", Size, "Int", Size, "UPtr*", &hIcon, "UPtr*", 0, "UInt", 1, "UInt", 0)

			if (!hIcon) {
				continue
			}

			if !DllCall("GetIconInfo", "UPtr", hIcon, "UPtr", buf.Ptr) {
				DestroyIcon(hIcon)
				continue
			}

			hbmMask  := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4))
			hbmColor := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4) + (A_PtrSize ? A_PtrSize : 4))
			if !(hbmColor && DllCall("GetObject", "UPtr", hbmColor, "Int", BufSize, "UPtr", buf.Ptr))
			{
				DestroyIcon(hIcon)
				continue
			}
			break
		}

		if (!hIcon) {
			return -1
		}

		Width := NumGet(buf, 4, "Int"), Height := NumGet(buf, 8, "Int")
		hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
		if !DllCall("DrawIconEx", "UPtr", hdc, "Int", 0, "Int", 0, "UPtr", hIcon, "UInt", Width, "UInt", Height, "UInt", 0, "UPtr", 0, "UInt", 3) {
			DestroyIcon(hIcon)
			return -2
		}

		dib := Buffer(104)
		DllCall("GetObject", "UPtr", hbm, "Int", A_PtrSize = 8 ? 104 : 84, "UPtr", dib.Ptr) ; sizeof(DIBSECTION) = 76+2*(A_PtrSize=8?4:0)+2*A_PtrSize
		Stride := NumGet(dib, 12, "Int"), Bits := NumGet(dib, 20 + (A_PtrSize = 8 ? 4 : 0)) ; padding
		DllCall("gdiplus\GdipCreateBitmapFromScan0", "Int", Width, "Int", Height, "Int", Stride, "Int", 0x26200A, "UPtr", Bits, "UPtr*", &pBitmapOld:=0)
		pBitmap := Gdip_CreateBitmap(Width, Height)
		_G := Gdip_GraphicsFromImage(pBitmap)
		, Gdip_DrawImage(_G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
		SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
		Gdip_DeleteGraphics(_G), Gdip_DisposeImage(pBitmapOld)
		DestroyIcon(hIcon)

	} else {
		DllCall("gdiplus\GdipCreateBitmapFromFile", "UPtr", StrPtr(sFile), "UPtr*", &pBitmap:=0)
	}

	return pBitmap
}

Gdip_CreateARGBBitmapFromHBITMAP(&hBitmap) {
	; struct BITMAP - https://docs.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-bitmap
	dib := Buffer(76+2*(A_PtrSize=8?4:0)+2*A_PtrSize)
	DllCall("GetObject"
				,    "ptr", hBitmap
				,    "Int", dib.Size
				,    "ptr", dib.Ptr) ; sizeof(DIBSECTION) = 84, 104
		, width  := NumGet(dib, 4, "UInt")
		, height := NumGet(dib, 8, "UInt")
		, bpp    := NumGet(dib, 18, "ushort")

	; Fallback to built-in method if pixels are not 32-bit ARGB.
	if (bpp != 32) { ; This built-in version is 120% faster but ignores transparency.
		DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hBitmap, "ptr", 0, "ptr*", &pBitmap:=0)
		return pBitmap
	}

	; Create a handle to a device context and associate the image.
	hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")             ; Creates a memory DC compatible with the current screen.
	obm := DllCall("SelectObject", "ptr", hdc, "ptr", hBitmap, "ptr") ; Put the (hBitmap) image onto the device context.

	; Create a device independent bitmap with negative height. All DIBs use the screen pixel format (pARGB).
	; Use hbm to buffer the image such that top-down and bottom-up images are mapped to this top-down buffer.
	cdc := DllCall("CreateCompatibleDC", "ptr", hdc, "ptr")
	bi := Buffer(40, 0)               ; sizeof(bi) = 40
	NumPut(
		"UInt", 	40, 	; Size
		"UInt", 	width,	; Width
		"Int", 		height, ; Height - Negative so (0, 0) is top-left.
		"ushort",	1, 		; Planes
		"ushort",	32, 	; BitCount / BitsPerPixel
		bi)
	hbm := DllCall("CreateDIBSection", "ptr", cdc, "ptr", bi.Ptr, "UInt", 0
				, "ptr*", &pBits:=0  ; pBits is the pointer to (top-down) pixel values.
				, "ptr", 0, "UInt", 0, "ptr")
	ob2 := DllCall("SelectObject", "ptr", cdc, "ptr", hbm, "ptr")

	; This is the 32-bit ARGB pBitmap (different from an hBitmap) that will receive the final converted pixels.
	DllCall("gdiplus\GdipCreateBitmapFromScan0"
				, "Int", width, "Int", height, "Int", 0, "Int", 0x26200A, "ptr", 0, "ptr*", &pBitmap:=0)

	; Create a Scan0 buffer pointing to pBits. The buffer has pixel format pARGB.
	Rect := Buffer(16, 0)              ; sizeof(Rect) = 16
	NumPut(
		"UInt",   width,	; Width
		"UInt",  height,	; Height
		Rect, 8)
	
	BitmapData := Buffer(16+2*A_PtrSize, 0)     ; sizeof(BitmapData) = 24, 32
	NumPut(
		"UInt", width, 		; Width
		"UInt", height, 	; Height
		"Int",  4 * width,	; Stride
		"Int",  0xE200B, 	; PixelFormat
		"ptr",  pBits, 	 	; Scan0
		BitmapData)

	; Use LockBits to create a writable buffer that converts pARGB to ARGB.
	DllCall("gdiplus\GdipBitmapLockBits"
				,    "ptr", pBitmap
				,    "ptr", Rect.Ptr
				,   "UInt", 6            ; ImageLockMode.UserInputBuffer | ImageLockMode.WriteOnly
				,    "Int", 0xE200B      ; Format32bppPArgb
				,    "ptr", BitmapData.Ptr) ; Contains the pointer (pBits) to the hbm.

	; Copies the image (hBitmap) to a top-down bitmap. Removes bottom-up-ness if present.
	DllCall("gdi32\BitBlt"
				, "ptr", cdc, "Int", 0, "Int", 0, "Int", width, "Int", height
				, "ptr", hdc, "Int", 0, "Int", 0, "UInt", 0x00CC0020) ; SRCCOPY

	; Convert the pARGB pixels copied into the device independent bitmap (hbm) to ARGB.
	DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData.Ptr)

	; Cleanup the buffer and device contexts.
	DllCall("SelectObject", "ptr", cdc, "ptr", ob2)
	DllCall("DeleteObject", "ptr", hbm)
	DllCall("DeleteDC",     "ptr", cdc)
	DllCall("SelectObject", "ptr", hdc, "ptr", obm)
	DllCall("DeleteDC",     "ptr", hdc)

	return pBitmap
}

Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette:=0)
{
	DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "UPtr", hBitmap, "UPtr", Palette, "UPtr*", &pBitmap:=0)
	return pBitmap
}

Gdip_CreateHBITMAPFromBitmap(pBitmap, Background:=0xffffffff)
{
	DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "UPtr", pBitmap, "UPtr*", &hbm:=0, "Int", Background)
	return hbm
}

Gdip_CreateARGBHBITMAPFromBitmap(&pBitmap) {
	; This version is about 25% faster than Gdip_CreateHBITMAPFromBitmap().
	; Get Bitmap width and height.
	DllCall("gdiplus\GdipGetImageWidth", "ptr", pBitmap, "uint*", &width:=0)
	DllCall("gdiplus\GdipGetImageHeight", "ptr", pBitmap, "uint*", &height:=0)

	; Convert the source pBitmap into a hBitmap manually.
	; struct BITMAPINFOHEADER - https://docs.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-bitmapinfoheader
	hdc := DllCall("CreateCompatibleDC", "ptr", 0, "ptr")
	bi := Buffer(40, 0)               ; sizeof(bi) = 40
	NumPut(
		"UInt",     40,  		; Size
		"UInt",    	width,  	; Width
		"Int",  	-height,	; Height - Negative so (0, 0) is top-left.
		"ushort",   1, 			; Planes
		"ushort",   32,  		; BitCount / BitsPerPixel
		bi)
	hbm := DllCall("CreateDIBSection", "ptr", hdc, "ptr", bi.Ptr, "UInt", 0, "ptr*", &pBits:=0, "ptr", 0, "UInt", 0, "ptr")
	obm := DllCall("SelectObject", "ptr", hdc, "ptr", hbm, "ptr")

	; Transfer data from source pBitmap to an hBitmap manually.
	Rect := Buffer(16, 0)              ; sizeof(Rect) = 16
	NumPut(
		"UInt",   width,	; Width
		"UInt",  height, 	; Height
		Rect, 8)
	BitmapData := Buffer(16+2*A_PtrSize, 0)     ; sizeof(BitmapData) = 24, 32
	NumPut(
		"UInt",     width, 	; Width
		"UInt",    height, 	; Height
		"Int",  4 * width, 	; Stride
		"Int",    0xE200B, 	; PixelFormat
		"ptr",      pBits, 	; Scan0
		BitmapData)
	DllCall("gdiplus\GdipBitmapLockBits"
				,    "ptr", pBitmap
				,    "ptr", Rect.Ptr
				,   "UInt", 5            ; ImageLockMode.UserInputBuffer | ImageLockMode.ReadOnly
				,    "Int", 0xE200B      ; Format32bppPArgb
				,    "ptr", BitmapData.Ptr) ; Contains the pointer (pBits) to the hbm.
	DllCall("gdiplus\GdipBitmapUnlockBits", "ptr", pBitmap, "ptr", BitmapData.Ptr)

	; Cleanup the hBitmap and device contexts.
	DllCall("SelectObject", "ptr", hdc, "ptr", obm)
	DllCall("DeleteDC",     "ptr", hdc)

	return hbm
}

Gdip_CreateBitmapFromHICON(hIcon)
{
	DllCall("gdiplus\GdipCreateBitmapFromHICON", "UPtr", hIcon, "UPtr*", &pBitmap:=0)
	return pBitmap
}

Gdip_CreateHICONFromBitmap(pBitmap)
{
	DllCall("gdiplus\GdipCreateHICONFromBitmap", "UPtr", pBitmap, "UPtr*", &hIcon:=0)
	return hIcon
}

Gdip_CreateBitmap(Width, Height, Format:=0x26200A)
{
	DllCall("gdiplus\GdipCreateBitmapFromScan0", "Int", Width, "Int", Height, "Int", 0, "Int", Format, "UPtr", 0, "UPtr*", &pBitmap:=0)
	return pBitmap
}

Gdip_CreateBitmapFromClipboard()
{
	if !DllCall("IsClipboardFormatAvailable", "UInt", 8) {
		return -2
	}

	if !DllCall("OpenClipboard", "UPtr", 0) {
		return -1
	}

	hBitmap := DllCall("GetClipboardData", "UInt", 2, "UPtr")

	if !DllCall("CloseClipboard") {
		return -5
	}

	if !hBitmap {
		return -3
	}

	pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
	if (!pBitmap) {
		return -4
	}

	DeleteObject(hBitmap)

	return pBitmap
}


Gdip_SetBitmapToClipboard(pBitmap)
{
	off1 := A_PtrSize = 8 ? 52 : 44, off2 := A_PtrSize = 8 ? 32 : 24
	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	oi := Buffer(A_PtrSize = 8 ? 104 : 84, 0)
	DllCall("GetObject", "UPtr", hBitmap, "Int", oi.Size, "UPtr", oi.Ptr)
	hdib := DllCall("GlobalAlloc", "UInt", 2, "UPtr", 40+NumGet(oi, off1, "UInt"), "UPtr")
	pdib := DllCall("GlobalLock", "UPtr", hdib, "UPtr")
	DllCall("RtlMoveMemory", "UPtr", pdib, "UPtr", oi.Ptr+off2, "UPtr", 40)
	DllCall("RtlMoveMemory", "UPtr", pdib+40, "UPtr", NumGet(oi, off2 - (A_PtrSize ? A_PtrSize : 4), "UPtr"), "UPtr", NumGet(oi, off1, "UInt"))
	DllCall("GlobalUnlock", "UPtr", hdib)
	DllCall("DeleteObject", "UPtr", hBitmap)
	DllCall("OpenClipboard", "UPtr", 0)
	DllCall("EmptyClipboard")
	DllCall("SetClipboardData", "UInt", 8, "UPtr", hdib)
	DllCall("CloseClipboard")
}

Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format:=0x26200A)
{
	DllCall("gdiplus\GdipCloneBitmapArea"
					, "Float", x
					, "Float", y
					, "Float", w
					, "Float", h
					, "Int", Format
					, "UPtr", pBitmap
					, "UPtr*", &pBitmapDest:=0)
	return pBitmapDest
}

Gdip_CloneBitmap(pBitmap) {
; the new pBitmap will have the same PixelFormat, unchanged.

   pBitmapDest := 0
   E := DllCall("gdiplus\GdipCloneImage"
               , "UPtr", pBitmap
               , "UPtr*", pBitmapDest)
   return pBitmapDest
}

Gdip_BitmapSelectActiveFrame(pBitmap, FrameIndex) {
; Selects as the active frame the given FrameIndex
; within an animated GIF or a multi-paged TIFF.
; On succes, it returns the frames count.
; On fail, the return value is -1.

    Countu := 0
    CountFrames := 0
    DllCall("gdiplus\GdipImageGetFrameDimensionsCount", "UPtr", pBitmap, "UInt*", Countu)
    dIDs := Buffer(16, 0)
    DllCall("gdiplus\GdipImageGetFrameDimensionsList", "UPtr", pBitmap, "Uint", dIDs.Ptr, "UInt", Countu)
    DllCall("gdiplus\GdipImageGetFrameCount", "UPtr", pBitmap, "Uint", dIDs.Ptr, "UInt*", CountFrames)
    If (FrameIndex>CountFrames)
       FrameIndex := CountFrames
    Else If (FrameIndex<1)
       FrameIndex := 0

    E := DllCall("gdiplus\GdipImageSelectActiveFrame", "UPtr", pBitmap, "UPtr", dIDs.Ptr, "uint", FrameIndex)
    If E
       Return -1
    Return CountFrames
}

Gdip_GetBitmapFramesCount(pBitmap) {
; The function returns the number of frames or pages a given pBitmap has.
; GDI+ only supports multi-frames/pages for GIFs and TIFFs.
; Function written by SBC in September 2010 and
; extracted from his «Picture Viewer» script.
; https://autohotkey.com/board/topic/58226-ahk-picture-viewer/

    Countu := 0
    CountFrames := 0
    DllCall("gdiplus\GdipImageGetFrameDimensionsCount", "UPtr", pBitmap, "UInt*", Countu)
    dIDs := Buffer(16, 0)
    DllCall("gdiplus\GdipImageGetFrameDimensionsList", "UPtr", pBitmap, "Uint", dIDs.Ptr, "UInt", Countu)
    DllCall("gdiplus\GdipImageGetFrameCount", "UPtr", pBitmap, "Uint", dIDs.Ptr, "UInt*", CountFrames)
    Return CountFrames
}

Gdip_CreateCachedBitmap(pBitmap, pGraphics) {
; Creates a CachedBitmap object based on a Bitmap object and a pGraphics object. The cached bitmap takes
; the pixel data from the Bitmap object and stores it in a format that is optimized for the display device
; associated with the pGraphics object.

   pCachedBitmap := 0
   
   E := DllCall("gdiplus\GdipCreateCachedBitmap", "UPtr", pBitmap, "UPtr", pGraphics, "Ptr*", pCachedBitmap)
   return pCachedBitmap
}

Gdip_DeleteCachedBitmap(pCachedBitmap) {
   
   return DllCall("gdiplus\GdipDeleteCachedBitmap", "UPtr", pCachedBitmap)
}

Gdip_DrawCachedBitmap(pGraphics, pCachedBitmap, X, Y) {
   
   return DllCall("gdiplus\GdipDrawCachedBitmap", "UPtr", pGraphics, "UPtr", pCachedBitmap, "int", X, "int", Y)
}

Gdip_ImageRotateFlip(pBitmap, RotateFlipType:=1) {
; RotateFlipType options:
; RotateNoneFlipNone   = 0
; Rotate90FlipNone     = 1
; Rotate180FlipNone    = 2
; Rotate270FlipNone    = 3
; RotateNoneFlipX      = 4
; Rotate90FlipX        = 5
; Rotate180FlipX       = 6
; Rotate270FlipX       = 7
; RotateNoneFlipY      = Rotate180FlipX
; Rotate90FlipY        = Rotate270FlipX
; Rotate180FlipY       = RotateNoneFlipX
; Rotate270FlipY       = Rotate90FlipX
; RotateNoneFlipXY     = Rotate180FlipNone
; Rotate90FlipXY       = Rotate270FlipNone
; Rotate180FlipXY      = RotateNoneFlipNone
; Rotate270FlipXY      = Rotate90FlipNone

   return DllCall("gdiplus\GdipImageRotateFlip", "UPtr", pBitmap, "int", RotateFlipType)
}

Gdip_RotateBitmapAtCenter(pBitmap, Angle, pBrush:=0, InterpolationMode:=7, PixelFormat:=0) {
; the pBrush will be used to fill the background of the image
; by default, it is black.
; It returns the pointer to a new pBitmap.

    If !Angle
    {
       newBitmap := Gdip_CloneBitmap(pBitmap)
       Return newBitmap
    }

    Gdip_GetImageDimensions(pBitmap, &Width, &Height)
    Gdip_GetRotatedDimensions(Width, Height, Angle, &RWidth, &RHeight)
    Gdip_GetRotatedTranslation(Width, Height, Angle, &xTranslation, &yTranslation)
    If (RWidth*RHeight>536848912) || (Rwidth>32100) || (RHeight>32100)
       Return

    If (pBrush=0)
    {
       pBrush := Gdip_BrushCreateSolid("0xFF000000")
       defaultBrush := 1
    }

    PixelFormatReadable := Gdip_GetImagePixelFormat(pBitmap, 2)
    If InStr(PixelFormatReadable, "indexed")
    {
       hbm := CreateDIBSection(RWidth, RHeight,,24)
       hdc := CreateCompatibleDC()
       obm := SelectObject(hdc, hbm)
       G := Gdip_GraphicsFromHDC(hdc)
       indexedMode := 1
    } Else
    {
       newBitmap := Gdip_CreateBitmap(RWidth, RHeight, PixelFormat)
       G := Gdip_GraphicsFromImage(newBitmap)
    }

    Gdip_SetInterpolationMode(G, InterpolationMode)
    Gdip_SetSmoothingMode(G, 4)
    If StrLen(pBrush)>1
       Gdip_FillRectangle(G, pBrush, 0, 0, RWidth, RHeight)
    Gdip_TranslateWorldTransform(G, xTranslation, yTranslation)
    Gdip_RotateWorldTransform(G, Angle)
    Gdip_DrawImageRect(G, pBitmap, 0, 0, Width, Height)

    If (indexedMode=1)
    {
       newBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
       SelectObject(hdc, obm)
       DeleteObject(hbm)
       DeleteDC(hdc)
    }

    Gdip_DeleteGraphics(G)
    If (defaultBrush=1)
       Gdip_DeleteBrush(pBrush)

    Return newBitmap
}

Gdip_ResizeBitmap(pBitmap, givenW, givenH, KeepRatio, InterpolationMode:="", KeepPixelFormat:=0, checkTooLarge:=0) {
; KeepPixelFormat can receive a specific PixelFormat.
; The function returns a pointer to a new pBitmap.
; Default is 0 = 32-ARGB

    Gdip_GetImageDimensions(pBitmap, &Width, &Height)
    If (KeepRatio=1)
    {
       calcIMGdimensions(Width, Height, givenW, givenH, ResizedW, ResizedH)
    } Else
    {
       ResizedW := givenW
       ResizedH := givenH
    }

    If (((ResizedW*ResizedH>536848912) || (ResizedW>32100) || (ResizedH>32100)) && checkTooLarge=1)
       Return

    PixelFormatReadable := Gdip_GetImagePixelFormat(pBitmap, 2)
    If (KeepPixelFormat=1)
       PixelFormat := Gdip_GetImagePixelFormat(pBitmap, 1)
    If Strlen(KeepPixelFormat)>3
       PixelFormat := KeepPixelFormat

    If InStr(PixelFormatReadable, "indexed")
    {
       hbm := CreateDIBSection(ResizedW, ResizedH,,24)
       hdc := CreateCompatibleDC()
       obm := SelectObject(hdc, hbm)
       G := Gdip_GraphicsFromHDC(hdc)
       Gdip_DrawImageRect(G, pBitmap, 0, 0, ResizedW, ResizedH)
       newBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
       If (KeepPixelFormat=1)
          Gdip_BitmapSetColorDepth(newBitmap, SubStr(PixelFormatReadable, 1, 1), 1)
       SelectObject(hdc, obm)
       DeleteObject(hbm)
       DeleteDC(hdc)
       Gdip_DeleteGraphics(G)
    } Else
    {
       newBitmap := Gdip_CreateBitmap(ResizedW, ResizedH, PixelFormat)
       G := Gdip_GraphicsFromImage(newBitmap)
       Gdip_DrawImageRect(G, pBitmap, 0, 0, ResizedW, ResizedH)
       Gdip_DeleteGraphics(G)
    }

    Return newBitmap
}

;#####################################################################################
; pPen functions
; With Gdip_SetPenBrushFill() or Gdip_CreatePenFromBrush() functions,
; pPen objects can have gradients or textures.
;#####################################################################################

Gdip_CreatePen(ARGB, w)
{
	DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "Float", w, "Int", 2, "UPtr*", &pPen:=0)
	return pPen
}

; Unit  - Unit of measurement for the pen size:
; 0 - World coordinates, a non-physical unit
; 1 - Display units
; 2 - A unit is 1 pixel [default]
; 3 - A unit is 1 point or 1/72 inch
; 4 - A unit is 1 inch
; 5 - A unit is 1/300 inch
; 6 - A unit is 1 millimeter

Gdip_CreatePenFromBrush(pBrush, w)
{
	DllCall("gdiplus\GdipCreatePen2", "UPtr", pBrush, "Float", w, "Int", 2, "UPtr*", &pPen:=0)
	return pPen
}

Gdip_SetPenWidth(pPen, width) {
   return DllCall("gdiplus\GdipSetPenWidth", "UPtr", pPen, "float", width)
}

Gdip_GetPenWidth(pPen) {
   width := 0
   E := DllCall("gdiplus\GdipGetPenWidth", "UPtr", pPen, "float*", width)
   If E
      return -1
   return width
}

Gdip_GetPenDashStyle(pPen) {
   DashStyle := 0
   E := DllCall("gdiplus\GdipGetPenDashStyle", "UPtr", pPen, "float*", DashStyle)
   If E
      return -1
   return DashStyle
}

Gdip_SetPenColor(pPen, ARGB) {
   return DllCall("gdiplus\GdipSetPenColor", "UPtr", pPen, "UInt", ARGB)
}

Gdip_GetPenColor(pPen) {
   ARGB := 0
   E := DllCall("gdiplus\GdipGetPenColor", "UPtr", pPen, "UInt*", ARGB)
   If E
      return -1
   return Format("{1:#x}", ARGB)
}

Gdip_SetPenBrushFill(pPen, pBrush) {
   return DllCall("gdiplus\GdipSetPenBrushFill", "UPtr", pPen, "UPtr", pBrush)
}

Gdip_ResetPenTransform(pPen) {
   
   Return DllCall("gdiplus\GdipResetPenTransform", "UPtr", pPen)
}

Gdip_MultiplyPenTransform(pPen, hMatrix, matrixOrder:=0) {
   
   Return DllCall("gdiplus\GdipMultiplyPenTransform", "UPtr", pPen, "UPtr", hMatrix, "int", matrixOrder)
}

Gdip_RotatePenTransform(pPen, Angle, matrixOrder:=0) {
   
   Return DllCall("gdiplus\GdipRotatePenTransform", "UPtr", pPen, "float", Angle, "int", matrixOrder)
}

Gdip_ScalePenTransform(pPen, ScaleX, ScaleY, matrixOrder:=0) {
   
   Return DllCall("gdiplus\GdipScalePenTransform", "UPtr", pPen, "float", ScaleX, "float", ScaleY, "int", matrixOrder)
}

Gdip_TranslatePenTransform(pPen, X, Y, matrixOrder:=0) {
   
   Return DllCall("gdiplus\GdipTranslatePenTransform", "UPtr", pPen, "float", X, "float", Y, "int", matrixOrder)
}

Gdip_SetPenTransform(pPen, pMatrix) {
   
   return DllCall("gdiplus\GdipSetPenTransform", "UPtr", pPen, "UPtr", pMatrix)
}

Gdip_GetPenTransform(pPen) {
   
   pMatrix := 0
   DllCall("gdiplus\GdipGetPenTransform", "UPtr", pPen, "UPtr*", pMatrix)
   Return pMatrix
}

Gdip_GetPenBrushFill(pPen) {
; Gets the pBrush object that is currently set for the pPen object
   
   pBrush := 0
   E := DllCall("gdiplus\GdipGetPenBrushFill", "UPtr", pPen, "int*", pBrush)
   Return pBrush
}

Gdip_GetPenFillType(pPen) {
; Description: Gets the type of brush fill currently set for a Pen object
; Return values:
; 0  - The pen draws with a solid color
; 1  - The pen draws with a hatch pattern that is specified by a HatchBrush object
; 2  - The pen draws with a texture that is specified by a TextureBrush object
; 3  - The pen draws with a color gradient that is specified by a PathGradientBrush object
; 4  - The pen draws with a color gradient that is specified by a LinearGradientBrush object
; -1 - The pen type is unknown
; -2 - Error

   
   result := 0
   E := DllCall("gdiplus\GdipGetPenFillType", "UPtr", pPen, "int*", result)
   If E
      return -2
   Return result
}

Gdip_GetPenStartCap(pPen) {
   result := 0
   
   E := DllCall("gdiplus\GdipGetPenStartCap", "UPtr", pPen, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetPenEndCap(pPen) {
   result := 0
   
   E := DllCall("gdiplus\GdipGetPenEndCap", "UPtr", pPen, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetPenDashCaps(pPen) {
   result := 0
   
   E := DllCall("gdiplus\GdipGetPenDashCap197819", "UPtr", pPen, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetPenAlignment(pPen) {
   result := 0
   
   E := DllCall("gdiplus\GdipGetPenMode", "UPtr", pPen, "int*", result)
   If E
      return -1
   Return result
}

;#####################################################################################
; Function    - Gdip_SetPenLineCaps
; Description - Sets the cap styles for the start, end, and dashes in a line drawn with the pPen object
; Parameters
; pPen        - Pointer to a Pen object. Start and end caps do not apply to closed lines.
;             - StartCap - Line cap style for the start cap:
;                  0x00 - Line ends at the last point. The end is squared off
;                  0x01 - Square cap. The center of the square is the last point in the line. The height and width of the square are the line width.
;                  0x02 - Circular cap. The center of the circle is the last point in the line. The diameter of the circle is the line width.
;                  0x03 - Triangular cap. The base of the triangle is the last point in the line. The base of the triangle is the line width.
;                  0x10 - Line ends are not anchored.
;                  0x11 - Line ends are anchored with a square. The center of the square is the last point in the line. The height and width of the square are the line width.
;                  0x12 - Line ends are anchored with a circle. The center of the circle is at the last point in the line. The circle is wider than the line.
;                  0x13 - Line ends are anchored with a diamond (a square turned at 45 degrees). The center of the diamond is at the last point in the line. The diamond is wider than the line.
;                  0x14 - Line ends are anchored with arrowheads. The arrowhead point is located at the last point in the line. The arrowhead is wider than the line.
;                  0xff - Line ends are made from a CustomLineCap object.
;               EndCap   - Line cap style for the end cap (same values as StartCap)
;               DashCap  - Start and end caps for a dashed line:
;                  0 - A square cap that squares off both ends of each dash
;                  2 - A circular cap that rounds off both ends of each dash
;                  3 - A triangular cap that points both ends of each dash
; Return value: status enumeration

Gdip_SetPenLineCaps(pPen, StartCap, EndCap, DashCap) {
   
   Return DllCall("gdiplus\GdipSetPenLineCap197819", "UPtr", pPen, "int", StartCap, "int", EndCap, "int", DashCap)
}

Gdip_SetPenStartCap(pPen, LineCap) {
   
   Return DllCall("gdiplus\GdipSetPenStartCap", "UPtr", pPen, "int", LineCap)
}

Gdip_SetPenEndCap(pPen, LineCap) {
   
   Return DllCall("gdiplus\GdipSetPenEndCap", "UPtr", pPen, "int", LineCap)
}

Gdip_SetPenDashCaps(pPen, LineCap) {
; If you set the alignment of a Pen object to
; Pen Alignment Inset, you cannot use that pen
; to draw triangular dash caps.

   
   Return DllCall("gdiplus\GdipSetPenDashCap197819", "UPtr", pPen, "int", LineCap)
}

Gdip_SetPenAlignment(pPen, Alignment) {
; Specifies the alignment setting of the pen relative to the line that is drawn. The default value is Center.
; If you set the alignment of a Pen object to Inset, you cannot use that pen to draw compound lines or triangular dash caps.
; Alignment options:
; 0 [Center] - Specifies that the pen is aligned on the center of the line that is drawn.
; 1 [Inset]  - Specifies, when drawing a polygon, that the pen is aligned on the inside of the edge of the polygon.

   
   Return DllCall("gdiplus\GdipSetPenMode", "UPtr", pPen, "int", Alignment)
}

Gdip_GetPenCompoundCount(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenCompoundCount", "UPtr", pPen, "int*", result)
    If E
       Return -1
    Return result
}

Gdip_SetPenCompoundArray(pPen, inCompounds) {
; Parameters     - pPen        - Pointer to a pPen object
;                  inCompounds - A string of compound values:
;                  "value1|value2|value3" [and so on]
;                  ExampleCompounds := "0.0|0.2|0.7|1.0"
; Remarks        - The elements in the string array must be in increasing order, between 0 and not greater than 1.
;                  Suppose you want a pen to draw two parallel lines where the width of the first line is 20 percent of the pen's
;                  width, the width of the space that separates the two lines is 50 percent of the pen's width, and the width
;                  of the second line is 30 percent of the pen's width. Start by creating a pPen object and an array of compound
;                  values. For this, you can then set the compound array by passing the array with the values "0.0|0.2|0.7|1.0".
; Return status enumeration

   arrCompounds := StrSplit(inCompounds, "|")
   totalCompounds := arrCompounds.Length
   pCompounds := Buffer(8 * totalCompounds, 0)
   Loop (totalCompounds)
      NumPut(arrCompounds[A_Index], pCompounds.ptr, 4*(A_Index - 1), "float")

   Return DllCall("gdiplus\GdipSetPenCompoundArray", "UPtr", pPen, "UPtr", pCompounds.ptr, "int", totalCompounds)
}

Gdip_SetPenDashStyle(pPen, DashStyle) {
; DashStyle options:
; Solid = 0
; Dash = 1
; Dot = 2
; DashDot = 3
; DashDotDot = 4
; Custom = 5
; https://technet.microsoft.com/pt-br/ms534104(v=vs.71).aspx
; function by IPhilip
   Return DllCall("gdiplus\GdipSetPenDashStyle", "UPtr", pPen, "Int", DashStyle)
}

Gdip_SetPenDashArray(pPen, Dashes) {
; Description     Sets custom dashes and spaces for the pPen object.
;
; Parameters      pPen   - Pointer to a Pen object
;                 Dashes - The string that specifies the length of the custom dashes and spaces:
;                 Format: "dL1,sL1,dL2,sL2,dL3,sL3" [... and so on]
;                   dLn - Dash N length
;                   sLn - Space N length
;                 ExampleDashesArgument := "3,6,8,4,2,1"
;
; Remarks         This function sets the dash style for the pPen object to DashStyleCustom (6).
; Return status enumeration.

   Points := StrSplit(Dashes, ",")
   PointsCount := Points.Length
   PointsF := Buffer(8 * PointsCount, 0)
   Loop (PointsCount)
       NumPut(Points[A_Index], PointsF.ptr, 4*(A_Index - 1), "float")

   Return DllCall("gdiplus\GdipSetPenDashArray", "UPtr", pPen, "UPtr", PointsF.ptr, "int", PointsCount)
}

Gdip_SetPenDashOffset(pPen, Offset) {
; Sets the distance from the start of the line to the start of the first space in a dashed line
; Offset - Real number that specifies the number of times to shift the spaces in a dashed line. Each shift is
; equal to the length of a space in the dashed line

    
    Return DllCall("gdiplus\GdipSetPenDashOffset", "UPtr", pPen, "float", Offset)
}

Gdip_GetPenDashArray(pPen) {
   iCount := Gdip_GetPenDashCount(pPen)
   If (iCount=-1)
      Return 0

   PointsF := Buffer(8 * iCount, 0)
   DllCall("gdiplus\GdipGetPenDashArray", "UPtr", pPen, "uPtr", PointsF.ptr, "int", iCount)

   Loop (iCount)
   {
       A := NumGet(PointsF, 4*(A_Index-1), "float")
       printList .= A ","
   }

   Return Trim(printList, ",")
}

Gdip_GetPenCompoundArray(pPen) {
   iCount := Gdip_GetPenCompoundCount(pPen)
   PointsF := Buffer(4 * iCount, 0)
   DllCall("gdiplus\GdipGetPenCompoundArray", "UPtr", pPen, "uPtr", PointsF.ptr, "int", iCount)

   Loop (iCount)
   {
       A := NumGet(PointsF, 4*(A_Index-1), "float")
       printList .= A "|"
   }

   Return Trim(printList, "|")
}

Gdip_SetPenLineJoin(pPen, LineJoin) {
; LineJoin - Line join style:
; MITER = 0 - it produces a sharp corner or a clipped corner, depending on whether the length of the miter exceeds the miter limit.
; BEVEL = 1 - it produces a diagonal corner.
; ROUND = 2 - it produces a smooth, circular arc between the lines.
; MITERCLIPPED = 3 - it produces a sharp corner or a beveled corner, depending on whether the length of the miter exceeds the miter limit.

    Return DllCall("gdiplus\GdipSetPenLineJoin", "UPtr", pPen, "int", LineJoin)
}

Gdip_SetPenMiterLimit(pPen, MiterLimit) {
; MiterLimit - Real number that specifies the miter limit of the Pen object. A real number value that is less
; than 1.0 will be replaced with 1.0,
;
; Remarks
; The miter length is the distance from the intersection of the line walls on the inside of the join to the
; intersection of the line walls outside of the join. The miter length can be large when the angle between two
; lines is small. The miter limit is the maximum allowed ratio of miter length to stroke width. The default
; value is 10.0.
; If the miter length of the join of the intersection exceeds the limit of the join, then the join will be
; beveled to keep it within the limit of the join of the intersection

    Return DllCall("gdiplus\GdipSetPenMiterLimit", "UPtr", pPen, "float", MiterLimit)
}

; Sets the unit of measurement for a pPen object.
; Unit - New unit of measurement for the pen:
; 0 - World coordinates, a non-physical unit
; 1 - Display units
; 2 - A unit is 1 pixel
; 3 - A unit is 1 point or 1/72 inch
; 4 - A unit is 1 inch
; 5 - A unit is 1/300 inch
; 6 - A unit is 1 millimeter
Gdip_SetPenUnit(pPen, Unit) {
    Return DllCall("gdiplus\GdipSetPenUnit", "UPtr", pPen, "int", Unit)
}

Gdip_GetPenDashCount(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenDashCount", "UPtr", pPen, "int*", result)
    If E
       Return -1
    Return result
}

Gdip_GetPenDashOffset(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenDashOffset", "UPtr", pPen, "float*", result)
    If E
       Return -1
    Return result
}

Gdip_GetPenLineJoin(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenLineJoin", "UPtr", pPen, "int*", result)
    If E
       Return -1
    Return result
}

Gdip_GetPenMiterLimit(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenMiterLimit", "UPtr", pPen, "float*", result)
    If E
       Return -1
    Return result
}

Gdip_GetPenUnit(pPen) {
    result := 0
    E := DllCall("gdiplus\GdipGetPenUnit", "UPtr", pPen, "int*", result)
    If E
       Return -1
    Return result
}

Gdip_ClonePen(pPen) {
   newPen := 0
   E := DllCall("gdiplus\GdipClonePen", "UPtr", pPen, "UPtr*", newPen)
   Return newPen
}

;#####################################################################################
; pBrush functions [types: SolidFill, Texture, Hatch patterns, PathGradient and LinearGradient]
; pBrush objects can be used by pPen objects via Gdip_SetPenBrushFill()
;#####################################################################################

Gdip_BrushCreateSolid(ARGB:=0xff000000)
{
	DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, "UPtr*", &pBrush:=0)
	return pBrush
}

Gdip_SetSolidFillColor(pBrush, ARGB) {
   return DllCall("gdiplus\GdipSetSolidFillColor", "UPtr", pBrush, "UInt", ARGB)
}

Gdip_GetSolidFillColor(pBrush) {
   ARGB := 0
   E := DllCall("gdiplus\GdipGetSolidFillColor", "UPtr", pBrush, "UInt*", ARGB)
   If E
      return -1
   return Format("{1:#x}", ARGB)
}

;#####################################################################################

; HatchStyleHorizontal = 0
; HatchStyleVertical = 1
; HatchStyleForwardDiagonal = 2
; HatchStyleBackwardDiagonal = 3
; HatchStyleCross = 4
; HatchStyleDiagonalCross = 5
; HatchStyle05Percent = 6
; HatchStyle10Percent = 7
; HatchStyle20Percent = 8
; HatchStyle25Percent = 9
; HatchStyle30Percent = 10
; HatchStyle40Percent = 11
; HatchStyle50Percent = 12
; HatchStyle60Percent = 13
; HatchStyle70Percent = 14
; HatchStyle75Percent = 15
; HatchStyle80Percent = 16
; HatchStyle90Percent = 17
; HatchStyleLightDownwardDiagonal = 18
; HatchStyleLightUpwardDiagonal = 19
; HatchStyleDarkDownwardDiagonal = 20
; HatchStyleDarkUpwardDiagonal = 21
; HatchStyleWideDownwardDiagonal = 22
; HatchStyleWideUpwardDiagonal = 23
; HatchStyleLightVertical = 24
; HatchStyleLightHorizontal = 25
; HatchStyleNarrowVertical = 26
; HatchStyleNarrowHorizontal = 27
; HatchStyleDarkVertical = 28
; HatchStyleDarkHorizontal = 29
; HatchStyleDashedDownwardDiagonal = 30
; HatchStyleDashedUpwardDiagonal = 31
; HatchStyleDashedHorizontal = 32
; HatchStyleDashedVertical = 33
; HatchStyleSmallConfetti = 34
; HatchStyleLargeConfetti = 35
; HatchStyleZigZag = 36
; HatchStyleWave = 37
; HatchStyleDiagonalBrick = 38
; HatchStyleHorizontalBrick = 39
; HatchStyleWeave = 40
; HatchStylePlaid = 41
; HatchStyleDivot = 42
; HatchStyleDottedGrid = 43
; HatchStyleDottedDiamond = 44
; HatchStyleShingle = 45
; HatchStyleTrellis = 46
; HatchStyleSphere = 47
; HatchStyleSmallGrid = 48
; HatchStyleSmallCheckerBoard = 49
; HatchStyleLargeCheckerBoard = 50
; HatchStyleOutlinedDiamond = 51
; HatchStyleSolidDiamond = 52
; HatchStyleTotal = 53
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle:=0)
{
	DllCall("gdiplus\GdipCreateHatchBrush", "Int", HatchStyle, "UInt", ARGBfront, "UInt", ARGBback, "UPtr*", &pBrush:=0)
	return pBrush
}

Gdip_GetHatchBackgroundColor(pHatchBrush) {
   ARGB := 0
   
   E := DllCall("gdiplus\GdipGetHatchBackgroundColor", "UPtr", pHatchBrush, "uint*", ARGB)
   If E 
      Return -1
   return Format("{1:#x}", ARGB)
}

Gdip_GetHatchForegroundColor(pHatchBrush) {
   ARGB := 0
   
   E := DllCall("gdiplus\GdipGetHatchForegroundColor", "UPtr", pHatchBrush, "uint*", ARGB)
   If E 
      Return -1
   return Format("{1:#x}", ARGB)
}

Gdip_GetHatchStyle(pHatchBrush) {
   result := 0
   
   E := DllCall("gdiplus\GdipGetHatchStyle", "UPtr", pHatchBrush, "int*", result)
   If E 
      Return -1
   Return result
}

;#####################################################################################

; Function:             Gdip_CreateTextureBrush
; Description:          Creates a TextureBrush object based on an image, a wrap mode and a defining rectangle.
;
; pBitmap               Pointer to an Image object
; WrapMode              Wrap mode that specifies how repeated copies of an image are used to tile an area when it is
;                       painted with the texture brush:
;                       0 - Tile - Tiling without flipping
;                       1 - TileFlipX - Tiles are flipped horizontally as you move from one tile to the next in a row
;                       2 - TileFlipY - Tiles are flipped vertically as you move from one tile to the next in a column
;                       3 - TileFlipXY - Tiles are flipped horizontally as you move along a row and flipped vertically as you move along a column
;                       4 - Clamp - No tiling takes place
; x, y                  x, y coordinates of the image portion to be used by this brush
; w, h                  Width and height of the image portion
; matrix                A color matrix to alter the colors of the given pBitmap
; ScaleX, ScaleY        x, y scaling factor for the texture
; Angle                 Rotates the texture at given angle
;
; return                If the function succeeds, the return value is nonzero
; notes                 If w and h are omitted, the entire pBitmap is used
;                       Matrix can be omitted to just draw with no alteration to the ARGB channels
;                       Matrix may be passed as a digit from 0.0 - 1.0 to change just transparency
;                       Matrix can be passed as a matrix with "|" as delimiter. 
; Function modified by Marius Șucan, to allow use of color matrix and ImageAttributes object.

Gdip_CreateTextureBrush(pBitmap, WrapMode:=1, x:=0, y:=0, w:="", h:="")
{
	if !(w && h) {
		DllCall("gdiplus\GdipCreateTexture", "UPtr", pBitmap, "Int", WrapMode, "UPtr*", &pBrush:=0)
	} else {
		DllCall("gdiplus\GdipCreateTexture2", "UPtr", pBitmap, "Int", WrapMode, "Float", x, "Float", y, "Float", w, "Float", h, "UPtr*", &pBrush:=0)
	}

	return pBrush
}

Gdip_RotateTextureTransform(pTexBrush, Angle, MatrixOrder:=0) {
; MatrixOrder options:
; Prepend = 0; The new operation is applied before the old operation.
; Append = 1; The new operation is applied after the old operation.
; Order of matrices multiplication:.

   
   return DllCall("gdiplus\GdipRotateTextureTransform", "UPtr", pTexBrush, "float", Angle, "int", MatrixOrder)
}

Gdip_ScaleTextureTransform(pTexBrush, ScaleX, ScaleY, MatrixOrder:=0) {
   
   return DllCall("gdiplus\GdipScaleTextureTransform", "UPtr", pTexBrush, "float", ScaleX, "float", ScaleY, "int", MatrixOrder)
}

Gdip_TranslateTextureTransform(pTexBrush, X, Y, MatrixOrder:=0) {
   
   return DllCall("gdiplus\GdipTranslateTextureTransform", "UPtr", pTexBrush, "float", X, "float", Y, "int", MatrixOrder)
}

Gdip_MultiplyTextureTransform(pTexBrush, hMatrix, matrixOrder:=0) {
   
   Return DllCall("gdiplus\GdipMultiplyTextureTransform", "UPtr", pTexBrush, "UPtr", hMatrix, "int", matrixOrder)
}

Gdip_SetTextureTransform(pTexBrush, hMatrix) {
   
   return DllCall("gdiplus\GdipSetTextureTransform", "UPtr", pTexBrush, "UPtr", hMatrix)
}

Gdip_GetTextureTransform(pTexBrush) {
   hMatrix := 0
   
   DllCall("gdiplus\GdipGetTextureTransform", "UPtr", pTexBrush, "UPtr*", hMatrix)
   Return hMatrix
}

Gdip_ResetTextureTransform(pTexBrush) {
   
   return DllCall("gdiplus\GdipResetTextureTransform", "UPtr", pTexBrush)
}

Gdip_SetTextureWrapMode(pTexBrush, WrapMode) {
; WrapMode options:
; 0 - Tile - Tiling without flipping
; 1 - TileFlipX - Tiles are flipped horizontally as you move from one tile to the next in a row
; 2 - TileFlipY - Tiles are flipped vertically as you move from one tile to the next in a column
; 3 - TileFlipXY - Tiles are flipped horizontally as you move along a row and flipped vertically as you move along a column
; 4 - Clamp - No tiling takes place

   
   return DllCall("gdiplus\GdipSetTextureWrapMode", "UPtr", pTexBrush, "int", WrapMode)
}

Gdip_GetTextureWrapMode(pTexBrush) {
   result := 0
   
   E := DllCall("gdiplus\GdipGetTextureWrapMode", "UPtr", pTexBrush, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetTextureImage(pTexBrush) {
   
   pBitmapDest := 0
   E := DllCall("gdiplus\GdipGetTextureImage", "UPtr", pTexBrush
               , "UPtr*", pBitmapDest)
   Return pBitmapDest
}

;#####################################################################################
; LinearGradientBrush functions
;#####################################################################################

;#####################################################################################

; WrapModeTile = 0
; WrapModeTileFlipX = 1
; WrapModeTileFlipY = 2
; WrapModeTileFlipXY = 3
; WrapModeClamp = 4
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode:=1)
{
	CreatePointF(&PointF1:="", x1, y1), CreatePointF(&PointF2:="", x2, y2)
	DllCall("gdiplus\GdipCreateLineBrush", "UPtr", PointF1.Ptr, "UPtr", PointF2.Ptr, "UInt", ARGB1, "UInt", ARGB2, "Int", WrapMode, "UPtr*", &LGpBrush:=0)
	return LGpBrush
}

Gdip_CreateLinearGrBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode:=1) {
; Linear gradient brush.
; WrapMode specifies how the pattern is repeated once it exceeds the defined space
; Tile [no flipping] = 0
; TileFlipX = 1
; TileFlipY = 2
; TileFlipXY = 3
; Clamp [no tiling] = 4
   
   CreatePointF(PointF1, x1, y1)
   CreatePointF(PointF2, x2, y2)
   pLinearGradientBrush := 0
   DllCall("gdiplus\GdipCreateLineBrush", "UPtr", &PointF1, "UPtr", &PointF2, "Uint", ARGB1, "Uint", ARGB2, "int", WrapMode, "UPtr*", pLinearGradientBrush)
   return pLinearGradientBrush
}

Gdip_SetLinearGrBrushColors(pLinearGradientBrush, ARGB1, ARGB2) {
   
   return DllCall("gdiplus\GdipSetLineColors", "UPtr", pLinearGradientBrush, "UInt", ARGB1, "UInt", ARGB2)
}

Gdip_GetLinearGrBrushColors(pLinearGradientBrush, &ARGB1, &ARGB2) {
   colors := Buffer(8, 0)
   E := DllCall("gdiplus\GdipGetLineColors", "UPtr", pLinearGradientBrush, "Ptr", colors.ptr)
   ARGB1 := NumGet(colors, 0, "UInt")
   ARGB2 := NumGet(colors, 4, "UInt")
   ARGB1 := Format("{1:#x}", ARGB1)
   ARGB2 := Format("{1:#x}", ARGB2)
   return E
}

;#####################################################################################

; LinearGradientModeHorizontal = 0
; LinearGradientModeVertical = 1
; LinearGradientModeForwardDiagonal = 2
; LinearGradientModeBackwardDiagonal = 3
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode:=1, WrapMode:=1)
{
	CreateRectF(&RectF:="", x, y, w, h)
	DllCall("gdiplus\GdipCreateLineBrushFromRect", "UPtr", RectF.Ptr, "Int", ARGB1, "Int", ARGB2, "Int", LinearGradientMode, "Int", WrapMode, "UPtr*", &LGpBrush:=0)
	return LGpBrush
}

Gdip_CreateLinearGrBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode:=1, WrapMode:=1) {
; WrapMode options [LinearGradientMode]:
; Horizontal = 0
; Vertical = 1
; ForwardDiagonal = 2
; BackwardDiagonal = 3
   CreateRectF(&RectF, x, y, w, h)
   E := DllCall("gdiplus\GdipCreateLineBrushFromRect", "UPtr", RectF.ptr, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, "UPtr*", &LGpBrush:=0)
   return LGpBrush
}

Gdip_GetLinearGrBrushGammaCorrection(pLinearGradientBrush) {
   E := DllCall("gdiplus\GdipGetLineGammaCorrection", "UPtr", pLinearGradientBrush, "int*", &result:=0)
   If E 
      Return -1
   Return result
}

Gdip_SetLinearGrBrushGammaCorrection(pLinearGradientBrush, UseGammaCorrection) {
   Return DllCall("gdiplus\GdipSetLineGammaCorrection", "UPtr", pLinearGradientBrush, "int", UseGammaCorrection)
}

Gdip_GetLinearGrBrushRect(pLinearGradientBrush) {
  rData := {}
  RectF := Buffer(16, 0)
  status := DllCall("gdiplus\GdipGetLineRect", "UPtr", pLinearGradientBrush, "UPtr", RectF.ptr)

  If (!status) {
        rData.x := NumGet(RectF, 0, "float")
      , rData.y := NumGet(RectF, 4, "float")
      , rData.w := NumGet(RectF, 8, "float")
      , rData.h := NumGet(RectF, 12, "float")
  } Else {
    Return status
  }

  return rData
}

Gdip_ResetLinearGrBrushTransform(pLinearGradientBrush) {
   return DllCall("gdiplus\GdipResetLineTransform", "UPtr", pLinearGradientBrush)
}

Gdip_ScaleLinearGrBrushTransform(pLinearGradientBrush, ScaleX, ScaleY, matrixOrder:=0) {
   return DllCall("gdiplus\GdipScaleLineTransform", "UPtr", pLinearGradientBrush, "float", ScaleX, "float", ScaleY, "int", matrixOrder)
}

Gdip_MultiplyLinearGrBrushTransform(pLinearGradientBrush, hMatrix, matrixOrder:=0) {
   Return DllCall("gdiplus\GdipMultiplyLineTransform", "UPtr", pLinearGradientBrush, "UPtr", hMatrix, "int", matrixOrder)
}

Gdip_TranslateLinearGrBrushTransform(pLinearGradientBrush, X, Y, matrixOrder:=0) {
   return DllCall("gdiplus\GdipTranslateLineTransform", "UPtr", pLinearGradientBrush, "float", X, "float", Y, "int", matrixOrder)
}

Gdip_RotateLinearGrBrushTransform(pLinearGradientBrush, Angle, matrixOrder:=0) {
   return DllCall("gdiplus\GdipRotateLineTransform", "UPtr", pLinearGradientBrush, "float", Angle, "int", matrixOrder)
}

Gdip_SetLinearGrBrushTransform(pLinearGradientBrush, pMatrix) {
   return DllCall("gdiplus\GdipSetLineTransform", "UPtr", pLinearGradientBrush, "UPtr", pMatrix)
}

Gdip_GetLinearGrBrushTransform(pLineGradientBrush) {
   DllCall("gdiplus\GdipGetLineTransform", "UPtr", pLineGradientBrush, "UPtr*", &pMatrix:=0)
   Return pMatrix
}

Gdip_RotateLinearGrBrushAtCenter(pLinearGradientBrush, Angle, MatrixOrder:=1) {
; function by Marius Șucan
; based on Gdip_RotatePathAtCenter() by RazorHalo

  Rect := Gdip_GetLinearGrBrushRect(pLinearGradientBrush) ; boundaries
  cX := Rect.x + (Rect.w / 2)
  cY := Rect.y + (Rect.h / 2)
  pMatrix := Gdip_CreateMatrix()
  Gdip_TranslateMatrix(pMatrix, -cX , -cY)
  Gdip_RotateMatrix(pMatrix, Angle, MatrixOrder)
  Gdip_TranslateMatrix(pMatrix, cX, cY, MatrixOrder)
  E := Gdip_SetLinearGrBrushTransform(pLinearGradientBrush, pMatrix)
  Gdip_DeleteMatrix(pMatrix)
  Return E
}

Gdip_GetLinearGrBrushWrapMode(pLinearGradientBrush) {
   result := 0
   E := DllCall("gdiplus\GdipGetLineWrapMode", "UPtr", pLinearGradientBrush, "int*", result)
   If E
      return -1
   Return result
}

Gdip_SetLinearGrBrushLinearBlend(pLinearGradientBrush, nFocus, nScale) {
; https://purebasic.developpez.com/tutoriels/gdi/documentation/GdiPlus/LinearGradientBrush/html/GdipSetLineLinearBlend.html

   
   Return DllCall("gdiplus\GdipSetLineLinearBlend", "UPtr", pLinearGradientBrush, "float", nFocus, "float", nScale)
}

Gdip_SetLinearGrBrushSigmaBlend(pLinearGradientBrush, nFocus, nScale) {
; https://purebasic.developpez.com/tutoriels/gdi/documentation/GdiPlus/LinearGradientBrush/html/GdipSetLineSigmaBlend.html
   
   Return DllCall("gdiplus\GdipSetLineSigmaBlend", "UPtr", pLinearGradientBrush, "float", nFocus, "float", nScale)
}

Gdip_SetLinearGrBrushWrapMode(pLinearGradientBrush, WrapMode) {
   
   Return DllCall("gdiplus\GdipSetLineWrapMode", "UPtr", pLinearGradientBrush, "int", WrapMode)
}

Gdip_GetLinearGrBrushBlendCount(pLinearGradientBrush) {
   E := DllCall("gdiplus\GdipGetLineBlendCount", "UPtr", pLinearGradientBrush, "int*", &result:=0)
   If E
      return -1
   Return result
}

Gdip_SetLinearGrBrushPresetBlend(pBrush, pA, pB, pC, pD, clr1, clr2, clr3, clr4) {
   
   CreateRectF(POSITIONS, pA, pB, pC, pD)
   CreateRect(COLORS, clr1, clr2, clr3, clr4)
   E:= DllCall("gdiplus\GdipSetLinePresetBlend", "UPtr", pBrush, "Ptr", &COLORS, "Ptr", &POSITIONS, "Int", 4)
   Return E
}

Gdip_CloneBrush(pBrush)
{
	DllCall("gdiplus\GdipCloneBrush", "UPtr", pBrush, "UPtr*", &pBrushClone:=0)
	return pBrushClone
}

Gdip_GetBrushType(pBrush) {
; Possible brush types [return values]:
; 0 - Solid color
; 1 - Hatch pattern fill
; 2 - Texture fill
; 3 - Path gradient
; 4 - Linear gradient
; -1 - error

   E := DllCall("gdiplus\GdipGetBrushType", "UPtr", pBrush, "int*", &result:=0)
   If E
      return -1
   Return result
}

;#####################################################################################
; Delete resources
;#####################################################################################

Gdip_DeleteRegion(Region) {
   return DllCall("gdiplus\GdipDeleteRegion", "UPtr", Region)
}

Gdip_DeletePen(pPen) {
   return DllCall("gdiplus\GdipDeletePen", "UPtr", pPen)
}

Gdip_DeleteBrush(pBrush) {
   return DllCall("gdiplus\GdipDeleteBrush", "UPtr", pBrush)
}

Gdip_DisposeImage(pBitmap)
{
	return DllCall("gdiplus\GdipDisposeImage", "UPtr", pBitmap)
}

Gdip_DeleteGraphics(pGraphics) {
   return DllCall("gdiplus\GdipDeleteGraphics", "UPtr", pGraphics)
}

Gdip_DisposeImageAttributes(ImageAttr) {
   return DllCall("gdiplus\GdipDisposeImageAttributes", "UPtr", ImageAttr)
}

Gdip_DeleteFont(hFont) {
   return DllCall("gdiplus\GdipDeleteFont", "UPtr", hFont)
}

Gdip_DeleteStringFormat(hStringFormat) {
   return DllCall("gdiplus\GdipDeleteStringFormat", "UPtr", hStringFormat)
}

Gdip_DeleteFontFamily(hFontFamily) {
   return DllCall("gdiplus\GdipDeleteFontFamily", "UPtr", hFontFamily)
}

Gdip_DeletePrivateFontCollection(hFontCollection) {
   Return DllCall("gdiplus\GdipDeletePrivateFontCollection", "ptr*", hFontCollection)
}

Gdip_DeleteMatrix(hMatrix) {
   return DllCall("gdiplus\GdipDeleteMatrix", "UPtr", hMatrix)
}

;#####################################################################################
; Text functions
; Easy to use functions:
; Gdip_DrawOrientedString() - allows to draw strings or string contours/outlines, 
; or both, rotated at any angle. On success, its boundaries are returned.
; Gdip_DrawStringAlongPolygon() - allows you to draw a string along a pPath
; or multiple given coordinates.
; Gdip_TextToGraphics() - allows you to draw strings or measure their boundaries.
;#####################################################################################

Gdip_DrawOrientedString(pGraphics, String, FontName, Size, Style, X, Y, Width, Height, Angle:=0, pBrush:=0, pPen:=0, Align:=0, ScaleX:=1) {
; FontName can be a name of an already installed font or it can point to a font file
; to be loaded and used to draw the string.

; Size   - in em, in world units [font size]
; Remarks: a high value might be required; over 60, 90... to see the text.
; X, Y   - coordinates for the rectangle where the text will be drawn
; W, H   - width and heigh for the rectangle where the text will be drawn
; Angle  - the angle at which the text should be rotated

; pBrush - a pointer to a pBrush object to fill the text with
; pPen   - a pointer to a pPen object to draw the outline [contour] of the text
; Remarks: both are optional, but one at least must be given, otherwise
; the function fails, returns -3.
; For example, if you want only the contour of the text, pass only a pPen object.

; Align options:
; Near/left = 0
; Center = 1
; Far/right = 2

; Style options:
; Regular = 0
; Bold = 1
; Italic = 2
; BoldItalic = 3
; Underline = 4
; Strikeout = 8

; ScaleX - if you want to distort the text [make it wider or narrower]

; On success, the function returns an array:
; PathBounds.x , PathBounds.y , PathBounds.w , PathBounds.h

   If (!pBrush && !pPen)
      Return -3

   If RegExMatch(FontName, "^(.\:\\.)")
   {
      hFontCollection := Gdip_NewPrivateFontCollection()
      hFontFamily := Gdip_CreateFontFamilyFromFile(FontName, hFontCollection)
   } Else hFontFamily := Gdip_FontFamilyCreate(FontName)

   If !hFontFamily
      hFontFamily := Gdip_FontFamilyCreateGeneric(1)
 
   If !hFontFamily
   {
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Return -1
   }

   FormatStyle := 0x4000
   hStringFormat := Gdip_StringFormatCreate(FormatStyle)
   If !hStringFormat
      hStringFormat := Gdip_StringFormatGetGeneric(1)

   If !hStringFormat
   {
      Gdip_DeleteFontFamily(hFontFamily)
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Return -2
   }

   Gdip_SetStringFormatTrimming(hStringFormat, 3)
   Gdip_SetStringFormatAlign(hStringFormat, Align)
   pPath := Gdip_CreatePath()

   E := Gdip_AddPathString(pPath, String, hFontFamily, Style, Size, hStringFormat, X, Y, Width, Height)
   If (ScaleX>0 && ScaleX!=1)
   {
      hMatrix := Gdip_CreateMatrix()
      Gdip_ScaleMatrix(hMatrix, ScaleX, 1)
      Gdip_TransformPath(pPath, hMatrix)
      Gdip_DeleteMatrix(hMatrix)
   }
   Gdip_RotatePathAtCenter(pPath, Angle)

   If (!E && pBrush)
      E := Gdip_FillPath(pGraphics, pBrush, pPath)
   If (!E && pPen)
      E := Gdip_DrawPath(pGraphics, pPen, pPath)
   PathBounds := Gdip_GetPathWorldBounds(pPath)
   Gdip_DeleteStringFormat(hStringFormat)
   Gdip_DeleteFontFamily(hFontFamily)
   Gdip_DeletePath(pPath)
   If hFontCollection
      Gdip_DeletePrivateFontCollection(hFontCollection)
   Return E ? E : PathBounds
}

Gdip_TextToGraphics(pGraphics, Text, Options, Font:="Arial", Width:="", Height:="", Measure:=0)
{
	IWidth := Width
	IHeight := Height
	PassBrush := 0

	pattern_opts := "i)"
	RegExMatch(Options, pattern_opts "X([\-\d\.]+)(p*)", &xpos:="")
	RegExMatch(Options, pattern_opts "Y([\-\d\.]+)(p*)", &ypos:="")
	RegExMatch(Options, pattern_opts "W([\-\d\.]+)(p*)", &Width:="")
	RegExMatch(Options, pattern_opts "H([\-\d\.]+)(p*)", &Height:="")
	RegExMatch(Options, pattern_opts "C(?!(entre|enter))([a-f\d]+)", &Colour:="")
	RegExMatch(Options, pattern_opts "Top|Up|Bottom|Down|vCentre|vCenter", &vPos:="")
	RegExMatch(Options, pattern_opts "NoWrap", &NoWrap:="")
	RegExMatch(Options, pattern_opts "R(\d)", &Rendering:="")
	RegExMatch(Options, pattern_opts "S(\d+)(p*)", &Size:="")

	if Colour && IsInteger(Colour[2]) && !Gdip_DeleteBrush(Gdip_CloneBrush(Colour[2])) {
		PassBrush := 1, pBrush := Colour[2]
	}

	if !(IWidth && IHeight) && ((xpos && xpos[2]) || (ypos && ypos[2]) || (Width && Width[2]) || (Height && Height[2]) || (Size && Size[2])) {
		return -1
	}

	Style := 0
	Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
	for eachStyle, valStyle in StrSplit( Styles, "|" ) {
		if RegExMatch(Options, "\b" valStyle)
			Style |= (valStyle != "StrikeOut") ? (A_Index-1) : 8
	}

	Align := 0
	Alignments := "Near|Left|Centre|Center|Far|Right"
	for eachAlignment, valAlignment in StrSplit( Alignments, "|" ) {
		if RegExMatch(Options, "\b" valAlignment) {
			Align |= A_Index*10//21	; 0|0|1|1|2|2
		}
	}

	xpos := (xpos && (xpos[1] != "")) ? xpos[2] ? IWidth*(xpos[1]/100) : xpos[1] : 0
	ypos := (ypos && (ypos[1] != "")) ? ypos[2] ? IHeight*(ypos[1]/100) : ypos[1] : 0
	Width := (Width && Width[1]) ? Width[2] ? IWidth*(Width[1]/100) : Width[1] : IWidth
	Height := (Height && Height[1]) ? Height[2] ? IHeight*(Height[1]/100) : Height[1] : IHeight

	if !PassBrush {
		Colour := "0x" (Colour && Colour[2] ? Colour[2] : "ff000000")
	}

	Rendering := (Rendering && (Rendering[1] >= 0) && (Rendering[1] <= 5)) ? Rendering[1] : 4
	Size := (Size && (Size[1] > 0)) ? Size[2] ? IHeight*(Size[1]/100) : Size[1] : 12

	hFamily := Gdip_FontFamilyCreate(Font)
	hFont := Gdip_FontCreate(hFamily, Size, Style)
	FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
	hFormat := Gdip_StringFormatCreate(FormatStyle)
	pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour)

	if !(hFamily && hFont && hFormat && pBrush && pGraphics) {
		return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
	}

	CreateRectF(&RC:="", xpos, ypos, Width, Height)
	Gdip_SetStringFormatAlign(hFormat, Align)
	Gdip_SetTextRenderingHint(pGraphics, Rendering)
	ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, &RC)

	if vPos {
		ReturnRC := StrSplit(ReturnRC, "|")

		if (vPos[0] = "vCentre") || (vPos[0] = "vCenter")
			ypos += Floor((Height-ReturnRC[4])/2)
		else if (vPos[0] = "Top") || (vPos[0] = "Up")
			ypos := 0
		else if (vPos[0] = "Bottom") || (vPos[0] = "Down")
			ypos := Height-ReturnRC[4]

		CreateRectF(&RC, xpos, ypos, Width, ReturnRC[4])
		ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, &RC)
	}

	if !Measure {
		ReturnRC := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, &RC)
	}

	if !PassBrush {
		Gdip_DeleteBrush(pBrush)
	}

	Gdip_DeleteStringFormat(hFormat)
	Gdip_DeleteFont(hFont)
	Gdip_DeleteFontFamily(hFamily)

	return ReturnRC
}

Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, &RectF)
{
	return DllCall("gdiplus\GdipDrawString"
					, "UPtr", pGraphics
					, "UPtr", StrPtr(sString)
					, "Int", -1
					, "UPtr", hFont
					, "UPtr", RectF.Ptr
					, "UPtr", hFormat
					, "UPtr", pBrush)
}

Gdip_MeasureString(pGraphics, sString, hFont, hFormat, &RectF)
{
	RC := Buffer(16)
	DllCall("gdiplus\GdipMeasureString"
					, "UPtr", pGraphics
					, "UPtr", StrPtr(sString)
					, "Int", -1
					, "UPtr", hFont
					, "UPtr", RectF.Ptr
					, "UPtr", hFormat
					, "UPtr", RC.Ptr
					, "uint*", &Chars:=0
					, "uint*", &Lines:=0)

	return RC.Ptr ? NumGet(RC, 0, "Float") "|" NumGet(RC, 4, "Float") "|" NumGet(RC, 8, "Float") "|" NumGet(RC, 12, "Float") "|" Chars "|" Lines : 0
}

Gdip_DrawStringAlongPolygon(pGraphics, String, FontName, FontSize, Style, pBrush, DriverPoints:=0, pPath:=0, minDist:=0, flatness:=4, hMatrix:=0, Unit:=0) {
; The function allows you to draw a text string along a polygonal line.
; Each point on the line corresponds to a letter.
; If they are too close, the letters will overlap. If they are fewer than
; the string length, the text is going to be truncated.
; If given, a pPath object will be segmented according to the precision defined by «flatness».
;
; pGraphics    - a pointer to a pGraphics object where to draw the text
; FontName       can be the name of an already installed font or it can point to a font file
;                to be loaded and used to draw the string.
; FontSize     - in em, in world units
;                a high value might be required; over 60, 90... to see the text.
; pBrush       - a pointer to a pBrush object to fill the text with
; DriverPoints - a string with X, Y coordinates where the letters
;                of the string will be drawn. Each X/Y pair corresponds to a letter.
;                "x1,y1|x2,y2|x3,y3" [...and so on]
; pPath        - A pointer to a pPath object.
;                It will be used only if DriverPoints parameter is omitted.
; If both DriverPoints and pPath are omitted, the function will return -4.
; Intermmediate points will be generated if there are more glyphs / letters than defined points.
;
; flatness - from 0.1 to 5; the precision for arcs, beziers and curves segmentation;
;            the lower the number is, the higher density of points is;
;            it applies only for given pPath objects
;
; minDist  - the minimum distance between letters; by default it is FontSize/4
;            does not apply for pPath objects; use the flatness parameter to control points density
;
; Style options:
; Regular = 0
; Bold = 1
; Italic = 2
; BoldItalic = 3
; Underline = 4
; Strikeout = 8
;
; Set Unit to 3 [Pts] to have the texts rendered at the same size
; with the texts rendered in GUIs with -DPIscale

   If (!minDist || minDist<1)
      minDist := FontSize//4 + 1

   If (pPath && !DriverPoints)
   {
      newPath := Gdip_ClonePath(pPath)
      Gdip_PathOutline(newPath, flatness)
      DriverPoints := Gdip_GetPathPoints(newPath)
      Gdip_DeletePath(newPath)
      If !DriverPoints
         Return -5
   }

   If (!pPath && !DriverPoints)
      Return -4

   If RegExMatch(FontName, "^(.\:\\.)")
   {
      hFontCollection := Gdip_NewPrivateFontCollection()
      hFontFamily := Gdip_CreateFontFamilyFromFile(FontName, hFontCollection)
   } Else hFontFamily := Gdip_FontFamilyCreate(FontName)

   If !hFontFamily
      hFontFamily := Gdip_FontFamilyCreateGeneric(1)

   If !hFontFamily
   {
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Return -1
   }

   hFont := Gdip_FontCreate(hFontFamily, FontSize, Style)
   If !hFont
   {
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Gdip_DeleteFontFamily(hFontFamily)
      Return -2
   }

   Points := StrSplit(DriverPoints, "|")
   PointsCount := Points.Length
   If (PointsCount<2)
   {
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Gdip_DeleteFont(hFont)
      Gdip_DeleteFontFamily(hFontFamily)
      Return -3
   }

   txtLen := StrLen(String)
   If (PointsCount<txtLen)
   {
      loopsMax := txtLen * 3
      newDriverPoints := DriverPoints
      Loop (loopsMax)
      { 
         newDriverPoints := GenerateIntermediatePoints(newDriverPoints, minDist, &totalResult)
         If (totalResult>=txtLen)
            Break
      }
      String := SubStr(String, 1, totalResult)
   } Else newDriverPoints := DriverPoints

   E := Gdip_DrawDrivenString(pGraphics, String, hFont, pBrush, newDriverPoints, 1, hMatrix)
   Gdip_DeleteFont(hFont)
   Gdip_DeleteFontFamily(hFontFamily)
   If hFontCollection
      Gdip_DeletePrivateFontCollection(hFontCollection)
   return E   
}

GenerateIntermediatePoints(PointsList, minDist, &resultPointsCount) {
; function used by Gdip_DrawFreeFormString()
   AllPoints := StrSplit(PointsList, "|")
   PointsCount := AllPoints.Length
   thizIndex := 0.5
   resultPointsCount := 0
   loopsMax := PointsCount*2
   Loop (loopsMax)
   {
        thizIndex += 0.5
        thisIndex := InStr(thizIndex, ".5") ? thizIndex : Trim(Round(thizIndex))
        thisPoint := AllPoints[thisIndex]
        theseCoords := StrSplit(thisPoint, ",")
        If (theseCoords[1]!="" && theseCoords[2]!="")
        {
           resultPointsCount++
           newPointsList .= theseCoords[1] "," theseCoords[2] "|"
        } Else
        {
           aIndex := Trim(Round(thizIndex - 0.5))
           bIndex := Trim(Round(thizIndex + 0.5))
           theseAcoords := StrSplit(AllPoints[aIndex], ",")
           theseBcoords := StrSplit(AllPoints[bIndex], ",")
           If (theseAcoords[1]!="" && theseAcoords[2]!="")
           && (theseBcoords[1]!="" && theseBcoords[2]!="")
           {
               newPosX := (theseAcoords[1] + theseBcoords[1])//2
               newPosY := (theseAcoords[2] + theseBcoords[2])//2
               distPosX := newPosX - theseAcoords[1]
               distPosY := newPosY - theseAcoords[2]
               If (distPosX>minDist || distPosY>minDist)
               {
                  newPointsList .= newPosX "," newPosY "|"
                  resultPointsCount++
               }
           }
        }
   }
   If !newPointsList
      Return PointsList
   Return Trim(newPointsList, "|")
}

Gdip_DrawDrivenString(pGraphics, String, hFont, pBrush, DriverPoints, Flags:=1, hMatrix:=0) {
; Parameters:
; pBrush       - pointer to a pBrush object used to draw the text into the given pGraphics
; hFont        - pointer for a Font object used to draw the given text that determines font, size and style 
; hMatrix      - pointer to a transformation matrix object that specifies the transformation matrix to apply to each value in the DriverPoints
; DriverPoints - a list of points coordinates that determines where the glyphs [letters] will be drawn
;                "x1,y1|x2,y2|x3,y3" [... and so on]
; Flags options:
; 1 - The string array contains Unicode character values. If this flag is not set, each value in $vText is
;     interpreted as an index to a font glyph that defines a character to be displayed
; 2 - The string is displayed vertically
; 4 - The glyph positions are calculated from the position of the first glyph. If this flag is not set, the
;     glyph positions are obtained from an array of coordinates ($aPoints)
; 8 - Less memory should be used for cache of antialiased glyphs. This also produces lower quality. If this
;     flag is not set, more memory is used, but the quality is higher

   txtLen := -1 ; StrLen(String)
   
   iCount := CreatePointsF(PointsF, DriverPoints)
   return DllCall("gdiplus\GdipDrawDriverString", "UPtr", pGraphics, "UPtr", &String, "int", txtLen, "UPtr", hFont, "UPtr", pBrush, "UPtr", &PointsF, "int", Flags, "UPtr", hMatrix)
}

; Format options [StringFormatFlags]
; DirectionRightToLeft    = 0x00000001
; - Activates is right to left reading order. For horizontal text, characters are read from right to left. For vertical text, columns are read from right to left.
; DirectionVertical       = 0x00000002
; - Individual lines of text are drawn vertically on the display device.
; NoFitBlackBox           = 0x00000004
; - Parts of characters are allowed to overhang the string's layout rectangle.
; DisplayFormatControl    = 0x00000020
; - Unicode layout control characters are displayed with a representative character.
; NoFontFallback          = 0x00000400
; - Prevent using an alternate font  for characters that are not supported in the requested font.
; MeasureTrailingSpaces   = 0x00000800
; - The spaces at the end of each line are included in a string measurement.
; NoWrap                  = 0x00001000
; - Disable text wrapping
; LineLimit               = 0x00002000
; - Only entire lines are laid out in the layout rectangle.
; NoClip                  = 0x00004000
; - Characters overhanging the layout rectangle and text extending outside the layout rectangle are allowed to show.

; StringFormatFlagsDirectionRightToLeft    = 0x00000001
; StringFormatFlagsDirectionVertical       = 0x00000002
; StringFormatFlagsNoFitBlackBox           = 0x00000004
; StringFormatFlagsDisplayFormatControl    = 0x00000020
; StringFormatFlagsNoFontFallback          = 0x00000400
; StringFormatFlagsMeasureTrailingSpaces   = 0x00000800
; StringFormatFlagsNoWrap                  = 0x00001000
; StringFormatFlagsLineLimit               = 0x00002000
; StringFormatFlagsNoClip                  = 0x00004000
Gdip_StringFormatCreate(Format:=0, Lang:=0)
{
	DllCall("gdiplus\GdipCreateStringFormat", "Int", Format, "Int", Lang, "UPtr*", &hFormat:=0)
	return hFormat
}

Gdip_CloneStringFormat(hStringFormat) {
   
   newHStringFormat := 0
   DllCall("gdiplus\GdipCloneStringFormat", "UPtr", hStringFormat, "uint*", newHStringFormat)
   Return newHStringFormat
}

Gdip_StringFormatGetGeneric(whichFormat:=0) {
; Default = 0
; Typographic := 1
   hStringFormat := 0
   If (whichFormat=1)
      DllCall("gdiplus\GdipStringFormatGetGenericTypographic", "UPtr*", hStringFormat)
   Else
      DllCall("gdiplus\GdipStringFormatGetGenericDefault", "UPtr*", hStringFormat)
   Return hStringFormat
}

Gdip_SetStringFormatAlign(hStringFormat, Align) {
; Text alignments:
; 0 - [Near / Left] Alignment is towards the origin of the bounding rectangle
; 1 - [Center] Alignment is centered between origin and extent (width) of the formatting rectangle
; 2 - [Far / Right] Alignment is to the far extent (right side) of the formatting rectangle

   return DllCall("gdiplus\GdipSetStringFormatAlign", "UPtr", hStringFormat, "int", Align)
}

Gdip_GetStringFormatAlign(hStringFormat) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatAlign", "UPtr", hStringFormat, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_GetStringFormatLineAlign(hStringFormat) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatLineAlign", "UPtr", hStringFormat, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_GetStringFormatDigitSubstitution(hStringFormat) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatDigitSubstitution", "UPtr", hStringFormat, "ushort*", 0, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_GetStringFormatHotkeyPrefix(hStringFormat) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatHotkeyPrefix", "UPtr", hStringFormat, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_GetStringFormatTrimming(hStringFormat) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetStringFormatTrimming", "UPtr", hStringFormat, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_SetStringFormatLineAlign(hStringFormat, StringAlign) {
; The line alignment setting specifies how to align the string vertically in the layout rectangle.
; The layout rectangle is used to position the displayed string
; StringAlign  - Type of line alignment to use:
; 0 - [Left] Alignment is towards the origin of the bounding rectangle
; 1 - [Center] Alignment is centered between origin and the height of the formatting rectangle
; 2 - [Right] Alignment is to the far extent (right side) of the formatting rectangle

   
   Return DllCall("gdiplus\GdipSetStringFormatLineAlign", "UPtr", hStringFormat, "int", StringAlign)
}

Gdip_SetStringFormatDigitSubstitution(hStringFormat, DigitSubstitute, LangID:=0) {
; Sets the language ID and the digit substitution method that is used by a StringFormat object
; DigitSubstitute - Digit substitution method that will be used by the StringFormat object:
; 0 - A user-defined substitution scheme
; 1 - Digit substitution is disabled
; 2 - Substitution digits that correspond with the official national language of the user's locale
; 3 - Substitution digits that correspond with the user's native script or language

   
   return DllCall("gdiplus\GdipSetStringFormatDigitSubstitution", "UPtr", hStringFormat, "ushort", LangID, "int", DigitSubstitute)
}

Gdip_SetStringFormatFlags(hStringFormat, Flags) {
; see Gdip_StringFormatCreate() for possible StringFormatFlags
   
   return DllCall("gdiplus\GdipSetStringFormatFlags", "UPtr", hStringFormat, "int", Flags)
}

Gdip_SetStringFormatHotkeyPrefix(hStringFormat, PrefixProcessMode) {
; Sets the type of processing that is performed on a string when a hot key prefix (&) is encountered
; PrefixProcessMode - Type of hot key prefix processing to use:
; 0 - No hot key processing occurs.
; 1 - Unicode text is scanned for ampersands (&). All pairs of ampersands are replaced by a single ampersand.
;     All single ampersands are removed, the first character that follows a single ampersand is displayed underlined.
; 2 - Same as 1 but a character following a single ampersand is not displayed underlined.

   
   return DllCall("gdiplus\GdipSetStringFormatHotkeyPrefix", "UPtr", hStringFormat, "int", PrefixProcessMode)
}

Gdip_SetStringFormatTrimming(hStringFormat, TrimMode) {
; TrimMode - The trimming style  to use:
; 0 - No trimming is done
; 1 - String is broken at the boundary of the last character that is inside the layout rectangle
; 2 - String is broken at the boundary of the last word that is inside the layout rectangle
; 3 - String is broken at the boundary of the last character that is inside the layout rectangle and an ellipsis (...) is inserted after the character
; 4 - String is broken at the boundary of the last word that is inside the layout rectangle and an ellipsis (...) is inserted after the word
; 5 - The center is removed from the string and replaced by an ellipsis. The algorithm keeps as much of the last portion of the string as possible

   
   return DllCall("gdiplus\GdipSetStringFormatTrimming", "UPtr", hStringFormat, "int", TrimMode)
}

; Font style options:
; Regular = 0
; Bold = 1
; Italic = 2
; BoldItalic = 3
; Underline = 4
; Strikeout = 8
; Unit options: see Gdip_SetPageUnit()
Gdip_FontCreate(hFamily, Size, Style:=0)
{
	DllCall("gdiplus\GdipCreateFont", "UPtr", hFamily, "Float", Size, "Int", Style, "Int", 0, "UPtr*", &hFont:=0)
	return hFont
}

Gdip_FontFamilyCreate(Font)
{
	DllCall("gdiplus\GdipCreateFontFamilyFromName"
					, "UPtr", StrPtr(Font)
					, "UInt", 0
					, "UPtr*", &hFamily:=0)

	return hFamily
}

Gdip_NewPrivateFontCollection() {
   hFontCollection := 0
   DllCall("gdiplus\GdipNewPrivateFontCollection", "ptr*", hFontCollection)
   Return hFontCollection
}

Gdip_CreateFontFamilyFromFile(FontFile, hFontCollection, FontName:="") {
; hFontCollection - the collection to add the font to
; Pass the result of Gdip_NewPrivateFontCollection() to this parameter
; to create a private collection of fonts.
; After no longer needing the private fonts, use Gdip_DeletePrivateFontCollection()
; to free up resources.
;
; GDI+ does not support PostScript fonts or OpenType fonts which do not have TrueType outlines.
;
; function by tmplinshi
; source: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=813&p=298435#p297794
; modified by Marius Șucan
   If !hFontCollection
      Return

   hFontFamily := 0
   E := DllCall("gdiplus\GdipPrivateAddFontFile", "ptr", hFontCollection, "str", FontFile)
   if (FontName="" && !E)
   {
      pFontFamily:=buffer( 10, 0)
      DllCall("gdiplus\GdipGetFontCollectionFamilyList", "ptr", hFontCollection, "int", 1, "ptr", pFontFamily.ptr, "int*", found:=0)

      FontName:=buffer( 100)
      DllCall("gdiplus\GdipGetFamilyName", "ptr", NumGet(pFontFamily, 0, "ptr"), "str", FontName, "ushort", 1033)
   }

   If !E
      DllCall("gdiplus\GdipCreateFontFamilyFromName", "str", FontName, "ptr", hFontCollection, "uint*", hFontFamily)
   Return hFontFamily
}

Gdip_FontFamilyCreateGeneric(whichStyle) {
; This function returns a hFontFamily font object that uses a generic font.
;
; whichStyle options:
; 0 - monospace generic font 
; 1 - sans-serif generic font 
; 2 - serif generic font 

   hFontFamily := 0
   If (whichStyle=0)
      DllCall("gdiplus\GdipGetGenericFontFamilyMonospace", "UPtr*", hFontFamily)
   Else If (whichStyle=1)
      DllCall("gdiplus\GdipGetGenericFontFamilySansSerif", "UPtr*", hFontFamily)
   Else If (whichStyle=2)
      DllCall("gdiplus\GdipGetGenericFontFamilySerif", "UPtr*", hFontFamily)
   Return hFontFamily
}

Gdip_CreateFontFromDC(hDC) {
; a font must be selected in the hDC for this function to work
; function extracted from a class based wrapper around the GDI+ API made by nnnik

   pFont := 0
   r := DllCall("gdiplus\GdipCreateFontFromDC", "UPtr", hDC, "UPtr*", pFont)
   Return pFont
}

Gdip_CreateFontFromLogfontW(hDC, LogFont) {
; extracted from: https://github.com/flipeador/Library-AutoHotkey/tree/master/graphics
; by flipeador
;
; Creates a Font object directly from a GDI logical font.
; The GDI logical font is a LOGFONTW structure, which is the wide character version of a logical font.
; Parameters:
;     hDC:
;         A handle to a Windows device context that has a font selected.
;     LogFont:
;         A LOGFONTW structure that contains attributes of the font.
;         The LOGFONTW structure is the wide character version of the logical font.
;
; https://docs.microsoft.com/en-us/windows/win32/api/gdiplusheaders/nf-gdiplusheaders-font-font(inhdc_inconstlogfontw)

     pFont := 0
     DllCall("Gdiplus\GdipCreateFontFromLogfontW", "Ptr", hDC, "Ptr", LogFont, "UPtrP", pFont)
     return pFont
}

Gdip_GetFontHeight(hFont, pGraphics:=0) {
; Gets the line spacing of a font in the current unit of a specified pGraphics object.
; The line spacing is the vertical distance between the base lines of two consecutive lines of text.
; Therefore, the line spacing includes the blank space between lines along with the height of 
; the character itself.

   
   result := 0
   DllCall("gdiplus\GdipGetFontHeight", "UPtr", hFont, "UPtr", pGraphics, "float*", result)
   Return result
}

Gdip_GetFontHeightGivenDPI(hFont, DPI:=72) {
; Remarks: it seems to always yield the same value 
; regardless of the given DPI.

   
   result := 0
   DllCall("gdiplus\GdipGetFontHeightGivenDPI", "UPtr", hFont, "float", DPI, "float*", result)
   Return result
}

Gdip_GetFontSize(hFont) {
   
   result := 0
   DllCall("gdiplus\GdipGetFontSize", "UPtr", hFont, "float*", result)
   Return result
}

Gdip_GetFontStyle(hFont) {
; see also Gdip_FontCreate()
   
   result := 0
   E := DllCall("gdiplus\GdipGetFontStyle", "UPtr", hFont, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_GetFontUnit(hFont) {
; Gets the unit of measure of a Font object.
   
   result := 0
   E := DllCall("gdiplus\GdipGetFontUnit", "UPtr", hFont, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_CloneFont(hfont) {
   
   newHFont := 0
   DllCall("gdiplus\GdipCloneFont", "UPtr", hFont, "UPtr*", newHFont)
   Return newHFont
}

Gdip_GetFontFamily(hFont) {
; On success returns a handle to a hFontFamily object
   
   hFontFamily := 0
   DllCall("gdiplus\GdipGetFamily", "UPtr", hFont, "UPtr*", hFontFamily)
   Return hFontFamily
}


Gdip_CloneFontFamily(hFontFamily) {
   
   newHFontFamily := 0
   DllCall("gdiplus\GdipCloneFontFamily", "UPtr", hFontFamily, "UPtr*", newHFontFamily)
   Return newHFontFamily
}

Gdip_IsFontStyleAvailable(hFontFamily, Style) {
; Remarks: given a proper hFontFamily object, it seems to be always 
; returning 1 [true] regardless of Style...

   
   result := 0
   E := DllCall("gdiplus\GdipIsStyleAvailable", "UPtr", hFontFamily, "int", Style, "Int*", result)
   If E
      Return -1
   Return result
}

Gdip_GetFontFamilyCellScents(hFontFamily, &Ascent, &Descent, Style:=0) {
; Ascent and Descent values are given in «design units»

   
   Ascent := 0
   Descent := 0
   E := DllCall("gdiplus\GdipGetCellAscent", "UPtr", hFontFamily, "int", Style, "ushort*", Ascent)
   E := DllCall("gdiplus\GdipGetCellDescent", "UPtr", hFontFamily, "int", Style, "ushort*", Descent)
   Return E
}

Gdip_GetFontFamilyEmHeight(hFontFamily, Style:=0) {
; EmHeight returned in «design units»
   
   result := 0
   DllCall("gdiplus\GdipGetEmHeight", "UPtr", hFontFamily, "int", Style, "ushort*", result)
   Return result
}

Gdip_GetFontFamilyLineSpacing(hFontFamily, Style:=0) {
; Line spacing returned in «design units»
   
   result := 0
   DllCall("gdiplus\GdipGetLineSpacing", "UPtr", hFontFamily, "int", Style, "ushort*", result)
   Return result
}

Gdip_GetFontFamilyName(hFontFamily) {
   
   FontName:=buffer( 90)
   DllCall("gdiplus\GdipGetFamilyName", "UPtr", hFontFamily, "Ptr", &FontName, "ushort", 0)
   Return FontName
}


;#####################################################################################
; Matrix functions
;#####################################################################################

Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y)
{
	DllCall("gdiplus\GdipCreateMatrix2", "Float", m11, "Float", m12, "Float", m21, "Float", m22, "Float", x, "Float", y, "UPtr*", &Matrix:=0)
	return Matrix
}

Gdip_CreateMatrix()
{
	DllCall("gdiplus\GdipCreateMatrix", "UPtr*", &Matrix:=0)
	return Matrix
}

Gdip_InvertMatrix(hMatrix) {
; Replaces the elements of a matrix with the elements of its inverse
   
   Return DllCall("gdiplus\GdipInvertMatrix", "UPtr", hMatrix)
}

Gdip_IsMatrixEqual(hMatrixA, hMatrixB) {
; compares two matrices; if identical, the function returns 1
   
   result := 0
   E := DllCall("gdiplus\GdipIsMatrixEqual", "UPtr", hMatrixA, "UPtr", hMatrixB, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_IsMatrixIdentity(hMatrix) {
; The identity matrix represents a transformation with no scaling, translation, rotation and conversion, and
; represents a transformation that does nothing.
   
   result := 0
   E := DllCall("gdiplus\GdipIsMatrixIdentity", "UPtr", hMatrix, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_IsMatrixInvertible(hMatrix) {
   
   result := 0
   E := DllCall("gdiplus\GdipIsMatrixInvertible", "UPtr", hMatrix, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_MultiplyMatrix(hMatrixA, hMatrixB, matrixOrder) {
; Updates hMatrixA with the product of itself and hMatrixB
; matrixOrder - Order of matrices multiplication:
; 0 - The second matrix is on the left
; 1 - The second matrix is on the right

   
   Return DllCall("gdiplus\GdipMultiplyMatrix", "UPtr", hMatrixA, "UPtr", hMatrixB, "int", matrixOrder)
}

Gdip_CloneMatrix(hMatrix) {
   
   newHMatrix := 0
   DllCall("gdiplus\GdipCloneMatrix", "UPtr", hMatrix, "UPtr*", newHMatrix)
   return newHMatrix
}

;#####################################################################################
; GraphicsPath functions
; pPath objects are rendered/drawn by pGraphics object using:
; - a) Gdip_FillPath() with an associated pBrush object created with any of the following functions:
;       - Gdip_BrushCreateSolid()     - SolidFill
;       - Gdip_CreateTextureBrush()   - Texture brush derived from a pBitmap
;       - Gdip_CreateLinearGrBrush()  - LinearGradient
;       - Gdip_BrushCreateHatch()     - Hatch pattern
;       - Gdip_PathGradientCreateFromPath()
; - b) Gdip_DrawPath() with an associated pPen created with Gdip_CreatePen()
;
; A pPath object can be converted using:
; - a) Gdip_PathGradientCreateFromPath() to a PathGradient brush object
; - b) Gdip_CreateRegionPath() to a region object
;#####################################################################################

; Alternate = 0
; Winding = 1
Gdip_CreatePath(BrushMode:=0)
{
	DllCall("gdiplus\GdipCreatePath", "Int", BrushMode, "UPtr*", &pPath:=0)
	return pPath
}

Gdip_AddPathEllipse(pPath, x, y, w, h) {
   return DllCall("gdiplus\GdipAddPathEllipse", "UPtr", pPath, "float", x, "float", y, "float", w, "float", h)
}

Gdip_AddPathRectangle(pPath, x, y, w, h) {
   return DllCall("gdiplus\GdipAddPathRectangle", "UPtr", pPath, "float", x, "float", y, "float", w, "float", h)
}

Gdip_AddPathRoundedRectangle(pPath, x, y, w, h, r) {
; extracted from: https://github.com/tariqporter/Gdip2/blob/master/lib/Object.ahk
; and adapted by Marius Șucan
   E := 0
   r := (w <= h) ? (r < w / 2) ? r : w / 2 : (r < h / 2) ? r : h / 2
   If (E := Gdip_AddPathRectangle(pPath, x+r, y, w-(2*r), r))
      Return E
   If (E := Gdip_AddPathRectangle(pPath, x+r, y+h-r, w-(2*r), r))
      Return E
   If (E := Gdip_AddPathRectangle(pPath, x, y+r, r, h-(2*r)))
      Return E
   If (E := Gdip_AddPathRectangle(pPath, x+w-r, y+r, r, h-(2*r)))
      Return E
   If (E := Gdip_AddPathRectangle(pPath, x+r, y+r, w-(2*r), h-(2*r)))
      Return E
   If (E := Gdip_AddPathPie(pPath, x, y, 2*r, 2*r, 180, 90))
      Return E
   If (E := Gdip_AddPathPie(pPath, x+w-(2*r), y, 2*r, 2*r, 270, 90))
      Return E
   If (E := Gdip_AddPathPie(pPath, x, y+h-(2*r), 2*r, 2*r, 90, 90))
      Return E
   If (E := Gdip_AddPathPie(pPath, x+w-(2*r), y+h-(2*r), 2*r, 2*r, 0, 90))
      Return E
   Return E
}

Gdip_AddPathPolygon(pPath, Points)
{
	Points := StrSplit(Points, "|")
	PointsLength := Points.Length
	PointF := Buffer(8*PointsLength)
	for eachPoint, Point in Points
	{
		Coord := StrSplit(Point, ",")
		NumPut("Float", Coord[1], PointF, 8*(A_Index-1))
		NumPut("Float", Coord[2], PointF, (8*(A_Index-1))+4)
	}

	return DllCall("gdiplus\GdipAddPathPolygon", "UPtr", pPath, "UPtr", PointF.Ptr, "Int", PointsLength)
}

Gdip_AddPathClosedCurve(pPath, Points, Tension:="") {
; Adds a closed cardinal spline to a path.
; A cardinal spline is a curve that passes through each point in the array.
;
; Parameters:
; pPath: Pointer to the GraphicsPath
; Points: the coordinates of all the points passed as x1,y1|x2,y2|x3,y3..... [minimum three points must be given]
; Tension: Non-negative real number that controls the length of the curve and how the curve bends. A value of
; zero specifies that the spline is a sequence of straight lines. As the value increases, the curve becomes fuller.

  
  iCount := CreatePointsF(PointsF, Points)
  If Tension
     return DllCall("gdiplus\GdipAddPathClosedCurve2", "UPtr", pPath, "UPtr", &PointsF, "int", iCount, "float", Tension)
  Else
     return DllCall("gdiplus\GdipAddPathClosedCurve", "UPtr", pPath, "UPtr", &PointsF, "int", iCount)
}

Gdip_AddPathCurve(pPath, Points, Tension:="") {
; Adds a cardinal spline to the current figure of a path
; A cardinal spline is a curve that passes through each point in the array.
;
; Parameters:
; pPath: Pointer to the GraphicsPath
; Points: the coordinates of all the points passed as x1,y1|x2,y2|x3,y3..... [minimum three points must be given]
; Tension: Non-negative real number that controls the length of the curve and how the curve bends. A value of
; zero specifies that the spline is a sequence of straight lines. As the value increases, the curve becomes fuller.

  
  iCount := CreatePointsF(PointsF, Points)
  If Tension
     return DllCall("gdiplus\GdipAddPathCurve2", "UPtr", pPath, "UPtr", &PointsF, "int", iCount, "float", Tension)
  Else
     return DllCall("gdiplus\GdipAddPathCurve", "UPtr", pPath, "UPtr", &PointsF, "int", iCount)
}

Gdip_AddPathToPath(pPathA, pPathB, fConnect) {
; Adds a path into another path.
;
; Parameters:
; pPathA and pPathB - Pointers to GraphicsPath objects
; fConnect - Specifies whether the first figure in the added path is part of the last figure in this path:
; 1 - The first figure in the added pPathB is part of the last figure in the pPathB path.
; 0 - The first figure in the added pPathB is separated from the last figure in the pPathA path.
;
; Remarks: Even if the value of the fConnect parameter is 1, this function might not be able to make the first figure
; of the added pPathB path part of the last figure of the pPathA path. If either of those figures is closed,
; then they must remain separated figures.

  
  return DllCall("gdiplus\GdipAddPathCurve2", "UPtr", pPathA, "UPtr", pPathB, "int", fConnect)
}

Gdip_AddPathStringSimplified(pPath, String, FontName, Size, Style, X, Y, Width, Height, Align:=0, NoWrap:=0) {
; Adds the outline of a given string with the given font name, size and style 
; to a Path object.

; Size - in em, in world units [font size]
; Remarks: a high value might be required; over 60, 90... to see the text.

; X, Y   - coordinates for the rectangle where the text will be placed
; W, H   - width and heigh for the rectangle where the text will be placed

; Align options:
; Near/left = 0
; Center = 1
; Far/right = 2

; Style options:
; Regular = 0
; Bold = 1
; Italic = 2
; BoldItalic = 3
; Underline = 4
; Strikeout = 8

   FormatStyle := NoWrap ? 0x4000 | 0x1000 : 0x4000
   If RegExMatch(FontName, "^(.\:\\.)")
   {
      hFontCollection := Gdip_NewPrivateFontCollection()
      hFontFamily := Gdip_CreateFontFamilyFromFile(FontName, hFontCollection)
   } Else hFontFamily := Gdip_FontFamilyCreate(FontName)

   If !hFontFamily
      hFontFamily := Gdip_FontFamilyCreateGeneric(1)
 
   If !hFontFamily
   {
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Return -1
   }

   hStringFormat := Gdip_StringFormatCreate(FormatStyle)
   If !hStringFormat
      hStringFormat := Gdip_StringFormatGetGeneric(1)

   If !hStringFormat
   {
      Gdip_DeleteFontFamily(hFontFamily)
      If hFontCollection
         Gdip_DeletePrivateFontCollection(hFontCollection)
      Return -2
   }

   Gdip_SetStringFormatTrimming(hStringFormat, 3)
   Gdip_SetStringFormatAlign(hStringFormat, Align)
   E := Gdip_AddPathString(pPath, String, hFontFamily, Style, Size, hStringFormat, X, Y, Width, Height)
   Gdip_DeleteStringFormat(hStringFormat)
   Gdip_DeleteFontFamily(hFontFamily)
   If hFontCollection
      Gdip_DeletePrivateFontCollection(hFontCollection)
   Return E
}

Gdip_AddPathString(pPath, String, hFontFamily, Style, Size, hStringFormat, X, Y, W, H) {
   
   CreateRectF(&RectF, X, Y, W, H)
   E := DllCall("gdiplus\GdipAddPathString", "UPtr", pPath, "WStr", String, "int", -1, "UPtr", hFontFamily, "int", Style, "float", Size, "UPtr", RectF.ptr, "UPtr", hStringFormat)
   Return E
}


Gdip_SetPathFillMode(pPath, FillMode) {
; Parameters
; pPath      - Pointer to a GraphicsPath object
; FillMode   - Path fill mode:
;              0 -  [Alternate] The areas are filled according to the even-odd parity rule
;              1 -  [Winding] The areas are filled according to the non-zero winding rule

   return DllCall("gdiplus\GdipSetPathFillMode", "UPtr", pPath, "int", FillMode)
}

Gdip_GetPathFillMode(pPath) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetPathFillMode", "UPtr", pPath, "int*", result)
   If E 
      Return -1
   Return result
}

Gdip_GetPathLastPoint(pPath, &X, &Y) {
   
   PointF:=buffer( 8, 0)
   E := DllCall("gdiplus\GdipGetPathLastPoint", "UPtr", pPath, "UPtr", &PointF)
   If !E
   {
      x := NumGet(PointF, 0, "float")
      y := NumGet(PointF, 4, "float")
   }

   Return E
}

Gdip_GetPathPointsCount(pPath) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetPointCount", "UPtr", pPath, "int*", result)
   If E 
      Return -1
   Return result
}

Gdip_GetPathPoints(pPath) {
   PointsCount := Gdip_GetPathPointsCount(pPath)
   If (PointsCount=-1)
      Return 0

   
   PointsF:=buffer( 8 * PointsCount, 0)
   DllCall("gdiplus\GdipGetPathPoints", "UPtr", pPath, "UPtr", &PointsF, "intP", PointsCount)
   Loop (PointsCount)
   {
       A := NumGet(&PointsF, 8*(A_Index-1), "float")
       B := NumGet(&PointsF, (8*(A_Index-1))+4, "float")
       printList .= A "," B "|"
   }
   Return Trim(printList, "|")
}

Gdip_FlattenPath(pPath, flatness, hMatrix:=0) {
; flatness - a precision value that specifies the maximum error between the path and
; its flattened [segmented] approximation. Reducing the flatness increases the number
; of line segments in the approximation. 
;
; hMatrix - a pointer to a transformation matrix to apply.
   
   return DllCall("gdiplus\GdipFlattenPath", "UPtr", pPath, "UPtr", hMatrix, "float", flatness)
}

Gdip_WidenPath(pPath, pPen, hMatrix:=0, Flatness:=1) {
; Replaces this path with curves that enclose the area that is filled when this path is drawn by a specified pen.
; This method also flattens the path.

  
  return DllCall("gdiplus\GdipWidenPath", "UPtr", pPath, "uint", pPen, "UPtr", hMatrix, "float", Flatness)
}

Gdip_PathOutline(pPath, flatness:=1, hMatrix:=0) {
; Transforms and flattens [segmentates] a pPath object, and then converts the path's data points
; so that they represent only the outline of the given path.
;
; flatness - a precision value that specifies the maximum error between the path and
; its flattened [segmented] approximation. Reducing the flatness increases the number
; of line segments in the resulted approximation. 
;
; hMatrix - a pointer to a transformation matrix to apply.

   
   return DllCall("gdiplus\GdipWindingModeOutline", "UPtr", pPath, "UPtr", hMatrix, "float", flatness)
}

Gdip_ResetPath(pPath) {
; Empties a path and sets the fill mode to alternate (0)

   
   Return DllCall("gdiplus\GdipResetPath", "UPtr", pPath)
}

Gdip_ReversePath(pPath) {
; Reverses the order of the points that define a path's lines and curves

   
   Return DllCall("gdiplus\GdipReversePath", "UPtr", pPath)
}

Gdip_IsOutlineVisiblePathPoint(pGraphics, pPath, pPen, X, Y) {
   result := 0
   E := DllCall("gdiplus\GdipIsOutlineVisiblePathPoint", "UPtr", pPath, "float", X, "float", Y, "UPtr", pPen, "UPtr", pGraphics, "int*", result)
   If E 
      Return -1
   Return result
}

Gdip_IsVisiblePathPoint(pPath, x, y, pGraphics) {
; Function by RazorHalo, modified by Marius Șucan
  result := 0
  
  E := DllCall("gdiplus\GdipIsVisiblePathPoint", "UPtr", pPath, "float", x, "float", y, "UPtr", pGraphics, "UPtr*", result)
  If E
     return -1
  return result
}

Gdip_DeletePath(pPath) {
   return DllCall("gdiplus\GdipDeletePath", "UPtr", pPath)
}

;#####################################################################################
; pGraphics rendering options functions
;#####################################################################################

Gdip_SetTextRenderingHint(pGraphics, RenderingHint) {
; RenderingHint options:
; SystemDefault = 0
; SingleBitPerPixelGridFit = 1
; SingleBitPerPixel = 2
; AntiAliasGridFit = 3
; AntiAlias = 4
   return DllCall("gdiplus\GdipSetTextRenderingHint", "UPtr", pGraphics, "int", RenderingHint)
}

Gdip_SetInterpolationMode(pGraphics, InterpolationMode) {
; InterpolationMode options:
; Default = 0
; LowQuality = 1
; HighQuality = 2
; Bilinear = 3
; Bicubic = 4
; NearestNeighbor = 5
; HighQualityBilinear = 6
; HighQualityBicubic = 7
   return DllCall("gdiplus\GdipSetInterpolationMode", "UPtr", pGraphics, "int", InterpolationMode)
}

; SmoothingMode options:
; Default = 0
; HighSpeed = 1
; HighQuality = 2
; None = 3
; AntiAlias = 4
; AntiAlias8x4 = 5
; AntiAlias8x8 = 6
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
{
	return DllCall("gdiplus\GdipSetSmoothingMode", "UPtr", pGraphics, "Int", SmoothingMode)
}

; CompositingModeSourceOver = 0 (blended)
; CompositingModeSourceCopy = 1 (overwrite)
Gdip_SetCompositingMode(pGraphics, CompositingMode:=0)
{
	return DllCall("gdiplus\GdipSetCompositingMode", "UPtr", pGraphics, "Int", CompositingMode)
}

Gdip_SetCompositingQuality(pGraphics, CompositionQuality) {
; CompositionQuality options:
; 0 - Gamma correction is not applied.
; 1 - Gamma correction is not applied. High speed, low quality.
; 2 - Gamma correction is applied. Composition of high quality and speed.
; 3 - Gamma correction is applied.
; 4 - Gamma correction is not applied. Linear values are used.

   
   return DllCall("gdiplus\GdipSetCompositingQuality", "UPtr", pGraphics, "int", CompositionQuality)
} 

Gdip_SetPageScale(pGraphics, Scale) {
; Sets the scaling factor for the page transformation of a pGraphics object.
; The page transformation converts page coordinates to device coordinates.

   
   return DllCall("gdiplus\GdipSetPageScale", "UPtr", pGraphics, "float", Scale)
}

Gdip_SetPageUnit(pGraphics, Unit) {
; Sets the unit of measurement for a pGraphics object.
; Unit of measuremnet options:
; 0 - World coordinates, a non-physical unit
; 1 - Display units
; 2 - A unit is 1 pixel
; 3 - A unit is 1 point or 1/72 inch
; 4 - A unit is 1 inch
; 5 - A unit is 1/300 inch
; 6 - A unit is 1 millimeter

   
   return DllCall("gdiplus\GdipSetPageUnit", "UPtr", pGraphics, "int", Unit)
}

Gdip_SetPixelOffsetMode(pGraphics, PixelOffsetMode) {
; Sets the pixel offset mode of a pGraphics object.
; PixelOffsetMode options:
; HighSpeed = QualityModeLow - Default
;             0, 1, 3 - Pixel centers have integer coordinates
; ModeHalf - ModeHighQuality
;             2, 4    - Pixel centers have coordinates that are half way between integer values (i.e. 0.5, 20, 105.5, etc...)

   
   return DllCall("gdiplus\GdipSetPixelOffsetMode", "UPtr", pGraphics, "int", PixelOffsetMode)
}

Gdip_SetRenderingOrigin(pGraphics, X, Y) {
; The rendering origin is used to set the dither origin for 8-bits-per-pixel and 16-bits-per-pixel dithering
; and is also used to set the origin for hatch brushes
   
   return DllCall("gdiplus\GdipSetRenderingOrigin", "UPtr", pGraphics, "int", X, "int", Y)
}

Gdip_SetTextContrast(pGraphics, Contrast) {
; Contrast - A number between 0 and 12, which defines the value of contrast used for antialiasing text

   
   return DllCall("gdiplus\GdipSetTextContrast", "UPtr", pGraphics, "uint", Contrast)
}

Gdip_RestoreGraphics(pGraphics, State) {
  ; Sets the state of this Graphics object to the state stored by a previous call to the Save method of this Graphics object.
  ; Parameters:
  ;     State:
  ;         A value returned by a previous call to the Save method that identifies a block of saved state.
  ; Return value:
  ;     Returns TRUE if successful, or FALSE otherwise. To get extended error information, check Â«Gdiplus.LastStatusÂ».
  ; https://docs.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-restore
    return DllCall("Gdiplus\GdipRestoreGraphics", "UPtr", pGraphics, "UInt", State)
}

Gdip_SaveGraphics(pGraphics) {
  ; Saves the current state (transformations, clipping region, and quality settings) of this Graphics object.
  ; You can restore the state later by calling the Restore method.
  ; Return value:
  ;     Returns a value that identifies the saved state.
  ;     Pass this value to the Restore method when you want to restore the state.
  ; Remarks:
  ;     The identifier returned by a given call to the Save method can be passed only once to the Restore method.
 ; https://docs.microsoft.com/en-us/windows/win32/api/gdiplusgraphics/nf-gdiplusgraphics-graphics-save
     State := 0
     DllCall("Gdiplus\GdipSaveGraphics", "Ptr", pGraphics, "UIntP", State)
     return State
}

Gdip_GetTextContrast(pGraphics) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetTextContrast", "UPtr", pGraphics, "uint*", result)
   If E
      return -1
   Return result
}

Gdip_GetCompositingMode(pGraphics) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetCompositingMode", "UPtr", pGraphics, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetCompositingQuality(pGraphics) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetCompositingQuality", "UPtr", pGraphics, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetInterpolationMode(pGraphics) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetInterpolationMode", "UPtr", pGraphics, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetSmoothingMode(pGraphics) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetSmoothingMode", "UPtr", pGraphics, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetPageScale(pGraphics) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetPageScale", "UPtr", pGraphics, "float*", result)
   If E
      return -1
   Return result
}

Gdip_GetPageUnit(pGraphics) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetPageUnit", "UPtr", pGraphics, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetPixelOffsetMode(pGraphics) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetPixelOffsetMode", "UPtr", pGraphics, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetRenderingOrigin(pGraphics, &X, &Y) {
   
   x := 0
   y := 0
   return DllCall("gdiplus\GdipGetRenderingOrigin", "UPtr", pGraphics, "uint*", X, "uint*", Y)
}

Gdip_GetTextRenderingHint(pGraphics) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetTextRenderingHint", "UPtr", pGraphics, "int*", result)
   If E
      return -1
   Return result
}

;#####################################################################################
; More pGraphics functions
;#####################################################################################

; MatrixOrder options:
; Prepend = 0; The new operation is applied before the old operation.
; Append = 1; The new operation is applied after the old operation.
; Order of matrices multiplication:.
Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipRotateWorldTransform", "UPtr", pGraphics, "float", Angle, "int", MatrixOrder)
}

Gdip_ScaleWorldTransform(pGraphics, ScaleX, ScaleY, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipScaleWorldTransform", "UPtr", pGraphics, "float", ScaleX, "float", ScaleY, "int", MatrixOrder)
}

Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder:=0) {
   return DllCall("gdiplus\GdipTranslateWorldTransform", "UPtr", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}

Gdip_MultiplyWorldTransform(pGraphics, hMatrix, matrixOrder:=0) {
   
   Return DllCall("gdiplus\GdipMultiplyWorldTransform", "UPtr", pGraphics, "UPtr", hMatrix, "int", matrixOrder)
}

Gdip_ResetWorldTransform(pGraphics) {
   return DllCall("gdiplus\GdipResetWorldTransform", "UPtr", pGraphics)
}

Gdip_ResetPageTransform(pGraphics) {
   return DllCall("gdiplus\GdipResetPageTransform", "UPtr", pGraphics)
}

Gdip_SetWorldTransform(pGraphics, hMatrix) {
   
   return DllCall("gdiplus\GdipSetWorldTransform", "UPtr", pGraphics, "UPtr", hMatrix)
}

Gdip_GetRotatedTranslation(Width, Height, Angle, &xTranslation, &yTranslation) {
   pi := 3.14159, TAngle := Angle*(pi/180)

   Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
   if ((Bound >= 0) && (Bound <= 90))
      xTranslation := Height*Sin(TAngle), yTranslation := 0
   else if ((Bound > 90) && (Bound <= 180))
      xTranslation := (Height*Sin(TAngle))-(Width*Cos(TAngle)), yTranslation := -Height*Cos(TAngle)
   else if ((Bound > 180) && (Bound <= 270))
      xTranslation := -(Width*Cos(TAngle)), yTranslation := -(Height*Cos(TAngle))-(Width*Sin(TAngle))
   else if ((Bound > 270) && (Bound <= 360))
      xTranslation := 0, yTranslation := -Width*Sin(TAngle)
}

Gdip_GetRotatedDimensions(Width, Height, Angle, &RWidth, &RHeight)
{
	pi := 3.14159, TAngle := Angle*(pi/180)

	if !(Width && Height) {
		return -1
	}

	RWidth := Ceil(Abs(Width*Cos(TAngle))+Abs(Height*Sin(TAngle)))
	RHeight := Ceil(Abs(Width*Sin(TAngle))+Abs(Height*Cos(Tangle)))
}

Gdip_GetRotatedEllipseDimensions(Width, Height, Angle, &RWidth, &RHeight) {
   if !(Width && Height)
      return -1

   pPath := Gdip_CreatePath()
   Gdip_AddPathEllipse(pPath, 0, 0, Width, Height)
   ; testAngle := Mod(Angle, 30)
   pMatrix := Gdip_CreateMatrix()
   Gdip_RotateMatrix(pMatrix, Angle, &MatrixOrder)
   E := Gdip_TransformPath(pPath, pMatrix)
   Gdip_DeleteMatrix(pMatrix)
   pathBounds := Gdip_GetPathWorldBounds(pPath)
   Gdip_DeletePath(pPath)
   RWidth := pathBounds.w
   RHeight := pathBounds.h
   Return E
}

Gdip_GetWorldTransform(pGraphics) {
; Returns the world transformation matrix of a pGraphics object.
; On error, it returns -1
   
   E := DllCall("gdiplus\GdipGetWorldTransform", "UPtr", pGraphics, "UPtr*", &hMatrix:=0)
   Return hMatrix
}

Gdip_IsVisibleGraphPoint(pGraphics, X, Y) {
   
   result := 0
   E := DllCall("gdiplus\GdipIsVisiblePoint", "UPtr", pGraphics, "float", X, "float", Y, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_IsVisibleGraphRect(pGraphics, X, Y, Width, Height) {
   
   result := 0
   E := DllCall("gdiplus\GdipIsVisibleRect", "UPtr", pGraphics, "float", X, "float", Y, "float", Width, "float", Height, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_IsVisibleGraphRectEntirely(pGraphics, X, Y, Width, Height) {
    a := Gdip_IsVisibleGraphPoint(pGraphics, X, Y)
    b := Gdip_IsVisibleGraphPoint(pGraphics, X + Width, Y)
    c := Gdip_IsVisibleGraphPoint(pGraphics, X + Width, Y + Height)
    d := Gdip_IsVisibleGraphPoint(pGraphics, X, Y + Height)
    If (a=1 && b=1 && c=1 && d=1)
       Return 1
    Else If (a=-1 || b=-1 || c=-1 || d=-1)
       Return -1
    Else
       Return 0
}

;#####################################################################################
; Region and clip functions [pGraphics related]
;
; One of the properties of the pGraphics class is the clip region.
; All drawing done in a given pGraphics object can be restricted
; to the clip region of that pGraphics object. 

; The GDI+ Region class allows you to define a custom shape.
; The shape[s] can be made up of lines, polygons, and curves.
;
; Two common uses for regions are hit testing and clipping. 
; Hit testing is determining whether the mouse was clicked
; in a certain region of the screen.
;
; Clipping is restricting drawing to a certain region in
; a given pGraphics object.
;
;#####################################################################################

Gdip_IsClipEmpty(pGraphics) {
; Determines whether the clipping region of a pGraphics object is empty

   
   result := 0
   E := DllCall("gdiplus\GdipIsClipEmpty", "UPtr", pGraphics, "int*", result)
   If E
      Return -1
   Return result
}

Gdip_IsVisibleClipEmpty(pGraphics) {
   
   result := 0
   E := DllCall("gdiplus\GdipIsVisibleClipEmpty", "UPtr", pGraphics, "uint*", result)
   If E
      Return -1
   Return result
}

;#####################################################################################

; Name............. Gdip_SetClipFromGraphics
;
; Parameters:
; pGraphicsA        Pointer to a pGraphics object
; pGrahpicsB        Pointer to a pGraphics object that contains the clipping region to be combined with
;                   the clipping region of the pGraphicsA object
; CombineMode       Regions combination mode:
;                   0 - The existing region is replaced by the new region
;                   1 - The existing region is replaced by the intersection of itself and the new region
;                   2 - The existing region is replaced by the union of itself and the new region
;                   3 - The existing region is replaced by the result of performing an XOR on the two regions
;                   4 - The existing region is replaced by the portion of itself that is outside of the new region
;                   5 - The existing region is replaced by the portion of the new region that is outside of the existing region
; return            Status enumeration value

Gdip_SetClipFromGraphics(pGraphics, pGraphicsSrc, CombineMode:=0) {
   
   return DllCall("gdiplus\GdipSetClipGraphics", "UPtr", pGraphics, "UPtr", pGraphicsSrc, "int", CombineMode)
}

Gdip_GetClipBounds(pGraphics) {
  
  rData := {}

  RectF:=buffer( 16, 0)
  status := DllCall("gdiplus\GdipGetClipBounds", "UPtr", pGraphics, "UPtr", RectF.ptr)

  If (!status) {
        rData.x := NumGet(RectF, 0, "float")
      , rData.y := NumGet(RectF, 4, "float")
      , rData.w := NumGet(RectF, 8, "float")
      , rData.h := NumGet(RectF, 12, "float")
  } Else {
    Return status
  }

  return rData
}

Gdip_GetVisibleClipBounds(pGraphics) {
  
  rData := {}

  RectF:=buffer( 16, 0)
  status := DllCall("gdiplus\GdipGetVisibleClipBounds", "UPtr", pGraphics, "UPtr", RectF.ptr)

  If (!status) {
        rData.x := NumGet(RectF, 0, "float")
      , rData.y := NumGet(RectF, 4, "float")
      , rData.w := NumGet(RectF, 8, "float")
      , rData.h := NumGet(RectF, 12, "float")
  } Else {
    Return status
  }

  return rData
}

Gdip_TranslateClip(pGraphics, dX, dY) {
   
   return DllCall("gdiplus\GdipTranslateClip", "UPtr", pGraphics, "float", dX, "float", dY)
}

Gdip_ResetClip(pGraphics) {
   return DllCall("gdiplus\GdipResetClip", "UPtr", pGraphics)
}

Gdip_GetClipRegion(pGraphics)
{
	Region := Gdip_CreateRegion()
	DllCall("gdiplus\GdipGetClip", "UPtr", pGraphics, "UInt", Region)
	return Region
}

Gdip_SetClipRegion(pGraphics, Region, CombineMode:=0)
{
	return DllCall("gdiplus\GdipSetClipRegion", "UPtr", pGraphics, "UPtr", Region, "Int", CombineMode)
}

; Replace = 0
; Intersect = 1
; Union = 2
; Xor = 3
; Exclude = 4
; Complement = 5
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode:=0)
{
	return DllCall("gdiplus\GdipSetClipRect",  "UPtr", pGraphics, "Float", x, "Float", y, "Float", w, "Float", h, "Int", CombineMode)
}

Gdip_SetClipPath(pGraphics, pPath, CombineMode:=0) {
   
   return DllCall("gdiplus\GdipSetClipPath", "UPtr", pGraphics, "UPtr", pPath, "int", CombineMode)
}

Gdip_CombineRegionRegion(Region, Region2, CombineMode) {
; Updates this region to the portion of itself that intersects another region. Added by Learning one
; see CombineMode options from Gdip_SetClipRect()

   
   return DllCall("gdiplus\GdipCombineRegionRegion", "UPtr", Region, "UPtr", Region2, "int", CombineMode)
}

Gdip_CombineRegionRect(Region, x, y, w, h, CombineMode) {
; Updates this region to the portion of itself that intersects with the given rectangle.
; see CombineMode options from Gdip_SetClipRect()

   
   CreateRectF(&RectF, x, y, w, h)
   return DllCall("gdiplus\GdipCombineRegionRect", "UPtr", Region, "UPtr", RectF.ptr, "int", CombineMode)
}

Gdip_CombineRegionPath(Region, pPath, CombineMode) {
; see CombineMode options from Gdip_SetClipRect()
   
   return DllCall("gdiplus\GdipCombineRegionPath", "UPtr", Region, "UPtr", pPath, "int", CombineMode)
}

Gdip_CreateRegionPath(pPath) {
; Creates a region that is defined by a GraphicsPath [pPath object]. Written by Learning one.

   
   Region := 0
   E := DllCall("gdiplus\GdipCreateRegionPath", "UPtr", pPath, "UInt*", Region)
   If E
      return -1
   return Region
}

Gdip_CreateRegionRect(x, y, w, h) {
   CreateRectF(&RectF, x, y, w, h)
   E := DllCall("gdiplus\GdipCreateRegionRect", "UPtr", RectF.ptr, "UInt*", &Region:=0)
   If E
      return -1
   return Region
}

Gdip_IsEmptyRegion(pGraphics, Region) {
   
   result := 0
   E := DllCall("gdiplus\GdipIsEmptyRegion", "UPtr", Region, "UPtr", pGraphics, "uInt*", result)
   If E
      return -1
   Return result
}

Gdip_IsEqualRegion(pGraphics, Region1, Region2) {
   
   result := 0
   E := DllCall("gdiplus\GdipIsEqualRegion", "UPtr", Region1, "UPtr", Region2, "UPtr", pGraphics, "uInt*", result)
   If E
      return -1
   Return result
}

Gdip_IsInfiniteRegion(pGraphics, Region) {
   
   result := 0
   E := DllCall("gdiplus\GdipIsInfiniteRegion", "UPtr", Region, "UPtr", pGraphics, "uInt*", result)
   If E
      return -1
   Return result
}

Gdip_IsVisibleRegionPoint(pGraphics, Region, x, y) {
   
   result := 0
   E := DllCall("gdiplus\GdipIsVisibleRegionPoint", "UPtr", Region, "float", X, "float", Y, "UPtr", pGraphics, "uInt*", result)
   If E
      return -1
   Return result
}

Gdip_IsVisibleRegionRect(pGraphics, Region, x, y, width, height) {
   
   result := 0
   E := DllCall("gdiplus\GdipIsVisibleRegionRect", "UPtr", Region, "float", X, "float", Y, "float", Width, "float", Height, "UPtr", pGraphics, "uInt*", result)
   If E
      return -1
   Return result
}

Gdip_IsVisibleRegionRectEntirely(pGraphics, Region, x, y, width, height) {
    a := Gdip_IsVisibleRegionPoint(pGraphics, Region, X, Y)
    b := Gdip_IsVisibleRegionPoint(pGraphics, Region, X + Width, Y)
    c := Gdip_IsVisibleRegionPoint(pGraphics, Region, X + Width, Y + Height)
    d := Gdip_IsVisibleRegionPoint(pGraphics, Region, X, Y + Height)
    If (a=1 && b=1 && c=1 && d=1)
       Return 1
    Else If (a=-1 || b=-1 || c=-1 || d=-1)
       Return -1
    Else
       Return 0
}

Gdip_SetEmptyRegion(Region) {
   
   return DllCall("gdiplus\GdipSetEmpty", "UPtr", Region)
}

Gdip_SetInfiniteRegion(Region) {
   
   return DllCall("gdiplus\GdipSetInfinite", "UPtr", Region)
}

Gdip_GetRegionBounds(pGraphics, Region) {
  
  rData := {}

  RectF:=buffer( 16, 0)
  status := DllCall("gdiplus\GdipGetRegionBounds", "UPtr", Region, "UPtr", pGraphics, "UPtr", RectF.ptr)

  If (!status) {
        rData.x := NumGet(RectF, 0, "float")
      , rData.y := NumGet(RectF, 4, "float")
      , rData.w := NumGet(RectF, 8, "float")
      , rData.h := NumGet(RectF, 12, "float")
  } Else {
    Return status
  }

  return rData
}

Gdip_TranslateRegion(Region, X, Y) {
   
   return DllCall("gdiplus\GdipTranslateRegion", "UPtr", Region, "float", X, "float", Y)
}

Gdip_RotateRegionAtCenter(pGraphics, Region, Angle, MatrixOrder:=1) {
; function by Marius Șucan
; based on Gdip_RotatePathAtCenter() by RazorHalo

  Rect := Gdip_GetRegionBounds(pGraphics, Region)
  cX := Rect.x + (Rect.w / 2)
  cY := Rect.y + (Rect.h / 2)
  pMatrix := Gdip_CreateMatrix()
  Gdip_TranslateMatrix(pMatrix, -cX , -cY)
  Gdip_RotateMatrix(pMatrix, Angle, MatrixOrder)
  Gdip_TranslateMatrix(pMatrix, cX, cY, MatrixOrder)
  E := Gdip_TransformRegion(Region, pMatrix)
  Gdip_DeleteMatrix(pMatrix)
  Return E
}

Gdip_TransformRegion(Region, pMatrix) {
  
  return DllCall("gdiplus\GdipTransformRegion", "UPtr", Region, "UPtr", pMatrix)
}

Gdip_CreateRegion()
{
	DllCall("gdiplus\GdipCreateRegion", "UInt*", &Region:=0)
	return Region
}

;#####################################################################################
; BitmapLockBits
;#####################################################################################

Gdip_LockBits(pBitmap, x, y, w, h, &Stride, &Scan0, &BitmapData, LockMode := 3, PixelFormat := 0x26200a) {
   

   CreateRect(&_Rect, x, y, w, h)
   BitmapData:=buffer( 16+2*A_PtrSize, 0)
   _E := DllCall("Gdiplus\GdipBitmapLockBits", "UPtr", pBitmap, "UPtr", _Rect.ptr, "uint", LockMode, "int", PixelFormat, "UPtr", BitmapData.ptr)
   Stride := NumGet(BitmapData, 8, "Int")
   Scan0 := NumGet(BitmapData, 16, "UPtr")
   return _E
}

Gdip_UnlockBits(pBitmap, &BitmapData) {
   
   return DllCall("Gdiplus\GdipBitmapUnlockBits", "UPtr", pBitmap, "UPtr", BitmapData.ptr)
}

Gdip_SetLockBitPixel(ARGB, Scan0, x, y, Stride) {
   NumPut(ARGB, Scan0+0, (x*4)+(y*Stride), "UInt")
}

Gdip_GetLockBitPixel(Scan0, x, y, Stride) {
   return NumGet(Scan0+0, (x*4)+(y*Stride), "UInt")
}

;#####################################################################################

Gdip_PixelateBitmap(pBitmap, &pBitmapOut, BlockSize)
{
	static PixelateBitmap := ""

	if (!PixelateBitmap)
	{
		if A_PtrSize != 8 ; x86 machine code
		MCode_PixelateBitmap := "
		(LTrim Join
		558BEC83EC3C8B4514538B5D1C99F7FB56578BC88955EC894DD885C90F8E830200008B451099F7FB8365DC008365E000894DC88955F08945E833FF897DD4
		397DE80F8E160100008BCB0FAFCB894DCC33C08945F88945FC89451C8945143BD87E608B45088D50028BC82BCA8BF02BF2418945F48B45E02955F4894DC4
		8D0CB80FAFCB03CA895DD08BD1895DE40FB64416030145140FB60201451C8B45C40FB604100145FC8B45F40FB604020145F883C204FF4DE475D6034D18FF
		4DD075C98B4DCC8B451499F7F98945148B451C99F7F989451C8B45FC99F7F98945FC8B45F899F7F98945F885DB7E648B450C8D50028BC82BCA83C103894D
		C48BC82BCA41894DF48B4DD48945E48B45E02955E48D0C880FAFCB03CA895DD08BD18BF38A45148B7DC48804178A451C8B7DF488028A45FC8804178A45F8
		8B7DE488043A83C2044E75DA034D18FF4DD075CE8B4DCC8B7DD447897DD43B7DE80F8CF2FEFFFF837DF0000F842C01000033C08945F88945FC89451C8945
		148945E43BD87E65837DF0007E578B4DDC034DE48B75E80FAF4D180FAFF38B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945CC0F
		B6440E030145140FB60101451C0FB6440F010145FC8B45F40FB604010145F883C104FF4DCC75D8FF45E4395DE47C9B8B4DF00FAFCB85C9740B8B451499F7
		F9894514EB048365140033F63BCE740B8B451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB
		038975F88975E43BDE7E5A837DF0007E4C8B4DDC034DE48B75E80FAF4D180FAFF38B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955CC8A55
		1488540E038A551C88118A55FC88540F018A55F888140183C104FF4DCC75DFFF45E4395DE47CA68B45180145E0015DDCFF4DC80F8594FDFFFF8B451099F7
		FB8955F08945E885C00F8E450100008B45EC0FAFC38365DC008945D48B45E88945CC33C08945F88945FC89451C8945148945103945EC7E6085DB7E518B4D
		D88B45080FAFCB034D108D50020FAF4D18034DDC8BF08BF88945F403CA2BF22BFA2955F4895DC80FB6440E030145140FB60101451C0FB6440F010145FC8B
		45F40FB604080145F883C104FF4DC875D8FF45108B45103B45EC7CA08B4DD485C9740B8B451499F7F9894514EB048365140033F63BCE740B8B451C99F7F9
		89451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975103975EC7E5585DB7E468B4DD88B450C
		0FAFCB034D108D50020FAF4D18034DDC8BF08BF803CA2BF22BFA2BC2895DC88A551488540E038A551C88118A55FC88540F018A55F888140183C104FF4DC8
		75DFFF45108B45103B45EC7CAB8BC3C1E0020145DCFF4DCC0F85CEFEFFFF8B4DEC33C08945F88945FC89451C8945148945103BC87E6C3945F07E5C8B4DD8
		8B75E80FAFCB034D100FAFF30FAF4D188B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945C80FB6440E030145140FB60101451C0F
		B6440F010145FC8B45F40FB604010145F883C104FF4DC875D833C0FF45108B4DEC394D107C940FAF4DF03BC874068B451499F7F933F68945143BCE740B8B
		451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975083975EC7E63EB0233F639
		75F07E4F8B4DD88B75E80FAFCB034D080FAFF30FAF4D188B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955108A551488540E038A551C8811
		8A55FC88540F018A55F888140883C104FF4D1075DFFF45088B45083B45EC7C9F5F5E33C05BC9C21800
		)"
		else ; x64 machine code
		MCode_PixelateBitmap := "
		(LTrim Join
		4489442418488954241048894C24085355565741544155415641574883EC28418BC1448B8C24980000004C8BDA99488BD941F7F9448BD0448BFA8954240C
		448994248800000085C00F8E9D020000418BC04533E4458BF299448924244C8954241041F7F933C9898C24980000008BEA89542404448BE889442408EB05
		4C8B5C24784585ED0F8E1A010000458BF1418BFD48897C2418450FAFF14533D233F633ED4533E44533ED4585C97E5B4C63BC2490000000418D040A410FAF
		C148984C8D441802498BD9498BD04D8BD90FB642010FB64AFF4403E80FB60203E90FB64AFE4883C2044403E003F149FFCB75DE4D03C748FFCB75D0488B7C
		24188B8C24980000004C8B5C2478418BC59941F7FE448BE8418BC49941F7FE448BE08BC59941F7FE8BE88BC69941F7FE8BF04585C97E4048639C24900000
		004103CA4D8BC1410FAFC94863C94A8D541902488BCA498BC144886901448821408869FF408871FE4883C10448FFC875E84803D349FFC875DA8B8C249800
		0000488B5C24704C8B5C24784183C20448FFCF48897C24180F850AFFFFFF8B6C2404448B2424448B6C24084C8B74241085ED0F840A01000033FF33DB4533
		DB4533D24533C04585C97E53488B74247085ED7E42438D0C04418BC50FAF8C2490000000410FAFC18D04814863C8488D5431028BCD0FB642014403D00FB6
		024883C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC17CB28BCD410FAFC985C9740A418BC299F7F98BF0EB0233F685C9740B418BC3
		99F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585C97E4D4C8B74247885ED7E3841
		8D0C14418BC50FAF8C2490000000410FAFC18D04814863C84A8D4431028BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2413BD17CBD
		4C8B7424108B8C2498000000038C2490000000488B5C24704503E149FFCE44892424898C24980000004C897424100F859EFDFFFF448B7C240C448B842480
		000000418BC09941F7F98BE8448BEA89942498000000896C240C85C00F8E3B010000448BAC2488000000418BCF448BF5410FAFC9898C248000000033FF33
		ED33F64533DB4533D24533C04585FF7E524585C97E40418BC5410FAFC14103C00FAF84249000000003C74898488D541802498BD90FB642014403D00FB602
		4883C2044403D80FB642FB03F00FB642FA03E848FFCB75DE488B5C247041FFC0453BC77CAE85C9740B418BC299F7F9448BE0EB034533E485C9740A418BC3
		99F7F98BD8EB0233DB85C9740A8BC699F7F9448BD8EB034533DB85C9740A8BC599F7F9448BD0EB034533D24533C04585FF7E4E488B4C24784585C97E3541
		8BC5410FAFC14103C00FAF84249000000003C74898488D540802498BC144886201881A44885AFF448852FE4883C20448FFC875E941FFC0453BC77CBE8B8C
		2480000000488B5C2470418BC1C1E00203F849FFCE0F85ECFEFFFF448BAC24980000008B6C240C448BA4248800000033FF33DB4533DB4533D24533C04585
		FF7E5A488B7424704585ED7E48418BCC8BC5410FAFC94103C80FAF8C2490000000410FAFC18D04814863C8488D543102418BCD0FB642014403D00FB60248
		83C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC77CAB418BCF410FAFCD85C9740A418BC299F7F98BF0EB0233F685C9740B418BC399
		F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585FF7E4E4585ED7E42418BCC8BC541
		0FAFC903CA0FAF8C2490000000410FAFC18D04814863C8488B442478488D440102418BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2
		413BD77CB233C04883C428415F415E415D415C5F5E5D5BC3
		)"

		PixelateBitmap := Buffer(StrLen(MCode_PixelateBitmap)//2)
		nCount := StrLen(MCode_PixelateBitmap)//2
		loop nCount {
			NumPut("UChar", "0x" SubStr(MCode_PixelateBitmap, (2*A_Index)-1, 2), PixelateBitmap, A_Index-1)
		}
		DllCall("VirtualProtect", "UPtr", PixelateBitmap.Ptr, "UPtr", PixelateBitmap.Size, "UInt", 0x40, "UPtr*", 0)
	}

	Gdip_GetImageDimensions(pBitmap, &Width:="", &Height:="")

	if (Width != Gdip_GetImageWidth(pBitmapOut) || Height != Gdip_GetImageHeight(pBitmapOut))
		return -1
	if (BlockSize > Width || BlockSize > Height)
		return -2

	E1 := Gdip_LockBits(pBitmap, 0, 0, Width, Height, &Stride1:="", &Scan01:="", &BitmapData1:="")
	E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width, Height, &Stride2:="", &Scan02:="", &BitmapData2:="")
	if (E1 || E2)
		return -3

	; E := - unused exit code
	DllCall(PixelateBitmap.Ptr, "UPtr", Scan01, "UPtr", Scan02, "Int", Width, "Int", Height, "Int", Stride1, "Int", BlockSize)

	Gdip_UnlockBits(pBitmap, &BitmapData1), Gdip_UnlockBits(pBitmapOut, &BitmapData2)

	return 0
}

;#####################################################################################

Gdip_ToARGB(A, R, G, B) {
   return (A << 24) | (R << 16) | (G << 8) | B
}

Gdip_FromARGB(ARGB, &A, &R, &G, &B) {
   A := (0xff000000 & ARGB) >> 24
   R := (0x00ff0000 & ARGB) >> 16
   G := (0x0000ff00 & ARGB) >> 8
   B := 0x000000ff & ARGB
}

Gdip_AFromARGB(ARGB) {
   return (0xff000000 & ARGB) >> 24
}

Gdip_RFromARGB(ARGB) {
   return (0x00ff0000 & ARGB) >> 16
}

Gdip_GFromARGB(ARGB) {
   return (0x0000ff00 & ARGB) >> 8
}

Gdip_BFromARGB(ARGB) {
   return 0x000000ff & ARGB
}

;#####################################################################################

StrGetB(Address, Length:=-1, Encoding:=0)
{
	; Flexible parameter handling:
	if !IsInteger(Length) {
		Encoding := Length,  Length := -1
	}

	; Check for obvious errors.
	if (Address+0 < 1024) {
		return
	}

	; Ensure 'Encoding' contains a numeric identifier.
	if (Encoding = "UTF-16") {
		Encoding := 1200
	} else if (Encoding = "UTF-8") {
		Encoding := 65001
	} else if SubStr(Encoding,1,2)="CP" {
		Encoding := SubStr(Encoding,3)
	}

	if !Encoding { 	; "" or 0
		; No conversion necessary, but we might not want the whole string.
		if (Length == -1)
			Length := DllCall("lstrlen", "UInt", Address)
		VarSetStrCapacity(&myString, Length)
		DllCall("lstrcpyn", "str", myString, "UInt", Address, "Int", Length + 1)

	} else if (Encoding = 1200) { 	; UTF-16
		char_count := DllCall("WideCharToMultiByte", "UInt", 0, "UInt", 0x400, "UInt", Address, "Int", Length, "UInt", 0, "UInt", 0, "UInt", 0, "UInt", 0)
		VarSetStrCapacity(&myString, char_count)
		DllCall("WideCharToMultiByte", "UInt", 0, "UInt", 0x400, "UInt", Address, "Int", Length, "str", myString, "Int", char_count, "UInt", 0, "UInt", 0)

	} else if IsInteger(Encoding) {
		; Convert from target encoding to UTF-16 then to the active code page.
		char_count := DllCall("MultiByteToWideChar", "UInt", Encoding, "UInt", 0, "UInt", Address, "Int", Length, "UInt", 0, "Int", 0)
		VarSetStrCapacity(&myString, char_count * 2)
		char_count := DllCall("MultiByteToWideChar", "UInt", Encoding, "UInt", 0, "UInt", Address, "Int", Length, "UInt", myString.Ptr, "Int", char_count * 2)
		myString := StrGetB(myString.Ptr, char_count, 1200)
	}

	return myString
}

Gdip_Startup()
{
	if (!DllCall("LoadLibrary", "str", "gdiplus", "UPtr")) {
		throw Error("Could not load GDI+ library")
	}

	si := Buffer(A_PtrSize = 4 ? 20:32, 0) ; sizeof(GdiplusStartupInputEx) = 20, 32
	NumPut("uint", 0x2, si)
	NumPut("uint", 0x4, si, A_PtrSize = 4 ? 16:24)
	DllCall("gdiplus\GdiplusStartup", "UPtr*", &pToken:=0, "Ptr", si, "UPtr", 0)
	if (!pToken) {
		throw Error("Gdiplus failed to start. Please ensure you have gdiplus on your system")
	}

	return pToken
}

Gdip_Shutdown(pToken)
{
	DllCall("gdiplus\GdiplusShutdown", "UPtr", pToken)
	hModule := DllCall("GetModuleHandle", "str", "gdiplus", "UPtr")
	if (!hModule) {
		throw Error("GDI+ library was unloaded before shutdown")
	}
	if (!DllCall("FreeLibrary", "UPtr", hModule)) {
		throw Error("Could not free GDI+ library")
	}

	return 0
}

; ======================================================================================================================
; Multiple Display Monitors Functions -> msdn.microsoft.com/en-us/library/dd145072(v=vs.85).aspx
; by 'just me'
; https://autohotkey.com/boards/viewtopic.php?f=6&t=4606
; ======================================================================================================================

GetMonitorCount() {
   Monitors := MDMF_Enum()
   for k,v in Monitors
      count := A_Index
   return count
}

GetMonitorInfo(MonitorNum) {
   Monitors := MDMF_Enum()
   for k,v in Monitors
      if (v.Num = MonitorNum)
         return v
}

GetPrimaryMonitor() {
   Monitors := MDMF_Enum()
   for k,v in Monitors
      If (v.Primary)
         return v.Num
}

; ----------------------------------------------------------------------------------------------------------------------
; Name ..........: MDMF - Multiple Display Monitor Functions
; Description ...: Various functions for multiple display monitor environments
; Tested with ...: AHK 1.1.32.00 (A32/U32/U64) and 2.0-a108-a2fa0498 (U32/U64)
; Original Author: just me (https://www.autohotkey.com/boards/viewtopic.php?f=6&t=4606)
; Mod Authors ...: iPhilip, guest3456
; Changes .......: Modified to work with v2.0-a108 and changed 'Count' key to 'TotalCount' to avoid conflicts
; ................ Modified MDMF_Enum() so that it works under both AHK v1 and v2.
; ................ Modified MDMF_EnumProc() to provide Count and Primary keys to the Monitors array.
; ................ Modified MDMF_FromHWND() to allow flag values that determine the function's return value if the
; ................    window does not intersect any display monitor.
; ................ Modified MDMF_FromPoint() to allow the cursor position to be returned ByRef if not specified and
; ................    allow flag values that determine the function's return value if the point is not contained within
; ................    any display monitor.
; ................ Modified MDMF_FromRect() to allow flag values that determine the function's return value if the
; ................    rectangle does not intersect any display monitor.
;................. Modified MDMF_GetInfo() with minor changes.
; ----------------------------------------------------------------------------------------------------------------------
;
; ======================================================================================================================
; Multiple Display Monitors Functions -> msdn.microsoft.com/en-us/library/dd145072(v=vs.85).aspx =======================
; ======================================================================================================================
; Enumerates display monitors and returns an object containing the properties of all monitors or the specified monitor.
; ======================================================================================================================

MDMF_Enum(HMON := "") {
	static EnumProc := CallbackCreate(MDMF_EnumProc)
	static Monitors := Map()

	if (HMON = "") { 	; new enumeration
		Monitors := Map("TotalCount", 0)
		if !DllCall("User32.dll\EnumDisplayMonitors", "Ptr", 0, "Ptr", 0, "Ptr", EnumProc, "Ptr", ObjPtr(Monitors), "Int")
			return False
	}

	return (HMON = "") ? Monitors : Monitors.HasKey(HMON) ? Monitors[HMON] : False
}
; ======================================================================================================================
;  Callback function that is called by the MDMF_Enum function.
; ======================================================================================================================
MDMF_EnumProc(HMON, HDC, PRECT, ObjectAddr) {
	Monitors := ObjFromPtrAddRef(ObjectAddr)

	Monitors[HMON] := MDMF_GetInfo(HMON)
	Monitors["TotalCount"]++
	if (Monitors[HMON].Primary) {
		Monitors["Primary"] := HMON
	}

	return true
}
; ======================================================================================================================
; Retrieves the display monitor that has the largest area of intersection with a specified window.
; The following flag values determine the function's return value if the window does not intersect any display monitor:
;    MONITOR_DEFAULTTONULL    = 0 - Returns NULL.
;    MONITOR_DEFAULTTOPRIMARY = 1 - Returns a handle to the primary display monitor. 
;    MONITOR_DEFAULTTONEAREST = 2 - Returns a handle to the display monitor that is nearest to the window.
; ======================================================================================================================
MDMF_FromHWND(HWND, Flag := 0) {
   Return DllCall("User32.dll\MonitorFromWindow", "Ptr", HWND, "UInt", Flag, "Ptr")
}
; ======================================================================================================================
; Retrieves the display monitor that contains a specified point.
; If either X or Y is empty, the function will use the current cursor position for this value and return it ByRef.
; The following flag values determine the function's return value if the point is not contained within any
; display monitor:
;    MONITOR_DEFAULTTONULL    = 0 - Returns NULL.
;    MONITOR_DEFAULTTOPRIMARY = 1 - Returns a handle to the primary display monitor. 
;    MONITOR_DEFAULTTONEAREST = 2 - Returns a handle to the display monitor that is nearest to the point.
; ======================================================================================================================
MDMF_FromPoint(&X:="", &Y:="", Flag:=0) {
	if (X = "") || (Y = "") {
		PT := Buffer(8, 0)
		DllCall("User32.dll\GetCursorPos", "Ptr", PT.Ptr, "Int")

		if (X = "") {
			X := NumGet(PT, 0, "Int")
		}

		if (Y = "") {
			Y := NumGet(PT, 4, "Int")
		}
	}
	return DllCall("User32.dll\MonitorFromPoint", "Int64", (X & 0xFFFFFFFF) | (Y << 32), "UInt", Flag, "Ptr")
}

; ======================================================================================================================
; Retrieves the display monitor that has the largest area of intersection with a specified rectangle.
; Parameters are consistent with the common AHK definition of a rectangle, which is X, Y, W, H instead of
; Left, Top, Right, Bottom.
; The following flag values determine the function's return value if the rectangle does not intersect any
; display monitor:
;    MONITOR_DEFAULTTONULL    = 0 - Returns NULL.
;    MONITOR_DEFAULTTOPRIMARY = 1 - Returns a handle to the primary display monitor. 
;    MONITOR_DEFAULTTONEAREST = 2 - Returns a handle to the display monitor that is nearest to the rectangle.
; ======================================================================================================================
MDMF_FromRect(X, Y, W, H, Flag := 0) {
	RC := Buffer(16, 0)
	NumPut("Int", X, "Int", Y, "Int", X + W, "Int", Y + H, RC)
	return DllCall("User32.dll\MonitorFromRect", "Ptr", RC.Ptr, "UInt", Flag, "Ptr")
}
; ======================================================================================================================
; Retrieves information about a display monitor.
; ======================================================================================================================
MDMF_GetInfo(HMON) {
	MIEX := Buffer(40 + (32 << !!1))
	NumPut("UInt", MIEX.Size, MIEX)
	if DllCall("User32.dll\GetMonitorInfo", "Ptr", HMON, "Ptr", MIEX.Ptr, "Int") {
		return {Name:      (Name := StrGet(MIEX.Ptr + 40, 32))  ; CCHDEVICENAME = 32
		      , Num:       RegExReplace(Name, ".*(\d+)$", "$1")
		      , Left:      NumGet(MIEX, 4, "Int")    ; display rectangle
		      , Top:       NumGet(MIEX, 8, "Int")    ; "
		      , Right:     NumGet(MIEX, 12, "Int")   ; "
		      , Bottom:    NumGet(MIEX, 16, "Int")   ; "
		      , WALeft:    NumGet(MIEX, 20, "Int")   ; work area
		      , WATop:     NumGet(MIEX, 24, "Int")   ; "
		      , WARight:   NumGet(MIEX, 28, "Int")   ; "
		      , WABottom:  NumGet(MIEX, 32, "Int")   ; "
		      , Primary:   NumGet(MIEX, 36, "UInt")} ; contains a non-zero value for the primary monitor.
	}
	return False
}

;######################################################################################################################################
; The following functions are written by Just Me
; Taken from https://autohotkey.com/board/topic/85238-get-image-metadata-using-gdi-ahk-l/
; October 2013; minimal modifications by Marius Șucan in July 2019

Gdip_LoadImageFromFile(sFile, useICM:=0) {
; An Image object encapsulates a bitmap or a metafile and stores attributes that you can retrieve.
   pImage := 0
   function2call := (useICM=1) ? "GdipLoadImageFromFileICM" : "GdipLoadImageFromFile"
   R := DllCall("gdiplus\" function2call, "WStr", sFile, "UPtrP", pImage)
   ErrorLevel := R
   Return pImage
}

;######################################################################################################################################
; Gdip_GetPropertyCount() - Gets the number of properties (pieces of metadata) stored in this Image object.
; Parameters:
;     pImage      -  Pointer to the Image object.
; Return values:
;     On success  -  Number of properties.
;     On failure  -  0, ErrorLevel contains the GDIP status
;######################################################################################################################################

Gdip_GetPropertyCount(pImage) {
   PropCount := 0
   
   R := DllCall("gdiplus\GdipGetPropertyCount", "UPtr", pImage, "UIntP", PropCount)
   ErrorLevel := R
   Return PropCount
}

;######################################################################################################################################
; Gdip_GetPropertyIdList() - Gets an aray of the property identifiers used in the metadata of this Image object.
; Parameters:
;     pImage      -  Pointer to the Image object.
; Return values:
;     On success  -  Array containing the property identifiers as integer keys and the name retrieved from
;                    Gdip_GetPropertyTagName(PropID) as values.
;                    The total number of properties is stored in Array.Count.
;     On failure  -  False, ErrorLevel contains the GDIP status
;######################################################################################################################################

Gdip_GetPropertyIdList(pImage) {
   PropNum := Gdip_GetPropertyCount(pImage)
   
   If (ErrorLevel) || (PropNum = 0)
      Return False
   PropIDList:=buffer( 4 * PropNum, 0)
   R := DllCall("gdiplus\GdipGetPropertyIdList", "UPtr", pImage, "UInt", PropNum, "Ptr", &PropIDList)
   If (R) {
      ErrorLevel := R
      Return False
   }

   PropArray := {Count: PropNum}
   Loop (PropNum)
   {
      PropID := NumGet(PropIDList, (A_Index - 1) << 2, "UInt")
      PropArray[PropID] := Gdip_GetPropertyTagName(PropID)
   }
   Return PropArray
}

;######################################################################################################################################
; Gdip_GetPropertyItem() - Gets a specified property item (piece of metadata) from this Image object.
; Parameters:
;     pImage      -  Pointer to the Image object.
;     PropID      -  Integer that identifies the property item to be retrieved (see Gdip_GetPropertyTagName()).
; Return values:
;     On success  -  Property item object containing three keys:
;                    Length   -  Length of the value in bytes.
;                    Type     -  Type of the value (see Gdip_GetPropertyTagType()).
;                    Value    -  The value itself.
;     On failure  -  False, ErrorLevel contains the GDIP status
;######################################################################################################################################

Gdip_GetPropertyItem(pImage, PropID) {
   PropItem := {Length: 0, Type: 0, Value: ""}
   ItemSize := 0
   R := DllCall("gdiplus\GdipGetPropertyItemSize", "Ptr", pImage, "UInt", PropID, "UIntP", ItemSize)
   If (R) {
      ErrorLevel := R
      Return False
   }

   
   Item:=buffer( ItemSize, 0)
   R := DllCall("gdiplus\GdipGetPropertyItem", "UPtr", pImage, "UInt", PropID, "UInt", ItemSize, "Ptr", &Item)
   If (R) {
      ErrorLevel := R
      Return False
   }
   PropLen := NumGet(Item, 4, "UInt")
   PropType := NumGet(Item, 8, "Short")
   PropAddr := NumGet(Item, 8 + A_PtrSize, "UPtr")
   PropItem.Length := PropLen
   PropItem.Type := PropType
   If (PropLen > 0)
   {
      PropVal := ""
      Gdip_GetPropertyItemValue(PropVal, PropLen, PropType, PropAddr)
      If (PropType = 1) || (PropType = 7) {
         PropItem.SetCapacity("Value", PropLen)
         ValAddr := PropItem.GetAddress("Value")
         DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", ValAddr, "Ptr", &PropVal, "Ptr", PropLen)
      } Else {
         PropItem.Value := PropVal
      }
   }
   ErrorLevel := 0
   Return PropItem
}

;######################################################################################################################################
; Gdip_GetAllPropertyItems() - Gets all the property items (metadata) stored in this Image object.
; Parameters:
;     pImage      -  Pointer to the Image object.
; Return values:
;     On success  -  Properties object containing one integer key for each property ID. Each value is an object
;                    containing three keys:
;                    Length   -  Length of the value in bytes.
;                    Type     -  Type of the value (see Gdip_GetPropertyTagType()).
;                    Value    -  The value itself.
;                    The total number of properties is stored in Properties.Count.
;     On failure  -  False, ErrorLevel contains the GDIP status
;######################################################################################################################################

Gdip_GetAllPropertyItems(pImage) {
   BufSize := PropNum := ErrorLevel := 0
   R := DllCall("gdiplus\GdipGetPropertySize", "Ptr", pImage, "UIntP", BufSize, "UIntP", PropNum)
   If (R) || (PropNum = 0) {
      ErrorLevel := R ? R : 19 ; 19 = PropertyNotFound
      Return False
   }
   Buffer:=buffer( BufSize, 0)
   
   R := DllCall("gdiplus\GdipGetAllPropertyItems", "UPtr", pImage, "UInt", BufSize, "UInt", PropNum, "Ptr", &Buffer)
   If (R) {
      ErrorLevel := R
      Return False
   }
   PropsObj := {Count: PropNum}
   PropSize := 8 + (2 * A_PtrSize)

   Loop (PropNum)
   {
      OffSet := PropSize * (A_Index - 1)
      PropID := NumGet(Buffer, OffSet, "UInt")
      PropLen := NumGet(Buffer, OffSet + 4, "UInt")
      PropType := NumGet(Buffer, OffSet + 8, "Short")
      PropAddr := NumGet(Buffer, OffSet + 8 + A_PtrSize, "UPtr")
      PropVal := ""
      PropsObj[PropID] := {}
      PropsObj[PropID, "Length"] := PropLen
      PropsObj[PropID, "Type"] := PropType
      PropsObj[PropID, "Value"] := PropVal
      If (PropLen > 0)
      {
         Gdip_GetPropertyItemValue(PropVal, PropLen, PropType, PropAddr)
         If (PropType = 1) || (PropType = 7)
         {
            PropsObj[PropID].SetCapacity("Value", PropLen)
            ValAddr := PropsObj[PropID].GetAddress("Value")
            DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", ValAddr, "Ptr", PropAddr, "Ptr", PropLen)
         } Else {
            PropsObj[PropID].Value := PropVal
         }
      }
   }
   ErrorLevel := 0
   Return PropsObj
}

;######################################################################################################################################
; Gdip_GetPropertyTagName() - Gets the name for the integer identifier of this property as defined in "Gdiplusimaging.h".
; Parameters:
;     PropID      -  Integer that identifies the property item to be retrieved.
; Return values:
;     On success  -  Corresponding name.
;     On failure  -  "Unknown"
;######################################################################################################################################

Gdip_GetPropertyTagName(PropID) {
; All tags are taken from "Gdiplusimaging.h", probably there will be more.
; For most of them you'll find a description on http://msdn.microsoft.com/en-us/library/ms534418(VS.85).aspx
;
; modified by Marius Șucan in July/August 2019:
; I transformed the function to not yield errors on AHK v2

   Static PropTagsA := {0x0001:"GPS LatitudeRef",0x0002:"GPS Latitude",0x0003:"GPS LongitudeRef",0x0004:"GPS Longitude",0x0005:"GPS AltitudeRef",0x0006:"GPS Altitude",0x0007:"GPS Time",0x0008:"GPS Satellites",0x0009:"GPS Status",0x000A:"GPS MeasureMode",0x001D:"GPS Date",0x001E:"GPS Differential",0x00FE:"NewSubfileType",0x00FF:"SubfileType",0x0102:"Bits Per Sample",0x0103:"Compression",0x0106:"Photometric Interpolation",0x0107:"ThreshHolding",0x010A:"Fill Order",0x010D:"Document Name",0x010E:"Image Description",0x010F:"Equipment Make",0x0110:"Equipment Model",0x0112:"Orientation",0x0115:"Samples Per Pixel",0x0118:"Min Sample Value",0x0119:"Max Sample Value",0x011D:"Page Name",0x0122:"GrayResponseUnit",0x0123:"GrayResponseCurve",0x0128:"Resolution Unit",0x012D:"Transfer Function",0x0131:"Software Used",0x0132:"Internal Date Time",0x013B:"Artist"
   ,0x013C:"Host Computer",0x013D:"Predictor",0x013E:"White Point",0x013F:"Primary Chromaticities",0x0140:"Color Map",0x014C:"Ink Set",0x014D:"Ink Names",0x014E:"Number Of Inks",0x0150:"Dot Range",0x0151:"Target Printer",0x0152:"Extra Samples",0x0153:"Sample Format",0x0156:"Transfer Range",0x0200:"JPEGProc",0x0205:"JPEGLosslessPredictors",0x0301:"Gamma",0x0302:"ICC Profile Descriptor",0x0303:"SRGB Rendering Intent",0x0320:"Image Title",0x5010:"JPEG Quality",0x5011:"Grid Size",0x501A:"Color Transfer Function",0x5100:"Frame Delay",0x5101:"Loop Count",0x5110:"Pixel Unit",0x5111:"Pixel Per Unit X",0x5112:"Pixel Per Unit Y",0x8298:"Copyright",0x829A:"EXIF Exposure Time",0x829D:"EXIF F Number",0x8773:"ICC Profile",0x8822:"EXIF ExposureProg",0x8824:"EXIF SpectralSense",0x8827:"EXIF ISO Speed",0x9003:"EXIF Date Original",0x9004:"EXIF Date Digitized"
   ,0x9102:"EXIF CompBPP",0x9201:"EXIF Shutter Speed",0x9202:"EXIF Aperture",0x9203:"EXIF Brightness",0x9204:"EXIF Exposure Bias",0x9205:"EXIF Max. Aperture",0x9206:"EXIF Subject Dist",0x9207:"EXIF Metering Mode",0x9208:"EXIF Light Source",0x9209:"EXIF Flash",0x920A:"EXIF Focal Length",0x9214:"EXIF Subject Area",0x927C:"EXIF Maker Note",0x9286:"EXIF Comments",0xA001:"EXIF Color Space",0xA002:"EXIF PixXDim",0xA003:"EXIF PixYDim",0xA004:"EXIF Related WAV",0xA005:"EXIF Interop",0xA20B:"EXIF Flash Energy",0xA20E:"EXIF Focal X Res",0xA20F:"EXIF Focal Y Res",0xA210:"EXIF FocalResUnit",0xA214:"EXIF Subject Loc",0xA215:"EXIF Exposure Index",0xA217:"EXIF Sensing Method",0xA300:"EXIF File Source",0xA301:"EXIF Scene Type",0xA401:"EXIF Custom Rendered",0xA402:"EXIF Exposure Mode",0xA403:"EXIF White Balance",0xA404:"EXIF Digital Zoom Ratio"
   ,0xA405:"EXIF Focal Length In 35mm Film",0xA406:"EXIF Scene Capture Type",0xA407:"EXIF Gain Control",0xA408:"EXIF Contrast",0xA409:"EXIF Saturation",0xA40A:"EXIF Sharpness",0xA40B:"EXIF Device Setting Description",0xA40C:"EXIF Subject Distance Range",0xA420:"EXIF Unique Image ID"}

   Static PropTagsB := {0x0000:"GpsVer",0x000B:"GpsGpsDop",0x000C:"GpsSpeedRef",0x000D:"GpsSpeed",0x000E:"GpsTrackRef",0x000F:"GpsTrack",0x0010:"GpsImgDirRef",0x0011:"GpsImgDir",0x0012:"GpsMapDatum",0x0013:"GpsDestLatRef",0x0014:"GpsDestLat",0x0015:"GpsDestLongRef",0x0016:"GpsDestLong",0x0017:"GpsDestBearRef",0x0018:"GpsDestBear",0x0019:"GpsDestDistRef",0x001A:"GpsDestDist",0x001B:"GpsProcessingMethod",0x001C:"GpsAreaInformation",0x0100:"Original Image Width",0x0101:"Original Image Height",0x0108:"CellWidth",0x0109:"CellHeight",0x0111:"Strip Offsets",0x0116:"RowsPerStrip",0x0117:"StripBytesCount",0x011A:"XResolution",0x011B:"YResolution",0x011C:"Planar Config",0x011E:"XPosition",0x011F:"YPosition",0x0120:"FreeOffset",0x0121:"FreeByteCounts",0x0124:"T4Option",0x0125:"T6Option",0x0129:"PageNumber",0x0141:"Halftone Hints",0x0142:"TileWidth",0x0143:"TileLength",0x0144:"TileOffset"
   ,0x0145:"TileByteCounts",0x0154:"SMin Sample Value",0x0155:"SMax Sample Value",0x0201:"JPEGInterFormat",0x0202:"JPEGInterLength",0x0203:"JPEGRestartInterval",0x0206:"JPEGPointTransforms",0x0207:"JPEGQTables",0x0208:"JPEGDCTables",0x0209:"JPEGACTables",0x0211:"YCbCrCoefficients",0x0212:"YCbCrSubsampling",0x0213:"YCbCrPositioning",0x0214:"REFBlackWhite",0x5001:"ResolutionXUnit",0x5002:"ResolutionYUnit",0x5003:"ResolutionXLengthUnit",0x5004:"ResolutionYLengthUnit",0x5005:"PrintFlags",0x5006:"PrintFlagsVersion",0x5007:"PrintFlagsCrop",0x5008:"PrintFlagsBleedWidth",0x5009:"PrintFlagsBleedWidthScale",0x500A:"HalftoneLPI",0x500B:"HalftoneLPIUnit",0x500C:"HalftoneDegree",0x500D:"HalftoneShape",0x500E:"HalftoneMisc",0x500F:"HalftoneScreen",0x5012:"ThumbnailFormat",0x5013:"ThumbnailWidth",0x5014:"ThumbnailHeight",0x5015:"ThumbnailColorDepth"
   ,0x5016:"ThumbnailPlanes",0x5017:"ThumbnailRawBytes",0x5018:"ThumbnailSize",0x5019:"ThumbnailCompressedSize",0x501B:"ThumbnailData",0x5020:"ThumbnailImageWidth",0x5021:"ThumbnailImageHeight",0x5022:"ThumbnailBitsPerSample",0x5023:"ThumbnailCompression",0x5024:"ThumbnailPhotometricInterp",0x5025:"ThumbnailImageDescription",0x5026:"ThumbnailEquipMake",0x5027:"ThumbnailEquipModel",0x5028:"ThumbnailStripOffsets",0x5029:"ThumbnailOrientation",0x502A:"ThumbnailSamplesPerPixel",0x502B:"ThumbnailRowsPerStrip",0x502C:"ThumbnailStripBytesCount",0x502D:"ThumbnailResolutionX",0x502E:"ThumbnailResolutionY",0x502F:"ThumbnailPlanarConfig",0x5030:"ThumbnailResolutionUnit",0x5031:"ThumbnailTransferFunction",0x5032:"ThumbnailSoftwareUsed",0x5033:"ThumbnailDateTime",0x5034:"ThumbnailArtist",0x5035:"ThumbnailWhitePoint"
   ,0x5036:"ThumbnailPrimaryChromaticities",0x5037:"ThumbnailYCbCrCoefficients",0x5038:"ThumbnailYCbCrSubsampling",0x5039:"ThumbnailYCbCrPositioning",0x503A:"ThumbnailRefBlackWhite",0x503B:"ThumbnailCopyRight",0x5090:"LuminanceTable",0x5091:"ChrominanceTable",0x5102:"Global Palette",0x5103:"Index Background",0x5104:"Index Transparent",0x5113:"Palette Histogram",0x8769:"ExifIFD",0x8825:"GpsIFD",0x8828:"ExifOECF",0x9000:"ExifVer",0x9101:"EXIF CompConfig",0x9290:"EXIF DTSubsec",0x9291:"EXIF DTOrigSS",0x9292:"EXIF DTDigSS",0xA000:"EXIF FPXVer",0xA20C:"EXIF Spatial FR",0xA302:"EXIF CfaPattern"}

   r := PropTagsA.HasKey(PropID) ? PropTagsA[PropID] : "Unknown"
   If (r="Unknown")
      r := PropTagsB.HasKey(PropID) ? PropTagsB[PropID] : "Unknown"
   Return r
}

;######################################################################################################################################
; Gdip_GetPropertyTagType() - Gets the name for he type of this property's value as defined in "Gdiplusimaging.h".
; Parameters:
;     PropType    -  Integer that identifies the type of the property item to be retrieved.
; Return values:
;     On success  -  Corresponding type.
;     On failure  -  "Unknown"
;######################################################################################################################################

Gdip_GetPropertyTagType(PropType) {
   Static PropTypes := {1: "Byte", 2: "ASCII", 3: "Short", 4: "Long", 5: "Rational", 7: "Undefined", 9: "SLong", 10: "SRational"}
   Return PropTypes.HasKey(PropType) ? PropTypes[PropType] : "Unknown"
}

Gdip_GetPropertyItemValue(&PropVal, PropLen, PropType, PropAddr) {
; Gdip_GetPropertyItemValue() - Reserved for internal use
   PropVal := ""
   If (PropType = 2)
   {
      PropVal := StrGet(PropAddr, PropLen, "CP0")
      Return True
   }

   If (PropType = 3)
   {
      PropyLen := PropLen // 2
      Loop (PropyLen)
         PropVal .= (A_Index > 1 ? " " : "") . NumGet(PropAddr + 0, (A_Index - 1) << 1, "Short")
      Return True
   }

   If (PropType = 4) || (PropType = 9)
   {
      NumType := PropType = 4 ? "UInt" : "Int"
      PropyLen := PropLen // 4
      Loop (PropyLen)
         PropVal .= (A_Index > 1 ? " " : "") . NumGet(PropAddr + 0, (A_Index - 1) << 2, NumType)
      Return True
   }

   If (PropType = 5) || (PropType = 10)
   {
      NumType := PropType = 5 ? "UInt" : "Int"
      PropyLen := PropLen // 8
      Loop (PropyLen)
         PropVal .= (A_Index > 1 ? " " : "") . NumGet(PropAddr + 0, (A_Index - 1) << 2, NumType)
                 .  "/" . NumGet(PropAddr + 4, (A_Index - 1) << 2, NumType)
      Return True
   }

   If (PropType = 1) || (PropType = 7)
   {
      PropVal:=buffer( PropLen, 0)
      DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", &PropVal, "Ptr", PropAddr, "Ptr", PropLen)
      Return True
   }
   Return False
}

;#####################################################################################
; RotateAtCenter() and related Functions by RazorHalo
; from https://www.autohotkey.com/boards/viewtopic.php?f=6&t=6517&start=260
; in April 2019.
;#####################################################################################
; The Matrix order has to be "Append" for the transformations to be applied 
; in the correct order - instead of the default "Prepend"

Gdip_RotatePathAtCenter(pPath, Angle, MatrixOrder:=1, withinBounds:=0, withinBkeepRatio:=1) {
; modified by Marius Șucan - added withinBounds option

  ; Gets the bounding rectangle of the GraphicsPath
  ; returns array x, y, w, h
  Rect := Gdip_GetPathWorldBounds(pPath)

  ; Calculate center of bounding rectangle which will be the center of the graphics path
  cX := Rect.x + (Rect.w / 2)
  cY := Rect.y + (Rect.h / 2)
  
  ; Create a Matrix for the transformations
  pMatrix := Gdip_CreateMatrix()
  
  ; Move the GraphicsPath center to the origin (0, 0) of the graphics object
  Gdip_TranslateMatrix(pMatrix, -cX , -cY)

  ; Rotate matrix on graphics object origin
  Gdip_RotateMatrix(pMatrix, Angle, MatrixOrder)
  
  ; Move the GraphicsPath origin point back to its original position
  Gdip_TranslateMatrix(pMatrix, cX, cY, MatrixOrder)

  ; Apply the transformations
  E := Gdip_TransformPath(pPath, pMatrix)

  ; Delete Matrix
  Gdip_DeleteMatrix(pMatrix)

  If (withinBounds=1 && !E && Angle!=0)
  {
     nRect := Gdip_GetPathWorldBounds(pPath)
     ncX := nRect.x + (nRect.w / 2)
     ncY := nRect.y + (nRect.h / 2)
     pMatrix := Gdip_CreateMatrix()
     Gdip_TranslateMatrix(pMatrix, -ncX , -ncY)
     sX := Rect.w / nRect.w
     sY := Rect.h / nRect.h
     If (withinBkeepRatio=1)
     {
        sX := min(sX, sY)
        sY := min(sX, sY)
     }
     Gdip_ScaleMatrix(pMatrix, sX, sY, MatrixOrder)
     Gdip_TranslateMatrix(pMatrix, ncX, ncY, MatrixOrder)
     If (sX!=0 && sY!=0)
        E := Gdip_TransformPath(pPath, pMatrix)
     Gdip_DeleteMatrix(pMatrix)
  }
  Return E
}

;#####################################################################################
; Matrix transformations functions by RazorHalo
;
; NOTE: Be aware of the order that transformations are applied.  You may need
; to pass MatrixOrder as 1 for "Append"
; the (default is 0 for "Prepend") to get the correct results.

Gdip_ResetMatrix(hMatrix) {
   
   return DllCall("gdiplus\GdipResetMatrix", "UPtr", hMatrix)
}

Gdip_RotateMatrix(hMatrix, Angle, MatrixOrder:=0) {
   
   return DllCall("gdiplus\GdipRotateMatrix", "UPtr", hMatrix, "float", Angle, "Int", MatrixOrder)
}


Gdip_GetPathWorldBounds(pPath, hMatrix:=0, pPen:=0) {
; hMatrix to use for calculating the boundaries
; pPen to use for calculating the boundaries
; Both will not affect the actual GraphicsPath.

  
  rData := {}

  RectF:=buffer( 16, 0)
  status := DllCall("gdiplus\GdipGetPathWorldBounds", "UPtr", pPath, "UPtr", RectF.ptr, "UPtr", hMatrix, "UPtr", pPen)

  If (!status) {
        rData.x := NumGet(RectF, 0, "float")
      , rData.y := NumGet(RectF, 4, "float")
      , rData.w := NumGet(RectF, 8, "float")
      , rData.h := NumGet(RectF, 12, "float")
  } Else {
    Return status
  }
  
  return rData
}

Gdip_ScaleMatrix(hMatrix, ScaleX, ScaleY, MatrixOrder:=0) {
   
   return DllCall("gdiplus\GdipScaleMatrix", "UPtr", hMatrix, "float", ScaleX, "float", ScaleY, "Int", MatrixOrder)
}

Gdip_TranslateMatrix(hMatrix, offsetX, offsetY, MatrixOrder:=0) {
   
   return DllCall("gdiplus\GdipTranslateMatrix", "UPtr", hMatrix, "float", offsetX, "float", offsetY, "Int", MatrixOrder)
}

Gdip_TransformPath(pPath, hMatrix) {
  
  return DllCall("gdiplus\GdipTransformPath", "UPtr", pPath, "UPtr", hMatrix)
}

Gdip_SetMatrixElements(hMatrix, m11, m12, m21, m22, x, y) {
  
  return DllCall("gdiplus\GdipSetMatrixElements", "UPtr", hMatrix, "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y)
}

Gdip_GetMatrixLastStatus(pMatrix) {
  
  return DllCall("gdiplus\GdipGetLastStatus", "UPtr", pMatrix)
}

;#####################################################################################
; GraphicsPath functions written by Learning one
; found on https://autohotkey.com/board/topic/29449-gdi-standard-library-145-by-tic/page-75
; Updated on 14/08/2019 by Marius Șucan
;#####################################################################################
;
; Function:    Gdip_AddPathBeziers
; Description: Adds a sequence of connected Bézier splines to the current figure of this path.
; A Bezier spline does not pass through its control points. The control points act as magnets, pulling the curve
; in certain directions to influence the way the spline bends.
;
; pPath:  Pointer to the GraphicsPath.
; Points: The coordinates of all the points passed as x1,y1|x2,y2|x3,y3...
;
; Return: Status enumeration. 0 = success.
;
; Notes: The first spline is constructed from the first point through the fourth point in the array and uses the second and third points as control points. Each subsequent spline in the sequence needs exactly three more points: the ending point of the previous spline is used as the starting point, the next two points in the sequence are control points, and the third point is the ending point.

Gdip_AddPathBeziers(pPath, Points) {
  
  iCount := CreatePointsF(PointsF, Points)
  return DllCall("gdiplus\GdipAddPathBeziers", "UPtr", pPath, "UPtr", &PointsF, "int", iCount)
}

Gdip_AddPathBezier(pPath, x1, y1, x2, y2, x3, y3, x4, y4) {
  ; Adds a Bézier spline to the current figure of this path
  
  return DllCall("gdiplus\GdipAddPathBezier", "UPtr", pPath
         , "float", x1, "float", y1, "float", x2, "float", y2
         , "float", x3, "float", y3, "float", x4, "float", y4)
}

;#####################################################################################
; Function: Gdip_AddPathLines
; Description: Adds a sequence of connected lines to the current figure of this path.
;
; pPath: Pointer to the GraphicsPath
; Points: the coordinates of all the points passed as x1,y1|x2,y2|x3,y3.....
;
; Return: status enumeration. 0 = success.

Gdip_AddPathLines(pPath, Points) {
  
  iCount := CreatePointsF(PointsF, Points)
  return DllCall("gdiplus\GdipAddPathLine2", "UPtr", pPath, "UPtr", &PointsF, "int", iCount)
}

Gdip_AddPathLine(pPath, x1, y1, x2, y2) {
  
  return DllCall("gdiplus\GdipAddPathLine", "UPtr", pPath, "float", x1, "float", y1, "float", x2, "float", y2)
}

Gdip_AddPathArc(pPath, x, y, w, h, StartAngle, SweepAngle) {
  
  return DllCall("gdiplus\GdipAddPathArc", "UPtr", pPath, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

Gdip_AddPathPie(pPath, x, y, w, h, StartAngle, SweepAngle) {
  
  return DllCall("gdiplus\GdipAddPathPie", "UPtr", pPath, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}

Gdip_StartPathFigure(pPath) {
; Starts a new figure without closing the current figure.
; Subsequent points added to this path are added to the new figure.
  
  return DllCall("gdiplus\GdipStartPathFigure", "UPtr", pPath)
}

Gdip_ClosePathFigure(pPath) {
; Closes the current figure of this path.
  
  return DllCall("gdiplus\GdipClosePathFigure", "UPtr", pPath)
}

Gdip_ClosePathFigures(pPath) {
; Closes the current figure of this path.
  
  return DllCall("gdiplus\GdipClosePathFigures", "UPtr", pPath)
}

;#####################################################################################
; Function: Gdip_DrawPath
; Description: Draws a sequence of lines and curves defined by a GraphicsPath object
;
; pGraphics: Pointer to the Graphics of a bitmap
; pPen: Pointer to a pen object
; pPath: Pointer to a Path object
;
; Return: status enumeration. 0 = success.

Gdip_DrawPath(pGraphics, pPen, pPath) {
  
  return DllCall("gdiplus\GdipDrawPath", "UPtr", pGraphics, "UPtr", pPen, "UPtr", pPath)
}

Gdip_ClonePath(pPath) {
  
  PtrA:= "UPtr*"
  pPathClone := 0
  DllCall("gdiplus\GdipClonePath", "UPtr", pPath, PtrA, pPathClone)
  return pPathClone
}

;######################################################################################################################################
; The following PathGradient brush functions were written by 'Just Me' in March 2012
; source: https://autohotkey.com/board/topic/29449-gdi-standard-library-145-by-tic/page-65
;######################################################################################################################################

Gdip_PathGradientCreateFromPath(pPath) {
   ; Creates and returns a path gradient brush.
   ; pPath              path object returned from Gdip_CreatePath()
   pBrush := 0
   DllCall("gdiplus\GdipCreatePathGradientFromPath", "Ptr", pPath, "PtrP", pBrush)
   Return pBrush
}

Gdip_PathGradientSetCenterPoint(pBrush, X, Y) {
   ; Sets the center point of this path gradient brush.
   ; pBrush             Brush object returned from Gdip_PathGradientCreateFromPath().
   ; X, Y               X, y coordinates in pixels
   POINTF:=buffer( 8)
   NumPut(X, POINTF, 0, "Float")
   NumPut(Y, POINTF, 4, "Float")
   Return DllCall("gdiplus\GdipSetPathGradientCenterPoint", "Ptr", pBrush, "Ptr", &POINTF)
}

Gdip_PathGradientSetCenterColor(pBrush, CenterColor) {
   ; Sets the center color of this path gradient brush.
   ; pBrush             Brush object returned from Gdip_PathGradientCreateFromPath().
   ; CenterColor        ARGB color value: A(lpha)R(ed)G(reen)B(lue).
   Return DllCall("gdiplus\GdipSetPathGradientCenterColor", "Ptr", pBrush, "UInt", CenterColor)   
}

Gdip_PathGradientSetSurroundColors(pBrush, SurroundColors) {
   ; Sets the surround colors of this path gradient brush. 
   ; pBrush             Brush object returned from Gdip_PathGradientCreateFromPath().
   ; SurroundColours    One or more ARGB color values seperated by pipe (|)).
   ; updated by Marius Șucan 

   Colors := StrSplit(SurroundColors, "|")
   tColors := Colors.Length
   ColorArray:=buffer( 4 * tColors, 0)

   Loop (tColors)
      NumPut(Colors[A_Index], ColorArray, 4 * (A_Index - 1), "UInt")

   Return DllCall("gdiplus\GdipSetPathGradientSurroundColorsWithCount", "Ptr", pBrush, "Ptr", &ColorArray
                , "IntP", tColors)
}

Gdip_PathGradientSetSigmaBlend(pBrush, Focus, Scale:=1) {
   ; Sets the blend shape of this path gradient brush to bell shape.
   ; pBrush             Brush object returned from Gdip_PathGradientCreateFromPath().
   ; Focus              Number that specifies where the center color will be at its highest intensity.
   ;                    Values: 1.0 (center) - 0.0 (border)
   ; Scale              Number that specifies the maximum intensity of center color that gets blended with 
   ;                    the boundary color.
   ;                    Values:  1.0 (100 %) - 0.0 (0 %)
   Return DllCall("gdiplus\GdipSetPathGradientSigmaBlend", "Ptr", pBrush, "Float", Focus, "Float", Scale)
}

Gdip_PathGradientSetLinearBlend(pBrush, Focus, Scale:=1) {
   ; Sets the blend shape of this path gradient brush to triangular shape.
   ; pBrush             Brush object returned from Gdip_PathGradientCreateFromPath()
   ; Focus              Number that specifies where the center color will be at its highest intensity.
   ;                    Values: 1.0 (center) - 0.0 (border)
   ; Scale              Number that specifies the maximum intensity of center color that gets blended with 
   ;                    the boundary color.
   ;                    Values:  1.0 (100 %) - 0.0 (0 %)
   Return DllCall("gdiplus\GdipSetPathGradientLinearBlend", "Ptr", pBrush, "Float", Focus, "Float", Scale)
}

Gdip_PathGradientSetFocusScales(pBrush, xScale, yScale) {
   ; Sets the focus scales of this path gradient brush.
   ; pBrush             Brush object returned from Gdip_PathGradientCreateFromPath().
   ; xScale             Number that specifies the x focus scale.
   ;                    Values: 0.0 (0 %) - 1.0 (100 %)
   ; yScale             Number that specifies the y focus scale.
   ;                    Values: 0.0 (0 %) - 1.0 (100 %)
   Return DllCall("gdiplus\GdipSetPathGradientFocusScales", "Ptr", pBrush, "Float", xScale, "Float", yScale)
}

Gdip_AddPathGradient(pGraphics, x, y, w, h, cX, cY, cClr, sClr, BlendFocus, ScaleX, ScaleY, Shape, Angle:=0) {
; Parameters:
; X, Y   - coordinates where to add the gradient path object 
; W, H   - the width and height of the path gradient object 
; cX, cY - the coordinates of the Center Point of the gradient within the wdith and height object boundaries
; cClr   - the center color in 0xARGB
; sClr   - the surrounding color in 0xARGB
; BlendFocus - 0.0 to 1.0; where the center color reaches the highest intensity
; Shape   - 1 = rectangle ; 0 = ellipse
; Angle   - Rotate the pPathGradientBrush at given angle
;
; function based on the example provided by Just Me for the path gradient functions
; adaptations/modifications by Marius Șucan

   pPath := Gdip_CreatePath()
   If (Shape=1)
      Gdip_AddPathRectangle(pPath, x, y, W, H)
   Else
      Gdip_AddPathEllipse(pPath, x, y, W, H)
   zBrush := Gdip_PathGradientCreateFromPath(pPath)
   If (Angle!=0)
      Gdip_RotatePathGradientAtCenter(zBrush, Angle)
   Gdip_PathGradientSetCenterPoint(zBrush, cX, cY)
   Gdip_PathGradientSetCenterColor(zBrush, cClr)
   Gdip_PathGradientSetSurroundColors(zBrush, sClr)
   Gdip_PathGradientSetSigmaBlend(zBrush, BlendFocus)
   Gdip_PathGradientSetLinearBlend(zBrush, BlendFocus)
   Gdip_PathGradientSetFocusScales(zBrush, ScaleX, ScaleY)
   E := Gdip_FillPath(pGraphics, zBrush, pPath)
   Gdip_DeleteBrush(zBrush)
   Gdip_DeletePath(pPath)
   Return E
}

;######################################################################################################################################
; The following PathGradient brush functions were written by Marius Șucan
;######################################################################################################################################

Gdip_CreatePathGradient(Points, WrapMode) {
; Creates a PathGradientBrush object based on an array of points and initializes the wrap mode of the brush
;
; Points array format:
; Points := "x1,y1|x2,y2|x3,y3|x4,y4" [... and so on]
;
; WrapMode options: specifies how an area is tiled when it is painted with a brush:
; 0 - Tile - Tiling without flipping
; 1 - TileFlipX - Tiles are flipped horizontally as you move from one tile to the next in a row
; 2 - TileFlipY - Tiles are flipped vertically as you move from one tile to the next in a column
; 3 - TileFlipXY - Tiles are flipped horizontally as you move along a row and flipped vertically as you move along a column
; 4 - Clamp - No tiling

    
    iCount := CreatePointsF(PointsF, Points)
    pPathGradientBrush := 0
    DllCall("gdiplus\GdipCreatePathGradient", "UPtr", &PointsF, "int", iCount, "int", WrapMode, "int*", pPathGradientBrush)
    Return pPathGradientBrush
}

Gdip_PathGradientGetGammaCorrection(pPathGradientBrush) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetPathGradientGammaCorrection", "UPtr", pPathGradientBrush, "int*", result)
   If E
      return -1
   Return result
}

Gdip_PathGradientGetPointCount(pPathGradientBrush) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetPathGradientPointCount", "UPtr", pPathGradientBrush, "int*", result)
   If E
      return -1
   Return result
}

Gdip_PathGradientGetWrapMode(pPathGradientBrush) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetPathGradientWrapMode", "UPtr", pPathGradientBrush, "int*", result)
   If E
      return -1
   Return result
}

Gdip_PathGradientGetRect(pPathGradientBrush) {
  
  rData := {}

  RectF:=buffer( 16, 0)
  status := DllCall("gdiplus\GdipGetPathGradientRect", "UPtr", pPathGradientBrush, "UPtr", RectF.ptr)

  If (!status) {
        rData.x := NumGet(RectF, 0, "float")
      , rData.y := NumGet(RectF, 4, "float")
      , rData.w := NumGet(RectF, 8, "float")
      , rData.h := NumGet(RectF, 12, "float")
  } Else {
    Return status
  }

  return rData
}

Gdip_PathGradientResetTransform(pPathGradientBrush) {
   
   return DllCall("gdiplus\GdipResetPathGradientTransform", "UPtr", pPathGradientBrush)
}

Gdip_PathGradientRotateTransform(pPathGradientBrush, Angle, matrixOrder:=0) {
   
   return DllCall("gdiplus\GdipRotatePathGradientTransform", "UPtr", pPathGradientBrush, "float", Angle, "int", matrixOrder)
}

Gdip_PathGradientScaleTransform(pPathGradientBrush, ScaleX, ScaleY, matrixOrder:=0) {
   
   return DllCall("gdiplus\GdipScalePathGradientTransform", "UPtr", pPathGradientBrush, "float", ScaleX, "float", ScaleY, "int", matrixOrder)
}

Gdip_PathGradientTranslateTransform(pPathGradientBrush, X, Y, matrixOrder:=0) {
   
   Return DllCall("gdiplus\GdipTranslatePathGradientTransform", "UPtr", pPathGradientBrush, "float", X, "float", Y, "int", matrixOrder)
}

Gdip_PathGradientMultiplyTransform(pPathGradientBrush, hMatrix, matrixOrder:=0) {
   
   Return DllCall("gdiplus\GdipMultiplyPathGradientTransform", "UPtr", pPathGradientBrush, "UPtr", hMatrix, "int", matrixOrder)
}

Gdip_PathGradientSetTransform(pPathGradientBrush, pMatrix) {
  
  return DllCall("gdiplus\GdipSetPathGradientTransform", "UPtr", pPathGradientBrush, "UPtr", pMatrix)
}

Gdip_PathGradientGetTransform(pPathGradientBrush) {
   
   pMatrix := 0
   DllCall("gdiplus\GdipGetPathGradientTransform", "UPtr", pPathGradientBrush, "UPtr*", pMatrix)
   Return pMatrix
}

Gdip_RotatePathGradientAtCenter(pPathGradientBrush, Angle, MatrixOrder:=1) {
; function by Marius Șucan
; based on Gdip_RotatePathAtCenter() by RazorHalo

  Rect := Gdip_PathGradientGetRect(pPathGradientBrush)
  cX := Rect.x + (Rect.w / 2)
  cY := Rect.y + (Rect.h / 2)
  pMatrix := Gdip_CreateMatrix()
  Gdip_TranslateMatrix(pMatrix, -cX , -cY)
  Gdip_RotateMatrix(pMatrix, Angle, MatrixOrder)
  Gdip_TranslateMatrix(pMatrix, cX, cY, MatrixOrder)
  E := Gdip_PathGradientSetTransform(pPathGradientBrush, pMatrix)
  Gdip_DeleteMatrix(pMatrix)
  Return E
}


Gdip_PathGradientSetGammaCorrection(pPathGradientBrush, UseGammaCorrection) {
; Specifies whether gamma correction is enabled for a path gradient brush
; UseGammaCorrection: 1 or 0.
   
   return DllCall("gdiplus\GdipSetPathGradientGammaCorrection", "UPtr", pPathGradientBrush, "int", UseGammaCorrection)
}

Gdip_PathGradientSetWrapMode(pPathGradientBrush, WrapMode) {
; WrapMode options: specifies how an area is tiled when it is painted with a brush:
; 0 - Tile - Tiling without flipping
; 1 - TileFlipX - Tiles are flipped horizontally as you move from one tile to the next in a row
; 2 - TileFlipY - Tiles are flipped vertically as you move from one tile to the next in a column
; 3 - TileFlipXY - Tiles are flipped horizontally as you move along a row and flipped vertically as you move along a column
; 4 - Clamp - No tiling

   
   return DllCall("gdiplus\GdipSetPathGradientWrapMode", "UPtr", pPathGradientBrush, "int", WrapMode)
}

Gdip_PathGradientGetCenterColor(pPathGradientBrush) {
   
   ARGB := 0
   E := DllCall("gdiplus\GdipGetPathGradientCenterColor", "UPtr", pPathGradientBrush, "uint*", ARGB)
   If E
      return -1
   Return Format("{1:#x}", ARGB)
}

Gdip_PathGradientGetCenterPoint(pPathGradientBrush, &X, &Y) {
   
   PointF:=buffer( 8, 0)
   E := DllCall("gdiplus\GdipGetPathGradientCenterPoint", "UPtr", pPathGradientBrush, "UPtr", &PointF)
   If !E
   {
      x := NumGet(PointF, 0, "float")
      y := NumGet(PointF, 4, "float")
   }
   Return E
}

Gdip_PathGradientGetFocusScales(pPathGradientBrush, &X, &Y) {
   
   x := 0
   y := 0
   Return DllCall("gdiplus\GdipGetPathGradientFocusScales", "UPtr", pPathGradientBrush, "float*", X, "float*", Y)
}

Gdip_PathGradientGetSurroundColorCount(pPathGradientBrush) {
   
   result := 0
   E := DllCall("gdiplus\GdipGetPathGradientSurroundColorCount", "UPtr", pPathGradientBrush, "int*", result)
   If E
      return -1
   Return result
}

Gdip_GetPathGradientSurroundColors(pPathGradientBrush) {
   iCount := Gdip_PathGradientGetSurroundColorCount(pPathGradientBrush)
   If (iCount=-1)
      Return 0


   
   sColors:=buffer( 8 * iCount, 0)
   DllCall("gdiplus\GdipGetPathGradientSurroundColorsWithCount", "UPtr", pPathGradientBrush, "UPtr", &sColors, "intP", iCount)
   Loop (iCount)
   {
       A := NumGet(&sColors, 8*(A_Index-1), "uint")
       printList .= Format("{1:#x}", A) ","
   }

   Return Trim(printList, ",")
}

;######################################################################################################################################
; Function written by swagfag in July 2019
; source https://www.autohotkey.com/boards/viewtopic.php?f=6&t=62550
; modified by Marius Șucan
; whichFormat = 2;  histogram for each channel: R, G, B
; whichFormat = 3;  histogram of the luminance/brightness of the image
; Return: Status enumerated return type; 0 = OK/Success

Gdip_GetHistogram(pBitmap, whichFormat, &newArrayA, &newArrayB, &newArrayC) {
   Static sizeofUInt := 4

   ; HistogramFormats := {ARGB: 0, PARGB: 1, RGB: 2, Gray: 3, B: 4, G: 5, R: 6, A: 7}
   z := DllCall("gdiplus\GdipBitmapGetHistogramSize", "UInt", whichFormat, "UInt*", &numEntries:=0)

   newArrayA := [], newArrayB := [], newArrayC := []
   ch0:=buffer( numEntries * sizeofUInt)
   ch1:=buffer( numEntries * sizeofUInt)
   ch2:=buffer( numEntries * sizeofUInt)
   If (whichFormat=2)
      r := DllCall("gdiplus\GdipBitmapGetHistogram", "Ptr", pBitmap, "UInt", whichFormat, "UInt", numEntries, "Ptr", ch0.ptr, "Ptr", ch1.ptr, "Ptr", ch2.ptr, "Ptr", 0)
   Else If (whichFormat>2)
      r := DllCall("gdiplus\GdipBitmapGetHistogram", "Ptr", pBitmap, "UInt", whichFormat, "UInt", numEntries, "Ptr", &ch0, "Ptr", 0, "Ptr", 0, "Ptr", 0)

   Loop (numEntries)
   {
      i := A_Index - 1
      r := NumGet(ch0.ptr, i * sizeofUInt, "UInt")
      newArrayA[i] := r

      If (whichFormat=2)
      {
         g := NumGet(ch1.ptr, i * sizeofUInt, "UInt")
         b := NumGet(ch2.ptr, i * sizeofUInt, "UInt")
         newArrayB[i] := g
         newArrayC[i] := b
      }
   }

   Return r
}

Gdip_DrawRoundedLine(G, x1, y1, x2, y2, LineWidth, LineColor) {
; function by DevX and Rabiator found on:
; https://autohotkey.com/board/topic/29449-gdi-standard-library-145-by-tic/page-11

  pPen := Gdip_CreatePen(LineColor, LineWidth) 
  Gdip_DrawLine(G, pPen, x1, y1, x2, y2) 
  Gdip_DeletePen(pPen) 

  pPen := Gdip_CreatePen(LineColor, LineWidth/2) 
  Gdip_DrawEllipse(G, pPen, x1-LineWidth/4, y1-LineWidth/4, LineWidth/2, LineWidth/2)
  Gdip_DrawEllipse(G, pPen, x2-LineWidth/4, y2-LineWidth/4, LineWidth/2, LineWidth/2)
  Gdip_DeletePen(pPen) 
}

Gdi_CreateBitmap(hDC:="", w:=1, h:=1, BitCount:=32, Planes:=1, pBits:=0) {
; Creates a GDI bitmap; it can be a DIB or DDB.
; https://docs.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-createcompatiblebitmap
    If (hDC="")
       Return DllCall("Gdi32\CreateBitmap", "Int", w, "Int", h, "UInt", Planes, "UInt", BitCount, "Ptr", pBits, "UPtr")
    Else
       Return DllCall("gdi32\CreateCompatibleBitmap", "UPtr", hdc, "int", w, "int", h)
}

Gdi_CreateDIBitmap(hdc, bmpInfoHeader, CBM_INIT, pBits, BITMAPINFO, DIB_COLORS) {
; This function creates a hBitmap, a device-dependent bitmap [DDB]
; from a pointer of data-bits [pBits].
;
; The hBitmap is created according to the information found in
; the BITMAPINFO and bmpInfoHeader pointers.
;
; If the function fails, the return value is NULL,
; otherwise a handle to the hBitmap
;
; Function written by Marius Șucan.
; Many thanks to Drugwash for the help offered.

   
   hBitmap := DllCall("CreateDIBitmap"
            , "UPtr", hdc
            , "UPtr", bmpInfoHeader
            , "uint", CBM_INIT    ; =4
            , "UPtr", pBits
            , "UPtr", BITMAPINFO
            , "uint", DIB_COLORS, "UPtr")    ; PAL=1 ; RGB=2

   Return hBitmap
}

Gdip_CreateBitmapFromGdiDib(BITMAPINFO, BitmapData) {
   
   pBitmap := 0
   E := DllCall("gdiplus\GdipCreateBitmapFromGdiDib", "UPtr", BITMAPINFO, "UPtr", BitmapData, "UPtr*", pBitmap)
   Return pBitmap
}

Gdi_StretchDIBits(hDestDC, dX, dY, dW, dH, sX, sY, sW, sH, tBITMAPINFO, DIB_COLORS, pBits, RasterOper) {
   
   Return DllCall("StretchDIBits"
      , "UPtr", hDestDC, "int", dX, "int", dY
      , "int", dW, "int", dH, "int", sX, "int", sY
      , "int", sW, "int", sH, "UPtr", pBits, "UPtr", tBITMAPINFO
      , "int", DIB_COLORS, "uint", RasterOper)
}

Gdi_SetDIBitsToDevice(hDC, dX, dY, Width, Height, sX, sY, StartScan, ScanLines, pBits, BITMAPINFO, DIB_COLORS) {
   
   Return DllCall("SetDIBitsToDevice", "UPtr", hDC
         , "int", dX, "int", dY
         , "uint", Width, "uint", Height
         , "int", sX, "int", sY
         , "uint", StartScan, "uint", ScanLines
         , "UPtr", pBits, "UPtr", BITMAPINFO, "uint", DIB_COLORS)
}

Gdi_GetDIBits(hDC, hBitmap, start, cLines, pBits, BITMAPINFO, DIB_COLORS) {
; hDC     - A handle to the device context.
; hBitmap - A handle to the GDI bitmap. This must be a compatible bitmap (DDB).
; pbits   --A pointer to a buffer to receive the bitmap data.
;           If this parameter is NULL, the function passes the dimensions
;           and format of the bitmap to the BITMAPINFO structure pointed to 
;           by the BITMAPINFO parameter.
; A DDB is a Device-Dependent Bitmap, (as opposed to a DIB, or Device-Independent Bitmap).
; That means: a DDB does not contain color values; instead, the colors are in a
; device-dependent format. Therefore, it requires a hDC.
; 
; This function returns the data-bits as device-independent bitmap
; from a hBitmap into the pBits pointer.
;
; Return: if the function fails, the return value is zero.
; It can also return ERROR_INVALID_PARAMETER.
; Function written by Marius Șucan.

   
   Return DllCall("GetDIBits"
            , "UPtr", hDC
            , "UPtr", hBitmap
            , "uint", start
            , "uint", cLines
            , "UPtr", pBits
            , "UPtr", BITMAPINFO
            , "uint", DIB_COLORS, "UPtr")    ; PAL=1 ; RGB=2
}

;#####################################################################################

; Function        Gdip_DrawImageFX
; Description     This function draws a bitmap into the pGraphics that can use an Effect.
;
; pGraphics       Pointer to the Graphics of a bitmap
; pBitmap         Pointer to a bitmap to be drawn
; dX, dY          x, y coordinates of the destination upper-left corner where the image will be painted
; sX, sY          x, y coordinates of the source upper-left corner
; sW, sH          width and height of the source image
; Matrix          a color matrix used to alter image attributes when drawing
; pEffect         a pointer to an Effect object to apply when drawing the image
; hMatrix         a pointer to a transformation matrix
; Unit            Unit of measurement:
;                 0 - World coordinates, a nonphysical unit
;                 1 - Display units
;                 2 - A unit is 1 pixel
;                 3 - A unit is 1 point or 1/72 inch
;                 4 - A unit is 1 inch
;                 5 - A unit is 1/300 inch
;                 6 - A unit is 1 millimeter
;
; return          status enumeration. 0 = success
;
; notes on the color matrix:
;                 Matrix can be omitted to just draw with no alteration to ARGB
;                 Matrix may be passed as a digit from 0.0 - 1.0 to change just transparency
;                 Matrix can be passed as a matrix with "|" as delimiter. For example:
;                 MatrixBright=
;                 (
;                 1.5   |0    |0    |0    |0
;                 0     |1.5  |0    |0    |0
;                 0     |0    |1.5  |0    |0
;                 0     |0    |0    |1    |0
;                 0.05  |0.05 |0.05 |0    |1
;                 )
;
; example color matrix:
;                 MatrixBright = 1.5|0|0|0|0|0|1.5|0|0|0|0|0|1.5|0|0|0|0|0|1|0|0.05|0.05|0.05|0|1
;                 MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;                 MatrixNegative = -1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|1|0|1|1|1|0|1
;                 To generate a color matrix using user-friendly parameters,
;                 use GenerateColorMatrix()
; Function written by Marius Șucan.


Gdip_DrawImageFX(pGraphics, pBitmap, dX:="", dY:="", sX:="", sY:="", sW:="", sH:="", matrix:="", pEffect:="", ImageAttr:=0, hMatrix:=0, Unit:=2) {
    
    If !ImageAttr
    {
       if !IsNumber(Matrix)
          ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
       else if (Matrix != 1)
          ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
    } Else usrImageAttr := 1

    if (sX="" && sY="")
       sX := sY := 0

    if (sW="" && sH="")
       Gdip_GetImageDimensions(pBitmap, sW, sH)

    if (!hMatrix && dX!="" && dY!="")
    {
       hMatrix := dhMatrix := Gdip_CreateMatrix()
       Gdip_TranslateMatrix(dhMatrix, dX, dY, 1)
    }

    CreateRectF(sourceRect, sX, sY, sW, sH)
    E := DllCall("gdiplus\GdipDrawImageFX"
      , "UPtr", pGraphics
      , "UPtr", pBitmap
      , "UPtr", &sourceRect
      , "UPtr", hMatrix ? hMatrix : 0        ; transformation matrix
      , "UPtr", pEffect
      , "UPtr", ImageAttr ? ImageAttr : 0
      , "Uint", Unit)            ; srcUnit
    ; r4 := GetStatus(A_LineNumber ":GdipDrawImageFX",r4)

   If dhMatrix
      Gdip_DeleteMatrix(dhMatrix)

    If (ImageAttr && usrImageAttr!=1)
       Gdip_DisposeImageAttributes(ImageAttr)
      
    Return E
}

Gdip_BitmapApplyEffect(pBitmap, pEffect, x:="", y:="", w:="", h:=0) {
; X, Y   - coordinates for the rectangle where the effect is applied
; W, H   - width and heigh for the rectangle where the effect is applied
; If X, Y, W or H are omitted , the effect is applied on the entire pBitmap 
;
; written by Marius Șucan
; many thanks to Drugwash for the help provided
  If InStr(pEffect, "err-")
     Return pEffect

  If (!x && !y && !w && !h)
  {
     Gdip_GetImageDimensions(pBitmap, &Width, &Height)
     CreateRectF(&RectF, 0, 0, Width, Height)
  } Else CreateRectF(&RectF, X, Y, W, H)

  
  E := DllCall("gdiplus\GdipBitmapApplyEffect"
      , "UPtr", pBitmap
      , "UPtr", pEffect
      , "UPtr", RectF.ptr
      , "UPtr", 0
      , "UPtr", 0
      , "UPtr", 0)

   Return E
}

COM_CLSIDfromString(&CLSID, String) {
    CLSID:=buffer( 16, 0)
    E := DllCall("ole32\CLSIDFromString", "WStr", String, "UPtr", &CLSID)
    Return E
}

Gdip_CreateEffect(whichFX, paramA, paramB, paramC:=0) {
/*
   whichFX options:
   1 - Blur
          paramA - radius [0, 255]
          paramB - bool [0, 1]
   2 - Sharpen
          paramA - radius [0, 255]
          paramB - amount [0, 100]
   3 - ! ColorMatrix
   4 - ! ColorLUT
   5 - BrightnessContrast
          paramA - brightness [-255, 255]
          paramB - contrast [-100, 100]
   6 - HueSaturationLightness
          paramA - hue [-180, 180]
          paramB - saturation [-100, 100]
          paramC - light [-100, 100]
   7 - LevelsAdjust
          paramA - highlights [0, 100]
          paramB - midtones [-100, 100]
          paramC - shadows [0, 100]
   8 - Tint
          paramA - hue [-180, 180]
          paramB - amount [0, 100]
   9 - ColorBalance
          paramA - Cyan / Red [-100, 100]
          paramB - Magenta / Green [-100, 100]
          paramC - Yellow / Blue [-100, 100]
   10 - ! RedEyeCorrection
   11 - ColorCurve
          paramA - Type of adjustments [0, 7]
                   0 - AdjustExposure         [-255, 255]
                   1 - AdjustDensity          [-255, 255]
                   2 - AdjustContrast         [-100, 100]
                   3 - AdjustHighlight        [-100, 100]
                   4 - AdjustShadow           [-100, 100]
                   5 - AdjustMidtone          [-100, 100]
                   6 - AdjustWhiteSaturation  [0, 255]
                   7 - AdjustBlackSaturation  [0, 255]

         paramB - Apply ColorCurve on channels [1, 4]
                   1 - Red
                   2 - Green
                   3 - Blue
                   4 - All channels

         paramC - An adjust value within range according to paramA

   Effects marked with "!" are not yet implemented.
   Through ParamA, ParamB and ParamC, the effects can be controlled.
   Function written by Marius Șucan. Many thanks to Drugwash for the help provided,
*/

    Static gdipImgFX := {1:"633C80A4-1843-482b-9EF2-BE2834C5FDD4", 2:"63CBF3EE-C526-402c-8F71-62C540BF5142", 3:"718F2615-7933-40e3-A511-5F68FE14DD74", 4:"A7CE72A9-0F7F-40d7-B3CC-D0C02D5C3212", 5:"D3A1DBE1-8EC4-4c17-9F4C-EA97AD1C343D", 6:"8B2DD6C3-EB07-4d87-A5F0-7108E26A9C5F", 7:"99C354EC-2A31-4f3a-8C34-17A803B33A25", 8:"1077AF00-2848-4441-9489-44AD4C2D7A2C", 9:"537E597D-251E-48da-9664-29CA496B70F8", 10:"74D29D05-69A4-4266-9549-3CC52836B632", 11:"DD6A0022-58E4-4a67-9D9B-D48EB881A53D"}
    Ptr := A_PtrSize=8 ? "UPtr" : "UInt"
    Ptr2 := A_PtrSize=8 ? "Ptr*" : "PtrP"
    pEffect := 0
    r1 := COM_CLSIDfromString(eFXguid, "{" gdipImgFX[whichFX] "}" )
    If r1
       Return "err-" r1

    If (A_PtrSize=4) ; 32 bits
    {
       r2 := DllCall("gdiplus\GdipCreateEffect"
          , "UInt", NumGet(eFXguid, 0, "UInt")
          , "UInt", NumGet(eFXguid, 4, "UInt")
          , "UInt", NumGet(eFXguid, 8, "UInt")
          , "UInt", NumGet(eFXguid, 12, "UInt")
          , Ptr2, pEffect)
    } Else
    {
       r2 := DllCall("gdiplus\GdipCreateEffect"
          , "UPtr", &eFXguid
          , Ptr2, pEffect)
    }
    If r2
       Return "err-" r2

    ; r2 := GetStatus(A_LineNumber ":GdipCreateEffect", r2)

    FXparams:=buffer( 16, 0)
    If (whichFX=1)   ; Blur FX
    {
       NumPut(paramA, FXparams, 0, "Float")   ; radius [0, 255]
       NumPut(paramB, FXparams, 4, "Uchar")   ; bool 0, 1
    } Else If (whichFX=2)   ; Sharpen FX
    {
       NumPut(paramA, FXparams, 0, "Float")   ; radius [0, 255]
       NumPut(paramB, FXparams, 4, "Float")   ; amount [0, 100]
    } Else If (whichFX=5)   ; Brightness / Contrast
    {
       NumPut(paramA, FXparams, 0, "Int")     ; brightness [-255, 255]
       NumPut(paramB, FXparams, 4, "Int")     ; contrast [-100, 100]
    } Else If (whichFX=6)   ; Hue / Saturation / Lightness
    {
       NumPut(paramA, FXparams, 0, "Int")     ; hue [-180, 180]
       NumPut(paramB, FXparams, 4, "Int")     ; saturation [-100, 100]
       NumPut(paramC, FXparams, 8, "Int")     ; light [-100, 100]
    } Else If (whichFX=7)   ; Levels adjust
    {
       NumPut(paramA, FXparams, 0, "Int")     ; highlights [0, 100]
       NumPut(paramB, FXparams, 4, "Int")     ; midtones [-100, 100]
       NumPut(paramC, FXparams, 8, "Int")     ; shadows [0, 100]
    } Else If (whichFX=8)   ; Tint adjust
    {
       NumPut(paramA, FXparams, 0, "Int")     ; hue [180, 180]
       NumPut(paramB, FXparams, 4, "Int")     ; amount [0, 100]
    } Else If (whichFX=9)   ; Colors balance
    {
       NumPut(paramA, FXparams, 0, "Int")     ; Cyan / Red [-100, 100]
       NumPut(paramB, FXparams, 4, "Int")     ; Magenta / Green [-100, 100]
       NumPut(paramC, FXparams, 8, "Int")     ; Yellow / Blue [-100, 100]
    } Else If (whichFX=11)   ; ColorCurve
    {
       NumPut(paramA, FXparams, 0, "Int")     ; Type of adjustment [0, 7]
       NumPut(paramB, FXparams, 4, "Int")     ; Channels to affect [1, 4]
       NumPut(paramC, FXparams, 8, "Int")     ; Adjustment value [based on the type of adjustment]
    }

    DllCall("gdiplus\GdipGetEffectParameterSize", "UPtr", pEffect, "uint*", &FXsize:=0)
    r3 := DllCall("gdiplus\GdipSetEffectParameters", "UPtr", pEffect, "UPtr", &FXparams, "UInt", FXsize)
    If r3
    {
       Gdip_DisposeEffect(pEffect)
       Return "err-" r3
    }
    ; r3 := GetStatus(A_LineNumber ":GdipSetEffectParameters", r3)
    ; ToolTip, % r1 " -- " r2 " -- " r3 " -- " r4,,, 2
    Return pEffect
}

Gdip_DisposeEffect(pEffect) {
   
   r := DllCall("gdiplus\GdipDeleteEffect", "UPtr", pEffect)
   Return r
}

GenerateColorMatrix(modus, bright:=1, contrast:=0, saturation:=1, alph:=1, chnRdec:=0, chnGdec:=0, chnBdec:=0) {
; parameters ranges / intervals:
; bright:     [0.001 - 20.0]
; contrast:   [-20.0 - 1.00]
; saturation: [0.001 - 5.00]
; alph:       [0.001 - 5.00]
;
; modus options:
; 0 - personalized colors based on the bright, contrast [hue], saturation parameters
; 1 - personalized colors based on the bright, contrast, saturation parameters
; 2 - grayscale image
; 3 - grayscale R channel
; 4 - grayscale G channel
; 5 - grayscale B channel
; 6 - negative / invert image
; 7 - alpha channel as grayscale image
;
; chnRdec, chnGdec, chnBdec only apply in modus=1
; these represent offsets for the RGB channels

; in modus=0 the parameters have other ranges:
; bright:     [-5.00 - 5.00]
; hue:        [-1.57 - 1.57]  ; pi/2 - contrast stands for hue in this mode
; saturation: [0.001 - 5.00]
; formulas for modus=0 were written by Smurth
; extracted from https://autohotkey.com/board/topic/29449-gdi-standard-library-145-by-tic/page-86
;
; function written by Marius Șucan
; infos from http://www.graficaobscura.com/matrix/index.html
; real NTSC values: r := 0.300, g := 0.587, b := 0.115

    Static NTSCr := 0.308, NTSCg := 0.650, NTSCb := 0.095   ; personalized values
    matrix := ""

    If (modus=2)       ; grayscale
    {
       LGA := (bright<=1) ? bright/1.5 - 0.6666 : bright - 1
       Ra := NTSCr + LGA
       If (Ra<0)
          Ra := 0
       Ga := NTSCg + LGA
       If (Ga<0)
          Ga := 0
       Ba := NTSCb + LGA
       If (Ba<0)
          Ba := 0
       matrix := Ra "|" Ra "|" Ra "|0|0|" Ga "|" Ga "|" Ga "|0|0|" Ba "|" Ba "|" Ba "|0|0|0|0|0|" alph "|0|" contrast "|" contrast "|" contrast "|0|1"
    } Else If (modus=3)       ; grayscale R
    {
       Ga := 0, Ba := 0, GGA := 0
       Ra := bright
       matrix := Ra "|" Ra "|" Ra "|0|0|" Ga "|" Ga "|" Ga "|0|0|" Ba "|" Ba "|" Ba "|0|0|0|0|0|25|0|" GGA+0.01 "|" GGA "|" GGA "|0|1"
    } Else If (modus=4)       ; grayscale G
    {
       Ra := 0, Ba := 0, GGA := 0
       Ga := bright
       matrix := Ra "|" Ra "|" Ra "|0|0|" Ga "|" Ga "|" Ga "|0|0|" Ba "|" Ba "|" Ba "|0|0|0|0|0|25|0|" GGA "|" GGA+0.01 "|" GGA "|0|1"
    } Else If (modus=5)       ; grayscale B
    {
       Ra := 0, Ga := 0, GGA := 0
       Ba := bright
       matrix := Ra "|" Ra "|" Ra "|0|0|" Ga "|" Ga "|" Ga "|0|0|" Ba "|" Ba "|" Ba "|0|0|0|0|0|25|0|" GGA "|" GGA "|" GGA+0.01 "|0|1"
    } Else If (modus=6)  ; negative / invert
    {
       matrix := "-1|0|0|0|0|0|-1|0|0|0|0|0|-1|0|0|0|0|0|" alph "|0|1|1|1|0|1"
    } Else If (modus=1)   ; personalized saturation, contrast and brightness 
    {
       bL := bright, aL := alph
       G := contrast, sL := saturation
       sLi := 1 - saturation
       bLa := bright - 1
       If (sL>1)
       {
          z := (bL<1) ? bL : 1
          sL := sL*z
          If (sL<0.98)
             sL := 0.98

          y := z*(1 - sL)
          mA := z*(y*NTSCr + sL + bLa + chnRdec)
          mB := z*(y*NTSCr)
          mC := z*(y*NTSCr)
          mD := z*(y*NTSCg)
          mE := z*(y*NTSCg + sL + bLa + chnGdec)
          mF := z*(y*NTSCg)
          mG := z*(y*NTSCb)
          mH := z*(y*NTSCb)
          mI := z*(y*NTSCb + sL + bLa + chnBdec)
          mtrx:= mA "|" mB "|" mC "|  0   |0"
           . "|" mD "|" mE "|" mF "|  0   |0"
           . "|" mG "|" mH "|" mI "|  0   |0"
           . "|  0   |  0   |  0   |" aL "|0"
           . "|" G  "|" G  "|" G  "|  0   |1"
       } Else
       {
          z := (bL<1) ? bL : 1
          tR := NTSCr - 0.5 + bL/2
          tG := NTSCg - 0.5 + bL/2
          tB := NTSCb - 0.5 + bL/2
          rB := z*(tR*sLi+bL*(1 - sLi) + chnRdec)
          gB := z*(tG*sLi+bL*(1 - sLi) + chnGdec)
          bB := z*(tB*sLi+bL*(1 - sLi) + chnBdec)     ; Formula used: A*w + B*(1 – w)
          rF := z*(NTSCr*sLi + (bL/2 - 0.5)*sLi)
          gF := z*(NTSCg*sLi + (bL/2 - 0.5)*sLi)
          bF := z*(NTSCb*sLi + (bL/2 - 0.5)*sLi)

          rB := rB*z+rF*(1 - z)
          gB := gB*z+gF*(1 - z)
          bB := bB*z+bF*(1 - z)     ; Formula used: A*w + B*(1 – w)
          If (rB<0)
             rB := 0
          If (gB<0)
             gB := 0
          If (bB<0)
             bB := 0
          If (rF<0)
             rF := 0
 
          If (gF<0)
             gF := 0
 
          If (bF<0)
             bF := 0

          ; ToolTip, % rB " - " rF " --- " gB " - " gF
          mtrx:= rB "|" rF "|" rF "|  0   |0"
           . "|" gF "|" gB "|" gF "|  0   |0"
           . "|" bF "|" bF "|" bB "|  0   |0"
           . "|  0   |  0   |  0   |" aL "|0"
           . "|" G  "|" G  "|" G  "|  0   |1"
          ; matrix adjusted for lisibility
       }
       matrix := StrReplace(mtrx, A_Space)
    } Else If (modus=0)   ; personalized hue, saturation and brightness
    {
       s1 := contrast   ; in this mode, contrast stands for hue
       s2 := saturation
       s3 := bright
       aL := alph
 
       s1 := s2*sin(s1)
       sc := 1-s2
       r := NTSCr*sc-s1
       g := NTSCg*sc-s1
       b := NTSCb*sc-s1
 
       rB := r+s2+3*s1
       gB := g+s2+3*s1
       bB := b+s2+3*s1
       mtrx :=   rB "|" r  "|" r  "|  0   |0"
           . "|" g  "|" gB "|" g  "|  0   |0"
           . "|" b  "|" b  "|" bB "|  0   |0"
           . "|  0   |  0   |  0   |" aL "|0"
           . "|" s3 "|" s3 "|" s3 "|  0   |1"
       matrix := StrReplace(mtrx, A_Space)
    } Else If (modus=7)
    {
       mtrx := "0|0|0|0|0"
            . "|0|0|0|0|0"
            . "|0|0|0|0|0"
            . "|1|1|1|25|0"
            . "|0|0|0|0|1"
       matrix := StrReplace(mtrx, A_Space)
    }
    Return matrix
}

Gdip_CompareBitmaps(pBitmapA, pBitmapB, accuracy:=25) {
; On success, it returns the percentage of similarity between the given pBitmaps.
; If the given pBitmaps do not have the same resolution, 
; the return value is -1.
;
; Function by Tic, from June 2010
; Source: https://autohotkey.com/board/topic/29449-gdi-standard-library-145-by-tic/page-27
;
; Warning: it can be very slow with really large images and high accuracy.
;
; Updated and modified by Marius Șucan in September 2019.
; Added accuracy factor.

   If (accuracy>99)
      accuracy := 100
   Else If (accuracy<5)
      accuracy := 5

   Gdip_GetImageDimensions(pBitmapA, &WidthA, &HeightA)
   Gdip_GetImageDimensions(pBitmapB, &WidthB, &HeightB)
   If (accuracy!=100)
   {
      pBitmap1 := Gdip_ResizeBitmap(pBitmapA, Floor(WidthA*(accuracy/100)), Floor(HeightA*(accuracy/100)), 0, 5)
      pBitmap2 := Gdip_ResizeBitmap(pBitmapB, Floor(WidthB*(accuracy/100)), Floor(HeightB*(accuracy/100)), 0, 5)
   } Else
   {
      pBitmap1 := pBitmapA
      pBitmap2 := pBitmapB
   }

   Gdip_GetImageDimensions(pBitmap1, &Width1, &Height1)
   Gdip_GetImageDimensions(pBitmap2, &Width2, &Height2)
   if (!Width1 || !Height1 || !Width2 || !Height2
   || Width1 != Width2 || Height1 != Height2)
      Return -1

   E1 := Gdip_LockBits(pBitmap1, 0, 0, Width1, Height1, &Stride1, &Scan01, &BitmapData1)
   E2 := Gdip_LockBits(pBitmap2, 0, 0, Width2, Height2, &Stride2, &Scan02, &BitmapData2)
   z := 0
   Loop (Height1)
   {
      y++
      Loop (Width1)
      {
         Gdip_FromARGB(Gdip_GetLockBitPixel(Scan01, A_Index-1, y-1, Stride1), &A1, &R1, &G1, &B1)
         Gdip_FromARGB(Gdip_GetLockBitPixel(Scan02, A_Index-1, y-1, Stride2), &A2, &R2, &G2, &B2)
         z += Abs(A2-A1) + Abs(R2-R1) + Abs(G2-G1) + Abs(B2-B1)
      }
   }

   Gdip_UnlockBits(pBitmap1, BitmapData1), Gdip_UnlockBits(pBitmap2, BitmapData2)
   If (accuracy!=100)
   {
      Gdip_DisposeImage(pBitmap1)
      Gdip_DisposeImage(pBitmap2)
   }
   Return z/(Width1*Width2*3*255/100)
}

Gdip_RetrieveBitmapChannel(pBitmap, channel) {
; Channel to retrive:
; 1 - Red
; 2 - Green
; 3 - Blue
; 4 - Alpha
; On success, the function will return a pBitmap
; in 32-ARGB PixelFormat containing a grayscale
; rendition of the retrieved channel.

    If (channel="1")
       matrix := GenerateColorMatrix(3)
    Else If (channel="2")
       matrix := GenerateColorMatrix(4)
    Else If (channel="3")
       matrix := GenerateColorMatrix(5)
    Else If (channel="4")
       matrix := GenerateColorMatrix(7)
    Else Return

    Gdip_GetImageDimensions(pBitmap, &imgW, &imgH)
    If (!imgW || !imgH)
       Return

    pBrush := Gdip_BrushCreateSolid(0xff000000)
    newBitmap := Gdip_CreateBitmap(imgW, imgH)
    If !newBitmap
       Return

    G := Gdip_GraphicsFromImage(newBitmap)
    Gdip_SetInterpolationMode(G, 7)
    Gdip_FillRectangle(G, pBrush, 0, 0, imgW, imgH)
    Gdip_DrawImage(G, pBitmap, 0, 0, imgW, imgH, 0, 0, imgW, imgH, matrix)
    Gdip_DeleteBrush(pBrush)
    Gdip_DeleteGraphics(G)
    Return newBitmap
}

Gdip_RenderPixelsOpaque(pBitmap, pBrush:=0, alphaLevel:=0) {
; alphaLevel - from 0 [transparent] to 1 or beyond [opaque]
;
; This function is meant to make opaque partially transparent pixels.
; It returns a pointer to a new pBitmap.
;
; If pBrush is given, the background of the image is filled using it,
; otherwise, the pixels that are 100% transparent
; might remain transparent.

    Gdip_GetImageDimensions(pBitmap, &imgW, &imgH)
    newBitmap := Gdip_CreateBitmap(imgW, imgH)
    G := Gdip_GraphicsFromImage(newBitmap)
    Gdip_SetInterpolationMode(G, 7)
    If alphaLevel
       matrix := GenerateColorMatrix(0, 0, 0, 1, alphaLevel)
    Else
       matrix := GenerateColorMatrix(0, 0, 0, 1, 25)
    If pBrush
       Gdip_FillRectangle(G, pBrush, 0, 0, imgW, imgH)

    Gdip_DrawImage(G, pBitmap, 0, 0, imgW, imgH, 0, 0, imgW, imgH, matrix)
    Gdip_DeleteGraphics(G)
    Return newBitmap
}

Gdip_TestBitmapUniformity(pBitmap, HistogramFormat:=3, &maxLevelIndex:=0, &maxLevelPixels:=0) {
; This function tests whether the given pBitmap 
; is in a single shade [color] or not.

; If HistogramFormat parameter is set to 3, the function 
; retrieves the intensity/gray histogram and checks
; how many pixels are for each level [0, 255].
;
; If all pixels are found at a single level,
; the return value is 1, because the pBitmap is considered
; uniform, in a single shade.
;
; One can set the HistogramFormat to 4 [R], 5 [G], 6 [B] or 7 [A]
; to test for the uniformity of a specific channel.
;
; A threshold value of 0.0005% of all the pixels, is used.
; This is to ensure that a few pixels do not change the status.

   LevelsArray := []
   maxLevelIndex := maxLevelPixels := nrPixels := 9
   Gdip_GetImageDimensions(pBitmap, &Width, &Height)
   Gdip_GetHistogram(pBitmap, HistogramFormat, LevelsArray, 0, 0)
   Loop (256)
   {
       nrPixels := Round(LevelsArray[A_Index - 1])
       If (nrPixels>0)
          histoList .= nrPixels "." A_Index - 1 "|"
   }
   histoList := Sort(histoList, "NURD|")
   histoList := Trim(histoList, "|")
   histoListSortedArray := StrSplit(histoList, "|")
   maxLevel := StrSplit(histoListSortedArray[1], ".")
   maxLevelIndex := maxLevel[2]
   maxLevelPixels := maxLevel[1]
   ; ToolTip, % maxLevelIndex " -- " maxLevelPixels " | " histoListSortedArray[1] "`n" histoList, , , 3
   pixelsThreshold := Round((Width * Height) * 0.0005) + 1
   If (Floor(histoListSortedArray[2])<pixelsThreshold)
      Return 1
   Else 
      Return 0
}

Gdip_SetBitmapAlphaChannel(pBitmap, AlphaMaskBitmap) {
; Replaces the alpha channel of the given pBitmap
; based on the red channel of AlphaMaskBitmap.
; AlphaMaskBitmap must be grayscale for optimal results.
; Both pBitmap and AlphaMaskBitmap must be in 32-ARGB PixelFormat.

   Gdip_GetImageDimensions(pBitmap, &Width1, &Height1)
   Gdip_GetImageDimensions(AlphaMaskBitmap, &Width2, &Height2)
   if (!Width1 || !Height1 || !Width2 || !Height2
   || Width1 != Width2 || Height1 != Height2)
      Return -1

   newBitmap := Gdip_RenderPixelsOpaque(pBitmap)
   alphaUniform := Gdip_TestBitmapUniformity(AlphaMaskBitmap, 3, &maxLevelIndex, &maxLevelPixels)
   If (alphaUniform=1)
   {
      ; if the given AlphaMaskBitmap is only in a single shade,
      ; the opacity of the pixels in the given pBitmap is set
      ; using a ColorMatrix.
      newAlpha := Round(maxLevelIndex/255, 2)
      If (newAlpha<0.1)
         newAlpha := 0.1

      nBitmap := Gdip_RenderPixelsOpaque(pBitmap, 0 , newAlpha)
      Gdip_DisposeImage(newBitmap)
      Return nBitmap
   }

   E1 := Gdip_LockBits(newBitmap, 0, 0, Width1, Height1, &Stride1, &Scan01, &BitmapData1)
   E2 := Gdip_LockBits(AlphaMaskBitmap, 0, 0, Width2, Height2, &Stride2, &Scan02, &BitmapData2)
   Loop (Height1)
   {
      y++
      Loop (Width1)
      {
         pX := A_Index-1, pY := y-1
         R2 := Gdip_RFromARGB(NumGet(Scan02+0, (pX*4)+(pY*Stride2), "UInt"))       ; Gdip_GetLockBitPixel()
         If (R2>254)
            Continue
         Gdip_FromARGB(NumGet(Scan01+0, (pX*4)+(pY*Stride1), "UInt"), &A1, &R1, &G1, &B1)
         NumPut(Gdip_ToARGB(R2, R1, G1, B1), Scan01+0, (pX*4)+(pY*Stride1), "UInt")    ; Gdip_SetLockBitPixel()
      }
   }

   Gdip_UnlockBits(newBitmap, BitmapData1)
   Gdip_UnlockBits(AlphaMaskBitmap, BitmapData2)
   return newBitmap
}

calcIMGdimensions(imgW, imgH, givenW, givenH, &ResizedW, &ResizedH) {
; This function calculates from original imgW and imgH 
; new image dimensions that maintain the aspect ratio
; and are within the boundaries of givenW and givenH.
;
; imgW, imgH         - original image width and height
; givenW, givenH     - the width and height [in pixels] to adapt to
; ResizedW, ResizedH - the width and height resulted from adapting imgW, imgH to givenW, givenH
;                      by keeping the aspect ratio

   PicRatio := Round(imgW/imgH, 5)
   givenRatio := Round(givenW/givenH, 5)
   If (imgW <= givenW) && (imgH <= givenH)
   {
      ResizedW := givenW
      ResizedH := Round(ResizedW / PicRatio)
      If (ResizedH>givenH)
      {
         ResizedH := (imgH <= givenH) ? givenH : imgH
         ResizedW := Round(ResizedH * PicRatio)
      }   
   } Else If (PicRatio > givenRatio)
   {
      ResizedW := givenW
      ResizedH := Round(ResizedW / PicRatio)
   } Else
   {
      ResizedH := (imgH >= givenH) ? givenH : imgH         ;set the maximum picture height to the original height
      ResizedW := Round(ResizedH * PicRatio)
   }
}

GetWindowRect(hwnd, &W, &H) {
   ; function by GeekDude: https://gist.github.com/G33kDude/5b7ba418e685e52c3e6507e5c6972959
   ; W10 compatible function to find a window's visible boundaries
   ; modified by Marius Șucanto return an array
   size := rect:=buffer( 16, 0)
   er := DllCall("dwmapi\DwmGetWindowAttribute"
      , "UPtr", hWnd  ; HWND  hwnd
      , "UInt", 9     ; DWORD dwAttribute (DWMWA_EXTENDED_FRAME_BOUNDS)
      , "UPtr", &rect ; PVOID pvAttribute
      , "UInt", size  ; DWORD cbAttribute
      , "UInt")       ; HRESULT

   If er
      DllCall("GetWindowRect", "UPtr", hwnd, "UPtr", &rect, "UInt")

   r := []
   r.x1 := NumGet(rect, 0, "Int"), r.y1 := NumGet(rect, 4, "Int")
   r.x2 := NumGet(rect, 8, "Int"), r.y2 := NumGet(rect, 12, "Int")
   r.w := Abs(max(r.x1, r.x2) - min(r.x1, r.x2))
   r.h := Abs(max(r.y1, r.y2) - min(r.y1, r.y2))
   W := r.w
   H := r.h
   ; ToolTip, % r.w " --- " r.h , , , 2
   Return r
}

Gdip_BitmapConvertGray(pBitmap, hue:=0, vibrance:=-40, brightness:=1, contrast:=0, KeepPixelFormat:=0) {
; hue, vibrance, contrast and brightness parameters
; influence the resulted new grayscale pBitmap.
;
; KeepPixelFormat can receive a specific PixelFormat.
; The function returns a pointer to a new pBitmap.

    Gdip_GetImageDimensions(pBitmap, &Width, &Height)
    If (KeepPixelFormat=1)
       PixelFormat := Gdip_GetImagePixelFormat(pBitmap, 1)
    If StrLen(KeepPixelFormat)>3
       PixelFormat := KeepPixelFormat

    newBitmap := Gdip_CreateBitmap(Width, Height, PixelFormat)
    G := Gdip_GraphicsFromImage(newBitmap)
    Gdip_SetInterpolationMode(G, 7)
    pEffect := Gdip_CreateEffect(6, hue, vibrance, 0)
    matrix := GenerateColorMatrix(2, brightness, contrast)
    r1 := Gdip_DrawImageFX(G, pBitmap, 0, 0, 0, 0, Width, Height, matrix, pEffect)
    Gdip_DisposeEffect(pEffect)
    Gdip_DeleteGraphics(G)
    Return newBitmap
}

Gdip_BitmapSetColorDepth(pBitmap, bitsDepth, useDithering:=1) {
; Return 0 = OK - Success

   ditheringMode := (useDithering=1) ? 9 : 1
   If (useDithering=1 && bitsDepth=16)
      ditheringMode := 2

   Colors := 2**bitsDepth
   If (bitsDepth >= 2) and  (bitsDepth<=4)
      bitsDepth := "40s"
   If (bitsDepth >= 5) and  (bitsDepth<=8)
      bitsDepth := "80s"
   If (bitsDepth="BW")
      E := Gdip_BitmapConvertFormat(pBitmap, 0x30101, ditheringMode, 2, 2, 2, 2, 0, 0)
   Else If (bitsDepth=1)
      E := Gdip_BitmapConvertFormat(pBitmap, 0x30101, ditheringMode, 1, 2, 1, 2, 0, 0)
   Else If (bitsDepth="40s")
      E := Gdip_BitmapConvertFormat(pBitmap, 0x30402, ditheringMode, 1, Colors, 1, Colors, 0, 0)
   Else If (bitsDepth="80s")
      E := Gdip_BitmapConvertFormat(pBitmap, 0x30803, ditheringMode, 1, Colors, 1, Colors, 0, 0)
   Else If (bitsDepth=16)
      E := Gdip_BitmapConvertFormat(pBitmap, 0x21005, ditheringMode, 1, Colors, 1, Colors, 0, 0)
   Else If (bitsDepth=24)
      E := Gdip_BitmapConvertFormat(pBitmap, 0x21808, 2, 1, 0, 0, 0, 0, 0)
   Else If (bitsDepth=32)
      E := Gdip_BitmapConvertFormat(pBitmap, 0x26200A, 2, 1, 0, 0, 0, 0, 0)
   Else
      E := -1
   Return E
}

Gdip_BitmapConvertFormat(pBitmap, PixelFormat, DitherType, DitherPaletteType, PaletteEntries, PaletteType, OptimalColors, UseTransparentColor:=0, AlphaThresholdPercent:=0) {
; pBitmap - Handle to a pBitmap object on which the color conversion is applied.

; PixelFormat options: see Gdip_GetImagePixelFormat()
; Pixel format constant that specifies the new pixel format.

; PaletteEntries    Number of Entries.
; OptimalColors   - Integer that specifies the number of colors you want to have in an optimal palette based on a specified pBitmap.
;                   This parameter is relevant if PaletteType parameter is set to PaletteTypeOptimal [1].
; UseTransparentColor     Boolean value that specifies whether to include the transparent color in the palette.
; AlphaThresholdPercent - Real number in the range 0.0 through 100.0 that specifies which pixels in the source bitmap will map to the transparent color in the converted bitmap.
;
; PaletteType options:
; Custom = 0   ; Arbitrary custom palette provided by caller.
; Optimal = 1   ; Optimal palette generated using a median-cut algorithm.
; FixedBW = 2   ; Black and white palette.
;
; Symmetric halftone palettes. Each of these halftone palettes will be a superset of the system palette.
; e.g. Halftone8 will have its 8-color on-off primaries and the 16 system colors added. With duplicates removed, that leaves 16 colors.
; FixedHalftone8 = 3   ; 8-color, on-off primaries
; FixedHalftone27 = 4   ; 3 intensity levels of each color
; FixedHalftone64 = 5   ; 4 intensity levels of each color
; FixedHalftone125 = 6   ; 5 intensity levels of each color
; FixedHalftone216 = 7   ; 6 intensity levels of each color
;
; Assymetric halftone palettes. These are somewhat less useful than the symmetric ones, but are included for completeness.
; These do not include all of the system colors.
; FixedHalftone252 = 8   ; 6-red, 7-green, 6-blue intensities
; FixedHalftone256 = 9   ; 8-red, 8-green, 4-blue intensities
;
; DitherType options:
; None = 0
; Solid = 1
; - it picks the nearest matching color with no attempt to halftone or dither. May be used on an arbitrary palette.
;
; Ordered dithers and spiral dithers must be used with a fixed palette.
; NOTE: DitherOrdered4x4 is unique in that it may apply to 16bpp conversions also.
; Ordered4x4 = 2
; Ordered8x8 = 3
; Ordered16x16 = 4
; Ordered91x91 = 5
; Spiral4x4 = 6
; Spiral8x8 = 7
; DualSpiral4x4 = 8
; DualSpiral8x8 = 9
; ErrorDiffusion = 10   ; may be used with any palette
; Return 0 = OK - Success

   hPalette:=buffer( 4 * PaletteEntries + 8, 0)

;   tPalette := DllStructCreate("uint Flags; uint Count; uint ARGB[" & $iEntries & "];")
   NumPut(PaletteType, &hPalette, 0, "uint")
   NumPut(PaletteEntries, &hPalette, 4, "uint")
   NumPut(0, &hPalette, 8, "uint")

   
   E1 := DllCall("gdiplus\GdipInitializePalette", "UPtr", &hPalette, "uint", PaletteType, "uint", OptimalColors, "Int", UseTransparentColor, "UPtr", pBitmap)
   E2 := DllCall("gdiplus\GdipBitmapConvertFormat", "UPtr", pBitmap, "uint", PixelFormat, "uint", DitherType, "uint", DitherPaletteType, "uPtr", &hPalette, "float", AlphaThresholdPercent)
   E := E1 ? E1 : E2
   Return E
}

Gdip_GetImageThumbnail(pBitmap, W, H) {
; by jballi, source
; https://www.autohotkey.com/boards/viewtopic.php?style=7&t=70508

    DllCall("gdiplus\GdipGetImageThumbnail"
        ,"UPtr",pBitmap                         ;-- *image
        ,"UInt",W                               ;-- thumbWidth
        ,"UInt",H                               ;-- thumbHeight
        ,"UPtr*",&pThumbnail:=0                     ;-- **thumbImage
        ,"UPtr",0                               ;-- callback
        ,"UPtr",0)                              ;-- callbackData

   Return pThumbnail
}

; =================================================
; The following functions were written by Tidbit
; handed to me by himself to be included here.
; =================================================

ConvertRGBtoHSL(R, G, B) {
; http://www.easyrgb.com/index.php?X=MATH&H=18#text18
   R := (R / 255)
   G := (G / 255)
   B := (B / 255)

   Min     := min(R, G, B)
   Max     := max(R, G, B)
   del_Max := Max - Min

   L := (Max + Min) / 2

   if (del_Max = 0)
   {
      H := S := 0
   } else
   {
      if (L < 0.5)
         S := del_Max / (Max + Min)
      else
         S := del_Max / (2 - Max - Min)

      del_R := (((Max - R) / 6) + (del_Max / 2)) / del_Max
      del_G := (((Max - G) / 6) + (del_Max / 2)) / del_Max
      del_B := (((Max - B) / 6) + (del_Max / 2)) / del_Max

      if (R = Max)
      {
         H := del_B - del_G
      } else
      {
         if (G = Max)
            H := (1 / 3) + del_R - del_B
         else if (B = Max)
            H := (2 / 3) + del_G - del_R
      }
      if (H < 0)
         H += 1
      if (H > 1)
         H -= 1
   }
   ; return round(h*360) "," s "," l
   ; return (h*360) "," s "," l
   return [abs(round(h*360)), abs(s), abs(l)]
}

ConvertHSLtoRGB(H, S, L) {
; http://www.had2know.com/technology/hsl-rgb-color-converter.html

   H := H/360
   if (S == 0)
   {
      R := L*255
      G := L*255
      B := L*255
   } else
   {
      if (L < 0.5)
         var_2 := L * (1 + S)
      else
         var_2 := (L + S) - (S * L)
       var_1 := 2 * L - var_2

       R := 255 * ConvertHueToRGB(var_1, var_2, H + (1 / 3))
       G := 255 * ConvertHueToRGB(var_1, var_2, H)
       B := 255 * ConvertHueToRGB(var_1, var_2, H - (1 / 3))
   }
   ; Return round(R) "," round(G) "," round(B)
   ; Return (R) "," (G) "," (B)
   Return [round(R), round(G), round(B)]
}

ConvertHueToRGB(v1, v2, vH) {
   vH := ((vH<0) ? ++vH : vH)
   vH := ((vH>1) ? --vH : vH)
   return  ((6 * vH) < 1) ? (v1 + (v2 - v1) * 6 * vH)
         : ((2 * vH) < 1) ? (v2)
         : ((3 * vH) < 2) ? (v1 + (v2 - v1) * ((2 / 3) - vH) * 6)
         : v1
}

Gdip_ErrrorHandler(errCode, throwErrorMsg, additionalInfo:="") {
   Static errList := {1:"Generic_Error", 2:"Invalid_Parameter"
         , 3:"Out_Of_Memory", 4:"Object_Busy"
         , 5:"Insufficient_Buffer", 6:"Not_Implemented"
         , 7:"Win32_Error", 8:"Wrong_State"
         , 9:"Aborted", 10:"File_Not_Found"
         , 11:"Value_Overflow", 12:"Access_Denied"
         , 13:"Unknown_Image_Format", 14:"Font_Family_Not_Found"
         , 15:"Font_Style_Not_Found", 16:"Not_TrueType_Font"
         , 17:"Unsupported_GdiPlus_Version", 18:"Not_Initialized"
         , 19:"Property_Not_Found", 20:"Property_Not_Supported"
         , 21:"Profile_Not_Found", 100:"Unknown_Wrapper_Error"}

   If !errCode
      Return

   aerrCode := (errCode<0) ? 100 : errCode
   If errList.HasKey(aerrCode)
      GdipErrMsg := "GDI+ ERROR: " errList[aerrCode]  " [CODE: " aerrCode "]" additionalInfo
   Else
      GdipErrMsg := "GDI+ UNKNOWN ERROR: " aerrCode additionalInfo

   If (throwErrorMsg=1)
      MsgBox(GdipErrMsg, "GDI+ ERROR")

   Return GdipErrMsg
}

; Based on WinGetClientPos by dd900 and Frosti - https://www.autohotkey.com/boards/viewtopic.php?t=484
WinGetRect( hwnd, &x:="", &y:="", &w:="", &h:="" ) {
	Ptr := A_PtrSize ? "UPtr" : "UInt"
	CreateRect(&winRect, 0, 0, 0, 0) ;is 16 on both 32 and 64
	; winRect:=buffer( 16, 0 )	; Alternative of above two lines
	DllCall( "GetWindowRect", "Ptr", hwnd, "Ptr", winRect )
	x := NumGet(winRect,  0, "UInt")
	y := NumGet(winRect,  4, "UInt")
	w := NumGet(winRect,  8, "UInt") - x
	h := NumGet(winRect, 12, "UInt") - y
}