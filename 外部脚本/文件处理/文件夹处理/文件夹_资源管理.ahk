;|2.8|2024.09.22|1xxx
; 还在测试中
#Include <Ruyi>
#Include <File_GetEncoding>
#Include <File_CpTransform>
#Include <AutoXYWH>
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
Gui, Add, Button, xp+70 yp w60 gcheckallSeletedfile, 选中高亮
Gui, Add, Button, xp+70 yp w60 guncheckallSeletedfile, 高亮不选
Gui, Add, Button, xp+70 yp w60 gEditFile, 编辑文件
Gui, Add, Button, xp+70 yp w60 gopenfilefromlist, 打开文件
Gui, Add, Button, xp+70 yp w60 gopenfilepfromlist, 打开路径

gui, show,, 文件夹管理器
Menu, Tray, UseErrorLevel
Menu, filelistMenu, deleteall
Menu, filelistMenu, Add, 全选, checkallfile
Menu, filelistMenu, Add, 全不选, uncheckallfile
Menu, filelistMenu, Add, 选中高亮, checkSameFolderall
Menu, filelistMenu, Add, 取消选中, uncheckSameFolderall
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

checkallSeletedfile:
RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Loop
{
  RowNumber := LV_GetNext(RowNumber)  ; 在前一次找到的位置后继续搜索.
  if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
    break
  LV_Modify(RowNumber, "+check")
}
return

uncheckallSeletedfile:
RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Loop
{
  RowNumber := LV_GetNext(RowNumber)  ; 在前一次找到的位置后继续搜索.
  if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
    break
  LV_Modify(RowNumber, "-check")
}
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