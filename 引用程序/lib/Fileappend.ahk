FileAppend(text, FileName := "", Encoding := "UTF-8")
{
	if !Filename
		FileName := A_Desktop "\debug.log"
	FileAppend, % text, % Filename, % Encoding
}