;|2.2|2023.07.30|1402
CandySel := A_Args[1]
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

Props := GetFullDetails(CandySel)
Gui, Add, ListView, w600 r20, 序号|名称|值
For Each, Prop In Props
   LV_Add("", Each, Prop.N, Prop.V)
LV_ModifyCol()
LV_ModifyCol(1, "Logical") 
Gui, Show,, 文件属性
Return

GuiClose:
ExitApp

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