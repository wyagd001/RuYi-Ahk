folder1 :=  A_Args[1]
folder2 :=  A_Args[2]
; 1088
OnMessage(0x4a, "Receive_WM_COPYDATA")
SyncFolder:
IfWinExist, �ļ���ͬ�� ahk_class AutoHotkeyGUI
{
	folder2 := CandySel2
	GuiControl,, folder2, %folder2%
}
Else
{
	Gui,66:Destroy
	Gui,66: Default
	SplitPath, folder1, OutFileName
	AllOpenFolder := GetAllWindowOpenFolder()
	for k,v in AllOpenFolder
	{
		if (v = folder1)
			Continue
		SplitPath, v, Tmp_OutFileName
		if (OutFileName = Tmp_OutFileName)
		{
			folder2 := v
			break
		}
	}
	Gui, Add, text, x10 y10, Դ�ļ���:
	Gui, Add, edit, xp+70 w480 vfolder1, % folder1
	Gui, Add, text, xp+500, Ŀ���ļ���:
	Gui, Add, edit, xp+80 y10 w460 vfolder2, % folder2
	Gui, Add, ListView, x10 y40 w550 h500 vfilelist1 hwndHLV1 Checked AltSubmit gsync, ���|�ļ���|�޸�����|��С|md5
	Gui, Add, ListView, x570 y40 w550 h500 vfilelist2 hwndHLV2 Checked AltSubmit gsync, ���|�ļ���|�޸�����|��С|���|md5
	Gui, Add, Button, x10 yp+510 h30 gloderfolder, �����б�
	Gui, Add, Button, xp+70 h30 grpview, Ԥ�����
	Gui, Add, Button, xp+70 h30 gsave, ִ��ͬ��
	gui, show,, �ļ���ͬ��
}
return

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

Receive_WM_COPYDATA(wParam, lParam)
{
	Global CandySel2
	StringAddress := NumGet(lParam + 2*A_PtrSize)  ; ��ȡ CopyDataStruct �� lpData ��Ա.
	CandySel2 := StrGet(StringAddress)  ; �ӽṹ�и����ַ���.
	gosub SyncFolder
return true
}

On_WM_NOTIFY(W, L, M, H) {
   Global HLV1, HLV2, IH
   HLV := NumGet(L + 0, "UPtr")
   If ((HLV = HLV1) || (HLV = HLV2)) && (NumGet(L + (A_PtrSize * 2), "Int") = -181) { ; LVN_ENDSCROLL
      XD := NumGet(L + (A_PtrSize * 3), 0, "Int")
      , YD := NumGet(L + (A_PtrSize * 3), 4, "Int")
      , HLV := (HLV = HLV1) ? HLV2 : HLV1
      , DllCall("SendMessage", "Ptr", HLV, "Int", 0x1014, "Ptr", XD, "Ptr", YD * IH) ; LVM_SCROLL
   }
}
;  --------------------------------------------------------------------------------------------------
LV_GetItemHeight(HLV) {
   VarSetCapacity(RC, 16, 0)
   If DllCall("SendMessage", "Ptr", HLV, "UInt", 0x100E, "Ptr", 0, "Ptr", &RC) ; LVM_GETITEMRECT
      Return (NumGet(RC, 12, "Int") - NumGet(RC, 4, "Int"))
   Return 0
}

loderfolder:
Gui, 66: Default
Gui, submit, nohide
;folder1:="D:\����\autohotkey ����\v2\docs"
;folder2:="F:\Program Files\����\git\wyagd001.github.io\v2\docs"
IniRead, ����Ŀ¼, %folder1%\.�����б�.ini, Ŀ¼, ����Ŀ¼
IniRead, �����ļ�, %folder1%\.�����б�.ini, �ļ�
Gui, ListView, filelist1
LV_Delete()
Gui, ListView, filelist2
LV_Delete()
folderobj1:={}
folderobj2:={}
flastwriteobj1:={}
flastwriteobj2:={}
fsizeobj1:={}
fsizeobj2:={}
fMD5obj1:={}
fMD5obj2:={}
Tmp_Str:=""

