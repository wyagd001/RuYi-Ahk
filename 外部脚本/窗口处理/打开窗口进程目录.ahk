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

File_OpenAndSelect(sFullPath)
{
	SplitPath sFullPath, , sPath
	FolderPidl := DllCall("shell32\ILCreateFromPath", "Str", sPath)
	; QtTabBar 使用 explorer /select, %sFullPath%, explorer %sFullPath% 会打开新窗口
	;run %sPath%  ; 用标签页打开目录后, 选择才能快速结束,否则下面的SHOpenFolderAndSelectItems可能会卡住(安装了QtTabBar)
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