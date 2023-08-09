DeBugBin(Var, Size := 20, FileName := "")
{
	if !FileName
		FileName := A_Desktop "\debug.bin"
	file := FileOpen(FileName, "rw")
	hSize := File.RawWrite(Var, Size)
	File.Close()
	return hSize
}