;|2.8|2024.09.03|1330
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?t=92366
#SingleInstance, Ignore
StickyNotesFolder := A_ScriptDir "\..\..\配置文件\外部脚本\ahk_note"
if !FileExist(StickyNotesFolder)
  FileCreateDir, % StickyNotesFolder
StickyNotesIni := StickyNotesFolder . "\Sticky Notes.ini"

if !FileExist(StickyNotesIni)
{
	Settings := "
(
[StickyNotes]

[Settings]
EditColor=0xFFFFFF
TextColor=0x000000
AutomaticTextColor=1
ShowOnStartup=1
AutoSave=1
DarkMode=0
Password=0
Passcode=
Color1=0
Color2=0
Color3=0
Color4=0
Color5=0
Color6=0
Color7=0
Color8=0
Color9=0
Color10=0
Color11=0
Color12=0
Color13=0
Color14=0
Color15=0
Color16=0
)"
	FileAppend, %Settings%, %StickyNotesIni%
}

IniRead, EditC, %StickyNotesIni%, Settings, EditColor
IniRead, TextC, %StickyNotesIni%, Settings, TextColor
IniRead, ATC, %StickyNotesIni%, Settings, AutomaticTextColor
IniRead, StartupShow, %StickyNotesIni%, Settings, ShowOnStartup
IniRead, AutoS, %StickyNotesIni%, Settings, AutoSave
IniRead, DarkMode, %StickyNotesIni%, Settings, DarkMode
IniRead, Password, %StickyNotesIni%, Settings, Password
IniRead, Passcode, %StickyNotesIni%, Settings, Passcode
IniRead, TabCheckRead, %StickyNotesIni%, StickyNotes, TabNames

if (TabCheckRead = "ERROR")    ;  没有配置文件
{
	TNames := "Untitled"
	Gui, Add, Tab3, hwndtab vcurrentTab, %TNames% 
	Gui, Add, Edit, w300 h200 gAutoSave c%TextC% vEditText1
}
else
{
	IniRead, TNames, %StickyNotesIni%, StickyNotes, TabNames
	Gui, Add, Tab3, hwndtab vcurrentTab, %TNames%
	tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
	Loop, Parse, TNames, |
	{
		Gui, Tab, %A_Index%
    if (A_LoopField != "")
    {
      FileRead, EditVar, % StickyNotesFolder "\" A_LoopField
      Gui, Add, Edit, w300 h200 gAutoSave c%TextC% vEditText%A_Index%, %EditVar%
      EditPut := ""
    }
	}
}
Gui, Color, , %EditC%
Gui, Tab
Gui, Add, Button, gSave, 保存
Gui, Add, Button, gNew x+5, 新建
Gui, Add, Button, gDelete x+5, 删除
Gui, Add, Button, gChangeName x+5, 重命名
Gui, Add, Button, gAddFiles x+5, 🔺
Gui, Add, Button, gSettings x+5, ⚙
Gui, Add, CheckBox, gAOT x+5 yp+5, AOT
if (StartupShow = 1)
	GoSub, PasscodeCheckEnter
