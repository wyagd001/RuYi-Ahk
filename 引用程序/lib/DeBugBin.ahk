DeBugBin(ByRef Var, Size := 20, FileName := "")
{
	if !FileName
		FilePath := A_Desktop "\debug.bin"
	else
	{
		If !instr(fileName, "\")
			FilePath := A_Desktop "\" FileName
		else
			FilePath := FileName
	}
	File := FileOpen(FilePath, "rw")
	hSize := File.RawWrite(Var, Size)
	File.Close()
	return hSize
}