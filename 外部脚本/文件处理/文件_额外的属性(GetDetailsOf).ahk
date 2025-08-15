;|2.2|2023.07.30|1402
CandySel := A_Args[1]
;CandySel := A_ScriptFullPath
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
	MultiF := InStr(CandySel, "`r")
	if MultiF
	{
		CandySel_org := CandySel
		CandySel := SubStr(CandySel, 1, MultiF - 1)   ;  第一行的文件
	}
}

Gui,66: Destroy
Gui,66: Default

Props := GetFullDetails(CandySel)
Gui, Add, ListView, w600 r20 glvgio, 序号|名称|值
For Each, Prop In Props
   LV_Add("", Each, Prop.N, Prop.V)
LV_ModifyCol()
LV_ModifyCol(1, "Logical") 
Gui, Show,, 文件属性
Return

66GuiClose:
66Guiescape:
Gui,66: Destroy
exitapp
Return

lvgio:
if (A_GuiEvent = "DoubleClick") or (A_GuiEvent = "R")
{
	LV_GetText(CopyV2, A_EventInfo, 2)
	LV_GetText(CopyV3, A_EventInfo, 3)
	CopyV := CopyV2 "`t" CopyV3
	clipboard := CopyV
	CF_ToolTip("已经复制焦点行到剪贴板(双击或右键).", 3000)
}
return

GetFullDetails(FilePath)
{
	Props := {}
	SplitPath, FilePath, FileName, DirPath
	objShell := ComObjCreate("Shell.Application")
	objFolder := objShell.NameSpace(DirPath)		; set the directry path
	objFolderItem := objFolder.ParseName(FileName)	; set the file name

	Loop 329
	{
		if propertyitem := objFolder.GetDetailsOf(objFolderItem, A_Index-1)
		{
			PropName := objFolder.GetDetailsOf(objFolder.Items, A_Index-1)
			Props[A_Index-1] := {N: PropName, V: propertyitem}
		}
	}
	Return Props
}