;|2.9|2024.12.12|1333
#Include <File_GetEncoding>
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\f17f.ico"
CandySel :=  A_Args[1]
;CandySel := "C:\Documents and Settings\Administrator\Desktop\新建文件夹"
Gui, Add, Text, x10 y15 h25, 查找文件夹:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vsfolder, % CandySel
;Gui, Add, Button, xp+560 yp w60 h25 gloadfolder, 载入

Gui, Add, Text, x10 yp+40, 指定扩展名:
Gui, Add, Edit, xp+80 yp-2 w550 vsExt, % "txt,ahk,md"
Gui, Add, Text, x10 yp+32, 命令类型:
Gui, Add, ComboBox, xp+80 yp-5 w550 h90 vcommand gupdateparam, 查找替换||文首添加一行|文末添加一行|文首删除一行|文末删除一行|删除包含指定字符的行
Gui, Add, Button, xp+560 yp-2 w60 gruncommand, 执行命令

gui, add, Text, x10 yp+38 w80 vmyparam1, 查找字符:
gui, add, Edit, xp+80 yp-3 w550 vmyedit1 r3, 
gui, add, Text, x10 yp+60 w80 vmyparam2, 替换字符:
gui, add, Edit, xp+80 yp w550 vmyedit2 r3,
Gui, Add, CheckBox, x10 yp+60 vzhuanyi h30, 对参数中的 \r, \n, \t 进行转义
Gui, Add, CheckBox, xp+240 yp vregex h30, 使用正则替换

Gui, Add, ListView, x10 yp+40 w700 h500 vfilelist Checked hwndHLV AltSubmit Grid, 文件名|相对路径|扩展名|大小(KB)|修改时间|替换次数|完整路径
Gui, Add, Button, xp yp+510 w60 h30 guncheckall, 全不选
Gui, Add, Button, xp+70 yp w60 h30 gEditfilefromlist, 编辑文件
Gui, Add, Button, xp+70 yp w60 h30 gopenfilefromlist, 打开文件
Gui, Add, Button, xp+70 yp w60 h30 gopenfilepfromlist, 打开路径

gui, Show,, 文件夹中文本文件批量操作
Return

;loadfolder:
;Return

updateparam:
Gui Submit, nohide
if (command = "查找替换")
{
	commmode("查找字符:", "替换字符:", "enable", "enable")
}
if (command = "文首添加一行") or (command = "文末添加一行")
{
	commmode("新增行字符:", "参数2:", "enable", "disable")
}
Return

commmode(p1:="参数1:", p2:="参数2:", st1:="Disable", st2:="Disable")
{
	GuiControl,, myparam1, % p1
	GuiControl,, myparam2, % p2
	GuiControl,, myedit1, `n
	GuiControl,, myedit2, `n
	GuiControl, % st1, myedit1
	GuiControl, % st2, myedit2
}

uncheckall:
LV_Modify(0, "-check")
return

Editfilefromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 7)
}
run notepad  %Tmp_file%
return

openfilefromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 7)
}
run %Tmp_file%
return

openfilepfromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 7)
}
SplitPath, Tmp_file,, OutDir
Run, %OutDir%
;Run, explorer.exe /select`, %Tmp_file%
return

runcommand:
gui, Submit, NoHide
LV_Delete()

myedit1 := StrReplace(myedit1, "`n", "`r`n")
myedit2 := StrReplace(myedit2, "`n", "`r`n")
if zhuanyi
{
	myedit1 := StrReplace(myedit1, "\r", "`r")
	myedit1 := StrReplace(myedit1, "\n", "`n")
	myedit1 := StrReplace(myedit1, "\t", "`t")
	myedit2 := StrReplace(myedit2, "\r", "`r")
	myedit2 := StrReplace(myedit2, "\n", "`n")
	myedit2 := StrReplace(myedit2, "\t", "`t")
}

