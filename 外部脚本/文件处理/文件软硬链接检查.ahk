;|2.0|2023.07.01|1311
CandySel := A_Args[1]
;CandySel := "C:\Documents and Settings\Administrator\Desktop\JumPList\1.txt"
checkhardlink := ListHardLinks(CandySel)
if checkhardlink
	msgbox % "文件拥有硬链接:`n" checkhardlink
checkSoftlink := symlink_Shell(CandySel, target)
if checkSoftlink
{
	msgbox % "文件为软链接: " CandySel "`n目标源文件: " target
	return
}
if !checkhardlink && !checkSoftlink
	msgbox % "文件没有硬链接文件, 也不是软链接文件."
return

ListHardLinks(sFile)
{
	;static ERROR_MORE_DATA := 234
	static MAX_PATH := 520
	buflen := MAX_PATH
	VarSetCapacity(linkname, buflen)
	handle := DllCall("FindFirstFileNameW", "WStr", sFile, "UInt", 0, "UInt*", buflen, "WStr", linkname)
	root := SubStr(sFile, 1, 2)
	paths := ""
	try
	{
		b_index := 0
		Loop
		{
			paths .= root linkname "`n"
			
			buflen := MAX_PATH
			VarSetCapacity(linkname, buflen)
			more := DllCall("FindNextFileNameW", "UInt", handle, "UInt*", buflen, "WStr", linkname)
			b_index := A_Index
		} until (!more)
	} finally
	DllCall("FindClose", "UInt", handle)
	
	if (b_index < 2)
		return 0
	return paths
}

; 检查文件是否是软链接
;https://autohotkey.com/board/topic/116161-i-need-help-how-can-i-check-a-file-is-a-symlink-file/page-2#entry671199
symlink_Shell(filepath, ByRef target="", ByRef type="")
{
	SplitPath, filepath , FileName, DirPath,
	objShell :=   ComObjCreate("Shell.Application")
	objFolder :=   objShell.NameSpace(DirPath)      ;set the directry path
	objFolderItem :=   objFolder.ParseName(FileName)   ;set the file name
	att := objFolder.GetDetailsOf(objFolderItem, 6)
	;    6: attributes (see iColumn bellow)
	;    L: Link?
	status := objFolder.GetDetailsOf(objFolderItem, 202)
	;    202: link status (see iColumn bellow)
	;    "未解析“ test from symlink or normal file / folder
	target := objFolder.GetDetailsOf(objFolderItem, 203)
	;    203: Link target (absolute) (see iColumn bellow)
	;iColumn:
	;    Folder.GetDetailsOf method (Shlobj\_core.h) - Win32 apps | Microsoft Docs
	;        https://docs.microsoft.com/en-us/windows/win32/shell/folder-getdetailsof
	;    c# - What options are available for Shell32.Folder.GetDetailsOf(..,..)? - Stack Overflow
	;        https://stackoverflow.com/questions/22382010/what-options-are-available-for-shell32-folder-getdetailsof
	if (att="AL")
		type:="File"
	else if (att="DL")
		type := "Folder"
	;else assert(att="A")
	if (att="AL" or att="DL")
		return 1
	else
		return 0
}