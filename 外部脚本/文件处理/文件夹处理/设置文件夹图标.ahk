;|2.9|2024.12.29|1697
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
CandySel :=  A_Args[1]
desktopfile := CandySel "\desktop.ini"
if fileexist(desktopfile)
{
  IniRead, cur_icon, % desktopfile, .ShellClassInfo, IconResource
}
SetBatchLines -1

Gui Font, s9, Segoe UI
Gui Add, Text, x10 y10 w80 h23, 当前图标:
Gui Add, Edit, xp+60 yp w400 h21 viconf gshowicon
Gui Add, Button, xp+410 yp w80 h23 gsIcon, 选择图标
if cur_icon
{
  if InStr(cur_icon, ",")
  {
    Array := StrSplit(cur_icon, ",")
    iconPath := Array[1]
    iconIndex := Array[2]
    Gui Add, Picture, xp+85 yp w32 h32 +Icon%iconIndex% viconp, %iconPath%
  }
  else
    Gui Add, Picture, xp+85 yp w32 h32 viconp, %cur_icon%
  GuiControl,, iconf, % cur_icon
}
else
  Gui Add, Picture, xp+85 yp w32 h32 +Icon5 viconp, shell32.dll

Gui Add, Text, x10 y55 w68 h23 +0x200, 提示文本:
Gui Add, Edit, xp+60 yp w400 h21 vfoldertip
Gui Add, Button, x315 y100 w80 h23 gok, 确定
Gui Add, Button, xp+85 yp w80 h23 gGuiClose, 取消
Gui Add, Button, xp+85 yp w80 h23 gHdef, 恢复默认
Title := Strlen(CandySel) > 40 ? SubStr0(CandySel, 1, 20) . "..." . SubStr0(CandySel, -20) : CandySel
Gui Show, w600 h140, 为文件夹 %Title% 更改图标
Return

sIcon:
sIconPath := A_WinDir . "\system32\shell32.dll"
VarSetCapacity(sIconPath, 260)
DllCall("shell32\PickIconDlg", "Uint", null, "str", sIconPath, "Uint", 260, "intP", nIndex:=0)
;msgbox % sIconPath "," nIndex
if sIconPath
{
  GuiControl,, iconf, % sIconPath "," nIndex
  ;GuiControl,, iconp, *icon%nIndex% *w32 *h-1 %sIconPath%
  gosub showicon
}
Return

