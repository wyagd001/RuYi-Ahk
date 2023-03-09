folder1 :=  A_Args[1], folder2 :=  A_Args[2]
B_Autohotkey := A_ScriptDir "\..\..\引用程序\" (A_PtrSize = 8 ? "AutoHotkeyU64.exe" : "AutoHotkeyU32.exe")
; 1088
OnMessage(0x4a, "Receive_WM_COPYDATA")

SyncFolder:
IfWinExist, 文件夹同步 ahk_class AutoHotkeyGUI
{
	folder2 := CandySel2
	GuiControl,, folder2, %folder2%
	if (folder2 != folder1)
		gosub loderfolder
}
Else
{
	Gui,66: Destroy
	Gui,66: Default
	SplitPath, folder1, OutFileName
	if !Fileexist(folder2)
	{
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
	}
	Gui, Add, text, x10 y10, 源文件夹:
	Gui, Add, edit, xp+70 w480 h40 r2 vfolder1, % folder1
	Gui, Add, text, xp+490, 目标文件夹:
	Gui, Add, edit, xp+80 y10 w470 h40 r2 vfolder2, % folder2
	Gui, Add, ListView, x10 y55 w550 h500 vfilelist1 hwndHLV1 Checked AltSubmit gsync, 序号|文件名|修改日期|大小|md5
	Gui, Add, ListView, x570 y55 w550 h500 vfilelist2 hwndHLV2 Checked AltSubmit gsync, 序号|文件名|修改日期|大小|相等|md5
	Gui, Add, Button, x10 yp+510 h30 gloderfolder, 加载列表
	Gui, Add, Button, xp+70 h30 grpview, 预览结果
	Gui, Add, Button, xp+70 h30 gsave, 执行同步
	gui, show,, 文件夹同步
	Menu, Tray, UseErrorLevel
	Menu, filelistMenu, deleteall
	Menu, filelistMenu, Add, 全不选, uncheckallfile
	Menu, filelistMenu, Add, 下一个选中, jumpcheckedfile
	Menu, filelistMenu, Add, 打开, openfilefromlist
	Menu, filelistMenu, Add, 打开路径, openfilepfromlist
	Menu, filelistMenu, Add, 编辑选中文件, editfilefromlist
	Menu, filelistMenu, Add, 文本文件对比, compfilefromlist
	Menu, filelistMenu, Add, 删除选中文件, delfillefromlist
	if folder2 && (folder2 != folder1)
		gosub loderfolder
}
return

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
tooltip % "正在对比文件夹, 请稍候..."
;folder1:="D:\资料\autohotkey 帮助\v2\docs"
;folder2:="F:\Program Files\运行\git\wyagd001.github.io\v2\docs"
IniRead, 忽略路径, %folder1%\.忽略列表.ini, 路径, 忽略路径
IniRead, 忽略目录, %folder1%\.忽略列表.ini, 目录, 忽略目录
IniRead, 忽略文件, %folder1%\.忽略列表.ini, 文件
IniRead, 判断类型, %folder1%\.忽略列表.ini, 判断依据, 判断类型, 文件md5
Gui, ListView, filelist1
LV_Delete()
Gui, ListView, filelist2
LV_Delete()
folderobj1:={}
folderobj2:={}
flastwriteobj1:={}
flastwriteobj2:={}
fsizeobj1:={}
fsizekbobj1:={}
fsizeobj2:={}
fsizekbobj2:={}
fMD5obj1:={}
fMD5obj2:={}
Tmp_Str:=""

