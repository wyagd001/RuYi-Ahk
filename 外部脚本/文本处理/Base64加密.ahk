;|2.0|2023.07.01|1337
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}

newStr := Base64Encode(CandySel)
GuiText(newStr, "Base64加密", 420)
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

Base64Encode(ByRef StrOrBin, nBytes := 0, LineLength := 64, LeadingSpaces := 0)
{ ; By SKAN / 18-Aug-2017
	Local Rqd := 0, B64, B := "", N := 0 - LineLength + 1  ; CRYPT_STRING_BASE64 := 0x1
	if !nBytes     ; 如果传入的是字符串, 先转换为 utf-8 编码数据
	{
		nBytes := StrPutVar(StrOrBin, Bin, "UTF-8") - 1
		Bin_Address := &Bin
	}
	else
		Bin_Address := &StrOrBin
	DllCall("Crypt32.dll\CryptBinaryToString", "Ptr", Bin_Address, "UInt", nBytes, "UInt", 0x1, "Ptr", 0, "UIntP", Rqd)
  VarSetCapacity(B64, Rqd * ( A_Isunicode ? 2 : 1 ), 0)
  DllCall("Crypt32.dll\CryptBinaryToString", "Ptr", Bin_Address, "UInt", nBytes, "UInt", 0x1, "Str", B64, "UIntP", Rqd)
  If (LineLength = 64 and !LeadingSpaces)
    Return B64
  B64 := StrReplace(B64, "`r`n")        
  Loop % Ceil(StrLen(B64) / LineLength)
    B .= Format("{1:" LeadingSpaces "s}", "") . SubStr(B64, N += LineLength, LineLength) . "`n" 
	Return RTrim(B, "`n")    
}

StrPutVar(Str, ByRef Var, Enc = "", ExLen = 0)
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1) + ExLen
	VarSetCapacity(Var, Len, 0)
	Return StrPut(Str, &Var, Enc)
}