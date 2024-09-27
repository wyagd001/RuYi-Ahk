;|2.8|2024.09.22|1xxx
;CandySel := A_Args[1]

CandySel := "C:\Documents and Settings\Administrator\Desktop\Ahk\如意百宝箱\外部脚本\文件处理"
folder1 := CandySel
IniRead, notepad2, %A_ScriptDir%\..\..\..\配置文件\如一.ini, 其他程序, notepad2, Notepad.exe
if InStr(notepad2, "%A_ScriptDir%")
{
	RY_Dir := Deref("%A_ScriptDir%")
	RY_Dir := SubStr(RY_Dir, 1, InStr(RY_Dir, "\", 0, 0, 3) - 1)
	notepad2 := StrReplace(notepad2, "%A_ScriptDir%", RY_Dir)
	notepad2 := FileExist(notepad2) ? notepad2 : "notepad.exe"
	;msgbox % notepad2
}

ListFolder:
Gui,66: Destroy
Gui,66: Default

Gui, Add, text, x10 y10, 源文件夹:
Gui, Add, edit, xp+80 yp w580 h40 r2 vfolder1, % folder1
Gui, Add, Button, xp+590 yp h25 gloderfolder, 加载列表
Gui, Add, Button, xp+70 yp h25 gopenfolder1, 打开

Gui, Add, Text, x10 yp+50 h25, 文件名:
Gui, Add, Edit, xp+80 yp-5 w140 h25 vfilterName,
Gui, Add, Text, xp+150 yp+5 w50 h25 , 扩展名:
Gui, Add, Edit, xp+60 yp-5 w140 h25 vfilterExt,
Gui, Add, Text, xp+150 yp+5 w70 h25 , 文件内容:
Gui, Add, Edit, xp+80 yp-5 w140 h25 vfilterContext,
Gui, Add, Button, xp+150 yp w60 h25 gofilter, 筛选

Gui, Add, text, x10 yp+40, 目标文件夹:
Gui, Add, edit, xp+80 yp w580 h25 vfolder2, % folder2
Gui, Add, Button, xp+590 yp h25 w60 gselfolder2, ...
Gui, Add, Button, xp+70 yp h25 gopenfolder2, 打开

Gui, Add, ListView, x10 yp+40 w750 h500 vfilelist1 hwndHLV1 Checked AltSubmit glvsort, 序号|文件名|修改日期|大小|文件类型|创建日期|找到次数
Gui, Add, ComboBox, xp+760 yp w80 vSelFun gSelFun, 复制列表||复制到|剪切到|删除|按个数分割|合并分割文件|按字节分割(2个)|转换编码*|文本合并*|纠正扩展名*
Gui, Add, ComboBox, xp yp+28 w80 vFunpara, 带源文件夹||不带源文件夹
Gui, Add, Button, xp yp+28 w80 grpview, 预览结果
Gui, Add, Button, xp yp+28 w80 gRunfun, 执行

Gui, Add, Button, x10 yp+425 w60 gcheckallfile, 全选
Gui, Add, Button, xp+70 yp w60 guncheckallfile, 全不选
Gui, Add, Button, xp+70 yp w60 gEditFile, 编辑文件
Gui, Add, Button, xp+70 yp w60 gopenfilefromlist, 打开文件
Gui, Add, Button, xp+70 yp w60 gopenfilepfromlist, 打开路径

gui, show,, 文件夹管理器
Menu, Tray, UseErrorLevel
Menu, filelistMenu, deleteall
Menu, filelistMenu, Add, 全选, checkallfile
Menu, filelistMenu, Add, 全不选, uncheckallfile
Menu, filelistMenu, Add, 全选同级, checkSameFolderall
Menu, filelistMenu, Add, 全不选同级, uncheckSameFolderall
Menu, filelistMenu, Add, 下一个选中, jumpcheckedfile
Menu, filelistMenu, Add, 从列表删除, delfillefromlist
Menu, filelistMenu, Add
Menu, filelistMenu, Add, 打开, openfilefromlist
Menu, filelistMenu, Add, 打开路径, openfilepfromlist
Menu, filelistMenu, Add, 编辑文件, editfilefromlist
Menu, filelistMenu, Add, 属性, ContextProperties
;if folder1
	;gosub loderfolder
return

openfolder1:
Gui, 66: Default
Gui, submit, nohide
if folder1
	run % folder1
Return

openfolder2:
Gui, 66: Default
Gui, submit, nohide
if folder2
	run % folder2
Return

selfolder2:
SelectedFolder := SelectFolderEx(A_desktop, 请选择一个文件夹)
if !(SelectedFolder = "")
GuiControl,, folder2, %SelectedFolder%
return

lvsort:
Gui, 66: Default
if (A_GuiEvent = "ColClick")
LV_SortArrow(HLV1, A_EventInfo)
Return

ofilter:
loderfolder:
Gui, 66: Default
Gui, submit, nohide
;tooltip % "正在载入文件夹, 请稍候..."
Gui, ListView, filelist1
LV_Delete()

filelistObj := {}
Tmp_Str:=""
SearchStop := 0

if !folder1 or !fileexist(folder1)
	return
ToltalSize := 0
Loop, Files, %folder1%\*.*, DFR
{
	if A_LoopFileAttrib contains H,R,S
	{
		if !InStr(A_LoopFileAttrib, "D")    ; 只跳过文件, 文件夹不跳过只读属性
			continue
	}
	if filterContext
	{
		if A_LoopFileExt in txt,ahk,au3,htm,json,md
			FileEncoding % File_GetEncoding(A_LoopFileFullPath)
		Try FileRead, MatchRead, % A_LoopFileFullPath   ;  utf8  编码的问题
		IfEqual, SearchStop, 1, Break
		StringReplace, MatchRead, MatchRead, % filterContext, % filterContext, UseErrorLevel
		findstrcount := ErrorLevel
		IfEqual, ErrorLevel, 0, Continue
	}

	relativePS := StrReplace(A_LoopFilePath, folder1 "\")
	filelistObj[relativePS] := {}
	filelistObj[relativePS]["filter"] := findstrcount
	if (SelFun = "转换编码*") or (SelFun = "文本合并*")
	{
		if InStr(A_LoopFileAttrib, "D")
			filelistObj[relativePS]["EnCode"] := ""
		else
		{
			fileEnCode := File_GetEncoding(A_LoopFileFullPath)
			filelistObj[relativePS]["EnCode"] := fileEnCode
		}
	}
	else if (SelFun = "纠正扩展名*")
	{
		if InStr(A_LoopFileAttrib, "D")
			filelistObj[relativePS]["EnExt"] := ""
		else
		{
			fileEnExt := File_GetExt(A_LoopFileFullPath)
			filelistObj[relativePS]["EnExt"] := fileEnExt
		}
	}
	FormatTime, Out_time, % A_LoopFileTimeModified, yyyy-M-d H:m
	filelistObj[relativePS]["MDT"] := Out_time
	FormatTime, Out_time, % A_LoopFileTimeCreated, yyyy-M-d H:m
	filelistObj[relativePS]["CT"] := Out_time
	if InStr(A_LoopFileAttrib, "D")
		filelistObj[relativePS]["Type"] := "文件夹"
	else
		filelistObj[relativePS]["Type"] := A_LoopFileExt
	filelistObj[relativePS]["BSize"] := A_LoopFileSize
	ToltalSize += A_LoopFileSize
	if (A_LoopFileSize = 0)   ; 大小为 0 的文件
		filelistObj[relativePS]["KBSize"] := 0
	else if (A_LoopFileSize < 1024) && (A_LoopFileSize != 0)   ; 1 kb 大小的文件
		filelistObj[relativePS]["KBSize"] := 1
	else
		filelistObj[relativePS]["KBSize"] := Ceil(A_LoopFileSize / 1024)
}
GuiControl, -redraw, filelist1

f_index := 0
for k,v in filelistObj
{
	if instr(k, filterName) && (filterExt ? instr(filterExt, v["Type"]) : 1)
	{
		f_index ++
		if (SelFun = "转换编码*") or (SelFun = "文本合并*")
			sevenVal := v["EnCode"]
		else if (SelFun = "纠正扩展名*")
			sevenVal := v["EnExt"]
		else if filterContext
			sevenVal := v["filter"]   ; 查找字符串
		else
			sevenVal := Format("{:.4f}", v["BSize"] * 100 / ToltalSize) "%"
		if (SelFun = "纠正扩展名*") && v["EnExt"] && (v["Type"] != v["EnExt"])
			LV_Add("check", f_index, k, v["MDT"], v["KBSize"], v["Type"], v["CT"], sevenVal)
		else
			LV_Add("", f_index, k, v["MDT"], v["KBSize"], v["Type"], v["CT"], sevenVal)
	}
}

	LV_ModifyCol()
	LV_ModifyCol(1, "Logical")
	LV_ModifyCol(2, 300)
	LV_ModifyCol(3, "Logical")
	LV_ModifyCol(4, "Logical")
	LV_ModifyCol(4, 50)
	LV_ModifyCol(5, 50)
	LV_ModifyCol(6, "Logical")

GuiControl, +redraw, filelist1

;CF_ToolTip("载入完成", 3000)
WinActivate, 文件夹列表 ahk_class AutoHotkeyGUI
return

SelFun:
Gui,66: Default
gui, Submit, NoHide
GuiControl,, Funpara, |
if (SelFun = "复制列表")
{
	GuiControl,, Funpara, 带源文件夹||不带源文件夹
}
else if (SelFun = "复制到")
{
	GuiControl,, Funpara, 带结构复制||复制到同一层
}
else if (SelFun = "剪切到")
{
	GuiControl,, Funpara, 带结构移动||移动到同一层
}
else if (SelFun = "删除")
{
	GuiControl,, Funpara, 回收站||永久删除
}
else if (SelFun = "按个数分割")
{
	GuiControl,, Funpara, 2||3
}
else if (SelFun = "转换编码*")
{
	GuiControl,, Funpara, ANSI(CP936)|UTF-8 Raw|UTF-8 BOM||Unicode(UTF16)
}
return

Runfun:
Gui,66: Default
gui, Submit, NoHide
DelArr := []
if (SelFun = "复制列表")
{
	Tmp_Str := ""
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		if (Funpara = "带源文件夹")
			Tmp_Str .= folder1 "\" relPath "`n"
		else if (Funpara = "不带源文件夹")
			Tmp_Str .= relPath "`n"
	}
	clipboard := Tmp_Str
}
else if (SelFun = "复制到")
{
	if !folder2 or !fileexist(folder2)
	{
		msgbox 目标文件夹为空或不存在, 请设置目标文件夹!
		return
	}
	if (Funpara = "带结构复制")
	{
		RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
		Loop
		{
			RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
			if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
				break
			LV_GetText(relPath, RowNumber, 2)
			sour_filepath := folder1 "\" relPath
			targ_filepath := folder2 "\" relPath
			SplitPath, targ_filepath,, OutDir
			if (filelistObj[relPath]["Type"] = "文件夹")
				FileCreateDir, %targ_filepath%
			else
			{
				if !InStr(FileExist(OutDir), "D") && (OutDir != folder2)
					FileCreateDir, %OutDir%
				FileCopy, %sour_filepath%, %targ_filepath%
			}
		}
	}
	else if (Funpara = "复制到同一层")
	{
		RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
		Loop
		{
			RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
			if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
				break
			LV_GetText(relPath, RowNumber, 2)
			sour_filepath := folder1 "\" relPath
			FileCopy, %sour_filepath%, %folder2%
		}
	}
}
else if (SelFun = "剪切到")
{
	if !folder2 or !fileexist(folder2)
	{
		msgbox 目标文件夹为空或不存在, 请设置目标文件夹!
		return
	}
	if (Funpara = "带结构移动")
	{
		RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
		Loop
		{
			RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
			if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
				break
			LV_GetText(relPath, RowNumber, 2)
			sour_filepath := folder1 "\" relPath
			targ_filepath := folder2 "\" relPath
			SplitPath, targ_filepath,, OutDir
			if (filelistObj[relPath]["Type"] = "文件夹")
				FileCreateDir, %targ_filepath%
			else
			{
				if !InStr(FileExist(OutDir), "D") && (OutDir != folder2)
					FileCreateDir, %OutDir%
				FileMove, %sour_filepath%, %targ_filepath%
				if !ErrorLevel
					DelArr.push(RowNumber)
			}
		}
	}
	else if (Funpara = "移动到同一层")
	{
		RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
		Loop
		{
			RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
			if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
				break
			LV_GetText(relPath, RowNumber, 2)
			sour_filepath := folder1 "\" relPath
			if (filelistObj[relPath]["Type"] != "文件夹")
			{
				FileMove, %sour_filepath%, %folder2%
				if !ErrorLevel
					DelArr.push(RowNumber)
			}
		}
	}
	loop % DelArr.Count()
	{
		RowNumber := DelArr.Pop()
		LV_Delete(RowNumber)
	}
	DelArr := []
	LV_RowIndexOrder()
}
else if (SelFun = "删除")
{
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		sour_filepath := folder1 "\" relPath
		if (filelistObj[relPath]["Type"] != "文件夹")
		{
			if (Funpara = "回收站")
				FileRecycle, %sour_filepath%
			else if (Funpara = "永久删除")
				FileDelete, %sour_filepath%
			if !ErrorLevel
				DelArr.push(RowNumber)
		}
	}
	loop % DelArr.Count()
	{
		RowNumber := DelArr.Pop()
		LV_Delete(RowNumber)
	}
	DelArr := []
	LV_RowIndexOrder()
}
else if (SelFun = "按个数分割")
{
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		sour_filepath := folder1 "\" relPath
    sour_fileSize := filelistObj[relPath]["BSize"]
    SplitPath, sour_filepath, CandySel_FileName, CandySel_ParentPath
    FegeSize := Ceil(sour_fileSize / Funpara)
    ;msgbox % sour_fileSize "|" FegeSize
    FegeLastSize := sour_fileSize - FegeSize * (Funpara - 1)
    File := FileOpen(sour_filepath, "r")
    loop % Funpara
    {
      zwj_filepath := CandySel_ParentPath "\" CandySel_FileName ".00" A_index
      file_zwj := FileOpen(zwj_filepath, "rw")
      if (A_Index < Funpara)
      {
        if (A_index = 1)
          File.Pos := 0
        File.RawRead(Var, FegeSize)
        File_zwj.RawWrite(Var, FegeSize)
      }
      else if (A_Index = Funpara)
      {
        File.RawRead(Var, FegeLastSize)
        File_zwj.RawWrite(Var, FegeLastSize)
      }
      File_zwj.Close()
    }
    File.Close()
    ;
    Break
	}
}
else if (SelFun = "合并分割文件")
{
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		sour_filepath := folder1 "\" relPath
    sour_filepath := SubStr(sour_filepath, 1, -4)
    SplitPath, sour_filepath, CandySel_FileName, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt
    targetFile := CandySel_ParentPath "\" CandySel_FileNameNoExt "_合并." CandySel_Ext
    File := FileOpen(targetFile, "rw")
    break
  }
  RowNumber := 0
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		sour_filepath := folder1 "\" relPath
    ;msgbox % sour_filepath
    sourFile := FileOpen(sour_filepath, "r")
    sourFile.Pos := 0
    sourFile.RawRead(Var, sourFile.Length)
    File.RawWrite(Var, sourFile.Length)
    sourFile.Close()
    Var := ""
  }
  File.Close()
}
else if (SelFun = "按字节分割(2个)")
{
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		sour_filepath := folder1 "\" relPath
    sour_fileSize := filelistObj[relPath]["BSize"]
    SplitPath, sour_filepath, CandySel_FileName, CandySel_ParentPath
    if (Funpara > 0)
    {
      FegeFirstSize := Funpara
      FegeLastSize := sour_fileSize - Funpara
    }
    else
    {
      FegeFirstSize := sour_fileSize + Funpara
      FegeLastSize := -Funpara
    }
    File := FileOpen(sour_filepath, "r")
    loop 2
    {
      zwj_filepath := CandySel_ParentPath "\" CandySel_FileName ".00" A_index
      file_zwj := FileOpen(zwj_filepath, "rw")
      if (A_index = 1)
      {
        File.Pos := 0
        File.RawRead(Var, FegeFirstSize)
        File_zwj.RawWrite(Var, FegeFirstSize)
      }
      else
      {
        File.RawRead(Var, FegeLastSize)
        File_zwj.RawWrite(Var, FegeLastSize)
      }
      File_zwj.Close()
    }
    File.Close()
    Break
	}
}
else if (SelFun = "转换编码*")
{
	valuetocp := {"ANSI(CP936)": "CP936", "UTF-8 BOM": "UTF-8", "UTF-8 Raw": "UTF-8-Raw", "Unicode(UTF16)": "UTF-16"}
	out_code := valuetocp[Funpara]
	;msgbox % out_code
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		sour_filepath := folder1 "\" relPath
		LV_GetText(Tmp_CPcode, RowNumber, 7)

		if (Tmp_CPcode != out_code)
		{
			;if (Funpara = "保留源文件")
				;File_CpTransform(sour_filepath, Tmp_CPcode, out_code, 1)
			;else if (Funpara = "覆盖源文件")
				File_CpTransform(sour_filepath, Tmp_CPcode, out_code, 0)
		}
	}
}
else if (SelFun = "文本合并*")
{
	valuetocp := {"ANSI(CP936)": "CP936", "UTF-8 BOM": "UTF-8", "UTF-8 Raw": "UTF-8-Raw", "Unicode(UTF16)": "UTF-16"}
	out_code := valuetocp[Funpara]
	;msgbox % out_code
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Tmp_Str := ""
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		sour_filepath := folder1 "\" relPath
		LV_GetText(Tmp_CPcode, RowNumber, 7)
		FileEncoding, %Tmp_CPcode%
		FileRead, OutputVar, %sour_filepath%
		Tmp_Str .= OutputVar "`r`n`r`n"
	}
	FileAppend, %Tmp_Str%, %folder1%\合并_%A_Now%.txt, UTF-8
}
else if (SelFun = "纠正扩展名*")
{
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		LV_GetText(fileext, RowNumber, 5)
		LV_GetText(filenewext, RowNumber, 7)
		sour_filepath := folder1 "\" relPath
		targ_filepath := RegExReplace(sour_filepath, fileext "$", filenewext)
		;msgbox % sour_filepath " - " targ_filepath
		if (filenewext != fileext)
			FileMove, %sour_filepath%, %targ_filepath%
	}
}
return