if folder1
Loop, Files, %folder1%\*.*, DFR
{
	if A_LoopFileAttrib contains H,R,S
		continue
	relativePS := StrReplace(A_LoopFilePath, folder1 "\")
	if relativePS contains %忽略路径%
		Continue
	if instr(忽略目录, relativePS) && InStr(A_LoopFileAttrib, "D")
		Continue
	if instr(忽略文件, relativePS) && !InStr(A_LoopFileAttrib, "D")
		Continue

	if InStr(A_LoopFileAttrib, "D")
		folderobj1[relativePS] := "folder"
	else
		folderobj1[relativePS] := 1
	FormatTime, Out_time, % A_LoopFileTimeModified, yyyy-MM-dd HH:mm:ss
	flastwriteobj1[relativePS] := Out_time
	fsizeobj1[relativePS] := A_LoopFileSize
	fsizekbobj1[relativePS] := A_LoopFileSizeKB
	;fMD5obj1[relativePS] := MD5_File(A_LoopFilePath)
	Tmp_Str .= relativePS "`n"
}

if folder2
Loop, Files, %folder2%\*.*, DFR
{
	if A_LoopFileAttrib contains H,R,S
		continue
	relativePS := StrReplace(A_LoopFilePath, folder2 "\")
	if relativePS contains %忽略路径%
		Continue
	if instr(忽略目录, relativePS) && InStr(A_LoopFileAttrib, "D")
		Continue
	if instr(忽略文件, relativePS)
		Continue

	if InStr(A_LoopFileAttrib, "D")
		folderobj2[relativePS] := "folder"
	else
		folderobj2[relativePS] := 1
	FormatTime, Out_time, % A_LoopFileTimeModified, yyyy-MM-dd HH:mm:ss
	flastwriteobj2[relativePS] := Out_time
	fsizeobj2[relativePS] := A_LoopFileSize
	fsizekbobj2[relativePS] := A_LoopFileSizeKB
	;fMD5obj2[relativePS] := MD5_File(A_LoopFilePath)
	Tmp_Str .= relativePS "`n"
}

Tmp_Str := Trim(Tmp_Str, "`n")
Sort, Tmp_Str, U

GuiControl, -redraw, filelist1
GuiControl, -redraw, filelist2
Loop, parse, Tmp_Str, `n, `r
{
	Gui, ListView, filelist1
	if folderobj1.HasKey(A_LoopField)
	{
		LV_Add("", A_Index, A_LoopField, flastwriteobj1[A_LoopField], fsizekbobj1[A_LoopField])
	}
	else
	{
		LV_Add("", A_Index, "空")
	}

	Gui, ListView, filelist2
	if folderobj2.HasKey(A_LoopField)
	{
		if (fsizeobj1[A_LoopField] = fsizeobj2[A_LoopField])   ; 文件大小相等
		{
			if (判断类型 = "最近修改时间") ; 文件大小相同通过最近修改时间来判断为文件是否相同而不计算MD5
			{
				if (flastwriteobj1[A_LoopField] = flastwriteobj2[A_LoopField]) or (folderobj2[A_LoopField] = "folder")
				{
					LV_Add("", A_Index, A_LoopField, flastwriteobj2[A_LoopField], fsizeKBobj2[A_LoopField], "是")
				}
				else
				{
					LV_Add("", A_Index, A_LoopField, flastwriteobj2[A_LoopField], fsizeKBobj2[A_LoopField], "否")
					Gui, ListView, filelist1
					LV_Modify(A_Index, "check")    ; 文件大小相同但是最近修改时间不同则勾选左侧(不管右侧是否更新, 左侧为准)
				}
			}
			else if (判断类型 = "文件md5")  ; 通过md5来判断文件是否相同
			{
				fMD5obj2[A_LoopField] := MD5_File(folder2 "\" A_LoopField)
				fMD5obj1[A_LoopField] := MD5_File(folder1 "\" A_LoopField)
				if (fMD5obj1[A_LoopField] = fMD5obj2[A_LoopField])
				{
					LV_Add("", A_Index, A_LoopField, flastwriteobj2[A_LoopField], fsizeKBobj2[A_LoopField], "是", fMD5obj2[A_LoopField])
				}
				else
				{
					LV_Add("", A_Index, A_LoopField, flastwriteobj2[A_LoopField], fsizeKBobj2[A_LoopField], "否", fMD5obj2[A_LoopField])
					Gui, ListView, filelist1
					LV_Modify(A_Index, "check",,,,, fMD5obj1[A_LoopField])   ; md5 不同时, 写左侧文件的md5到列表
				}
			}
		}
		else   ; 文件大小不相等时不计算比较MD5
		{
			LV_Add("", A_Index, A_LoopField, flastwriteobj2[A_LoopField], fsizeKBobj2[A_LoopField], "否")
			if folderobj1.HasKey(A_LoopField)   ; 左侧也存在该文件, 勾选左侧
			{
				Gui, ListView, filelist1
				LV_Modify(A_Index, "check")
			}
			else                                ; 左侧不存在该文件, 勾选右侧  
				LV_Modify(A_Index, "check")
		}
	}
	else
	{
		LV_Add("", A_Index, "空")
		Gui, ListView, filelist1
		LV_Modify(A_Index, "check")
	}
}

Gui, ListView, filelist1
{
	LV_ModifyCol()
	LV_ModifyCol(1, "Logical")
	LV_ModifyCol(2, 300)
	LV_ModifyCol(5, 220)
}
Gui, ListView, filelist2
{
	LV_ModifyCol()
	LV_ModifyCol(1, "Logical")
	LV_ModifyCol(2, 300)
}

GuiControl, +redraw, filelist1
GuiControl, +redraw, filelist2

CF_ToolTip("对比完成", 3000)
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
	if RF
		LV_Modify(RF, "Select Focus Vis")
}
if (A_GuiControl = "filelist2") && (A_GuiEvent = "Normal")
{
	Gui, ListView, filelist2
	RF := LV_GetNext("F")
	Gui, ListView, filelist1
	LV_Modify(0, "-Select")
	if RF
		LV_Modify(RF, "Select Focus Vis")
}
return

save:
Gui, 66: Default
Gui, ListView, filelist1
RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	;msgbox % RowNumber
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break

	LV_GetText(Tmp_Str, RowNumber, 2)
	if (folderobj1[Tmp_Str] = "folder" )
		FileCreateDir, %folder2%\%Tmp_Str%       ; 新建文件夹
	else
	{
		FileCopy, %folder1%\%Tmp_Str%, %folder2%\%Tmp_Str%, 1   ; 同步文件
	}
}

Gui, ListView, filelist2
RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break
	LV_GetText(Tmp_Str, RowNumber, 2)
	if (folderobj2[Tmp_Str] = "folder" )
		Continue
	else
		FileDelete %folder2%\%Tmp_Str%    ; 删除右侧有而左侧没有的文件
}

RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break
	LV_GetText(Tmp_Str, RowNumber, 2)
	if (folderobj2[Tmp_Str] = "folder" )
		FileRemoveDir, %folder2%\%Tmp_Str%   ; 删除右侧有而左侧没有的文件夹
}
CF_ToolTip("同步完成", 3000)
return

