;|2.0|2023.07.01|1231
;来源网址: https://www.autohotkey.com/board/topic/63210-modify-system-path-gui
#SingleInstance, Force
#NoEnv
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\..\脚本图标\如意\ef58.ico"
RegRead, UPL, HKCU\Environment, PATH
RegRead, SPL, HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment, PATH
firstUPL := UPL
firstSPL := SPL

Gui, +Delimiter`;

Gui, Add, Text, x10 y10, 用户 Path:
Gui, Add, Text, xp+410 yp, 系统 Path:
Gui, Add, ListBox, x10    yp+20  w400 r10 +0x100 vUserPath gEditEntry AltSubmit, %UPL%
Gui, Add, ListBox, xp+410 yp     w400 r10 +0x100 vSysPath gEditEntry AltSubmit, %SPL%
Gui, Font, s12
Gui, Add, Button, x10     yp+130 w70  vuseradd     gNew,     新增
Gui, Add, Button, xp+70   yp     w70  vuserdel     gDelete,  删除
Gui, Add, Button, xp+70   yp     w120 vuserjump    gjreg,    跳转到注册表
Gui, Add, Button, xp+120  yp     w70  vuserbackup  gbackup,  备份
Gui, Add, Button, xp+70   yp     w70  vuserRestore grestore, 恢复
Gui, Add, Button, x420    yp     w70  vsysadd      gNew,     新增
Gui, Add, Button, xp+70   yp     w70  vsysdel      gDelete,  删除
Gui, Add, Button, xp+70   yp     w120 vsysjump     gjreg,    跳转到注册表
Gui, Add, Button, xp+120  yp     w70  vsysbackup   gbackup,  备份
Gui, Add, Button, xp+70   yp     w70  vsysRestore  grestore, 恢复

Gui, Add, Button, x10     yp+50  w120 gsysedit, 系统编辑界面
Gui, Add, Button, xp+670  yP     w70 gSubmit, 保存
Gui, Add, Button, xp+70   yp     w70 gExit, 取消

Gui, Show,, 环境变量编辑
return

EditEntry:
if (A_GuiControl = "UserPath")
{
	CurPL := UPL
	CurLB := "UserPath"
}
if (A_GuiControl = "SysPath")
{
	CurPL := SPL
	CurLB := "SysPath"
}

if (a_guievent == "DoubleClick" && a_eventinfo)
{
	Gui +OwnDialogs
	RegExMatch(CurPL, "P)^(?:(?<E>[^;]*)(?:;|$)){" a_eventinfo "}", _)
	_En := IB( "编辑 PATH 变量条目", substr(CurPL, _PosE, _LenE))
	if (ErrorLevel == 0)
	{
		if (InStr(FileExist(ExpEnv(_En)),"D"))
		{
			CurPL := substr(CurPL, 1, _PosE-1) _En (_PosE+_LenE+1 < strlen(CurPL) ? ";" substr(CurPL, _PosE+_LenE+1) : "")
			GuiControl,, % CurLB, `;%CurPL%
			if (CurLB = "UserPath")
				UPL := CurPL
			if (CurLB = "SysPath")
				SPL := CurPL
		}
		else
			MsgBox, , SysEnv, 路径不是目录.
	}
}
return

New:
if (A_GuiControl = "useradd")
{
	CurPL := UPL
	CurLB := "UserPath"
}
if (A_GuiControl = "sysadd")
{
	CurPL := SPL
	CurLB := "SysPath"
}

add := IB( "新增 PATH 条目" )
if (instr(fileexist(ExpEnv(add)),"D"))
{
	CurPL .= (strlen(CurPL) > 0 ? ";" : "") add
	GuiControl,, % CurLB, `;%CurPL%
	if (CurLB = "UserPath")
		UPL := CurPL
	if (CurLB = "SysPath")
		SPL := CurPL
}
return

Delete:
if (A_GuiControl = "userdel")
{
	CurPL := UPL
	CurLB := "UserPath"
}
if (A_GuiControl = "sysdel")
{
	CurPL := SPL
	CurLB := "SysPath"
}

GuiControlGet, entry,, % CurLB   ; 有选项 AltSubmit 则获取位置编号
if (entry)
{
	Gui, +OwnDialogs
	MsgBox, 4, SysEnv -- 确认, 从 PATH 变量中移除条目 #%entry%?
	IfMsgBox Yes
	{   ; 计算选中行的起始位置和长度
		RegExMatch(CurPL, "P)^(?:(?<E>[^;]*)(?:;|$)){" entry "}", _)
		CurPL := SubStr(CurPL, 1, max(_PosE-2,0)) (_PosE+_LenE+1 < strlen(CurPL) ? ";" substr(CurPL, _PosE+_LenE+1) : "")
		GuiControl,, % CurLB, `;%CurPL%
		if (CurLB = "UserPath")
			UPL := CurPL
		if (CurLB = "SysPath")
			SPL := CurPL
	}
}
return

