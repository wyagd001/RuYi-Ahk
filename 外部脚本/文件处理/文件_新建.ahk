q::
return

新建文件夹:
IfWinActive, ahk_group Prew_Group
{
	if WinActive("ahk_class TTOTAL_CMD")
	{
		ActPath := TC_CurrTPath()
		TextTranslated := TranslateMUI("shell32.dll", 16888)  ; "新建文件夹"
		newFolder := PathU(ActPath "\" TextTranslated)
		FileCreateDir % newFolder
		TC_SendMsg(540)
	}
	Else If !IsRenaming()   ; win 7 以上系统自带的新建文件夹的快捷键
		Send ^+n
}
Return

新建文本文档:
IfWinActive, ahk_group Prew_Group
{
	if WinActive("ahk_class TTOTAL_CMD")
	{
		ActPath := TC_CurrTPath()
		TextTranslated := TranslateMUI("shell32.dll", 16888)  ; "新建文件夹"
		newFolder := PathU(ActPath "\" TextTranslated)
		FileCreateDir % newFolder
		TC_SendMsg(540)
		Return
	}
	if !IsRenaming()
		CreateNewTextFile()
}
return

; Explorer Windows Manipulations - Sean
; http://www.autohotkey.com/forum/topic20701.html
; 7plus - fragman
; http://code.google.com/p/7plus/
; https://github.com/7plus/7plus
TC_CurrTPath() ; 返回当前路径栏控件文本
{
	DetectHiddenText, On
	WinGetText, TCWindowText, Ahk_class TTOTAL_CMD
	RegExMatch(TCWindowText, "(.*)>", TCPath)
	return TCPath1
}

TranslateMUI(resDll, resID)
{
VarSetCapacity(buf, 256)
hDll := DllCall("LoadLibrary", "str", resDll, "Ptr")
Result := DllCall("LoadString", "uint", hDll, "uint", resID, "uint", &buf, "int", 128)
VarSetCapacity(buf, -1)
Return buf
}

IsRenaming()
{
	ControlGetFocus focussed, A ; 获取到的控件为 Edit1
	If(WinActive("ahk_class CabinetWClass")) ;Explorer
	{
		If(strStartsWith(focussed, "Edit"))
		{
			; Win 10 中有可能是 DirectUIHWND2 或 DirectUIHWND3
			ControlGetPos , X, Y, Width, Height,DirectUIHWND3, A
			if !X
				ControlGetPos , X, Y, Width, Height,DirectUIHWND2, A
			ControlGetPos , X1, Y1, Width1, Height1, %focussed%, A
			If(IsInArea(X1, Y1, X, Y, Width, Height) && IsInArea(X1+Width1, Y1, X, Y, Width, Height) && IsInArea(X1,Y1+Height1, X, Y, Width, Height) && IsInArea(X1+Width1,Y1+Height1, X, Y, Width, Height))
				Return true
		}
	}
	Else If (WinActive("ahk_class Progman") or WinActive("ahk_class WorkerW")) ;Desktop
	{
		If(focussed = "Edit1")
			Return true
	}
	Else If((x := IsDialog())) ;FileDialogs
	{
		If(strStartsWith(focussed, "Edit1"))
		{
			;figure out If the the edit control is inside the DirectUIHWND2 or SysListView321
			If(x=1 && Vista7) ;New Dialogs
				ControlGetPos , X, Y, Width, Height, DirectUIHWND2, A
			Else ;Old Dialogs
				ControlGetPos , X, Y, Width, Height, SysListView321, A
			ControlGetPos , X1, Y1, Width1, Height1, %focussed%, A
			If(IsInArea(X1, Y1, X, Y, Width, Height)&&IsInArea(X1+Width1, Y1, X, Y, Width, Height)&&IsInArea(X1, Y1+Height1, X, Y, Width, Height)&&IsInArea(X1+Width1, Y1+Height1, X, Y, Width, Height))
				Return true
		}
	}
	Else If (WinActive("ahk_class EVERYTHING")) ; EVERYTHING
	{
		If(focussed="Edit1")
		{
			;tooltip 123
			Return true
		}
	}
	Return false
}

strStartsWith(string,start)
{
	x:=(strlen(start)<=strlen(string)&&Substr(string,1,strlen(start))=start)
	Return x
}

IsInArea(px,py,x,y,w,h)
{
	Return (px>x&&py>y&&px<x+w&&py<y+h)
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

PathU(Filename) { ;  PathU v0.91 by SKAN on D35E/D68M @ tiny.cc/pathu
Local OutFile
  VarSetCapacity(OutFile, 520)
  DllCall("Kernel32\GetFullPathNameW", "WStr",Filename, "UInt",260, "Str",OutFile, "Ptr",0)
  DllCall("Shell32\PathYetAnotherMakeUniqueName", "Str",OutFile, "Str",Outfile, "Ptr",0, "Ptr",0)
Return A_IsUnicode ? OutFile : StrGet(&OutFile, "UTF-16")
}

TC_SendMsg(n)  ; WM_USER+51 = 1075
{
	Return CF_SendMessage(1075, n, 0, , "Ahk_class TTOTAL_CMD")
}

CF_SendMessage(Msg, wParam := 0, lParam := 0, Control := "", WinTitle := "A"){
	SendMessage, % Msg, % wParam, % lParam, %control%, %WinTitle%
	return ErrorLevel
}

SelectFiles(Select,Clear=1,Deselect=0,MakeVisible=1,focus=1, hWnd=0)
{
	If (window := Explorer_GetWindow(hwnd)) && (window != "desktop")
	{
		SplitPath, Select, Select ;Make sure only names are used
		doc:=window.Document
		value:=!(Deselect = 1)
		value1:=!(Deselect = 1)+(focus = 1)*16+(MakeVisible = 1)*8
		count := doc.Folder.Items.Count
		If(Clear = 1)
		{
			If(count > 0)
			{
				item := doc.Folder.Items.Item(0)
				doc.SelectItem(item, 4)
				doc.SelectItem(item, 0)
			}
		}
		If(!IsObject(Select))
			Select := ToArray(Select)
		items := Array()
		itemnames := Array()
		Loop % count
		{
			index := A_Index
			while(true)
			{
				item := doc.Folder.Items.Item(index - 1)
				itemname := item.Name
				If(itemname != "")
				{
					; outputdebug itemname %itemname%
				break
				}
				Sleep 10
			}
			items.Push(item)
			itemnames.Push(itemname)
		}
		ererer:=Select.Length()
		Loop % Select.Length()
		{
			index := A_Index
			filter := Select[A_Index]
			If(filter)
			{
				If(InStr(filter, "*"))
				{
					filter := "\Q" CF_StringReplace(filter, "*", "\E.*\Q", 1) "\E"
					filter := strTrim(filter,"\Q\E")
					Loop % items.Length()
					{
						If(RegexMatch(itemnames[A_Index],"i)" filter))
						{
							doc.SelectItem(items[A_Index], index=1 ? value1 : value)
							index++
						}
					}
				}
				Else
				{
					Loop % items.Length()
					{
						If(itemnames[A_Index]=filter)
						{
							doc.SelectItem(items[A_Index], index=1 ? value1 : value)
							index++
						break
						}
					}
				}
			}
		}
		Return
	}
	Else If(window = "desktop")
	{
		SplitPath, Select,,,, Select
		SendStr(Select)  ; A版，U版兼容
		; _SendRaw(Select)  ; A版
	}
}

RefreshExplorer()
{ ; by teadrinker on D437 @ tiny.cc/refreshexplorer
	local Windows := ComObjCreate("Shell.Application").Windows
	Windows.Item(ComObject(0x13, 8)).Refresh()
	for Window in Windows
		if (Window.Name != "Internet Explorer")
			Window.Refresh()
	Else If(IsDialog())
	{
		WinGet, w_WinIDs, List, ahk_class #32770
		Loop, %w_WinIDs%
		{
			w_WinID := w_WinIDs%A_Index%
			ControlGet, w_CtrID, Hwnd,, SHELLDLL_DefView1, ahk_id %w_WinID%
			ControlGet, w_CtrID, Hwnd,, SHELLDLL_DefView1, ahk_id %w_WinID%
			ControlClick, DirectUIHWND2, ahk_id %w_WinID%,,,, NA x1 y30
			SendMessage, 0x111, 0x7103,,, ahk_id %w_CtrID%
		}
	}
	Else
		Send {F5}
}

SetFocusToFileView()
{
	If (WinActive("ahk_class CabinetWClass"))
	{
			ControlGetFocus focussed, A
			if (focussed = "DirectUIHWND2")
				ControlFocus DirectUIHWND2, A
			else
				ControlFocus DirectUIHWND3, A
	}
	Else If((x:=IsDialog())=1) ; New Dialogs
	{
			ControlFocus DirectUIHWND2, A
	}
	Else If(x=2) ; Old Dialogs
	{
		ControlFocus SysListView321, A
	}
	Return
}

CreateNewTextFile(CurrentFolder)
{
	; This is done manually, by creating a text file with the translated name, which is then focussed
	SetFocusToFileView()
	TextTranslated := TranslateMUI("notepad.exe",470) ; "New Textfile"
	if (CurrentFolder = "")
		CurrentFolder := GetCurrentFolder()
	If (CurrentFolder = 0)
		Return
	Testpath := CurrentFolder "\" TextTranslated "." txt
	i:=1 ;Find free filename
	while FileExist(TestPath)
	{
		i++
		Testpath:=CurrentFolder "\" TextTranslated " (" i ")." txt
	}
	FileAppend,, %TestPath%, UTF-8	;Create file and then select it and rename it
	If ErrorLevel
	{
    TrayTip,错误,新建文本文档出错,3
	Return
	}
	RefreshExplorer()
	Sleep 500
	SelectFiles(TestPath)
	Sleep 50
	Send {F2}
	Return
}

GetCurrentFolder()
{
	global newfolder
	newfolder =
	If WinActive("ahk_group ccc")
	{
		isdg := IsDialog()
		If (isdg = 0)
			Return ShellFolder(, 1)
		Else If (isdg = 1) ; No Support for old dialogs for now
		{
			ControlGetText, text, ToolBarWindow322, A
			dgpath := SubStr(text, InStr(text, " "))
			dgpath = %dgpath%
			Return dgpath
		}
		Else If (isdg = 2)
		{
			newfolder = types2
			Return 0
		}
	}
	Return 0
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

ToArray(SourceFiles, ByRef Separator = "`n", ByRef wasQuoted = 0)
{
	files := Array()
	pos := 1
	wasQuoted := 0
	Loop
	{
		If(pos > strlen(SourceFiles))
			break
			
		char := SubStr(SourceFiles, pos, 1)
		If(char = """" || wasQuoted) ; Quoted paths
		{
			file := SubStr(SourceFiles, InStr(SourceFiles, """", 0, pos) + 1, InStr(SourceFiles, """", 0, pos + 1) - pos - 1)
			If(!wasQuoted)
			{
				wasQuoted := 1
				Separator := SubStr(SourceFiles, InStr(SourceFiles, """", 0, pos + 1) + 1, InStr(SourceFiles, """", 0, InStr(SourceFiles, """", 0, pos + 1) + 1) - InStr(SourceFiles, """", 0, pos + 1) - 1)
			}
			If(file)
			{
				files.Push(file)
				pos += strlen(file) + 3
				continue
			}
			Else
				Msgbox Invalid source format %SourceFiles%
		}
		Else
		{
			file := SubStr(SourceFiles, pos, max(InStr(SourceFiles, Separator, 0, pos + 1) - pos, 0)) ; separator
			If(!file)
				file := SubStr(SourceFiles, pos) ; no quotes or separators, single file
			If(file)
			{
				files.Push(file)
				pos += strlen(file) + strlen(Separator)
				continue
			}
			Else
				Msgbox Invalid source format
		}
		pos++ ;Shouldn't happen
	}
	Return files
}

CF_StringReplace(InputVar, SearchText, ReplaceText = "", All = "") {
	StringReplace, v, InputVar, %SearchText%, %ReplaceText%, %All%
	Return, v
}

strTrim(string, trim)
{
	Return strTrimLeft(strTrimRight(string,trim),trim)
}

; http://www.ahkcn.net/thread-5385.html
; 发送中文，避免输入法影响
SendStr(String)
{
	if(A_IsUnicode)
	{
		Loop, Parse, String
			ascString .= (Asc(A_loopfield)>127 )? A_LoopField : "{ASC 0" . Asc(A_loopfield) . "}"
	}
	else     ;如果非Unicode
	{
		z:=0
		Loop,parse,String
		{
			if RegExMatch(A_LoopField, "[^x00-xff]")
			{
				if (z=1)
				{
					x<<= 8
					x+=Asc(A_loopfield)
					z:=0
					ascString .="{ASC 0" . x . "}"
				}
				else
				{
					x:=asc(A_loopfield)
					z:=1
				}
			}
			else
			{
				ascString .="{ASC 0" . Asc(A_loopfield) . "}"
			}
		}
	}
	SendInput %ascString%
}

strTrimRight(string,trim)
{
	len:=strLen(trim)
	If(strEndsWith(string,trim))
	{
		StringTrimRight, string, string, %len%
	}
	Return string
}

strTrimLeft(string,trim)
{
	len:=strLen(trim)
	while(strStartsWith(string,trim))
	{
		StringTrimLeft, string, string, %len%
	}
	Return string
}

strEndsWith(string,end)
{
	Return strlen(end)<=strlen(string) && Substr(string,-strlen(end)+1)=end
}