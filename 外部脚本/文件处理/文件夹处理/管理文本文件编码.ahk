;|2.7|2024.06.15|1316
#Include <File_GetEncoding>
#Include <File_CpTransform>
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\f17f.ico"

CandySel :=  A_Args[1]
;CandySel := "C:\Documents and Settings\Administrator\Desktop\Gui"
valuetocp := {"ANSI(中文简体)": "CP936", "UTF-8 BOM": "UTF-8", "UTF-8 Raw": "UTF-8-Raw", "Unicode(UTF-16)": "UTF-16"}
Gui, Add, Text, x10 y15 h25, 查找文件夹:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vsfolder, % CandySel
Gui, Add, Button, xp+560 yp-2 w60 h30 gstartsearch, 开始查找
Gui, Add, Text, x10 yp+40 h25, 筛选扩展名:
Gui, Add, Edit, xp+80 yp-5 w225 h25 vsExt, % "txt,ahk,md,lrc,ahk2,htm,html"
Gui, Add, Text, xp+240 yp+5 h25, 筛选编码:
Gui, Add, DropDownList, xp+80 yp-5 w230 h70 vfcode hwndhcbx, 所有||CP936|UTF-8
PostMessage, 0x0153, -1, 20,, ahk_id %hcbx%  

Gui, Add, Button, xp+240 yp w60 h30 grunzhuanma, 执行转码
gui, add, Text, x10 yp+40 w60 vmyparam1, 输出编码:
gui, add, DropDownList, xp+80 yp w550 vOut_Code hwndhcby, ANSI(中文简体)|UTF-8 Raw|UTF-8 BOM||Unicode(UTF-16)
PostMessage, 0x0153, -1, 20,, ahk_id %hcby% 
Gui, Add, Button, xp+560 yp w60 h30 gstopload, 停止查找

Gui, Add, ListView, x10 yp+40 w700 h500 vfilelist Checked hwndHLV AltSubmit grid, 文件名|相对路径|扩展名|文件编码|大小(KB)|修改日期|完整路径
Gui, Add, Button, xp yp+510 w60 h30 gcheckall, 全选
Gui, Add, Button, xp+70 yp w60 h30 guncheckall, 全不选
Gui, Add, Button, xp+70 yp w60 h30 gcheckunall, 反选
Gui, Add, Button, xp+70 yp w80 h30 gcheckcp936, 勾选 CP936
Gui, Add, Button, xp+90 yp w60 h30 gEditfilefromlist, 编辑文件
Gui, Add, Button, xp+70 yp w60 h30 gopenfilefromlist, 打开文件
Gui, Add, Button, xp+70 yp w60 h30 gopenfilepfromlist, 打开路径

gui, Show,, 列出文件夹中文本文件的编码

if FileExist(CandySel)
	gosub startsearch
Return

startsearch:
stopload := 0
gui, Submit, NoHide
ToolTip, % "正在遍历文本文件编码类型, 请稍候..."
LV_Delete()
GuiControl, -Redraw, filelist
Loop, Files, %sfolder%\*.*, FR
{
	if A_LoopFileSize = 0
		continue
	if sExt
	{
		if A_LoopFileExt not in %sExt%
			continue
	}
	Tmp_Code := File_GetEncoding(A_LoopFileFullPath)
	if (fcode = "所有") or (Tmp_Code = fcode)
		LV_Add("", A_LoopFileName, StrReplace(StrReplace(A_LoopFilePath, sfolder), A_LoopFileName), A_LoopFileExt, Tmp_Code, Ceil(A_LoopFileSize / 1024), A_LoopFileTimeModified, A_LoopFilePath)
	if stopload
	{
		stopload := 0
		ToolTip
		break
	}
}
;msgbox % "文件遍历完成. 用时: " A_TickCount - st
ToolTip
GuiControl, +Redraw, filelist
LV_ModifyCol()
LV_ModifyCol(1, 200)
LV_ModifyCol(2, 250)
LV_ModifyCol(3, 60)
LV_ModifyCol(5, "75 Logical")
;FileAppend, % Array_ToString(folderobj) , %A_desktop%\123.txt
return

stopload:
stopload := 1
return

checkall:
LV_Modify(0, "check")
return

uncheckall:
LV_Modify(0, "-check")
return

checkunall:
Loop % LV_GetCount()
{
	SendMessage, 0x102C, A_index - 1, 0xF000, SysListView321
	IsChecked := (ErrorLevel >> 12) - 1
	if IsChecked
		LV_Modify(A_index, "-check")
	else
		LV_Modify(A_index, "check")
}
return

checkcp936:
Loop % LV_GetCount()
{
	LV_GetText(OutputVar, A_Index, 4)
	if (OutputVar = "CP936")
		LV_Modify(A_index, "check")
}
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

runzhuanma:
ToolTip, % "正在进行文件转码, 请稍候..."
gui, Submit, NoHide
out_code := valuetocp[out_code]
;msgbox % out_code
RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break
	LV_GetText(Tmp_Path, RowNumber, 7)
	LV_GetText(Tmp_CPcode, RowNumber, 4)

	if (Tmp_CPcode != out_code)
		File_CpTransform(Tmp_Path, Tmp_CPcode, out_code, 0)
}
ToolTip
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