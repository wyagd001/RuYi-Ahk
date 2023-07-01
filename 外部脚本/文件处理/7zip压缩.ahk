;1269
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}

;CandySel := "C:\Documents and Settings\Administrator\Desktop\123.zip"
If !( o7z := 7Zip_Init() )
  Quit("Failed loading 7-zip32.dll library")
global sDllPath

;o7z.opt.Output := "C:\Documents and Settings\Administrator\Desktop"
o7z.opt.Hide := 1
o7z.opt.ExcludeFile := ".git"   ; 排除的文件

if !instr(CandySel, "`n")
{
	SplitPath, CandySel,, OutDir,, OutFileNameNoExt
	7Zip_Add(OutDir "\" OutFileNameNoExt ".zip", CandySel)
}
Else
{
		loop, parse, CandySel, `n, `r
	{
		SplitPath, CandySel,, OutDir,, OutFileNameNoExt
		break
	}
	loop, parse, CandySel, `n, `r
	{
		7Zip_Add(OutDir "\" OutFileNameNoExt ".zip", A_LoopField)
	}
}
ExitApp

Quit(Msg) {
  MsgBox % Msg
  ExitApp
}

; https://www.autohotkey.com/board/topic/64362-7zip-7-zip32dll-library-without-commandline-ahk-l/page-1

/*
------------------------------------------------------------------
Function: 7-zip32.dll wrapper library
Author  : shajul (with generous help from Lexikos)
Requires: Autohotkey_L
URL: http://www.autohotkey.com/forum/viewtopic.php?t=69249
------------------------------------------------------------------
*/

;
; Function: 7Zip_Init
; Description:
;      Initiate 7Zip (must be called only if 7-zip32.dll is not in same folder as script)
; Syntax: 7Zip_Init([sDllPath])
; Parameters:
;      sDllPath - (Optional) Path to 7-zip32.dll
; Return Value:
;      Helper Object on success, 0 on failure
; Remarks:
;      Object properties are mentioned below.
; Related: 7Zip_Close
; Example:
;      file:example.ahk
;
/* PROPERTIES OF .opt ----------------------------------------------------------------------------------------------------------
Hide           ;Callback is called (bool);a,d,e,x,u
CompressLevel  ;0-9 (level);a,d,u
CompressType   ;7z,gzip,zip,bzip2,tar,iso,udf (string);a
Recurse        ;0 - Disable, 1 - Enable, 2 - Enable only for wildcard names;a,d,e,x,u
IncludeFile    ;Specifies filenames and wildcards or list file that specify processed files (string);a,d,e,x,u
ExcludeFile    ;Specifies what filenames or (and) wildcards must be excluded from operation (string);a,d,e,x,u
Password       ;Password (string);a,d,e,x,u
SFX            ;Self extracting archive module name (string);a,u
VolumeSize     ;Create volumes of specified sizes (integer);a
WorkingDir     ;Sets working directory for temporary base archive (string);a,d,e,x,u
ExtractPaths   ;Extract with full paths. Default is yes (bool);e,x
Output         ;Output directory (string);e,x
Overwrite      ;0 - Overwrite All, 1 - Skip extracting of existing, 2 - Auto rename extracting file, 3 - auto rename existing file;e,x
IncludeArchive ;Include archive filenames (string);e,x
ExcludeArchive ;Exclude archive filenames (string);e,x
Yes            ;assume Yes on all queries;e,x
------------------------------------------------------------------------------------------------------------------------------- 
*/
7Zip_Init() {
	global sDllPath
	global 7Zip_
	sDllPath := A_ScriptDir . "\..\..\引用程序" (A_PtrSize=8 ? "\x64\7-zip.dll" : "\x32\7-zip.dll")
  if !( r := DllCall("LoadLibrary", "Str", sDllPath) )
    return 0 , ErrorLevel := -1

	If 7Zip_._hModule
		return 7Zip_

  If !IsObject(7Zip_)
    7Zip_ := Object()

  7Zip_._hModule := r

  ;--- Default options
  7Zip_["opt","Hide"]      := 0       ;Callback is called (bool);a,d,e,x,u
  7Zip_.opt.CompressLevel  := 5       ;0-9 (level);a,d,u
  7Zip_.opt.CompressType   := "zip"   ;7z,gzip,zip,bzip2,tar,iso,udf (string);a
  7Zip_.opt.Recurse        := 0       ;0 - Disable, 1 - Enable, 2 - Enable only for wildcard names;a,d,e,x,u
  7Zip_.opt.IncludeFile    := ""      ;Specifies filenames and wildcards or list file that specify processed files (string);a,d,e,x,u
  7Zip_.opt.ExcludeFile    := ""      ;Specifies what filenames or (and) wildcards must be excluded from operation (string);a,d,e,x,u
  7Zip_.opt.Password       := ""      ;Password (string);a,d,e,x,u
  7Zip_.opt.SFX            := ""      ;Self extracting archive module name (string);a,u
  7Zip_.opt.VolumeSize     := 0       ;Create volumes of specified sizes (integer);a
  7Zip_.opt.WorkingDir     := ""      ;Sets working directory for temporary base archive (string);a,d,e,x,u
  7Zip_.opt.ExtractPaths   := 1       ;Extract full paths (default 1);e,x
  7Zip_.opt.Output         := ""      ;Output directory (string);e,x
  7Zip_.opt.Overwrite      := 0       ;0 - Overwrite All, 1 - Skip extracting of existing, 2 - Auto rename extracting file, 3 - auto rename existing file;e,x
  7Zip_.opt.IncludeArchive := ""      ;Include archive filenames (string);e,x
  7Zip_.opt.ExcludeArchive := ""      ;Exclude archive filenames (string);e,x
  7Zip_.opt.Yes            := 0       ;assume Yes on all queries;e,x
  
  7Zip_.FNAME_MAX32 := 512   ;Filename string max
  ;--- File attributes constants ---
  7Zip_.FA_RDONLY    := 0x01 ;Readonly
  7Zip_.FA_HIDDEN    := 0x02 ;Hidden
  7Zip_.FA_SYSTEM    := 0x04 ;System file
  7Zip_.FA_LABEL     := 0x08 ;Volume label
  7Zip_.FA_DIREC     := 0x10 ;Directory
  7Zip_.FA_ARCH      := 0x20 ;Retention bit
  7Zip_.FA_ENCRYPTED := 0x40 ;password protected

  return 7Zip_
}

;
; Function: 7Zip_List
; Description:
;      List files in an archive
; Syntax: 7Zip_Add(hWnd, sArcName)
; Parameters:
;      sArcName - Name of archive to list
;      hWnd - handle of window (calling application), can be 0
; Return Value:
;      Response buffer (string) on success, 0 on failure.
; Related: 
; Remarks:
;      Errorlevel is set to returned value of the function on success.
;
7Zip_List(sArcName, hWnd=0) {
  global 7Zip_
  if !7Zip_Init()
    return 0
    
  opt := 7Zip_.opt  
  commandline  = l "%sArcName%"
  commandline .= opt.Hide ? " -hide" : ""
  commandline .= opt.Password ? " -p" . opt.Password : ""
  
  return 7Zip__SevenZip(commandline)
} ;End Function

;
; Function: 7Zip_Add
; Description:
;      Add files to archive
; Syntax: 7Zip_Add(hWnd, sArcName, sFileName)
; Parameters:
;      sArcName - Name of archive to be created
;      sFileName - Files to archive
;      hWnd - handle of window (calling application), can be 0
; Return Value:
;      Response buffer (string) on success, 0 on failure.
; Remarks:
;      Errorlevel is set to returned value of the function on success.
; Related: 7Zip_Update , 7Zip_Delete
;
7Zip_Add(sArcName, sFileName, hWnd=0) {
  global 7Zip_
  if !7Zip_Init()
    return 0 , ErrorLevel := -1  
  opt := 7Zip_.opt
  commandline  = a "%sArcName%" "%sFileName%"
  commandline .= opt.Hide ? " -hide" : ""
  commandline .= " -mx" . opt.CompressLevel
  commandline .= " -t" . opt.CompressType
  commandline .= 7Zip__Recursion()
  commandline .= opt.Password ? " -p" . opt.Password : ""
  commandline .= FileExist(opt.SFX) ? " -sfx" . opt.SFX : ""
  commandline .= opt.VolumeSize ? " -v" . opt.VolumeSize : ""
  commandline .= opt.WorkingDir ? " -w" . opt.WorkingDir : ""
  
  if opt.IncludeFile
    commandline .= ( SubStr(opt.IncludeFile,1,1) = "@" ) ? " -i""" . opt.IncludeFile . """" : " -i!""" . opt.IncludeFile . """"
  if opt.ExcludeFile
    commandline .= ( SubStr(opt.ExcludeFile,1,1) = "@" ) ? " -x""" . opt.ExcludeFile . """" : " -x!""" . opt.ExcludeFile . """"
	if opt.ExcludeFile2
    commandline .= ( SubStr(opt.ExcludeFile,1,1) = "@" ) ? " -xr""" . opt.ExcludeFile2 . """" : " -xr!""" . opt.ExcludeFile2 . """"
  return 7Zip__SevenZip(commandline)
} ;End Function

;
; Function: 7Zip_Delete
; Description:
;      Add files to archive
; Syntax: 7Zip_Delete(hWnd, sArcName, sFileName)
; Parameters:
;      sArcName - Name of the archive
;      sFileName - Files to delete
;      hWnd - handle of window (calling application), can be 0
; Return Value:
;      Response buffer (string) on success, 0 on failure.
; Remarks:
;      Errorlevel is set to returned value of the function on success.
; Related: 7Zip_Update , 7Zip_Add
;
7Zip_Delete(sArcName, sFileName, hWnd=0) {
  global 7Zip_
  if !7Zip_Init()
    return 0 , ErrorLevel := -1  
  opt := 7Zip_.opt, nSize := 32768
  commandline  = d "%sArcName%" "%sFileName%"
  commandline .= opt.Hide ? " -hide" : ""
  commandline .= " -mx" . opt.CompressLevel
  commandline .= 7Zip__Recursion()
  commandline .= opt.Password ? " -p" . opt.Password : ""
  commandline .= opt.WorkingDir ? " -w" . opt.WorkingDir : ""  
  
  if opt.IncludeFile
    commandline .= ( SubStr(opt.IncludeFile,1,1) = "@" ) ? " -i""" . opt.IncludeFile . """" : " -i!""" . opt.IncludeFile . """"
  if opt.ExcludeFile
    commandline .= ( SubStr(opt.ExcludeFile,1,1) = "@" ) ? " -x""" . opt.ExcludeFile . """" : " -x!""" . opt.ExcludeFile . """"

  return 7Zip__SevenZip(commandline)
} ;End Function

;
; Function: 7Zip_Extract
; Description:
;      Extract files from archive
; Syntax: 7Zip_Extract(hWnd, sArcName)
; Parameters:
;      sArcName - Name of archive to extract
;      hWnd - handle of window (calling application), can be 0
; Return Value:
;      Response buffer (string) on success, 0 on failure.
; Remarks:
;      Errorlevel is set to returned value of the function on success.
;      Note that output folder can be specified as a property
; Related: 7Zip_Update , 7Zip_Delete
;
7Zip_Extract(sArcName, hWnd=0) {
  global 7Zip_
  if !7Zip_Init()
    return 0 , ErrorLevel := -1  
  opt := 7Zip_.opt, nSize := 32768
  commandline := opt.ExtractPaths ? "x """ . sArcName . """" : "e """ . sArcName . """"
  commandline .= opt.Hide ? " -hide" : ""
  commandline .= 7Zip__Recursion()
  commandline .= opt.Output ? " -o""" . opt.Output . """" : ""
  commandline .= 7Zip__Overwrite()
  commandline .= opt.Password ? " -p" . opt.Password : ""
  commandline .= opt.WorkingDir ? " -w" . opt.WorkingDir : ""  
  commandline .= opt.Yes ? " -y" : ""
  
  if opt.IncludeArchive
    commandline .= ( SubStr(opt.IncludeArchive,1,1) = "@" ) ? " -ai""" . opt.IncludeArchive . """" : " -ai!""" . opt.IncludeArchive . """"
  if opt.ExcludeArchive
    commandline .= ( SubStr(opt.ExcludeArchive,1,1) = "@" ) ? " -ax""" . opt.ExcludeArchive . """" : " -ax!""" . opt.ExcludeArchive . """"
  
  if opt.IncludeFile
    commandline .= ( SubStr(opt.IncludeFile,1,1) = "@" ) ? " -i""" . opt.IncludeFile . """" : " -i!""" . opt.IncludeFile . """"
  if opt.ExcludeFile
    commandline .= ( SubStr(opt.ExcludeFile,1,1) = "@" ) ? " -x""" . opt.ExcludeFile . """" : " -x!""" . opt.ExcludeFile . """"

  return 7Zip__SevenZip(commandline)
} ;End Function

;
; Function: 7Zip_Update
; Description:
;      Update files to an archive
; Syntax: 7Zip_Update(hWnd, sArcName, sFileName)
; Parameters:
;      sArcName - Name of archive to be updated
;      sFileName - Files to add
;      hWnd - handle of window (calling application), can be 0
; Return Value:
;      Response buffer (string) on success, 0 on failure.
; Remarks:
;      Errorlevel is set to returned value of the function on success.
; Related: 7Zip_Add , 7Zip_Delete
;
7Zip_Update(sArcName, sFileName, hWnd=0) {
  global 7Zip_
  if !7Zip_Init()
    return 0 , ErrorLevel := -1  
  opt := 7Zip_.opt
  commandline  = a "%sArcName%" "%sFileName%"
  commandline .= opt.Hide ? " -hide" : ""
  commandline .= " -mx" . opt.CompressLevel
  commandline .= 7Zip__Recursion()
  commandline .= opt.Password ? " -p" . opt.Password : ""
  commandline .= FileExist(opt.SFX) ? " -sfx" . opt.SFX : ""
  commandline .= opt.WorkingDir ? " -w" . opt.WorkingDir : ""
  
  if opt.IncludeFile
    commandline .= ( SubStr(opt.IncludeFile,1,1) = "@" ) ? " -i""" . opt.IncludeFile . """" : " -i!""" . opt.IncludeFile . """"
  if opt.ExcludeFile
    commandline .= ( SubStr(opt.ExcludeFile,1,1) = "@" ) ? " -x""" . opt.ExcludeFile . """" : " -x!""" . opt.ExcludeFile . """"
  return 7Zip__SevenZip(commandline)
} ;End Function

;
; Function: 7Zip_SetOwnerWindowEx
; Description:
;      Appoints the call-back function in order to receive the information of the compressing/unpacking
; Syntax: 7Zip_SetOwnerWindowEx(hWnd, sProcFunc)
; Parameters:
;      hWnd - Handle to parent or owner window
;      sProcFunc - Callback function name
; Return Value:
;      True on success, false otherwise
; Related: 7Zip_KillOwnerWindowEx
;
7Zip_SetOwnerWindowEx(sProcFunc, hWnd=0) {
  Address := RegisterCallback(sProcFunc, "F", 4)
  Return DllCall(sDllPath "\SevenZipSetOwnerWindowEx", "Ptr", hWnd , "ptr", Address)
} ;End Function

;
; Function: 7Zip_KillOwnerWindowEx
; Description:
;      Removes the callback
; Syntax: 7Zip_KillOwnerWindowEx(hWnd)
; Parameters:
;      hWnd - Handle to parent or owner window
; Return Value:
;      True on success, false otherwise
; Related: 7Zip_SetOwnerWindowEx
;
7Zip_KillOwnerWindowEx(hWnd) {
  Return DllCall(sDllPath "\SevenZipKillOwnerWindowEx" , "Ptr", hWnd)
} ;End Function

;
; Function: 7Zip_CheckArchive
; Description:
;      Check archive integrity 
; Syntax: 7Zip_CheckArchive(sArcName)
; Parameters:
;      sArcName - Name of archive to be created
; Return Value:
;      True on success, false otherwise
;
7Zip_CheckArchive(sArcName) {
  Return DllCall(sDllPath "\SevenZipCheckArchive", "AStr", sArcName, "int", 0)
} ;End Function

;
; Function: 7Zip_GetArchiveType
; Description:
;      Get the type of archive
; Syntax: 7Zip_GetArchiveType(sArcName)
; Parameters:
;      sArcName - Name of archive
; Return Value:
;      0 - Unknown type
;      1 - ZIP type
;      2 - 7Z type
;      -1 - Failure
;
7Zip_GetArchiveType(sArcName) {
  Return DllCall(sDllPath "\SevenZipGetArchiveType", "AStr", sArcName)
} ;End Function

;
; Function: 7Zip_GetFileCount
; Description:
;      Get the number of files in archive
; Syntax: 7Zip_GetFileCount(sArcName)
; Parameters:
;      sArcName - Name of archive
; Return Value:
;      Count on success, -1 otherwise
;
7Zip_GetFileCount(sArcName) {
  Return DllCall(sDllPath "\SevenZipGetFileCount", "AStr", sArcName)
} ;End Function

;
; Function: 7Zip_ConfigDialog
; Description:
;      Shows the about dialog for 7-zip32.dll
; Syntax: 7Zip_ConfigDialog(hWnd)
; Parameters:
;      hWnd - handle of owner window
;
7Zip_ConfigDialog(hWnd) {
  Return DllCall(sDllPath "\SevenZipConfigDialog", "Ptr", hWnd, "ptr",0, "int",0)
} ;End Function

7Zip_QueryFunctionList(iFunction = 0) {
  Return DllCall(sDllPath "\SevenZipQueryFunctionList", "int", iFunction)
} ;End Function

;
; Function: 7Zip_GetVersion
; Description:
;      Version of 7-zip32.dll
; Syntax: 7Zip_GetVersion()
; Return Value:
;      Version string
;
7Zip_GetVersion() {
  aRet := DllCall(sDllPath "\SevenZipGetVersion", "Short")
  Return SubStr(aRet,1,1) . "." . SubStr(aRet,2)
} ;End Function

;
; Function: 7Zip_GetSubVersion
; Description:
;      Subversion of 7-zip32.dll
; Syntax: 7Zip_GetSubVersion()
; Return Value:
;      Subversion string
;
7Zip_GetSubVersion() {
  return DllCall(sDllPath "\SevenZipGetSubVersion", "Short")
} ;End Function

;
; Function: 7Zip_Close
; Description:
;      Free 7-zip32.dll library
; Syntax: 7Zip_Close()
;
7Zip_Close() {
  global 7Zip_
  DllCall("FreeLibrary", "Ptr", 7Zip_._hModule)
  7Zip_ := ""
}

; FUNCTIONS BELOW - CREDIT TO LEXIKOS -------------------------------------------------------

;
; Function: 7Zip_OpenArchive
; Description:
;      Open archive and return handle for use with 7Zip_FindFirst
; Syntax: 7Zip_OpenArchive(sArcName, [hWnd])
; Parameters:
;      sArcName - Path of archive
;      hWnd - Handle of calling window
; Return Value:
;      Handle for use with 7Zip_FindFirst function, 0 on error.
; Remarks:
;      Nil
; Related: 7Zip_CloseArchive, 7Zip_FindFirst , File Info Functions
; Example:
;      hArc := 7Zip_OpenArchive("C:\Path\To\Archive.7z")
;

7Zip_OpenArchive(sArcName, hWnd=0) {
	;global sDllPath
  Return DllCall(sDllPath "\SevenZipOpenArchive", "Ptr", hWnd, "AStr", sArcName, "int", 0)
} ;End Function

;
; Function: 7Zip_CloseArchive
; Description:
;      Closes the archive handle
; Syntax: 7Zip_CloseArchive(hArc)
; Parameters:
;      hArc - Handle retrived from 7Zip_OpenArchive
; Return Value:
;      -1 on error
; Remarks:
;      Nil
; Related: 7Zip_OpenArchive
; Example:
;      7Zip_CloseArchive(hArc)
;

7Zip_CloseArchive(hArc) {
  Return DllCall(sDllPath "\SevenZipCloseArchive", "Ptr", hArc)
} ;End Function

;
; Function: 7Zip_FindFirst
; Description:
;      Find first file for search criteria in archive
; Syntax: 7Zip_FindFirst(hArc, sSearch, [o7zip__info])
; Parameters:
;      hArc - handle of archive (returned from 7Zip_OpenArchive)
;      sSearch - Search string (wildcards allowed)
;      o7zip__info - (Optional) Name of object to recieve details of file.
; Return Value:
;      Object with file details on success. If 3rd param was 0, returns true on success. False on failure.
; Remarks:
;      If third param is omitted, details are returned in a new object.
;      If it is set to 0, details are not retrieved. (You can use the other functions to get details.)
; Related: 7Zip_FindNext , 7Zip_OpenArchive , File Info Functions
; Example:
;      file:example_archive_info.ahk
;  9.22版 搜索有些问题, 不能搜索到正常结果

7Zip_FindFirst(hArc, sSearch, o7zip__info="") {
	;global sDllPath
	;tohex(sSearch, qq)
	;MsgBox % qq
	;Unicode2Ansi(sSearch, ASearch, 936)
	;tohex(ASearch, pp)
	;MsgBox % pp
  if (o7zip__info = 0)
  {
    r := DllCall(sDllPath "\SevenZipFindFirst", "Ptr", hArc, "AStr", sSearch, "ptr", 0)
    return ( r ? 0 : 1 ), ErrorLevel := (r ? r : ErrorLevel)
  }
  if !IsObject(o7zip__info)
    o7zip__info := Object()
  VarSetCapacity(tINDIVIDUALINFO, 558, 0)
  h := DllCall(sDllPath "\SevenZipFindFirst", "Ptr", hArc, "AStr", sSearch, "ptr", &tINDIVIDUALINFO)
	if h
	{
		tooltip % h
    Return 0 
	}

; 9.20版 32位 可以正常搜索
  o7zip__info.OriginalSize   := NumGet(tINDIVIDUALINFO , 0, "UInt")
  o7zip__info.CompressedSize := NumGet(tINDIVIDUALINFO , 4, "UInt")
  o7zip__info.CRC            := NumGet(tINDIVIDUALINFO , 8, "UInt")
; uFlag                      := NumGet(tINDIVIDUALINFO , 12, "UInt") ;always 0
; uOSType                    := NumGet(tINDIVIDUALINFO , 16, "UInt") ;always 0  
  o7zip__info.Ratio          := NumGet(tINDIVIDUALINFO , 20, "UShort")
  o7zip__info.Date           := 7Zip_DosDateTimeToStr(NumGet(tINDIVIDUALINFO , 22, "UShort"),NumGet(tINDIVIDUALINFO , 24, "UShort"))
  o7zip__info.FileName       := StrGet(&tINDIVIDUALINFO+26 ,513,"CP0")
  o7zip__info.Attribute      := StrGet(&tINDIVIDUALINFO+542,8  ,"CP0")
  o7zip__info.Mode           := StrGet(&tINDIVIDUALINFO+550,8  ,"CP0")

  return o7zip__info
} ;End Function

;
; Function: 7Zip_FindNext
; Description:
;      Find next file for search criteria in archive
; Syntax: 7Zip_FindNext(hArc, [o7zip__info])
; Parameters:
;      hArc - handle of archive (returned from 7Zip_OpenArchive)
;      o7zip__info - (Optional) Name of object to recieve details of file.
; Return Value:
;      Object with file details on success. If 2nd param was 0, returns true on success. False on failure.
; Remarks:
;      If second param is omitted, details are returned in a new object. 
;      If it is set to 0, details are not retrieved. (You can use the other functions to get details.)
; Related: 7Zip_FindFirst , 7Zip_OpenArchive, File Info Functions
; Example:
;      file:example_archive_info.ahk
;
7Zip_FindNext(hArc, o7zip__info="") {
  if (o7zip__info = 0)
  {
    r := DllCall(sDllPath "\SevenZipFindFirst", "Ptr", hArc, "AStr", sSearch, "ptr", 0)
    return ( r ? 0 : 1 ), ErrorLevel := (r ? r : ErrorLevel)
  }
  if !IsObject(o7zip__info)
    o7zip__info := Object()
  VarSetCapacity(tINDIVIDUALINFO, 558, 0)
  h := DllCall(sDllPath "\SevenZipFindNext", "Ptr", hArc, "ptr", &tINDIVIDUALINFO)
;MsgBox % h
	if h
	{
		tooltip % h
    Return 0 
	}

  o7zip__info.OriginalSize   := NumGet(tINDIVIDUALINFO , 0, "UInt")
  o7zip__info.CompressedSize := NumGet(tINDIVIDUALINFO , 4, "UInt")
  o7zip__info.CRC            := NumGet(tINDIVIDUALINFO , 8, "UInt")
  o7zip__info.Ratio          := NumGet(tINDIVIDUALINFO , 20, "UShort")
  o7zip__info.Date           := 7Zip_DosDateTimeToStr(NumGet(tINDIVIDUALINFO , 22, "UShort"),NumGet(tINDIVIDUALINFO , 24, "UShort"))  
  o7zip__info.FileName       := StrGet(&tINDIVIDUALINFO+26 ,513,"CP0")
  o7zip__info.Attribute      := StrGet(&tINDIVIDUALINFO+542,8  ,"CP0")
  o7zip__info.Mode           := StrGet(&tINDIVIDUALINFO+550,8  ,"CP0")
  
  return o7zip__info
} ;End Function

;
; Function: File Info Functions
; Description:
;      Using handle hArc, get info of file(s) in archive.
; Syntax: 7Zip_<InfoFunction>(hArc)
; Parameters:
;      7Zip_GetFileName - Get file name
;      7Zip_GetArcOriginalSize - Original size of file
;      7Zip_GetArcCompressedSize - Compressed size
;      7Zip_GetArcRatio - Compression ratio
;      7Zip_GetDate - Date
;      7Zip_GetTime - Time
;      7Zip_GetCRC - File CRC
;      7Zip_GetAttribute - File Attribute
;      7Zip_GetMethod - Compression method (LZMA or PPMD)
; Return Value:
;      -1 on error
; Remarks:
;      See included example for details
; Related: 7Zip_OpenArchive , 7Zip_FindFirst
; Example:
;      file:example_archive_info.ahk
;
7Zip_GetFileName(hArc) {
  VarSetCapacity(tNameBuffer, 513)
	h := DllCall(sDllPath "\SevenZipGetFileName", "Ptr", hArc, "ptr", &tNameBuffer, "int", 513)
	;msgbox % h
  If !h
    Return StrGet(&tNameBuffer, 513, "CP0")
} ;End Function

7Zip_GetArcOriginalSize(hArc) {
  Return DllCall(sDllPath "\SevenZipGetArcOriginalSize", "Ptr", hArc)
} ;End Function

7Zip_GetArcCompressedSize(hArc) {
  Return DllCall(sDllPath "\SevenZipGetArcCompressedSize", "Ptr", hArc)
} ;End Function

7Zip_GetArcRatio(hArc) {
  Return DllCall(sDllPath "\SevenZipGetArcRatio", "Ptr", hArc, "short")
} ;End Function

7Zip_GetDate(hArc) {
  Return DllCall(sDllPath "\SevenZipGetDate", "Ptr", hArc, "Short")
} ;End Function

7Zip_GetTime(hArc) {
  Return DllCall(sDllPath "\SevenZipGetTime", "Ptr", hArc, "Short")
} ;End Function

7Zip_GetCRC(hArc) {
  Return DllCall(sDllPath "\SevenZipGetCRC", "Ptr", hArc, "UInt")
} ;End Function

7Zip_GetAttribute(hArc) {
  return DllCall(sDllPath "\SevenZipGetAttribute", "Ptr", hArc)
} ;End Function

7Zip_GetMethod(hArc) {
  VarSetCapacity(sBUFFER,8)
  if DllCall(sDllPath "\SevenZipGetMethod" , "Ptr", hArc , "ptr", &sBuffer,"int", 8)
    Return 0
  Return StrGet(&sBUFFER, 8, "CP0")
} ;End Function

; FUNCTIONS FOR INTERNAL USE --------------------------------------------------------------------------------------------------
7Zip__SevenZip(sCommand) {
  nSize := 32768
  VarSetCapacity(tOutBuffer, nSize)
  aRet := DllCall(sDllPath "\SevenZip", "Ptr", hWnd
          ,"AStr", sCommand
          ,"Ptr", &tOutBuffer
          ,"Int", nSize)

  If !ErrorLevel
    return StrGet(&tOutBuffer, nSize, "CP0"), ErrorLevel := aRet
  else
    return 0
} ;End Function  

7Zip__Recursion() {
  global 7Zip_
    if 7Zip_.opt.Recurse = 1
      Return " -r"
    if 7Zip_.opt.Recurse = 2
      Return " -r0"
    Else
      Return " -r-"
} ;End Function

7Zip__Overwrite() {
  global 7Zip_
  if (7Zip_.opt.Overwrite = 0)
    Return " -aoa"
  else if (7Zip_.opt.Overwrite = 1)
    Return " -aos"
  else if (7Zip_.opt.Overwrite = 2)
    Return " -aou"
  else if (7Zip_.opt.Overwrite = 3)
    Return " -aot"
  Else
    Return " -aoa"
} ;End Function

7Zip_DosDate(ByRef DosDate) {
  day   := DosDate & 0x1F
  month := (DosDate<<4) & 0x0F
  year  := ((DosDate<<8) & 0x3F) + 1980
  return "" . year . "/" . month . "/" . day
}

7Zip_DosTime(ByRef DosTime) {
  sec   := (DosTime & 0x1F) * 2
  min   := (DosTime<<4) & 0x3F
  hour  := (DosTime<<10) & 0x1F
  return "" . hour . ":" . min . ":" . sec
}

7Zip_DosDateTimeToStr( ByRef DosDate, ByRef DosTime) {
  VarSetCapacity(FileTime,8)
  DllCall("DosDateTimeToFileTime", "UShort", DosDate, "UShort", DosTime, "UInt", &FileTime)
  VarSetCapacity(SystemTime, 16, 0)
  If (!NumGet(FileTime,"UInt") && !NumGet(FileTime,4,"UInt"))
   Return 0
  DllCall("FileTimeToSystemTime", "PTR", &FileTime, "PTR", &SystemTime)
  Return NumGet(SystemTime,6,"short") ;date
    . "/" . NumGet(SystemTime,2,"short") ;month
    . "/" . NumGet(SystemTime,0,"short") ;year
    . " " . NumGet(SystemTime,8,"short") ;hours
    . ":" . ((StrLen(tvar := NumGet(SystemTime,10,"short")) = 1) ? "0" . tvar : tvar) ;minutes
    . ":" . ((StrLen(tvar := NumGet(SystemTime,12,"short")) = 1) ? "0" . tvar : tvar) ;seconds
  ;      . "." . NumGet(SystemTime,14,"short") ;milliseconds
}

/* STRUCTURES ------------------------------------------------------------------------------------------------------------------
typedef struct {
	DWORD	dwOriginalSize;  4 8
	DWORD	dwCompressedSize;  4 8
	DWORD	dwCRC; 4 8
	UINT	uFlag; 4 8
	UINT	uOSType; 4 8
	WORD	wRatio; 2 2
	WORD	wDate; 2 2
	WORD	wTime; 2 2
	char	szFileName[FNAME_MAX32 + 1]; 513 513
	char	dummy1[3]; 3 3
	char	szAttribute[8]; 8 8
	char	szMode[8]; 8 8
} INDIVIDUALINFO, *LPINDIVIDUALINFO;

tINDIVIDUALINFO 
VarSetCapacity(tINDIVIDUALINFO , 558, 0)

; typedef struct {
    dwOriginalSize := NumGet(tINDIVIDUALINFO , 0, "UInt")
    dwCompressedSize := NumGet(tINDIVIDUALINFO , 4, "UInt")
    dwCRC := NumGet(tINDIVIDUALINFO , 8, "UInt")
    uFlag := NumGet(tINDIVIDUALINFO , 12, "UInt")
    uOSType := NumGet(tINDIVIDUALINFO , 16, "UInt")
    wRatio := NumGet(tINDIVIDUALINFO , 20, "UShort")
    wDate := NumGet(tINDIVIDUALINFO , 22, "UShort")
    wTime := NumGet(tINDIVIDUALINFO , 24, "UShort")
    szFileName[%index%] := NumGet(tINDIVIDUALINFO , 26 + index, "Char"), szFileName_length := 513
    dummy1[%index%] := NumGet(tINDIVIDUALINFO , 539 + index, "Char"), dummy1_length := 3
    szAttribute[%index%] := NumGet(tINDIVIDUALINFO , 542 + index, "Char"), szAttribute_length := 8
    szMode[%index%] := NumGet(tINDIVIDUALINFO , 550 + index, "Char"), szMode_length := 8
; }

tEXTRACTINGINFO
VarSetCapacity(tEXTRACTINGINFO, 1040, 0)

; typedef struct {
    tEXTRACTINGINFO_dwFileSize := NumGet(tEXTRACTINGINFO, 0, "UInt")
    tEXTRACTINGINFO_dwWriteSize := NumGet(tEXTRACTINGINFO, 4, "UInt")
    tEXTRACTINGINFO_szSourceFileName[%index%] := NumGet(tEXTRACTINGINFO, 8 + index, "Char"), tEXTRACTINGINFO_szSourceFileName_length := 513
    tEXTRACTINGINFO_dummy1[%index%] := NumGet(tEXTRACTINGINFO, 521 + index, "Char"), tEXTRACTINGINFO_dummy1_length := 3
    tEXTRACTINGINFO_szDestFileName[%index%] := NumGet(tEXTRACTINGINFO, 524 + index, "Char"), tEXTRACTINGINFO_szDestFileName_length := 513
    tEXTRACTINGINFO_dummy[%index%] := NumGet(tEXTRACTINGINFO, 1037 + index, "Char"), tEXTRACTINGINFO_dummy_length := 3
; }


tEXTRACTINGINFOEX
VarSetCapacity(tEXTRACTINGINFOEX, 1074, 0)

; typedef struct {
    tEXTRACTINGINFOEX_exinfo := NumGet(tEXTRACTINGINFOEX, 0, "UInt")
    tEXTRACTINGINFOEX_dwCompressedSize := NumGet(tEXTRACTINGINFOEX, 1040, "UInt")
    tEXTRACTINGINFOEX_dwCRC := NumGet(tEXTRACTINGINFOEX, 1044, "UInt")
    tEXTRACTINGINFOEX_uOSType := NumGet(tEXTRACTINGINFOEX, 1048, "UInt")
    tEXTRACTINGINFOEX_wRatio := NumGet(tEXTRACTINGINFOEX, 1052, "UShort")
    tEXTRACTINGINFOEX_wDate := NumGet(tEXTRACTINGINFOEX, 1054, "UShort")
    tEXTRACTINGINFOEX_wTime := NumGet(tEXTRACTINGINFOEX, 1056, "UShort")
    tEXTRACTINGINFOEX_szAttribute[%index%] := NumGet(tEXTRACTINGINFOEX, 1058 + index, "Char"), tEXTRACTINGINFOEX_szAttribute_length := 8
    tEXTRACTINGINFOEX_szMode[%index%] := NumGet(tEXTRACTINGINFOEX, 1066 + index, "Char"), tEXTRACTINGINFOEX_szMode_length := 8
; }
------------------------------------------------------------------------------------------------------------------------------- 
*/