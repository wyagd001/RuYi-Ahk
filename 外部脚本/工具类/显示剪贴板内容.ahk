;|2.5|2024.02.12|1550
#Include <ImagePut>
;#Include <Gdip>

sleep 600
clip := ClipboardAll
if !A_Clipboard && !clip
{
	msgbox 剪贴板为空
	exitapp
}
if DllCall("IsClipboardFormatAvailable", "Uint", 1) or DllCall("IsClipboardFormatAvailable", "Uint", 13)
{
	;tooltip 22222
	GuiText(A_Clipboard, "剪贴板中的文本")
}
else if DllCall("IsClipboardFormatAvailable", "Uint", 2)
{
	zoom:=1
	if (A_OSversion = "Win_7")
	{
		; Win7 系统无法使用 ImagePutWindow 来显示剪贴板
		;windowsid := ImagePutWindow(ClipboardAll, "剪贴板中的图片")
		windowsid := ImageShow(ClipboardAll)
	}
	else
		windowsid := ImagePutWindow(ClipboardAll, "剪贴板中的图片")
	jiancck:=1
	;tooltip 33333 %windowsid%
	loop
	{
		if jiancck && !WinExist("ahk_id " windowsid)
			exitapp
	}
}
else if DllCall( "IsClipboardFormatAvailable", "UInt", 15)
{
	GuiText("剪贴板中的内容是文件`n" A_Clipboard, "剪贴板中的文件")
}
else
msgbox % GetClipboardFormat(0)
return

/*

ImagePutWindow({image: "x:\1.jpg", scale: 1.25})           ; 放大到1.25倍。 scale 可以是小数
ImagePutWindow({image: "x:\1.jpg", scale: 0.5})            ; 缩小到0.5倍。 scale 可以是小数
ImagePutWindow({image: "x:\1.jpg", scale: [300, 600]})     ; 将图片缩放为 300x600 （注意：指定完整宽高的缩放将无视图片原始宽高比）
ImagePutWindow({image: "x:\1.jpg", scale: [300, ""]})      ; 将图片宽度缩放为300 高度按原始宽高比自动缩放
ImagePutWindow({image: "x:\1.jpg", scale: ["auto", 600]})  ; 将图片高度缩放为600 宽度按原始宽高比自动缩放

ImagePutWindow({image: "x:\1.jpg", crop: [0, 0, -100, 200]})          ; 格式 [X, Y, W, H] 。这里表示：宽度减少100像素 高度保留200像素
ImagePutWindow({image: "x:\1.jpg", crop: [0, "10%", "50%", "-20%"]})  ; 百分比要加引号。这里表示：从顶端10%的位置开始裁剪 并且宽度保留50% 高度减少20%
*/

WheelDown::
if !DllCall("IsClipboardFormatAvailable", "Uint", 2)
Return
	zoom-=0.1
	jiancck := 0
	WinClose, ahk_id %windowsid%
	if (A_OSversion = "Win_7")
	{
		windowsid := ImagePut("show", {image: ClipboardAll, scale: zoom}, "剪贴板中的图片")
	}
	else
		windowsid := ImagePut("window", {image: ClipboardAll, scale: zoom}, "剪贴板中的图片")     ;crop字段为optional
	ToolTip, % "缩放率：" Round(zoom,1)
	jiancck := 1
Return

Wheelup::
if !DllCall("IsClipboardFormatAvailable", "Uint", 2)
Return
	zoom+=0.1
	jiancck := 0
	WinClose, ahk_id %windowsid%
	if (A_OSversion = "Win_7")
	{
		windowsid := ImagePut("show", {image: ClipboardAll, scale: zoom}, "剪贴板中的图片")
	}
	else
		windowsid := ImagePut("window", {image: ClipboardAll, scale: zoom}, "剪贴板中的图片")     ;crop字段为optional
	ToolTip, % "缩放率：" Round(zoom,1)
	jiancck := 1
Return

GetClipboardFormat(type=1)  ;Thanks nnnik
{
	Critical, On  
	DllCall("OpenClipboard", "int", "")
	while c := DllCall("EnumClipboardFormats", "Int", c?c:0)
		x .= "," c
	DllCall("CloseClipboard")
	Critical, OFF    ; 在开始执行段使用该函数，使所有后续线程变为不可中断，脚本会卡死，所以需要关闭
	if type=1
		if Instr(x, ",1") and Instr(x, ",13")
		return 1
		else If Instr(x, ",15")
		return 2
		else
		return ""
	else
		return x
}

/*
fmt =
(
CF_TEXT             , 1
CF_BITMAP           , 2
CF_METAFILEPICT     , 3
CF_SYLK             , 4
CF_DIF              , 5
CF_TIFF             , 6
CF_OEMTEXT          , 7
CF_DIB              , 8
CF_PALETTE          , 9
CF_PENDATA          , 10
CF_RIFF             , 11
CF_WAVE             , 12
CF_UNICODETEXT      , 13
CF_ENHMETAFILE      , 14
CF_HDROP            , 15
CF_LOCALE           , 16
CF_DIBV5            , 17
CF_MAX              , 18
CF_OWNERDISPLAY     , 0x0080
CF_DSPTEXT          , 0x0081
CF_DSPBITMAP        , 0x0082
CF_DSPMETAFILEPICT  , 0x0083
CF_DSPENHMETAFILE   , 0x008E
CF_PRIVATEFIRST     , 0x0200
CF_PRIVATELAST      , 0x02FF
CF_GDIOBJFIRST      , 0x0300
CF_GDIOBJLAST       , 0x03FF
)
*/

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
	exitapp
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
AutoXYWH(DimSize, cList*){       ; https://www.autohotkey.com/boards/viewtopic.php?t=1079
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