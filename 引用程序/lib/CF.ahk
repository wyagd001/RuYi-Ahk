CF_FileAppend(text, FileName := "", Encoding := "UTF-8")
{
	if !Filename
		FilePath := A_Desktop "\debug.log"
	else
	{
		If !instr(fileName, "\")
			FilePath := A_Desktop "\" FileName
		else
			FilePath := FileName
	}
	FileAppend, % text, % FilePath, % Encoding
	if ErrorLevel
    Return %A_LastError%
}

CF_RegRead(KeyName, ValueName="")
{
	RegRead, OutputVar, % KeyName, % ValueName
	if ErrorLevel
    Return %A_LastError%
	else
    Return OutputVar
}

CF_RegWrite(Value, ValueType, KeyName, ValueName="")
{
	RegWrite, % ValueType, % KeyName, % ValueName, % Value
	if ErrorLevel
    Return %A_LastError%
	else
    Return 0
}

CF_RegDelete(KeyName, ValueName := "")
{
  if !ValueName or (ValueName="\")   ; 防止删除整个主键
  {
    KeyName := KeyName ValueName
    if KeyName in HKEY_LOCAL_MACHINE,HKEY_LOCAL_MACHINE\,HKEY_LOCAL_MACHINE\\,HKLM,HKLM\,HKLM\\,HKEY_CLASSES_ROOT,HKEY_CLASSES_ROOT\,HKEY_CLASSES_ROOT\\,HKCR,HKCR\,HKCR\\,HKEY_CURRENT_USER,HKEY_CURRENT_USER\,HKEY_CURRENT_USER\\,HKCU,HKCU\,HKCU\\
    {
      return 1
    }
  }
	RegDelete, % KeyName, % ValueName
	if ErrorLevel
    Return %A_LastError%
	else
    Return 0
}

CF_ToolTip(tipText, delay := 1000)
{
	ToolTip
	ToolTip, % tipText
  if (delay > 0)
    SetTimer, RemoveToolTip, % "-" delay
return

RemoveToolTip:
	ToolTip
return
}

CF_FolderIsEmpty(sfolder)
{
  Loop, Files, %sfolder%\*.*, FD
    return 0
  return 1
}

CF_WinMove(Win, x:="", y:="", w:="", h:="")
{
	WinMove, ahk_id %win%,, x, y, w, h
}

CF_IniRead(ini, sec, key := "", default := ""){
	IniRead, v, %ini%, %sec%, %key%, %default%
  Return, v
}

CF_IsFolder(sfile){
	if InStr(FileExist(sfile), "D")
	|| (sfile = """::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
	;|| (SubStr(sfile, 1, 2) = "\\")   ; 局域网共享文件夹 如 \\Win11\Soft
		return 1
	else
		return 0
}