if folder1
Loop, Files, %folder1%\*.*, DFR
{
	if A_LoopFileAttrib contains H,R,S
		continue
	relativePS := StrReplace(A_LoopFilePath, folder1 "\")
	if relativePS contains %����Ŀ¼%
		Continue
	if instr(�����ļ�, relativePS)
		Continue

	if InStr(A_LoopFileAttrib, "D")
		folderobj1[relativePS] := "folder"
	else
		folderobj1[relativePS] := 1
	flastwriteobj1[relativePS] := A_LoopFileTimeModified
	fsizeobj1[relativePS] := A_LoopFileSizeKB
	fMD5obj1[relativePS] := MD5_File(A_LoopFilePath)
	Tmp_Str .= relativePS "`n"
}

if folder2
Loop, Files, %folder2%\*.*, DFR
{
	if A_LoopFileAttrib contains H,R,S
		continue
	relativePS := StrReplace(A_LoopFilePath, folder2 "\")
	if relativePS contains %����Ŀ¼%
		Continue
	if instr(�����ļ�, relativePS)
		Continue

	if InStr(A_LoopFileAttrib, "D")
		folderobj2[relativePS] := "folder"
	else
		folderobj2[relativePS] := 1
	flastwriteobj2[relativePS] := A_LoopFileTimeModified
	fsizeobj2[relativePS] := A_LoopFileSizeKB
	fMD5obj2[relativePS] := MD5_File(A_LoopFilePath)
	Tmp_Str .= relativePS "`n"
}

Tmp_Str := Trim(Tmp_Str, "`n")
Sort, Tmp_Str, U

Loop, parse, Tmp_Str, `n, `r
{
	Gui, ListView, filelist1
	if folderobj1.HasKey(A_LoopField)
	{
		LV_Add("", A_Index, A_LoopField, flastwriteobj1[A_LoopField], fsizeobj1[A_LoopField], fMD5obj1[A_LoopField])
	}
	else
	{
		;msgbox % A_LoopField
		LV_Add("", A_Index, "��")
	}

	Gui, ListView, filelist2
	if folderobj2.HasKey(A_LoopField)
	{
		if (fMD5obj2[A_LoopField]=fMD5obj1[A_LoopField])
		{
			LV_Add("", A_Index, A_LoopField, flastwriteobj2[A_LoopField], fsizeobj2[A_LoopField], "��", fMD5obj2[A_LoopField])
		}
		else
		{
			LV_Add("", A_Index, A_LoopField, flastwriteobj2[A_LoopField], fsizeobj2[A_LoopField], "��", fMD5obj2[A_LoopField])
			if folderobj1.HasKey(A_LoopField)
			{
				Gui, ListView, filelist1
				LV_Modify(A_Index, "check")
			}
			else
				LV_Modify(A_Index, "check")
		}
	}
	else
	{
		LV_Add("", A_Index, "��")
		Gui, ListView, filelist1
		LV_Modify(A_Index, "check")
	}
}

Gui, ListView, filelist1
LV_ModifyCol()
Gui, ListView, filelist2
LV_ModifyCol()
IH := LV_GetItemHeight(HLV1)
OnMessage(0x004E, "On_WM_NOTIFY")
return

sync:
if (A_GuiControl = "filelist1") && (A_GuiEvent = "Normal")
{
	Gui, ListView, filelist1
	RF := LV_GetNext("F")
	Gui, ListView, filelist2
	LV_Modify(0, "-Select")
	LV_Modify(RF, "Select Focus Vis")
}
if (A_GuiControl = "filelist2") && (A_GuiEvent = "Normal")
{
	Gui, ListView, filelist2
	RF := LV_GetNext("F")
	tooltip % RF
	Gui, ListView, filelist1
	LV_Modify(0, "-Select")
	LV_Modify(RF, "Select Focus Vis")
}
return

66GuiClose:
66Guiescape:
Gui,66: Destroy
exitapp
Return

save:
Gui, 66: Default
Gui, ListView, filelist1
RowNumber := 0  ; ����ʹ���״�ѭ�����б�Ķ�����ʼ����.
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; ��ǰһ���ҵ���λ�ú��������.
	;msgbox % RowNumber
	if not RowNumber  ; ���淵����, ����ѡ������Ѿ����ҵ���.
		break

	LV_GetText(Tmp_Str, RowNumber, 2)
if (folderobj1[Tmp_Str] = "folder" )
	FileCreateDir, %folder2%\%Tmp_Str%       ; �½��ļ���
else
	{
	FileCopy, %folder1%\%Tmp_Str%, %folder2%\%Tmp_Str%, 1   ; ͬ���ļ�
	}
}

Gui, ListView, filelist2
RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; ��ǰһ���ҵ���λ�ú��������.
	if not RowNumber  ; ���淵����, ����ѡ������Ѿ����ҵ���.
		break
	LV_GetText(Tmp_Str, RowNumber, 2)
	if (folderobj2[Tmp_Str] = "folder" )
		Continue
	else
		FileDelete %folder2%\%Tmp_Str%    ; ɾ���ļ�
}

RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; ��ǰһ���ҵ���λ�ú��������.
	if not RowNumber  ; ���淵����, ����ѡ������Ѿ����ҵ���.
		break
	LV_GetText(Tmp_Str, RowNumber, 2)
	if (folderobj2[Tmp_Str] = "folder" )
		FileRemoveDir, %folder2%\%Tmp_Str%
}
return

rpview:
Gui, 66: Default

Gui, ListView, filelist1
RowNumber := 0  ; ����ʹ���״�ѭ�����б�Ķ�����ʼ����.
Tmp_Str := ""
Loop
{
    RowNumber := LV_GetNext(RowNumber, "C")  ; ��ǰһ���ҵ���λ�ú��������.
		;msgbox % RowNumber
    if not RowNumber  ; ���淵����, ����ѡ������Ѿ����ҵ���.
        break

	LV_GetText(Tmp_Value, RowNumber, 2)
if (folderobj1[Tmp_Value] = "folder" )
	Tmp_Str .= "�½��ļ���: " Tmp_Value "`n"
else
	Tmp_Str .= "ͬ�����ļ�: "  Tmp_Value "`n"
}

Gui, ListView, filelist2
RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; ��ǰһ���ҵ���λ�ú��������.
	if not RowNumber  ; ���淵����, ����ѡ������Ѿ����ҵ���.
		break
	LV_GetText(Tmp_Value, RowNumber, 2)
	if (folderobj2[Tmp_Value] = "folder" )
		Tmp_Str .= "ɾ�����ļ���: " Tmp_Value "`n"
	else
		Tmp_Str .= "ɾ�����ļ�: " Tmp_Value "`n"
}
;msgbox % Tmp_Str
GuiText(Tmp_Str, 500, 20)
return

GuiText(Gtext, w:=300, l:=20)
{
Gui,GuiText: Destroy
Gui,GuiText: Default
Gui, Add, Edit, Multi readonly w%w% r%l%, %Gtext%
gui, Show, AutoSize
return

GuiTextGuiClose:
GuiTextGuiescape:
Gui, GuiText: Destroy
Return
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
