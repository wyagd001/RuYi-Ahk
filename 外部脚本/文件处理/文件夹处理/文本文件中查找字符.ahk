;|3.0|2025.09.06|1096
#Include <Ruyi>
#Include <File_GetEncoding>
; Script Information ===========================================================
; Name:         File String Search
; Description:  Search files for a specific string (Inspired by TLM)
;               https://autohotkey.com/boards/viewtopic.php?f=6&t=27299 
; AHK Version:  AHK_L 1.1.24.04 (Unicode 32-bit) - December 17, 2016
; OS Version:   Windows 2000+
; Language:     English - United States (en-US)
; Author:       Weston Campbell <westoncampbell@gmail.com>
; Filename:     StringSearch.ahk
; ==============================================================================

; Revision History =============================================================
; Revision 1 (2017-01-25)
; * Initial release
; ==============================================================================

; Auto-Execute =================================================================
#SingleInstance, Ignore ; Allow only one running instance of script
#Persistent ; Keep the script permanently running until terminated
#NoEnv ; Avoid checking empty variables for environment variables
#Warn ; Enable warnings to assist with detecting common errors
;#NoTrayIcon ; Disable the tray icon of the script
SendMode, Input ; The method for sending keystrokes and mouse clicks
SetWorkingDir, %A_ScriptDir% ; Set the working directory of the script
SetBatchLines, -1 ; The speed at which the lines of the script are executed
SetWinDelay, -1 ; The delay to occur after modifying a window
SetControlDelay, -1 ; The delay to occur after modifying a control
OnExit("OnUnload") ; Run a subroutine or function when exiting the script
return ; End automatic execution
; ==============================================================================

; Labels =======================================================================
ControlHandler:
    VarCount := ""
    If (A_GuiControl = "ButtonDir") {
        FileSelectFolder, DirSel,,, 选择目录...
        IfEqual, ErrorLevel, 1, return
        GuiControl,, EditDir, % DirSel
        GuiControl, choose, EditDir, % DirSel
    } Else If (A_GuiControl = "ButtonSearch") {
        Gui, Submit, NoHide
        if !EditString
          Return
        GuiControl, Choose, Tab, 2
        LV_Delete()
        SB_SetText("搜索中...", 1)
        SB_SetText("", 2)
        
        GuiControl, Disable, ButtonSearch
        GuiControl, Enable, ButtonStop
        
        if Recurse
          option := "FR"
        else
          option := "F"
        Loop, Files, % EditDir "\" (EditType ? EditType : "*.*"), % option
        {
            if A_LoopFileExt in txt,ahk,ahk2,au3,htm,html,json,md,bat,js
            	FileEncoding % File_GetEncoding(A_LoopFileFullPath)
            else if A_LoopFileExt in exe,rar,zip,doc,pdf,mp4,xls,mp3,dll
              continue    ; 跳过指定类型的文件
            ;FileEncoding % File_GetEncoding(A_LoopFileFullPath)
            Try FileRead, MatchRead, % A_LoopFileFullPath   ;  utf8  编码的问题

            IfEqual, SearchStop, 1, Break
            if (fullword = 1)
            {
              MatchRead := RegExReplace(MatchRead, "i)\b" EditString "\b", EditString, VarCount) 
              IfEqual, VarCount, 0, Continue
            }
            else if (Rerex = 1)
            {
              MatchRead := RegExReplace(MatchRead, EditString, , VarCount)
              IfEqual, VarCount, 0, Continue
            }
            else   ; 普通查找
            {
              StringReplace, MatchRead, MatchRead, % EditString, % EditString, UseErrorLevel
              IfEqual, ErrorLevel, 0, Continue
            }
            LV_Add("", (VarCount != "") ? VarCount : ErrorLevel, A_LoopFileFullPath)
            LV_ModifyCol(1, "AutoHdr")
            LV_ModifyCol(2, "AutoHdr")
            SB_SetText("`t`t搜索 " A_Index . " 个文件, (" LV_GetCount() "个匹配)", 2)
        }
        LV_ModifyCol(1, "Logical")
        SearchStop := 0
        
        GuiControl, Disable, ButtonStop
        GuiControl, Enable, ButtonSearch
        GuiControl, Enable, OpenFileFullPath
        GuiControl, Enable, OpenFile
        
        SB_SetText("扫描完毕", 1)
    } Else If (A_GuiControl = "ButtonStop") {
        SearchStop := 1
    }
