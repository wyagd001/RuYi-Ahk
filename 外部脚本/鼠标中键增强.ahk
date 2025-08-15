;|2.6|2024.05.05|1596
Windy_CurWin_id := A_Args[1]
;qt := QtTabBar()
qt := 1 ; 未安装 QT 时, QT 值可设为 0, 资源管理器中键文件夹打开新窗口
gosub $MButton
return

$MButton::
CoordMode, Mouse, Screen
MouseGetPos, lastx, lasty, UID, ClassNN ; 获取指针下窗口的 ID 和控件的 ClassNN
WinGetClass, 窗口类, ahk_id %UID% ; 根据 ID 获得窗口类名
WinExist("ahk_id " UID)
ControlGetText, OutputText, %ClassNN%
; 任务栏自动关闭窗口
If (窗口类 = "Shell_TrayWnd") ; 指针是否在任务栏上
{
	KeyIsDown := GetKeyState("Capslock" , "T")
	if KeyIsDown
	{
		Send {MButton}
	Return
	}
	else
	{
		If instr(ClassNN, "ToolbarWindow32") ; 指针是否在托盘图标上
		{
			if instr(OutputText, "通知区域")
			{
				SendEvent,{click, Right}
				SendEvent,{Up}{enter} ; 如果是在托盘区上，为关闭选择的程序
				return
			}
		}
		Else ; 指针在任务栏窗口按钮上
		{
			wID := TE_GetTaskID()
			;tooltip % wID "--121212"
			PostMessage, 0x112, 0xF060,,, ahk_id %wID%
			return
		}
	}
}
else if (窗口类 = "CabinetWClass") && IsMouseOverFileList() && !qt  ; QT 设置里可设置中键文件夹的动作
{
	SendEvent {LButton}
	Sleep 100
	undermouse := GetSelectedFiles()
	if undermouse
	{
		if CF_IsFolder(undermouse)
			Isdir :=true
		else
			Isdir :=false
		if (Isdir)
			run explorer.exe %undermouse%  ; 安装使用 qttabbar 后为新窗口打开文件夹
		else
			run %undermouse% ; 选中文件直接运行
		return
	}
}

; 窗口标题栏上为关闭窗口, 未激活窗口先点击激活
send {click}
CoordMode, Mouse, Window 
WinGetPos , , , Width,, A  
MouseGetPos, 窗口x坐标, 窗口y坐标
If (窗口y坐标 <= 28) && (窗口y坐标 >= -1) && (窗口x坐标 >= -1) && (窗口x坐标 <= Width) ; 指针是否在窗口标题栏
{
	; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
	PostMessage, 0x112, 0xF060,,, A   ; 如果是在窗口标题栏上中键，为关闭窗口，不管这个窗口是在顶层还是底层
	return
}
return

TE_GetTaskID()
{
	global lastx, lasty
	WinID :=
	flag := 0
	
	WinGetPos,,, taskbarW, taskbarH, ahk_class Shell_TrayWnd
	ControlGet, hWnd, Hwnd,, MSTaskListWClass1, ahk_class Shell_TrayWnd
	TaskList := TE_AccessibleObjectFromWindow(hWnd)
	Loop, % TaskList.accChildCount
	{
		wTitle := TaskList.accName(A_Index)  ;  任务栏按钮窗口的标题
		TaskList.accLocation(ComObjParameter(0x4003, &L:=0), ComObjParameter(0x4003, &T:=0)
			, ComObjParameter(0x4003, &W:=0), ComObjParameter(0x4003, &H:=0)
			, A_Index) 
		
		bL := NumGet(L), bT := NumGet(T), bW := NumGet(W), bH := NumGet(H)
		if (taskbarW > taskbarH) {
			S := bL
			E := bL + bW
			P := lastx
		}
		else {
			S := bT
			E := bT + bH
			P := lasty
		}
		;msgbox % S "<" P "<" E
		if (S < P && P < E) {
			SetTitleMatchMode, 3
			if (A_OSversion != "Win_7")  ; Win 10 任务栏按钮标题 带有 " - 1 个窗口" 字样,  win7 系统不带
				wTitle := substr(wTitle, 1, instr(wTitle, " - ",, 0) - 1)
			;msgbox % wTitle
			WinGet, list, List, % wTitle
			Loop, %list%
			{
				tooltip % wTitle
				wID := list%A_Index%
				;msgbox % wID
				WinGet, uStyle, Style, ahk_id %wID%
				if (!(uStyle&0x08000000)
				&& (!(uStyle&0x80000000) || ((uStyle&0x30000000)=0x30000000) || (uStyle&0x80) || (uStyle&0x00C00000)))
				{
					;msgbox % wID
					WinID := wID
					flag++
				}
			}
			if (flag)
				break
		}
		
	}
	
	if (flag = 1)
		return WinID
	else
		return 
}

