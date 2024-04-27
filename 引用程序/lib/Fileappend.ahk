FileAppend(text, FileName := "", Encoding := "UTF-8")
{
	if !Filename
		FilePath := A_Desktop "\debug.log"
	else
	{
		If !instr(fileName, "\")
			FilePath := A_Desktop "\" FileName
		else
			FilePath := FileName
	}
	FileAppend, % text, % FilePath, % Encoding
}