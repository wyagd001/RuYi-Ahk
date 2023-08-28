;|2.0|2023.07.01|1303
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\f32a.ico"
CandySel := A_Args[1]
;CandySel := "C:\Documents and Settings\Administrator\Desktop"
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}

Gui, 66: Destroy
Gui, 66: Default

Gui, Add, Text, x10 y15 h25, 查找文件夹:
Gui, Add, Edit, xp+80 yp-5 w480 h25 vsfolder, % CandySel
Gui, Add, Button, xp+490 yp-2 w60 h30 gloadfolder, 开始查找
Gui, Add, ListView, x10 yp+36 w630 h400 vfilelist hwndHLV AltSubmit gopenads, 文件名|数据流名称|所在目录|大小|大小(字节)
Gui, Add, Button, x10 yp+410 h30 gaddadstext, 添加文本
Gui, Add, Button, xp+70 yp h30 gaddadsbin, 添加文件
Gui, Add, Button, xp+70 yp h30 gdelads, 删除选中
Gui, Add, Button, xp+70 yp h30 greadads, 读取文本
Gui, Add, Button, xp+70 yp h30 gsaveads, 另存到桌面
gui, Show,, ADS 管理

if CandySel
	gosub loadfolder
Return

loadfolder:
Gui, 66: Default
Gui, submit, nohide
LV_Delete()
Loop, Files, %sfolder%\*.*, DFR
{
	For Index, Stream In EnumFileStreams(A_LoopFilePath)
	{
		LV_Add("", A_LoopFileName, Stream.Name, A_LoopFileDir, DisplaySize(Stream.Size), Stream.Size)
	}
}
LV_ModifyCol()
LV_ModifyCol(1, 150)
LV_ModifyCol(2, 150)
return

66GuiClose:
66Guiescape:
Gui, Destroy
exitapp

openads:
Gui, 66: Default
Gui, submit, nohide
if A_GuiEvent = DoubleClick
{
	RF := LV_GetNext("F")
	if RF
	{
		LV_GetText(filename, RF, 1)
		LV_GetText(streamfilename, RF, 2)
		LV_GetText(filedir, RF, 3)
		;msgbox % "notepad.exe " filedir "\" filename streamfilename
		run, % "notepad.exe " filedir "\" filename streamfilename
	}
}
return

addadstext:
Gui, 66: Default
Gui, submit, nohide
RF := LV_GetNext("F")
if RF
{
	LV_GetText(filename, RF, 1)
	LV_GetText(streamfilename, RF, 2)
	LV_GetText(filedir, RF, 3)
	
	Loop_Index := 1
	While FileExist(filedir "\" filename ":ads" Loop_Index)
	{
		Loop_Index := A_Index + 1
	}
	FileAppend,, % filedir "\" filename ":ads" Loop_Index
	RunWait, % "notepad.exe " filedir "\" filename ":ads" Loop_Index
	gosub loadfolder
}
Return

addadsbin:
Gui, 66: Default
Gui, submit, nohide
RF := LV_GetNext("F")
if RF
{
	LV_GetText(filename, RF, 1)
	LV_GetText(filedir, RF, 3)
	FileSelectFile, streamselfile,,, 选择要添加的文件
	if !streamselfile
		Return
	SplitPath, streamselfile, streamfilename
	streamselfile_obj := FileOpen(streamselfile, "r")
	streamselfile_obj.RawRead(streambin, streamselfile_obj.Length)
	streamfile_obj := FileOpen(filedir "\" filename ":" streamfilename, "rw")
	streamfile_obj.RawWrite(streambin, streamselfile_obj.Length)
	streamfile_obj := streamselfile_obj := streambin := "" 
	gosub loadfolder
}
Return

delads:
Gui, 66: Default
Gui, submit, nohide
RF := LV_GetNext("F")
if RF
{
	LV_GetText(filename, RF, 1)
	LV_GetText(streamfilename, RF, 2)
	LV_GetText(filedir, RF, 3)
	filedelete, % filedir "\" filename streamfilename
	LV_Delete(RF)
}
Return

readads:
Gui, 66: Default
Gui, submit, nohide
RF := LV_GetNext("F")
if RF
{
	LV_GetText(filename, RF, 1)
	LV_GetText(streamfilename, RF, 2)
	LV_GetText(filedir, RF, 3)
	MsgBox % FileOpen(filedir "\" filename streamfilename, "r").Read()
}
Return

saveads:
Gui, 66: Default
Gui, submit, nohide
RF := LV_GetNext("F")
if RF
{
	LV_GetText(filename, RF, 1)
	LV_GetText(streamfilename, RF, 2)
	LV_GetText(filedir, RF, 3)
	LV_GetText(streamfilesize, RF, 5)
	streamfile_obj := FileOpen(filedir "\" filename streamfilename, "r")
	streamfile_obj.RawRead(streambin, streamfilesize)
	streamsavefilename := strreplace(streamfilename, ":")
	streamsavefilename := strreplace(streamsavefilename, "$DATA")
	streamsavefile := PathU(A_desktop "\" streamsavefilename)
	streamsavefile_obj := FileOpen(streamsavefile, "rw")
	streamsavefile_obj.RawWrite(streambin, streamfilesize)
	streamfile_obj := streamsavefile_obj := streambin := "" 
}
Return

EnumFileStreams(FileName) {
   ; FileName : The fully qualified file name.
   Streams := []
   If (DllCall("Kernel32.dll\GetVersion", "UChar") < 6)
      Return False
   VarSetCapacity(FSD, 600, 0) ; WIN32_FIND_STREAM_DATA
   HFIND := DllCall("Kernel32.dll\FindFirstStreamW", "WStr", FileName, "Int", 0, "Ptr", &FSD, "UInt", 0, "Ptr")
   If (HFIND <> -1) {
      ; Uncomment to add the main stream of the file (i.e. the file itself)
      ; Streams.Insert({Size: NumGet(&FSD, 0, "UInt64"), Name: StrGet(&FSD + 8, 296, "UTF-16")})
      While DllCall("Kernel32.dll\FindNextStreamW", "Ptr", HFIND, "Ptr", &FSD)
         Streams.Insert({Size: NumGet(&FSD, 0, "UInt64"), Name: StrGet(&FSD + 8, 296, "UTF-16")})
      DllCall("Kernel32.dll\FindClose", "Ptr", HFIND)
      Return Streams
   }
   Return False
}

DisplaySize(FileSize) {
   Static KB := 1024
   Static MB := KB * 1024
   Static GB := MB * 1024
   Return (FileSize >= GB) ? (Round(FileSize / GB, 2) . " GB")
        : (FileSize >= MB) ? (Round(FileSize / MB) . " MB")
        : (FileSize >= KB) ? (Round(FileSize / KB) . " kB")
        : (FileSize < KB) ? (Round(FileSize) . " byte")
	    : FileSize
}

PathU(Filename) { ;  PathU v0.91 by SKAN on D35E/D68M @ tiny.cc/pathu
Local OutFile
  VarSetCapacity(OutFile, 520)
  DllCall("Kernel32\GetFullPathNameW", "WStr",Filename, "UInt",260, "Str",OutFile, "Ptr",0)
  DllCall("Shell32\PathYetAnotherMakeUniqueName", "Str",OutFile, "Str",Outfile, "Ptr",0, "Ptr",0)
Return A_IsUnicode ? OutFile : StrGet(&OutFile, "UTF-16")
}