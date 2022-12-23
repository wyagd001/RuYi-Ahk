ComObjError(0)
DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
h_hwnd := StrReplace(h_hwnd, "获取当前窗口信息_")
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

; 窗口标题有路径的窗口直接获取窗口标题文字
IfInString, _Title, :\ 
{
	; 匹配目录不能匹配文件
	;FullNamell:=RegExReplace(_Title,"^.*(.:(\\)?.*)\\.*$","$1")
	; 编辑器文件修改后标题开头带“*”
	RegExMatch(_Title, "i)^\*?\K.*\..*(?= [-*] )", FileFullPath)
	If FileFullPath
		goto OpenFileFullPath
}

; Word、Excel、WPS、et、Scite程序
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
		; RealPlayer式例：file://N:/电影/小视频/【藤缠楼】必看！正确的电线绕圈收集方法 标清.flv
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

; 直接打开记事本程序，然后打开文本文件，命令行没有文件路径，使用读取内存的方法得到路径
IfInString, _Title, 记事本
{
	If(_Title = "无标题 - 记事本")
	Return
	OSRecentTextFile := A_AppData "\Microsoft\Windows\Recent\" StrReplace(_Title, " - 记事本") ".lnk"
	FileGetShortcut, % OSRecentTextFile, FileFullPath
	if FileExist(FileFullPath)
		gosub OpenFileFullPath
}
Return

OpenFileFullPath:
; QQ 影音  文件路径末尾带“*”号
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
		Msgbox, % "目标文件不存在 " FileFullPath "，`r`n" "打开文件所在目录 " Filepath "。"
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
	if !ActiveDocument   ; WPS 启动然后打开表格文件的情况
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
	; QtTabBar 使用 explorer /select, %sFullPath%, explorer %sFullPath% 会打开新窗口
	;run %sPath%  ; 用标签页打开目录后, 选择才能快速结束,否则下面的SHOpenFolderAndSelectItems可能会卡住(安装QtTabBar)
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