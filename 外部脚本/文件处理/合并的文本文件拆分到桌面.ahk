;|2.7|2024.06.20|1623
CandySel := A_Args[1]

Loop, Read, % CandySel
{
	if (instr(A_LoopReadLine, ";自拆分文件") = 1)
	{
    if pre_Tmp_File
    {
      FileSetTime, % CreateTime, % Tmp_File, C
      FileSetTime, % ModifyTime, % Tmp_File, M
    }
		Tmp_Arr := GetStringIndex(A_LoopReadLine, , , " | ")
		FileEncoding, % Tmp_Arr[4]
		Tmp_File := A_desktop "\拆分的\" Tmp_Arr[2]
    CreateTime := Tmp_Arr[6]
    ModifyTime := Tmp_Arr[7]
		CreateFolder(Tmp_File)
		FileAppend,, % Tmp_File
		continue
	}
	if (Tmp_File != pre_Tmp_File)
	{
		FileAppend, % A_LoopReadLine , % Tmp_File
		pre_Tmp_File := Tmp_File
	}
	else
		FileAppend, % "`r`n" A_LoopReadLine , % Tmp_File
}
return

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

CreateFolder(filepath)
{
	SplitPath, filepath,, OutDir
	if !InStr(FileExist(OutDir), "D")
		FileCreateDir % OutDir
}