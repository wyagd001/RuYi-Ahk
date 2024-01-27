;|2.5|2023.11.18|1229
CandySel :=  A_Args[1]
;CandySel := "C:\Documents and Settings\Administrator\Desktop\文本碎片小脚本"
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\e773.ico"
Gui, Add, Text, x10 y15 h25, 查找文件夹:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vsfolder, % CandySel
Gui, Add, Button, xp+560 yp-2 w60 h30 gstartsearch, 开始查找
Gui, Add, Text, x10 yp+40 h25, 指定扩展名:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vsExt,
Gui, Add, Text, x10 yp+40 h25, 目标文件夹:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vtfolder,
Gui, Add, Button, xp+560 yp h25 gseltfolder, ...
Gui, Add, ListView, x10 yp+40 w700 h500 vfilelist Checked hwndHLV AltSubmit, 分组|序号|文件名|相对路径|大小|修改日期|完整路径|md5
Gui, Add, Button, xp yp+510 w60 h30 guncheckall, 全不选
Gui, Add, Button, xp+70 yp w60 h30 gEditfilefromlist, 编辑文件
Gui, Add, Button, xp+70 yp w60 h30 gopenfilefromlist, 打开文件
Gui, Add, Button, xp+70 yp w60 h30 gopenfilepfromlist, 打开路径

Gui, Add, Radio, xp+120 yp w70 h30 Checked1 vactionmode, 删除勾选
Gui, Add, Radio, xp+70 yp w160 h30 , 移动勾选到目标文件夹
Gui, Add, Button, xp+170 yp w60 h30 grpview, 预览结果
Gui, Add, Button, xp+70 yp w60 h30 grundel, 执行
gui, Show,, 查找文件夹中的重复文件

if FileExist(CandySel)
	gosub startsearch
Return

startsearch:
gui, Submit, NoHide
folderobj := {}, fsizeobj := {}, fMD5obj := {}, md5obj := {}
ToolTip, % "正在查找重复文件, 请稍候..."
LV_Delete()
Loop, parse, sfolder, |;
{
	;msgbox % A_LoopField
	Loop, Files, %A_LoopField%\*.*, FR
	{
		if A_LoopFileSize = 0
			continue
		if sExt
		{
			if A_LoopFileExt not in %sExt%
				continue
		}
		if !fsizeobj[A_LoopFileSize]
		{
			fsizeobj[A_LoopFileSize] := A_LoopFilePath  ; 将文件的大小记入大小库中
			continue
		}

		if fsizeobj[A_LoopFileSize]    ; 大小有重复的情况
		{
			currfileMD5 := MD5_File(A_LoopFilePath)
			sprefilepath := fsizeobj[A_LoopFileSize]
			;FileAppend, % A_LoopFilePath " - " prefilepath "`n", %A_desktop%\123.txt
			if !fMD5obj[sprefilepath]               ; 前一个文件还没有计算过 Md5
			{
				prefileMD5 := MD5_File(sprefilepath)
				fMD5obj[sprefilepath] := prefileMD5
				md5obj[prefileMD5] := sprefilepath
			}
			if md5obj[currfileMD5]                ; 已经存在相同的 md5
			{
				folderobj[A_LoopFilePath] := {}
				folderobj[A_LoopFilePath]["fname"] := A_LoopFileName
				folderobj[A_LoopFilePath]["relPath"] := StrReplace(StrReplace(A_LoopFilePath, sfolder), A_LoopFileName)
				folderobj[A_LoopFilePath]["fTMod"] := A_LoopFileTimeModified
				folderobj[A_LoopFilePath]["fsize"] := A_LoopFileSize
				folderobj[A_LoopFilePath]["fmd5"] := currfileMD5

				mprefilepath := md5obj[currfileMD5]
				;FileAppend, % A_LoopFilePath " - " prefilepath "`n", %A_desktop%\123.txt
				if !folderobj[mprefilepath]          ; 前一个文件还没有入过重复库
				{
					FileGetTime, fTMod, % mprefilepath, M
					SplitPath, mprefilepath, fname
					folderobj[mprefilepath] := {}
					folderobj[mprefilepath]["fname"] := fname
					folderobj[mprefilepath]["relPath"] := StrReplace(StrReplace(mprefilepath, sfolder), fname)
					folderobj[mprefilepath]["fTMod"] := fTMod
					folderobj[mprefilepath]["fsize"] := A_LoopFileSize
					folderobj[mprefilepath]["fmd5"] := currfileMD5
					folderobj[mprefilepath]["unchecked"] := "1"
				}
			}
			else                                  ; 不存在相同的 md5
			{
				MD5obj[currfileMD5] := A_LoopFilePath
				fMD5obj[A_LoopFilePath] := currfileMD5
			}
		}
	}
}
fsizeobj := {}, fMD5obj := {}, md5obj := {}
;msgbox % "文件遍历完成. 用时: " A_TickCount - st
CF_ToolTip("文件遍历完成.", 2500)
GuiControl, -redraw, filelist
for nFile in folderobj
{
	LV_Add("", "", "", folderobj[nFile].fname, folderobj[nFile].relPath, folderobj[nFile].fsize, folderobj[nFile].fTmod, nFile, folderobj[nFile].fmd5)
}
LV_ModifyCol()
LV_ModifyCol(1, 40)
LV_ModifyCol(2, "40 Logical")
LV_ModifyCol(3, 200)
LV_ModifyCol(4, 300)
LV_ModifyCol(5, "Logical")  ; 按大小排序, 如果有大量文件大小一致的文件会显示混乱
LV_ModifyCol(7, 200)
LV_ModifyCol(8, "SortDesc")
colorou := 0
Loop % LV_GetCount()
{
	LV_Modify(A_Index, "", "", A_Index)
	LV_GetText(RetrievedText, A_Index, 7)
	LV_GetText(md5value, A_Index, 8)
	if (A_Index = 1)
		premd5value := md5value
	if (md5value != premd5value)
	{
		colorou := !colorou
	}
	if colorou
		LV_Modify(A_Index, "", "☆_" A_Index)
	if folderobj[RetrievedText].unchecked
	{
		premd5value := md5value
	}
	Else
	{
		LV_Modify(A_Index, "check")
		premd5value := md5value
	}
}
GuiControl, +redraw, filelist
;FileAppend, % Array_ToString(folderobj) , %A_desktop%\123.txt
folderobj := {}
return

