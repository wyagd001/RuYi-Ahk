;|2.2|2023.08.12|1061
ComObjError(0)
DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
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

; 窗口标题有路径的窗口直接获取窗口标题文字
IfInString, Windy_CurWin_Title, :\ 
{
	; 匹配目录不能匹配文件
	;FullNamell:=RegExReplace(_Title,"^.*(.:(\\)?.*)\\.*$","$1")
	; 编辑器文件修改后标题开头带“*”
	RegExMatch(Windy_CurWin_Title, "i)^\*?\K.*\..*(?= [-*] )", FileFullPath)
	FileFullPath := Trim(FileFullPath, " *[]")
	;msgbox % FileFullPath "$$1"
	If FileFullPath
		goto OpenFileFullPath
}

; Word、Excel、WPS、et、Scite程序
FileFullPath := getDocumentPath(Windy_CurWin_Fullpath)
;msgbox % FileFullPath "$$2"
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
		; RealPlayer式例：file://N:/电影/小视频/【藤缠楼】必看！正确的电线绕圈收集方法 标清.flv
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

; 直接打开记事本程序，然后打开文本文件，命令行没有文件路径，使用读取内存的方法得到路径
IfInString, Windy_CurWin_Title, 记事本
{
	Windy_CurWin_Title := StrReplace(Windy_CurWin_Title, "*")
	If(Windy_CurWin_Title = "无标题 - 记事本")
	Return
	OSRecentTextFile := A_AppData "\Microsoft\Windows\Recent\" StrReplace(Windy_CurWin_Title, " - 记事本") ".lnk"
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
	Case_Photoshop:
	Application := ComObjActive("Photoshop.Application")
	ActiveDocument:= Application.ActiveDocument
	try Return ActiveDocument.FullName
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

; 安装 QtTabBar 后, 使用 explorer /select, %sFullPath%, explorer %sFullPath% 会打开新窗口
; 使用 File_OpenAndSelect 不会打开新窗口, 但是
; 没有资源管理器的窗口时, 打开速度正常
; 已经存在资源管理器窗口时, 会卡住, 很久才能打开或不打开
File_OpenAndSelect(sFullPath)
{
	static QtTabBar
	if (QtTabBar = "")
	{
		QtTabBar := QtTabBar()
	}
	SplitPath sFullPath,, sPath
	if (QtTabBar = 1)
	{
		run %sPath%
		return
	}
	; 使用 Run 命令打开目录后, 选择才能快速结束,否则下面的 SHOpenFolderAndSelectItems 可能会卡住(安装了 QtTabBar)
	; 不能完全避免, 有时还是会卡住, 或者目录被打开了两次
	FolderPidl := DllCall("shell32\ILCreateFromPath", "Str", sPath)
	DllCall("shell32\SHParseDisplayName", "str", sFullPath, "Ptr", 0, "Ptr*", ItemPidl, "Uint", 0, "Uint*", 0)
	DllCall("shell32\SHOpenFolderAndSelectItems", "Ptr", FolderPidl, "UInt", 1, "Ptr*", ItemPidl, "Int", 0)
	CoTaskMemFree(FolderPidl)
	CoTaskMemFree(ItemPidl)
return
}

QtTabBar()
{
	try QtTabBarObj := ComObjCreate("QTTabBarLib.Scripting")
	if IsObject(QtTabBarObj)
	return 1
	else
	return 0
}

CoTaskMemFree(pv)
{
   Return   DllCall("ole32\CoTaskMemFree", "Ptr", pv)
}