; 1310
CandySel := A_Args[1]
;CandySel := "C:\Users\Administrator\Desktop"
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
Gui, Add, ListView, x10 yp+36 w630 h400 vfilelist hwndHLV AltSubmit gopenads, 序号|文件路径
Gui, Add, Button, x10 yp+410 h30 gdelsel, 删除选中
gui, Show,, 文件硬链接管理

if CandySel
	gosub loadfolder
Return

loadfolder:
Gui, 66: Default
Gui, submit, nohide
LV_Delete()
f_array := []
Loop, Files, %sfolder%\*.*, DFR    ;;;
{
	For k, v In ListHardLinks(A_LoopFilePath)
	{
		f_array[v] := k
	}
}

For k, v In f_array
	LV_Add("", v, k)

LV_ModifyCol()
LV_ModifyCol(1, 50)
LV_ModifyCol(2, 400)
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

delsel:
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

ListHardLinks(sFile)
{
	;static ERROR_MORE_DATA := 234
	;FileAppend, % "@ " sFile "`n", %A_desktop%\123.txt
	static MAX_PATH := 520
	buflen := MAX_PATH
	VarSetCapacity(linkname, buflen)
	handle := DllCall("FindFirstFileNameW", "WStr", sFile, "UInt", 0, "UInt*", buflen, "WStr", linkname)
	root := SubStr(sFile, 1, 2)
	paths := []
	try
	{
		Loop
		{
			org := root linkname
			;FileAppend, % A_index " ☆ " org "`n", %A_desktop%\123.txt
			buflen := MAX_PATH
			VarSetCapacity(linkname, buflen)
			more := DllCall("FindNextFileNameW", "UInt", handle, "UInt*", buflen, "WStr", linkname)
			if more
			{
				;FileAppend, % A_index " - " root linkname  "`n", %A_desktop%\123.txt
				paths[A_index] := org
				paths[A_index+1] := root linkname
			}
		}
		until (!more)
	} 
	finally DllCall("FindClose", "UInt", handle)
	return paths
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