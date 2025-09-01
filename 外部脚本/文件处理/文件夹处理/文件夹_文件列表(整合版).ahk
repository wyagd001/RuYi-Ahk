;|2.8|2024.09.20|1297
#Include <AutoXYWH>
CandySel := A_Args[1]

Gui,66: Destroy
Gui,66: Default
Gui, +Resize
Gui, Add, text, x10 y10, 文件夹:
Gui, Add, edit, xp+70 y10 w550 h25 vfolder1, % CandySel
Gui, Add, Button, xp+560 yp h25 gfolderfilelist default, 文件列表
Gui, Add, text, x10 yp+40, 排序选项:
Gui, Add, DropDownList, xp+70 yp-3 w80 h120 vlistordermode, 默认||创建日期|修改日期|文件大小
Gui, Add, DropDownList, xp+90 yp w80 h60 vlistorderR, 升序||降序
Gui, Add, CheckBox, xp+90 yp h30 vdelfolderpath gdelfolderpath, 只显示相对路径(删除文件夹的路径)
Gui, Add, Edit, x10 yp+40 Multi readonly w690 r20 vmyedit
Gui, Show, AutoSize, 文件夹文件列表
sleep 300
if CandySel
	Gosub folderfilelist
return

folderfilelist:
Gui,66: Default
Gui, Submit, NoHide
Gtext := getfolderfilelist(folder1, listordermode, listorderR)
if delfolderpath
	Gtext := StrReplace(Gtext, CandySel "\")
GuiControl,, myedit, %Gtext%
Gtext := ""
Return

delfolderpath:
Gui,66: Default
Gui, Submit, NoHide
if delfolderpath
{
	Gtext := StrReplace(myedit, CandySel "\")
}
else
{
	Gtext := ""
	Loop, parse, myedit, `n, `r
	{
		line_str := CandySel "\" A_LoopField
		Gtext .= line_str "`r`n"
	}

}
GuiControl,, myedit, %Gtext%
return

getfolderfilelist(sfolder, optionmode := "", optionR := "")
{
	optstr2 := 0
	if (optionmode = "默认")
	{
		Loop, Files, %sfolder%\*.*, DFR  ; 包含文件
		{
			tmp_Str .= A_LoopFileLongPath "`n"
			if (A_index > 500)
				break
		}
	}
	Else if (optionmode = "创建日期")
	{
		Loop, Files, %sfolder%\*.*, DFR  ; 包含文件
		{
			tmp_Str .= A_LoopFileTimeCreated "`t" A_LoopFileLongPath "`n"
			if (A_index > 500)
				break
		}
	}
	Else if (optionmode = "修改日期")
	{
		Loop, Files, %sfolder%\*.*, DFR  ; 包含文件
		{
			tmp_Str .= A_LoopFileTimeModified "`t" A_LoopFileLongPath "`n"
			if (A_index > 500)
				break
		}
	}
	Else if (optionmode = "文件大小")
	{
		Loop, Files, %sfolder%\*.*, DFR  ; 包含文件
		{
			tmp_Str .= A_LoopFileSize "`t" A_LoopFileLongPath "`n"
			if (A_index > 500)
				break
		}
		optstr2 := 1
	}

	if !optstr2 
	{
		if (optionR = "升序")
			Sort, tmp_Str
		Else if (optionR = "降序")
			Sort, tmp_Str, R
	}
	if optstr2 
	{
		if (optionR = "升序")
			Sort, tmp_Str, N
		Else if (optionR = "降序")
			Sort, tmp_Str, N R
	}

	if (optionmode = "默认")
		Return tmp_Str
	Loop, Parse, tmp_Str, `n
	{
		if (A_LoopField = "")  ; 忽略列表末尾的最后一个换行符(空项).
			continue
		StringSplit, FileItem, A_LoopField, %A_Tab%  ; 用 tab 作为分隔符将其分为两部分.
		FileList .= FileItem2 "`n"
	}
	Return FileList
}

66GuiClose:
66Guiescape:
Gui, 66: Destroy
exitapp

66GuiSize:
If (A_EventInfo = 1) ; The window has been minimized.
	Return
AutoXYWH("wh", "myedit")
return