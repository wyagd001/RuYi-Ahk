;|2.2|2023.08.10|1401
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
localPropName := {}

Gui,66: Destroy
Gui,66: Default
Props := GetExtendedProperties(CandySel)
Gui, Add, ListView, w600 r27 glvgio, 序号|属性名|属性值
For Each, Prop In Props
{
	if instr(Prop.N, "System.Date")
	{
		utc := DateParse(Prop.V)
		utc += 8, Hours
		FormatTime, OutputVar, % utc, yyyy.MM.dd HH:mm:ss
		Prop.V := OutputVar
	}
	LV_Add("", Each, Prop.N, Prop.V)
}
LV_ModifyCol()
LV_ModifyCol(1, "Logical") 
Gui, Show,, 详细信息
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

GetExtendedProperties(FilePath) {
   ; The properties in 'Exclude' caused problems during my tests
   Static Exclude := {"System.SharedWith": 1}
   SplitPath, FilePath, FileName , FileDir
   If (FileDir = "")
      FileDir := A_WorkingDir
   Props := {}
   If (SFI := ComObjCreate("Shell.Application").NameSpace(FileDir).ParseName(FileName)) {
      PropList := SFI.ExtendedProperty("System.PropList.FullDetails")
      If (SubStr(PropList, 1, 5) = "prop:") {
         Props := {}
         PropCount := 0
         For Each, PropName In StrSplit(SubStr(PropList, 6), ";", "*") {
            If Exclude.HasKey(PropName)
               Continue
            If InStr(PropName, ".PropGroup.") {
               PropName := ">>>>> " . StrSplit(PropName, ".")[3] . " <<<<<"
               Props[++PropCount] := {N: PropName, V: ""}
               Continue
            }
            PropVal := SFI.ExtendedProperty(PropName)
            If IsObject(PropVal) {
               If (ComObjType(PropVal) & 0x2000) { ; VT_ARRAY
                  Values := ""
                  For Value In PropVal
                     Values .= Value . ", "
                  Props[++PropCount] := {N: PropName, V: RTrim(Values, ", ")}
               }
            }
            Else If (PropVal <> "") {
               Props[++PropCount] := {N: PropName, V: PropVal}
            }
         }
      }
   }
   Return Props
}

DateParse(str) {
	RegExMatch(str, "(\d+)\.(\d+)\.(\d+)\s(\d+):(\d+):(\d+)", SubPat)
	return SubPat1 (strlen(SubPat2)=1?"0" SubPat2:SubPat2) (strlen(SubPat3)=1?"0" SubPat3:SubPat3) (strlen(SubPat4)=1?"0" SubPat4:SubPat4) (strlen(SubPat5)=1?"0" SubPat5:SubPat5) (strlen(SubPat6)=1?"0" SubPat6:SubPat6)
}