;|2.1|2023.07.23|1377
CandySel := A_Args[1]
if !CandySel             ; 多个文件
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}
Loop Parse, CandySel, `n, `r
{
	if A_LoopField
		File_changeuri2char(A_LoopField)
}
Return

File_changeuri2char(filename)
{
	SplitPath, filename, CandySel_FileName, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt, CandySel_Drive
	new_FileNameNoExt := UrlDecode(CandySel_FileNameNoExt)
	new_FileNameNoExt := SafeFileName(new_FileNameNoExt)
	if (CandySel_FileNameNoExt != new_FileNameNoExt)
		FileMove, %filename%, % PathU(CandySel_ParentPath "\" new_FileNameNoExt "." CandySel_Ext)
}

UrlDecode(Uri, Enc = "UTF-8")
{
   Pos := 1
   Loop
   {
      Pos := RegExMatch(Uri, "i)(?:%[\da-f]{2})+", Code, Pos++)
      If (Pos = 0)
         Break
      VarSetCapacity(Var, StrLen(Code) // 3, 0)
      StringTrimLeft, Code, Code, 1
      Loop, Parse, Code, `%
         NumPut("0x" . A_LoopField, Var, A_Index - 1, "UChar")
      StringReplace, Uri, Uri, `%%Code%, % StrGet(&Var, Enc), All
   }
   Return, Uri
}

SafeFileName(String)
{
	IllegalLetter := "<,>,|,/,\,"",?,*,:,`n,`r,`t"
	Loop, parse, IllegalLetter, `,
		String := StrReplace(String, A_LoopField)
	String := LTrim(String, " ")
	return String
}

PathU(sFile) {                     ; PathU v0.90 by SKAN on D35E/D35F @ tiny.cc/pathu 
Local Q, F := VarSetCapacity(Q,520,0) 
  DllCall("kernel32\GetFullPathNameW", "WStr",sFile, "UInt",260, "Str",Q, "PtrP",F)
  DllCall("shell32\PathYetAnotherMakeUniqueName","Str",Q, "Str",Q, "Ptr",0, "Ptr",F)
Return A_IsUnicode ? Q : StrGet(&Q, "UTF-16")
}