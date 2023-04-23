; 1121
RecentFolderPath := upDir(A_StartMenu) "\Recent"
DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
if Windy_CurWin_id
{
	WinGetClass, Windy_CurWin_Class, ahk_id %Windy_CurWin_id%
	WinGet, Windy_CurWin_Fullpath, ProcessPath, Ahk_ID %Windy_CurWin_id% 
}
else
{
	WinGetClass, Windy_CurWin_Class, A
	WinGet, Windy_CurWin_Fullpath, ProcessPath, A
}

if (Windy_CurWin_Class = "Notepad") or (Windy_CurWin_Class = "Notepad2U") or (Windy_CurWin_Class = "SciTEWindow")
menu, % LnkFolderMenu(RecentFolderPath, "txt,ahk,htm","收藏夹",0,2,1,1), show
else if (Windy_CurWin_Class = "CabinetWClass") or (Windy_CurWin_Class = "Progman")
menu, % LnkFolderMenu(RecentFolderPath, "","收藏夹",0,2,1,0), show
else if (Windy_CurWin_Class = "WinRarWindow")
menu, % LnkFolderMenu(RecentFolderPath, "rar,zip","收藏夹",0,2,1,1), show
return

; LnkFolderMenu 函数参数
; FolderPath             文件夹路径，类型：字符串，必须的参数例如 "C:\"
; SpecifyExt             指定要显示的文件的扩展名，类型：字符串，可选 例如 "lnk"，"exe"，默认值"*"
; MenuName               是否指定菜单名称，类型：字符串，默认值为空
; ShowIcon               菜单是否带图标，类型：布尔值 0 或 1，默认值 1
; ShowOpenFolderMenu     是否显示子文件夹的“打开”菜单，类型：布尔值 0 或 1，默认值 1
;                        特殊值 2, 效果等同于 0，不同的在于在底部显示主目录的打开菜单
; Showhide               是否显示隐藏文件，类型：布尔值 0 或 1，默认值 0
; FolderFirst            子文件夹在前，类型：布尔值 0 或 1，默认值 1
;                        值为 1 时，文件菜单按文件名排序(中文排序不准)，值为 0 时，不排序(按loop文件的顺序)
; LnkFolderMenu 函数返回值  菜单名称 MenuName
;                        子文件夹数量超过 50，文件数量超过 500，返回空值