return

OpenFileFullPath:
LV_GetText(FileFullPath, LV_GetNext("F"), 2)
If Fileexist(FileFullPath)
	CF_OpenFolder(FileFullPath)
else
	msgbox, 未选中或文件不存在。
Return

OpenFile:
LV_GetText(FileFullPath, LV_GetNext("F"), 2)
If Fileexist(FileFullPath)
{
	if instr(notepad2, "notepad2.exe")
	{
		FileEncoding % File_GetEncoding(FileFullPath)
    tmp_linenum := 0
		Loop, Read, % FileFullPath
		{
      if !Rerex
      {
        if instr(A_LoopReadLine, EditString)
        {
          tmp_linenum := A_index
          ;tooltip % EditString "-" tmp_linenum
          break
        }
      }
      else
      {
        FoundPos := RegExMatch(A_LoopReadLine, EditString)
        if FoundPos
        {
          tmp_linenum := A_index
          break
        }
      }
		}
    ;msgbox % notepad2
    if tmp_linenum
      Run, "%notepad2%" /g %tmp_linenum% "%FileFullPath%"
    else
      Run, "%notepad2%" "%FileFullPath%"
	}
	else
		Run, "%notepad2%" "%FileFullPath%"
}
else
	msgbox, 未选中或文件不存在。
Return

LV1x:
Gui,1:default
Gui,1:submit, nohide
rcon := a_guicontrol
Gui,1:ListView, %rcon%
Extensions := "ahk,ahk2,txt,bat,bas,ini,htm,html,csv,xml,md,reg,au3"    ;- some extensions with text
RN := LV_GetNext("C")
RF := LV_GetNext("F")
GC := LV_GetCount()
if (rn = 0)
	return
if (A_GuiEvent = "DoubleClick")
{
	LV_GetText(C2, a_eventinfo, 2)
	SplitPath, c2,,, ext,
	if Ext in %Extensions%
	{
		try
		run, "%notepad2%" "%c2%"
	}
}
return

GuiEscape:
GuiClose:
ExitSub:
    ExitApp ; Terminate the script unconditionally
return
; ==============================================================================

