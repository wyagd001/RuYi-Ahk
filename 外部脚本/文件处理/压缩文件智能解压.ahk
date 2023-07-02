﻿;|2.0|2023.07.01|1198
CandySel := A_Args[1]    ; 单个文件
if !CandySel             ; 多个文件
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}

ATA_settingFile := A_ScriptDir "\..\..\配置文件\如一.ini"
7z := (A_PtrSize = 8) ? (A_ScriptDir "\..\..\引用程序\x64\7z.exe") : (A_ScriptDir "\..\..\引用程序\x32\7z.exe")
7zG := (A_PtrSize = 8) ? (A_ScriptDir "\..\..\引用程序\x64\7zG.exe") : (A_ScriptDir "\..\..\引用程序\x32\7zG.exe")
if !FileExist(7z) or !FileExist(7zG)
{
	IniRead, 7z, %ATA_settingFile%, 其他程序, 7z, %A_Space%  ; 使用7z命令行解压, 会有cmd窗口, 遇到需要覆盖时, 会在cmd询问
	IniRead, 7zg, %ATA_settingFile%, 其他程序, 7zg, %A_Space%  ; 图形界面
}

cando_智能解压:
Loop Parse, CandySel, `n, `r
{
	if A_LoopField
		7z_smart_Unarchiver(A_LoopField)
}
Return

; 智能解压
; 1).压缩包内有多个文件（或文件夹）时“解压”文件到压缩包所在目录的“与压缩包同名的文件夹”内
; A.rar-------- Files / Folds / File+Fold / File+Folds / Files+Fold / Files+Folds  → Fold(name:A)
; 2).压缩包内有只有1个文件（夹）时“解压”文件到压缩包到所在目录
; A.rar-------- File→File / Fold→Fold
7z_smart_Unarchiver(S_File:="", S_tooltip:= 0)
{
	global 7Z, 7ZG
	if !7z
	{
		msgbox, 没有找到 7z 程序，请检查设置文件 [如一.ini] 中 [其他程序] 的7z条目，文件无法解压程序退出。
	return
	}
	SmartUnZip_首层多个文件标志 := SmartUnZip_首层有文件夹标志 := SmartUnZip_是否存在文件 := SmartUnZip_FileB := 0
	SmartUnZip_文件夹名A := SmartUnZip_文件夹名B := ""
	包_列表=%A_Temp%\wannianshuyaozhinengjieya_%A_Now%.txt

	; 将压缩包路径分割为它的所在目录和不含扩展名的文件名
	SplitPath S_File, 包_完整文件名, 包_目录, , 包_文件名, 包_磁盘
	DriveSpaceFree, IntUnZip_FreeSpace, %包_磁盘%
	FileGetSize, IntUnZip_FileSize, %S_File%, M
	If (IntUnZip_FileSize > IntUnZip_FreeSpace)
	{
		MsgBox 磁盘空间不足,无法解压文件。`n------------`n压缩包：%IntUnZip_FileSize%M`n剩余 ：%IntUnZip_FreeSpace%M
	Return
	}
	RunWait, %comspec% /c ""%7Z%" l "%S_File%"`>"%包_列表%"",,hide
	loop, read, %包_列表%
	{
		; 合计项老版 7z 不显示日期, 新版需要添加额外的条件
		if InStr(A_loopreadline, "-------------------")
		{
			SmartUnZip_FileB +=1
			if SmartUnZip_FileB = 2
				break
		}
		If(RegExMatch(A_LoopReadLine, "^(\d\d\d\d-\d\d-\d\d)")) || InStr(A_loopreadline, "...")
		{
			SmartUnZip_是否存在文件 := 1
			If( InStr(A_loopreadline, "D") = 21 Or InStr(A_loopreadline, "\"))  ;本行如果包含\或者有D标志，则判定为文件夹
			{
				SmartUnZip_首层有文件夹标志 = 1
			}

			If InStr(A_loopreadline, "\")
				StringMid, SmartUnZip_文件夹名A, A_LoopReadLine, 54, InStr(A_loopreadline, "\")-54
			Else
				StringTrimLeft, SmartUnZip_文件夹名A, A_LoopReadLine, 53

			If((SmartUnZip_文件夹名B != SmartUnZip_文件夹名A) And (SmartUnZip_文件夹名B != ""))
			{
				SmartUnZip_首层多个文件标志 = 1
				Break
			}
			SmartUnZip_文件夹名B := SmartUnZip_文件夹名A
		}
	}
	FileDelete, %包_列表%
	if !SmartUnZip_是否存在文件
	{
		msgbox 空压缩包或无法读取压缩包。
	return
	}

	;msgbox % "SmartUnZip_首层多个文件标志: " SmartUnZip_首层多个文件标志 "`n" "SmartUnZip_首层有文件夹标志: " SmartUnZip_首层有文件夹标志 "`n" "SmartUnZip_首层文件夹名: " SmartUnZip_首层文件夹名 "`n" "SmartUnZip_文件夹名A: " SmartUnZip_文件夹名A "`n" "SmartUnZip_文件夹名B: " SmartUnZip_文件夹名B

; -o 参数后不能有空格
	If(SmartUnZip_首层多个文件标志=0 && SmartUnZip_首层有文件夹标志 = 0)   ; 压缩文件内，首层有且仅有一个文件
	{
		Run, %7ZG% x "%S_File%" -o"%包_目录%"    ; 有且仅有一个文件直接解压，覆盖还是改名，交给7z
	}

	Else If(SmartUnZip_首层多个文件标志=0 && SmartUnZip_首层有文件夹标志 = 1)   ; 压缩文件内，首层有且仅有一个文件夹
	{
		;msgbox 222
		IfExist, %包_目录%\%SmartUnZip_文件夹名A%   ;已经存在了以“首层文件夹命名”的文件夹，怎么办？
		{
			Loop
			{
				SmartUnZip_NewFolderName = %包_目录%\%SmartUnZip_文件夹名A%(%A_Index%)
				If !FileExist(SmartUnZip_NewFolderName)
				{
					Run, %7ZG% x "%S_File%" -o"%SmartUnZip_NewFolderName%"
				break
				}
			}
		}
		Else  ;没有“首层文件夹命名”的文件夹，那就太好了
		{
			Run, %7ZG% x "%S_File%" -o"%包_目录%"
		}
	}
	Else  ; 其他情况
	{
		IfExist %包_目录%\%包_文件名%  ;已经存在了以“包文件名”的文件夹，怎么办？
		{
			Loop
			{
				SmartUnZip_NewFolderName = %包_目录%\%包_文件名%(%A_Index%)
				If !FileExist(SmartUnZip_NewFolderName)
				{
					Run, %7ZG% x "%S_File%" -o"%SmartUnZip_NewFolderName%"
				break
				}
			}
		}
		Else ;没有，那就太好了
		{
			Run, %7ZG% x "%S_File%" -o"%包_目录%\%包_文件名%"
		}
	}
	if S_tooltip
		CF_ToolTip("文件%包_完整文件名%解压完成！", 2000)
Return
}

CF_ToolTip(tipText, delay := 1000)
{
	ToolTip
	ToolTip, % tipText
	SetTimer, RemoveToolTip, % "-" delay
return

RemoveToolTip:
	ToolTip
return
}