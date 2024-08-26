;|2.7|2024.06.26|1530
区域选择方式 = 1
pToken := Gdip_Startup()

if(区域选择方式 = 1)
{
	cstip=
	(LTrim
		按住鼠标左键拖选截图区域
		"Esc/右键"键，退出
	)
}
else if(区域选择方式 = 2)
{
	cstip=
  (LTrim
		点击"左键"开始选取，移动鼠标，再次点击"左键"结束
		"Esc/右键"键，退出
	)
}
gosub, Tip_info
gosub, SelectCaptureArea
Return

Esc::ExitApp

#IfWinNotActive,  ahk_class AutoHotkeyGUI
Rbutton:: ExitApp
#IfWinNotActive

SelectCaptureArea:
CoordMode, Mouse, Screen
; 区域截图选取截图区域方法1
if(区域选择方式 = 1)
{
	selobj := GetArea()
	aRect := selobj.x "|" selobj.y "|" selobj.w "|" selobj.h

	;~ ;快门声音
	IfExist, %A_ScriptDir%\..\..\脚本图标\shutter.wav
		SoundPlay, %A_ScriptDir%\..\..\脚本图标\shutter.wav

	;Tooltip %aRect%
	sleep,100
}
; 区域截图选取截图区域方法2
else if(区域选择方式 = 2)
{
	Loop
	{
		Sleep, 10
		KeyIsDown := GetKeyState("LButton")
		if (KeyIsDown = 1)
		{
			TrayTip
			MouseGetPos, MX, MY
			Gui, +LastFound
			Gui, +AlwaysOnTop -caption +Border +ToolWindow +LastFound
			WinSet, Transparent, 80
			Gui, Color, EEAA99
			Sleep, 500
			Loop
			{
				sleep, 10
				KeyIsDown := GetKeyState("LButton")
				MouseGetPos, MXend, MYend
				w := abs(MX - MXend), h := abs(MY - MYend)
				X := (MX < MXend) ? MX : MXend
				Y := (MY < MYend) ? MY : MYend
				Gui, Show, x%X% y%Y% w%w% h%h%

				if (KeyIsDown = 1)
				{
					If ((w < 10) or (h < 10))
					{
						TrayTip,警告,两次点击间距过小或者未按提示进行操作，脚本重新启动,3,18
						sleep,3000
						reload
					}
					If ( MX > MXend )
						Swap(MX, MXend)
					If ( MY > MYend )
						Swap(MY, MYend)

					aRect :=  MX "|" MY "|" MXend "|" MYend
					IfExist, %A_ScriptDir%\..\..\脚本图标\shutter.wav
						SoundPlay, %A_ScriptDir%\..\..\脚本图标\shutter.wav
					Gui, Destroy
					;Gui, Font, s10
					;Gui, Add, Text, , >>>>选定的区域已经截图，回车继续
					;Gui, Destroy
					;tooltip % aRect
					break 2
				}
			}
		}
	}
}
pBitmap := Gdip_BitmapFromScreen(aRect)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
hw := GetStringIndex(aRect, 3), hh := GetStringIndex(aRect, 4), bhh := hh+5
;Gui, +hwndquyujt
Gui, Add, Picture, w%hw% h%hh% vprev_pic, HBITMAP:%hBitmap%
Gui, Add, Button, x5 yp+%bhh% gocr w40 vocr, OCR
Gui, Add, Button, xp+45 yp gOCR2 w60 vocr2, 本地OCR
Gui, Add, Button, xp+65 yp gmspaint w40, 画图
Gui, Add, Button, xp+45 yp gsave w40, 保存
Gui, Add, Button, xp+45 yp gsavas w50, 另存为
Gui, Add, Button, xp+55 yp gclip w50, 剪贴板
Gui, Add, Button, xp+55 yp gRCap w55, 重新截图
Gui, Add, Button, xp+60 yp gBreload w40, 重启
Gui, Add, Button, xp+45 yp gguiclose w40, 退出
Gui, Add, text, x5 yp+30 w60, 文件名:
Gui, Add, Edit, xp+50 yp vjtfn w300, 
Gui, Add, Button, xp+310 yp gQRcodeReader w80, 二维码识别
Gui Show
if A_OSVersion in Win_7,Win_8,Win_8.1
	GuiControl, Disable, ocr
