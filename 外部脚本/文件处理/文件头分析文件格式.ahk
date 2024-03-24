;|2.5|2024.03.24|1567
CandySel := A_Args[1]
msgbox % File_GetExt(CandySel)

File_GetExt(aFile, aNumBytes = 0, aMinimum = 4)
{
	if !FileExist(aFile) or InStr(FileExist(aFile), "D")
		return 0

	_rawBytes := ""
	_hFile := FileOpen(aFile, "r")
	; force position to 0 (zero)
	_hFile.Position := 0
	_nBytes := (_hFile.length < 1024) ? (_hFile.RawRead(_rawBytes, _hFile.length)) : (aNumBytes = 0) ? (_hFile.RawRead(_rawBytes, 1026)) : (_hFile.RawRead(_rawBytes, aNumBytes))
	_hFile.Close()

	; Initialize vars
	_t := 0, _i := 0, _bytesArr := []

	loop % _nBytes ; create c-style _bytesArr array
		_bytesArr[(A_Index - 1)] := Numget(&_rawBytes, (A_Index - 1), "UChar")

	; determine BOM if possible/existant
	if ((_bytesArr[0] = 0xFE) && (_bytesArr[1] = 0xFF))
	{
		; text Utf-16 BE File
		return "CP1201"
	}
	if ((_bytesArr[0] = 0xFF) && (_bytesArr[1] = 0xFE))
	{
		; text Utf-16 LE File
		return "UTF-16"
	}
	if ((_bytesArr[0] = 0xEF) && (_bytesArr[1] = 0xBB) && (_bytesArr[2] = 0xBF))
	{
		; text Utf-8 File
		return "UTF-8"
	}
	if ((_bytesArr[0] = 0x00) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0xFE) && (_bytesArr[3] = 0xFF))
	|| ((_bytesArr[0] = 0xFF) && (_bytesArr[1] = 0xFE) && (_bytesArr[2]= 0x00) && (_bytesArr[3] = 0x00))
	{
		; text Utf-32 BE/LE File
		return "UTF-32"
	}
	else if ((_bytesArr[0] = 0x00) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0x00) && (_bytesArr[4] = 0x66) && (_bytesArr[5] = 0x74) && (_bytesArr[6] = 0x79) && (_bytesArr[7] = 0x70) && (_bytesArr[8] = 0x33) && (_bytesArr[9] = 0x67) && (_bytesArr[10] = 0x70))
	{
		return "3gp"
	}
	else if ((_bytesArr[0] = 0x37) && (_bytesArr[1] = 0x7A) && (_bytesArr[2] = 0xBC) && (_bytesArr[3] = 0xAF))
	&& ((_bytesArr[4] = 0x27) && (_bytesArr[5] = 0x1C))
	{
		return "7z"
	}
	else if ((_bytesArr[0] = 0x42) && (_bytesArr[1] = 0x4D))
	{
		return "bmp"
	}
	else if ((_bytesArr[0] = 0x4D) && (_bytesArr[1] = 0x5A) && (_bytesArr[2] = 0x90))
	{
		return "exe/dll"
	}
	else if ((_bytesArr[0] = 0xD0) && (_bytesArr[1] = 0xCF) && (_bytesArr[2] = 0x11) && (_bytesArr[3] = 0xE0))
	{
		return "doc/xls"
	}
	else if ((_bytesArr[0] = 0x47) && (_bytesArr[1] = 0x49) && (_bytesArr[2] = 0x46) && (_bytesArr[3] = 0x38))
	{
		return "gif"
	}
	else if ((_bytesArr[0] = 0x00) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0x01) && (_bytesArr[3] = 0x00))
	{
		return "ico"
	}
	else if ((_bytesArr[0] = 0xFF) && (_bytesArr[1] = 0xD8) && (_bytesArr[2] = 0xFF))
	{
		return "jpg"
	}

	else if ((_bytesArr[0] = 0x4C) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0x00))
	{
		return "lnk"
	}
	else if ((_bytesArr[0] = 0x49) && (_bytesArr[1] = 0x44) && (_bytesArr[2] = 0x33))
	{
		return "mp3"
	}
	else if ((_bytesArr[0] = 0x00) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0x00) && (_bytesArr[3] = 0x18) && (_bytesArr[4] = 0x66) && (_bytesArr[5] = 0x74) && (_bytesArr[6] = 0x79) && (_bytesArr[7] = 0x70) && (_bytesArr[8] = 0x6D) && (_bytesArr[9] = 0x70) && (_bytesArr[10] = 0x34) && (_bytesArr[11] = 0x32))
	{
		return "mp4"
	}
	else if ((_bytesArr[0] = 0x25) && (_bytesArr[1] = 0x50) && (_bytesArr[2] = 0x44))
	{
		return "pdf"
	}
	else if ((_bytesArr[0] = 0x89) && (_bytesArr[1] = 0x50) && (_bytesArr[2] = 0x4E) && (_bytesArr[3] = 0x47))
	{
		return "png"
	}
	else if ((_bytesArr[0] = 0x52) && (_bytesArr[1] = 0x61) && (_bytesArr[2] = 0x72))
	{
		return "rar"
	}
	else if ((_bytesArr[0] = 0x2E) && (_bytesArr[1] = 0x52) && (_bytesArr[2] = 0x4D))
	{
		return "rm/rmvb"
	}
	else if ((_bytesArr[0] = 0x52) && (_bytesArr[1] = 0x49) && (_bytesArr[2] = 0x46) && (_bytesArr[3] = 0x46))
	&& ((_bytesArr[8] = 0x57) && (_bytesArr[9] = 0x45) && (_bytesArr[10]= 0x42) && (_bytesArr[11] = 0x50))
	{
		return "webp"
	}
	else if ((_bytesArr[0] = 0x50) && (_bytesArr[1] = 0x4B) && (_bytesArr[2] = 0x03) && (_bytesArr[3] = 0x04))
	{
		return "zip"
	}
}