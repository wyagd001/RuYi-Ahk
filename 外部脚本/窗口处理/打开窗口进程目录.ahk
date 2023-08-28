;|2.2|2023.08.03|1413
DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
if Windy_CurWin_id
{
	WinGet, Windy_CurWin_Fullpath, ProcessPath, ahk_id %Windy_CurWin_id%
}
else
{
	WinGet, Windy_CurWin_Fullpath, ProcessPath, A
}
File_OpenAndSelect(Windy_CurWin_Fullpath)
sleep 300
ExitApp

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