;|2.2|2023.07.30|1401
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
Gui, Add, ListView, w600 r20, 序号|属性名|属性值
For Each, Prop In Props
   LV_Add("", Each, Prop.N, Prop.V)
LV_ModifyCol()
LV_ModifyCol(1, "Logical") 
Gui, Show,, 额外属性
Return

GuiClose:
ExitApp

GetFullDetails(FilePath) {
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