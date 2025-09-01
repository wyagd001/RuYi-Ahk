;|2.2|2023.08.10|1067
#Include <File_GetEncoding>
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}
Cando_合并文本文件:
loop, parse, CandySel, `n, `r
{
	SplitPath, A_LoopField,, OutDir
	break
}
loop, parse, CandySel, `n, `r
{
	SplitPath, A_LoopField, oFileName
	FileList .= oFileName "`n"
}
;msgbox % FileList " - " OutDir
Sort, FileList
Loop, parse, FileList, `n
{
	SplitPath, A_LoopField, , , File_Ext, ,
	If File_Ext in txt,ahk,ini,js,vbs,bat
	{
		FileEncoding, % File_GetEncoding(OutDir "\" A_LoopField)
		Fileread, FileR_TFC, %OutDir%\%A_loopfield%
		;msgbox % FileR_TFC " - " A_LoopField
		Tmp_Str = %Tmp_Str%%FileR_TFC%`r`n
	}
}
Tmp_Str := Rtrim(Tmp_Str, "`r`n")
FileAppend, %Tmp_Str%, %OutDir%\合并.txt
Tmp_Str := FileR_TFC := FileList := ""
Return