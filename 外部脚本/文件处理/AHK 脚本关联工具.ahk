;|2.8|2024.08.30|1662
/*
作者：      甲壳虫<jdchenjian@gmail.com>
博客：      http://hi.baidu.com/jdchenjian
脚本说明：  此工具用来修改 AutoHotkey 脚本的右键菜单关联，适用于 AutoHotkey 安装版、绿色版。
脚本版本：  2009-01-21

修改作者：	兔子
更新说明：
2010.01.09	之前某个时间，修改AHK路径、编辑器路径、编译器路径，默认全部在当前目录下寻找
2010.01.09	去掉默认在新建菜单的勾
2010.06.21	如果SCITE为默认编辑器，则复制个人配置文件“SciTEUser.properties”到%USERPROFILE%
2010.06.25	修正因#NoEnv使%USERPROFILE%变量直接引用无效
2016.04.18	删除“2010.06.21”的改动
2021.10.17	新增“编译脚本 (GUI)”的汉化
2021.11.02	自动根据 AutoHotkey.exe 的位置定位基准目录。
2021.11.05	重构代码，精简界面，修复新建模板时的编码问题，修复编辑模板时的权限问题。

修改作者：	布谷布谷
2022.04.15	增加.ah2 .ahk2 文件的关联，并增加脚本关联选项 
2022.04.16	增加右键脚本以管理员身份运行,添加注册表操作日志 
*/

#NoEnv
#SingleInstance, force
SendMode Input
SetBatchLines, -1
SetControlDelay, -1
SetWorkingDir %A_ScriptDir%
if fileexist(A_ScriptDir "\..\临时目录")
	tmp_folder := A_ScriptDir "\..\临时目录"
else if fileexist(A_ScriptDir "\..\..\临时目录")
	tmp_folder := A_ScriptDir "\..\..\临时目录"
else
	tmp_folder := A_ScriptDir

