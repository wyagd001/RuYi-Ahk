;|2.8|2024.10.11|1229
CandySel :=  A_Args[1]
;CandySel := "C:\Documents and Settings\Administrator\Desktop\文本碎片小脚本"
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\e773.ico"
Gui +Resize
Gui, Add, Text, x10 y15 h25, 查找文件夹:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vsfolder, % CandySel
Gui, Add, Button, xp+560 yp-2 w60 h30 gstartsearch, 开始查找
Gui, Add, Text, x10 yp+40 h25, 指定扩展名:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vsExt,
Gui, Add, Button, xp+560 yp-2 w60 h30 gstartsearch2, 同名查找
Gui, Add, Text, x10 yp+40 h25, 目标文件夹:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vtfolder,
Gui, Add, Button, xp+560 yp h25 gseltfolder, ...
Gui, Add, ListView, x10 yp+40 w700 h500 vfilelist Checked hwndHLV AltSubmit Grid, 分组|序号|文件名|相对路径|大小|修改日期|完整路径|md5
Gui, Add, Button, xp yp+510 w50 h30 guncheckall vuncheckallB, 全不选
Gui, Add, Button, xp+55 yp w50 h30 gswitchcheck vswitchcheckB, 反选
Gui, Add, Button, xp+55 yp w60 h30 gEditfilefromlist vEditfilefromlistB, 编辑文件
Gui, Add, Button, xp+65 yp w60 h30 gopenfilefromlist vopenfilefromlistB, 打开文件
Gui, Add, Button, xp+65 yp w60 h30 gopenfilepfromlist vopenfilepfromlistB, 打开路径

Gui, Add, Radio, xp+100 yp w70 h30 Checked1 vactionmode, 删除勾选
Gui, Add, Radio, xp+75 yp w160 h30 vactionmode2, 移动勾选到目标文件夹
Gui, Add, Button, xp+170 yp w60 h30 grpview vrpviewB, 预览结果
Gui, Add, Button, xp+65 yp w50 h30 grundel vrundelB, 执行
gui, Show,, 查找文件夹中的重复文件

if FileExist(CandySel)
	gosub startsearch
Return