rpview:
Gui, 66: Default

Gui, ListView, filelist1
RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Tmp_Str := ""
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	;msgbox % RowNumber
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break

	LV_GetText(Tmp_Value, RowNumber, 2)
	Tmp_index := Format("{:04}", A_Index)
	if (folderobj1[Tmp_Value] = "folder" )
		Tmp_Str .= Tmp_index ". 新建文件夹: " Tmp_Value "`n"
	else
	{
		if folderobj2[Tmp_Value]
			Tmp_Str .= Tmp_index ". 同步的文件: "  Tmp_Value "`n"
		else
			Tmp_Str .= Tmp_index ". 新建的文件: "  Tmp_Value "`n"
	}
}

Gui, ListView, filelist2
RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break
	LV_GetText(Tmp_Value, RowNumber, 2)
	Tmp_index := Format("{:04}", A_Index)
	if (folderobj2[Tmp_Value] = "folder" )
		Tmp_Str .= Tmp_index ". 删除的文件夹: " Tmp_Value "`n"
	else
		Tmp_Str .= Tmp_index ". 删除的文件: " Tmp_Value "`n"
}
;msgbox % Tmp_Str
GuiText(Tmp_Str, "文件夹同步操作预览", 500, 20)
return

delfillefromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
	if (lvfolder=1)
	{
		FileDelete %folder1%\%Tmp_Str%
		LV_Modify(RF, "-check",, "空", "", "", "")
	}
	if (lvfolder=2)
	{
		FileDelete %folder2%\%Tmp_Str%
		LV_Modify(RF, "-check",, "空", "", "", "", "")
	}
}
return

editfilefromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
	IniRead, notepad2, %A_ScriptDir%\..\..\配置文件\如一.ini, 其他程序, notepad2
	notepad2 := notepad2 ? notepad2 : "notepad.exe"
	if (lvfolder=1)
	{
		if (folderobj1[Tmp_Str] != "folder")
			run %notepad2% "%folder1%\%Tmp_Str%"
	}
	if (lvfolder=2)
	{
		if (folderobj2[Tmp_Str] != "folder")
			run %notepad2% "%folder2%\%Tmp_Str%"
	}
}
return

compfilefromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
	if (folderobj1[Tmp_Str] != "folder") && folderobj2[Tmp_Str]
	{
		run %B_Autohotkey% "%A_ScriptDir%\..\文件处理\文本比较.ahk" "%folder1%\%Tmp_Str%" "%folder2%\%Tmp_Str%"
	}
}
return

openfilefromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
	if (lvfolder=1)
	{
		run %folder1%\%Tmp_Str%
	}
	if (lvfolder=2)
	{
		run %folder2%\%Tmp_Str%
	}
}
return

openfilepfromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
	if (lvfolder=1)
	{
		Run, explorer.exe /select`, %folder1%\%Tmp_Str%
	}
	if (lvfolder=2)
	{
		Run, explorer.exe /select`, %folder2%\%Tmp_Str%
	}
}
return

uncheckallfile:
Gui,66: Default
LV_Modify(0, "-check")
return

jumpcheckedfile:
Gui,66: Default
RF := LV_GetNext("F")
if RF
{
	RFF := LV_GetNext(RF, "C")
	if !RFF
		RFF := LV_GetNext(RF+1, "C")
	LV_Modify(RFF, "Focus Vis")
}
return

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	Return
}

66GuiClose:
66Guiescape:
Gui,66: Destroy
Gui,GuiText: Destroy
exitapp
Return

66GuiContextMenu:
if (A_GuiControl = "filelist1")
{
	Gui, ListView, filelist1
	lvfolder := 1
	Menu, filelistMenu, Show
}
if (A_GuiControl = "filelist2")
{
	Gui, ListView, filelist2
	lvfolder := 2
	Menu, filelistMenu, Show
}
return

nul:
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
	StringAddress := NumGet(lParam + 2*A_PtrSize)  ; 获取 CopyDataStruct 的 lpData 成员.
	CandySel2 := StrGet(StringAddress)  ; 从结构中复制字符串.
	gosub SyncFolder
return true
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

CF_ToolTip(tipText, delay := 1000)
{
	ToolTip
	ToolTip, % tipText
	SetTimer, RemoveToolTip, % "-" delay
return

RemoveToolTip:
	ToolTip
return
}