; Functions ====================================================================
OnLoad()
{
  Global ; Assume-global mode
  run_iniFile = %A_ScriptDir%\..\..\..\配置文件\外部脚本\文件处理\文件夹处理\文本文件中查找字符.ini
  if !fileexist(run_iniFile)
  {
    FileCreateDir, %A_ScriptDir%\..\..\..\配置文件\外部脚本\文件处理\文件夹处理
    fileappend,, %run_iniFile%
    ;msgbox % ErrorLevel " - " A_LastError 
    IniWrite, *.*|*.htm|*.ahk|*.txt|*.md, %run_iniFile%, 文件中查找字符, 固定类型
    IniWrite, *.*, %run_iniFile%, 文件中查找字符, 类型
  }
  Static Init := OnLoad() ; Call function
	Menu, Tray, UseErrorLevel
	Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\ede4.ico"
  EditDir = %1%
  if !EditDir
    IniRead, EditDir, %run_iniFile%, 文件中查找字符, 路径, %A_Space%
  IniRead, SEditDir, %run_iniFile%, 文件中查找字符, 固定查找目录, %A_Space%
  IniRead, EditType, %run_iniFile%, 文件中查找字符, 类型, %A_Space%
  IniRead, SEditType, %run_iniFile%, 文件中查找字符, 固定类型, %A_Space%
  IniRead, EditString, %run_iniFile%, 文件中查找字符, 字符, %A_Space%
  IniRead, notepad2, %A_ScriptDir%\..\..\..\配置文件\如一.ini, 其他程序, notepad2, Notepad.exe
  if InStr(notepad2, "%A_ScriptDir%")
	{
		RY_Dir := Deref("%A_ScriptDir%")
		RY_Dir := SubStr(RY_Dir, 1, InStr(RY_Dir, "\", 0, 0, 3) - 1)
 		notepad2 := StrReplace(notepad2, "%A_ScriptDir%", RY_Dir)
		notepad2 := FileExist(notepad2) ? notepad2 : "notepad.exe"
 		;msgbox % notepad2
	}
  SearchStop := 0
}

OnUnload(ExitReason, ExitCode) {
    Global ; Assume-global mode
    
    Gui, Submit, NoHide
    if EditDir <>
			IniWrite, % EditDir, %run_iniFile%, 文件中查找字符, 路径
		if EditType <>
      IniWrite, % EditType, %run_iniFile%, 文件中查找字符, 类型
    IniWrite, % EditString, %run_iniFile%, 文件中查找字符, 字符
}

GuiCreate() {
    Global ; Assume-global mode
    Static Init := GuiCreate() ; Call function
    If SEditDir not contains  %EditDir%
       EditDirList := EditDir "|" SEditDir
    else
       EditDirList := SEditDir
    If SEditType not contains  %EditType%
       EditTypeList := EditType "|" SEditType
    else
       EditTypeList := SEditType
    Gui, +LastFound -Resize +HWNDhGui1
    Gui, Margin, 8, 8
    Gui, Add, Tab3, vTab, 查找

    Gui, Tab, 1
    Gui, Add, Text, w460 BackgroundTrans Section, 目录:
    Gui, Add, ComBoBox, y+10 w416 vEditDir, % EditDirList
    Gui, Add, Button, x+10 yp w34 hp vButtonDir gControlHandler, ...
    Gui, Add, Text, xs y+20 w460 BackgroundTrans, 文件类型:
    Gui, Add, ComBoBox, y+10 w460 vEditType, % EditTypeList
    Gui, Add, Text, xs y+20 w460 BackgroundTrans, 字符:
    Gui, Add, Edit, y+10 w460 vEditString, % EditString
    GuiControl, choose, EditDir, % EditDir
    GuiControl, choose, EditType, % EditType
    Gui, Add, CheckBox, xs y+10 h20 vfullword, 全字符匹配(单词边界)
    Gui, Add, CheckBox, x+10 yp h20 vRerex, 正则表达式
    Gui, Add, CheckBox, x+10 yp h20 Checked vRecurse, 递归子文件夹

    ;Gui, Tab, 2
    Gui, Add, ListView, w460 r10 xs yp+30 vListView Grid +altsubmit vLV1 gLV1x, 找到次数|文件路径

    Gui, Tab
    Gui, Add, Button, w80 h24 default vButtonSearch gControlHandler, 搜索   
    Gui, Add, Button, x+10 w80 h24 vButtonStop gControlHandler Disabled, 停止
    Gui, Add, Button, x+10 w100 h24 vOpenFileFullPath gOpenFileFullPath Disabled, 打开文件位置
    Gui, Add, Button, x+10 w100 h24 vOpenFile gOpenFile Disabled, 编辑文件  
    
    Gui, Add, StatusBar,,
    SB_SetParts(120)
    
    Gui, Show, AutoSize, 文件字符搜索
}
; ==============================================================================

CF_OpenFolder(sfile, OnlyFolder := 1){
	if !CF_IsFolder(sfile)
		SplitPath, sfile, , oPath
	if OnlyFolder
		Run %oPath%
	else
		Run, % "explorer.exe /select," sfile
}