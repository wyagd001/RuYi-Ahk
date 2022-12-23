ComObjError(0)
DetectHiddenWindows, On
WinGetTitle, h_hwnd, ��ȡ��ǰ������Ϣ ;ahk_class AutoHotkeyGUI
Windy_CurWin_id := StrReplace(h_hwnd, "��ȡ��ǰ������Ϣ_")
if Windy_CurWin_id
{
	WinGetClass, Windy_CurWin_Class, ahk_id %Windy_CurWin_id%
	WinGet Windy_CurWin_Pid, PID, ahk_id %Windy_CurWin_id%
	WinGetTitle, Windy_CurWin_Title, ahk_id %Windy_CurWin_id%
	WinGet, Windy_CurWin_Fullpath, ProcessPath, ahk_id %Windy_CurWin_id%
}
else
{
	WinGetClass, Windy_CurWin_Class, A
	WinGet Windy_CurWin_Pid, PID, A
	WinGetTitle, Windy_CurWin_Title, A
	WinGet, Windy_CurWin_Fullpath, ProcessPath, A
}

; ���ڱ�����·���Ĵ���ֱ�ӻ�ȡ���ڱ�������
IfInString, Windy_CurWin_Title, :\ 
{
	; ƥ��Ŀ¼����ƥ���ļ�
	;FullNamell:=RegExReplace(_Title,"^.*(.:(\\)?.*)\\.*$","$1")
	; �༭���ļ��޸ĺ���⿪ͷ����*��
	RegExMatch(Windy_CurWin_Title, "i)^\*?\K.*\..*(?= [-*] )", FileFullPath)
	FileFullPath := Trim(FileFullPath, " *[]")
	If FileFullPath
		goto OpenFileFullPath
}

; Word��Excel��WPS��et��Scite����
FileFullPath := getDocumentPath(Windy_CurWin_Fullpath)
if FileFullPath
	goto OpenFileFullPath

CMDLine:= WMI_Query(Windy_CurWin_Pid)
RegExMatch(CMDLine, "i).*exe.*?\s+(.*)", ff_)
StringReplace, FileFullPath, ff_1, `",, All
startzimu := RegExMatch(FileFullPath, "i)^[a-z]")
if !startzimu
{
	RegExMatch(FileFullPath, "i)([a-z]:\\.*\.\S*)", fff_)
	FileFullPath := fff_1
}
if FileFullPath
	goto OpenFileFullPath

; RealPlayer
IfInString, Windy_CurWin_Title, RealPlayer
{
	SetTitleMatchMode, Slow
	WinGetText, Windy_CurWin_Title, %Windy_CurWin_Title%
	IfInString, Windy_CurWin_Title, :/
	{
		; RealPlayerʽ����file://N:/��Ӱ/С��Ƶ/���ٲ�¥���ؿ�����ȷ�ĵ�����Ȧ�ռ����� ����.flv
		StringReplace, Windy_CurWin_Title, Windy_CurWin_Title, /, \, 1
		Loop, parse, Windy_CurWin_Title, `n, `r
		{
			StringTrimLeft, FileFullPath, A_LoopField, 7
			If FileFullPath && FileExist(FileFullPath)
				gosub OpenFileFullPath
		}
	}
	SetTitleMatchMode, fast
	Return
}

; ֱ�Ӵ򿪼��±�����Ȼ����ı��ļ���������û���ļ�·����ʹ�ö�ȡ�ڴ�ķ����õ�·��
IfInString, Windy_CurWin_Title, ���±�
{
	Windy_CurWin_Title := StrReplace(Windy_CurWin_Title, "*")
	If(Windy_CurWin_Title = "�ޱ��� - ���±�")
	Return
	OSRecentTextFile := A_AppData "\Microsoft\Windows\Recent\" StrReplace(Windy_CurWin_Title, " - ���±�") ".lnk"
	FileGetShortcut, % OSRecentTextFile, FileFullPath
	if FileExist(FileFullPath)
		gosub OpenFileFullPath
}
Return

OpenFileFullPath:
; QQ Ӱ��  �ļ�·��ĩβ����*����
FileFullPath := Trim(FileFullPath, "`*")
If Fileexist(FileFullPath)
{
	File_OpenAndSelect(FileFullPath)
	;Run, % "explorer.exe /select," FileFullPath
	Return
}
else
{
	RegExMatch(FileFullPath, "i)^\*?\K.*\..*(?= [-*] )", FileFullPath)
	If Fileexist(FileFullPath)
	{
		Run, % "explorer.exe /select," FileFullPath
		Return
	}
	Splitpath, FileFullPath, , Filepath
	If Fileexist(Filepath)
	{
		Msgbox, % "Ŀ���ļ������� " FileFullPath "��`r`n" "���ļ�����Ŀ¼ " Filepath "��"
		Run, % Filepath
		Return
	}
}
Return

