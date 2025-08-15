;|3.0|2025.07.16|1721
CandySel := A_Args[1]
;CandySel := "J:\拼多多\Camera"
Gui, 66: Destroy
Gui, 66: Default

Gui, Add, Text, x10 y15 h25, 查找文件夹:
Gui, Add, Edit, xp+80 yp-5 w480 h25 vsfolder, % CandySel
Gui, Add, Button, xp+490 yp-2 w60 h30 gloadfileprops, 开始查找
Gui, Add, ListView, x10 yp+36 w630 h400 vfilelist hwndHLV AltSubmit glvgio, 序号|文件名|文件路径|纬度|经度|大小|修改时间
Gui, Add, Button, x10 yp+410 h30 gCopySel, 复制到剪贴板
gui, Show,, 图片GPS管理
return

;System.GPS.Latitude	25.000000, 19.000000, 44.037780
;System.GPS.Longitude	110.000000, 17.000000, 6.150512
loadfileprops:
b_ind := 0
Loop, Files, %CandySel%\*.jpg, FDR
{
  ;tooltip % A_LoopFilePath
  Props := GetExtendedProperties(A_LoopFilePath)
  ;msgbox % Props["System.GPS.Latitude"]
  fLatitude := fLongitude := ""
  For Each, Prop In Props
  {
    if (Prop.N = "System.GPS.Latitude")
      fLatitude := Prop.V
    else if (Prop.N = "System.GPS.Longitude")
      fLongitude := Prop.V
    if fLatitude && fLongitude
      break
  }
  ;msgbox % fLatitude " - " fLongitude
  if fLatitude || fLongitude
  {
    b_ind ++
    ;tooltip % b_ind
    ;if b_ind >  5
      ;break
    Arr := StrSplit(fLatitude, ",")
    fLatitude := Arr[1] + Arr[2] / 60 + Arr[3] / 3600
    Arr := StrSplit(fLongitude, ",")
    fLongitude := Arr[1] + Arr[2] / 60 + Arr[3] / 3600
    LV_Add("", b_ind, A_LoopFileName, A_LoopFilePath, fLatitude, fLongitude, Ceil(A_LoopFileSize / 1024), A_LoopFileTimeModified)
  }
;msgbox % Props[35]["V"]
}
LV_ModifyCol()
LV_ModifyCol(1, 40)
LV_ModifyCol(3, 150)
return

66GuiClose:
66Guiescape:
Gui,66: Destroy
exitapp
Return

lvgio:
if (A_GuiEvent = "DoubleClick") or (A_GuiEvent = "R")
{
	LV_GetText(CopyV3, A_EventInfo, 3)
	LV_GetText(CopyV4, A_EventInfo, 4)
  LV_GetText(CopyV5, A_EventInfo, 5)
	CopyV := CopyV3 "`t" CopyV4 "`t" CopyV5
	clipboard := CopyV
	CF_ToolTip("已经复制焦点行到剪贴板(双击或右键).", 3000)
}
return

CopySel:
ControlGet, aac, List, Selected, SysListView321, 图片GPS管理
Clipboard := aac
sleep 30
aac := ""
return

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