Guix := A_ScreenWidth/2 - 300
Guiy := A_ScreenHeight/2 - 300
; 版本(仅用于显示）
Script_Version=ver. 1.2.1
administrator:=(A_IsAdmin?"已":"未" ) . "获得管理员权限"
Gui, New, +HwndGuiHwnd, AHK 脚本关联工具_汉化 %Script_Version% ( %administrator% )
Gui, Font, bold s15
Gui, Add, Text,x15 y10 w275 h20 vText__, 
Gui, Font

Gui, Add, Radio,xp+280 yp- w50 hp vRadio_1 gOptions__ Checked1, ahk
Gui, Add, Radio,xp+50 yp- wp hp vRadio_2 gOptions__, ahk2
Gui, Add, Radio,xp+50 yp- wp hp vRadio_3 gOptions__, ah2

Gui, Add, Button,xp+50 yp- w50 hp vState__0 gState__, 选项>>
Gui, Add, GroupBox,xp+60 yp-5 w205 h336 vState__1,

Gui, Font, bold s12
Gui, Add, Button, xp+10 yp+20 w185 h35 vState__2 gState__, 删除所有关联
Gui, Font
Gui, Add, Checkbox, xp+ yp+40 wp h30  vState__3 Checked0 gState__, 右键 >> 编译脚本
Gui, Add, Checkbox, xp+ yp+30 wp hp  vState__4 Checked0 gState__, 右键 >> 编译脚本<GUI>
Gui, Add, Checkbox, xp+ yp+30 wp hp  vState__5 Checked0 gState__, 右键 >> 编辑脚本
Gui, Add, Checkbox, xp+ yp+30 wp hp  vState__6 Checked0 gState__, 右键 >> 新建 >> ahk脚本
Gui, Add, Checkbox, xp+ yp+30 wp hp  vState__7 Checked0 gState__, 右键 >> 以管理员身份运行
Gui, Add, Button,   xp+ yp+30 wp hp  vState__8 gRunAs__, 重启并获得管理员权限
Gui, Add, Button,   xp+ yp+30 wp hp  vState__9 gjumpreg1, 经典
Gui, Add, Button,   xp+ yp+30 wp hp  vState__10 gjumpreg2, progid
Gui, Add, Button,   xp+ yp+30 wp hp  vState__11 gjumpreg3, FileExts

loop 11
	GuiControl, Hide, State__%A_Index%

Gui, Add, GroupBox,x15 y44 w480 h50 , 打开
Gui, Add, Edit, xp+10 yp+18 w340 h20 vAHK_Path,
Gui, Add, Button, xp+350 yp- w50 hp gFind_AHK, 浏览
Gui, Add, Button, xp+60 yp- wp hp gDefault_Ahk, 更改

Gui, Add, GroupBox,x15 yp+30 w480 h50 , 扩展名图标
Gui, Add, Edit, xp+10 yp+18 w340 h20 vAHKIcon_Path gshowicon,
Gui, Add, Button, xp+350 yp- w50 hp gFind_AHKIcon, 浏览
Gui, Add, Picture, xp+60 yp-5 w32 h32 vaico,

Gui, Font, bold s15
Gui, Add, Button, x15 yp+40 w200 h40 Default gInstall, 设置
Gui, Add, Button, x295 yp wp hp gCancel, 取消
Gui, Font

Gui, Add, GroupBox,x15 yp+50 w480 h50 , 编译脚本
Gui, Add, Edit, xp+10 yp+18 w340 h20 vCompiler_Path,
Gui, Add, Button, xp+350 yp- w50 hp gChoose_Compiler, 浏览
Gui, Add, Button, xp+60 yp- wp hp gDefault_Compiler, 默认

Gui, Add, GroupBox, x15 yp+30 w480 h50 , 编辑脚本
Gui, Add, Edit, xp+10 yp+18 w340 h20 vEditor_Path, 
Gui, Add, Button, xp+350 yp- w50 hp gChoose_Editor, 浏览
Gui, Add, Button, xp+60 yp- wp hp gDefault_Editor, 默认

Gui, Add, GroupBox, x15 yp+30 w480 h50 , 新建脚本文件模版
Gui, Add, Edit, xp+10 yp+18 w340 h20 vnews_Path, 
Gui, Add, Button, xp+350 yp w50 h20 gEdit_Template, 自定义
Gui, Add, Button, xp+60 yp- wp hp gDefault_news, 默认

Gui, font, , Arial,
Gui, Add, Edit, x15 yp+50 w695 h300 vlog HwndEditHwnd,注册表操作日志：`n
GuiControl, Hide, log
gosub, Options__

if (A_Args.1="/set")
	gosub, Install
else
	Gui, Show, w510 h190 x%Guix% Y%Guiy%
return

GuiClose:
GuiEscape:
Cancel:
	ExitApp
return

RunAs__:
if !(A_IsAdmin||RegExMatch(DllCall("GetCommandLine", "str"), " /restart(?!\S)"))
{
  try
  {
      if A_IsCompiled
          Run *RunAs "%A_ScriptFullPath%" /restart
      else
          Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
  }
  ExitApp
}
return

State__:
switch A_GuiControl
{
	Case "State__0":    ; 显示隐藏的界面
		State__0:=!State__0
		loop 11
    {
      if (A_Index = 8)
      {
        if !A_IsAdmin
        {
          GuiControl, Show%State__0%, State__8
        }
        continue
      }
			GuiControl, Show%State__0%, State__%A_Index%
    }
		GuiControl, Show%State__0%, log
		GuiControl, Text, State__0 , % State__0?"<<选项":"选项>>"
    if State__0
      Gui, Show, AutoSize 
    else
      Gui, Show, w510 h190 x%Guix% Y%Guiy%
	return
	Case "State__2":        ; 删除关联的所有信息
    if FileType
      RegDelete_(RootKey "\" Subkey FileType)
    if ahk__
		RegDelete_(RootKey "\" Subkey "." ahk__)
    progid := RegRead_("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\." ahk__ "\UserChoice", "ProgId")
    if progid
      RegDelete_(RootKey "\" Subkey progid)
    RegDelete_(RootKey "\" Subkey ahk__ "_auto_file")         ; 删除一些默认项, 不管其是否存在, 是否已经被删除
    RegDelete_(RootKey "\" Subkey "AutoHotkeyScript" . (ahk__="ahk"?"":"." . ahk__))
    if (ahk__= "ahk")
    {
      RegDelete_(RootKey "\" Subkey "Applications\AutoHotkey.exe")
      RegDelete_(RootKey "\" Subkey "Applications\AutoHotkeyU32.exe")
      RegDelete_(RootKey "\" Subkey "Applications\AutoHotkeyU64.exe")
    }
    else if (ahk__= "ahk")
    {
      RegDelete_(RootKey "\" Subkey "Applications\AutoHotkey32.exe")
      RegDelete_(RootKey "\" Subkey "Applications\AutoHotkey64.exe")
    }
    RegDelete_("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\." ahk__)
    DllCall("shell32\SHChangeNotify", "uint", 0x08000000, "uint", 0, "int", 0, "int", 0) ; SHCNE_ASSOCCHANGED
    gosub, Options__
		MsgBox, 4096,, 清除关联操作完成 !
	return
	Case "State__3","State__4","State__5","State__6","State__7":
		Gui, Submit, NoHide
	return
}
return

; 选择文件名类型
Options__:
Gui, Submit, NoHide
ahk__:=Radio_3?"ah2":Radio_2?"ahk2":"ahk"
GuiControl, Text, Text__ , 设置 .%ahk__% 文件的右键菜单
GuiControl, Text, State__2 , 删除 .%ahk__% 所有关联
; AutoHotkey 原版的相关信息写在注册表HKCR主键中，
; 尝试当前用户否有权操作该键，如果无权操作HKCR键（受限用户），
; 可通过操作注册表HKCU键来实现仅当前用户关联AHK脚本。
logup("通过操作注册表测试当前用户否有权操作该键")
if RegWrite_("REG_SZ","HKCR",".test")
	IsLimitedUser:=1

if RegDelete_("HKCR", ".test")
	IsLimitedUser:=1

if IsLimitedUser
{
	RootKey=HKCU              ; 受限用户操作HKCU键
	Subkey=Software\Classes\  ; 为简化后面的脚本，此子键须以“\”结尾
}
else
{
	RootKey=HKCR              ; 非受限用户操作HKCR键
	Subkey=
}
logup("--------------------------------------------------------------")
; 检查是否存在AHK注册表项
FileType:=AHK_Path:=AHKIcon_Path:=Compiler_Path:=Editor_Path:=Template_Path:=""
logup("读取 ." ahk__ " 文件的注册表")
ProgId := RegRead_("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\." ahk__ "\UserChoice", "ProgId")
if ProgId
  FileType := ProgId
else
  FileType := RegRead_(RootKey "\" Subkey "." ahk__)
if (FileType!="")
{
	AHK_Path:=PathGetPath(RegRead_(RootKey "\" Subkey FileType "\Shell\Open\Command")) ; AHK路径
  AHKIcon_Path:=RegRead_(RootKey "\" Subkey FileType "\DefaultIcon") ; 图标路径
	Compiler_Path :=PathGetPath(RegRead_(RootKey "\" Subkey FileType "\Shell\Compile\Command")) ; 编译器路径
	Compiler_Path_:=PathGetPath(RegRead_(RootKey "\" Subkey FileType "\Shell\Compile-Gui\Command")) ; 编译器路径
	Editor_Path:=PathGetPath(RegRead_(RootKey "\" Subkey FileType "\Shell\Edit\Command")) ; 编辑器路径
	Template_Path:=RegRead_(RootKey "\" Subkey "." ahk__ "\ShellNew", "FileName") ; 模板文件名 
	(!Compiler_Path&&Compiler_Path:=Compiler_Path_)
}
else
	FileType := "AutoHotkeyScript" . (ahk__="ahk"?"":"." . ahk__)
;msgbox % FileType "|" AHKIcon_Path
; 通过 AutoHotkey.exe 的位置来定位基准目录
SplitPath, A_AhkPath, , AhkDir
FilePattern := AhkDir . (ahk__="ahk"?"":"\2.0") . "\AutoHotkey.exe"
(!AHK_Path&&FileExist(FilePattern)&&AHK_Path:=FilePattern)

if !AHK_Path
{
  if (ahk__ = "ahk")
  {
    if !FileExist(AHK_Path)
      AHK_Path := GetFullPathName(A_ScriptDir "\..\..\引用程序\AutoHotkeyU" 8*A_PtrSize ".exe")
  }
  else if (ahk__ = "ahk2")
  {
    if !FileExist(AHK_Path)
      AHK_Path := GetFullPathName(A_ScriptDir "\..\..\引用程序\2.0\AutoHotkey" 8*A_PtrSize ".exe")
  }
}

if !AHKIcon_Path   ; 未设置图标时, 默认使用程序的0号图标
{
  Loop, Reg, % "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\." ahk__ "\OpenWithProgids", KV
  {
    if A_LoopRegName
    {
        AHKIcon_Path := RegRead_(RootKey "\" Subkey A_LoopRegName "\DefaultIcon") ; 图标路径
        ;msgbox % A_LoopRegName
        if AHKIcon_Path
          break
    }
  }
}

FilePattern := AhkDir . "\Compiler\Ahk2Exe.exe"
(!Compiler_Path&&FileExist(FilePattern)&&Compiler_Path:=FilePattern)
FilePattern := AhkDir . "\SciTE\SciTE.exe"
(!Editor_Path&&FileExist(FilePattern)&&Editor_Path:=FilePattern)
(!Template_Path&&Template_Path:="Template." . ahk__)
if !Instr(Template_Path, ":\")
{
  If FileExist(A_WinDir "\ShellNew")
  {
    Dnews_Path := A_WinDir "\ShellNew\" Template_Path
  }
  else
  {
    if (ahk__ = "ahk2")
      Dnews_Path := GetFullPathName(A_ScriptDir "\..\..\引用程序\2.0\UX\Templates\" Template_Path)
    else if (ahk__ = "ahk")
      Dnews_Path := GetFullPathName(A_ScriptDir "\..\..\引用程序\" Template_Path)
    else if (ahk__ = "ah2")
      Dnews_Path := GetFullPathName(A_ScriptDir "\..\..\引用程序\2.0\UX\Templates\" Template_Path)
  }
}
else
  Dnews_Path := Template_Path
;msgbox %  Dnews_Path

GuiControl,, AHK_Path , %AHK_Path%
if AHKIcon_Path
  GuiControl,, AHKIcon_Path, %AHKIcon_Path%
GuiControl,, Compiler_Path , %Compiler_Path%
GuiControl,, Editor_Path , %Editor_Path%
GuiControl,, news_Path , %Dnews_Path%
;msgbox %Dnews_Path%
if !AHKIcon_Path
{
  (!AHKIcon_Path&&FileExist(AHK_Path)&&AHKIcon_Path:=AHK_Path ",0")
  Array := StrSplit(AHKIcon_Path , ",")
  if (Array[2] < 0)
  {
    Icon_index := IndexOfIconResource(ExpandEnvVars(Array[1]), abs(Array[2]))
    ;msgbox % Icon_index
  }
  else
    Icon_index := Array[2] + 1
  GuiControl,, aico, % Array[1] ? "*Icon" Icon_index " " Array[1] : "*Icon0" " " AHKIcon_Path
}
logup("--------------------------------------------------------------")
return

jumpreg1:
f_OpenReg(RootKey "\" Subkey FileType)
return

jumpreg2:
ProgId := RegRead_("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\." ahk__ "\UserChoice", "ProgId")
if ProgId
{
  f_OpenReg(RootKey "\" ProgId)
}
return

jumpreg3:
f_OpenReg("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\." ahk__)
return

logup(value:="")
{
	global EditHwnd
	GuiControlGet, log
	GuiControl,, log , % log A_YYYY "-" A_MM "-" A_DD "-" A_Hour ":" A_Min ":" A_Sec ":" A_MSec " ：" value "`n"	
	PostMessage, 0x0115,7, 0,,ahk_id %EditHwnd%
}