rpview:
Gui,66: Default
gui, Submit, NoHide
Tmp_Str := ""
if (SelFun = "复制列表")
{
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		if (Funpara = "带源文件夹")
			Tmp_Str .= folder1 "\" relPath "`n"
		else if (Funpara = "不带源文件夹")
			Tmp_Str .= relPath "`n"
	}
}
else if (SelFun = "复制到")
{
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		if (Funpara = "带结构复制")
			Tmp_Str .= "源文件夹\" relPath " 复制到 目标文件夹\" relPath "`n"
		else if (Funpara = "复制到同一层")
			Tmp_Str .= "源文件夹\" relPath " 复制到 目标文件夹`n"
	}
}
else if (SelFun = "剪切到")
{
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		if (Funpara = "带结构移动")
			Tmp_Str .= "源文件夹\" relPath " 移动到 目标文件夹\" relPath "`n"
		else if (Funpara = "移动到同一层")
			Tmp_Str .= "源文件夹\" relPath " 移动到 目标文件夹`n"
	}
}
else if (SelFun = "删除")
{
	RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
	Loop
	{
		RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
		if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
			break
		LV_GetText(relPath, RowNumber, 2)
		sour_filepath := folder1 "\" relPath
		if (Funpara = "回收站")
			Tmp_Str .= "删除文件 " sour_filepath "`n"
		else if (Funpara = "永久删除")
			Tmp_Str .= "永久删除文件 " sour_filepath "`n"
	}
}
GuiText(Tmp_Str, "操作预览", 840)
return

