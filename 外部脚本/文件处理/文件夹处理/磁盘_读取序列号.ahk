;|2.0|2023.07.01|1175
CandySel :=  A_Args[1]
CandySel := trim(CandySel, """")
; 格式化分区时产生的分区序列号(卷序列号, 磁盘序列号, VolumeId)
; 等同于 DriveGet, OutputVar, Serial, C:
; 获取 8 个字符长度的分区序列号
; 不同的是本函数在分区为 NTFS 格式时获取 16 个字符长度的分区序列号
Cando_GetVolumeId:
hVolume := Trim(CandySel, "\")
Tmp_Str := readSector(hVolume)
Tmp_Val := CF_GetDriveFS(CandySel)
if (Tmp_Val="NTFS")  ; NTFS格式
{
	Tmp_Str := SubStr(Tmp_Str, 145, 16)
	msgbox % Format("{:16X}", _byteswap_uint64("0x" Tmp_Str))
}
else if (Tmp_Val="FAT32")
{
  ;msgbox % Tmp_Str
	Tmp_Str := SubStr(Tmp_Str, 135, 8)
	msgbox % Format("{:08X}", _byteswap_uint32("0x" Tmp_Str))
}
else
{
	DriveGet, Tmp_Val, Serial, hVolume
	msgbox % Tmp_Val
}
return

_byteswap_uint64(num) ; 需要 msvcr100.dll
{
return dllcall("msvcr100\_byteswap_uint64", "UInt64", Num, "UInt64")
}

_byteswap_uint32(num)
{
return dllcall("msvcr100\_byteswap_ulong", "UInt", Num, "UInt")
}

;msgbox % readSector("C:")
;msgbox % readSector("PhysicalDrive0", 0x4A8530000)
readSector(Device, Offset:=0)
{
FileName       := "\\.\" Device
hFile := DllCall("CreateFile", "str", FileName, "UInt", 0x80000000, "UInt", 0x1|0x2, "UInt", 0, "UInt", 3, "Uint", 0, "UInt", 0)
BytesToRead := VarSetCapacity(MySector, 512, 0x55)

ldword := Offset & 0xFFFFFFFF
hdword := (Offset >> 32) & 0xFFFFFFFF
VarSetCapacity(OVERLAPPED, 20, 0)
NumPut(ldword, OVERLAPPED, 8, "UInt")
NumPut(hdword, OVERLAPPED, 12, "UInt")

response := DllCall("ReadFile", "UInt", hFile, "UInt", &MySector, "UInt", 512, "UInt *", BytesToRead, "UInt", &OVERLAPPED)
response := DllCall("CloseHandle", "UInt", hFile)

	i = 0 
	Data_HEX =
	BackUp_FmtInt := A_FormatInteger
	SetFormat, Integer, HEX   
	Loop 512 
	{ 
		;First byte into the Rx FIFO ends up at position 0 

		Data_HEX_Temp := NumGet(MySector, i, "UChar") ;Convert to HEX byte-by-byte 
		StringTrimLeft, Data_HEX_Temp, Data_HEX_Temp, 2 ;Remove the 0x (added by the above line) from the front 

		;If there is only 1 character then add the leading "0' 
		Length := StrLen(Data_HEX_Temp) 
		If (Length =1) 
		  Data_HEX_Temp = 0%Data_HEX_Temp% 
		i++ 
		;Put it all together 
		Data_HEX := Data_HEX . Data_HEX_Temp 
	} 
	SetFormat, Integer, %BackUp_FmtInt%
return Data_HEX
}

CF_GetDriveFS(sfile){
	SplitPath, sfile, , , , , sDrive
	DriveGet, DFS, FS, %sDrive%
	return DFS
}