RegRead_(KeyName, ValueName:="")
{
	logup("读取：" KeyName " " ValueName)
	RegRead, OutputVar, %KeyName% , %ValueName%
	if (ErrorLevel_:=ErrorLevel)
		logup("失败：" (A_IsAdmin?"":"权限不够 或 ") "注册表不存在")
	else
		logup("数据：" OutputVar)
	return OutputVar
}
RegWrite_(ValueType, KeyName, ValueName:="", Value:="")
{
	logup("写入：" ValueType ", " KeyName ", " ValueName ", " Value)
	RegWrite, %ValueType%, %KeyName%, %ValueName%, %Value%
	if (ErrorLevel_:=ErrorLevel)
		logup("失败：" (A_IsAdmin?"未知错误":"权限不够"))
	else
		logup("成功")
	return ErrorLevel_
}
RegDelete_(KeyName, ValueName:="")
{
	logup("删除：" KeyName ", " ValueName)
  if !ValueName or (ValueName="\")
  {
    KeyName := KeyName ValueName
    if KeyName in HKEY_LOCAL_MACHINE,HKEY_LOCAL_MACHINE\,HKEY_LOCAL_MACHINE\\,HKLM,HKLM\,HKLM\\,HKEY_CLASSES_ROOT,HKEY_CLASSES_ROOT\,HKEY_CLASSES_ROOT\\,HKCR,HKCR\,HKCR\\,HKEY_CURRENT_USER,HKEY_CURRENT_USER\,HKEY_CURRENT_USER\\,HKCU,HKCU\,HKCU\\
    {
      logup("失败：不能删除主键")
      return
    }
  }
	RegDelete, %KeyName%, %ValueName%
	if (ErrorLevel_:=ErrorLevel)
		logup("失败：" (A_IsAdmin?"":"权限不够 或") "注册表不存在")
	else
		logup("成功")
	return ErrorLevel_
}

; 查找 AutoHotkey 主程序
Find_AHK:
	Gui +OwnDialogs
	FileSelectFile, AHK_Path, 3, , 查找 AutoHotkey.exe, AutoHotkey.exe
	if (AHK_Path!="")
		GuiControl,,AHK_Path, %AHK_Path%
	gosub Default_Compiler
return

Find_AHKIcon:
Gui +OwnDialogs
FileSelectFile, AHKIcon_Path, 3, , 查找 AutoHotkey.exe, AutoHotkey.exe
if (AHKIcon_Path!="")
	GuiControl,,AHKIcon_Path, %AHKIcon_Path%
return

showicon:
gui, submit, nohide

Array := StrSplit(AHKIcon_Path , ",")
	if (Array[2] < 0)
	{
		Icon_index := IndexOfIconResource(ExpandEnvVars(Array[1]), abs(Array[2]))
		;msgbox % Icon_index
	}
	else
		Icon_index := Array[2] + 1
GuiControl,, aico, % Array[1] ? "*Icon" Icon_index " " Array[1] : "*Icon0" " " AHKIcon_Path
return

; 选择脚本编译器
Choose_Compiler:
	Gui +OwnDialogs
	FileSelectFile, Compiler_Path, 3, , 选择脚本编译器, 程序(*.exe)
	if (Compiler_Path!="")
		GuiControl,,Compiler_Path, %Compiler_Path%
return

; 默认脚本编译器
Default_Compiler:
GuiControlGet, AHK_Path
SplitPath, AHK_Path, ,AHK_Dir
IfExist, %AHK_Dir%\Compiler\Ahk2Exe.exe
{
	Compiler_Path=%AHK_Dir%\Compiler\Ahk2Exe.exe
	GuiControl,, Compiler_Path, %Compiler_Path%
}
return

; 选择脚本编辑器
Choose_Editor:
	Gui +OwnDialogs
	FileSelectFile, Editor_Path, 3, , 选择脚本编辑器, 程序(*.exe)
	if (Editor_Path!="")
		GuiControl,,Editor_Path, %Editor_Path%
return

; 默认脚本编辑器
Default_Editor:
GuiControlGet, AHK_Path
SplitPath, AHK_Path,, AHK_Dir
IfExist, %AHK_Dir%\SciTE\SciTE.exe
  Editor_Path=%AHK_Dir%\SciTE\SciTE.exe
else ifExist, %A_WinDir%\system32\notepad.exe
  Editor_Path = %A_WinDir%\system32\notepad.exe
GuiControl,, Editor_Path, %Editor_Path%
return

; 设置
Install:
	Gui, Submit, NoHide
	logup("写入注册表")
	IfNotExist, %AHK_Path%
	{
		logup("AutoHotkey 路径错误 ！")
		MsgBox, % 4096+16, , AutoHotkey 路径错误 ！`n%AHK_Path%
		return
	}
  RegWrite_("REG_SZ", RootKey "\" Subkey "." ahk__,, FileType)
  RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell",, "Open")
  ;RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Open",, "运行脚本(&O)")
  RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Open","Icon", """" AHK_Path """")
  RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Open\Command",, """" AHK_Path """ ""%1"" %*")
  ; 能拖放文件到脚本
  RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\ShellEx\DropHandler",, "{86C86720-42A0-1069-A2E8-08002B30309D}")

  if AHKIcon_Path   ; 设置了图标路径才会使用自定义图标
  {
    RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\DefaultIcon",, AHKIcon_Path)
  }
	if State__3     ; 编译
	{
		IfNotExist, %Compiler_Path%
		{
			logup("编译器路径错误 ！")
			MsgBox, % 4096+16, , 编译器路径错误 ！
			return
		}
		RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Compile",, "编译脚本")
		RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Compile","Icon", """" Compiler_Path """")
		IfInString, Compiler_Path, Ahk2Exe.exe
			RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Compile\Command",, """" Compiler_Path """ /in ""%1""")
		else
			RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Compile\Command",, """" Compiler_Path """ ""%1""")
	}
	;else
		;RegDelete_(RootKey "\" Subkey "\" FileType "\Shell\Compile")
	if State__4     ; 编译 Gui
	{
		IfNotExist, %Compiler_Path%
		{
			logup("编译器路径错误 ！")
			MsgBox, % 4096+16, , 编译器路径错误 ！
			return
		}
		RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Compile-Gui",, "编译脚本<GUI>")
		RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Compile-Gui","Icon", """" Compiler_Path """")
		IfInString, Compiler_Path, Ahk2Exe.exe
			RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Compile-Gui\Command",, """" Compiler_Path """ /gui /in ""%1""")
		else
			RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Compile-Gui\Command",, """" Compiler_Path """ /gui ""%1""")
	}
	;else
		;RegDelete_(RootKey "\" Subkey "\" FileType "\Shell\Compile-Gui")
	if State__5    ; 编辑脚本
	{
		IfNotExist, %Editor_Path%
		{
			logup("编辑器路径错误 ！")
			MsgBox, % 4096+16, , 编辑器路径错误 ！
			return
		}
		RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Edit",, "编辑脚本(&E)")
		RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Edit","Icon", """" Editor_Path """")
		RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Edit\Command",, """" Editor_Path """ ""%1""")
	}
	;else
		;RegDelete_(RootKey "\" Subkey "\" FileType "\Shell\Edit")
	
	if State__6      ; 右键新建脚本
	{
    RegWrite_("REG_SZ", RootKey "\" Subkey "." ahk__ "\ShellNew", "FileName", news_Path)
		IfNotExist, %News_Path%
			gosub Create_Template
		RegWrite_("REG_SZ", RootKey "\" Subkey FileType,, "AutoHotkey " ahk__ " 脚本")
	}
	;else
		;RegWrite_("REG_SZ", RootKey "\" Subkey FileType)
	if State__7
	{
		RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Runas", "HasLUAShield")
		RegWrite_("REG_SZ", RootKey "\" Subkey FileType "\Shell\Runas\Command",, """" AHK_Path """ ""%1"" %*")
	}
	;else
		;RegDelete_(RootKey "\" Subkey "\" FileType "\Shell\runas")
	logup("设置完毕 ！")
	logup("--------------------------------------------------------------")
  DllCall("shell32\SHChangeNotify", "uint", 0x08000000, "uint", 0, "int", 0, "int", 0) ; SHCNE_ASSOCCHANGED
	MsgBox, % 4096+64, , 设置完毕 ！
return

Default_Ahk:
gui, submit, nohide
fileappend,, %tmp_folder%\1.%ahk__%
sleep 300
run properties %tmp_folder%\1.%ahk__%
sleep 300
WinActivate 1.%ahk__% 属性 ahk_class #32770
send c
sleep 300 
loop
{
  Process, Exist, OpenWith.exe
  ;tooltip % ErrorLevel
  if ErrorLevel
    sleep 100
  else
  {
    WinClose, 1.%ext% 属性 ahk_class #32770
    gosub, Options__
    break
  }
}
return

; 编辑脚本模板
Edit_Template:
	GuiControlGet, Editor_Path
  GuiControlGet, news_Path

	If !FileExist(news_Path)
		gosub Create_Template
IfExist, %news_Path%
{
	ifExist, %Editor_Path%
    Run, *RunAs "%Editor_Path%" "%news_Path%"
	else
		Run, *RunAs notepad.exe "%news_Path%"
}
return

; 新建脚本模板
Create_Template:
	if (ahk__ = "ahk")
		txt:="#NoEnv`r`nSendMode Input`r`nSetWorkingDir %A_ScriptDir%`r`n"
	if (ahk__ = "ahk2" || ahk__ = "ah2")
		txt:="#Requires AutoHotkey v2.0`r`nSendMode ""Input""`r`nSetWorkingDir A_ScriptDir`r`n"
	FileAppend, %txt%, %news_Path%, UTF-8
	IfNotExist, %news_Path%
		MsgBox, % 4096+64, , 无法创建脚本模板 %news_Path%！`n`n请尝试使用管理员权限运行本工具。
return

; 从注册表值字符串中提取路径
PathGetPath(pSourceCmd)
{
	local Path, ArgsStartPos = 0
	if (SubStr(pSourceCmd, 1, 1) = """")
		Path := SubStr(pSourceCmd, 2, InStr(pSourceCmd, """", False, 2) - 2)
	else
	{
		ArgsStartPos := InStr(pSourceCmd, " ")
		if ArgsStartPos
			Path := SubStr(pSourceCmd, 1, ArgsStartPos - 1)
		else
			Path = %pSourceCmd%
	}
	return Path
}

Default_news:
if (ahk__ = "ahk2")
  Dnews_Path := GetFullPathName(A_ScriptDir "\..\..\引用程序\2.0\UX\Templates\Template." ahk__)
else if (ahk__ = "ahk")
  Dnews_Path := GetFullPathName(A_ScriptDir "\..\..\引用程序\Template." ahk__)
GuiControl, , news_Path , %Dnews_Path%
return

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}

ExpandEnvVars(string){
   ; Find length of dest string:
   nSize := DllCall("ExpandEnvironmentStrings", "Str", string, "Str", NULL, "UInt", 0, "UInt")
  ,VarSetCapacity(Dest, size := (nSize * (1 << !!A_IsUnicode)) + !A_IsUnicode) ; allocate dest string
  ,DllCall("ExpandEnvironmentStrings", "Str", string, "Str", Dest, "UInt", size, "UInt") ; fill dest string
   return Dest
}

IndexOfIconResource(Filename, ID)
{
    hmod := DllCall("GetModuleHandle", "str", Filename, "ptr")
    ; If the DLL isn't already loaded, load it as a data file.
    loaded := !hmod
        && hmod := DllCall("LoadLibraryEx", "str", Filename, "ptr", 0, "uint", 0x2, "ptr")
    
    enumproc := RegisterCallback("IndexOfIconResource_EnumIconResources","F")
    param := {ID: ID, index: 0, result: 0}
    
    ; Enumerate the icon group resources. (RT_GROUP_ICON=14)
    DllCall("EnumResourceNames", "ptr", hmod, "ptr", 14, "ptr", enumproc, "ptr", &param)
    DllCall("GlobalFree", "ptr", enumproc)
    
    ; If we loaded the DLL, free it now.
    if loaded
        DllCall("FreeLibrary", "ptr", hmod)
    
    return param.result
}

IndexOfIconResource_EnumIconResources(hModule, lpszType, lpszName, lParam)
{
    param := Object(lParam)
    param.index += 1

    if (lpszName = param.ID)
    {
        param.result := param.index
        return false    ; break
    }
    return true
}

f_OpenReg(RegPath)
{
	RegPath:=LTrim(RegPath, "[")
	RegPath:=RTrim(RegPath, "]")
	StringLeft, RegPathFirst4, RegPath, 4
	if RegPathFirst4 = HKCR
		StringReplace, RegPath, RegPath, HKCR, HKEY_CLASSES_ROOT
	else if RegPathFirst4 = HKCU
		StringReplace, RegPath, RegPath, HKCU, HKEY_CURRENT_USER
	else if RegPathFirst4 = HKLM
		StringReplace, RegPath, RegPath, HKLM, HKEY_LOCAL_MACHINE
	else if RegPathFirst4 = HKCC
		StringReplace, RegPath, RegPath, HKCC, HKEY_CURRENT_CONFIG
	else if RegPathFirst4 = HKU
		StringReplace, RegPath, RegPath, HKU, HKEY_USERS

	; 将字串中的前两个"＿"(全角) 替换为“_"(半角)
	StringReplace, RegPath, RegPath, ＿, _
	StringReplace, RegPath, RegPath, ＿, _
	; 替换字串中第一个“, ”为"\"
	StringReplace, RegPath, RegPath, `,%A_Space%, \
	; 替换字串中第一个“,”为"\"
	StringReplace, RegPath, RegPath, `,, \
	; 将字串中的所有"/" 替换为“\"
	StringReplace, RegPath, RegPath, /, \, All
	; 将字串中的所有"／"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ／, \, All
	; 将字串中的所有"＼"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ＼, \, All
	StringReplace, RegPath, RegPath, %A_Space%\, \, All
	StringReplace, RegPath, RegPath, \%A_Space%, \, All
	; 将字串中的所有“\\”替换为“\”
	StringReplace, RegPath, RegPath, \\, \, All

	RegRead, MyComputer, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey
	f_Split2(MyComputer, "\", MyComputer, aaa)
	MyComputer := MyComputer ? MyComputer : (A_OSVersion="WIN_XP")?"我的电脑":"计算机"
	IfNotInString, RegPath, %MyComputer%\
		RegPath := MyComputer "\" RegPath
	;tooltip % RegPath

	IfWinExist, ahk_class RegEdit_RegEdit
	{
		RunWait, % "cmd.exe /c taskkill /IM regedit.exe", , Hide
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe
	}
	Else
	{
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe ;-m
	}
return
}

f_Split2(String, Seperator, ByRef LeftStr, ByRef RightStr)
{
	SplitPos := InStr(String, Seperator)
	if SplitPos = 0 ; Seperator not found, L = Str, R = ""
	{
		LeftStr := String
		RightStr:= ""
	}
	else
	{
		SplitPos--
		StringLeft, LeftStr, String, %SplitPos%
		SplitPos++
		StringTrimLeft, RightStr, String, %SplitPos%
	}
	return
}