LV_RowIndexOrder()
{
	loop % LV_GetCount()
	{
		LV_Modify(A_index, , A_index)
	}
}

EditFile:
LV_GetText(relPath, LV_GetNext("F"), 2)
FileFullPath := folder1 "\" relPath
If Fileexist(FileFullPath)
{
	if instr(notepad2, "notepad2.exe")
	{
		FileEncoding % File_GetEncoding(FileFullPath)
		Loop, Read, % FileFullPath
		{
			if instr(A_LoopReadLine, filterContext)
			{
				tmp_linenum := A_index
				;tooltip % filterContext "-" tmp_linenum
				break
			}
		}
		Run, "%notepad2%" /g %tmp_linenum% "%FileFullPath%"
	}
	else
		Run, "%notepad2%" "%FileFullPath%"
}
else
	msgbox, 未选中或文件不存在。
Return

delfillefromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_Delete(RF)
}
return

editfilefromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
	if (filelistObj[Tmp_Str]["Type"] != "文件夹")
		run %notepad2% "%folder1%\%Tmp_Str%"
}
return

openfilefromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
	run %folder1%\%Tmp_Str%
}
return

ContextProperties:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
	run Properties %folder1%\%Tmp_Str%
}
return

openfilepfromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
	Run, explorer.exe /select`,%folder1%\%Tmp_Str%
}
return

checkallfile:
Gui,66: Default
LV_Modify(0, "check")
return

uncheckallfile:
Gui,66: Default
LV_Modify(0, "-check")
return

checkSameFolderall:
Gui,66: Default
RF := LV_GetNext("F")
if RF
{
	LV_GetText(RealPath, RF, 2)
	SplitPath, RealPath, OutFileName, OutDir
	if !OutDir
		OutDir := OutFileName
}
loop %  LV_GetCount()
{
	LV_GetText(RealPath, A_index, 2)
	if (instr(RealPath, OutDir) = 1)
		LV_Modify(A_index, "check")
}
return

uncheckSameFolderall:
Gui,66: Default
RF := LV_GetNext("F")
if RF
{
	LV_GetText(RealPath, RF, 2)
	SplitPath, RealPath, OutFileName, OutDir
	if !OutDir
		OutDir := OutFileName
}
loop %  LV_GetCount()
{
	LV_GetText(RealPath, A_index, 2)
	if (instr(RealPath, OutDir) = 1)
		LV_Modify(A_index, "-check")
}
return

jumpcheckedfile:
Gui,66: Default
RF := LV_GetNext("F")
if RF
{
	RFF := LV_GetNext(RF, "C")
	if !RFF
		RFF := LV_GetNext(RF+1, "C")
	LV_Modify(RFF, "Focus Vis")
}
return

66GuiClose:
66Guiescape:
Gui,66: Destroy
Gui,GuiText: Destroy
exitapp
Return

66GuiContextMenu:
if (A_GuiControl = "filelist1")
{
	Gui, ListView, filelist1
	lvfolder := 1
	Menu, filelistMenu, Show
}
return

nul:
return

CF_ToolTip(tipText, delay := 1000)
{
	ToolTip
	ToolTip, % tipText
	SetTimer, RemoveToolTip, % "-" delay
return

RemoveToolTip:
	ToolTip
return
}

; ==================================================================================================================================
; Shows a dialog to select a folder.
; Depending on the OS version the function will use either the built-in FileSelectFolder command (XP and previous)
; or the Common Item Dialog (Vista and later).
; Parameter:
;     StartingFolder -  the full path of a folder which will be preselected.
;     Prompt         -  a text used as window title (Common Item Dialog) or as text displayed withing the dialog.
;     ----------------  Common Item Dialog only:
;     OwnerHwnd      -  HWND of the Gui which owns the dialog. If you pass a valid HWND the dialog will become modal.
;     BtnLabel       -  a text to be used as caption for the apply button.
;  Return values:
;     On success the function returns the full path of selected folder; otherwise it returns an empty string.
; MSDN:
;     Common Item Dialog -> msdn.microsoft.com/en-us/library/bb776913%28v=vs.85%29.aspx
;     IFileDialog        -> msdn.microsoft.com/en-us/library/bb775966%28v=vs.85%29.aspx
;     IShellItem         -> msdn.microsoft.com/en-us/library/bb761140%28v=vs.85%29.aspx
; ==================================================================================================================================
SelectFolderEx(StartingFolder := "", Prompt := "", OwnerHwnd := 0, OkBtnLabel := "") {
   Static OsVersion := DllCall("GetVersion", "UChar")
        , IID_IShellItem := 0
        , InitIID := VarSetCapacity(IID_IShellItem, 16, 0)
                  & DllCall("Ole32.dll\IIDFromString", "WStr", "{43826d1e-e718-42ee-bc55-a1e261c37bfe}", "Ptr", &IID_IShellItem)
        , Show := A_PtrSize * 3
        , SetOptions := A_PtrSize * 9
        , SetFolder := A_PtrSize * 12
        , SetTitle := A_PtrSize * 17
        , SetOkButtonLabel := A_PtrSize * 18
        , GetResult := A_PtrSize * 20
   SelectedFolder := ""
   If (OsVersion < 6) { ; IFileDialog requires Win Vista+, so revert to FileSelectFolder
      FileSelectFolder, SelectedFolder, *%StartingFolder%, 3, %Prompt%
      Return SelectedFolder
   }
   OwnerHwnd := DllCall("IsWindow", "Ptr", OwnerHwnd, "UInt") ? OwnerHwnd : 0
   If !(FileDialog := ComObjCreate("{DC1C5A9C-E88A-4dde-A5A1-60F82A20AEF7}", "{42f85136-db7e-439c-85f1-e4075d135fc8}"))
      Return ""
   VTBL := NumGet(FileDialog + 0, "UPtr")
   ; FOS_CREATEPROMPT | FOS_NOCHANGEDIR | FOS_PICKFOLDERS
   DllCall(NumGet(VTBL + SetOptions, "UPtr"), "Ptr", FileDialog, "UInt", 0x00002028, "UInt")
   If (StartingFolder <> "")
      If !DllCall("Shell32.dll\SHCreateItemFromParsingName", "WStr", StartingFolder, "Ptr", 0, "Ptr", &IID_IShellItem, "PtrP", FolderItem)
         DllCall(NumGet(VTBL + SetFolder, "UPtr"), "Ptr", FileDialog, "Ptr", FolderItem, "UInt")
   If (Prompt <> "")
      DllCall(NumGet(VTBL + SetTitle, "UPtr"), "Ptr", FileDialog, "WStr", Prompt, "UInt")
   If (OkBtnLabel <> "")
      DllCall(NumGet(VTBL + SetOkButtonLabel, "UPtr"), "Ptr", FileDialog, "WStr", OkBtnLabel, "UInt")
   If !DllCall(NumGet(VTBL + Show, "UPtr"), "Ptr", FileDialog, "Ptr", OwnerHwnd, "UInt") {
      If !DllCall(NumGet(VTBL + GetResult, "UPtr"), "Ptr", FileDialog, "PtrP", ShellItem, "UInt") {
         GetDisplayName := NumGet(NumGet(ShellItem + 0, "UPtr"), A_PtrSize * 5, "UPtr")
         If !DllCall(GetDisplayName, "Ptr", ShellItem, "UInt", 0x80028000, "PtrP", StrPtr) ; SIGDN_DESKTOPABSOLUTEPARSING
            SelectedFolder := StrGet(StrPtr, "UTF-16"), DllCall("Ole32.dll\CoTaskMemFree", "Ptr", StrPtr)
         ObjRelease(ShellItem)
   }  }
   If (FolderItem)
      ObjRelease(FolderItem)
   ObjRelease(FileDialog)
   Return SelectedFolder
}

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd +Resize
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	Return

	GuiTextGuiSize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	AutoXYWH("wh", "myedit")
	return
}

LV_SortArrow(h, c, d="")	; by Solar (http://www.autohotkey.com/forum/viewtopic.php?t=69642)
; Shows a chevron in a sorted listview column pointing in the direction of sort (like in Explorer)
; h = ListView handle (use +hwnd option to store the handle in a variable)
; c = 1 based index of the column
; d = Optional direction to set the arrow. "asc" or "up". "desc" or "down".
{
	static ptr, ptrSize, lvColumn, LVM_GETCOLUMN, LVM_SETCOLUMN
	if (!ptr)
		ptr := A_PtrSize ? ("ptr", ptrSize := A_PtrSize) : ("uint", ptrSize := 4)
		,LVM_GETCOLUMN := A_IsUnicode ? (4191, LVM_SETCOLUMN := 4192) : (4121, LVM_SETCOLUMN := 4122)
		,VarSetCapacity(lvColumn, ptrSize + 4), NumPut(1, lvColumn, "uint")
	c -= 1, DllCall("SendMessage", ptr, h, "uint", LVM_GETCOLUMN, "uint", c, ptr, &lvColumn)
	if ((fmt := NumGet(lvColumn, 4, "int")) & 1024) {
		if (d && d = "asc" || d = "up")
			return
		NumPut(fmt & ~1024 | 512, lvColumn, 4, "int")
	} else if (fmt & 512) {
		if (d && d = "desc" || d = "down")
			return
		NumPut(fmt & ~512 | 1024, lvColumn, 4, "int")
	} else {
		Loop % DllCall("SendMessage", ptr, DllCall("SendMessage", ptr, h, "uint", 4127), "uint", 4608)
			if ((i := A_Index - 1) != c)
				DllCall("SendMessage", ptr, h, "uint", LVM_GETCOLUMN, "uint", i, ptr, &lvColumn)
				,NumPut(NumGet(lvColumn, 4, "int") & ~1536, lvColumn, 4, "int")
				,DllCall("SendMessage", ptr, h, "uint", LVM_SETCOLUMN, "uint", i, ptr, &lvColumn)
		NumPut(fmt | (d && d = "desc" || d = "down" ? 512 : 1024), lvColumn, 4, "int")
	}
	return DllCall("SendMessage", ptr, h, "uint", LVM_SETCOLUMN, "uint", c, ptr, &lvColumn)
}

; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;             add a 't' to DimSize to tell AutoXYWH that the controls in cList are on/in a tab3 control
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
;   AutoXYWH("t x h0.5", "Btn1")
; ---------------------------------------------------------------------------------
; Version: 2020-5-20 / small code improvements (toralf)
;          2018-1-31 / added a line to prevent warnings (pramach)
;          2018-1-13 / added t option for controls on Tab3 (Alguimist)
;          2015-5-29 / added 'reset' option (tmplinshi)
;          2014-7-03 / mod by toralf
;          2014-1-02 / initial version tmplinshi
; requires AHK version : 1.1.13.01+    due to SprSplit()
; =================================================================================

AutoXYWH(DimSize, cList*){   ;https://www.autohotkey.com/boards/viewtopic.php?t=1079
  Static cInfo := {}

  If (DimSize = "reset")
    Return cInfo := {}

  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If !cInfo.hasKey(ctrlID) {
      ix := iy := iw := ih := 0	
      GuiControlGet i, %A_Gui%: Pos, %ctrl%
      MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
      fx := fy := fw := fh := 0
      For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) 
        If !RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)
          f%dim% := 1

      If (InStr(DimSize, "t")) {
        GuiControlGet hWnd, %A_Gui%: hWnd, %ctrl%
        hParentWnd := DllCall("GetParent", "Ptr", hWnd, "Ptr")
        VarSetCapacity(RECT, 16, 0)
        DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", &RECT)
        DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", &RECT, "UInt", 1)
        ix := ix - NumGet(RECT, 0, "Int")
        iy := iy - NumGet(RECT, 4, "Int")
      }

      cInfo[ctrlID] := {x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a, m:MMD}
    } Else {
      dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw, dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
      Options := ""
      For i, dim in cInfo[ctrlID]["a"]
        Options .= dim (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) A_Space
      GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
} } }

/*!
	函数: File_GetEncoding
		类似 chardet Py库, 检测文件的代码页.

	参数:
		aFile - 要分析的外部文件路径.

	备注:
			> 注意:
			> ANSI 文档为全英文时, 默认返回 UTF-8.

	返回值:
		字符串
		0      - 错误, 文件不存在
		CPnnn  - ANSI (CPnnn), 必须带有中文字符串, 才能和 UTF-8 无签名 区分开.
		UTF-16 - text Utf-16 LE File
		CP1201 - text Utf-16 BE File
		UTF-32 - text Utf-32 BE/LE File
		UTF-8  - text Utf-8 File (UTF-8 + BOM). 检验的文件太小, 不足以检查时, 默认返回 UTF-8.
		UTF-8-RAW  - UTF-8 无签名. 
		对于 UTF-8-RAW 的说明：
		1.文件小于100kb 读取整个文件, 必须带有中文字符串(文件中存在乱码（特殊字符）时可能得到错误的结果), 才能和 CP936 区分开.
		2.文件大于100kb 读取文件前 100kb 的内容。
*/

; isBinFile
; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=144&start=20

/*
; 示例
Loop, Files, *.txt
msgbox % A_LoopFileName " - " File_GetEncoding(A_LoopFileLongPath)
*/

File_GetEncoding(aFile, aNumBytes = 0, aMinimum = 4)
{
	if !FileExist(aFile) or InStr(FileExist(aFile), "D")
		return 0

	_rawBytes := ""
	_hFile := FileOpen(aFile, "r")
	; force position to 0 (zero)
	_hFile.Position := 0
	; 文件小于100k, 则读取整个文件
	_nBytes := (_hFile.length < 102400) ? (_hFile.RawRead(_rawBytes, _hFile.length)) : (aNumBytes = 0) ? (_hFile.RawRead(_rawBytes, 102402)) : (_hFile.RawRead(_rawBytes, aNumBytes))
	_hFile.Close()

	; Initialize vars
	_t := 0, _i := 0, _bytesArr := []

	loop % _nBytes ; create c-style _bytesArr array
		_bytesArr[(A_Index - 1)] := Numget(&_rawBytes, (A_Index - 1), "UChar")

	; determine BOM if possible/existant
	if ((_bytesArr[0] = 0xFE) && (_bytesArr[1] = 0xFF))
	{
		; text Utf-16 BE File
		return "CP1201"
	}
	if ((_bytesArr[0] = 0xFF) && (_bytesArr[1] = 0xFE))
	{
		; text Utf-16 LE File
		return "UTF-16"
	}
	if ((_bytesArr[0] = 0xEF) && (_bytesArr[1] = 0xBB) && (_bytesArr[2] = 0xBF))
	{
		; text Utf-8 File
		return "UTF-8"
	}
	if ((_bytesArr[0] = 0x00) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0xFE) && (_bytesArr[3] = 0xFF))
	|| ((_bytesArr[0] = 0xFF) && (_bytesArr[1] = 0xFE) && (_bytesArr[2]= 0x00) && (_bytesArr[3] = x00))
	{
		; text Utf-32 BE/LE File
		return "UTF-32"
	}
	; 为了 unicode 检测, 推荐 aMinimum 为 4  (4个字节以下的文件无法判断类型)
	if (_nBytes < aMinimum)
	{
		; 如果文本太短，返回编码"UTF-8"
		return "UTF-8"
	}

	while(_i < _nBytes)
	{
		; // ASCII
		if (_bytesArr[_i] == 0x09)
		|| (_bytesArr[_i] == 0x0A)
		|| (_bytesArr[_i] == 0x0D)
		|| ((0x20 <= _bytesArr[_i]) && (_bytesArr[_i] <= 0x7E))
		{
			_i += 1
			continue
		}

		; // non-overlong 2-byte
		if (0xC2 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xDF)
		&& (0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF)
		{
			_i += 2
			if (_i + 1 > 102400) or (_i + 2 > 102400)
				break
			else
				continue
		}

		; // excluding overlongs, straight 3-byte, excluding surrogates
		if (((_bytesArr[_i] == 0xE0)
		&& ((0xA0 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF)))
		|| ((((0xE1 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xEC))
		|| (_bytesArr[_i] == 0xEE)
		|| (_bytesArr[_i] == 0xEF))
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF)))
		|| ((_bytesArr[_i] == 0xED)
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0x9F))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))))
		{
			_i += 3
			if (_i + 1 > 102400) or (_i + 2 > 102400) or (_i + 3 > 102400)
				break
			else
				continue
		}

		; // planes 1-3, planes 4-15, plane 16
		if (((_bytesArr[_i] == 0xF0)
		&& ((0x90 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
			&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF)))
		|| (((0xF1 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xF3))
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF)))
		|| ((_bytesArr[_i] == 0xF4)
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0x8F))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF))))
		{
			_i += 4
			continue
		}
		_t := 1
		break
	}

	; while 循环没有失败，然后确认为utf-8
	if (_t = 0)
	{
		return "UTF-8-RAW"
	}

	; 如果通过以上判断没有获取到文件编码
	; 通过检测文件是否含有不可见字符来简单判断是否为exe类型的二进制文件
/*
	loop, %_nBytes%
	{
		if ((_bytesArr[(A_Index - 1)] > 0) && (_bytesArr[(A_Index - 1)] < 9))
		|| ((_bytesArr[(A_Index - 1)] > 13) && (_bytesArr[(A_Index - 1)] < 20))
		{
			return 1
		}
	}
*/

	changyongzi := ["的", "一", "是", "了", "不", "在", "有", "个", "人", "这", "上", "中", "大", "为", "来", "我", "到", "出", "要", "以", "时", "和", "地", "们", "得", "可", "下", "对", "生", "也", "子", "就", "过", "能", "他", "会", "多", "发", "说", "而", "于", "自", "之", "用", "年", "行", "家", "方", "后", "作", "成", "开", "面", "事", "好", "小", "心", "前", "所", "道", "法", "如", "进", "着", "同", "经", "分", "定", "都", "然", "与", "本", "还", "其", "当", "起", "动", "已", "两", "点", "从", "问", "里", "主", "实", "天", "高", "去", "现", "长", "此", "三", "将", "无", "国", "全", "文", "理", "明", "日"]
	readstr := StrGet(&_rawBytes, _nBytes, "CP65001")
	changyongzi_jishu := 0
	for k,v in changyongzi
	{
		if InStr(readstr, v)
			changyongzi_jishu := changyongzi_jishu + 1
		if (changyongzi_jishu > 5)
		{
			return "UTF-8-Raw"
		}
	}

	readstr := StrGet(&_rawBytes, _nBytes, "CP936")
	changyongzi_jishu := 0
	for k,v in changyongzi
	{
		if InStr(readstr, v)
		{
			changyongzi_jishu := changyongzi_jishu + 1
		}
		if (changyongzi_jishu > 5)
		{
			return "CP936"
		}
	}

	changyongzi2 := ["個", "這", "為", "來", "時", "們", "得", "對", "過", "會", "發", "說", "開", "進", "經", "與", "本", "還", "當", "動", "兩", "點", "從", "問", "實", "現", "長", "將", "無", "國", "愛", "罷", "筆", "邊", "慘", "憐", "稱", "辦", "礙", "幫", "斃", "標", "彆", "錶", "參", "陽", "産", "蟲", "醜", "塵", "個", "掃", "監", "見", "舉", "鳥", "贜", "樹", "雜", "聽", "嘆", "薦", "夥", "漢", "黨", "齣", "遲", "車", "竄", "燈", "膚", "團", "態", "條", "殺", "農", "樂", "競", "驚", "幾", "處", "齒", "廠", "徹", "雙", "懲", "東", "當", "電", "奪", "麽", "舊", "關", "畫", "來", "賣", "買", "門", "麵", "氣"]
	readstr := StrGet(&_rawBytes, _nBytes, "CP950")
	changyongzi_jishu := 0
	for k,v in changyongzi2
	{
		if InStr(readstr, v)
			changyongzi_jishu := changyongzi_jishu + 1
		if (changyongzi_jishu > 5)
		{
			return "CP950"
		}
	}

	; 未符合上面条件的返回系统默认 ansi 内码
	; 简体中文系统默认返回的是 CP936, 非中文系统的内码显示中文会乱码,如果要显示中文可直接改为"CP936"
	return "CP" DllCall("GetACP")  
}

Deref(String)
{
    spo := 1
    out := ""
    while (fpo:=RegexMatch(String, "(%(.*?)%)|``(.)", m, spo))
    {
        out .= SubStr(String, spo, fpo-spo)
        spo := fpo + StrLen(m)
        if (m1)
            out .= %m2%
        else switch (m3)
        {
            case "a": out .= "`a"
            case "b": out .= "`b"
            case "f": out .= "`f"
            case "n": out .= "`n"
            case "r": out .= "`r"
            case "t": out .= "`t"
            case "v": out .= "`v"
            default: out .= m3
        }
    }
    return out SubStr(String, spo)
}

