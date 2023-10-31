;|2.0|2023.07.01|多条目
; 1042 参数可变, 多条目
CandySel :=  A_Args[1]
DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
if !Windy_CurWin_id
	WinGet, Windy_CurWin_id, ID, A
WinActivate, ahk_id %Windy_CurWin_id%
WinGetClass, Windy_CurWin_Class, ahk_id %Windy_CurWin_id%
if (Windy_CurWin_Class = "CabinetWClass") or (Windy_CurWin_Class = "#32770")
	SetDirectory(CandySel, Windy_CurWin_id)
if (Windy_CurWin_Class = "ConsoleWindowClass")
{
	WinActivate, ahk_id %Windy_CurWin_id%
	Clipboard :="cd /d """ . CandySel . """"
	ClipWait
	send {click right}{enter}
	sleep, 100
}
return

SetDirectory(sPath, hWnd:="")
{
	sPath:=ExpandEnvVars(sPath)
	If(strEndsWith(sPath, ":"))
		sPath .="\"s
	WinGetClass, h_class, ahk_id %hwnd%
	If (h_class="CabinetWClass")
	{
		If (CF_IsFolder(sPath) || SubStr(sPath,1,6)="shell:" || SubStr(sPath,1,6)="ftp://" || strEndsWith(sPath,".search-ms")||CF_Isinteger(sPath))
		{
			hWnd:= hWnd ? hWnd : WinExist("A")
			ShellNavigate(sPath, 0, hwnd)
		}
	}
	If (IsDialog(hWnd))
	{
		SetDialogDirectory(sPath, hwnd)
	}
	return
}

strEndsWith(string,end)
{
	Return strlen(end)<=strlen(string) && Substr(string,-strlen(end)+1)=end
}

SetDialogDirectory(Path, hWnd:="")
{
	hWnd:= hWnd ? hWnd : WinExist("A")
	ControlGetFocus, focussed, ahk_id %hwnd%
	ControlGetText, w_Edit1Text, Edit1, ahk_id %hwnd%
	ControlClick, Edit1, ahk_id %hwnd%
	Sleep, 100
	ControlSetText, Edit1, %Path%, ahk_id %hwnd%
	ControlFocus,  Edit1, ahk_id %hwnd%
	ControlSend, Edit1, {Enter}, ahk_id %hwnd%
	Sleep, 200	; It needs extra time on some dialogs or in some cases.
	while hwnd!=WinExist("A")
	{
		Sleep, 100
		ControlGetFocus, focussed, ahk_id %hwnd%
		tooltip % focussed
	}
	ControlSetText, Edit1, %w_Edit1Text%, ahk_id %hwnd%
	ControlFocus %focussed%, ahk_id %hwnd%
}

Explorer_GetWindow(hwnd="")
{
	static shell := ComObjCreate("Shell.Application")
	; thanks to jethrow for some pointers here
	WinGet, process, processName, % "ahk_id" hwnd := (hwnd ? hwnd : WinExist("A"))
	WinGetClass class, ahk_id %hwnd%
    
	If (process!="explorer.exe")
		Return
	If (class ~= "(Cabinet|Explore)WClass")
	{
		for window in shell.Windows
		{
			;tooltip % window.hwnd " - " hwnd
			If (window.hwnd==hwnd)
			Return window
		}
	}
	Else If (class ~= "Progman|WorkerW")
		Return "desktop" ; desktop found
}

ShellNavigate(sPath, bExplore = False, hWnd=0)
{
	If (window := Explorer_GetWindow(hwnd))
	{
		if !InStr(sPath, "#")  ; 排除特殊文件名
		{
			window.Navigate2(sPath) ; 当前资源管理器窗口切换到指定目录
		}
		else ; https://www.autohotkey.com/boards/viewtopic.php?f=5&t=526&p=153676#p153676
		{
			DllCall("shell32\SHParseDisplayName", WStr, sPath, Ptr,0, PtrP, vPIDL, UInt, 0, Ptr, 0)
			VarSetCapacity(SAFEARRAY, A_PtrSize=8?32:24, 0)
			NumPut(1, SAFEARRAY, 0, "UShort") ;cDims
			NumPut(1, SAFEARRAY, 4, "UInt") ;cbElements
			NumPut(vPIDL, SAFEARRAY, A_PtrSize=8?16:12, "Ptr") ;pvData
			NumPut(DllCall("shell32\ILGetSize", Ptr, vPIDL, UInt), SAFEARRAY, A_PtrSize=8?24:16, "Int") ;rgsabound[1]
			window.Navigate2(ComObject(0x2011, &SAFEARRAY))
			DllCall("shell32\ILFree", Ptr, vPIDL)
		}
	}
	Else If bExplore
		ComObjCreate("Shell.Application").Explore[sPath]  ; 新窗口打开目录(带左侧导航SysTreeView321控件)
	Else ComObjCreate("Shell.Application").Open[sPath]  ; 新窗口打开目录
}

CF_Isinteger(ByRef hNumber){
	if hNumber is integer
	{
		hNumber := Round(hNumber)
		return true
	}
}

CF_IsFolder(sfile){
	if InStr(FileExist(sfile), "D")
	|| (sfile = """::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
	;|| (SubStr(sfile, 1, 2) = "\\")   ; 局域网共享文件夹 如 \\Win11\Soft
		return 1
	else
		return 0
}

; 解析用户、系统环境变量
; ppath 为 不带引号的文本或百分号包围的文本
ExpandEnvVars(ppath)
{
	VarSetCapacity(dest, 2000)
	DllCall("ExpandEnvironmentStrings", "str", ppath, "str", dest, int, 1999, "Cdecl int")
	Return dest
}

IsDialog(window=0)
{
	result:=0
	If(window)
		window := "ahk_id " window
	Else
		window:="A"
	WinGetClass, wc, %window%
	If(wc = "#32770")
	{
		;Check for new FileOpen dialog
		ControlGet, hwnd, Hwnd, , DirectUIHWND3, %window%
		If(hwnd)
		{
			ControlGet, hwnd, Hwnd, , SysTreeView321, %window%
			If(hwnd)
			{
				ControlGet, hwnd, Hwnd, , Edit1, %window%
				If(hwnd)
				{
					ControlGet, hwnd, Hwnd, , Button2, %window%
					If(hwnd)
					{
						ControlGet, hwnd, Hwnd, , ComboBox2, %window%
						If(hwnd)
						{
						ControlGet, hwnd, Hwnd, , ToolBarWindow323, %window%
						If(hwnd)
							result := 1
						}
					}
				}
			}
		}
		;Check for old FileOpen dialog
		If(!result)
		{
			ControlGet, hwnd, Hwnd, , ToolbarWindow321, %window%          ;工具栏
			If(hwnd)
			{
				ControlGet, hwnd, Hwnd, , SysListView321, %window%        ;文件列表
				If(hwnd)
				{
					ControlGet, hwnd, Hwnd, , ComboBox3, %window%         ;文件类型下拉选择框
					If(hwnd)
					{
						ControlGet, hwnd, Hwnd, , Button3, %window%       ;取消按钮
						If(hwnd)
						{
							;ControlGet, hwnd, Hwnd , , SysHeader321 , %window%    ;详细视图的列标题
							ControlGet, hwnd, Hwnd, , ToolBarWindow322, %window%  ;左侧导航栏
							If(hwnd)
								result := 2
						}
					}
				}
			}
		}
	}
	Return result
}