;|2.0|2023.07.01|1336

CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}

CandySel := StrReplace(CandySel, "`r")
CandySel := StrReplace(CandySel, "`n")
CandySel := StrReplace(CandySel, "`t")
CandySel := StrReplace(CandySel, " ")
CandySel := StrReplace(CandySel, """")
CandySel := StrReplace(CandySel, ".")

Base64Decode(CandySel, bin)
newStr := StrGet(&bin, "UTF-8")
GuiText(newStr, "Base64解密")
return

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	ExitApp
	Return
}

Base64Decode(ByRef B64, ByRef Bin) {  ; By SKAN / 18-Aug-2017
Local Rqd := 0, BLen := StrLen(B64)                 ; CRYPT_STRING_BASE64 := 0x1
  DllCall("Crypt32.dll\CryptStringToBinary", "Str", B64, "UInt", BLen, "UInt", 0x1
         , "UInt", 0, "UIntP", Rqd, "Int", 0, "Int", 0)
  VarSetCapacity(Bin, 128), VarSetCapacity(Bin, 0),  VarSetCapacity(Bin, Rqd, 0)
  DllCall("Crypt32.dll\CryptStringToBinary", "Str", B64, "UInt", BLen, "UInt", 0x1
         , "Ptr", &Bin, "UIntP", Rqd, "Int", 0, "Int", 0)
Return Rqd
}