startsearch2:
mode := "samename"
gosub listfile
return
startsearch:
mode := "Md5"
gosub listfile
return
listfile:
gui, Submit, NoHide
folderobj := {}, fsizeobj := {}, fMD5obj := {}, md5obj := {}, fnameobj := {}, nameobj := {}
ToolTip, % "正在查找重复文件, 请稍候..."
LV_Delete()
; 查找文件夹, 最多支持3个文件夹, 文件夹以 "|" 或 ";" 分隔
Loop, parse, sfolder, |;
{
	My_Index := (A_index = 1) ? "①" : (A_index = 2) ? "②" : "③"
	Loop, Files, %A_LoopField%\*.*, FR
	{
		if A_LoopFileSize = 0   ; 忽略零字节的文件
			continue
		if sExt                 ; 如果指定了扩展名, 忽略其他扩展名文件
		{
			if A_LoopFileExt not in %sExt%
				continue
		}
		if (mode = "Md5") && !fsizeobj[A_LoopFileSize]  ; 文件大小首次遍历
		{
			fsizeobj[A_LoopFileSize] := A_LoopFilePath "|" A_LoopField "|" My_Index    ; 将文件的大小记入大小库中
			continue
		}
		if (mode = "samename") && !fnameobj[A_LoopFileName]   ; 文件名首次遍历
		{
			fnameobj[A_LoopFileName] := A_LoopFilePath "|" A_LoopField "|" My_Index   ; 将文件名记入文件名库中
			continue
		}

		if (mode = "samename") && fnameobj[A_LoopFileName]    ; 存在文件名相同的文件
		{
			currfileMD5 := MD5_File(A_LoopFilePath)   ; 当前文件
			folderobj[A_LoopFilePath] := {}
			folderobj[A_LoopFilePath]["fname"] := A_LoopFileName
			folderobj[A_LoopFilePath]["relPath"] := StrReplace(StrReplace(A_LoopFilePath, A_LoopField, My_Index), A_LoopFileName)
;msgbox % A_LoopFilePath "|" A_LoopField "|" A_LoopFileName
			folderobj[A_LoopFilePath]["fTMod"] := A_LoopFileTimeModified
			folderobj[A_LoopFilePath]["fsize"] := A_LoopFileSize
			folderobj[A_LoopFilePath]["fmd5"] := currfileMD5
      prefilepath := GetStringIndex(fnameobj[A_LoopFileName], 1)  ; 前一个同名文件
			if !folderobj[prefilepath]   ; 首次遍历到的文件
			{
					FileGetTime, fTMod, % prefilepath, M
          FileGetSize, fsize, % prefilepath
					;SplitPath, prefilepath, fname
					prefileMD5 := MD5_File(prefilepath)
					folderobj[prefilepath] := {}
					folderobj[prefilepath]["fname"] := A_LoopFileName
					folderobj[prefilepath]["relPath"] := StrReplace(StrReplace(prefilepath, GetStringIndex(fnameobj[A_LoopFileName], 2), GetStringIndex(fnameobj[A_LoopFileName], 3)), A_LoopFileName)
;msgbox % prefilepath "|" A_LoopField "|" A_LoopFileName
					folderobj[prefilepath]["fTMod"] := fTMod
					folderobj[prefilepath]["fsize"] := fsize
					folderobj[prefilepath]["fmd5"] := prefileMD5
          folderobj[prefilepath]["unchecked"] := "1"
			}
    }
		if (mode = "Md5") && fsizeobj[A_LoopFileSize]    ; 大小有重复的情况
		{
			currfileMD5 := MD5_File(A_LoopFilePath)
			sprefilepath := GetStringIndex(fsizeobj[A_LoopFileSize], 1)
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
				folderobj[A_LoopFilePath]["relPath"] := StrReplace(StrReplace(A_LoopFilePath, A_LoopField, My_Index), A_LoopFileName)
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
					folderobj[mprefilepath]["relPath"] := StrReplace(StrReplace(mprefilepath, GetStringIndex(fsizeobj[A_LoopFileSize], 2), GetStringIndex(fsizeobj[A_LoopFileSize], 3)), fname)
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
	;if (mode = "Md5")
		LV_Add("", "", "", folderobj[nFile].fname, folderobj[nFile].relPath, folderobj[nFile].fsize, folderobj[nFile].fTmod, nFile, folderobj[nFile].fmd5)
	;if (mode = "samename")
		;LV_Add("", "", "", folderobj[nFile].fname, folderobj[nFile].relPath, folderobj[nFile].fsize, folderobj[nFile].fTmod, nFile)	
}
LV_ModifyCol()
LV_ModifyCol(1, 40)
LV_ModifyCol(2, "40 Logical")
LV_ModifyCol(3, 200)
LV_ModifyCol(4, 300)
LV_ModifyCol(5, "Logical")  ; 按大小排序, 如果有大量文件大小一致的文件会显示混乱
LV_ModifyCol(7, 200)
if (mode = "samename")
	LV_ModifyCol(3, "Sort")
if (mode = "Md5")
	LV_ModifyCol(8, "SortDesc")

if (mode = "samename")
{
	colorou := 0
	Loop % LV_GetCount()
	{
		LV_Modify(A_Index, "", "", A_Index)
		LV_GetText(RetrievedName, A_Index, 3)   ; 文件名
    LV_GetText(RetrievedPath, A_Index, 7)   ; 文件路径
		if (A_Index = 1)
			preText := RetrievedName
		if (RetrievedName != preText)
		{
			colorou := !colorou
			preText := RetrievedName
		}
		if colorou
			LV_Modify(A_Index, "", "☆_" A_Index)
    if !folderobj[RetrievedPath].unchecked
    {
			LV_Modify(A_Index, "check")
		}
	}
}

if (mode = "Md5")
{
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
}
GuiControl, +redraw, filelist
;FileAppend, % Array_ToString(folderobj) , %A_desktop%\123.txt
folderobj := {}
mode := ""
return

seltfolder:
SelectedFolder := SelectFolderEx(A_desktop, 请选择一个文件夹)
if !(SelectedFolder = "")
GuiControl,, tfolder, %SelectedFolder%
return

uncheckall:
LV_Modify(0, "-check")
return

switchcheck:
Loop % LV_GetCount()
{
	SendMessage, 0x102C, A_index - 1, 0xF000, SysListView321
	IsChecked := (ErrorLevel >> 12) - 1
	if IsChecked
		LV_Modify(A_index, "-check")
	else
		LV_Modify(A_index, "check")
}
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
folder1 := GetStringIndex(sfolder, 1)
folder2 := GetStringIndex(sfolder, 2)
folder3 := GetStringIndex(sfolder, 3)
;msgbox % actionmode "|" actionmode2
if (actionmode = 1)
	tipStr := " 删除文件: "
if (actionmode2 = 1)
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

	LV_GetText(Tmp_Path, RowNumber, 7)
	LV_GetText(Tmp_Rel, RowNumber, 4)
	LV_GetText(Tmp_Name, RowNumber, 3)
	if instr(sfolder, "|")
	{
		Tmp_Rel := StrReplace(Tmp_Rel, folder1)
		if folder2
			Tmp_Rel := StrReplace(Tmp_Rel, folder2)
		if folder3
			Tmp_Rel := StrReplace(Tmp_Rel, folder3)
	}
	Tmp_index := Format("{:04}", A_Index)
	
	Tmp_Str .= Tmp_index tipStr Tmp_Path (actionmode2 = 1 ? " 到 " Tmp_Rel Tmp_Name : "") "`n"
}
GuiText(Tmp_Str, "文件夹重复文件操作预览", 780, 20)
return

rundel:
gui, Submit, NoHide

RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
if (actionmode = 1)    ; 删除
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
else if (actionmode2 = 1)   ; 移动
{
	if !tfolder
		return
	folder1 := GetStringIndex(sfolder, 1)
	folder2 := GetStringIndex(sfolder, 2)
	folder3 := GetStringIndex(sfolder, 3)
	ErrMoveFileCount := 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(Tmp_Path, RowNumber, 7)
		LV_GetText(Tmp_Rel, RowNumber, 4)
		LV_GetText(Tmp_Name, RowNumber, 3)
		Tmp_Rel := StrReplace(Tmp_Rel, folder1)
		if folder2
			Tmp_Rel := StrReplace(Tmp_Rel, folder2)
		if folder3
			Tmp_Rel := StrReplace(Tmp_Rel, folder3)
		FileCreateDir, % tfolder Tmp_Rel
		FileMove, % Tmp_Path, % tfolder Tmp_Rel Tmp_Name, 1
		if errorlevel
			ErrMoveFileCount++
	}
}
if !ErrMoveFileCount
	CF_ToolTip("文件处理完成.", 3000)
