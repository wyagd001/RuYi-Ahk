#SingleInstance force
CandySel := A_Args[1]
CandySel2 := A_Args[2]
OnMessage(0x4a, "Receive_WM_COPYDATA")
cando_MD5:
Gui, 66: Default
Nomd5func := 0
;IfWinActive,ahk_Group ccc
IfWinExist, MD5验证
{
	Md5FilePath2 := CandySel2

	if (Md5FilePath2 = Md5FilePath)
		Return
	GuiControl, enable, CRC32_2
	GuiControl, enable, del2
	GuiControl,, Md5FilePath2, %Md5FilePath2%
	GuiControl,, hash2, % MD5_File(Md5FilePath2)
	WinActivate, MD5验证
}
Else
{
	Md5FilePath := CandySel
	if (Md5FilePath = "")
		exitapp
	SplitPath, Md5FilePath, OutFileName,, OutExtension, OutNameNoExt
	if CandySel2
		Md5FilePath2 := CandySel2
	else
		Md5FilePath2 := ""
	if !FileExist(Md5FilePath2)
	{
		AllOpenFolder := GetAllWindowOpenFolder()
		for k,v in AllOpenFolder
		{
			Tmp_Fp := v "\" OutNameNoExt
			Tmp_Fp := StrReplace(Tmp_Fp, "\\", "\")
			if FileExist(Tmp_Fp "*.*")
			{
				if FileExist(Tmp_Fp "." OutExtension) && (Tmp_Fp (OutExtension?".":"") OutExtension != Md5FilePath)
				{
					Md5FilePath2 := Tmp_Fp (OutExtension?".":"") OutExtension
					break
				}
				Loop, Files, % Tmp_Fp "*.*", F
				{
					if InStr(A_LoopFileName, OutNameNoExt) && (A_LoopFileName != OutFileName)
					{
						Md5FilePath2 := v "\" A_LoopFileName
						Md5FilePath2 := StrReplace(Md5FilePath2, "\\", "\")
						break 2
					}
				}
			}
		}
	}
	AllOpenFolder := ""

	Gui, add, text, x5, 文件1
	Gui, Add, edit, x+10 VMd5FilePath readonly w350, %Md5FilePath%
	Gui, add, edit, y+7 h20 w350 Vhash readonly cblue,
	Gui, Add, Button, x+5 w65 h20 gdelfile, 删除文件1
	Gui, add, text, yp-25 w60 cgreen vCRC32 gCRC32, CRC32

	Gui, add, text, x5, 文件2
	Gui, Add, edit, x+10 VMd5FilePath2 w350 readonly,
	Gui, add, edit, y+7 h20 w350 Vhash2 readonly gTrueorFalse cblue,
	Gui, Add, Button, x+5 w65 h20 vdel2 gdelfile, 删除文件2
	Gui, add, text, yp-25 w60 cgreen vCRC32_2 gCRC32, CRC32

	Gui, add, text, x5, 两文件是否相同：
	Gui, add, text, x+1 vtof w30,

	GuiControl, disable, CRC32_2
	GuiControl, disable, del2
	Gui, Show,, MD5验证

	GuiControl,, hash, % MD5_File(Md5FilePath)

	if Md5FilePath2
	{
		GuiControl, enable, CRC32_2
		GuiControl, enable, del2
		GuiControl,, Md5FilePath2, %Md5FilePath2%

		GuiControl,, hash2, % MD5_File(Md5FilePath2)
	}
}

Gosub TrueorFalse
Return

66GuiClose:
66GuiEscape:
Gui, 66: Destroy
exitapp
Return

Receive_WM_COPYDATA(wParam, lParam)
{
	Global CandySel2
	StringAddress := NumGet(lParam + 2*A_PtrSize)  ; 获取 CopyDataStruct 的 lpData 成员.
	CandySel2 := StrGet(StringAddress)  ; 从结构中复制字符串.
	gosub cando_MD5
return true
}

TrueorFalse:
GuiControlGet, hash,, hash
GuiControlGet, hash2,, hash2
if(hash=hash2)
{
	Gui, Font, cgreen bold
	GuiControl, Font, tof
	GuiControl,, tof, 是
}
Else
{
	Gui, Font, cred bold
	GuiControl, Font, tof
	GuiControl,, tof, 否
}
Return

66GuiDropFiles:
	Loop, parse, A_GuiEvent, `n
	{
		FileGetAttrib, Attributes, %A_LoopField%
		IfEqual A_guicontrol, Md5FilePath
		{
			IfInString, Attributes, D
			return  ; exit if it is folder
			GuiControl,, %A_guicontrol%, %A_LoopField%  ; to asign filename to a control
			GuiControl,, hash, % MD5_File(A_LoopField)
		}
		IfEqual A_guicontrol, Md5FilePath2
		{
			IfInString, Attributes, D
			return  ; exit if it is folder
			GuiControl,, %A_guicontrol%, %A_LoopField%  ; to asign filename to a control
			GuiControl, enable, CRC32_2
			GuiControl, enable, del2
			GuiControl,, hash2, % MD5_File(A_LoopField)
		}
	}

	Gosub TrueorFalse
return

delfile:
GuiControlGet, whichbutton, Focus
if whichbutton = Button1
	delfile = Md5FilePath
else 
	delfile = Md5FilePath2
GuiControlGet, Md5FilePath,, %delfile%
MsgBox, 4, 删除提示, 确定要把下面的文件放入回收站吗？`n`n%Md5FilePath%
IfMsgBox Yes
	FileRecycle, %Md5FilePath%
return

CRC32:
if A_GuiControl =CRC32
{
	CRCfile = Md5FilePath
	whichstatic = static2 
}
else 
{
	CRCfile = Md5FilePath2
	whichstatic = static4
}
Gui, Font, cblue bold
GuiControl,Font, %A_GuiControl%
GuiControlGet, Md5FilePath,, %CRCfile%
GuiControl,, %A_GuiControl%, % FileCRC32(Md5FilePath)
ControlGetText, CRC32, %whichstatic% 
Clipboard := CRC32
Return

Ansi2Unicode(ByRef wString, ByRef mString, CP = 0)
{
	nSize := DllCall("MultiByteToWideChar", "Uint", CP, "Uint", 0, "Uint", &mString, "int",  -1, "Uint", 0, "int", 0)
	VarSetCapacity(wString, nSize * 2,0)
	DllCall("MultiByteToWideChar", "Uint", CP, "Uint", 0, "Uint", &mString, "int",  -1, "Uint", &wString, "int", nSize)
Return	&wString
}

; ************  MD5 hashing functions by Laszlo  *******************

MD5_File( sFile="", cSz=4 ) { ; www.autohotkey.com/forum/viewtopic.php?p=275910#275910
	global Nomd5func
 cSz  := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 )
 hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,1,Int,0,Int,3,Int,0,Int,0)
 IfLess,hFil,1, Return,hFil
 DllCall( "GetFileSizeEx", UInt,hFil, Str,Buffer ),   fSz := NumGet( Buffer,0,"Int64" )
 VarSetCapacity( MD5_CTX,104,0 ),    DllCall( "advapi32\MD5Init", Str,MD5_CTX )
	LoopNum := fSz//cSz
 Loop % ( LoopNum +!!Mod(fSz,cSz) )
	{
		if (LoopNum > 125)
				tooltip % (A_index * cSz *100) / fSz "%"
   DllCall( "ReadFile", UInt,hFil, Str,Buffer, UInt,cSz, UIntP,bytesRead, UInt,0 )
 , DllCall( "advapi32\MD5Update", Str,MD5_CTX, Str,Buffer, UInt,bytesRead )
	if Nomd5func
	break
	}
	if (LoopNum > 125)
		tooltip
 DllCall( "advapi32\MD5Final", Str,MD5_CTX ), DllCall( "CloseHandle", UInt,hFil )
 Loop % StrLen( Hex:="123456789ABCDEF0" )
  N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
Return MD5
}

MD5( ByRef V, L=0 ) { ; www.autohotkey.com/forum/viewtopic.php?p=275910#275910
 VarSetCapacity( MD5_CTX,104,0 ), DllCall( "advapi32\MD5Init", Str,MD5_CTX )
 DllCall( "advapi32\MD5Update", Str,MD5_CTX, Str,V, UInt,L ? L : VarSetCapacity(V) )
 DllCall( "advapi32\MD5Final", Str,MD5_CTX )
 Loop % StrLen( Hex:="123456789ABCDEF0" )
  N := NumGet( MD5_CTX,87+A_Index,"Char"), MD5 .= SubStr(Hex,N>>4,1) . SubStr(Hex,N&15,1)
Return MD5
}

FileCRC32( sFile="",cSz=4 ) { ; by SKAN www.autohotkey.com/community/viewtopic.php?t=64211
 cSz := (cSz<0||cSz>8) ? 2**22 : 2**(18+cSz), VarSetCapacity( Buffer,cSz,0 ) ; 10-Oct-2009
 hFil := DllCall( "CreateFile", Str,sFile,UInt,0x80000000, Int,3,Int,0,Int,3,Int,0,Int,0 )
 IfLess,hFil,1, Return,hFil
 hMod := DllCall( "LoadLibrary", Str,"ntdll.dll" ), CRC32 := 0
 DllCall( "GetFileSizeEx", UInt,hFil, UInt,&Buffer ),    fSz := NumGet( Buffer,0,"Int64" )
 Loop % ( fSz//cSz + !!Mod( fSz,cSz ) )
   DllCall( "ReadFile", UInt,hFil, UInt,&Buffer, UInt,cSz, UIntP,Bytes, UInt,0 )
 , CRC32 := DllCall( "NTDLL\RtlComputeCrc32", UInt,CRC32, UInt,&Buffer, UInt,Bytes, UInt )
 DllCall( "CloseHandle", UInt,hFil )
 SetFormat, Integer, % SubStr( ( A_FI := A_FormatInteger ) "H", 0 )
 CRC32 := SubStr( CRC32 + 0x1000000000, -7 ), DllCall( "CharUpper", Str,CRC32 )
 SetFormat, Integer, %A_FI%
Return CRC32, DllCall( "FreeLibrary", UInt,hMod )
}

GetAllWindowOpenFolder()
{
	if WinActive("ahk_class TTOTAL_CMD")
	return TC_getTwoPath()

	QtTabBarObj := QtTabBar()
	if QtTabBarObj
	{
		OPenedFolder := QtTabBar_GetAllTabs()
	}
	else
	{
		OPenedFolder := []
		ShellWindows := ComObjCreate("Shell.Application").Windows
		for w in ShellWindows
		{
			Tmp_Fp := w.Document.Folder.Self.path
			if (Tmp_Fp)
				if FileExist(Tmp_Fp)
				{
					OPenedFolder.push(Tmp_Fp)
				}
		}
	}
return OPenedFolder
}

TC_getTwoPath()
{
	DetectHiddenText, On
	WinGetText, TCWindowText, Ahk_class TTOTAL_CMD
	m := RegExMatchAll(TCWindowText, "m)(.*)\\\*\.\*", 1)
	return m
}

QtTabBar()
{
	try QtTabBarObj := ComObjCreate("QTTabBarLib.Scripting")
	if IsObject(QtTabBarObj)
	return 1
	else
	return 0
}

QtTabBar_GetAllTabs()
{
	ScriptCode = 
	(
		OPenedFolder_Str := GetAllWindowOpenFolder()
		FileAppend `% OPenedFolder_Str, *

		GetAllWindowOpenFolder()
		{
			OPenedFolder_Str := ""
			QtTabBarObj := ComObjCreate("QTTabBarLib.Scripting")
			if QtTabBarObj
			{
				for k in QtTabBarObj.Windows
					for w in k.Tabs
					{
						Tmp_Fp := w.path
						if (Tmp_Fp)
							if FileExist(Tmp_Fp)
							{
								OPenedFolder_Str .= Tmp_Fp "``n"
							}
					}
			}
		return OPenedFolder_Str
		}
	)

	OPenedFolder_Str := RunScript(ScriptCode, 1)
	OPenedFolder_Str := Trim(OPenedFolder_Str, " `t`n")
	OPenedFolder := StrSplit(OPenedFolder_Str, "`n")
return OPenedFolder
}

RegExMatchAll(ByRef Haystack, NeedleRegEx, SubPat="")
{
	arr := [], startPos := 1
	while ( pos := RegExMatch(Haystack, NeedleRegEx, match, startPos) )
	{
		arr.push(match%SubPat%)
		startPos := pos + StrLen(match)
	}
	return arr.MaxIndex() ? arr : ""
}

RunScript(script, WaitResult:="false")
{
	static test_ahk := A_AhkPath,
	shell := ComObjCreate("WScript.Shell")
	BackUp_WorkingDir:= A_WorkingDir
	SetWorkingDir %A_ScriptDir%
	exec := shell.Exec(chr(34) test_ahk chr(34) " /ErrorStdOut *")
	exec.StdIn.Write(script)
	exec.StdIn.Close()
	SetWorkingDir %BackUp_WorkingDir%
	if WaitResult
		return exec.StdOut.ReadAll()
	else 
return
}