getDocumentPath(_ProcessPath)  
{  
	SplitPath, _ProcessPath, , , , Process_NameNoExt  
	value := Process_NameNoExt  
	If IsLabel( "Case_" . value)  
		Goto Case_%value%  

	Case_WINWORD:  ; Word OpusApp
	Application:= ComObjActive("Word.Application") ; word
	ActiveDocument:= Application.ActiveDocument ; ActiveDocument
	Return  % ActiveDocument.FullName
	Case_EXCEL:  ; Excel XLMAIN
	Application := ComObjActive("Excel.Application") ; excel
	ActiveWorkbook := Application.ActiveWorkbook ; ActiveWorkbook
	Return % ActiveWorkbook.FullName
	Case_POWERPNT:  ; Powerpoint PPTFrameClass
	Application:= ComObjActive("PowerPoint.Application") ; Powerpoint
	ActivePresentation := Application.ActivePresentation ; ActivePresentation
	Return % ActivePresentation.FullName
	Case_WPS:
	Application := ComObjActive("kWPS.Application")
	if !Application
		Application := ComObjActive("WPS.Application")
	ActiveDocument := Application.ActiveDocument
	if !ActiveDocument   ; WPS ����Ȼ��򿪱���ļ������
	{
		Goto Case_ET
	}
	Return  % ActiveDocument.FullName
	Case_ET:
	Application := ComObjActive("ket.Application")
	if !Application
		Application := ComObjActive("et.Application")
	ActiveWorkbook := Application.ActiveWorkbook ; ActiveWorkbook
	Return % ActiveWorkbook.FullName
	Case_WPP:
	Application := ComObjActive("kWPP.Application")
	if !Application
		Application := ComObjActive("wpp.Application")
	ActivePresentation := Application.ActivePresentation ; ActivePresentation
	Return % ActivePresentation.FullName
	Case_SciTE:
	Application := ComObjActive("SciTE4AHK.Application")
	Return Application.CurrentFile
}

WMI_Query(pid)
{
   wmi :=    ComObjGet("winmgmts:")
    queryEnum := wmi.ExecQuery("" . "Select * from Win32_Process where ProcessId=" . pid)._NewEnum()
    if queryEnum[process]
        sResult.=process.CommandLine
    else
        sResult := 0 
   Return   sResult
}

File_OpenAndSelect(sFullPath)
{
	SplitPath sFullPath, , sPath
	FolderPidl := DllCall("shell32\ILCreateFromPath", "Str", sPath)
	; QtTabBar ʹ�� explorer /select, %sFullPath%, explorer %sFullPath% ����´���
	;run %sPath%  ; �ñ�ǩҳ��Ŀ¼��, ѡ����ܿ��ٽ���,���������SHOpenFolderAndSelectItems���ܻῨס(��װQtTabBar)
	sleep 200
	DllCall("shell32\SHParseDisplayName", "str", sFullPath, "Ptr", 0, "Ptr*", ItemPidl, "Uint", 0, "Uint*", 0)
	DllCall("shell32\SHOpenFolderAndSelectItems", "Ptr", FolderPidl, "UInt", 1, "Ptr*", ItemPidl, "Int", 0)
	CoTaskMemFree(FolderPidl)
	CoTaskMemFree(ItemPidl)
}

CoTaskMemFree(pv)
{
   Return   DllCall("ole32\CoTaskMemFree", "Ptr", pv)
}