Gui, +HwndSN
Gui, New, , Settings
Gui, Settings:Add, Text, x10 y10 w50 h20, Edit Color
Gui, Settings:Add, Edit, x10 y30 w80 h20 gEditColor vEditColor, %EditC%
Gui, Settings:Add, Button, x+5 y29 w20 gChooseColorEdit, 🖌
Gui, Settings:Add, ListView, x120 y30 w20 h20 +Background%EditC%
Gui, Settings:Add, Text, x10 y60 w50 h20, Text Color
Gui, Settings:Add, Edit, x10 y80 w80 h20 gTextColor vTextColor Disabled%ATC%, %TextC%
Gui, Settings:Add, Button, x+5 y79 w20 gChooseColorText Disabled%ATC%, 🖌
Gui, Settings:Add, ListView, x120 y80 w20 h20 +Background%TextC%
Gui, Settings:Add, CheckBox, x10 +Checked%ATC% gATColor vATColor, Automatic Text Color
Gui, Settings:Add, CheckBox, +Checked%StartupShow% vSoS, Show on Startup
Gui, Settings:Add, CheckBox, +Checked%AutoS% vAS, AutoSave
Gui, Settings:Add, CheckBox, +Checked%DarkMode% gDM vDM, Dark Mode
Gui, Settings:Add, CheckBox, +Checked%Password% gPW vPW w200, Password
Gui, Settings:Add, Edit, Password w120 vPC, %Passcode%
GuiControl, Settings:Enable%Password%, Edit3
Gui, Settings:Add, Button, gApply, Apply
Gui, Settings:+ToolWindow +Owner
Col:=0xFF0000
CColors:=Object()
Loop 16
{
	IniRead, Color%A_Index%, %StickyNotesIni%, Settings, Color%A_Index%
	CColors.Insert(Color%A_Index%)
}
return

Apply:
Gui, Settings:Submit, NoHide
if (PW = 1)
{
	InputBox, PasscodeCheck, Input your password, Input the password to confirm
	if (PasscodeCheck == Passcode)
	{
		Gui, Settings:Submit
		Gui, 1:Default
		tcount := DllCall("SendMessage", "UInt", tab, "UInt", 0x1304, Int, 0, Int, 0)
		Loop, %tcount%
		{
			Gui, Tab, %A_Index%
			Gui, Color, , %EditColor%
			GuiControl, +c%TextColor%, Edit%A_Index%
		}
		IniWrite, %EditColor%, %StickyNotesIni%, Settings, EditColor
		IniWrite, %TextColor%, %StickyNotesIni%, Settings, TextColor
		IniWrite, %ATColor%, %StickyNotesIni%, Settings, AutomaticTextColor
		IniWrite, %SoS%, %StickyNotesIni%, Settings, ShowOnStartup
		IniWrite, %SoS%, %StickyNotesIni%, Settings, ShowOnStartup
		IniWrite, %DM%, %StickyNotesIni%, Settings, DarkMode
		IniWrite, %PW%, %StickyNotesIni%, Settings, Password
		IniWrite, %PC%, %StickyNotesIni%, Settings, Passcode
		Password := PW = 0 ? 0 : 1
	}
	else
	{
		ToolTipTimer("Password was not the same, try again`n" PasscodeCheck " - " Passcode, 2000)
		return
	}
}
return

PW:
Gui, Submit, NoHide
if (PW = 1)
{
	GuiControl, Enable, Edit3
	ToolTipTimer("Remember this password", 2000)
}
if (PW = 0)
{
	if (Passcode = "")
	{
		GuiControl, Settings:Disable, Edit3
		GuiControl, Settings:Text, Edit3
	}
	else
	{
		InputBox, PasswordCheck, Input your password, You must input your password first (Case Sensitive)
		if (PasswordCheck == Passcode)
		{
			GuiControl, Settings:Disable, Edit3
			GuiControl, Settings:Text, Edit3
		}
		else
		{
			GuiControl, Settings:, Button7, 1
			GuiControl, Settings:Text, Button7, Password is incorrect
			Sleep, 1000
			GuiControl, Settings:Text, Button7, Password
		}
	}
	
	
}
return

DM:
Gui, Submit, NoHide
GuiControl, Settings:Disable%DM%, Edit1
GuiControl, Settings:Disable%DM%, Button1
GuiControl, Settings:Disable%DM%, Edit2
GuiControl, Settings:Disable%DM%, Button2
GuiControl, Settings:Disable%DM%, Button3
GuiControl, Settings:Text, Edit1, % DM = 1 ? 0x1A1A1B : 0xFFFFFF
Goto, ATColor
return

