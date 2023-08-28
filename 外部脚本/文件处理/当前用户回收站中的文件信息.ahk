;|2.3|2023.08.27|1440
SID := CF_RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI", "LastLoggedOnUserSID")

Gui, Add, ListView, w750 r20 vMyRBListView, 序号|文件名|原目录|删除时间|大小|类型|原路径|回收站中的信息文件|回收站中的真实文件
Gui, Add, button, gclearRecycleBin, 清空回收站
Gui, Add, button, xp+90 gclearRecycleBinInfoFile, 清空信息文件
DriveGet, OutputVar, List, FIXED
Array := StrSplit(OutputVar)
F_Index := 0
Loop, % Array.Length()
{
	; Test ; Put your RecycleBin path here
	;RecycleBin=C:\$Recycle.Bin\PUT-YOUR-SID-HERE-K-THX-BAI
	RecycleBin := Array[A_index] ":\$Recycle.Bin\" SID
	;msgbox % RecycleBin
	Loop, Files, % RecycleBin "\*.*"
	{
		if InStr(A_LoopFileName, "$I")
		{
			RecycleInfo(A_LoopFilefullpath, FilePath, TrueSize, DeletedDate)
			FormatTime, DeletedDate, %DeletedDate%, yyyy.MM.dd HH:mm
			SplitPath, FilePath, OutFileName, OutDir, OutExtension
			truefile := strreplace(A_LoopFilefullpath, "$I", "$R")
			F_Index ++
			if FileExist(truefile)
				LV_Add("", F_Index, OutFileName, OutDir, DeletedDate, TrueSize, OutExtension, FilePath, A_LoopFilefullpath, truefile)
			else
				LV_Add("", F_Index, OutFileName, OutDir, DeletedDate, TrueSize, OutExtension, FilePath, A_LoopFilefullpath, "原文件已被删除")
		}
		if InStr(A_LoopFileName, "$R")
		{
			infofile := strreplace(A_LoopFileName, "$R", "$I")
			infofile := A_LoopFileDir "\" infofile
			;msgbox % infofile
			if FileExist(infofile)
				continue
			else
			{
				F_Index ++
				LV_Add("", F_Index, , , , , , , "信息文件已被删除", A_LoopFilefullpath)
			}
		}
	}
}
LV_ModifyCol()
LV_ModifyCol(1, "Logical")
Gui, Show,, % "当前用户[ " A_UserName " ]回收站中的文件信息"
Menu, MyContextMenu, Add, 还原, refile
Menu, MyContextMenu, Add, 删除, delfile
return

GuiClose:
ExitApp

refile:
LV_GetText(rfilepath, LV_GetNext("F"), 9)
LV_GetText(sfilepath, LV_GetNext("F"), 7)
if (rfilepath != "原文件已被删除")
{
FileMove, % rfilepath, % sfilepath
LV_Delete(LV_GetNext("F"))
}
Return

delfile:
LV_GetText(rfilepath, LV_GetNext("F"), 9)
LV_GetText(rinfofilepath, LV_GetNext("F"), 8)
if (rfilepath != "原文件已被删除")
{
	FileDelete % rfilepath
}
if (rinfofilepath != "信息文件已被删除")
	FileDelete % rinfofilepath
return

clearRecycleBin:
FileRecycleEmpty
LV_Delete()
SoundPlay, C:\WINDOWS\Media\Windows Recycle.wav
Return

clearRecycleBinInfoFile:
Loop % LV_GetCount()
{
	LV_GetText(rinfofilepath, A_index, 8)
	if (rinfofilepath != "信息文件已被删除")
		FileDelete % rinfofilepath
}
return

GuiContextMenu:  ; 运行此标签来响应右键点击或按下 Apps 键.
if (A_GuiControl != "MyRBListView")  ; 这个检查是可选的. 让它只为 ListView 中的点击显示菜单.
    return
; 在提供的坐标处显示菜单, A_GuiX 和 A_GuiY. 应该使用这些
; 因为即使用户按下 Apps 键它们也会提供正确的坐标:
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return

