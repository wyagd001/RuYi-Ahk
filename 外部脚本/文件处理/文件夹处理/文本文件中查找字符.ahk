﻿; Script Information ===========================================================
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
#SingleInstance, Force ; Allow only one running instance of script
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
        GuiControl, Choose, Tab, 2
        LV_Delete()
        SB_SetText("搜索中...", 1)
        SB_SetText("", 2)
        
        GuiControl, Disable, ButtonSearch
        GuiControl, Enable, ButtonStop
        
        Loop, Files, % EditDir "\" (EditType ? EditType : "*.*"), FR
        {
            Try FileRead, MatchRead, % A_LoopFileFullPath
            IfEqual, SearchStop, 1, Break
            if !fullword
            {
              StringReplace, MatchRead, MatchRead, % EditString, % EditString, UseErrorLevel
              IfEqual, ErrorLevel, 0, Continue
            }
            else
            {
              MatchRead := RegExReplace(MatchRead, "i)\b" EditString "\b", EditString, VarCount) 
              IfEqual, VarCount, 0, Continue
            } 
            LV_Add("", (VarCount != "") ? VarCount : ErrorLevel, A_LoopFileFullPath)
            LV_ModifyCol(1, "AutoHdr")
            LV_ModifyCol(2, "AutoHdr")
            SB_SetText("`t`t搜索 " A_Index . " 个文件, (" LV_GetCount() "个匹配)", 2)
        }
        
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
	msgbox,未选中或文件不存在。
Return

OpenFile:
LV_GetText(FileFullPath, LV_GetNext("F"), 2)
If Fileexist(FileFullPath)
Run,"%notepad2%"  "%FileFullPath%"
else
msgbox,未选中或文件不存在。
Return

LV1x:
Gui,1:default
Gui,1:submit, nohide
rcon := a_guicontrol
Gui,1:ListView, %rcon%
Extensions := "ahk,txt,bat,bas,ini,htm,html,csv,xml"    ;- some extensions with text
  RN := LV_GetNext("C")
  RF := LV_GetNext("F")
  GC := LV_GetCount()
  if (rn = 0)
    return
if A_GuiEvent = DoubleClick
  {
  LV_GetText(C2, a_eventinfo, 2)
  SplitPath,c2, , , ext,
  if Ext in %Extensions%
    {
    try
    ;run, notepad "%c2%"
		run, "%notepad2%" "%c2%"
       ;- open with notepad or other editors
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
OnLoad() {
    Global ; Assume-global mode
    run_iniFile = %A_ScriptDir%\文本文件中查找字符.ini
    Static Init := OnLoad() ; Call function
    EditDir = %1%
    if !EditDir
      IniRead, EditDir, %run_iniFile%, 文件中查找字符, 路径, %A_Space%
    IniRead, SEditDir, %run_iniFile%, 文件中查找字符, 固定查找目录, %A_Space%
    IniRead, EditType, %run_iniFile%, 文件中查找字符, 类型, %A_Space%
    IniRead, EditString, %run_iniFile%, 文件中查找字符, 字符, %A_Space%
    IniRead, notepad2, %run_iniFile%, otherProgram, notepad2, F:\Program Files\Editor\Notepad2\Notepad2.exe

    SearchStop := 0
}

OnUnload(ExitReason, ExitCode) {
    Global ; Assume-global mode
    
    Gui, Submit, NoHide
    if EditDir <>
    IniWrite, % EditDir, %run_iniFile%, 文件中查找字符, 路径
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
    Gui, +LastFound -Resize +HWNDhGui1
    Gui, Margin, 8, 8
    Gui, Add, Tab3, vTab, 查找|搜索结果

    Gui, Tab, 1
    Gui, Add, Text, w460 BackgroundTrans Section, 目录:
    Gui, Add, ComBoBox, y+10 w416 vEditDir, % EditDirList
    Gui, Add, Button, x+10 yp w34 hp vButtonDir gControlHandler, ...
    Gui, Add, Text, xs y+20 w460 BackgroundTrans, 文件类型:
    Gui, Add, Edit, y+10 w460 vEditType, % EditType
    Gui, Add, Text, xs y+20 w460 BackgroundTrans, 字符:
    Gui, Add, Edit, y+10 w460 vEditString, % EditString
    GuiControl,choose,EditDir,% EditDir
    Gui, Add, CheckBox, xs y+10 h20 vfullword,全字符匹配(单词边界)

    Gui, Tab, 2
    Gui, Add, ListView, w460 r10 vListView Grid +altsubmit vLV1 gLV1x, 找到次数|文件路径

    Gui, Tab
    Gui, Add, Button, w80 h24 default vButtonSearch gControlHandler, 搜索   
    Gui, Add, Button, x+10 w80 h24 vButtonStop gControlHandler Disabled, 停止
    Gui, Add, Button, x+10 w100 h24 vOpenFileFullPath gOpenFileFullPath Disabled, 打开文件位置
    Gui, Add, Button, x+10 w100 h24 vOpenFile gOpenFile Disabled, 打开文件  
    
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

CF_IsFolder(sfile){
	if InStr(FileExist(sfile), "D")
	|| (sfile = """::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
	|| SubStr(sfile, 1, 2) = "\\"
		return 1
	else
		return 0
}