Loop, Files, %sfolder%\*.*, FR
{
	if A_LoopFileSize = 0
		continue
	if sExt
	{
		if A_LoopFileExt not in %sExt%
			continue
	}
	FileEncoding % File_GetEncoding(A_LoopFileFullPath)
	Try FileRead, OMatchRead, % A_LoopFileFullPath
	if (command = "查找替换")
	{
    if !regex
    {
      StringReplace, MatchRead, OMatchRead, %myedit1%, %myedit2%, UseErrorLevel
      repalcecount := ErrorLevel
    }
    else
    {
      MatchRead := RegExReplace(OMatchRead, myedit1, myedit2, repalcecount)
    }
		;if instr(OMatchRead, myedit1)
			;msgbox
	}
  else if (command = "删除包含指定字符的行")
  {
    MatchRead := RegExReplace(OMatchRead, "m)^(.*?)" myedit1 "(.*?)\R", , repalcecount)
    ;msgbox % MatchRead
  }
	else if (command = "文首添加一行")
		MatchRead := myedit1 "`r`n" OMatchRead
	else if (command = "文首删除一行")
	{
		MatchRead := trim(OMatchRead, " `t`n`r")
		Loop, parse, MatchRead, `n, `r
		{
			firstline := A_LoopField
			break
		}
		StringReplace, MatchRead, MatchRead, %firstline%
		StringReplace, MatchRead, MatchRead, `r`n
	}
	else if (command = "文末添加一行")
		MatchRead := OMatchRead "`r`n" myedit1
	else if (command = "文末删除一行")
	{
		MatchRead := trim(OMatchRead, " `t`n`r")
		RegExMatch(MatchRead, "`am)^.*\Z", lastline)
		StringReplace, MatchRead, MatchRead, %lastline%
		MatchRead := trim(MatchRead, " `t`n`r")
	}
	if (OMatchRead != MatchRead)
	{
		MyFileObj := FileOpen(A_LoopFileFullPath, "w")
		MyFileObj.Write(MatchRead)
		MyFileObj.Close()
	}

	if ((command = "查找替换") or (command = "删除包含指定字符的行"))&& repalcecount
		LV_Add("", A_LoopFileName, StrReplace(StrReplace(A_LoopFilePath, sfolder), A_LoopFileName), A_LoopFileExt, Ceil(A_LoopFileSize / 1024), A_LoopFileTimeModified, repalcecount, A_LoopFilePath)
	else
		LV_Add("", A_LoopFileName, StrReplace(StrReplace(A_LoopFilePath, sfolder), A_LoopFileName), A_LoopFileExt, Ceil(A_LoopFileSize / 1024), A_LoopFileTimeModified, 0, A_LoopFilePath)
}
LV_ModifyCol(1, 200)
LV_ModifyCol(2, 250)
LV_ModifyCol(3, 60)
LV_ModifyCol(4, 60)
LV_ModifyCol(5, 110)
LV_ModifyCol(6, 60)
Return

GuiClose:
Guiescape:
Gui Destroy
Gui, GuiText: Destroy
exitapp
Return

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	Return
}

MCode(ByRef code, hex) 
{ ; allocate memory and write Machine Code there
	VarSetCapacity(code, 0) 
	VarSetCapacity(code, StrLen(hex)//2+2)
	Loop % StrLen(hex)//2 + 2
		NumPut("0x" . SubStr(hex, 2*A_Index-1, 2), code, A_Index-1, "Char")
}

PathU(Filename) { ;  PathU v0.91 by SKAN on D35E/D68M @ tiny.cc/pathu
Local OutFile
  VarSetCapacity(OutFile, 520)
  DllCall("Kernel32\GetFullPathNameW", "WStr",Filename, "UInt",260, "Str",OutFile, "Ptr",0)
  DllCall("Shell32\PathYetAnotherMakeUniqueName", "Str",OutFile, "Str",Outfile, "Ptr",0, "Ptr",0)
Return A_IsUnicode ? OutFile : StrGet(&OutFile, "UTF-16")
}