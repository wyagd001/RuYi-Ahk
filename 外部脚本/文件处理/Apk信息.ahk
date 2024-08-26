;|2.8|2024.08.24|1660
#SingleInstance force
CandySel := A_Args[1]

Aapt := GetFullPathName(A_ScriptDir "\..\..\引用程序\x32\aapt.exe")
;msgbox % Aapt " dump badging """ CandySel """"
ApkInfo := RunCmd(Aapt " dump badging """ CandySel """", , "UTF-8")
RegExMatch(ApkInfo, "icon='(.*?)'", iconfile)   ; 图标文件
RegExMatch(ApkInfo, "application-label-zh_CN:'(.*?)'", zhcnname)
if !zhcnname1
  RegExMatch(ApkInfo, "application-label:'(.*?)'", zhcnname)
RegExMatch(ApkInfo, "name='(.*?)'", name)
RegExMatch(ApkInfo, "versionName='(.*?)'", versionName)
RegExMatch(ApkInfo, "versionCode='(.*?)'", versionCode)
Tmp_str := "名称: " zhcnname1 "`n"
Tmp_str .= "包名: " Name1 "`n"
Tmp_str .= "版本号: " versionName1 "`n"
Tmp_str .= "版本代码: " versionCode1 "`n"
Tmp_str .= "-----------------------------`n"
ApkInfo := Tmp_str ApkInfo

If !( o7z := 7Zip_Init() )
  Quit("Failed loading 7-zip32.dll library")
global sDllPath
o7z.opt.Hide := 1
o7z.opt.ExtractPaths := 0
o7z.opt.Output := GetFullPathName(A_ScriptDir "\..\..\临时目录")
o7z.opt.IncludeFile := iconfile1
if iconfile1
  7Zip_Extract(CandySel)
RegExMatch(iconfile1, ".*/([^/]+)$", filename)
;msgbox % filename "|" filename1 "|" o7z.opt.Output
iconfile := o7z.opt.Output "\icon.png"
filedelete, % iconfile
if filename1
  FileMove, % o7z.opt.Output "\" filename1, % iconfile
GuiText(ApkInfo, "Apk 信息", 600)
return

F2::
ControlGet, Tmp_V, Selected,, Edit1, A
if Tmp_V
{
  SplitPath, CandySel,, Prew_File_ParentPath, Prew_File_Ext
  TargetFile := PathU(Prew_File_ParentPath "\" Tmp_V "." Prew_File_Ext)
  ;msgbox % Tmp_V "|" TargetFile 
  FileMove, % CandySel, % TargetFile
}
return

PathU(Filename) { ;  PathU v0.91 by SKAN on D35E/D68M @ tiny.cc/pathu
Local OutFile
  VarSetCapacity(OutFile, 520)
  DllCall("Kernel32\GetFullPathNameW", "WStr",Filename, "UInt",260, "Str",OutFile, "Ptr",0)
  DllCall("Shell32\PathYetAnotherMakeUniqueName", "Str",OutFile, "Str",Outfile, "Ptr",0, "Ptr",0)
Return A_IsUnicode ? OutFile : StrGet(&OutFile, "UTF-16")
}

Quit(Msg) {
  MsgBox % Msg
  ExitApp
}

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}

RunCmd(CmdLine, WorkingDir:="", Cp:="CP0") { ; Thanks Sean!  SKAN on D34E @ tiny.cc/runcmd 
  Local P8 := (A_PtrSize=8),  pWorkingDir := (WorkingDir ? &WorkingDir : 0)                                                
  Local SI, PI,  hPipeR:=0, hPipeW:=0, Buff, sOutput:="",  ExitCode:=0,  hProcess, hThread
                   
  DllCall("CreatePipe", "PtrP",hPipeR, "PtrP",hPipeW, "Ptr",0, "UInt",0)
, DllCall("SetHandleInformation", "Ptr",hPipeW, "UInt",1, "UInt",1)
    
  VarSetCapacity(SI, P8? 104:68,0),      NumPut(P8? 104:68, SI)
, NumPut(0x100, SI,  P8? 60:44,"UInt"),  NumPut(hPipeW, SI, P8? 88:60)
, NumPut(hPipeW, SI, P8? 96:64)   

, VarSetCapacity(PI, P8? 24:16)               

  If not DllCall("CreateProcess", "Ptr",0, "Str",CmdLine, "Ptr",0, "UInt",0, "UInt",True
              , "UInt",0x08000000 | DllCall("GetPriorityClass", "Ptr",-1,"UInt"), "UInt",0
              , "Ptr",pWorkingDir, "Ptr",&SI, "Ptr",&PI )  
     Return Format( "{1:}", "" 
          , DllCall("CloseHandle", "Ptr",hPipeW)
          , DllCall("CloseHandle", "Ptr",hPipeR)
          , ErrorLevel := -1 )
  DllCall( "CloseHandle", "Ptr",hPipeW)

, VarSetCapacity(Buff, 4096, 0), nSz:=0   
  While DllCall("ReadFile",  "Ptr",hPipeR, "Ptr",&Buff, "UInt",4094, "PtrP",nSz, "UInt",0)
    sOutput .= StrGet(&Buff, nSz, Cp)

  hProcess := NumGet(PI, 0),  hThread := NumGet(PI,4)
, DllCall("GetExitCodeProcess", "Ptr",hProcess, "PtrP",ExitCode)
, DllCall("CloseHandle", "Ptr",hProcess),    DllCall("CloseHandle", "Ptr",hThread)
, DllCall("CloseHandle", "Ptr",hPipeR),      ErrorLevel := ExitCode  
Return sOutput  
}

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd, iconfile
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd +Resize
  Gui, add, Picture, , %iconfile%
	Gui, Add, Edit, Multi readonly xM+2 w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	;GuiTextGuiescape:
	Gui, GuiText: Destroy
	exitapp
	Return

	GuiTextGuiSize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	AutoXYWH("wh", "myedit")
	return
}

; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
; ---------------------------------------------------------------------------------
; Version: 2015-5-29 / Added 'reset' option (by tmplinshi)
;          2014-7-03 / toralf
;          2014-1-2  / tmplinshi
; requires AHK version : 1.1.13.01+
; =================================================================================
AutoXYWH(DimSize, cList*){       ; http://ahkscript.org/boards/viewtopic.php?t=1079
  static cInfo := {}
 
  If (DimSize = "reset")
    Return cInfo := {}
 
  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If ( cInfo[ctrlID].x = "" ){
        GuiControlGet, i, %A_Gui%:Pos, %ctrl%
        MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
        fx := fy := fw := fh := 0
        For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
            If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
              f%dim% := 1
        cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
    }Else If ( cInfo[ctrlID].a.1) {
        dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
        For i, dim in cInfo[ctrlID]["a"]
            Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
        GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
} } }

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
; Syntax: 7Zip_Add(sArcName, hWnd)
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
; Syntax: 7Zip_Add(sArcName, sFileName, hWnd)
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
; Syntax: 7Zip_Delete(sArcName, sFileName, hWnd)
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
; Syntax: 7Zip_Extract(sArcName, hWnd)
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
; Syntax: 7Zip_Update(sArcName, sFileName, hWnd)
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
; Syntax: 7Zip_SetOwnerWindowEx(sProcFunc, hWnd)
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