ATColor:
Gui, Submit, NoHide
GuiControl, Settings:Disable%ATColor%, Edit2
GuiControl, Settings:Disable%ATColor%, Button2
if (ATColor = 1)
	TextColor := HexDec(EditColor) < 8355711 ? 0xFFFFFF : 0x000000
GuiControl, Settings:Text, Edit2, %TextColor%
GuiControl, Settings:+Background%TextColor%, SysListView322
return

ChooseColorEdit:
ChooseColorText:
if (ChooseColor(Col,CColors)=1)
{
	Loop, 16
		IniWrite, % CColors[A_Index], %StickyNotesIni%, Settings, Color%A_Index%
	SetFormat, Integer, H
	Color := BGRtoRGB(Col)
	SetFormat, Integer, D
	GuiControl, Settings:+Background%Color%, SysListView321
	GuiControl, Settings:Text, % A_ThisLabel = "ChooseColorEdit" ? "Edit1" : "Edit2", %Color%
}
if (A_ThisLabel = "ChooseColorEdit")
	Goto, ATColor
else
{
	GuiControlGet, colorcheck, Settings: , Edit1
	GuiControl, Settings:+Background%colorcheck%, SysListView321
}
return

EditColor:
TextColor:
Gui, Submit, NoHide
tempvar := %A_ThisLabel%
GuiControl, Settings:+Background%tempvar%, % A_ThisLabel = "EditColor" ? "SysListView321" : "SysListView322"
if (A_ThisLabel = "EditColor")
	Goto, ATColor
return

Settings:
GuiControlGet, CheckifAOT, , Button7
WinGetPos, SnX, SnY, , , ahk_id %SN%
SnX += 70, SnY += 15
Gui, Settings:Show, x%SnX% y%SnY%, Settings
if CheckifAOT
	Gui, Settings:+AlwaysOnTop
return

AOT:
Winset, AlwaysOnTop, Toggle
return

AutoSave:
;ControlGet, CurrentTabName, Tab, , SysTabControl321, A
;Gui, Show, , *Sticky Notes
if (AutoS = 1)
	SetTimer, Save, -60000
return

$^s::
if (WinActive("ahk_id" SN))
	Goto, Save
else
	Send, ^s
return

guiclose:
exitapp