if !fileexist(A_ScriptDir "\..\..\引用程序\其它资源\leptonica_util") or !fileexist(A_ScriptDir "\..\..\引用程序\其它资源\tesseract")
	GuiControl, Disable, ocr2
Return

save:
gui, submit, NoHide
if jtfn
	JTFilePath := A_ScriptDir "\..\..\截图目录\" SafeFileName(jtfn) ".png"
else
	JTFilePath := A_ScriptDir "\..\..\截图目录\区域截图_" A_Now ".png"
if FileExist(JTFilePath)
{
	msgbox, 51, 警告, % "文件已存在, 是否覆盖?"
	IfMsgBox, No
		return
	IfMsgBox, Cancel
		return
}
Gdip_SaveBitmapToFile(pBitmap, JTFilePath)
Gdip_DisposeImage(pBitmap)
DeleteObject(hBitmap)
gosub guiclose
Return

ocr:
hBitmap1 := Gdip_CreateHBITMAPFromBitmap(pBitmap)
pIRandomAccessStream := HBitmapToRandomAccessStream(hBitmap1)
text := ocr(pIRandomAccessStream, "zh-Hans-CN")
DeleteObject(hBitmap1)
Gdip_DisposeImage(pBitmap)
if text
   GuiText(text, "区域截图 - OCR")
else
   gosub guiclose
Return

; 本地 OCR, %Ahk% %OCR% %Picfile%
OCR2:
JTFilePath := A_temp "\Vis2_123.bmp"
Gdip_SaveBitmapToFile(pBitmap, JTFilePath)
B_Autohotkey := A_ScriptDir "\..\..\引用程序\" (A_PtrSize = 8 ? "AutoHotkeyU64.exe" : "AutoHotkeyU32.exe")
run %B_Autohotkey% "%A_ScriptDir%\..\文件处理\本地OCR(Vis2).ahk" "%JTFilePath%"
;run %B_Autohotkey% "%A_ScriptDir%\PaddleOCR_身份证识别验证.ahk" "%JTFilePath%"
;AutoHotkey64 := A_ScriptDir "\..\..\引用程序\2.0\AutoHotkey64.exe"
;run %AutoHotkey64% "%A_ScriptDir%\RapidOcrOnnx.ahk2" "%JTFilePath%"
return