backup:
if (A_GuiControl = "userbackup")
{
	Env_UserBackup()
}
if (A_GuiControl = "sysbackup")
{
	Env_SystemBackup()
}
return

restore:
if (A_GuiControl = "userRestore")
{
	Env_UserRestore()
}
if (A_GuiControl = "sysRestore")
{
	Env_SystemRestore()
}
return


jreg:
if (A_GuiControl = "userjump")
	f_OpenReg("HKCU\Environment")
if (A_GuiControl = "sysjump")
	f_OpenReg("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment")
return

f_OpenReg(RegPath)
{
	RegPath := LTrim(RegPath, "[")
	RegPath := RTrim(RegPath, "]")
	StringLeft, RegPathFirst4, RegPath, 4
	if RegPathFirst4 = HKCR
		StringReplace, RegPath, RegPath, HKCR, HKEY_CLASSES_ROOT
	else if RegPathFirst4 = HKCU
		StringReplace, RegPath, RegPath, HKCU, HKEY_CURRENT_USER
	else if RegPathFirst4 = HKLM
		StringReplace, RegPath, RegPath, HKLM, HKEY_LOCAL_MACHINE
	else if RegPathFirst4 = HKCC
		StringReplace, RegPath, RegPath, HKCC, HKEY_CURRENT_CONFIG
	else if RegPathFirst4 = HKU
		StringReplace, RegPath, RegPath, HKU, HKEY_USERS

	; 将字串中的前两个"＿"(全角) 替换为“_"(半角)
	StringReplace, RegPath, RegPath, ＿, _
	StringReplace, RegPath, RegPath, ＿, _
	; 替换字串中第一个“, ”为"\"
	StringReplace, RegPath, RegPath, `,%A_Space%, \
	; 替换字串中第一个“,”为"\"
	StringReplace, RegPath, RegPath, `,, \
	; 将字串中的所有"/" 替换为“\"
	StringReplace, RegPath, RegPath, /, \, All
	; 将字串中的所有"／"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ／, \, All
	; 将字串中的所有"＼"(全角) 替换为“\"(半角)
	StringReplace, RegPath, RegPath, ＼, \, All
	StringReplace, RegPath, RegPath, %A_Space%\, \, All
	StringReplace, RegPath, RegPath, \%A_Space%, \, All
	; 将字串中的所有“\\”替换为“\”
	StringReplace, RegPath, RegPath, \\, \, All

	RegRead, MyComputer, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey
	f_Split2(MyComputer, "\", MyComputer, aaa)
	MyComputer := MyComputer ? MyComputer : (A_OSVersion="WIN_XP")?"我的电脑":"计算机"
	IfNotInString, RegPath, %MyComputer%\
		RegPath := MyComputer "\" RegPath
	;tooltip % RegPath

	IfWinExist, ahk_class RegEdit_RegEdit
	{
		RunWait, % "cmd.exe /c taskkill /IM regedit.exe", , Hide
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe
	}
	Else
	{
		RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit, LastKey, %RegPath%
		Run, regedit.exe ;-m
	}
return
}

f_Split2(String, Seperator, ByRef LeftStr, ByRef RightStr)
{
	SplitPos := InStr(String, Seperator)
	if SplitPos = 0 ; Seperator not found, L = Str, R = ""
	{
		LeftStr := String
		RightStr:= ""
	}
	else
	{
		SplitPos--
		StringLeft, LeftStr, String, %SplitPos%
		SplitPos++
		StringTrimLeft, RightStr, String, %SplitPos%
	}
	return
}

sysedit:
run, rundll32.exe sysdm.cpl`,EditEnvironmentVariables
return

Submit:
Gui, +OwnDialogs
if (firstUPL != UPL)
{
	MsgBox, 1, SysEnv -- 保存更改, 更改用户 Path 为:`n`n%UPL%
	IfMsgBox, OK
	{
		RegWrite, REG_EXPAND_SZ, HKCU\Environment, PATH, %UPL%
		If !ErrorLevel
		{
			firstUPL := UPL
			RefreshEnvironment()
			MsgBox, 0, SysEnv -- 成功!, 修改用户 PATH 变量成功!
		}
		Else
			MsgBox,, SysEnv, 发生错误, 无法保存更改.
	}
	Else
		MsgBox, , SysEnv -- 取消, 退出.
}
if (firstSPL != SPL)
{
	MsgBox, 1, SysEnv --  保存更改, 更改系统 Path 为:`n`n%SPL%
	IfMsgBox, OK
	{
		RegWrite, REG_EXPAND_SZ, HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment, PATH, %SPL%
		If !ErrorLevel
		{
			firstSPL := SPL
			RefreshEnvironment()
			MsgBox, 0, SysEnv -- 成功!, 修改系统 PATH 变量成功!
		}
		Else
			MsgBox,, SysEnv, 发生错误, 无法保存更改.
	}
	Else
		MsgBox,, SysEnv -- 取消, 退出.
}
return

Exit:
GuiClose:
GuiEscape:
GuiEsc:
ExitApp

IB( prompt, default="" )
{
	InputBox, out, SysEnv -- %prompt%, %prompt%:, , , , , , , , %default%
	return out
}

max( a, b )
{
	return a > b ? a : b
}

ExpEnv(str)
{ 
	; by Lexikos: http://www.autohotkey.com/forum/viewtopic.php?p=327849#327849
	if sz:=DllCall("ExpandEnvironmentStrings", "uint", &str, "uint", 0, "uint", 0)
	{
		VarSetCapacity(dst, A_IsUnicode ? sz*2:sz)
		if DllCall("ExpandEnvironmentStrings", "uint", &str, "str", dst, "uint", sz)
			return dst
	}
	return ""
}

; Script     Environment.ahk
; License:   MIT License
; Author:    Edison Hua (iseahound)
; Github:    https://github.com/iseahound/Environment.ahk
; Date       2021-02-05
; Version    1.0.0
;
; ExpandEnvironmentStrings(), RefreshEnvironment()   by NoobSawce + DavidBiesack (modified by BatRamboZPM)
;   https://autohotkey.com/board/topic/63312-reload-systemuser-environment-variables/
;
; Global Error Values
;   0 - Success.
;  -1 - Error when writing value to registry.
;  -2 - Value already added or value already deleted.
;  -3 - Need to Run As Administrator.
;
; Notes
;   SendMessage 0x1A, 0, "Environment",, ahk_id 0xFFFF ; 0x1A is WM_SETTINGCHANGE
;      - The above code will broadcast a message stating there has been a change of environment variables.
;      - Some programs have not implemented this message.
;      - v1.00 replaces this with a powershell command using asyncronous execution providing 10x speedup.
;   RefreshEnvironment()
;      - This function will update the environment variables within AutoHotkey.
;      - Command prompts launched by AutoHotkey inherit AutoHotkey's environment.
;   Any command prompts currently open will not have their environment variables changed.
;      - Please use the RefreshEnv.cmd batch script found at:
;        https://github.com/chocolatey-archive/chocolatey/blob/master/src/redirects/RefreshEnv.cmd
Env_UserAdd(name, value, type := "", location := ""){
   value    := (value ~= "^\.\.\\") ? GetFullPathName(value) : value
   location := (location == "")     ? "HKCU\Environment"     : location

   RegRead registry, % location, % name
   if (ErrorLevel)
      return -1
   Loop Parse, registry, % ";"
      if (A_LoopField == value)
         return -2
   registry .= (registry ~= "(^$|;$)") ? "" : ";"
   value := registry . value
   type := (type) ? type : (value ~= "%") ? "REG_EXPAND_SZ" : "REG_SZ"
   RegWrite % type, % location, % name, % value
   SettingChange()
   RefreshEnvironment()
   return (ErrorLevel) ? -1 : 0
}

Env_SystemAdd(name, value, type := ""){
   return (A_IsAdmin) ? Env_UserAdd(name, value, type, "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment") : -3
}

Env_UserSub(name, value, type := "", location := ""){
   value    := (value ~= "^\.\.\\") ? GetFullPathName(value) : value
   location := (location == "")     ? "HKCU\Environment"     : location

   RegRead registry, % location, % name
   if ErrorLevel
      return -2

   Loop Parse, registry, % ";"
      if (A_LoopField != value) {
         output .= (A_Index > 1 && output != "") ? ";" : ""
         output .= A_LoopField
      }

   if (output == registry)
      return -2

   if (output != "") {
      type := (type) ? type : (output ~= "%") ? "REG_EXPAND_SZ" : "REG_SZ"
      RegWrite % type, % location, % name, % output
   }
   else
      RegDelete % location, % name
   SettingChange()
   RefreshEnvironment()
   return (ErrorLevel) ? -1 : 0
}

Env_SystemSub(name, value, type := ""){
   return (A_IsAdmin) ? Env_UserSub(name, value, type, "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment") : -3
}

Env_UserNew(name, value := "", type := "", location := ""){
   type := (type) ? type : (value ~= "%") ? "REG_EXPAND_SZ" : "REG_SZ"
   RegWrite % type, % (location == "") ? "HKCU\Environment" : location, % name, % value
   SettingChange()
   RefreshEnvironment()
   return (ErrorLevel) ? -1 : 0
}

Env_SystemNew(name, value := "", type := ""){
   return (A_IsAdmin) ? Env_UserNew(name, value, type, "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment") : -3
}

; Value does nothing except let me easily change between functions.
Env_UserDel(name, value := "", location := ""){
   RegDelete % (location == "") ? "HKCU\Environment" : location, % name
   SettingChange()
   RefreshEnvironment()
   return 0
}

Env_SystemDel(name, value := ""){
   return (A_IsAdmin) ? Env_UserDel(name, value, "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment") : -3
}

Env_UserRead(name, value := "", location := ""){
   RegRead registry, % (location == "") ? "HKCU\Environment" : location, % name
   if (value != "") {
      Loop Parse, registry, % ";"
         if (A_LoopField = value)
            return A_LoopField
      return ; Value not found
   }
   return registry
}

Env_SystemRead(name, value := ""){
   return Env_UserRead(name, value, "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment")
}

; Value does nothing except let me easily change between functions.
Env_UserSort(name, value := "", location := ""){
   RegRead registry, % (location == "") ? "HKCU\Environment" : location, % name
   Sort registry, % "D;"
   type := (type) ? type : (registry ~= "%") ? "REG_EXPAND_SZ" : "REG_SZ"
   RegWrite % type, % (location == "") ? "HKCU\Environment" : location, % name, % registry
   return (ErrorLevel) ? -1 : 0
}

Env_SystemSort(name, value := ""){
   return (A_IsAdmin) ? Env_UserSort(name, value, "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment") : -3
}

; Value does nothing except let me easily change between functions.
Env_UserRemoveDuplicates(name, value := "", location := ""){
   RegRead registry, % (location == "") ? "HKCU\Environment" : location, % name
   Sort registry, % "U D;"
   type := (type) ? type : (registry ~= "%") ? "REG_EXPAND_SZ" : "REG_SZ"
   RegWrite % type, % (location == "") ? "HKCU\Environment" : location, % name, % registry
   return (ErrorLevel) ? -1 : 0
}

Env_SystemRemoveDuplicates(name, value := ""){
   return (A_IsAdmin) ? Env_UserRemoveDuplicates(name, value, "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment") : -3
}

Env_UserBackup(fileName := "UserEnvironment.reg", location := ""){
   _cmd .= (A_Is64bitOS != A_PtrSize >> 3)    ? A_WinDir "\SysNative\cmd.exe"   : A_ComSpec
   _cmd .= " /K " Chr(0x22) "reg export " Chr(0x22)
   _cmd .= (location == "")                   ? "HKCU\Environment" : location
   _cmd .= Chr(0x22) " " Chr(0x22)
   _cmd .= fileName
   _cmd .= Chr(0x22) . Chr(0x22) . " && pause && exit"
   try RunWait % _cmd
   catch
      return "FAIL"
   return "SUCCESS"
}

Env_SystemBackup(fileName := "SystemEnvironment.reg"){
   return Env_UserBackup(fileName, "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment")
}

Env_UserRestore(fileName := "UserEnvironment.reg"){
   try RunWait % fileName
   catch
      return "FAIL"
   return "SUCCESS"
}

Env_SystemRestore(fileName := "SystemEnvironment.reg"){
   try RunWait % fileName
   catch
      return "FAIL"
   return "SUCCESS"
}

RefreshEnvironment()
{
   Path := ""
   PathExt := ""
   RegKeys := "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment,HKCU\Environment"
   Loop Parse, RegKeys, CSV
   {
      Loop Reg, % A_LoopField, V
      {
         RegRead Value
         If (A_LoopRegType == "REG_EXPAND_SZ" && !ExpandEnvironmentStrings(Value))
            Continue
         If (A_LoopRegName = "PATH")
            Path .= Value . ";"
         Else If (A_LoopRegName = "PATHEXT")
            PathExt .= Value . ";"
         Else
            EnvSet % A_LoopRegName, % Value
      }
   }
   EnvSet PATH, % Path
   EnvSet PATHEXT, % PathExt
}

ExpandEnvironmentStrings(ByRef vInputString)
{
   ; get the required size for the expanded string
   vSizeNeeded := DllCall("ExpandEnvironmentStrings", "Str", vInputString, "Int", 0, "Int", 0)
   If (vSizeNeeded == "" || vSizeNeeded <= 0)
      return False ; unable to get the size for the expanded string for some reason

   vByteSize := vSizeNeeded + 1
   VarSetCapacity(vTempValue, vByteSize*(A_IsUnicode?2:1))

   ; attempt to expand the environment string
   If (!DllCall("ExpandEnvironmentStrings", "Str", vInputString, "Str", vTempValue, "Int", vSizeNeeded))
      return False ; unable to expand the environment string
   vInputString := vTempValue

   ; return success
   Return True
}

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}

; Modified: AbsolutePath
RPath_Absolute(AbsolutPath, RelativePath, s="\") {

   len := InStr(AbsolutPath, s, "", InStr(AbsolutPath, s . s) + 2) - 1   ;get server or drive string length
   pr := SubStr(AbsolutPath, 1, len)                                     ;get server or drive name
   AbsolutPath := SubStr(AbsolutPath, len + 1)                           ;remove server or drive from AbsolutPath
   If InStr(AbsolutPath, s, "", 0) = StrLen(AbsolutPath)                 ;remove last \ from AbsolutPath if any
      StringTrimRight, AbsolutPath, AbsolutPath, 1

   If InStr(RelativePath, s) = 1                                         ;when first char is \ go to AbsolutPath of server or drive
      AbsolutPath := "", RelativePath := SubStr(RelativePath, 2)        ;set AbsolutPath to nothing and remove one char from RelativePath
   Else If InStr(RelativePath,"." s) = 1                                 ;when first two chars are .\ add to current AbsolutPath directory
      RelativePath := SubStr(RelativePath, 3)                           ;remove two chars from RelativePath
   Else If InStr(RelativePath,".." s) = 1 {                              ;otherwise when first 3 char are ..\
      StringReplace, RelativePath, RelativePath, ..%s%, , UseErrorLevel     ;remove all ..\ from RelativePath
      Loop, %ErrorLevel%                                                    ;for all ..\
         AbsolutPath := SubStr(AbsolutPath, 1, InStr(AbsolutPath, s, "", 0) - 1)  ;remove one folder from AbsolutPath
   } Else                                                                ;relative path does not need any substitution
      pr := "", AbsolutPath := "", s := ""                              ;clear all variables to just return RelativePath

   Return, pr . AbsolutPath . s . RelativePath                           ;concatenate server + AbsolutPath + separator + RelativePath
}

; Source: https://gist.github.com/alphp/78fffb6d69e5bb863c76bbfc767effda
/*
$Script = @'
Add-Type -Namespace Win32 -Name NativeMethods -MemberDefinition @"
  [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
  public static extern IntPtr SendMessageTimeout(IntPtr hWnd, uint Msg, UIntPtr wParam, string lParam, uint fuFlags, uint uTimeout, out UIntPtr lpdwResult);
"@

function Send-SettingChange {
  $HWND_BROADCAST = [IntPtr] 0xffff;
  $WM_SETTINGCHANGE = 0x1a;
  $result = [UIntPtr]::Zero

  [void] ([Win32.Nativemethods]::SendMessageTimeout($HWND_BROADCAST, $WM_SETTINGCHANGE, [UIntPtr]::Zero, "Environment", 2, 5000, [ref] $result))
}

Send-SettingChange;
'@

$ByteScript  = [System.Text.Encoding]::Unicode.GetBytes($Script)
[System.Convert]::ToBase64String($ByteScript)
*/

; To verify the encoded command, start a powershell terminal and paste the script above.
; 10x faster than SendMessage 0x1A, 0, "Environment",, ahk_id 0xFFFF ; 0x1A is WM_SETTINGCHANGE
SettingChange() {

   static _cmd := "
   ( LTrim
   QQBkAGQALQBUAHkAcABlACAALQBOAGEAbQBlAHMAcABhAGMAZQAgAFcAaQBuADMA
   MgAgAC0ATgBhAG0AZQAgAE4AYQB0AGkAdgBlAE0AZQB0AGgAbwBkAHMAIAAtAE0A
   ZQBtAGIAZQByAEQAZQBmAGkAbgBpAHQAaQBvAG4AIABAACIACgAgACAAWwBEAGwA
   bABJAG0AcABvAHIAdAAoACIAdQBzAGUAcgAzADIALgBkAGwAbAAiACwAIABTAGUA
   dABMAGEAcwB0AEUAcgByAG8AcgAgAD0AIAB0AHIAdQBlACwAIABDAGgAYQByAFMA
   ZQB0ACAAPQAgAEMAaABhAHIAUwBlAHQALgBBAHUAdABvACkAXQAKACAAIABwAHUA
   YgBsAGkAYwAgAHMAdABhAHQAaQBjACAAZQB4AHQAZQByAG4AIABJAG4AdABQAHQA
   cgAgAFMAZQBuAGQATQBlAHMAcwBhAGcAZQBUAGkAbQBlAG8AdQB0ACgASQBuAHQA
   UAB0AHIAIABoAFcAbgBkACwAIAB1AGkAbgB0ACAATQBzAGcALAAgAFUASQBuAHQA
   UAB0AHIAIAB3AFAAYQByAGEAbQAsACAAcwB0AHIAaQBuAGcAIABsAFAAYQByAGEA
   bQAsACAAdQBpAG4AdAAgAGYAdQBGAGwAYQBnAHMALAAgAHUAaQBuAHQAIAB1AFQA
   aQBtAGUAbwB1AHQALAAgAG8AdQB0ACAAVQBJAG4AdABQAHQAcgAgAGwAcABkAHcA
   UgBlAHMAdQBsAHQAKQA7AAoAIgBAAAoACgBmAHUAbgBjAHQAaQBvAG4AIABTAGUA
   bgBkAC0AUwBlAHQAdABpAG4AZwBDAGgAYQBuAGcAZQAgAHsACgAgACAAJABIAFcA
   TgBEAF8AQgBSAE8AQQBEAEMAQQBTAFQAIAA9ACAAWwBJAG4AdABQAHQAcgBdACAA
   MAB4AGYAZgBmAGYAOwAKACAAIAAkAFcATQBfAFMARQBUAFQASQBOAEcAQwBIAEEA
   TgBHAEUAIAA9ACAAMAB4ADEAYQA7AAoAIAAgACQAcgBlAHMAdQBsAHQAIAA9ACAA
   WwBVAEkAbgB0AFAAdAByAF0AOgA6AFoAZQByAG8ACgAKACAAIABbAHYAbwBpAGQA
   XQAgACgAWwBXAGkAbgAzADIALgBOAGEAdABpAHYAZQBtAGUAdABoAG8AZABzAF0A
   OgA6AFMAZQBuAGQATQBlAHMAcwBhAGcAZQBUAGkAbQBlAG8AdQB0ACgAJABIAFcA
   TgBEAF8AQgBSAE8AQQBEAEMAQQBTAFQALAAgACQAVwBNAF8AUwBFAFQAVABJAE4A
   RwBDAEgAQQBOAEcARQAsACAAWwBVAEkAbgB0AFAAdAByAF0AOgA6AFoAZQByAG8A
   LAAgACIARQBuAHYAaQByAG8AbgBtAGUAbgB0ACIALAAgADIALAAgADUAMAAwADAA
   LAAgAFsAcgBlAGYAXQAgACQAcgBlAHMAdQBsAHQAKQApAAoAfQAKAAoAUwBlAG4A
   ZAAtAFMAZQB0AHQAaQBuAGcAQwBoAGEAbgBnAGUAOwA=
   )"
   Run % "powershell -NoProfile -EncodedCommand " _cmd,, Hide
}