LnkFolderMenu(FolderPath, SpecifyExt:="*", MenuName:="", ShowIcon:=1, ShowOpenFolderMenu:=1, Showhide:=0, FolderFirst:=1, RecurseFolder:=1)
{
	MenuName := MenuName ? MenuName : FolderPath
	Array := StrSplit(SpecifyExt, ",")
	;msgbox % Array[1] " - " Array[2] " - " (Array[3]=""?0:1)
	if (ShowOpenFolderMenu = 1)
	{
		BoundRun := Func("Run").Bind(FolderPath)
		Menu, %MenuName%, add, 打开 %FolderPath%, %BoundRun%
		if ShowIcon
			FolderMenu_AddIcon(MenuName, "打开 " . FolderPath)
		Menu, %MenuName%, add
	}

	if !FolderFirst
	{
		menunum := 0
		ExistSubMenuName:={}
		Loop, %FolderPath%\*.lnk, 0, 1  ; lnk文件循环
		{
			if (A_Index > 500)
			{
				break
			}
			if !Showhide
			{
				if A_LoopFileAttrib contains H,R,S  ; 跳过具有 H(隐藏), R(只读) 或 S(系统) 属性的任何文件. 注意: 在 "H,R,S" 中不含空格.
				continue  ; 跳过这个文件并前进到下一个.
			}
			FileList .= A_LoopFileTimeModified "`t" A_LoopFileLongPath "`n"
		}
		;fileappend % FileList, 111.txt
		Sort, FileList, R
		;fileappend % FileList, 222.txt
		Loop, parse, FileList, `n
		{
			if (A_LoopField = "")  ; 忽略列表末尾的最后一个换行符(空项).
				continue
			StringSplit, FileItem, A_LoopField, %A_Tab%  ; 用 tab 作为分隔符将其分为两部分.
			SplitPath, FileItem2,, ParentFolderDirectory, fileExt, FileNameNoExt
			ParentFolderDirectory := (ParentFolderDirectory=FolderPath) ? MenuName : ParentFolderDirectory
			if (ShowOpenFolderMenu=1) && (ParentFolderDirectory != MenuName) && !ExistSubMenuName[ParentFolderDirectory]
			{
				ExistSubMenuName[ParentFolderDirectory]:=1
				BoundRun := Func("Run").Bind(ParentFolderDirectory)
				StringGetPos, pos, ParentFolderDirectory, \, R
				StringTrimLeft, SubMenuName, ParentFolderDirectory, % pos+1
				Menu, %ParentFolderDirectory%, add, 打开 %SubMenuName%, %BoundRun%
				if ShowIcon
					FolderMenu_AddIcon(ParentFolderDirectory, "打开 " . SubMenuName)
				Menu, %ParentFolderDirectory%, add
			}
			;msgbox %  pos "`n" A_LoopFileLongPath "`n" ParentFolderDirectory "`n" A_LoopFileName
			FileMenuName := FileNameNoExt
			
			if (Array[1]="*"?1:Array[1]=""?!instr(FileMenuName, "."):instr(FileMenuName, "." Array[1])) or (Array[2]=""?0:instr(FileMenuName, "." Array[2])) or (Array[3]=""?0:instr(FileMenuName, "." Array[3]))
			{
				FileGetShortcut, %FileItem2%, OutTarget
				if fileexist(OutTarget)
				{
					menunum ++
					if menunum >30
						break
					BoundRun := Func("Run").Bind(FileItem2)
					Menu, %ParentFolderDirectory%, add, %FileMenuName%, %BoundRun%
					if ShowIcon
						FolderMenu_AddIcon(ParentFolderDirectory, FileMenuName)
				}
			}
		}
	}

	Loop, %FolderPath%\*.*, 2, %RecurseFolder%   ; 文件夹
	{
		if (A_Index > 50)
		{
			msgbox, ,目录菜单创建失败, 选定文件夹内文件夹过多，无法创建菜单。`n文件夹最大数量：50。
		return
		}
		if !Showhide
		{
			if A_LoopFileAttrib contains H,R,S  ; 跳过具有 H(隐藏), R(只读) 或 S(系统) 属性的任何文件. 注意: 在 "H,R,S" 中不含空格.
			continue  ; 跳过这个文件并前进到下一个.
		}
		StringGetPos, pos, A_LoopFileLongPath, \, R
			StringLeft, ParentFolderDirectory, A_LoopFileLongPath, %pos%
		;msgbox %  pos "`n" A_LoopFileLongPath "`n" ParentFolderDirectory "`n" A_LoopFileName
		ParentFolderDirectory := (ParentFolderDirectory=FolderPath) ? MenuName : ParentFolderDirectory
		if FolderFirst || !ExistSubMenuName[A_LoopFileLongPath]
		{
			BoundRun := Func("Run").Bind(A_LoopFileLongPath)
			Menu, %A_LoopFileLongPath%, add, 打开 %A_LoopFileName%, %BoundRun%
			if (ShowOpenFolderMenu=1)
			{
				if ShowIcon
					FolderMenu_AddIcon(A_LoopFileLongPath, "打开 " . A_LoopFileName)
				filecount := 0
				Loop, %A_LoopFileLongPath%\*.%SpecifyExt%, 1, 0
				{
					filecount++
					break
				}
				Loop, %A_LoopFileLongPath%\*.*, 2, 0
				{
					filecount++
					break
				}
				if filecount
					Menu, %A_LoopFileLongPath%, add
			}
		}
		Menu, %ParentFolderDirectory%, add, %A_LoopFileName%, :%A_LoopFileLongPath%
		if ShowIcon
			FolderMenu_AddIcon(ParentFolderDirectory, A_LoopFileName)
		if (ShowOpenFolderMenu!=1)
		{
			Menu, %A_LoopFileLongPath%, Delete, 打开 %A_LoopFileName%
			filecount := 0
			Loop, %A_LoopFileLongPath%\*.%SpecifyExt%, 0, 1
			{
				filecount++
				break
			}
			if !filecount
				Menu, %A_LoopFileLongPath%, Delete
		}
	}
	
	if FolderFirst
	{
		Loop, %FolderPath%\*.lnk, 0, 1  ; 文件
		{
			if (A_Index > 500)
			{
				break
			}
			FileList .= A_LoopFileTimeModified "`t" A_LoopFileLongPath "`n"
		}
		Sort, FileList, R
		menunum := 0
		Loop, parse, FileList, `n
		{
			if (A_LoopField = "")  ; 忽略列表末尾的最后一个换行符(空项).
				continue
			StringSplit, FileItem, A_LoopField, %A_Tab%  ; 用 tab 
			if !Showhide
			{
				FileGetAttrib, FileAttrib, FileItem2
				if FileAttrib contains H,R,S  ; 跳过具有 H(隐藏), R(只读) 或 S(系统) 属性的任何文件. 注意: 在 "H,R,S" 中不含空格.
				continue  ; 跳过这个文件并前进到下一个.
			}
			SplitPath, FileItem2, FileName, ParentFolderDirectory, fileExt, FileNameNoExt
			ParentFolderDirectory := (ParentFolderDirectory=FolderPath) ? MenuName : ParentFolderDirectory
			;msgbox %  pos "`n" A_LoopFileLongPath "`n" ParentFolderDirectory "`n" A_LoopFileName
			FileMenuName := FileNameNoExt

			if (Array[1]="*"?1:Array[1]=""?!instr(FileMenuName, "."):instr(FileMenuName, "." Array[1])) or (Array[2]=""?0:instr(FileMenuName, "." Array[2])) or (Array[3]=""?0:instr(FileMenuName, "." Array[3]))
			{
				FileGetShortcut, %FileItem2%, OutTarget
				if fileexist(OutTarget)
				{
					menunum ++
					if menunum >30
						break
					BoundRun := Func("Run").Bind(FileItem2)
					Menu, %ParentFolderDirectory%, add, %FileMenuName%, %BoundRun%
					if ShowIcon
						FolderMenu_AddIcon(ParentFolderDirectory, FileMenuName)
				}
			}
			
		}
	}

	if (ShowOpenFolderMenu = 2)
	{
		Menu, %MenuName%, add
		BoundRun := Func("Run").Bind(FolderPath)
		Menu, %MenuName%, add, 打开 %FolderPath%, %BoundRun%
		if ShowIcon
		 FolderMenu_AddIcon(MenuName, "打开 " . FolderPath)
	}
	return MenuName
}

Run(a) {
	global Windy_CurWin_Fullpath
	if getkeystate("Shift") && Windy_CurWin_Fullpath
		run "%Windy_CurWin_Fullpath%" "%a%"
	else
		run, %a%
}

FolderMenu_AddIcon(menuitem,submenu)
{
	; Allocate memory for a SHFILEINFOW struct.
	VarSetCapacity(fileinfo, fisize := A_PtrSize + 688)
	
	; Get the file's icon.
	if DllCall("shell32\SHGetFileInfoW", "wstr", A_LoopFileLongPath?A_LoopFileLongPath:A_LoopField
		, "uint", 0, "ptr", &fileinfo, "uint", fisize, "uint", 0x100 | 0x000000001)
	{
		hicon := NumGet(fileinfo, 0, "ptr")
		; Set the menu item's icon.
		Menu %menuitem%, Icon, %submenu%, HICON:%hicon%
		; Because we used ":" and not ":*", the icon will be automatically
		; freed when the program exits or if the menu or item is deleted.
	}
}

upDir(Dir, levels:=1) {
    SplitPath, Dir,, ParentDir
    return levels > 1 ? upDir(--levels, ParentDir) : ParentDir
}