seltfolder:
SelectedFolder := SelectFolderEx(A_desktop, 请选择一个文件夹)
if !(SelectedFolder = "")
GuiControl,, tfolder, %SelectedFolder%
return

uncheckall:
LV_Modify(0, "-check")
return

Editfilefromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 7)
}
run notepad %Tmp_file%
return

openfilefromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 7)
}
run %Tmp_file%
return

openfilepfromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 7)
}
SplitPath, Tmp_file,, OutDir
Run, %OutDir%
;Run, explorer.exe /select`, %Tmp_file%
return

rpview:
gui, Submit, NoHide
if (actionmode = 1)
	tipStr := " 删除文件: "
if (actionmode = 2)
{
	if !tfolder
	{
		msgbox 目标文件夹为空, 请设置目标文件夹或选择删除勾选.
		return
	}
	tipStr := " 移动文件: "
}
RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Tmp_Str := ""
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	;msgbox % RowNumber
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break

	LV_GetText(Tmp_Rel, RowNumber, 4)
	LV_GetText(Tmp_Name, RowNumber, 3)
	Tmp_index := Format("{:04}", A_Index)
	
	Tmp_Str .= Tmp_index tipStr Tmp_Rel Tmp_Name "`n"
}
GuiText(Tmp_Str, "文件夹重复文件操作预览", 500, 20)
return

rundel:
gui, Submit, NoHide

RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
if (actionmode = 1)
{
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(Tmp_Path, RowNumber, 7)
		FileRecycle, % Tmp_Path
	}
}
if (actionmode = 2)
{
	if !tfolder
		return
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(Tmp_Path, RowNumber, 7)
		LV_GetText(Tmp_Rel, RowNumber, 4)
		LV_GetText(Tmp_Name, RowNumber, 3)
		FileCreateDir, % tfolder Tmp_Rel
		FileMove, % Tmp_Path, % tfolder  Tmp_Rel Tmp_Name
	}
}
CF_ToolTip("文件处理完成.", 3000)
Return

GuiClose:
Guiescape:
Gui Destroy
Gui, GuiText: Destroy
exitapp
Return

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