TE_AccessibleObjectFromWindow(Hwnd) 
{ 
	global 
	VarSetCapacity(IID, 16) 
	NumPut(0x11CF3C3D618736E0, IID, 0, "Int64") 
	NumPut(0x719B3800AA000C81, IID, 8, "Int64") 
	DllCall("LoadLibrary","Str","Oleacc") 
	DllCall("Oleacc\AccessibleObjectFromWindow", "Ptr", Hwnd, "UInt", -4, "Ptr", &IID, "Ptr*", ppvObject)
	Return, ComObjEnwrap(ppvObject) 
}

QtTabBar()
{
	try QtTabBarObj := ComObjCreate("QTTabBarLib.Scripting")
	if IsObject(QtTabBarObj)
	return 1
	else
	return 0
}

IsMouseOverFileList()
{
	CoordMode, Mouse, Relative
	MouseGetPos, MouseX, MouseY, Window, UnderMouse
	WinGetClass, winclass, ahk_id %Window%
	If (winclass="CabinetWClass" || winclass="ExploreWClass") ; Win7/10 Explorer
	{
		ControlGetFocus focussed, A
		if (focussed = "DirectUIHWND2")
			ControlGetPos, cX, cY, Width, Height, DirectUIHWND2, A
		else
			ControlGetPos, cX, cY, Width, Height, DirectUIHWND3, A
		If(IsInArea(MouseX, MouseY, cX, cY, Width, Height))
			Return true
	}
	Return false
}

IsInArea(px,py,x,y,w,h)
{
	Return (px>x&&py>y&&px<x+w&&py<y+h)
}

GetSelectedFiles(FullName=1, hwnd=0)
{
	If(!hwnd)
		hWnd := WinExist("A")
	If FullName
		Return ShellFolder(hwnd, 3)
	Else
		Return ShellFolder(hwnd, 3, 1)
}

Explorer_GetWindow(hwnd="")
{
	static shell := ComObjCreate("Shell.Application")
	; thanks to jethrow for some pointers here
	WinGet, process, processName, % "ahk_id " hwnd := (hwnd ? hwnd : WinExist("A"))
	WinGet, OutputVar, ProcessPath, % "ahk_id " hwnd := (hwnd ? hwnd : WinExist("A"))
	WinGetClass class, ahk_id %hwnd%
	;msgbox % process " - " class " - " hwnd
	; 因为 Bug 取消下面的判断
	;If (process!="explorer.exe")
		;Return
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
	{
		;SWC_DESKTOP := 0x8 ;VT_BYREF := 0x4000 ;VT_I4 := 0x3 ;SWFO_NEEDDISPATCH := 0x1
		VarSetCapacity(AhWnd, 4, 0)
		window := shell.Windows.FindWindowSW(0, "", 8, ComObject(0x4003, &AhWnd), 1)
		Return window
	}
}

/*
Returntype=1 当前文件夹
Returntype=2 具有焦点的选中项
Returntype=3 所有选中项
Returntype=4 当前文件夹下所有项目
*/
ShellFolder(hWnd=0, returntype=1, onlyname=0)
{
	
	If !(window := Explorer_GetWindow(hwnd))
	{
		;msgbox % hwnd
		Return 0
	}

	doc := window.Document
	If (returntype = 1)
	{
		sFolder := doc.Folder.Self.path
		if !sFolder
			return A_Desktop
		If onlyname
			sFolder := doc.Folder.Self.name
		return sFolder
	}
	If (returntype = 2)
	{
		sFocus :=doc.FocusedItem.Path
		If onlyname
			SplitPath, sFocus, sFocus
		Return sFocus
	}
	If(returntype = 3)
	{
		collection := doc.SelectedItems
		for item in collection
		{
			hpath :=  item.path
			If onlyname
				SplitPath, hpath, hpath
			sSelect .= hpath "`n"
		}
		
		StringReplace, sSelect, sSelect, \\ , \, 1
		sSelect:=Trim(sSelect, "`n")
		Return sSelect
	}
	If(returntype = 4)
	{
		collection := doc.Folder.Items
		for item in collection
		{
			hpath :=  item.path
			If onlyname
				SplitPath, hpath, hpath
			AllFiles .= hpath "`n"
		}
		AllFiles := Trim(AllFiles, "`n")
		Return AllFiles
	}
}