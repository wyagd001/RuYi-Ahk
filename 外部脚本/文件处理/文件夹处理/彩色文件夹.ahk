;|2.1|2023.07.27|多条目
;来源网址: https://www.autohotkey.com/boards/viewtopic.php?style=19&t=85170
CandySel := A_Args[1]
param := A_Args[2]
if (param = "")
	param := "红色"
if InStr(FileExist(CandySel), "D")
{
	iconPath := GetFullPathName(A_ScriptDir "\..\..\..\脚本图标\彩色文件夹\" param ".ico")
	if FileExist(iconPath)
		SetFolderIcon(CandySel, iconPath)
}
DllCall("Shell32\SHChangeNotify", "Int", SHCNE_ASSOCCHANGED := 0x8000000, "UInt", 0, "Ptr", 0, "Ptr", 0)
return

; 要生效会自动将文件夹的属性设置为只读
SetFolderIcon(folderPath, iconPath, iconIndex := 0)  {
   static FCSM_ICONFILE := 0x10, FCS_FORCEWRITE := 0x2
   if !A_IsUnicode  {
      VarSetCapacity(WiconPath, StrPut(iconPath, "UTF-16")*2, 0)
      StrPut(iconPath, &WiconPath, "UTF-16")
   }
   VarSetCapacity(SHFOLDERCUSTOMSETTINGS, size := 4*5 + A_PtrSize*10, 0)
   NumPut(size, SHFOLDERCUSTOMSETTINGS)
   NumPut(FCSM_ICONFILE, SHFOLDERCUSTOMSETTINGS, 4)
   NumPut(A_IsUnicode ? &iconPath : &WiconPath, SHFOLDERCUSTOMSETTINGS, 4*2 + A_PtrSize*8)
   NumPut(iconIndex, SHFOLDERCUSTOMSETTINGS, 4*2 + A_PtrSize*9 + 4)
   DllCall("Shell32\SHGetSetFolderCustomSettings", Ptr, &SHFOLDERCUSTOMSETTINGS, WStr, folderPath, UInt, FCS_FORCEWRITE)
}

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}