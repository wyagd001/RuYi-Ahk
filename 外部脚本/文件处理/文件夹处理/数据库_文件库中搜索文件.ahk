;|2.6|2024.05.03|1225
#SingleInstance force
#InputLevel 10   ; 优先级设置比如意中的高, 按下相同热键后先触发脚本自身的
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\e8a3.ico"

dbpath := A_ScriptDir "\..\..\..\配置文件\folder.db"
IniRead, notepad2, %A_ScriptDir%\..\..\..\配置文件\如一.ini, 其他程序, notepad2, Notepad.exe
if InStr(notepad2, "%A_ScriptDir%")
{
	RY_Dir := Deref("%A_ScriptDir%")
	RY_Dir := SubStr(RY_Dir, 1, InStr(RY_Dir, "\", 0, 0, 3) - 1)
	notepad2 := StrReplace(notepad2, "%A_ScriptDir%", RY_Dir)
}
IniRead, flibfolder1, %A_ScriptDir%\..\..\..\配置文件\如一.ini, 外部脚本, 文件库文件夹一, G:\Music
IniRead, flibfolder2, %A_ScriptDir%\..\..\..\配置文件\如一.ini, 外部脚本, 文件库文件夹二, G:\资料\脚本收集
if fileexist(A_Args[1])  ; 参数为文件时设置 CandySel
{
	CandySel :=  A_Args[1]   
	SplitPath, CandySel,,,, CandySel_FileNameNoExt
	flib_SearchText := CandySel_FileNameNoExt
}
else
	flib_SearchText := A_Args[1]

flib_partial := 0
if (!FileExist(DBPATH))
	isnewdb := 1
else
	isnewdb := 0
global DB := new SQLiteDB
if (!DB.OpenDB(dbpath))
{
	MsgBox, 16, SQLite错误, % "消息:`t" . DB.ErrorMsg . "`n代码:`t" . DB.ErrorCode
}
if (isnewdb = 1)
	createfliedb()
Gui, Add, Text, x10 y12, 搜索过滤
Gui, Add, Checkbox, xp+60 y6 h25 Checked%flib_partial% vflib_partial gswitchSL, 仅在文件名中搜索
Gui, Add, Edit, xp+130 y10 w390 vflib_SearchText, % flib_SearchText
Gui, Add, Button, xp+400 y9 h25 gflib_Search Default, 搜索文件
Gui, Add, ListView, xs+1 HWNDhistoryLV vhistoryLV  LV0x4000 h400 w650 AltSubmit gupdatesb, 名称|路径|大小(KB)|修改时间|MD5|大小|  ;ghistoryLV
Gui, Add, Button, xs+1 h30 gOpenFile, 打开文件
Gui, Add, Button, xp+70 yp h30 gEditFile, 编辑文件
Gui, Add, Button, xp+70 yp h30 gOpenFolder, 打开路径
Gui, Add, Button, xp+70 yp h30 gcheckmd5, 计算Md5
Gui, Add, Button, xp+70 yp h30 gfiletoclip, 复制文件
Gui, Add, Button, xp+300 yp h30 gupdateMlib, 更新文件库
Gui, Add, StatusBar,, 
Gui, Show, w670 h500, 文件库中搜索文件
if flib_SearchText
	gosub flib_Search
OnMessage(0x4a, "Receive_WM_COPYDATA")
return

!l::
CandySel := flib_SearchText := ""
GText := GetSelText()
if fileexist(GText)
{
	CandySel := GText
	SplitPath, CandySel,,,, CandySel_FileNameNoExt
	flib_SearchText := CandySel_FileNameNoExt
}
else
{
	if GText
		flib_SearchText := GText
	else
		return
}
GuiControl,, flib_SearchText, %flib_SearchText%
WinActivate, 文件库中搜索文件 ahk_class AutoHotkeyGUI
sleep 500
Gui, Submit, NoHide
gosub flib_Search
return

setflib_SearchText:
if fileexist(CandySel)
{
	SplitPath, CandySel,,,, CandySel_FileNameNoExt
	flib_SearchText := CandySel_FileNameNoExt
}
else
{
	flib_SearchText := CandySel
	CandySel := ""
}
GuiControl,, flib_SearchText, %flib_SearchText%
WinActivate, 文件库中搜索文件 ahk_class AutoHotkeyGUI
sleep 500
Gui, Submit, NoHide
gosub flib_Search
return

Receive_WM_COPYDATA(wParam, lParam)
{
	Global CandySel
	ID := NumGet(lParam + 0)
	StringAddress := NumGet(lParam + 2*A_PtrSize)  ; 获取 CopyDataStruct 的 lpData 成员.
	CandySel := StrGet(StringAddress)  ; 从结构中复制字符串.
	;ToolTip % CandySel " - " Id
	if (CandySel = "WhoAreYou")
		Return 2
	if CandySel
	{
		SetTimer, setflib_SearchText, -200
		return true
	}
	return False
}

GuiEscape:
GuiClose:
ExitSub:
	ExitApp ; Terminate the script unconditionally
return

GetSelText(returntype := 1, ByRef _isFile := "", ByRef _ClipAll := "", waittime := 0.5)
{
	global clipmonitor
	clipmonitor := (returntype = 0) ? 1 : 0
	BackUp_ClipBoard := ClipboardAll    ; 备份剪贴板
	Clipboard =    ; 清空剪贴板
	Send, ^c
	sleep 100
	ClipWait, % waittime
	If(ErrorLevel) ; 如果粘贴板里面没有内容，则还原剪贴板
	{
		Clipboard := BackUp_ClipBoard
		sleep 100
		clipmonitor := 1
	Return
	}
	If(returntype = 0)
	Return Clipboard
	else If(returntype=1)
		_isFile := _ClipAll := ""
	else
	{
		_isFile := DllCall("IsClipboardFormatAvailable", "UInt", 15) ; 是否是文件类型
		_ClipAll := ClipboardAll
	}
	ClipSel := Clipboard

	Clipboard := BackUp_ClipBoard  ; 还原粘贴板
	sleep 100
	clipmonitor := 1
	return ClipSel
}

updateMlib:
tooltip 开始更新文件库...
StartTime := A_TickCount
filelistarray := {}
if fileexist(flibfolder1)
{
	Loop, Files, %flibfolder1%\*.*, FR
	{
		if A_LoopFileAttrib contains H,R,S
			continue
		filelistarray[a_loopfilefullpath] := 1
	}
}
if fileexist(flibfolder2)
{
	Loop, Files, %flibfolder2%\*.*, FR
	{
		if A_LoopFileAttrib contains H,R,S
			continue
		filelistarray[a_loopfilefullpath] := 1
	}
}
if fileexist("H:\备份\资料备份\脚本收集\AutoHotkey\Ahk_L")
{
	Loop, Files, H:\备份\资料备份\脚本收集\AutoHotkey\Ahk_L\*.*, FR
	{
		if A_LoopFileAttrib contains H,R,S
			continue
		filelistarray[a_loopfilefullpath] := 1
	}
}
if fileexist("G:\Github")
	StackLoop("G:\Github")
tooltip 遍历文件完成.
if !fileexist(flibfolder1) && !fileexist(flibfolder2) && !fileexist("G:\Github")
	msgbox % "配置文件中 [外部脚本] 下的 ""文件库文件夹一"" 和 ""文件库文件夹二"" 项目设置的文件夹都不存在, 请检查 如一.ini 文件."
Else
	updateFlib()
;MsgBox, % ElapsedTime / 1000
return

switchSL:
Gui, Submit, NoHide
if (flib_partial = 0)
	GuiControl,, flib_partial, 仅在文件名中搜索
if (flib_partial = 1)
	GuiControl,, flib_partial, 在完整路径中搜索
return

StackLoop(path) {
global filelistarray
    SetBatchLines -1
    ; Create a "stack" to hold the folders yet to be indexed, initially
    ; containing the path specified by the caller.
    st := Object(1, path)
    Loop
    {
        ; Pop a folder from the top of the stack.
        path := st.Remove()
        ; For each file or folder in this folder,
        Loop, Files, %path%\*.*, DF
        {
            ; Skip any with these attributes.
            if A_LoopFileAttrib contains H,S
                continue
            ; If it's a folder (D for directory),
            if A_LoopFileAttrib contains D
            {
                ; and is one we want to exclude, skip it.
                if A_LoopFileName in .git
                    continue
                ; Push this folder onto the stack. 
                st.Insert(A_LoopFileFullPath)
            }
            ; Append this file or folder to the list.  Unconditionally
            ; inserting `n avoids a small amount of computation per
            ; file and folder, though it mightn't be significant.
            if A_LoopFileAttrib not contains D
                filelistarray[a_loopfilefullpath]:=1
        }
    }
    ; Continue looping until the stack is empty.
    until st.MaxIndex() = ""
    return
}

flib_Search:
Gui, Submit, NoHide
searchdb(flib_SearchText, flib_partial)
return

OpenFile:
LV_GetText(FileFullPath, LV_GetNext("F"), 2)
If Fileexist(FileFullPath)
Run, "%FileFullPath%"
return

OpenFolder:
LV_GetText(FileFullPath, LV_GetNext("F"), 2)
SplitPath, FileFullPath,, oPath
;msgbox % FileFullPath "`n" oPath
;Run, explorer.exe %oPath%    ; 指定 explorer.exe 后打开, 使用 explorer.exe 打开速度5秒左右
Run, %oPath%   ; 不指定进程 explorer.exe 若文件夹与同名的exe在一个目录中, 优先打开 exe 文件. 可能出错但是速度快, 用时1.5秒左右.
return

EditFile:
LV_GetText(FileFullPath, LV_GetNext("F"), 2)
If Fileexist(FileFullPath)
Run,"%notepad2%" "%FileFullPath%"
return

checkmd5:
LV_GetText(FileFullPath, RF := LV_GetNext("F"), 2)
LV_GetText(FileMD5V, RF, 5)
File_Md5 := MD5_File(FileFullPath)
if File_Md5 && (File_Md5 != -1) && (File_Md5 != FileMD5V)
{
   updatefilemd5(FileFullPath, File_Md5)
   LV_Modify(RF, "Col5", File_Md5)
   LV_ModifyCol(5, 230)
}

if fileexist(CandySel)
{
	File_Md5_2 := MD5_File(CandySel)
	if (File_Md5 = File_Md5_2)
		CF_ToolTip("两文件 md5 一致", 3000)
	else
		CF_ToolTip("两文件 md5 不一致", 3000)
}
return

filetoclip:
ControlGet, selfiles, List, Col2 Selected, SysListView321, 文件库中搜索文件
FileToClipboard(selfiles)
return


FileToClipboard(FilesPath, DropEffect := "Copy")
{
	Static TCS := A_IsUnicode ? 2 : 1 ; size of a TCHAR
	Static PreferredDropEffect := DllCall("RegisterClipboardFormat", "Str", "Preferred DropEffect")
	Static DropEffects := {1: 1, 2: 2, Copy: 1, Move: 2}
	; -------------------------------------------------------------------------------------------------------------------
	; Count files and total string length
	TotalLength := 0
	FileArray := []
	Loop, Parse, FilesPath, `n, `r
	{
		If (Length := StrLen(A_LoopField))
			FileArray.Push({Path: A_LoopField, Len: Length + 1})
		TotalLength += Length
	}
	FileCount := FileArray.Length()
	If !(FileCount && TotalLength)
		Return False
	; -------------------------------------------------------------------------------------------------------------------
	; Add files to the clipboard
	If DllCall("OpenClipboard", "Ptr", A_ScriptHwnd) && DllCall("EmptyClipboard")
	{
		; HDROP format ---------------------------------------------------------------------------------------------------
		; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
		hDrop := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 20 + (TotalLength + FileCount + 1) * TCS, "UPtr")
		pDrop := DllCall("GlobalLock", "Ptr" , hDrop)
		Offset := 20
		NumPut(Offset, pDrop + 0, "UInt")         ; DROPFILES.pFiles = offset of file list
		NumPut(!!A_IsUnicode, pDrop + 16, "UInt") ; DROPFILES.fWide = 0 --> ANSI, fWide = 1 --> Unicode
		For Each, File In FileArray
			Offset += StrPut(File.Path, pDrop + Offset, File.Len) * TCS
		DllCall("GlobalUnlock", "Ptr", hDrop)
		DllCall("SetClipboardData","UInt", 0x0F, "UPtr", hDrop) ; 0x0F = CF_HDROP
		; Preferred DropEffect format ------------------------------------------------------------------------------------
		If (DropEffect := DropEffects[DropEffect])
		{
			; Write Preferred DropEffect structure to clipboard to switch between copy/cut operations
			; 0x42 = GMEM_MOVEABLE (0x02) | GMEM_ZEROINIT (0x40)
			hMem := DllCall("GlobalAlloc", "UInt", 0x42, "UInt", 4, "UPtr")
			pMem := DllCall("GlobalLock", "Ptr", hMem)
			NumPut(DropEffect, pMem + 0, "UChar")
			DllCall("GlobalUnlock", "Ptr", hMem)
			DllCall("SetClipboardData", "UInt", PreferredDropEffect, "Ptr", hMem)
		}
		DllCall("CloseClipboard")
		Return True
	}
	Return False
}

searchdb(crit="", partial=false)
{
	local result, Row
	LV_Delete()

	crit := trim(crit)
	if (crit == ""){
		return
	} else if partial {
		likestr := ""
		loop, parse, crit, % " `t", % " `t"    ; 在路径中搜索
			likestr .= "File_Path like ""%" A_loopfield "%"" and "
		likestr := Substr(likestr, 1, -4)
		q := "select * from flib where " likestr
	} else {   ; 仅在文件名中搜索
		q := "select * from flib where File_Name like ""%" crit "%"""
	}

	result := ""
	if !DB.GetTable(q, result)
		msgbox error
	loop % result.RowCount
	{
		result.Next(Row)
		File_Name := Row[2] ;data
		File_Path := Row[4]
		File_MT := Row[6]
		File_SizeKB := byte2KB(Row[8])
		File_Md5 := Row[9]
		File_SizeHM := byte2human(Row[8])
		LV_Add("", File_Name, File_Path, File_SizeKB, File_MT, File_Md5, File_SizeHM)
	}
	LV_ModifyCol()
	LV_ModifyCol(1, 160)
	LV_ModifyCol(2, 320)
	LV_ModifyCol(3, "60 Logical")
	LV_ModifyCol(6, 0)
	SB_SetText("")
}

byte2KB(byteV)
{
	if (byteV < 1024)
		return 1
	else
		return Floor(byteV / 1024)
}

; 没有考虑数字为整数的情况 如 3.00 kb
byte2human(byteV)
{
	if (byteV < 1024)
		return byteV " 字节"
	else if (byteV > 1024) and (byteV < 10240)   ; 1k 以上 10k 以下
	{
		byteV := ZTrim(Format("{:.2f}", byteV / 1024 - 0.005))
		return byteV " KB"
	}
	else if (byteV >= 10240) and (byteV < 102400)  ; 10k 以上 100k以下
	{
		byteV := ZTrim(Format("{:.1f}", byteV / 1024 - 0.05))
		return byteV " KB"
	}
	else if (byteV >= 102400) and (byteV < 1048576) ; 100k以上 1mb 以下
	{
		byteV := ZTrim(Format("{:.0f}", byteV / 1024 - 0.5))
		return byteV " KB"
	}
	else if (byteV >= 1048576) and (byteV < 10485760) ; 1 mb以上 10mb 以下
	{
		byteV := ZTrim(Format("{:.2f}", byteV / 1024 / 1024  - 0.005))
		return byteV " MB"
	}
	else if (byteV >= 10485760) and (byteV < 104857600) ; 10 mb以上 100mb 以下
	{
		byteV := ZTrim(Format("{:.1f}", byteV / 1024 / 1024 - 0.05))
		return byteV " MB"
	}
	else if (byteV >= 104857600) and (byteV < 1073741824) ; 100mb 以上 1GB 以下
	{
		byteV := ZTrim(Format("{:.0f}", byteV / 1024 / 1024 - 0.5))
		return byteV " MB"
	}
	else if (byteV >= 1073741824) and (byteV < 10737418240) ; 1 GB以上 10GB 以下
	{
		byteV := ZTrim(Format("{:.2f}", byteV / 1024 / 1024 / 1024 - 0.005))
		return byteV " GB"
	}
	else if (byteV >= 10737418240) and (byteV < 107374182400) ; 10 GB以上 100Gb 以下
	{
		byteV := ZTrim(Format("{:.1f}", byteV / 1024 / 1024 / 1024 - 0.05))
		return byteV " GB"
	}
	else if (byteV >= 107374182400) and (byteV < 1099511627776) ; 100 GB以上 1TB 以下
	{
		byteV := ZTrim(Format("{:.0f}", byteV / 1024 / 1024 / 1024 - 0.5))
		return byteV " GB"
	}
	else if (byteV >= 1099511627776) and (byteV < 10995116277760) ; 1TB 以上 10TB 以下
	{
		byteV := ZTrim(Format("{:.2f}", byteV / 1024 / 1024 / 1024 / 1024 - 0.005))
		return byteV " TB"
	}
	else if (byteV >= 10995116277760)    ; 10TB 以上
	{
		byteV := ZTrim(Format("{:.1f}", byteV / 1024 / 1024 / 1024 / 1024))
		return byteV " TB"
	}
}

ZTrim( N := "" )
{ ; SKAN /  CD:01-Jul-2017 | LM:03-Jul-2017 | Topic: goo.gl/TgWDb5
	Local    V  := StrSplit( N, ".", A_Space ) 
	Local    V0 := SubStr( V.1,1,1 ),   V1 := Abs( V.1 ),      V2 :=  RTrim( V.2, "0" )
Return ( V0 = "-" ? "-" : ""   )  ( V1 = "" ? 0 : V1 )   ( V2 <> "" ? "." V2 : "" )
}

updatesb:
Gui Submit, nohide
if (A_GuiEvent = "K")
{
	RF := LV_GetNext("F")
	if RF
	{
		LV_GetText(File_Name, RF, 1)
		LV_GetText(File_SizeHM, RF, 6)
	}
}
if (A_GuiEvent = "Normal")
{
	RF := LV_GetNext("F")
	if RF
	{
		LV_GetText(File_Name, RF, 1)
		LV_GetText(File_SizeHM, RF, 6)
	}
}
SB_SetText(File_Name " " File_SizeHM)
return






























createfliedb()
{
	q = 
	(
		CREATE TABLE if not exists Flib `(
		id	INTEGER PRIMARY KEY AUTOINCREMENT,
		File_Name	TEXT,
		File_Ext 	TEXT,
		File_Path 	TEXT,
		File_CT	TEXT,
		File_MT	TEXT,
		File_AT	TEXT,
		File_Size 	NUMBER,
		File_Md5 	TEXT
		`)
	)
	if !DB.Exec(q)
		MsgBox, 16, SQLite错误, % "消息:`t" . DB.ErrorMsg . "`n代码:`t" . DB.ErrorCode
}

updateFlib()
{
	global filelistarray

	flibarray:={}
	db.Query("Select File_Path from Flib", result)
	while result.Next(Row) != -1
		flibarray.Push(Row[1])

	deletefilelistarray:=[]
	for k,v in flibarray
	{
		if !filelistarray.Delete(v)
		deletefilelistarray.Push(v)
	}

	if filelistarray.Count()
		PLaddfile(filelistarray)

	;fileappend, % Array_ToString(filelistarray), %A_ScriptDir%\aaa.txt

	if deletefilelistarray.length()
		PLdeletefile(deletefilelistarray)
	return
}

PLaddfile(aArray)
{
	; adds some text data to history
	; the timestamp is in A_Now format
	global StartTime
	q:=""
	counter:=0
	DB.Exec("BEGIN TRANSACTION")
	for k,v in aArray
	{
		counter++
		SplitPath, k, File_Name,, File_Ext
		File_CT := convertTimeSql( CF_FileGetTime(k, "C") )
		File_MT := convertTimeSql( CF_FileGetTime(k) )
		File_AT := convertTimeSql( CF_FileGetTime(k, "A") )
		p :=  "(""" 
			. File_Name
			. """, """ . File_Ext . """, """ . k . """, """
			. File_CT . """, """ . File_MT . """, """ . File_AT . """, "
			. CF_FileGetSize(k) . ", """ . 0 """)"
		q .= p ","
		if counter > 5000
		{
			q := Trim(q, ",")
			q := "insert into Flib (File_Name, File_Ext, File_Path, File_CT, File_MT, File_AT, File_Size, File_Md5) values " q
			if (!DB.Exec(q))
				MsgBox, 16, SQLite 错误, % "消息:`t" . DB.ErrorMsg . "`n代码:`t" . DB.ErrorCode
			tooltip % "已用时:" (A_TickCount - StartTime) / 1000 "`n已完成:" A_index *100 / aArray.count() "%"
			counter := 0
			q := ""
		}
	}
	q := Trim(q, ",")
	if q
	{
		q := "insert into Flib (File_Name, File_Ext, File_Path, File_CT, File_MT, File_AT, File_Size, File_Md5) values " q
		if (!DB.Exec(q))
			MsgBox, 16, SQLite 错误, % "消息:`t" . DB.ErrorMsg . "`n代码:`t" . DB.ErrorCode
		counter := 0
		q := ""
	}
	;fileappend, % q, %A_ScriptDir%\ddd.txt
	DB.Exec("COMMIT TRANSACTION")
	tooltip % "已用时:" (A_TickCount - StartTime) / 1000
	q:=""
	return
}

updatefilemd5(file, hmd5)
{
	q := "select * from Flib where File_Path =""" file """"
	if !DB.Query(q, recordSet)
		msgbox ERROR
	if (recordSet.RowCount == 0)
		return 
	if !hmd5
		hmd5 := MD5_File(file)

	;q := "Update Mlib Set lastplayedtime=""" lastplayedtime """, plcount=""" plcount """ Where mp3=""" file """"
	q := "Update Flib Set File_Md5=""" hmd5 """ Where File_Path=""" file """"

	if (!DB.Exec(q))
    MsgBox, 16, SQLite 错误, % "消息:`t" . DB.ErrorMsg . "`n代码:`t" . DB.ErrorCode
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

; Converts YYYYMMDDHHMMSS to YYYY-MM-DD HH:MM:SS
convertTimeSql(t=""){
	if (t == "") 
		t:= A_Now
	return SubStr(t, 1, 4) "-" SubStr(t,5,2) "-" SubStr(t,7,2) " " SubStr(t, 9, 2) ":" SubStr(t,11,2) ":" SubStr(t,13,2)
}

CF_FileGetTime(file, ttype:="M")
{
	FileGetTime, OutputVar, % file, % ttype
	return OutputVar
}

CF_FileGetSize(file, type := "")
{
	FileGetSize, OutputVar, % file, % type
	return OutputVar
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

PLdeletefile(aArray){
	q:=""
	for k,v in aArray
	{
		p:= """" v """"
		q:= q p ","
	}
	q:= Trim(q, ",")
	if !q
		return

	q := "delete from Flib where File_Path in (" q ")"
	execSql(q)
	q:=""
	tooltip 更新文件库完成.
	return
}

execSql(s, warn:=0){
	; execute sql
	if (!DB.Exec(s))
		if (warn)
			msgbox % DB.ErrorCode "`n" DB.ErrorMsg
}

; ======================================================================================================================
; Github            https://github.com/AHK-just-me/Class_SQLiteDB
; Function:         Class definitions as wrappers for SQLite3.dll to work with SQLite DBs.
; AHK version:      1.1.33.09
; Tested on:        Win 10 Pro (x64), SQLite 3.11.1
; Version:          0.0.01.00/2011-08-10/just me
;                   0.0.02.00/2012-08-10/just me   -  Added basic BLOB support
;                   0.0.03.00/2012-08-11/just me   -  Added more advanced BLOB support
;                   0.0.04.00/2013-06-29/just me   -  Added new methods AttachDB and DetachDB
;                   0.0.05.00/2013-08-03/just me   -  Changed base class assignment
;                   0.0.06.00/2016-01-28/just me   -  Fixed version check, revised parameter initialization.
;                   0.0.07.00/2016-03-28/just me   -  Added support for PRAGMA statements.
;                   0.0.08.00/2019-03-09/just me   -  Added basic support for application-defined functions
;                   0.0.09.00/2019-07-09/just me   -  Added basic support for prepared statements, minor bug fixes
;                   0.0.10.00/2019-12-12/just me   -  Fixed bug in EscapeStr method
;                   0.0.10.00/2019-12-12/just me   -  Fixed bug in EscapeStr method
;                   0.0.11.00/2021-10-10/just me   -  Removed statement checks in GetTable, Prepare, and Query
;                   0.0.12.00/2022-09-18/just me   -  Fixed bug for Bind - type text
;                   0.0.13.00/2022-10-03/just me   -  Fixed bug in Prepare
;                   0.0.14.00/2022-10-04/just me   -  Changed DllCall parameter type PtrP to UPtrP
; Remarks:          Names of "private" properties / methods are prefixed with an underscore,
;                   they must not be set / called by the script!
;                   
;                   SQLite3.dll 假定在脚本目录中, 此脚本修改指定了dll文件的位置和名称
;                   文件名 32 位系统中为 \Dll\SQLite3_x32.dll, 64 位系统中为 \Dll\SQLite3_x64.dll
;
;                   Encoding of SQLite DBs is assumed to be UTF-8
;                   Minimum supported SQLite3.dll version is 3.6
;                   Download the current version of SQLite3.dll (and also SQlite3.exe) from www.sqlite.org
; ======================================================================================================================
; This software is provided 'as-is', without any express or implied warranty.
; In no event will the authors be held liable for any damages arising from the
; use of this software.
; ======================================================================================================================
; CLASS SQliteDB - SQLiteDB main class
; ======================================================================================================================
Class SQLiteDB {
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PRIVATE Properties and Methods ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; BaseClass - SQLiteDB base class
   ; ===================================================================================================================
      Static Version := ""
      Static _SQLiteDLL := A_ScriptDir . (A_PtrSize=8 ? "\..\..\..\引用程序\x64\sqlite3_x64.dll" : "\..\..\..\引用程序\x32\sqlite3_x32.dll")
      Static _RefCount := 0
      Static _MinVersion := "3.6"
   ; ===================================================================================================================
   ; CLASS _Table
   ; Object returned from method GetTable()
   ; _Table is an independent object and does not need SQLite after creation at all.
   ; ===================================================================================================================
   Class _Table {
      ; ----------------------------------------------------------------------------------------------------------------
      ; CONSTRUCTOR  Create instance variables
      ; ----------------------------------------------------------------------------------------------------------------
      __New() {
          This.ColumnCount := 0          ; Number of columns in the result table         (Integer)
          This.RowCount := 0             ; Number of rows in the result table            (Integer)     
          This.ColumnNames := []         ; Names of columns in the result table          (Array)
          This.Rows := []                ; Rows of the result table                      (Array of Arrays)
          This.HasNames := False         ; Does var ColumnNames contain names?           (Bool)
          This.HasRows := False          ; Does var Rows contain rows?                   (Bool)
          This._CurrentRow := 0          ; Row index of last returned row                (Integer)
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD GetRow      Get row for RowIndex
      ; Parameters:        RowIndex    - Index of the row to retrieve, the index of the first row is 1
      ;                    ByRef Row   - Variable to pass out the row array
      ; Return values:     On failure  - False
      ;                    On success  - True, Row contains a valid array
      ; Remarks:           _CurrentRow is set to RowIndex, so a subsequent call of NextRow() will return the
      ;                    following row.
      ; ----------------------------------------------------------------------------------------------------------------
      GetRow(RowIndex, ByRef Row) {
         Row := ""
         If (RowIndex < 1 || RowIndex > This.RowCount)
            Return False
         If !This.Rows.HasKey(RowIndex)
            Return False
         Row := This.Rows[RowIndex]
         This._CurrentRow := RowIndex
         Return True
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Next        Get next row depending on _CurrentRow
      ; Parameters:        ByRef Row   - Variable to pass out the row array
      ; Return values:     On failure  - False, -1 for EOR (end of rows)
      ;                    On success  - True, Row contains a valid array
      ; ----------------------------------------------------------------------------------------------------------------
      Next(ByRef Row) {
         Row := ""
         If (This._CurrentRow >= This.RowCount)
            Return -1
         This._CurrentRow += 1
         If !This.Rows.HasKey(This._CurrentRow)
            Return False
         Row := This.Rows[This._CurrentRow]
         Return True
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Reset       Reset _CurrentRow to zero
      ; Parameters:        None
      ; Return value:      True
      ; ----------------------------------------------------------------------------------------------------------------
      Reset() {
         This._CurrentRow := 0
         Return True
      }
   }  
   ; ===================================================================================================================
   ; CLASS _RecordSet
   ; Object returned from method Query()
   ; The records (rows) of a recordset can be accessed sequentially per call of Next() starting with the first record.
   ; After a call of Reset() calls of Next() will start with the first record again.
   ; When the recordset isn't needed any more, call Free() to free the resources.
   ; The lifetime of a recordset depends on the lifetime of the related SQLiteDB object.
   ; ===================================================================================================================
   Class _RecordSet {
      ; ----------------------------------------------------------------------------------------------------------------
      ; CONSTRUCTOR  Create instance variables
      ; ----------------------------------------------------------------------------------------------------------------
      __New() {
         This.ColumnCount := 0          ; Number of columns                             (Integer)
         This.ColumnNames := []         ; Names of columns in the result table          (Array)
         This.HasNames := False         ; Does var ColumnNames contain names?           (Bool)
         This.HasRows := False          ; Does _RecordSet contain rows?                 (Bool)
         This.CurrentRow := 0           ; Index of current row                          (Integer)
         This.ErrorMsg := ""            ; Last error message                            (String)
         This.ErrorCode := 0            ; Last SQLite error code / ErrorLevel           (Variant)
         This._Handle := 0              ; Query handle                                  (Pointer)
         This._DB := {}                 ; SQLiteDB object                               (Object)
     }
      ; ----------------------------------------------------------------------------------------------------------------
      ; DESTRUCTOR   Clear instance variables
      ; ----------------------------------------------------------------------------------------------------------------
      __Delete() {
         If (This._Handle)
            This.Free()
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Next        Get next row of query result
      ; Parameters:        ByRef Row   - Variable to store the row array
      ; Return values:     On success  - True, Row contains the row array
      ;                    On failure  - False, ErrorMsg / ErrorCode contain additional information
      ;                                  -1 for EOR (end of records)
      ; ----------------------------------------------------------------------------------------------------------------
      Next(ByRef Row) {
         Static SQLITE_NULL := 5
         Static SQLITE_BLOB := 4
         Static EOR := -1
         Row := ""
         This.ErrorMsg := ""
         This.ErrorCode := 0
         If !(This._Handle) {
            This.ErrorMsg := "无效的查询句柄!"
            Return False
         }
         RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_step", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DllCall sqlite3_step 失败!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC <> This._DB._ReturnCode("SQLITE_ROW")) {
            If (RC = This._DB._ReturnCode("SQLITE_DONE")) {
               This.ErrorMsg := "EOR"
               This.ErrorCode := RC
               Return EOR
            }
            This.ErrorMsg := This._DB.ErrMsg()
            This.ErrorCode := RC
            Return False
         }
         RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_data_count", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DllCall sqlite3_data_count 失败!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC < 1) {
            This.ErrorMsg := "记录集为空!"
            This.ErrorCode := This._DB._ReturnCode("SQLITE_EMPTY")
            Return False
         }
         Row := []
         Loop, %RC% {
            Column := A_Index - 1
            ColumnType := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_column_type", "Ptr", This._Handle, "Int", Column, "Cdecl Int")
            If (ErrorLevel) {
               This.ErrorMsg := "DllCall sqlite3_column_type 失败!"
               This.ErrorCode := ErrorLevel
               Return False
            }
            If (ColumnType = SQLITE_NULL) {
               Row[A_Index] := ""
            } Else If (ColumnType = SQLITE_BLOB) {
               BlobPtr := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_column_blob", "Ptr", This._Handle, "Int", Column, "Cdecl UPtr")
               BlobSize := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_column_bytes", "Ptr", This._Handle, "Int", Column, "Cdecl Int")
               If (BlobPtr = 0) || (BlobSize = 0) {
                  Row[A_Index] := ""
               } Else {
                  Row[A_Index] := {}
                  Row[A_Index].Size := BlobSize
                  Row[A_Index].Blob := ""
                  Row[A_Index].SetCapacity("Blob", BlobSize)
                  Addr := Row[A_Index].GetAddress("Blob")
                  DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", Addr, "Ptr", BlobPtr, "Ptr", BlobSize)
               }
            } Else {
               StrPtr := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_column_text", "Ptr", This._Handle, "Int", Column, "Cdecl UPtr")
               If (ErrorLevel) {
                  This.ErrorMsg := "DllCall sqlite3_column_text 失败!"
                  This.ErrorCode := ErrorLevel
                  Return False
               }
               Row[A_Index] := StrGet(StrPtr, "UTF-8")
            }
         }
         This.CurrentRow += 1
         Return True
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Reset       Reset the result pointer
      ; Parameters:        None
      ; Return values:     On success  - True
      ;                    On failure  - False, ErrorMsg / ErrorCode contain additional information
      ; Remarks:           After a call of this method you can access the query result via Next() again.
      ; ----------------------------------------------------------------------------------------------------------------
      Reset() {
         This.ErrorMsg := ""
         This.ErrorCode := 0
         If !(This._Handle) {
            This.ErrorMsg := "无效的查询句柄!"
            Return False
         }
         RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_reset", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DllCall sqlite3_reset 失败!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC) {
            This.ErrorMsg := This._DB._ErrMsg()
            This.ErrorCode := RC
            Return False
         }
         This.CurrentRow := 0
         Return True
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Free        Free query result
      ; Parameters:        None
      ; Return values:     On success  - True
      ;                    On failure  - False, ErrorMsg / ErrorCode contain additional information
      ; Remarks:           After the call of this method further access on the query result is impossible.
      ; ----------------------------------------------------------------------------------------------------------------
      Free() {
         This.ErrorMsg := ""
         This.ErrorCode := 0
         If !(This._Handle)
            Return True
         RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_finalize", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DllCall sqlite3_finalize 失败!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC) {
            This.ErrorMsg := This._DB._ErrMsg()
            This.ErrorCode := RC
            Return False
         }
         This._DB._Queries.Delete(This._Handle)
         This._Handle := 0
         This._DB := 0
         Return True
      }
   }
   ; ===================================================================================================================
   ; CLASS _Statement
   ; Object returned from method Prepare()
   ; The life-cycle of a prepared statement object usually goes like this:
   ; 1. Create the prepared statement object (PST) by calling DB.Prepare().
   ; 2. Bind values to parameters using the PST.Bind_*() methods of the statement object.
   ; 3. Run the SQL by calling PST.Step() one or more times.
   ; 4. Reset the prepared statement using PTS.Reset() then go back to step 2. Do this zero or more times.
   ; 5. Destroy the object using PST.Finalize().
   ; The lifetime of a prepared statement depends on the lifetime of the related SQLiteDB object.
   ; ===================================================================================================================
   Class _Statement {
      ; ----------------------------------------------------------------------------------------------------------------
      ; CONSTRUCTOR  Create instance variables
      ; ----------------------------------------------------------------------------------------------------------------
      __New() {
         This.ErrorMsg := ""           ; Last error message                            (String)
         This.ErrorCode := 0           ; Last SQLite error code / ErrorLevel           (Variant)
         This.ParamCount := 0          ; Number of SQL parameters for this statement   (Integer)
         This._Handle := 0             ; Query handle                                  (Pointer)
         This._DB := {}                ; SQLiteDB object                               (Object)
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; DESTRUCTOR   Clear instance variables
      ; ----------------------------------------------------------------------------------------------------------------
      __Delete() {
         If (This._Handle)
            This.Free()
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Bind        Bind values to SQL parameters.
      ; Parameters:        Index       -  1-based index of the SQL parameter
      ;                    Type        -  type of the SQL parameter (currently: Blob/Double/Int/Text)
      ;                    Param3      -  type dependent value
      ;                    Param4      -  type dependent value
      ;                    Param5      -  not used
      ; Return values:     On success  - True
      ;                    On failure  - False, ErrorMsg / ErrorCode contain additional information
      ; ----------------------------------------------------------------------------------------------------------------
      Bind(Index, Type, Param3 := "", Param4 := 0, Param5 := 0) {
         Static SQLITE_STATIC := 0
         Static SQLITE_TRANSIENT := -1
         Static Types := {Blob: 1, Double: 1, Int: 1, Text: 1}
         This.ErrorMsg := ""
         This.ErrorCode := 0
         If !(This._Handle) {
            This.ErrorMsg := "Invalid statement handle!"
            Return False
         }
         If (Index < 1) || (Index > This.ParamCount) {
            This.ErrorMsg := "Invalid parameter index!"
            Return False
         }
         If (Types[Type] = "") {
            This.ErrorMsg := "Invalid parameter type!"
            Return False
         }
         If (Type = "Blob") { ; ----------------------------------------------------------------------------------------
            ; Param3 = BLOB pointer, Param4 = BLOB size in bytes
            If Param3 Is Not Integer
            {
               This.ErrorMsg := "Invalid blob pointer!"
               Return False
            }
            If Param4 Is Not Integer
            {
               This.ErrorMsg := "Invalid blob size!"
               Return False
            }
            ; Let SQLite always create a copy of the BLOB
            RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_bind_blob", "Ptr", This._Handle, "Int", Index, "Ptr", Param3
                        , "Int", Param4, "Ptr", -1, "Cdecl Int")
            If (ErrorLeveL) {
               This.ErrorMsg := "DllCall sqlite3_bind_blob failed!"
               This.ErrorCode := ErrorLevel
               Return False
            }
            If (RC) {
               This.ErrorMsg := This._ErrMsg()
               This.ErrorCode := RC
               Return False
            }
         }
         Else If (Type = "Double") { ; ---------------------------------------------------------------------------------
            ; Param3 = double value
            If Param3 Is Not Float
            {
               This.ErrorMsg := "Invalid value for double!"
               Return False
            }
            RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_bind_double", "Ptr", This._Handle, "Int", Index, "Double", Param3
                        , "Cdecl Int")
            If (ErrorLeveL) {
               This.ErrorMsg := "DllCall sqlite3_bind_double failed!"
               This.ErrorCode := ErrorLevel
               Return False
            }
            If (RC) {
               This.ErrorMsg := This._ErrMsg()
               This.ErrorCode := RC
               Return False
            }
         }
         Else If (Type = "Int") { ; ------------------------------------------------------------------------------------
            ; Param3 = integer value
            If Param3 Is Not Integer
            {
               This.ErrorMsg := "Invalid value for int!"
               Return False
            }
            RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_bind_int", "Ptr", This._Handle, "Int", Index, "Int", Param3
                        , "Cdecl Int")
            If (ErrorLeveL) {
               This.ErrorMsg := "DllCall sqlite3_bind_int failed!"
               This.ErrorCode := ErrorLevel
               Return False
            }
            If (RC) {
               This.ErrorMsg := This._ErrMsg()
               This.ErrorCode := RC
               Return False
            }
         }
         Else If (Type = "Text") { ; -----------------------------------------------------------------------------------
            ; Param3 = zero-terminated string
            This._DB._StrToUTF8(Param3, UTF8)
            ; Let SQLite always create a copy of the text
            RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_bind_text", "Ptr", This._Handle, "Int", Index, "Ptr", &UTF8
                        , "Int", -1, "Ptr", -1, "Cdecl Int")
            If (ErrorLeveL) {
               This.ErrorMsg := "DllCall sqlite3_bind_text failed!"
               This.ErrorCode := ErrorLevel
               Return False
            }
            If (RC) {
               This.ErrorMsg := This._ErrMsg()
               This.ErrorCode := RC
               Return False
            }
         }
         Return True
      }

       ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Step        Evaluate the prepared statement.
      ; Parameters:        None
      ; Return values:     On success  - True
      ;                    On failure  - False, ErrorMsg / ErrorCode contain additional information
      ; Remarks:           You must call ST.Reset() before you can call ST.Step() again.
      ; ----------------------------------------------------------------------------------------------------------------
      Step() {
         This.ErrorMsg := ""
         This.ErrorCode := 0
         If !(This._Handle) {
            This.ErrorMsg := "Invalid statement handle!"
            Return False
         }
         RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_step", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DllCall sqlite3_step failed!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC <> This._DB._ReturnCode("SQLITE_DONE"))
         && (RC <> This._DB._ReturnCode("SQLITE_ROW")) {
            This.ErrorMsg := This._DB.ErrMsg()
            This.ErrorCode := RC
            Return False
         }
         Return True
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Reset       Reset the prepared statement.
      ; Parameters:        ClearBindings  - Clear bound SQL parameter values (True/False)
      ; Return values:     On success     - True
      ;                    On failure     - False, ErrorMsg / ErrorCode contain additional information
      ; Remarks:           After a call of this method you can access the query result via Next() again.
      ; ----------------------------------------------------------------------------------------------------------------
      Reset(ClearBindings := True) {
         This.ErrorMsg := ""
         This.ErrorCode := 0
         If !(This._Handle) {
            This.ErrorMsg := "Invalid statement handle!"
            Return False
         }
         RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_reset", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DllCall sqlite3_reset failed!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC) {
            This.ErrorMsg := This._DB._ErrMsg()
            This.ErrorCode := RC
            Return False
         }
         If (ClearBindings) {
            RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_clear_bindings", "Ptr", This._Handle, "Cdecl Int")
            If (ErrorLevel) {
               This.ErrorMsg := "DllCall sqlite3_clear_bindings failed!"
               This.ErrorCode := ErrorLevel
               Return False
            }
            If (RC) {
               This.ErrorMsg := This._DB._ErrMsg()
               This.ErrorCode := RC
               Return False
            }
         }
         Return True
      }
      ; ----------------------------------------------------------------------------------------------------------------
      ; METHOD Free        Free the prepared statement object.
      ; Parameters:        None
      ; Return values:     On success  - True
      ;                    On failure  - False, ErrorMsg / ErrorCode contain additional information
      ; Remarks:           After the call of this method further access on the statement object is impossible.
      ; ----------------------------------------------------------------------------------------------------------------
      Free() {
         This.ErrorMsg := ""
         This.ErrorCode := 0
         If !(This._Handle)
            Return True
         RC := DllCall(SQLiteDB._SQLiteDLL "\sqlite3_finalize", "Ptr", This._Handle, "Cdecl Int")
         If (ErrorLevel) {
            This.ErrorMsg := "DllCall sqlite3_finalize 失败!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC) {
            This.ErrorMsg := This._DB._ErrMsg()
            This.ErrorCode := RC
            Return False
         }
         This._DB._Stmts.Delete(This._Handle)
         This._Handle := 0
         This._DB := 0
         Return True
      }
   }
   ; ===================================================================================================================
   ; CONSTRUCTOR __New
   ; ===================================================================================================================
   __New() {
      This._Path := ""                  ; Database path                                 (String)
      This._Handle := 0                 ; Database handle                               (Pointer)
      This._Queries := {}               ; Valid queries                                 (Object)
      This._Stmts := {}                 ; Valid prepared statements                     (Object)
      If (This.Base._RefCount = 0) {
;         SQLiteDLL := This.base._SQLiteDLL
;         If !FileExist(SQLiteDLL)
;            If FileExist(A_ScriptDir . "\SQLiteDB.ini") {
;               IniRead, SQLiteDLL, %A_ScriptDir%\SQLiteDB.ini, Main, DllPath, %SQLiteDLL%
;               This.base._SQLiteDLL := SQLiteDLL
;         }
         If !(DLL := DllCall("LoadLibrary", "Str", This.base._SQLiteDLL, "UPtr")) {
            MsgBox, 16, SQLiteDB Error, % "DLL 文件 " . This.base._SQLiteDLL . " 不存在!"
            return
         }
         This.Base.Version := StrGet(DllCall(This.base._SQLiteDLL "\sqlite3_libversion", "Cdecl UPtr"), "UTF-8")
         SQLVersion := StrSplit(This.Base.Version, ".")
         MinVersion := StrSplit(This.Base._MinVersion, ".")
         If (SQLVersion[1] < MinVersion[1]) || ((SQLVersion[1] = MinVersion[1]) && (SQLVersion[2] < MinVersion[2])){
            DllCall("FreeLibrary", "Ptr", DLL)
            MsgBox, 16, SQLite ERROR, % "不支持的 SQLite3.dll 版本 " . This.Base.Version .  "!`n`n"
                                      . "你可以在 www.sqlite.org 下载支持的版本!"
            return
         }
      }
      This.Base._RefCount += 1
   }
   ; ===================================================================================================================
   ; DESTRUCTOR __Delete
   ; ===================================================================================================================
   __Delete() {
      If (This._Handle)
         This.CloseDB()
      This.Base._RefCount -= 1
      If (This.Base._RefCount = 0) {
         If (DLL := DllCall("GetModuleHandle", "Str", This.base._SQLiteDLL, "UPtr"))
            DllCall("FreeLibrary", "Ptr", DLL)
      }
   }
   ; ===================================================================================================================
   ; PRIVATE _StrToUTF8
   ; ===================================================================================================================
   _StrToUTF8(Str, ByRef UTF8) {
      VarSetCapacity(UTF8, StrPut(Str, "UTF-8"), 0)
      StrPut(Str, &UTF8, "UTF-8")
      Return &UTF8
   }
   ; ===================================================================================================================
   ; PRIVATE _UTF8ToStr
   ; ===================================================================================================================
   _UTF8ToStr(UTF8) {
      Return StrGet(UTF8, "UTF-8")
   }
   ; ===================================================================================================================
   ; PRIVATE _ErrMsg
   ; ===================================================================================================================
   _ErrMsg() {
      If (RC := DllCall(This.base._SQLiteDLL "\sqlite3_errmsg", "Ptr", This._Handle, "Cdecl UPtr"))
         Return StrGet(&RC, "UTF-8")
      Return ""
   }
   ; ===================================================================================================================
   ; PRIVATE _ErrCode
   ; ===================================================================================================================
   _ErrCode() {
      Return DllCall(This.base._SQLiteDLL "\sqlite3_errcode", "Ptr", This._Handle, "Cdecl Int")
   }
   ; ===================================================================================================================
   ; PRIVATE _Changes
   ; ===================================================================================================================
   _Changes() {
      Return DllCall(This.base._SQLiteDLL "\sqlite3_changes", "Ptr", This._Handle, "Cdecl Int")
   }
   ; ===================================================================================================================
   ; PRIVATE _Returncode
   ; ===================================================================================================================
   _ReturnCode(RC) {
      Static RCODE := {SQLITE_OK: 0          ; Successful result
                     , SQLITE_ERROR: 1       ; SQL error or missing database
                     , SQLITE_INTERNAL: 2    ; NOT USED. Internal logic error in SQLite
                     , SQLITE_PERM: 3        ; Access permission denied
                     , SQLITE_ABORT: 4       ; Callback routine requested an abort
                     , SQLITE_BUSY: 5        ; The database file is locked
                     , SQLITE_LOCKED: 6      ; A table in the database is locked
                     , SQLITE_NOMEM: 7       ; A malloc() failed
                     , SQLITE_READONLY: 8    ; Attempt to write a readonly database
                     , SQLITE_INTERRUPT: 9   ; Operation terminated by sqlite3_interrupt()
                     , SQLITE_IOERR: 10      ; Some kind of disk I/O error occurred
                     , SQLITE_CORRUPT: 11    ; The database disk image is malformed
                     , SQLITE_NOTFOUND: 12   ; NOT USED. Table or record not found
                     , SQLITE_FULL: 13       ; Insertion failed because database is full
                     , SQLITE_CANTOPEN: 14   ; Unable to open the database file
                     , SQLITE_PROTOCOL: 15   ; NOT USED. Database lock protocol error
                     , SQLITE_EMPTY: 16      ; Database is empty
                     , SQLITE_SCHEMA: 17     ; The database schema changed
                     , SQLITE_TOOBIG: 18     ; String or BLOB exceeds size limit
                     , SQLITE_CONSTRAINT: 19 ; Abort due to constraint violation
                     , SQLITE_MISMATCH: 20   ; Data type mismatch
                     , SQLITE_MISUSE: 21     ; Library used incorrectly
                     , SQLITE_NOLFS: 22      ; Uses OS features not supported on host
                     , SQLITE_AUTH: 23       ; Authorization denied
                     , SQLITE_FORMAT: 24     ; Auxiliary database format error
                     , SQLITE_RANGE: 25      ; 2nd parameter to sqlite3_bind out of range
                     , SQLITE_NOTADB: 26     ; File opened that is not a database file
                     , SQLITE_ROW: 100       ; sqlite3_step() has another row ready
                     , SQLITE_DONE: 101}     ; sqlite3_step() has finished executing
      Return RCODE.HasKey(RC) ? RCODE[RC] : ""
   }
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PUBLIC Interface ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; Properties
   ; ===================================================================================================================
    ErrorMsg := ""              ; Error message                           (String) 
    ErrorCode := 0              ; SQLite error code / ErrorLevel          (Variant)
    Changes := 0                ; Changes made by last call of Exec()     (Integer)
    SQL := ""                   ; Last executed SQL statement             (String)
   ; ===================================================================================================================
   ; METHOD OpenDB         Open a database
   ; Parameters:           DBPath      - Path of the database file
   ;                       Access      - Wanted access: "R"ead / "W"rite
   ;                       Create      - Create new database in write mode, if it doesn't exist
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; Remarks:              If DBPath is empty in write mode, a database called ":memory:" is created in memory
   ;                       and deletet on call of CloseDB.
   ; ===================================================================================================================
   OpenDB(DBPath, Access := "W", Create := True) {
      Static SQLITE_OPEN_READONLY  := 0x01 ; Database opened as read-only
      Static SQLITE_OPEN_READWRITE := 0x02 ; Database opened as read-write
      Static SQLITE_OPEN_CREATE    := 0x04 ; Database will be created if not exists
      Static MEMDB := ":memory:"
      This.ErrorMsg := ""
      This.ErrorCode := 0
      HDB := 0
      If (DBPath = "")
         DBPath := MEMDB
      If (DBPath = This._Path) && (This._Handle)
         Return True
      If (This._Handle) {
         This.ErrorMsg := "您必须首先关闭 DB " . This._Path . "!"
         Return False
      }
      Flags := 0
      Access := SubStr(Access, 1, 1)
      If (Access <> "W") && (Access <> "R")
         Access := "R"
      Flags := SQLITE_OPEN_READONLY
      If (Access = "W") {
         Flags := SQLITE_OPEN_READWRITE
         If (Create)
            Flags |= SQLITE_OPEN_CREATE
      }
      This._Path := DBPath
      This._StrToUTF8(DBPath, UTF8)
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_open_v2", "Ptr", &UTF8, "UPtrP", HDB, "Int", Flags, "Ptr", 0, "Cdecl Int")
      If (ErrorLevel) {
         This._Path := ""
         This.ErrorMsg := "DllCall sqlite3_open_v2 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This._Path := ""
         This.ErrorMsg := This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      This._Handle := HDB
      Return True
   }
   ; ===================================================================================================================
   ; METHOD CloseDB        Close database
   ; Parameters:           None
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   CloseDB() {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := ""
      If !(This._Handle)
         Return True
      For Each, Query in This._Queries
         DllCall(This.base._SQLiteDLL "\sqlite3_finalize", "Ptr", Query, "Cdecl Int")
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_close", "Ptr", This._Handle, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DllCall sqlite3_close 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      This._Path := ""
      This._Handle := ""
      This._Queries := []
      Return True
   }
   ; ===================================================================================================================
   ; METHOD AttachDB       Add another database file to the current database connection
   ;                       http://www.sqlite.org/lang_attach.html
   ; Parameters:           DBPath      - Path of the database file
   ;                       DBAlias     - Database alias name used internally by SQLite
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   AttachDB(DBPath, DBAlias) {
      Return This.Exec("ATTACH DATABASE '" . DBPath . "' As " . DBAlias . ";")
   }
   ; ===================================================================================================================
   ; METHOD DetachDB       Detaches an additional database connection previously attached using AttachDB()
   ;                       http://www.sqlite.org/lang_detach.html
   ; Parameters:           DBAlias     - Database alias name used with AttachDB()
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   DetachDB(DBAlias) {
      Return This.Exec("DETACH DATABASE " . DBAlias . ";")
   }
   ; ===================================================================================================================
   ; METHOD Exec           Execute SQL statement
   ; Parameters:           SQL         - Valid SQL statement
   ;                       Callback    - Name of a callback function to invoke for each result row coming out
   ;                                     of the evaluated SQL statements.
   ;                                     The function must accept 4 parameters:
   ;                                     1: SQLiteDB object
   ;                                     2: Number of columns
   ;                                     3: Pointer to an array of pointers to columns text
   ;                                     4: Pointer to an array of pointers to column names
   ;                                     The address of the current SQL string is passed in A_EventInfo.
   ;                                     If the callback function returns non-zero, DB.Exec() returns SQLITE_ABORT
   ;                                     without invoking the callback again and without running any subsequent
   ;                                     SQL statements.  
   ; Return values:        On success  - True, the number of changed rows is given in property Changes
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   Exec(SQL, Callback := "") {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := SQL
      If !(This._Handle) {
         This.ErrorMsg := "无效的 database 句柄!"
         Return False
      }
      CBPtr := 0
      Err := 0
      If (FO := Func(Callback)) && (FO.MinParams = 4)
         CBPtr := RegisterCallback(Callback, "F C", 4, &SQL)
      This._StrToUTF8(SQL, UTF8)
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_exec", "Ptr", This._Handle, "Ptr", &UTF8, "Int", CBPtr, "Ptr", Object(This)
                  , "UPtrP", Err, "Cdecl Int")
      CallError := ErrorLevel
      If (CBPtr)
         DllCall("Kernel32.dll\GlobalFree", "Ptr", CBPtr)
      If (CallError) {
         This.ErrorMsg := "DllCall sqlite3_exec 失败!"
         This.ErrorCode := CallError
         Return False
      }
      If (RC) {
         This.ErrorMsg := StrGet(Err, "UTF-8")
         This.ErrorCode := RC
         DllCall(This.base._SQLiteDLL "\sqlite3_free", "Ptr", Err, "Cdecl")
         Return False
      }
      This.Changes := This._Changes()
      Return True
   }
   ; ===================================================================================================================
   ; METHOD GetTable       Get complete result for SELECT query
   ; Parameters:           SQL         - SQL SELECT statement
   ;                       ByRef TB    - Variable to store the result object (TB _Table)
   ;                       MaxResult   - Number of rows to return:
   ;                          0          Complete result (default)
   ;                         -1          Return only RowCount and ColumnCount
   ;                         -2          Return counters and array ColumnNames
   ;                          n          Return counters and ColumnNames and first n rows
   ; Return values:        On success  - True, TB contains the result object
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   GetTable(SQL, ByRef TB, MaxResult := 0) {
      TB := ""
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := SQL
      If !(This._Handle) {
         This.ErrorMsg := "无效的 database 句柄!"
         Return False
      }
      Names := ""
      Err := 0, RC := 0, GetRows := 0
      I := 0, Rows := Cols := 0
      Table := 0
      If MaxResult Is Not Integer
         MaxResult := 0
      If (MaxResult < -2)
         MaxResult := 0
      This._StrToUTF8(SQL, UTF8)
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_get_table", "Ptr", This._Handle, "Ptr", &UTF8, "PtrP", Table
                  , "IntP", Rows, "IntP", Cols, "UPtrP", Err, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DllCall sqlite3_get_table 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := StrGet(Err, "UTF-8")
         This.ErrorCode := RC
         DllCall(This.base._SQLiteDLL "\sqlite3_free", "Ptr", Err, "Cdecl")
         Return False
      }
      TB := new This._Table
      TB.ColumnCount := Cols
      TB.RowCount := Rows
      If (MaxResult = -1) {
         DllCall(This.base._SQLiteDLL "\sqlite3_free_table", "Ptr", Table, "Cdecl")
         If (ErrorLevel) {
            This.ErrorMsg := "DllCall sqlite3_free_table 失败!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         Return True
      }
      If (MaxResult = -2)
         GetRows := 0
      Else If (MaxResult > 0) && (MaxResult <= Rows)
         GetRows := MaxResult
      Else
         GetRows := Rows
      Offset := 0
      Names := Array()
      Loop, %Cols% {
         Names[A_Index] := StrGet(NumGet(Table+0, Offset, "UPtr"), "UTF-8")
         Offset += A_PtrSize
      }
      TB.ColumnNames := Names
      TB.HasNames := True
      Loop, %GetRows% {
         I := A_Index
         TB.Rows[I] := []
         Loop, %Cols% {
            TB.Rows[I][A_Index] := StrGet(NumGet(Table+0, Offset, "UPtr"), "UTF-8")
            Offset += A_PtrSize
         }
      }
      If (GetRows)
         TB.HasRows := True
      DllCall(This.base._SQLiteDLL "\sqlite3_free_table", "Ptr", Table, "Cdecl")
      If (ErrorLevel) {
         TB := ""
         This.ErrorMsg := "DllCall sqlite3_free_table 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      Return True
   }
   ; ===================================================================================================================
   ; Prepared statement 10:54 2019.07.05. by Dixtroy
   ;  DB := new SQLiteDB
   ;  DB.OpenDB(DBFileName)
   ;  DB.Prepare 1 or more, just once
   ;  DB.Step 1 or more on prepared one, repeatable
   ;  DB.Finalize at the end
   ; ===================================================================================================================
   ; ===================================================================================================================
   ; METHOD Prepare        Prepare database table for further actions.
   ; Parameters:           SQL         - SQL statement to be compiled
   ;                       ByRef ST    - Variable to store the statement object (Class _Statement)
   ; Return values:        On success  - True, ST contains the statement object
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; Remarks:              You have to pass one ? for each column you want to assign a value later.
   ; ===================================================================================================================
   Prepare(SQL, ByRef ST) {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := SQL
      If !(This._Handle) {
         This.ErrorMsg := "无效的 database 句柄!"
         Return False
      }
      Stmt := 0
      This._StrToUTF8(SQL, UTF8)
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_prepare_v2", "Ptr", This._Handle, "Ptr", &UTF8, "Int", -1
                  , "UPtrP", Stmt, "Ptr", 0, "Cdecl Int")
      If (ErrorLeveL) {
         This.ErrorMsg := A_ThisFunc . ": DllCall sqlite3_prepare_v2 failed!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
		ST := New This._Statement
      ST.ParamCount := DllCall(This.base._SQLiteDLL "\sqlite3_bind_parameter_count", "Ptr", Stmt, "Cdecl Int")
      ST._Handle := Stmt
      ST._DB := This
      This._Stmts[Stmt] := Stmt
      Return True
    }
   ; ===================================================================================================================
   ; METHOD Query          Get "recordset" object for prepared SELECT query
   ; Parameters:           SQL         - SQL SELECT statement
   ;                       ByRef RS    - Variable to store the result object (Class _RecordSet)
   ; Return values:        On success  - True, RS contains the result object
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   Query(SQL, ByRef RS) {
      RS := ""
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := SQL
      ColumnCount := 0
      HasRows := False
      If !(This._Handle) {
         This.ErrorMsg := "无效的 database 句柄!"
         Return False
      }
      Query := 0
      This._StrToUTF8(SQL, UTF8)
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_prepare_v2", "Ptr", This._Handle, "Ptr", &UTF8, "Int", -1
                  , "UPtrP", Query, "Ptr", 0, "Cdecl Int")
      If (ErrorLeveL) {
         This.ErrorMsg := "DllCall sqlite3_prepare_v2 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_column_count", "Ptr", Query, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DllCall sqlite3_column_count 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC < 1) {
         This.ErrorMsg := "Query result is empty!"
         This.ErrorCode := This._ReturnCode("SQLITE_EMPTY")
         Return False
      }
      ColumnCount := RC
      Names := []
      Loop, %RC% {
         StrPtr := DllCall(This.base._SQLiteDLL "\sqlite3_column_name", "Ptr", Query, "Int", A_Index - 1, "Cdecl UPtr")
         If (ErrorLevel) {
            This.ErrorMsg := "DllCall sqlite3_column_name 失败!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         Names[A_Index] := StrGet(StrPtr, "UTF-8")
      }
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_step", "Ptr", Query, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DllCall sqlite3_step 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC = This._ReturnCode("SQLITE_ROW"))
         HasRows := True
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_reset", "Ptr", Query, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DllCall sqlite3_reset 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      RS := new This._RecordSet
      RS.ColumnCount := ColumnCount
      RS.ColumnNames := Names
      RS.HasNames := True
      RS.HasRows := HasRows
      RS._Handle := Query
      RS._DB := This
      This._Queries[Query] := Query
      Return True
   }
   ; ===================================================================================================================
   ; METHOD CreateScalarFunc  Create a scalar application defined function
   ; Parameters:              Name  -  the name of the function
   ;                          Args  -  the number of arguments that the SQL function takes
   ;                          Func  -  a pointer to AHK functions that implement the SQL function
   ;                          Enc   -  specifies what text encoding this SQL function prefers for its parameters
   ;                          Param -  an arbitrary pointer accessible within the funtion with sqlite3_user_data()
   ; Return values:           On success  - True
   ;                          On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; Documentation:           www.sqlite.org/c3ref/create_function.html
   ; ===================================================================================================================
   CreateScalarFunc(Name, Args, Func, Enc := 0x0801, Param := 0) {
      ; SQLITE_DETERMINISTIC = 0x0800 - the function will always return the same result given the same inputs
      ;                                 within a single SQL statement
      ; SQLITE_UTF8 = 0x0001
      This.ErrorMsg := ""
      This.ErrorCode := 0
      If !(This._Handle) {
         This.ErrorMsg := "无效 database 句柄!"
         Return False
      }
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_create_function", "Ptr", This._Handle, "AStr", Name, "Int", Args, "Int", Enc
                                                         , "Ptr", Param, "Ptr", Func, "Ptr", 0, "Ptr", 0, "Cdecl Int")
      If (ErrorLeveL) {
         This.ErrorMsg := "DllCall sqlite3_create_function 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      Return True
   }
   ; ===================================================================================================================
   ; METHOD LastInsertRowID   Get the ROWID of the last inserted row
   ; Parameters:              ByRef RowID - Variable to store the ROWID
   ; Return values:           On success  - True, RowID contains the ROWID
   ;                          On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   LastInsertRowID(ByRef RowID) {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := ""
      If !(This._Handle) {
         This.ErrorMsg := "无效的 database 句柄!"
         Return False
      }
      RowID := 0
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_last_insert_rowid", "Ptr", This._Handle, "Cdecl Int64")
      If (ErrorLevel) {
         This.ErrorMsg := "DllCall sqlite3_last_insert_rowid 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      RowID := RC
      Return True
   }
   ; ===================================================================================================================
   ; METHOD TotalChanges   Get the number of changed rows since connecting to the database
   ; Parameters:           ByRef Rows  - Variable to store the number of rows
   ; Return values:        On success  - True, Rows contains the number of rows
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   TotalChanges(ByRef Rows) {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := ""
      If !(This._Handle) {
         This.ErrorMsg := "无效的 database 句柄!"
         Return False
      }
      Rows := 0
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_total_changes", "Ptr", This._Handle, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DllCall sqlite3_total_changes 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      Rows := RC
      Return True
   }
   ; ===================================================================================================================
   ; METHOD SetTimeout     Set the timeout to wait before SQLITE_BUSY or SQLITE_IOERR_BLOCKED is returned,
   ;                       when a table is locked.
   ; Parameters:           TimeOut     - Time to wait in milliseconds
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   SetTimeout(Timeout := 1000) {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := ""
      If !(This._Handle) {
         This.ErrorMsg := "无效的 database 句柄!"
         Return False
      }
      If Timeout Is Not Integer
         Timeout := 1000
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_busy_timeout", "Ptr", This._Handle, "Int", Timeout, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := "DllCall sqlite3_busy_timeout 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      Return True
   }
   ; ===================================================================================================================
   ; METHOD EscapeStr      Escapes special characters in a string to be used as field content
   ; Parameters:           Str         - String to be escaped
   ;                       Quote       - Add single quotes around the outside of the total string (True / False)
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; ===================================================================================================================
   EscapeStr(ByRef Str, Quote := True) {
      This.ErrorMsg := ""
      This.ErrorCode := 0
      This.SQL := ""
      If !(This._Handle) {
         This.ErrorMsg := "无效的 database 句柄!"
         Return False
      }
      If Str Is Number
         Return True
      VarSetCapacity(OP, 16, 0)
      StrPut(Quote ? "%Q" : "%q", &OP, "UTF-8")
      This._StrToUTF8(Str, UTF8)
      Ptr := DllCall(This.base._SQLiteDLL "\sqlite3_mprintf", "Ptr", &OP, "Ptr", &UTF8, "Cdecl UPtr")
      If (ErrorLevel) {
         This.ErrorMsg := "DllCall sqlite3_mprintf 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      Str := This._UTF8ToStr(Ptr)
      DllCall(This.base._SQLiteDLL "\sqlite3_free", "Ptr", Ptr, "Cdecl")
      Return True
   }
   ; ===================================================================================================================
   ; METHOD StoreBLOB      Use BLOBs as parameters of an INSERT/UPDATE/REPLACE statement.
   ; Parameters:           SQL         - SQL statement to be compiled
   ;                       BlobArray   - Array of objects containing two keys/value pairs:
   ;                                     Addr : Address of the (variable containing the) BLOB.
   ;                                     Size : Size of the BLOB in bytes.
   ; Return values:        On success  - True
   ;                       On failure  - False, ErrorMsg / ErrorCode contain additional information
   ; Remarks:              For each BLOB in the row you have to specify a ? parameter within the statement. The
   ;                       parameters are numbered automatically from left to right starting with 1.
   ;                       For each parameter you have to pass an object within BlobArray containing the address
   ;                       and the size of the BLOB.
   ; ===================================================================================================================
   StoreBLOB(SQL, BlobArray) {
      Static SQLITE_STATIC := 0
      Static SQLITE_TRANSIENT := -1
      This.ErrorMsg := ""
      This.ErrorCode := 0
      If !(This._Handle) {
         This.ErrorMsg := "无效的 database 句柄!"
         Return False
      }
      If !RegExMatch(SQL, "i)^\s*(INSERT|UPDATE|REPLACE)\s") {
         This.ErrorMsg := A_ThisFunc . " 需要 INSERT/UPDATE/REPLACE 语句!"
         Return False
      }
      Query := 0
      This._StrToUTF8(SQL, UTF8)
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_prepare_v2", "Ptr", This._Handle, "Ptr", &UTF8, "Int", -1
                  , "UPtrP", Query, "Ptr", 0, "Cdecl Int")
      If (ErrorLeveL) {
         This.ErrorMsg := A_ThisFunc . ": DllCall sqlite3_prepare_v2 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      For BlobNum, Blob In BlobArray {
         If !(Blob.Addr) || !(Blob.Size) {
            This.ErrorMsg := A_ThisFunc . ": 无效的 BlobArray 参数!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         RC := DllCall(This.base._SQLiteDLL "\sqlite3_bind_blob", "Ptr", Query, "Int", BlobNum, "Ptr", Blob.Addr
                     , "Int", Blob.Size, "Ptr", SQLITE_STATIC, "Cdecl Int")
         If (ErrorLeveL) {
            This.ErrorMsg := A_ThisFunc . ": DllCall sqlite3_bind_blob 失败!"
            This.ErrorCode := ErrorLevel
            Return False
         }
         If (RC) {
            This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
            This.ErrorCode := RC
            Return False
         }
      }
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_step", "Ptr", Query, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := A_ThisFunc . ": DllCall sqlite3_step 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) && (RC <> This._ReturnCode("SQLITE_DONE")) {
         This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      RC := DllCall(This.base._SQLiteDLL "\sqlite3_finalize", "Ptr", Query, "Cdecl Int")
      If (ErrorLevel) {
         This.ErrorMsg := A_ThisFunc . ": DllCall sqlite3_finalize 失败!"
         This.ErrorCode := ErrorLevel
         Return False
      }
      If (RC) {
         This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
         This.ErrorCode := RC
         Return False
      }
      Return True
   }
}
; ======================================================================================================================
; Exemplary custom callback function regexp()
; Parameters:        Context  -  handle to a sqlite3_context object
;                    ArgC     -  number of elements passed in Values (must be 2 for this function)
;                    Values   -  pointer to an array of pointers which can be passed to sqlite3_value_text():
;                                1. Needle
;                                2. Haystack
; Return values:     Call sqlite3_result_int() passing 1 (True) for a match, otherwise pass 0 (False).
; ======================================================================================================================
SQLiteDB_RegExp(Context, ArgC, Values) {
   Result := 0
   If (ArgC = 2) {
      AddrN := DllCall(This.base._SQLiteDLL "\sqlite3_value_text", "Ptr", NumGet(Values + 0, "UPtr"), "Cdecl UPtr")
      AddrH := DllCall(This.base._SQLiteDLL "\sqlite3_value_text", "Ptr", NumGet(Values + A_PtrSize, "UPtr"), "Cdecl UPtr")
      Result := RegExMatch(StrGet(AddrH, "UTF-8"), StrGet(AddrN, "UTF-8"))
   }
   DllCall(This.base._SQLiteDLL "\sqlite3_result_int", "Ptr", Context, "Int", !!Result, "Cdecl") ; 0 = false, 1 = trus
}

Deref(String)
{
    spo := 1
    out := ""
    while (fpo:=RegexMatch(String, "(%(.*?)%)|``(.)", m, spo))
    {
        out .= SubStr(String, spo, fpo-spo)
        spo := fpo + StrLen(m)
        if (m1)
            out .= %m2%
        else switch (m3)
        {
            case "a": out .= "`a"
            case "b": out .= "`b"
            case "f": out .= "`f"
            case "n": out .= "`n"
            case "r": out .= "`r"
            case "t": out .= "`t"
            case "v": out .= "`v"
            default: out .= m3
        }
    }
    return out SubStr(String, spo)
}