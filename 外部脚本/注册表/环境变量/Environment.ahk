#Requires AutoHotkey v1.1.33+
;1232
CandySel :=  A_Args[1]
if !CandySel
	exitapp
if !Env_SystemRead("PATH", CandySel)
{
	Env_SystemAdd("PATH", CandySel)
	msgbox 已经成功将路径 "%CandySel%" 添加到 Path 变量中.
}
else
	msgbox Path 变量中已经包含该路径.`n%CandySel%
return

/*
Env_UserBackup()    ; Creates a backup of the user's environment variables. 
Env_SystemBackup()  ; Creates a backup of the system environment variables.

; Add your binaries to the user PATH
Env_UserAdd("PATH", "C:\bin")
; Remove a directory from user PATH
Env_UserSub("PATH", "C:\bin")
; Create a new Environment Variable
Env_UserNew("ANSWER", "42")
; Read an existing Environment Variable
key := Env_UserRead("ANSWER") ; returns 42
; Delete an Environment Variable
Env_UserDel("ANSWER")

;来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=30977&sid=e55c033a4297dd06138e2222a268f1cc
; Use EnvSystem to edit the System Environment Variables
Env_SystemAdd("PATH", "X:\Backup\bin")
; Sort System PATH in alphabetical order
Env_SystemSort("PATH")
; Remove pesky duplicate entries in your system PATH
Env_SystemRemoveDuplicates("PATH")
*/

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