else
	CF_ToolTip("文件处理完成. 但是有 " ErrMoveFileCount " 文件移动失败.", 3000)
Return

GuiClose:
Guiescape:
Gui Destroy
Gui, GuiText: Destroy
exitapp
Return

GuiSize:
If (A_EventInfo = 1) ; The window has been minimized.
	Return
AutoXYWH("wh", "filelist")
AutoXYWH("y", "uncheckallB", "switchcheckB", "EditfilefromlistB", "openfilefromlistB", "openfilepfromlistB", "actionmode", "actionmode2", "rpviewB", "rundelB")
return


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
	Gui, +HwndTextGuiHwnd +Resize
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	Return

	GuiTextGuiSize:
	AutoXYWH("wh", "myedit")
	return
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

; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;             add a 't' to DimSize to tell AutoXYWH that the controls in cList are on/in a tab3 control
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
;   AutoXYWH("t x h0.5", "Btn1")
; ---------------------------------------------------------------------------------
; Version: 2020-5-20 / small code improvements (toralf)
;          2018-1-31 / added a line to prevent warnings (pramach)
;          2018-1-13 / added t option for controls on Tab3 (Alguimist)
;          2015-5-29 / added 'reset' option (tmplinshi)
;          2014-7-03 / mod by toralf
;          2014-1-02 / initial version tmplinshi
; requires AHK version : 1.1.13.01+    due to SprSplit()
; =================================================================================

AutoXYWH(DimSize, cList*){   ;https://www.autohotkey.com/boards/viewtopic.php?t=1079
  Static cInfo := {}

  If (DimSize = "reset")
    Return cInfo := {}

  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If !cInfo.hasKey(ctrlID) {
      ix := iy := iw := ih := 0	
      GuiControlGet i, %A_Gui%: Pos, %ctrl%
      MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
      fx := fy := fw := fh := 0
      For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) 
        If !RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)
          f%dim% := 1

      If (InStr(DimSize, "t")) {
        GuiControlGet hWnd, %A_Gui%: hWnd, %ctrl%
        hParentWnd := DllCall("GetParent", "Ptr", hWnd, "Ptr")
        VarSetCapacity(RECT, 16, 0)
        DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", &RECT)
        DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", &RECT, "UInt", 1)
        ix := ix - NumGet(RECT, 0, "Int")
        iy := iy - NumGet(RECT, 4, "Int")
      }

      cInfo[ctrlID] := {x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a, m:MMD}
    } Else {
      dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw, dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
      Options := ""
      For i, dim in cInfo[ctrlID]["a"]
        Options .= dim (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) A_Space
      GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
} } }

GetStringIndex(String, Index := "", MaxParts := -1, SplitStr := "|")
{
	arrCandy_Cmd_Str := StrSplit(String, SplitStr, " `t", MaxParts)
	if Index
	{
		NewStr := arrCandy_Cmd_Str[Index]
		return NewStr
	}
	else
		return arrCandy_Cmd_Str
}