;来源网址: https://www.autohotkey.com/board/topic/65897-retrieve-information-about-recycled-files-in-recycle-bin/
;Compiled/wrapped by he who eats pie
;http://www.autohotkey.com/forum/viewtopic.php?p=437720

;RecycleReference = the "$I*" file that you want to examine
;Filename = The variable to hold name of the file in C:\$Recycle.Bin you want info about.
;Size = The variable to hold the size (in bytes) of the file
;Timestamp = The variable to hold the timestamp the file was deleted
RecycleInfo(RecycleReference, ByRef Filename, ByRef Size, ByRef TimeStamp)
{
	if(!FileExist(RecycleReference))
	{	msgbox, Unable to access the recycle bin for sid`n%SID%
		return -1
	}
	BinRead(RecycleReference,FILE)
	SIZE_LOCATION=17
	SIZE_BYTES=8
	TIMESTAMP_LOCATION := SIZE_LOCATION + SIZE_BYTES*2  ;33
	TIMESTAMP_BYTES=8
	FILENAME_LOCATION:=TIMESTAMP_LOCATION+TIMESTAMP_BYTES*2 ;49

	Size := hex2dec(fliphex(SubStr(FILE, SIZE_LOCATION, SIZE_BYTES*2)))
	Timestamp := unix2Human(Round((10**(-7) * hex2dec(fliphex(SubStr(FILE, TIMESTAMP_LOCATION, TIMESTAMP_BYTES*2)))) - 11644473600 + 28800))  ; 加上时区的秒数 8 * 3600
	;msgbox % hex2dec(fliphex(SubStr(FILE, TIMESTAMP_LOCATION, TIMESTAMP_BYTES*2)))
	;Filename := Hex2TXT(SubStr(FILE,FILENAME_LOCATION))
	dd := SubStr(FILE,FILENAME_LOCATION + 8)
	;msgbox % dd
	MCode(varchinese, dd)
	Filename := StrGet(&varchinese, "UTF-16")
}

; Returns the original size of the file in question
; Filename = the "$I*" file that you want to examine
RecycleInfo_size(Filename)
{
	if(!FileExist(Filename))
	{
		msgbox, Unable to access the file`n%Filename%
		return -1
	}
	SIZE_LOCATION=17
	SIZE_BYTES=8
	BinRead(Filename,FILE)

	Size:=SubStr(FILE,SIZE_LOCATION,SIZE_BYTES*2)	;(1) flip (2) convert to decimal
	Size := hex2dec(fliphex(size))
	Return Size
}

; Returns the time of deletion of the file in question
; Format is YYYYMMDDHH24MISS
; Filename = the "$I*" file that you want to examine
RecycleInfo_time(Filename)
{
	if(!FileExist(Filename))
	{
		msgbox, Unable to access the file`n%Filename%
		return -1
	}
	TIMESTAMP_LOCATION := SIZE_LOCATION+SIZE_BYTES*2  ;33
	TIMESTAMP_BYTES := 8
	BinRead(Filename, FILE)
	
	Timestamp := SubStr(FILE, TIMESTAMP_LOCATION, TIMESTAMP_BYTES*2)	;(1) flip (2) convert to decimal (3) convert to Unix (4) convert to Human
	Timestamp := unix2Human(Round((10**(-7) * hex2dec(fliphex(timestamp))) - 11644473600))
}

; Returns the original file path of the file in question
; Filename = the "$I*" file that you want to examine
RecycleInfo_filename(Filename)
{
	if(!FileExist(Filename))
	{
		msgbox, Unable to access the file`n%Filename%
		return -1
	}
	FILENAME_LOCATION := TIMESTAMP_LOCATION + TIMESTAMP_BYTES * 2 ;49
	BinRead(Filename, FILE)
	
	Filename := SubStr(FILE, FILENAME_LOCATION)
	Filename := Hex2TXT(Filename)
}

; This one was by me! Reverses a hex quantity that is grouped in bits of 2
fliphex(Invar)
{
	OutVar=
	loop, % StrLen(Invar)/2
		OutVar:= SubStr(InVar,2*(A_Index-1)+1,2) . OutVar
	return OutVar
}

