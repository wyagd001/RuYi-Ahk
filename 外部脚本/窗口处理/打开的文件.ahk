ComObjError(0)
DetectHiddenWindows, On
WinGetTitle, h_hwnd, ��ȡ��ǰ������Ϣ ;ahk_class AutoHotkeyGUI
h_hwnd := StrReplace(h_hwnd, "��ȡ��ǰ������Ϣ_")
if h_hwnd
{
	WinGetClass, h_class, ahk_id %h_hwnd%
	WinGet pid, PID, ahk_id %h_hwnd%
	WinGetTitle, _Title, ahk_id %h_hwnd%
	WinGet, ProcessPath, ProcessPath, ahk_id %h_hwnd%
}
else
{
	WinGetClass, h_class, A
	WinGet pid, PID, A
	WinGetTitle, _Title, A
	WinGet, ProcessPath, ProcessPath, A
}

; ���ڱ�����·���Ĵ���ֱ�ӻ�ȡ���ڱ�������
IfInString, _Title, :\ 
{
	; ƥ��Ŀ¼����ƥ���ļ�
	;FullNamell:=RegExReplace(_Title,"^.*(.:(\\)?.*)\\.*$","$1")
	; �༭���ļ��޸ĺ���⿪ͷ����*��
	RegExMatch(_Title, "i)^\*?\K.*\..*(?= [-*] )", FileFullPath)
	If FileFullPath
		goto OpenFileFullPath
}

; Word��Excel��WPS��et��Scite����
FileFullPath := getDocumentPath(ProcessPath)
if FileFullPath
	goto OpenFileFullPath

CMDLine:= WMI_Query(pid)
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
IfInString, _Title, RealPlayer
{
	SetTitleMatchMode, Slow
	WinGetText, _Title, %_Title%
	IfInString, _Title, :/
	{
		; RealPlayerʽ����file://N:/��Ӱ/С��Ƶ/���ٲ�¥���ؿ�����ȷ�ĵ�����Ȧ�ռ����� ����.flv
		StringReplace, _Title, _Title, /, \, 1
		Loop, parse, _Title, `n, `r
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
IfInString, _Title, ���±�
{
	If(_Title = "�ޱ��� - ���±�")
	Return
	OSRecentTextFile := A_AppData "\Microsoft\Windows\Recent\" StrReplace(_Title, " - ���±�") ".lnk"
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