Save:    ; 保存所有
ControlGet, CurrentTabName, Tab, , SysTabControl321, A   ; 当前序号
tcount := TAB_GetItemCount(Tab)
/*
Loop, %tcount%
{
	GuiControl, Choose, SysTabControl321, %A_Index%
	Gui, Submit, NoHide
	GuiControlGet, Edit, , Edit%A_Index%

	TabNames .= currentTab "|"
	file:=FileOpen(StickyNotesFolder "\" currentTab,"w"), file.Write(Edit), file.Close()
}
*/
Gui, Submit, NoHide
TabNames := ""
Loop, %tcount%
{
  currentTab := TAB_GetText(Tab, A_Index)
  TabNames .= currentTab "|"
  file := FileOpen(StickyNotesFolder "\" currentTab, "w"), file.Write(EditText%A_Index%), file.Close()
}
IniWrite, %TabNames%, %StickyNotesIni%, StickyNotes, TabNames
TabNames := ""
GuiControl, Choose, SysTabControl321, %CurrentTabName%
Gui, Show, NoActivate, Sticky Notes
return

TAB_GetItemCount(hTab)
    {
    Static TCM_GETITEMCOUNT:=0x1304                     ;-- TCM_FIRST + 4
    SendMessage TCM_GETITEMCOUNT,0,0,,ahk_id %hTab%
    Return ErrorLevel="FAIL" ? 0:ErrorLevel
    }

TAB_GetText(hTab,iTab)
    {
    Static Dummy18408860
          ,MAX_TEXT:=512  ;-- Size in TCHARS

          ;-- Mask
          ,TCIF_TEXT      :=0x1
          ,TCIF_IMAGE     :=0x2
          ,TCIF_PARAM     :=0x8
          ,TCIF_RTLREADING:=0x4
          ,TCIF_STATE     :=0x10

          ;-- Messages
          ,TCM_GETITEMA:=0x1305                         ;-- TCM_FIRST + 5
          ,TCM_GETITEMW:=0x133C                         ;-- TCM_FIRST + 60

    VarSetCapacity(TCITEM,A_PtrSize=8 ? 40:28,0)
    VarSetCapacity(l_Text,MAX_TEXT*(A_IsUnicode ? 2:1),0)
    NumPut(TCIF_TEXT,TCITEM,0,"UInt")                   ;-- mask
    NumPut(&l_Text,  TCITEM,A_PtrSize=8 ? 16:12,"Ptr")  ;-- pszText
    NumPut(MAX_TEXT, TCITEM,A_PtrSize=8 ? 24:16,"Int")  ;-- cchTextMax
    SendMessage A_IsUnicode ? TCM_GETITEMW:TCM_GETITEMA,iTab-1,&TCITEM,,ahk_id %hTab%
    VarSetCapacity(l_Text,-1)
    Return l_Text
    }

New:
newf := newnote()
GuiControl,, SysTabControl321, % newf   ; 新增1标签
tcount := TAB_GetItemCount(Tab)
;msgbox % tcount
Gui, Tab, %tcount%
Gui, Add, Edit, w300 h200 gAutoSave c%TextC% vEditText%tcount%
return

newnote()
{
  global StickyNotesFolder
  Loop
    f:=Format("{:03d}.txt", A_Index)
  Until !FileExist(StickyNotesFolder "\" f)
  ;FileAppend,, % StickyNotesFolder "\" f
  return f
}
return

Delete:
Gui, +OwnDialogs
tcount := TAB_GetItemCount(Tab)  ; 总标签页数目
if (tcount = 1)
	MsgBox, 48, 抱歉, 您不能删除最后一个便签!
else 
{
  ControlGet, CurrentTabName, Tab, , SysTabControl321, A
  delfileName := TAB_GetText(Tab, CurrentTabName)
	MsgBox, 308, 确认, 您确认要删除选中的便签 %delfileName%, 然后重启吗?
	IfMsgBox, No
		return
	IfMsgBox, Yes
	{
    names := ""
			
		Loop, % tcount
		{
			GuiControl, Choose, SysTabControl321, %A_Index%
			Gui, Submit, NoHide
      if (A_Index != CurrentTabName)
        names .= "|" currentTab
		}
;TAB_DeleteItem(Tab, CurrentTabName)
  while instr(names, "|")=1
  names := substr(names, 2)
  IniWrite, %names%, %StickyNotesIni%, StickyNotes, TabNames
  if delfileName
    FileRecycle % StickyNotesFolder "\" delfileName
  reload
			;GuiControl, Choose, SysTabControl321, %tcount%
			;Gui, Submit, NoHide
			;IniDelete, %StickyNotesIni%, StickyNotes, %currentTab%
;msgbox % currentTab
			;GuiControl, Text, Edit%tcount%
			;GuiControl, , SysTabControl321, %names%    ; ; 删除标签 移除当前选项卡
			;GoSub, Save
			;GuiControl, Choose, SysTabControl321, %CurrentTabName%
			;names := ""
		;}
	}
}
return

ChangeName:
Gui, +OwnDialogs
ControlGet, CurrentTabName, Tab, , SysTabControl321, A
CurrentfileName := TAB_GetText(Tab, CurrentTabName)
InputBox, NewName, Sticky Notes, 请输入新的便签名, , 130, 125
if (NewName = "TabNames")
	MsgBox, 8208, Error, Sorry but you can't use that name, it would interfere with the saving system!
else
	if (ErrorLevel = 0)
	{
		tcount := TAB_GetItemCount(Tab)
TabNames := ""
Loop, %tcount%
{
  currentTab := TAB_GetText(Tab, A_Index)
  TabNames .= "|" currentTab 
}
TabNames  := strreplace(TabNames, CurrentfileName, NewName)
GuiControl, , SysTabControl321, % TabNames
TabNames := ""
FileMove, % StickyNotesFolder "\" CurrentfileName, % StickyNotesFolder "\" NewName
	}
return

AddFiles:
Gui, +OwnDialogs
FileSelectFile, File, 3, C:\Users\%A_UserName%\Downloads, Open a file, ONLY TEXT YOU- (*.txt; *.ahk; *.doc)
GuiDropFiles:
if (A_ThisLabel = "GuiDropFiles")
	File := A_GuiEvent
if (File = "")
	return
else
{
	GoSub, New
	tcount := TAB_GetItemCount(Tab)
	GuiControl, Choose, SysTabControl321, %tcount%
	FileRead, FileInput, %File%
	Gui, Tab, %tcount%
	GuiControl, Text, EditText%tcount%, %FileInput%

TabNames := ""
Loop, %tcount%
{
  currentTab := TAB_GetText(Tab, A_Index)
  TabNames .= "|" currentTab 
}
TabNames := strreplace(TabNames, newf, LTrim(SubStr(File, InStr(File, "\", , , StrAmt(File, "\"))), "\")) 

	GuiControl, , SysTabControl321, %TabNames%
GuiControl, Choose, SysTabControl321, %tcount%
}
return

PasscodeCheckEnter:
F4::
if (Password = 1)
{
	InputBox, PasswordCheck, Input your password, Input your password (Case Sensitive)
	if (ErrorLevel = 1)
		return
	else
	{
		if (PasswordCheck == Passcode)
			Gui, Show, , Sticky Notes
		else
			Goto, PasscodeCheckEnter
	}
}
else
	Gui, Show, , Sticky Notes
return

StrAmt(haystack, needle, casesense := false) {
	StringCaseSense % casesense
	StrReplace(haystack, needle, , Count)
	return Count
}

ChooseColor(ByRef Color, ByRef CustColors, hWnd=0x0, Flags=0x103) { ;DISCLAIMER: This function is not mine, all the credit for this goes to Elgin on the forums, thank you for "borrowing" it to me :) Link: https://autohotkey.com/board/topic/8617-how-to-call-the-standard-choose-color-dialog/
	VarSetCapacity(CC,36+64,0)
	NumPut(36,CC)
	NumPut(hWnd,CC,4)
	NumPut(Color,CC,12)
	Loop 16
		NumPut(CustColors[A_Index],CC,32+A_Index*4)
	NumPut(&CC+36,CC,16)
	NumPut(Flags,CC,20)
	RVal:=DllCall( "comdlg32\ChooseColorW", Str,CC )
	Color:=NumGet(CC,12,"UInt")
	CustColors:=
	CustColors:=Object()
	Loop 16
	{
		CustColors.Insert(A_Index,Numget(CC,32+A_Index*4,"UInt"))
	}
	return RVal
}

BGRtoRGB(oldValue) { ;DISCLAIMER: This function is not mine, all the credit for this goes to Micha on the forums, thanks for letting me "borrow" it, Link: https://autohotkey.com/board/topic/8617-how-to-call-the-standard-choose-color-dialog/
	Value := (oldValue & 0x00ff00)
	Value += ((oldValue & 0xff0000) >> 16)
	Value += ((oldValue & 0x0000ff) << 16)  
	return Value
}

HexDec(DX) {
	DH := InStr(DX, "0x") > 0 ? "D" : "H"
	SetFormat Integer, %DH%
	return DX + 0
}

ToolTipTimer(Text, Timeout, x:="x", y:="y", WhichToolTip:=1) {
	If (x = "x")
		MouseGetPos, X
	If (y = "y")
		MouseGetPos, , Y
	ToolTip, %Text%, %X%, %Y%, %WhichToolTip%
	SetTimer, RemoveToolTip, -%Timeout%
	return
	
	RemoveToolTip:
	ToolTip
	return
}