;Written by Elevator_Hazard
;http://www.autohotkey.com/forum/topic17928.html
Hex2Txt(Hex) 
{
	format := A_FormatInteger
	go=1
	Txt=
	HexLen := StrLen(Hex)
	Loop, %HexLen%
	{
		If go=1
		{
			go=0
			HexSet := "0x" . SubStr(Hex, A_Index, 2)
			SetFormat, Integer, Decimal
			HexSet += 0
			Txt := Txt . Chr(HexSet)
		}
		else
		{
			go=1
		}
	}
	SetFormat, Integer, %Format%
	return %Txt%
}

;Written by derRaphael
;http://www.autohotkey.com/forum/topic36870.html#226284
hex2dec(n) {
   x := ((substr(n,1,2)!="0x") ? "0x" : "") n
   if ! StrLen(x+0)
      return n
   oIF := A_FormatInteger
   SetFormat,Integer, d
   x += 0
   SetFormat,Integer, % oIF
   return x
}

;Written by [VxE], wrapped by JonS
;http://www.autohotkey.com/forum/viewtopic.php?t=2633&start=15#423331
unix2Human(unixTimestamp) {
   returnDate = 19700101000000
   returnDate += unixTimestamp, s
   return returnDate
}

;Written by Laszlo
;http://www.autohotkey.com/forum/topic4546.html
BinRead(file, ByRef data, n=0, offset=0)
{
   h := DllCall("CreateFile","Str",file,"Uint",0x80000000,"Uint",3,"UInt",0,"UInt",3,"Uint",0,"UInt",0)
   IfEqual h,-1, SetEnv, ErrorLevel, -1
   IfNotEqual ErrorLevel,0,Return,0 ; couldn't open the file

   m = 0                            ; seek to offset
   IfLess offset,0, SetEnv,m,2
   r := DllCall("SetFilePointerEx","Uint",h,"Int64",offset,"UInt *",p,"Int",m)
   IfEqual r,0, SetEnv, ErrorLevel, -3
   IfNotEqual ErrorLevel,0, {
      t = %ErrorLevel%              ; save ErrorLevel to be returned
      DllCall("CloseHandle", "Uint", h)
      ErrorLevel = %t%              ; return seek error
      Return 0
   }

   TotalRead = 0
   data =
   IfEqual n,0, SetEnv n,0xffffffff ; almost infinite

   format = %A_FormatInteger%       ; save original integer format
   SetFormat Integer, Hex           ; for converting bytes to hex

   Loop %n%
   {
      result := DllCall("ReadFile","UInt",h,"UChar *",c,"UInt",1,"UInt *",Read,"UInt",0)
      if (!result or Read < 1 or ErrorLevel)
         break
      TotalRead += Read             ; count read
      c += 0                        ; convert to hex
      StringTrimLeft c, c, 2        ; remove 0x
      c = 0%c%                      ; pad left with 0
      StringRight c, c, 2           ; always 2 digits
      data = %data%%c%              ; append 2 hex digits
   }

   IfNotEqual ErrorLevel,0, SetEnv,t,%ErrorLevel%

   h := DllCall("CloseHandle", "Uint", h)
   IfEqual h,-1, SetEnv, ErrorLevel, -2
   IfNotEqual t,,SetEnv, ErrorLevel, %t%

   SetFormat Integer, %format%      ; restore original format
   Totalread += 0                   ; convert to original format
   Return TotalRead
}

MCode(ByRef code, hex) 
{ ; allocate memory and write Machine Code there
	VarSetCapacity(code, 0) 
	VarSetCapacity(code,StrLen(hex)//2+2)
	Loop % StrLen(hex)//2 + 2
		NumPut("0x" . SubStr(hex,2*A_Index-1,2), code, A_Index-1, "Char")
}

CF_RegRead(KeyName, ValueName = "") {
	RegRead, v, %KeyName%, %ValueName%
Return, v
}