File_CpTransform(aInFile, aInCp := "", aOutCp := "", aOutNewFile := 1)
{
	if (aInCp = "CP1201")
	{
		_hFile := FileOpen(aInFile, "r")
		_hFile.Position := 2
		aInLen := _hFile.length - 2
		_hFile.RawRead(FileR_TFRaw, aInLen)
		_hFile.Close()
		;msgbox % aInLen
	}
	else
	{
		FileEncoding, % aInCp
		FileRead, FileR_TFC, %aInFile%
		FileEncoding
	}

	aSysCp := "CP" DllCall("GetACP")
	if !aOutCp or (aOutCp = "ansi")
		aOutCp := aSysCp

	SplitPath, % aInFile, , aOutDir, OutExtension, OutNameNoExt
	if aOutNewFile
	{
		aOutFile := aOutDir "\" OutNameNoExt "(" aInCp "转码" aOutCp ")." OutExtension
		aOutFile := PathU(aOutFile)
	}
	else
	{
		FileRecycle, %aInFile%
		aOutFile := aInFile
	}

	if (aOutCp != "CP1201")
	{
		if (aInCp = "CP1201")
		{
			LCMAP_BYTEREV := 0x800   ; 高低位转换
			cch := DllCall("LCMapStringW", "UInt", 0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFRaw, "UInt", -1, "Str", 0, "UInt", 0)
			;msgbox % cch  ; 长度与文件的实际长度 不一致
			VarSetCapacity(LE, cch * 2)
			DllCall("LCMapStringW", "UInt",0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFRaw, "UInt", cch, "Str", LE, "UInt",  cch)
			;msgbox % LE
			StrLE := StrGet(&LE, aInLen / 2)   ; 移除掉多余的长度的乱码
			;msgbox % StrLE
			FileAppend, %StrLE%, % aOutFile, % aOutCp
			FileR_TFRaw := StrLE := LE := ""
			return
		}
		else
		{
			FileAppend, %FileR_TFC%, % aOutFile, % aOutCp
			FileR_TFC := ""
			return
		}
	}
	else if (aOutCp = "CP1201")
	{
		if (aInCp = "CP1201")
		{
			_hFile := FileOpen(aOutFile, "w")
			MCode(code, "FEFF")
			_hFile.RawWrite(code, 2)
			_hFile.RawWrite(FileR_TFRaw, aInLen)
			FileR_TFRaw := ""
			return
		}
		else
		{
			LCMAP_BYTEREV := 0x800
			cch:=DllCall("LCMapStringW", "UInt",0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFC, "UInt", -1, "Str", 0, "UInt", 0)
			VarSetCapacity(BE, cch * 2)
			DllCall("LCMapStringW", "UInt", 0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFC, "UInt", cch, "Str", BE, "UInt", cch)
			_hFile := FileOpen(aOutFile, "w")
			MCode(code, "FEFF")
			_hFile.RawWrite(code, 2)
			_hFile.RawWrite(BE, cch * 2-2)
			FileR_TFC := BE := ""
			return
		}
	}
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

File_GetExt(aFile, aNumBytes = 0, aMinimum = 4)
{
	if !FileExist(aFile) or InStr(FileExist(aFile), "D")
		return 0

	_rawBytes := ""
	_hFile := FileOpen(aFile, "r")
	; force position to 0 (zero)
	_hFile.Position := 0
	_nBytes := (_hFile.length < 1024) ? (_hFile.RawRead(_rawBytes, _hFile.length)) : (aNumBytes = 0) ? (_hFile.RawRead(_rawBytes, 1026)) : (_hFile.RawRead(_rawBytes, aNumBytes))
	_hFile.Close()

	; Initialize vars
	_t := 0, _i := 0, _bytesArr := []

	loop % _nBytes ; create c-style _bytesArr array
		_bytesArr[(A_Index - 1)] := Numget(&_rawBytes, (A_Index - 1), "UChar")

	if ((_bytesArr[0] = 0x00) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0x00) && (_bytesArr[4] = 0x66) && (_bytesArr[5] = 0x74) && (_bytesArr[6] = 0x79) && (_bytesArr[7] = 0x70) && (_bytesArr[8] = 0x33) && (_bytesArr[9] = 0x67) && (_bytesArr[10] = 0x70))
	{
		return "3gp"
	}
	else if ((_bytesArr[0] = 0x37) && (_bytesArr[1] = 0x7A) && (_bytesArr[2] = 0xBC) && (_bytesArr[3] = 0xAF))
	&& ((_bytesArr[4] = 0x27) && (_bytesArr[5] = 0x1C))
	{
		return "7z"
	}
	else if ((_bytesArr[0] = 0x42) && (_bytesArr[1] = 0x4D))
	{
		return "bmp"
	}
	else if ((_bytesArr[0] = 0x4D) && (_bytesArr[1] = 0x5A) && (_bytesArr[2] = 0x90))
	{
		return "exe/dll"
	}
	else if ((_bytesArr[0] = 0xD0) && (_bytesArr[1] = 0xCF) && (_bytesArr[2] = 0x11) && (_bytesArr[3] = 0xE0))
	{
		return "doc/xls"
	}
	else if ((_bytesArr[0] = 0x47) && (_bytesArr[1] = 0x49) && (_bytesArr[2] = 0x46) && (_bytesArr[3] = 0x38))
	{
		return "gif"
	}
	else if ((_bytesArr[0] = 0x00) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0x01) && (_bytesArr[3] = 0x00))
	{
		return "ico"
	}
	else if ((_bytesArr[0] = 0xFF) && (_bytesArr[1] = 0xD8) && (_bytesArr[2] = 0xFF))
	{
		return "jpg"
	}

	else if ((_bytesArr[0] = 0x4C) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0x00))
	{
		return "lnk"
	}
	else if ((_bytesArr[0] = 0x49) && (_bytesArr[1] = 0x44) && (_bytesArr[2] = 0x33))
	{
		return "mp3"
	}
	else if ((_bytesArr[0] = 0x00) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0x00) && (_bytesArr[3] = 0x18) && (_bytesArr[4] = 0x66) && (_bytesArr[5] = 0x74) && (_bytesArr[6] = 0x79) && (_bytesArr[7] = 0x70) && (_bytesArr[8] = 0x6D) && (_bytesArr[9] = 0x70) && (_bytesArr[10] = 0x34) && (_bytesArr[11] = 0x32))
	{
		return "mp4"
	}
	else if ((_bytesArr[0] = 0x25) && (_bytesArr[1] = 0x50) && (_bytesArr[2] = 0x44))
	{
		return "pdf"
	}
	else if ((_bytesArr[0] = 0x89) && (_bytesArr[1] = 0x50) && (_bytesArr[2] = 0x4E) && (_bytesArr[3] = 0x47))
	{
		return "png"
	}
	else if ((_bytesArr[0] = 0x52) && (_bytesArr[1] = 0x61) && (_bytesArr[2] = 0x72))
	{
		return "rar"
	}
	else if ((_bytesArr[0] = 0x2E) && (_bytesArr[1] = 0x52) && (_bytesArr[2] = 0x4D))
	{
		return "rm/rmvb"
	}
	else if ((_bytesArr[0] = 0x52) && (_bytesArr[1] = 0x49) && (_bytesArr[2] = 0x46) && (_bytesArr[3] = 0x46))
	&& ((_bytesArr[8] = 0x57) && (_bytesArr[9] = 0x45) && (_bytesArr[10]= 0x42) && (_bytesArr[11] = 0x50))
	{
		return "webp"
	}
	else if ((_bytesArr[0] = 0x50) && (_bytesArr[1] = 0x4B) && (_bytesArr[2] = 0x03) && (_bytesArr[3] = 0x04))
	{
		return "zip"
	}
}