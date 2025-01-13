;|2.9|2024.01.09|1271
#NoEnv
#SingleInstance force
; 1271
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}

if !instr(CandySel, "`n")
{
	SplitPath, CandySel,, OutDir
	UnRAR(CandySel, OutDir)
}
Else
{
	loop, parse, CandySel, `n, `r
	{
		SplitPath, A_LoopField,, OutDir
		break
	}
	loop, parse, CandySel, `n, `r
	{
		UnRAR(A_LoopField, OutDir)
	}
}
return

; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?t=55680
; UnRAR.dll/UnRAR64.dll ahk demo, reads password from UTF-8 encoded "password.txt"
; UnRAR dlls at https://rarlab.com/rar_add.htm
; 只能解压 rar 文件, zip 文件提示错误 13

UnRar(RarFile, DestPath="")
{
	global UnPackSize, UnPackFileName, UnRARLog, Progress, TryPassword
	static	hModule
		, UnRAR := A_ScriptDir "\..\..\引用程序\x64\UnRAR.dll"
		, RarCallBack, Passwords
		, ERAR := {11:"内存不足", 12:"Bad data (broken header/CRC error)", 13:"Bad archive", 14:"Unknown encryption", 15:"不能打开文件", 16:"Cannot create file", 17:"Cannot close file", 18:"不能读取文件", 19:"Cannot write file", 20:"Buffer too small", 21:"Unknown error", 22:"缺少密码", 23:"Reference error", 24:"无效的密码"}

	If (A_PtrSize="" || A_PtrSize="4")
		A_PtrSize := 4, Ptr := "UInt", UnRAR := A_ScriptDir "\..\..\引用程序\x32\UnRAR.dll"

	If !hModule						; initialise
		if hModule := DllCall("LoadLibrary", "Str", UnRAR, Ptr)
			RarCallBack := RegisterCallBack("RarCallBack","",4)
		else {
			msgbox Cannot load %UnRAR%
			ExitApp
		}

	If !FileExist(RarFile)
	{
		msgbox %RarFile% not found
		return 15
	}

	If (DestPath="")
		DestPath := A_WorkingDir
	

	; msgbox % "UnRAR v" DllCall(UnRAR "\RARGetDllVersion")

/*
struct RAROpenArchiveDataEx
{				;32bit	64bit
  char         *ArcName;        ;0	0	Point to zero terminated Ansi archive name or NULL if Unicode name specified. 	
  wchar_t      *ArcNameW;       ;4      8	Point to zero terminated Unicode archive name or NULL.
  unsigned int  OpenMode;       ;8	16      RAR_OM_LIST = 0 (Read file headers, 只读取文件头，获取一些文件信息，而不解压文件); RAR_OM_EXTRACT = 1 (test/extract 为检测或者解压缩而打开压缩包); RAR_OM_LIST_INCSPLIT = 2 (read file headers incl split archives)
  unsigned int  OpenResult;     ;12	20	0 Success, ERAR_NO_MEMORY not enough memory, ERAR_BAD_DATA archive header broken, ERAR_UNKNOWN_FORMAT unknown encryption, EBAR_EOPEN open error, ERAR_BAD_PASSWORD invalid password (only for RAR5 archives)
  char         *CmtBuf;         ;16     24	buffer for comments (max 64kb), if nul comment not read, 设置存放注释缓冲区，最大不能超过64KB;设为null表示不读取注释
  unsigned int  CmtBufSize;     ;20     32	max size of comment buffer  设置缓冲区大小
  unsigned int  CmtSize;        ;24     36	size of comment stored 实际读取到的注释大小
  unsigned int  CmtState;       ;28     40	 输出注释状态, 0 No comments, 1 Comments read, ERAR_NO_MEMORY Not enough memory to extract comments, ERAR_BAD_DATA Broken comment, ERAR_SMALL_BUF Buffer is too small, comments are not read completely.
  unsigned int  Flags;          ;32     44	1 archive volume, 2 comment present, 4 locked archive, 8 solid, 16 new naming scheme (volname.partN.rar), 32 authenticity info present (obsolete), 64 recovery record present, 128 headers encrypted, 256 first volume (RAR3.0 or later)
  UNRARCALLBACK Callback;       ;36     48	callback address to process UnRAR events
  LPARAM        UserData;       ;40     56	Userdefined data to pass to callback
  unsigned int  Reserved[28];   ;44     64	Reserved for future use, must be zero
				;152    172
};
*/

	VarSetCapacity(RAROpenArchiveDataEx, (A_PtrSize*5) + 132, 0)
	Numput(&RarFile, RAROpenArchiveDataEx, A_PtrSize)
	Numput(1, RAROpenArchiveDataEx, A_PtrSize*2, "UInt")		; OpenMode
	;commit := 1
	;Numput(&commit, RAROpenArchiveDataEx, A_PtrSize*3, "UInt")
	;Numput(65536, RAROpenArchiveDataEx, A_PtrSize*4, "UInt")
	Numput(RarCallBack, RAROpenArchiveDataEx, A_PtrSize*3+24)

	Handle := DllCall(UnRAR "\RAROpenArchiveEx", Ptr, &RAROpenArchiveDataEx, Ptr)
	;msgbox % StrGet(&commit, "utf-8")
	If OpenResult := NumGet(RAROpenArchiveDataEx, A_PtrSize*2+4, "UInt")
	{
		msgbox % OpenResult ": " ERAR[OpenResult]
		Return OpenResult
	}

/*
struct RARHeaderDataEx
{				  ;32 bit	64 bit
  char         ArcName[1024];     ;0   		0
  wchar_t      ArcNameW[1024];    ;1024		1024
  char         FileName[1024];    ;3072		3072
  wchar_t      FileNameW[1024];   ;4096		4096
  unsigned int Flags;             ;6144		6144		; RHDF_SPLITBEFORE=1 Continued from previous volume, RHDF_SPLITAFTER=2 continued on next volume, RHDF_ENCRYPTED=4 encrypted, 8 reserved, 16 RHDF_SOLID, 32 RHDF_DIRECTORY
  unsigned int PackSize;          ;6148         6148
  unsigned int PackSizeHigh;      ;6152         6152
  unsigned int UnpSize;           ;6156         6156
  unsigned int UnpSizeHigh;       ;6160         6160
  unsigned int HostOS;            ;6164         6164
  unsigned int FileCRC;           ;6168         6168
  unsigned int FileTime;          ;6172         6172
  unsigned int UnpVer;            ;6176         6176
  unsigned int Method;            ;6180         6180
  unsigned int FileAttr;          ;6184         6184
  char         *CmtBuf;           ;6188         6192
  unsigned int CmtBufSize;        ;6192         6200
  unsigned int CmtSize;           ;6196         6204
  unsigned int CmtState;          ;6200         6208
  unsigned int DictSize;          ;6204         6212
  unsigned int HashType;          ;6208         6216
  char         Hash[32];          ;6212         6220
  unsigned int RedirType;	  ;6244		6252
  wchar_t      *RedirName;	  ;6248		6256
  unsigned int RedirNameSize;     ;6252		6264
  unsigned int DirTarget;         ;6256         6268
  unsigned int MtimeLow;          ;6260         6272
  unsigned int MtimeHigh;         ;6264         6276
  unsigned int CtimeLow;          ;6268         6280
  unsigned int CtimeHigh;         ;6272         6284
  unsigned int AtimeLow;          ;6276         6288
  unsigned int AtimeHigh;         ;6280         6292
  unsigned int Reserved[988]      ;6284         6296
};                                ;10236	10248
*/

	VarSetCapacity(RARHeaderDataEx, 10224 + A_PtrSize*3, 0)
	Gui, UnRAR:New									; output window
	Gui, Add, Edit, x5 vUnRARLog w400 r10
	Gui, Add, Progress, vProgress w400
	Gui, Add, Button, w75 Default gUnRARGuiClose, &OK 
	Gui, Add, Button, w75 x+25 gUnRARGuiEscape, Cancel
	Gui, Show,, %RarFile%

	; first pass to see if need to create dir
	NoDir := 0
	while !HeaderResult := DllCall(UnRAR "\RARReadHeaderEx", Ptr, Handle, Ptr, &RARHeaderDataEx)					; read file headers
	{
		if (NumGet(RARHeaderDataEx, 6144, "UInt") & 32)    ; 文件夹
		{
			NoDir++
			if (NoDir = 1)
			{
				UnPackFileName := StrGet(&RARHeaderDataEx+4096, "utf-16")
				orgDestPath := DestPath
				tmpPath := DestPath "\" UnPackFileName
				if FileExist(tmpPath)
				{ 
					SplitPath, tmpPath,,,, OutNameNoExt
					DestPath := PathU(DestPath "\" OutNameNoExt)  ; 指定将要解压到的的目录, 防止覆盖已存在的文件
				}
			}
		}

		if !(NumGet(RARHeaderDataEx, 6144, "UInt") & 32)	; 文件
		{
			If !InStr(UnPackFileName := StrGet(&RARHeaderDataEx+4096, "utf-16"), "\")					; count number of files without directory
			{
				;msgbox % UnPackFileName
				NoDir++
				if (NoDir = 1)
				{
					orgDestPath := DestPath
					tmpPath := DestPath "\" UnPackFileName
					if FileExist(tmpPath)
					{ 
						SplitPath, tmpPath,,,, OutNameNoExt
						DestPath := PathU(DestPath "\" OutNameNoExt)  ; 指定将要解压到的的目录, 防止覆盖已存在的文件
					}
				}
			}
		}
		If NoDir>1
		{
			;DestPath := RegExReplace(DestPath, "\\$") "\" RegExReplace(RarFile, "i)part\d+\.rar|\.[^\.]+$")		; automatically create folder based on archive name
			DestPath := orgDestPath
			SplitPath, RarFile,,,, OutNameNoExt
			DestPath := PathU(RegExReplace(DestPath, "\\$") "\" OutNameNoExt)   ; 指定将要解压到的目录, 不存在的话会自动创建
			break
		}

		;msgbox % DestName "-33"
		if ProcessResult := DllCall(UnRAR "\RARProcessFileW", Ptr, Handle, "Int", 0, Ptr, &DestPath, Ptr, &DestName)		; process & move to next file in archive (RAR_SKIP=0)
			Break
	}
  ;msgbox % DestPath
	; second pass to extract
	DllCall(UnRAR "\RARCloseArchive", Ptr, Handle)						; re-open RAR file ... can't find an easy way to restart
	Handle := DllCall(UnRAR "\RAROpenArchiveEx", Ptr, &RAROpenArchiveDataEx, Ptr)
	VarSetCapacity(RARHeaderDataEx, 10224 + A_PtrSize*3, 0)
	PasswordIdx := 1, TriedPasswords := "`n"						; initialize password attempts for current archive
	haveunrarfile_obj := {}

	while !HeaderResult := DllCall(UnRAR "\RARReadHeaderEx", Ptr, Handle, Ptr, &RARHeaderDataEx)
	{
		UnPackFileName := StrGet(&RARHeaderDataEx+4096 ,"utf-16")
		UnPackSize := NumGet(RARHeaderDataEx, 6156, "UInt")
		Progress := 0, DestName := "", Flags := NumGet(RARHeaderDataEx, 6144, "UInt") 
		if Flags & 4		; If encrypted
		{
			If !Passwords	
			{
        passtxtfile := A_ScriptDir "\..\..\配置文件\外部脚本\文件处理\解压密码.txt"
        if !fileexist(passtxtfile)
          FileCopy % A_ScriptDir "\..\..\配置文件\外部脚本\文件处理\解压密码_默认配置.txt", % passtxtfile
				FileRead, src, *P65001 %passtxtfile%    ; 1200 unicode or 65001 UTF-8
				Passwords := StrSplit(RegExReplace(src, "[`r`n]+", "`n"), "`n")	; Initialise array, skip blank lines
				;msgbox % Array_ToString(Passwords)
			}
			If !TryPassword								; Use Last successful password if available
				TryPassword := Passwords[PasswordIdx]
		}

		UnRARLog .= UnPackFileName 
		GuiControl,, UnRARLog, %UnRARLog%

		if ProcessResult := DllCall(UnRAR "\RARProcessFileW", Ptr, Handle, "Int", 2, Ptr, &DestPath, Ptr, &DestName)	; RAR_SKIP=0, RAR_TEST=1, RAR_EXTRACT=2
		{
			if haveunrarfile_obj[UnPackFileName]
				continue
			if (StrLen(TryPassword) > 0) && (ProcessResult=12 || ProcessResult=24)		; if unsuccessful password (crc / password error)
			{
				TriedPasswords .= TryPassword "`n"				; save previously tried passwords to avoid duplicates
				TryPassword := ""						; make password nul to signal that last password failed
				While (Passwords.Length() >= PasswordIdx)			; loop through passwords in password list, starting at first password
				{
					If !Instr(TriedPasswords, "`n" Passwords[PasswordIdx] "`n", 1)	; skip duplicate passwords
						break
					PasswordIdx++
				}
				
				DllCall(UnRAR "\RARCloseArchive", Ptr, Handle)			; re-open RAR file ... can't find an easy way to restart
				Handle := DllCall(UnRAR "\RAROpenArchiveEx", Ptr, &RAROpenArchiveDataEx, Ptr)
				VarSetCapacity(RARHeaderDataEx, 10224 + A_PtrSize*3, 0)
				continue
			}
			;msgbox % TryPassword
			GuiControl,,UnRARLog, % UnRARLog " 错误号 #" ProcessResult ": " ERAR[ProcessResult] "`n"
				Break
		}

		UnRARLog .= "`t(" UnPackSize " bytes)`n"
		if Flags & 4									; save successful password to file & password list if user provided password
		{
			; 使用密码解压成功
			haveunrarfile_obj[UnPackFileName] := 1
			UnRARLog .= "Password #" PasswordIdx ": " TryPassword "`n"
			If Passwords.Length() < PasswordIdx
			{
				FileAppend, `n%TryPassword%, %passtxtfile%, UTF-8
				Passwords[PasswordIdx] := TryPassword
			}  
		}
		GuiControl,, UnRARLog, %UnRARLog%
	}
	If (HeaderResult>10)
		GuiControl,, UnRARLog, % UnRARLog "Header error #" HeaderResult ": " ERAR[HeaderResult]
	DllCall(UnRAR "\RARCloseArchive", Ptr, Handle)
}

UnRARGuiEscape:
UnRARGuiClose:
ExitApp

RarCallback(Msg, User, P1, P2){		; Msg UCM_CHANGEVOLUME = 0, UCM_PROCESSDATA = 1, UCM_NEEDPASSWORD = 2, UCM_CHANGEVOLUMEW = 3, UCM_NEEDPASSWORDW = 4
	global UnPackSize, Progress, TryPassword, UnPackFileName
	If (Msg==0 || Msg==3) && (!P2) 	; P1 = next volume name, Param2 = RAR_VOL_ASK = 0, RAR_VOL_NOTIFY = 1
	{
		Vol := StrGet(P1, Msg ? "utf-16" : "cp0")
		InputBox, Path, Next volume %P1% not found, Please enter path of next volume,,,,,,,,%P1%
		IfNotEqual, ErrorLevel, 0, Return, -1
		StrPut(Path, P1, 1024, Msg ? "utf-16" : "cp0")
	} else if (Msg=1) {		; P1 = pointer to unpacked data (read only, do not modify), P2 = size of unpacked data
		Progress += P2
		GuiControl, UnRAR:, Progress, % Progress*400/UnPackSize
	} else if (Msg=2 || Msg=3){	; P1 = pointer to password buffer, P2 = size of buffer
		if (StrLen(TryPassword) = 0)	; Ask for password if no password available
		{
			InputBox, TryPassword, Password required for %UnPackFileName%, Please enter password for %UnPackFileName%,,,,,,,,
			IfNotEqual, ErrorLevel, 0, Return, -1
		}
		;msgbox % TryPassword
		StrPut(TryPassword, P1, P2, Msg=3 ? "utf-16" : "cp0")
	}
	return 1
}

toHex( ByRef V, ByRef H, dataSz:=0 )
{ ; http://goo.gl/b2Az0W (by SKAN)
	P := ( &V-1 ), VarSetCapacity( H,(dataSz*2) ), Hex := "123456789ABCDEF0"
	Loop, % dataSz ? dataSz : VarSetCapacity( V )
		H  .=  SubStr(Hex, (*++P >> 4), 1) . SubStr(Hex, (*P & 15), 1)
}

PathU(Filename) { ;  PathU v0.91 by SKAN on D35E/D68M @ tiny.cc/pathu
Local OutFile
  VarSetCapacity(OutFile, 520)
  DllCall("Kernel32\GetFullPathNameW", "WStr",Filename, "UInt",260, "Str",OutFile, "Ptr",0)
  DllCall("Shell32\PathYetAnotherMakeUniqueName", "Str",OutFile, "Str",Outfile, "Ptr",0, "Ptr",0)
Return A_IsUnicode ? OutFile : StrGet(&OutFile, "UTF-16")
}

Array_ToString(array, depth=5, indentLevel="")
{
   for k,v in Array
   {
      list.= indentLevel "[" k "]"
      if (IsObject(v) && depth>1)
         list.="`n" Array_ToString(v, depth-1, indentLevel . "    ")
      Else
         list.=" => " v
      list.="`n"
   }
   return rtrim(list)
}