QRcodeReader:
JTFilePath := A_temp "\ewm_123.png"
Gdip_SaveBitmapToFile(pBitmap, JTFilePath)
QRText := RunCmd(A_ScriptDir "\..\..\引用程序\x32\ewm.exe """ JTFilePath """")
GuiText(QRText, "区域截图 - 二维码识别结果")
return

mspaint:
Gdip_SetBitmapToClipboard(pBitmap)
Gdip_DisposeImage(pBitmap)
DeleteObject(hBitmap)
run mspaint
sleep 800
send ^v
gosub guiclose
return

clip:
Gdip_SetBitmapToClipboard(pBitmap)
Gdip_DisposeImage(pBitmap)
DeleteObject(hBitmap)
gosub guiclose
return

savas:
FileSelectFile, savefile, S2, , 截图另存为, 图片文件 (*.jpg; *.png; *.bmp)
if !RegExMatch(savefile, "(\.jpg)|(\.png)|(\.bmp)$")
  savefile := savefile ".png"
Gdip_SaveBitmapToFile(pBitmap, savefile)
Gdip_DisposeImage(pBitmap)
DeleteObject(hBitmap)
gosub guiclose
Return

RCap:
gui, Destroy
gosub SelectCaptureArea
return

Breload:
reload
return

guiclose:
GuiEscape:
gui, Destroy
exitapp

SafeFileName(String)
{
	IllegalLetter := "<,>,|,/,\,"",?,*,:,`n,`r,`t"
	Loop, parse, IllegalLetter, `,
		String := StrReplace(String, A_LoopField)
	String := LTrim(String, " ")
	return String
}

GetArea() {
   area := []
   StartSelection(area)
   while !area.w
      Sleep, 100
   Return area
}

StartSelection(area) {
   handler := Func("Select").Bind(area)
   Hotkey, LButton, % handler, On
   ReplaceSystemCursors("IDC_CROSS")
}

Select(area) {
	static hGui
	if !hGui
		hGui := CreateSelectionGui()
	;tooltip % hGui
	Hook := new WindowsHook(WH_MOUSE_LL := 14, "LowLevelMouseProc", hGui)  ;  鼠标钩子
	Loop {
		KeyWait, LButton
		WinGetPos, X, Y, W, H, ahk_id %hGui%
	} until w > 0
	ReplaceSystemCursors("")
	Hotkey, LButton, Off
	Hook := ""
	;Gui, %hGui%:Color, 0058EE
	Gui, %hGui%: Destroy
	hGui := 0
   for k, v in ["x", "y", "w", "h"]
      area[v] := %v%
}

ReplaceSystemCursors(IDC = "")
{
   static IMAGE_CURSOR := 2, SPI_SETCURSORS := 0x57
        , exitFunc := Func("ReplaceSystemCursors").Bind("")
        , SysCursors := { IDC_APPSTARTING: 32650
                        , IDC_ARROW      : 32512
                        , IDC_CROSS      : 32515
                        , IDC_HAND       : 32649
                        , IDC_HELP       : 32651
                        , IDC_IBEAM      : 32513
                        , IDC_NO         : 32648
                        , IDC_SIZEALL    : 32646
                        , IDC_SIZENESW   : 32643
                        , IDC_SIZENWSE   : 32642
                        , IDC_SIZEWE     : 32644
                        , IDC_SIZENS     : 32645 
                        , IDC_UPARROW    : 32516
                        , IDC_WAIT       : 32514 }
   if !IDC {
      DllCall("SystemParametersInfo", UInt, SPI_SETCURSORS, UInt, 0, UInt, 0, UInt, 0)
      OnExit(exitFunc, 0)
   }
   else  {
      hCursor := DllCall("LoadCursor", Ptr, 0, UInt, SysCursors[IDC], Ptr)
      for k, v in SysCursors  {
         hCopy := DllCall("CopyImage", Ptr, hCursor, UInt, IMAGE_CURSOR, Int, 0, Int, 0, UInt, 0, Ptr)
         DllCall("SetSystemCursor", Ptr, hCopy, UInt, v)
      }
      OnExit(exitFunc)
   }
}

CreateSelectionGui() {
   Gui, New, +hwndhGui +Alwaysontop -Caption +LastFound +ToolWindow +E0x20 -DPIScale
   WinSet, Transparent, 130
   Gui, Color, EEAA99
   Return hGui
}

LowLevelMouseProc(nCode, wParam, lParam) {
   static WM_MOUSEMOVE := 0x200, WM_LBUTTONUP := 0x202
        , timer := Func("LowLevelMouseProc").Bind("timer", "", "")
        , coords := [], startMouseX, startMouseY, hGui

   if (nCode = "timer") {
      while coords[1] {
         point := coords.RemoveAt(1)
         mouseX := point[1], mouseY := point[2]
         x := startMouseX < mouseX ? startMouseX : mouseX
         y := startMouseY < mouseY ? startMouseY : mouseY
         w := Abs(mouseX - startMouseX)
         h := Abs(mouseY - startMouseY)
         try Gui, %hGUi%: Show, x%x% y%y% w%w% h%h% NA
      }
   }
   else {
      (!hGui && hGui := A_EventInfo)
      if (wParam = WM_LBUTTONUP)
         startMouseX := startMouseY := "", hGui := ""
      if (wParam = WM_MOUSEMOVE)  {
         mouseX := NumGet(lParam + 0, "Int")
         mouseY := NumGet(lParam + 4, "Int")
         if (startMouseX = "") {
            startMouseX := mouseX
            startMouseY := mouseY
         }
         coords.Push([mouseX, mouseY])
         SetTimer, % timer, -10
      }
      Return DllCall("CallNextHookEx", Ptr, 0, Int, nCode, UInt, wParam, Ptr, lParam)
   }
}

class WindowsHook {
   __New(type, callback, eventInfo := "", isGlobal := true) {
      this.callbackPtr := RegisterCallback(callback, "Fast", 3, eventInfo)
      this.hHook := DllCall("SetWindowsHookEx", "Int", type, "Ptr", this.callbackPtr
                                              , "Ptr", !isGlobal ? 0 : DllCall("GetModuleHandle", "UInt", 0, "Ptr")
                                              , "UInt", isGlobal ? 0 : DllCall("GetCurrentThreadId"), "Ptr")
;tooltip  新建
   }
   __Delete() {
      DllCall("UnhookWindowsHookEx", "Ptr", this.hHook)
      DllCall("GlobalFree", "Ptr", this.callBackPtr, "Ptr")
;tooltip  注销
   }
}

Swap(ByRef Left, ByRef Right)
{
   temp := Left
   Left := Right
   Right := temp
}

Tip_info:
TrayTip, 截图进行中..., %cstip%,, 17
Return

HBitmapToRandomAccessStream(hBitmap) {
   static IID_IRandomAccessStream := "{905A0FE1-BC53-11DF-8C49-001E4FC686DA}"
        , IID_IPicture            := "{7BF80980-BF32-101A-8BBB-00AA00300CAB}"
        , PICTYPE_BITMAP := 1
        , BSOS_DEFAULT   := 0
        
   DllCall("Ole32\CreateStreamOnHGlobal", "Ptr", 0, "UInt", true, "PtrP", pIStream, "UInt")
   
   VarSetCapacity(PICTDESC, sz := 8 + A_PtrSize*2, 0)
   NumPut(sz, PICTDESC)
   NumPut(PICTYPE_BITMAP, PICTDESC, 4)
   NumPut(hBitmap, PICTDESC, 8)
   riid := CLSIDFromString(IID_IPicture, GUID1)
   DllCall("OleAut32\OleCreatePictureIndirect", "Ptr", &PICTDESC, "Ptr", riid, "UInt", false, "PtrP", pIPicture, "UInt")
   ; IPicture::SaveAsFile
   DllCall(NumGet(NumGet(pIPicture+0) + A_PtrSize*15), "Ptr", pIPicture, "Ptr", pIStream, "UInt", true, "UIntP", size, "UInt")

   riid := CLSIDFromString(IID_IRandomAccessStream, GUID2)
   DllCall("ShCore\CreateRandomAccessStreamOverStream", "Ptr", pIStream, "UInt", BSOS_DEFAULT, "Ptr", riid, "PtrP", pIRandomAccessStream, "UInt")
   ObjRelease(pIPicture)
   ObjRelease(pIStream)
   Return pIRandomAccessStream
}

CLSIDFromString(IID, ByRef CLSID) {
   VarSetCapacity(CLSID, 16, 0)
   if res := DllCall("ole32\CLSIDFromString", "WStr", IID, "Ptr", &CLSID, "UInt")
      throw Exception("CLSIDFromString failed. Error: " . Format("{:#x}", res))
   Return &CLSID
}

ocr(file, lang := "FirstFromAvailableLanguages")
{
   static OcrEngineStatics, OcrEngine, MaxDimension, LanguageFactory, Language, CurrentLanguage, BitmapDecoderStatics, GlobalizationPreferencesStatics
   if (OcrEngineStatics = "")
   {
      CreateClass("Windows.Globalization.Language", ILanguageFactory := "{9B0252AC-0C27-44F8-B792-9793FB66C63E}", LanguageFactory)
      CreateClass("Windows.Graphics.Imaging.BitmapDecoder", IBitmapDecoderStatics := "{438CCB26-BCEF-4E95-BAD6-23A822E58D01}", BitmapDecoderStatics)
      CreateClass("Windows.Media.Ocr.OcrEngine", IOcrEngineStatics := "{5BFFA85A-3384-3540-9940-699120D428A8}", OcrEngineStatics)
      DllCall(NumGet(NumGet(OcrEngineStatics+0)+6*A_PtrSize), "ptr", OcrEngineStatics, "uint*", MaxDimension)   ; MaxImageDimension
   }
   if (file = "ShowAvailableLanguages")
   {
      if (GlobalizationPreferencesStatics = "")
         CreateClass("Windows.System.UserProfile.GlobalizationPreferences", IGlobalizationPreferencesStatics := "{01BF4326-ED37-4E96-B0E9-C1340D1EA158}", GlobalizationPreferencesStatics)
      DllCall(NumGet(NumGet(GlobalizationPreferencesStatics+0)+9*A_PtrSize), "ptr", GlobalizationPreferencesStatics, "ptr*", LanguageList)   ; get_Languages
      DllCall(NumGet(NumGet(LanguageList+0)+7*A_PtrSize), "ptr", LanguageList, "int*", count)   ; count
      loop % count
      {
         DllCall(NumGet(NumGet(LanguageList+0)+6*A_PtrSize), "ptr", LanguageList, "int", A_Index-1, "ptr*", hString)   ; get_Item
         DllCall(NumGet(NumGet(LanguageFactory+0)+6*A_PtrSize), "ptr", LanguageFactory, "ptr", hString, "ptr*", LanguageTest)   ; CreateLanguage
         DllCall(NumGet(NumGet(OcrEngineStatics+0)+8*A_PtrSize), "ptr", OcrEngineStatics, "ptr", LanguageTest, "int*", bool)   ; IsLanguageSupported
         if (bool = 1)
         {
            DllCall(NumGet(NumGet(LanguageTest+0)+6*A_PtrSize), "ptr", LanguageTest, "ptr*", hText)
            buffer := DllCall("Combase.dll\WindowsGetStringRawBuffer", "ptr", hText, "uint*", length, "ptr")
            text .= StrGet(buffer, "UTF-16") "`n"
         }
         ObjRelease(LanguageTest)
      }
      ObjRelease(LanguageList)
      return text
   }
   if (lang != CurrentLanguage) or (lang = "FirstFromAvailableLanguages")
   {
      if (OcrEngine != "")
      {
         ObjRelease(OcrEngine)
         if (CurrentLanguage != "FirstFromAvailableLanguages")
            ObjRelease(Language)
      }
      if (lang = "FirstFromAvailableLanguages")
         DllCall(NumGet(NumGet(OcrEngineStatics+0)+10*A_PtrSize), "ptr", OcrEngineStatics, "ptr*", OcrEngine)   ; TryCreateFromUserProfileLanguages
      else
      {
         CreateHString(lang, hString)
         DllCall(NumGet(NumGet(LanguageFactory+0)+6*A_PtrSize), "ptr", LanguageFactory, "ptr", hString, "ptr*", Language)   ; CreateLanguage
         DeleteHString(hString)
         DllCall(NumGet(NumGet(OcrEngineStatics+0)+9*A_PtrSize), "ptr", OcrEngineStatics, ptr, Language, "ptr*", OcrEngine)   ; TryCreateFromLanguage
      }
      if (OcrEngine = 0)
      {
         msgbox Can not use language "%lang%" for OCR, please install language pack.
         ExitApp
      }
      CurrentLanguage := lang
   }
   IRandomAccessStream := file
   DllCall(NumGet(NumGet(BitmapDecoderStatics+0)+14*A_PtrSize), "ptr", BitmapDecoderStatics, "ptr", IRandomAccessStream, "ptr*", BitmapDecoder)   ; CreateAsync
   WaitForAsync(BitmapDecoder)
   BitmapFrame := ComObjQuery(BitmapDecoder, IBitmapFrame := "{72A49A1C-8081-438D-91BC-94ECFC8185C6}")
   DllCall(NumGet(NumGet(BitmapFrame+0)+12*A_PtrSize), "ptr", BitmapFrame, "uint*", width)   ; get_PixelWidth
   DllCall(NumGet(NumGet(BitmapFrame+0)+13*A_PtrSize), "ptr", BitmapFrame, "uint*", height)   ; get_PixelHeight
   if (width > MaxDimension) or (height > MaxDimension)
   {
      msgbox Image is to big - %width%x%height%.`nIt should be maximum - %MaxDimension% pixels
      ExitApp
   }
   BitmapFrameWithSoftwareBitmap := ComObjQuery(BitmapDecoder, IBitmapFrameWithSoftwareBitmap := "{FE287C9A-420C-4963-87AD-691436E08383}")
   DllCall(NumGet(NumGet(BitmapFrameWithSoftwareBitmap+0)+6*A_PtrSize), "ptr", BitmapFrameWithSoftwareBitmap, "ptr*", SoftwareBitmap)   ; GetSoftwareBitmapAsync
   WaitForAsync(SoftwareBitmap)
   DllCall(NumGet(NumGet(OcrEngine+0)+6*A_PtrSize), "ptr", OcrEngine, ptr, SoftwareBitmap, "ptr*", OcrResult)   ; RecognizeAsync
   WaitForAsync(OcrResult)
   DllCall(NumGet(NumGet(OcrResult+0)+6*A_PtrSize), "ptr", OcrResult, "ptr*", LinesList)   ; get_Lines
   DllCall(NumGet(NumGet(LinesList+0)+7*A_PtrSize), "ptr", LinesList, "int*", count)   ; count
   loop % count
   {
      DllCall(NumGet(NumGet(LinesList+0)+6*A_PtrSize), "ptr", LinesList, "int", A_Index-1, "ptr*", OcrLine)
      DllCall(NumGet(NumGet(OcrLine+0)+7*A_PtrSize), "ptr", OcrLine, "ptr*", hText) 
      buffer := DllCall("Combase.dll\WindowsGetStringRawBuffer", "ptr", hText, "uint*", length, "ptr")
      text .= StrGet(buffer, "UTF-16") "`n"
      ObjRelease(OcrLine)
   }
   Close := ComObjQuery(IRandomAccessStream, IClosable := "{30D5A829-7FA4-4026-83BB-D75BAE4EA99E}")
   DllCall(NumGet(NumGet(Close+0)+6*A_PtrSize), "ptr", Close)   ; Close
   ObjRelease(Close)
   Close := ComObjQuery(SoftwareBitmap, IClosable := "{30D5A829-7FA4-4026-83BB-D75BAE4EA99E}")
   DllCall(NumGet(NumGet(Close+0)+6*A_PtrSize), "ptr", Close)   ; Close
   ObjRelease(Close)
   ObjRelease(IRandomAccessStream)
   ObjRelease(BitmapDecoder)
   ObjRelease(BitmapFrame)
   ObjRelease(BitmapFrameWithSoftwareBitmap)
   ObjRelease(SoftwareBitmap)
   ObjRelease(OcrResult)
   ObjRelease(LinesList)
   return text
}

CreateClass(string, interface, ByRef Class)
{
   CreateHString(string, hString)
   VarSetCapacity(GUID, 16)
   DllCall("ole32\CLSIDFromString", "wstr", interface, "ptr", &GUID)
   result := DllCall("Combase.dll\RoGetActivationFactory", "ptr", hString, "ptr", &GUID, "ptr*", Class)
   if (result != 0)
   {
      if (result = 0x80004002)
         msgbox No such interface supported
      else if (result = 0x80040154)
         msgbox Class not registered
      else
         msgbox error: %result%
      ExitApp
   }
   DeleteHString(hString)
}

CreateHString(string, ByRef hString)
{
    DllCall("Combase.dll\WindowsCreateString", "wstr", string, "uint", StrLen(string), "ptr*", hString)
}

DeleteHString(hString)
{
   DllCall("Combase.dll\WindowsDeleteString", "ptr", hString)
}

WaitForAsync(ByRef Object)
{
   AsyncInfo := ComObjQuery(Object, IAsyncInfo := "{00000036-0000-0000-C000-000000000046}")
   loop
   {
      DllCall(NumGet(NumGet(AsyncInfo+0)+7*A_PtrSize), "ptr", AsyncInfo, "uint*", status)   ; IAsyncInfo.Status
      if (status != 0)
      {
         if (status != 1)
         {
            DllCall(NumGet(NumGet(AsyncInfo+0)+8*A_PtrSize), "ptr", AsyncInfo, "uint*", ErrorCode)   ; IAsyncInfo.ErrorCode
            msgbox AsyncInfo status error: %ErrorCode%
            ExitApp
         }
         ObjRelease(AsyncInfo)
         break
      }
      sleep 10
   }
   DllCall(NumGet(NumGet(Object+0)+8*A_PtrSize), "ptr", Object, "ptr*", ObjectResult)   ; GetResults
   ObjRelease(Object)
   Object := ObjectResult
}

GetStringIndex(String, Index := "", MaxParts := -1, SplitStr := "|")
{
	arrCandy_Cmd_Str := StrSplit(String, SplitStr, " `t", MaxParts)
	if Index
	{
		NewStr := arrCandy_Cmd_Str[Index]
		return NewStr
	}
	else
		return arrCandy_Cmd_Str
}

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd +Resize
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	ExitApp
	Return

	GuiTextGuiSize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	AutoXYWH("wh", "myedit")
	return
}

; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
; ---------------------------------------------------------------------------------
; Version: 2015-5-29 / Added 'reset' option (by tmplinshi)
;          2014-7-03 / toralf
;          2014-1-2  / tmplinshi
; requires AHK version : 1.1.13.01+
; =================================================================================
AutoXYWH(DimSize, cList*){       ; http://ahkscript.org/boards/viewtopic.php?t=1079
  static cInfo := {}
 
  If (DimSize = "reset")
    Return cInfo := {}
 
  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If ( cInfo[ctrlID].x = "" ){
        GuiControlGet, i, %A_Gui%:Pos, %ctrl%
        MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
        fx := fy := fw := fh := 0
        For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
            If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
              f%dim% := 1
        cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
    }Else If ( cInfo[ctrlID].a.1) {
        dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
        For i, dim in cInfo[ctrlID]["a"]
            Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
        GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
} } }

RunCmd(CmdLine, WorkingDir:="", Cp:="CP0") { ; Thanks Sean!  SKAN on D34E @ tiny.cc/runcmd 
  Local P8 := (A_PtrSize=8),  pWorkingDir := (WorkingDir ? &WorkingDir : 0)                                                
  Local SI, PI,  hPipeR:=0, hPipeW:=0, Buff, sOutput:="",  ExitCode:=0,  hProcess, hThread
                   
  DllCall("CreatePipe", "PtrP",hPipeR, "PtrP",hPipeW, "Ptr",0, "UInt",0)
, DllCall("SetHandleInformation", "Ptr",hPipeW, "UInt",1, "UInt",1)
    
  VarSetCapacity(SI, P8? 104:68,0),      NumPut(P8? 104:68, SI)
, NumPut(0x100, SI,  P8? 60:44,"UInt"),  NumPut(hPipeW, SI, P8? 88:60)
, NumPut(hPipeW, SI, P8? 96:64)   

, VarSetCapacity(PI, P8? 24:16)               

  If not DllCall("CreateProcess", "Ptr",0, "Str",CmdLine, "Ptr",0, "UInt",0, "UInt",True
              , "UInt",0x08000000 | DllCall("GetPriorityClass", "Ptr",-1,"UInt"), "UInt",0
              , "Ptr",pWorkingDir, "Ptr",&SI, "Ptr",&PI )  
     Return Format( "{1:}", "" 
          , DllCall("CloseHandle", "Ptr",hPipeW)
          , DllCall("CloseHandle", "Ptr",hPipeR)
          , ErrorLevel := -1 )
  DllCall( "CloseHandle", "Ptr",hPipeW)

, VarSetCapacity(Buff, 4096, 0), nSz:=0   
  While DllCall("ReadFile",  "Ptr",hPipeR, "Ptr",&Buff, "UInt",4094, "PtrP",nSz, "UInt",0)
    sOutput .= StrGet(&Buff, nSz, Cp)

  hProcess := NumGet(PI, 0),  hThread := NumGet(PI,4)
, DllCall("GetExitCodeProcess", "Ptr",hProcess, "PtrP",ExitCode)
, DllCall("CloseHandle", "Ptr",hProcess),    DllCall("CloseHandle", "Ptr",hThread)
, DllCall("CloseHandle", "Ptr",hPipeR),      ErrorLevel := ExitCode  
Return sOutput  
}