SubStr0(String, Pos0, Len0 = 360, StrCheck = 3)
{
	If (Pos0 <> 1 && Pos0+StrLen(String) <> 1 && StrLenW(String0 := SubStr(String, 1, Pos0 > 0 ? Pos0-1 : StrLen(String) + Pos0 - 1)) = StrLenW(SubStr(String0, 1, StrLen(String0)-1)))
		Len0 := Mod(StrCheck, 2) = 1 ? Len0 + 1 : Pos0 = 0 ? 0 : Len0 - 1, Pos0 := Mod(StrCheck, 2) = 1 ? Pos0 - 1 : Pos0 + 1
return SubStr(String, Pos0, (StrLenW(SubStr(String, Pos0, Len0-1)) = StrLenW(SubStr(String, Pos0, Len0))) ? StrCheck // 2 = 1 ? Len0+1 : Len0-1 : Len0)
}

StrLenW(String)
{
	RegExReplace(String, "(?:[^[:ascii:]]{2}|[[:ascii:]])", "", ErrorLevel)
return ErrorLevel
}

GuiEscape:
GuiClose:
    ExitApp

ok:
Gui, Submit, NoHide
SetFolderIcon(CandySel, iconf, foldertip)
RefreshExplorer()
;msgbox % foldertip
return

showicon:
gui, submit, nohide
if iconf
{
  Array := StrSplit(iconf, ",")
  if (Array[2] < 0)
  {
    Icon_index := IndexOfIconResource(ExpandEnvVars(Array[1]), abs(Array[2]))
    ;msgbox % Icon_index
  }
  else
    Icon_index := Array[2] + 1
  GuiControl,, iconp, % Array[1] ? "*Icon" Icon_index " " Array[1] : "*Icon0" " " iconf
}
return

ExpandEnvVars(string){
   ; Find length of dest string:
   nSize := DllCall("ExpandEnvironmentStrings", "Str", string, "Str", NULL, "UInt", 0, "UInt")
  ,VarSetCapacity(Dest, size := (nSize * (1 << !!A_IsUnicode)) + !A_IsUnicode) ; allocate dest string
  ,DllCall("ExpandEnvironmentStrings", "Str", string, "Str", Dest, "UInt", size, "UInt") ; fill dest string
   return Dest
}

IndexOfIconResource(Filename, ID)
{
    hmod := DllCall("GetModuleHandle", "str", Filename, "ptr")
    ; If the DLL isn't already loaded, load it as a data file.
    loaded := !hmod
        && hmod := DllCall("LoadLibraryEx", "str", Filename, "ptr", 0, "uint", 0x2, "ptr")
    
    enumproc := RegisterCallback("IndexOfIconResource_EnumIconResources","F")
    param := {ID: ID, index: 0, result: 0}
    
    ; Enumerate the icon group resources. (RT_GROUP_ICON=14)
    DllCall("EnumResourceNames", "ptr", hmod, "ptr", 14, "ptr", enumproc, "ptr", &param)
    DllCall("GlobalFree", "ptr", enumproc)
    
    ; If we loaded the DLL, free it now.
    if loaded
        DllCall("FreeLibrary", "ptr", hmod)
    
    return param.result
}

IndexOfIconResource_EnumIconResources(hModule, lpszType, lpszName, lParam)
{
    param := Object(lParam)
    param.index += 1

    if (lpszName = param.ID)
    {
        param.result := param.index
        return false    ; break
    }
    return true
}

SetFolderIcon(folderPath, iconPath, InfoTip := "")
{
  if InStr(iconPath, ",")
  {
    Array := StrSplit(iconPath, ",")
    iconPath := Array[1]
    iconIndex := Array[2]
  }
  static FCSM_INFOTIP := 0x4, FCSM_ICONFILE := 0x10, FCS_FORCEWRITE := 0x2
  if !A_IsUnicode  {
     VarSetCapacity(WiconPath, StrPut(iconPath, "UTF-16")*2, 0)
     StrPut(iconPath, &WiconPath, "UTF-16")
  }
  VarSetCapacity(SHFOLDERCUSTOMSETTINGS, size := 4*5 + A_PtrSize*10, 0)
  NumPut(size, SHFOLDERCUSTOMSETTINGS)
  NumPut(0x14, SHFOLDERCUSTOMSETTINGS, 4)
  NumPut(&InfoTip, SHFOLDERCUSTOMSETTINGS, 4*2 + A_PtrSize*4)
  NumPut(A_IsUnicode ? &iconPath : &WiconPath, SHFOLDERCUSTOMSETTINGS, 4*2 + A_PtrSize*8)
  NumPut(iconIndex, SHFOLDERCUSTOMSETTINGS, 4*2 + A_PtrSize*9 + 4)
  DllCall("Shell32\SHGetSetFolderCustomSettings", Ptr, &SHFOLDERCUSTOMSETTINGS, WStr, folderPath, UInt, FCS_FORCEWRITE)
}

Hdef:
FileDelete % desktopfile
RefreshExplorer()
GuiControl,, iconf
sleep 200
GuiControl,, iconp, *icon5 *w32 *h-1 shell32.dll
return
/*
typedef struct {
  DWORD       dwSize;
  DWORD       dwMask;
  SHELLVIEWID *pvid;
  LPWSTR      pszWebViewTemplate;
  DWORD       cchWebViewTemplate;
  LPWSTR      pszWebViewTemplateVersion;
  LPWSTR      pszInfoTip;
  DWORD       cchInfoTip;
  CLSID       *pclsid;
  DWORD       dwFlags;
  LPWSTR      pszIconFile;
  DWORD       cchIconFile;
  int         iIconIndex;
  LPWSTR      pszLogo;
  DWORD       cchLogo;
} SHFOLDERCUSTOMSETTINGS, *LPSHFOLDERCUSTOMSETTINGS;
*/

RefreshExplorer()
{ ; by teadrinker on D437 @ tiny.cc/refreshexplorer
	local Windows := ComObjCreate("Shell.Application").Windows
	Windows.Item(ComObject(0x13, 8)).Refresh()
	for Window in Windows
		if (Window.Name != "Internet Explorer")
			Window.Refresh()
}