; ==================================================================================================================================
; Shows a dialog to select a folder.
; Depending on the OS version the function will use either the built-in FileSelectFolder command (XP and previous)
; or the Common Item Dialog (Vista and later).
; Parameter:
;     StartingFolder -  the full path of a folder which will be preselected.
;     Prompt         -  a text used as window title (Common Item Dialog) or as text displayed withing the dialog.
;     ----------------  Common Item Dialog only:
;     OwnerHwnd      -  HWND of the Gui which owns the dialog. If you pass a valid HWND the dialog will become modal.
;     BtnLabel       -  a text to be used as caption for the apply button.
;  Return values:
;     On success the function returns the full path of selected folder; otherwise it returns an empty string.
; MSDN:
;     Common Item Dialog -> msdn.microsoft.com/en-us/library/bb776913%28v=vs.85%29.aspx
;     IFileDialog        -> msdn.microsoft.com/en-us/library/bb775966%28v=vs.85%29.aspx
;     IShellItem         -> msdn.microsoft.com/en-us/library/bb761140%28v=vs.85%29.aspx
; ==================================================================================================================================
SelectFolderEx(StartingFolder := "", Prompt := "", OwnerHwnd := 0, OkBtnLabel := "") {
   Static OsVersion := DllCall("GetVersion", "UChar")
        , IID_IShellItem := 0
        , InitIID := VarSetCapacity(IID_IShellItem, 16, 0)
                  & DllCall("Ole32.dll\IIDFromString", "WStr", "{43826d1e-e718-42ee-bc55-a1e261c37bfe}", "Ptr", &IID_IShellItem)
        , Show := A_PtrSize * 3
        , SetOptions := A_PtrSize * 9
        , SetFolder := A_PtrSize * 12
        , SetTitle := A_PtrSize * 17
        , SetOkButtonLabel := A_PtrSize * 18
        , GetResult := A_PtrSize * 20
   SelectedFolder := ""
   If (OsVersion < 6) { ; IFileDialog requires Win Vista+, so revert to FileSelectFolder
      FileSelectFolder, SelectedFolder, *%StartingFolder%, 3, %Prompt%
      Return SelectedFolder
   }
   OwnerHwnd := DllCall("IsWindow", "Ptr", OwnerHwnd, "UInt") ? OwnerHwnd : 0
   If !(FileDialog := ComObjCreate("{DC1C5A9C-E88A-4dde-A5A1-60F82A20AEF7}", "{42f85136-db7e-439c-85f1-e4075d135fc8}"))
      Return ""
   VTBL := NumGet(FileDialog + 0, "UPtr")
   ; FOS_CREATEPROMPT | FOS_NOCHANGEDIR | FOS_PICKFOLDERS
   DllCall(NumGet(VTBL + SetOptions, "UPtr"), "Ptr", FileDialog, "UInt", 0x00002028, "UInt")
   If (StartingFolder <> "")
      If !DllCall("Shell32.dll\SHCreateItemFromParsingName", "WStr", StartingFolder, "Ptr", 0, "Ptr", &IID_IShellItem, "PtrP", FolderItem)
         DllCall(NumGet(VTBL + SetFolder, "UPtr"), "Ptr", FileDialog, "Ptr", FolderItem, "UInt")
   If (Prompt <> "")
      DllCall(NumGet(VTBL + SetTitle, "UPtr"), "Ptr", FileDialog, "WStr", Prompt, "UInt")
   If (OkBtnLabel <> "")
      DllCall(NumGet(VTBL + SetOkButtonLabel, "UPtr"), "Ptr", FileDialog, "WStr", OkBtnLabel, "UInt")
   If !DllCall(NumGet(VTBL + Show, "UPtr"), "Ptr", FileDialog, "Ptr", OwnerHwnd, "UInt") {
      If !DllCall(NumGet(VTBL + GetResult, "UPtr"), "Ptr", FileDialog, "PtrP", ShellItem, "UInt") {
         GetDisplayName := NumGet(NumGet(ShellItem + 0, "UPtr"), A_PtrSize * 5, "UPtr")
         If !DllCall(GetDisplayName, "Ptr", ShellItem, "UInt", 0x80028000, "PtrP", StrPtr) ; SIGDN_DESKTOPABSOLUTEPARSING
            SelectedFolder := StrGet(StrPtr, "UTF-16"), DllCall("Ole32.dll\CoTaskMemFree", "Ptr", StrPtr)
         ObjRelease(ShellItem)
   }  }
   If (FolderItem)
      ObjRelease(FolderItem)
   ObjRelease(FileDialog)
   Return SelectedFolder
}