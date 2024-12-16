;|2.8|2024.09.08|1670
#SingleInstance, Ignore

Filename := GetFullPathName(A_scriptdir "\..\..\引用程序\其它资源\8000.txt")
Random, Rand, 1, 7744
FileReadLine, Rand_word, % Filename, % Rand
FileEncoding UTF-8   ; 默认文本文件的编码

WordIni := A_ScriptDir "\..\..\配置文件\外部脚本\工具类\单行阅读器.ini"

if !FileExist(WordIni)
{
	Settings := "
(
[Tabs]
TabNames=8000|
t_8000=" Filename "
t_800_Line=1

[Settings]
EditColor=0xFFFFFF
TextColor=0x000000
AutomaticTextColor=1
AutoSave=1
DarkMode=0
Passcode=D41D8CD98F00B204E9800998ECF8427E
StartupCheckPassCode=0
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
	FileAppend, %Settings%, %WordIni%
}

IniRead, EditC, %WordIni%, Settings, EditColor
IniRead, TextC, %WordIni%, Settings, TextColor
IniRead, ATC, %WordIni%, Settings, AutomaticTextColor
IniRead, AutoS, %WordIni%, Settings, AutoSave
IniRead, DarkMode, %WordIni%, Settings, DarkMode
IniRead, StartupCheckPassCode, %WordIni%, Settings, StartupCheckPassCode
IniRead, Passcode, %WordIni%, Settings, Passcode
IniRead, TabCheckRead, %WordIni%, Tabs, TabNames

if (TabCheckRead = "ERROR")    ;  没有配置文件
{
  Gui, +Hwnddhydq
	TNames := "Untitled"
	Gui, Add, Tab3, hwndtab vcurrentTab, %TNames%
  Gui, font, s16
	Gui, Add, Edit, w300 h200 gAutoSave c%TextC% vEditText1
  Gui, font
}
else
{
	IniRead, TNames, %WordIni%, Tabs, TabNames
  while instr(TNames, "|")=1
    TNames := substr(TNames, 2)
  Gui, +Hwnddhydq
	Gui, Add, Tab3, hwndtab vcurrentTab, %TNames%
	tcount := TAB_GetItemCount(Tab)
	Loop, Parse, TNames, |
	{
		Gui, Tab, %A_Index%
    EditVar := ""
    if (A_LoopField != "")
    {
      IniRead, Fpath, %WordIni%, Tabs, % "t_" A_LoopField
      IniRead, FLine, %WordIni%, Tabs, % "t_" A_LoopField "_Line"
      FileReadLine, EditVar, % Fpath, % FLine
      ;msgbox % EditVar "`n" Fpath  ; 发生错误 EditVar 不会清空
      Gui, font, s16
      Gui, Add, Edit, w300 h200 gAutoSave c%TextC% vEditText%A_Index%, %EditVar%
      Gui, font
      EditPut := ""
    }
	}
}
Gui, Color, , %EditC%
Gui, Tab
Gui, Add, Button, gAddFiles, ▲
Gui, Add, Button, gprev x+5, ◀
Gui, Add, Button, gnext x+5, ▶
;Gui, Add, Button, gNew x+5, 新建
Gui, Add, Button, gDelete x+5, 删除
Gui, Add, Button, gChangeName x+5, 重命名

Gui, Add, Button, gSettings x+5, ¤
Gui, Add, CheckBox, gAOT x+5 yp h25, 置顶
Gui, Add, CheckBox, x+5 yp h25 vwordp, 朗读
if (StartupCheckPassCode = 1) && (Passcode != "")
	GoSub, PasscodeCheckEnter
else
	Gui, Show,, 阅读器

Gui, +HwndSN
Gui, New, , Settings
Gui, Settings:Add, Text, x10 y10 w50 h20, 背景颜色
Gui, Settings:Add, Edit, x10 y30 w80 h20 gEditColor vEditColor, %EditC%
Gui, Settings:Add, Button, x+5 y29 w20 gChooseColorEdit, °
Gui, Settings:Add, ListView, x120 y30 w20 h20 +Background%EditC%
Gui, Settings:Add, Text, x10 y60 w50 h20, 文本颜色
Gui, Settings:Add, Edit, x10 y80 w80 h20 gTextColor vTextColor Disabled%ATC%, %TextC%
Gui, Settings:Add, Button, x+5 y79 w20 gChooseColorText Disabled%ATC%, °
Gui, Settings:Add, ListView, x120 y80 w20 h20 +Background%TextC%
Gui, Settings:Add, CheckBox, x10 +Checked%ATC% gATColor vATColor h25, 自动文本颜色
Gui, Settings:Add, CheckBox, +Checked%AutoS% vAS  h25, 自动保存
Gui, Settings:Add, CheckBox, +Checked%DarkMode% gDM vDM  h25, 夜间模式
Gui, Settings:Add, GroupBox, w150 h100, 密码相关
Gui, Settings:Add, Text, xp+10 h25 yp+25, 设置新密码
Gui, Settings:Add, Edit, Password yp+20 w120 vPC h25,
Gui, Settings:Add, CheckBox, xp yp+25 +Checked%StartupCheckPassCode% vScp h25, 启动时验证密码
Gui, Settings:Add, Button, gApply, 应用
Gui, Settings:+ToolWindow +Owner
Col:=0xFF0000
CColors:=Object()
Loop 16
{
	IniRead, Color%A_Index%, %WordIni%, Settings, Color%A_Index%
	CColors.Insert(Color%A_Index%)
  ;msgbox % (Color%A_Index%)
}
return

Apply:
Gui, Settings:Submit, NoHide
Gui, 1:Default
tcount := TAB_GetItemCount(Tab)
Loop, %tcount%
{
	Gui, Tab, %A_Index%
	Gui, Color, , %EditColor%
	GuiControl, +c%TextColor%, Edit%A_Index%
}
IniWrite, %EditColor%, %WordIni%, Settings, EditColor
IniWrite, %TextColor%, %WordIni%, Settings, TextColor
IniWrite, %ATColor%, %WordIni%, Settings, AutomaticTextColor
IniWrite, %DM%, %WordIni%, Settings, DarkMode

if (pc != "") or (StartupCheckPassCode != scp)
{
  InputBox, oldpc, 密码检测, 请输入旧密码以更改设置, hide
  if (ErrorLevel = 1)  ; 按下取消键
  {
    GuiControl, Settings:, scp, % StartupCheckPassCode
    return
  }
  else
  {
    if (Passcode = MD5_fromString(oldpc)) or (strlen(Passcode) != 32)
    {
      Passcode := MD5_fromString(PC)
      IniWrite, % Passcode, %WordIni%, Settings, Passcode
      StartupCheckPassCode := scp
      IniWrite, %Scp%, %WordIni%, Settings, StartupCheckPassCode
    }
    else
    {
      ToolTipTimer("旧密码输入错误, 无法设置新密码或修改启动时验证密码的设置", 5200)
      GuiControl, Settings: , scp, % StartupCheckPassCode
    }
  }
}
return

;-------------------------------------------------------------------------------
MD5_fromString(String) { ; return the MD5 hash for a string variable
;-------------------------------------------------------------------------------
    ; MD5 context structure
    VarSetCapacity(MD5_CTX, 104, 0)
    , DllCall("advapi32\MD5Init",   "UInt", &MD5_CTX)
    , DllCall("advapi32\MD5Update", "UInt", &MD5_CTX
        , A_IsUnicode ? "AStr" : "Str", String, "UInt", StrLen(String))
    , DllCall("advapi32\MD5Final",  "UInt", &MD5_CTX)

    ; convert 16-byte MD5 digest to 32-char hash string
    Loop, % StrLen(Hex := "123456789ABCDEF0")
        N := NumGet(MD5_CTX, 87 + A_Index, "Char")
        , MD5 .= SubStr(Hex, N >> 4, 1) SubStr(Hex, N & 15, 1)

    Return, MD5
}

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
	TextColor := hex2dec(EditColor) < 8355711 ? 0xFFFFFF : 0x000000
GuiControl, Settings:Text, Edit2, %TextColor%
GuiControl, Settings:+Background%TextColor%, SysListView322
return

ChooseColorEdit:
ChooseColorText:
if (ChooseColor(Col, CColors)=1)
{
	Loop, 16
  {
    tmpcol := FHex(CColors[A_Index], 6)
    if (tmpcol = 0x0)
      tmpcol := "0x000000"
		IniWrite, % tmpcol, %WordIni%, Settings, Color%A_Index%
  }
  ;msgbox % BGRtoRGB(Col)
	Color := FHex(BGRtoRGB(Col), 6)
  if (Color = 0x0)
    Color := "0x000000"
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

FHex( int, pad=0 ) 
{
  ; 将十进制整数转换为十六进制
  ; Function by [VxE]. Formats an integer (decimals are truncated) as hex.
  ; "Pad" may be the minimum number of digits that should appear on the right of the "0x".

	Static hx := "0123456789ABCDEF"
	If !( 0 < int |= 0 )
		Return !int ? "0x0" : "-" FHex( -int, pad )

	s := 1 + Floor( Ln( int ) / Ln( 16 ) )
	h := SubStr( "0x0000000000000000", 1, pad := pad < s ? s + 2 : pad < 16 ? pad + 2 : 18 )
	u := A_IsUnicode = 1
	Loop % s
		NumPut( *( &hx + ( ( int & 15 ) << u ) ), h, pad - A_Index << u, "UChar" ), int >>= 4
	Return h
}

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
Gui, Settings:Show, x%SnX% y%SnY%, 设置
if CheckifAOT
	Gui, Settings:+AlwaysOnTop
else
	Gui, Settings:-AlwaysOnTop
return

prev:
!right::
next:
ControlGet, CurrentTabNum, Tab, , SysTabControl321, ahk_id %dhydq%
currentTab := TAB_GetText(Tab, CurrentTabNum)
IniRead, Fpath, %WordIni%, Tabs, % "t_" currentTab
IniRead, FLine, %WordIni%, Tabs, % "t_" currentTab "_Line"
if FLine is not integer
  FLine := 0
FLine++
FileReadLine, EditVar, % Fpath, % FLine
while !EditVar
{
  FLine++
  FileReadLine, EditVar, % Fpath, % FLine
}
;msgbox % FLine "|" EditVar "|" CurrentTabNum "|" currentTab
GuiControl,, EditText%CurrentTabNum%, %EditVar%
IniWrite, % FLine, %WordIni%, Tabs, % "t_" currentTab "_Line"
sleep 50
ControlGet, wordp, Checked,, Button8, ahk_id %dhydq%
if wordp
{
  Wordpaly(EditVar)
  gosub next
}
return

AutoSave:
Return

AOT:
Winset, AlwaysOnTop, Toggle
return

guiclose:
Gui, Destroy
exitapp

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

Delete:
Gui, +OwnDialogs
tcount := TAB_GetItemCount(Tab)  ; 总标签页数目
if (tcount = 1)
	MsgBox, 48, 抱歉, 您不能删除最后一个便签!
else 
{
  ControlGet, CurrentTabNum, Tab, , SysTabControl321, A
  currentDelTab := TAB_GetText(Tab, CurrentTabNum)
	MsgBox, 308, 确认, 您确认要删除选中的便签 %currentDelTab%, 然后重启吗?
	IfMsgBox, No
		return
	IfMsgBox, Yes
	{
    TabNames := ""
    Loop, %tcount%
    {
      currentTab := TAB_GetText(Tab, A_Index)
      if (A_Index != CurrentTabNum)
        TabNames .= "|" currentTab 
    }
    while instr(TabNames, "|")=1
      TabNames := substr(TabNames, 2)
    IniWrite, %TabNames%, %WordIni%, Tabs, TabNames
    IniDelete, %WordIni%, Tabs, % "t_" currentDelTab        ; 删除选中名称
    IniDelete, %WordIni%, Tabs, % "t_" currentDelTab "_Line"
    reload
	}
}
return

ChangeName:
Gui, +OwnDialogs
ControlGet, CurrentTabNum, Tab, , SysTabControl321, A
currentChangingNameTab := TAB_GetText(Tab, CurrentTabNum)
if (currentTab = "无标题")
{
  ToolTipTimer("无标题标签不能重命名", 4000)
  return
}
InputBox, NewName, 单词本, 请输入新的标签名, , 250, 125
if (NewName = "无标题")
	MsgBox, 8208, Error, Sorry but you can't use that name, it would interfere with the saving system!
else if (ErrorLevel = 0)
{
  IniRead, Fpath, %WordIni%, Tabs, % "t_" currentChangingNameTab
  IniRead, FLine, %WordIni%, Tabs, % "t_" currentChangingNameTab "_Line"
  IniDelete, %WordIni%, Tabs, % "t_" currentChangingNameTab  ; 删除旧名称
  IniDelete, %WordIni%, Tabs, % "t_" currentChangingNameTab "_Line"
  tcount := TAB_GetItemCount(Tab)
  TabNames := ""
  Loop, %tcount%
  {
    currentTab := TAB_GetText(Tab, A_Index)
    TabNames .= "|" currentTab 
  }
  TabNames  := strreplace(TabNames, currentChangingNameTab, NewName)
  GuiControl, , SysTabControl321, % TabNames   ; 应用新标签名
  while instr(TabNames, "|")=1
    TabNames := substr(TabNames, 2)
  IniWrite, % TabNames, %WordIni%, Tabs, TabNames
  IniWrite, % Fpath, %WordIni%, Tabs, % "t_" NewName 
  IniWrite, % FLine, %WordIni%, Tabs, % "t_" NewName "_Line"
  TabNames := ""
}
return

New:
newf := "无标题"
GuiControl,, SysTabControl321, % newf   ; 新增1标签
tcount := TAB_GetItemCount(Tab)
;msgbox % tcount
Gui, Tab, %tcount%
Gui, Add, Edit, w300 h200 gAutoSave c%TextC% vEditText%tcount%
return

AddFiles:
Gui, +OwnDialogs
FileSelectFile, Fpath, 3, C:\Users\%A_UserName%\Downloads, 打开文本文件, 文本文件(*.txt; *.ahk; *.md)
GuiDropFiles:
if (A_ThisLabel = "GuiDropFiles")
	Fpath := A_GuiEvent
if (Fpath = "")
	return
else
{
	GoSub, New
	GuiControl, Choose, SysTabControl321, %tcount%
	FileReadLine, EditVar, % Fpath, 1
  SplitPath, Fpath, , , , OutNameNoExt
	Gui, Tab, %tcount%
	GuiControl, Text, EditText%tcount%, %EditVar%

  TabNames := ""
  Loop, %tcount%
  {
    currentTab := TAB_GetText(Tab, A_Index)
    TabNames .= "|" currentTab 
  }
  TabNames := strreplace(TabNames, newf, OutNameNoExt)

  GuiControl, , SysTabControl321, %TabNames%
  GuiControl, Choose, SysTabControl321, %tcount%
  IniWrite, % TabNames, %WordIni%, Tabs, TabNames
  IniWrite, % Fpath, %WordIni%, Tabs, % "t_" OutNameNoExt 
  IniWrite, 1, %WordIni%, Tabs, % "t_" OutNameNoExt "_Line"
}
return

PasscodeCheckEnter:
F4::
InputBox, PasswordCheck, 密码检测, 输入密码后打开(区分大小写), hide
if (ErrorLevel = 1)
	exitapp
else
{
	if (MD5_fromString(PasswordCheck) = Passcode)
		Gui, Show, , 阅读器
	else
  {
    ;msgbox % MD5_fromString(PasswordCheck) "`n" Passcode
		Goto, PasscodeCheckEnter
  }
}
return

StrAmt(haystack, needle, casesense := false) {
	StringCaseSense % casesense
	StrReplace(haystack, needle, , Count)
	return Count
}

/*
Save:    ; 保存所有
ControlGet, CurrentTabName, Tab, , SysTabControl321, A   ; 当前序号
tcount := TAB_GetItemCount(Tab)
Gui, Submit, NoHide
TabNames := ""
Loop, %tcount%
{
  currentTab := TAB_GetText(Tab, A_Index)
  TabNames .= currentTab "|"
  file := FileOpen(StickyNotesFolder "\" currentTab, "w"), file.Write(EditText%A_Index%), file.Close()
}
IniWrite, %TabNames%, %WordIni%, StickyNotes, TabNames
TabNames := ""
GuiControl, Choose, SysTabControl321, %CurrentTabName%
Gui, Show, NoActivate, 阅读器
return
*/

ChooseColor(ByRef Color, ByRef CustColors, hWnd=0x0, Flags=0x103)
{ ;DISCLAIMER: This function is not mine, all the credit for this goes to Elgin on the forums, thank you for "borrowing" it to me :) Link: https://www.autohotkey.com/board/topic/8617-how-to-call-the-standard-choose-color-dialog/
	VarSetCapacity(CC, 9*A_PtrSize+16*4, 0)
	NumPut(9*A_PtrSize, CC)
	NumPut(hWnd, CC, A_PtrSize)
	NumPut(Color, CC, 3*A_PtrSize)
	Loop 16
		NumPut(CustColors[A_Index], CC, 9*A_PtrSize+(A_Index-1)*4)
	NumPut(&CC+9*A_PtrSize, CC, 4*A_PtrSize)
	NumPut(Flags, CC, 5*A_PtrSize)
	RVal:=DllCall( "comdlg32\ChooseColorW", Str, CC )
	Color := NumGet(CC, 3*A_PtrSize, "UInt")
	CustColors := ""
	CustColors := Object()
	Loop 16
	{
		CustColors.Insert(A_Index, Numget(CC, 9*A_PtrSize+(A_Index-1)*4, "UInt"))
	}
	return RVal
}

BGRtoRGB(oldValue)
{ ;DISCLAIMER: This function is not mine, all the credit for this goes to Micha on the forums, thanks for letting me "borrow" it, Link: https://autohotkey.com/board/topic/8617-how-to-call-the-standard-choose-color-dialog/
	Value := (oldValue & 0x00ff00)
	Value += ((oldValue & 0xff0000) >> 16)
	Value += ((oldValue & 0x0000ff) << 16)  
	return Value
}

hex2dec(h)
{
	BackUp_FmtInt := A_FormatInteger
	SetFormat, integer, dec
	d := h+0
	SetFormat, IntegerFast, %BackUp_FmtInt% 
  return d
} 

dec2hex(d)
{
	BackUp_FmtInt := A_FormatInteger
	SetFormat, integer, H
	h := d+0
	SetFormat, IntegerFast, %BackUp_FmtInt%
  return h
}

ToolTipTimer(Text, Timeout, x:="x", y:="y", WhichToolTip:=1)
{
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

Wordpaly(Word)
{
	static spovice
	if !IsObject(spovice)
		try spovice := ComObjCreate("sapi.spvoice")
  if (pos := Instr(Word, " ["))
    Rand_word := 	SubStr(Word, 1, pos)
  Else
    Rand_word := Word
	try spovice.Speak(Rand_word)
}

GetFullPathName(path)
{
  cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
  VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
  DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
  return buf
}