;|2.8|2024.10.27|1682
#SingleInstance force
#NoEnv
CandySel := A_Args[1]
param := A_Args[2]

if !CandySel or (StrLen(CandySel) > 2 && !param) or (CandySel = "Gui")
{
  DLL := "D:E:F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:"
  DriveGet, DGOPV, List
  Array := StrSplit(DGOPV)
  for k, v In Array
  {
    ;msgbox % k "|" v
    DLL := StrReplace(DLL, v ":")
  }
   DLL := StrReplace(DLL, ":", ":|")

  ;MsgBox, % DriveMap.Add(param, CandySel)

  ;MsgBox, % (Share := DriveMap.Get("p:")) . " - " . ErrorLevel
  ;MsgBox, % DriveMap.Del("p:")
  ;MsgBox, % DriveMap.Add("p:", Share)
  Gui, add, text, x5 y5, 网络文件夹:
  Gui, add, Edit, x120 y5 w300 h20 vwebfolder, %CandySel%

  Gui, add, text, x5 y35, 映射盘符:
  Gui, add, ComboBox, x120 y35 w300 h120 vxunipanfu ggetxunifolder, %Dll%

  Gui, add, text, x5 y+10, 模式:
  Gui, add, ComboBox, x120 y65 w300 h60 vmode gchangemode, 挂载||卸载
  Gui, add, button, x430 yp w60 h20 gruncom, 执行

  Gui, add, text, x5 y+10, 用户名(可选):
  Gui, add, Edit, x120 y95 w300 h20 vusername

  Gui, add, text, x5 y+10, 密码(可选):
  Gui, add, Edit, x120 y125 w300 h20 vuserpass

  Gui, show,, 挂载网络文件夹为磁盘
  GuiControl, ChooseString, xunipanfu, % param
}
if (StrLen(CandySel) = 2)   ; 选中盘符
{
  DriveMap.Del(CandySel)
  ExitApp
}
else if (StrLen(CandySel) > 2) && param
{
  if !InStr(param, ":")
    param := param ":"
  DriveMap.Add(param, CandySel)
  ExitApp
}
Return

runcom:
gui Submit, Nohide
if (mode = "卸载")
{
  DriveMap.del(xunipanfu)
}
else if (mode = "挂载")
{
  DriveMap.Add(xunipanfu, webfolder)
}
return

getxunifolder:
gui Submit, Nohide
if (mode = "卸载")
{
  wbfolder := DriveMap.Get(xunipanfu)
  GuiControl,, webfolder, % wbfolder
}
return

changemode:
gui Submit, Nohide
if (mode = "卸载")
{
  DriveGet, DGOPV, List
  Array := StrSplit(DGOPV)
  for k, v In Array
  {
    ;msgbox % k "|" v
    DGOPV := StrReplace(DGOPV, v, v ":|")
  }
  GuiControl, , xunipanfu, |%DGOPV%
  ;msgbox % DLL
}
else if (mode = "挂载")
{
  DLL := "D:E:F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:"
  DriveGet, DGOPV, List
  Array := StrSplit(DGOPV)
  for k, v In Array
  {
    ;msgbox % k "|" v
    DLL := StrReplace(DLL, v ":")
  }
  DLL := StrReplace(DLL, ":", ":|")
  GuiControl, , xunipanfu, |%DLL%
}
return

guiclose:
Gui, Destroy
ExitApp
; ======================================================================================================================
; Namespace:      DriveMap
; Function:       Add, delete, or query network shares mapped to local drives.
; AHK version:    AHK 1.1.13.01
; Tested on:      Win XP SP3 - AHK A32/U32 (Win 7 - AHK A32/U32 by HotKeyIt, THX)
; Version:        1.0.00.00/2013-11-04/just me
; ======================================================================================================================
Class DriveMap {
   ;--------------------------------------------------------------------------------------------------------------------
   Static MinDL := "D"              ; minimum drive letter
   Static MaxDL := "Z"              ; maximum drive letter
   Static ERROR_BAD_DEVICE := 1200  ; system error code
   ;--------------------------------------------------------------------------------------------------------------------
   __New(P*) {
      Return ""
   }
   ; -------------------------------------------------------------------------------------------------------------------
   ; Method:         Add      -  Makes a connection to a network resource and redirects a local device to the resource.
   ; Parameter:      Drive    -  Drive letter to be mapped to the share followed by a colon (e.g. "Z:")
   ;                             or "*" to map an unused drive letter.
   ;                 Share    -  A null-terminated string that specifies the remote network name.
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 User     -  A string that specifies a user name for making the connection.
   ;                             If omitted or explicitely set empty, the function uses the name of the user running
   ;                             the current process.
   ;                 Pass     -  A string that specifies a password for making the connection.
   ;                             If omitted or explicitely set to "`n", the function uses the current default password
   ;                             associated with the user specified by the User parameter.
   ;                             If Pass is an empty string, the function does not use a password.
   ; Return Values:  Drive letter followed by a colon on success, otherwise an empty string.
   ;                 ErrorLevel contains the system error code, if any.
   ; MSDN:           WNetAddConnection2 -> http://msdn.microsoft.com/en-us/library/aa385413%28v=vs.85%29.aspx
   ;                 NETRESOURCE        -> http://msdn.microsoft.com/en-us/library/aa385353%28v=vs.85%29.aspx
   ; -------------------------------------------------------------------------------------------------------------------
   Add(Drive, Share, User := "", Pass := "`n") {
      Static RESOURCETYPE_DISK := 0x00000001
      Static Flags := 0x04 ; CONNECT_TEMPORARY
      Static offType := 4, offLocal := 16, offRemote := offLocal + A_PtrSize ; NETRESOURCE offsets
      ErrorLevel := 0
      If (Drive <> "*") && !RegExMatch(Drive, "i)^[" . This.MinDL . "-" . This.MaxDL . "]:$") { ; invalid drive
         ErrorLevel := This.ERROR_BAD_DEVICE
         Return ""
      }
      DriveGet, DriveList, List
      Loop, % StrLen(DriveList) { ; check whether the share is already mapped
         DL := SubStr(DriveList, A_Index, 1) . ":"
         If (This.Get(DL) = Share)
            Return DL
      }
      ; Automatic drive mapping by leaving drive empty doesn't work on Win XP, so we have to use the asterisk
      ; and do it manually
      If (Drive = "*") { ; try to find an unused drive letter
         DL := Asc(This.MaxDL)
         While (DL >= Asc(This.MinDL)) {
            If !InStr(DriveList, Chr(DL)) {
               Drive := Chr(DL) . ":"
               Break
            }
            DL--
         }
         If (Drive = "*") { ; drive is still '*', i.e. the share cannot be mapped to a drive letter
            ErrorLevel := This.ERROR_BAD_DEVICE
            Return ""
         }
      }
      VarSetCapacity(NR, (4 * 4) + (A_PtrSize * 4), 0) ; NETRESOURCE structure
      NumPut(RESOURCETYPE_DISK, NR, offType, "UInt")
      NumPut(&Drive, NR, offLocal, "Ptr")
      NumPut(&Share, NR, offRemote, "Ptr")
      PtrPass := Pass = "`n" ? 0 : &Pass
      PtrUser := User = "" ? 0 : &User
      If (Result := DllCall("Mpr.dll\WNetAddConnection2", "Ptr", &NR, "Ptr", PtrPass, "Ptr", PtrUser
                                                        , "UInt", Flags, "UInt")) {
         ErrorLevel := Result
         Return ""
      }
      Return Drive
   }
   ; -------------------------------------------------------------------------------------------------------------------
   ; Method:         Del      -  removes an existing drive mapping to a network share.
   ; Parameter:      Drive    -  drive letter of the mapped local drive followed by a colon (e.g. "Z:").
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 Force    -  specifies whether the disconnection should occur if there are open files or jobs
   ;                             on the connection. Values: True/False
   ; Return Values:  True on success, otherwise False.
   ;                 ErrorLevel contains the system error code, if any.
   ; MSDN:           WNetCancelConnection2 -> http://msdn.microsoft.com/en-us/library/aa385427%28v=vs.85%29.aspx
   ; -------------------------------------------------------------------------------------------------------------------
   Del(Drive, Force := False) {
      ErrorLevel := 0
      If !RegExMatch(Drive, "i)^[" . This.MinDL . "-" . This.MaxDL . "]:$") { ; invalid drive
         ErrorLevel := This.ERROR_BAD_DEVICE
         Return False
      }
      If (Result := DllCall("Mpr.dll\WNetCancelConnection2", "Str", Drive, "UInt", 0, "UInt", !!Force, "UInt")) {
         ErrorLevel := Result
         Return False
      }
      Return True
   }
   ; -------------------------------------------------------------------------------------------------------------------
   ; Method:         Get      -  retrieves the name of the network share associated with the local drive.
   ; Parameter:      Drive    -  drive letter to get the network name for followed by a colon (e.g. "Z:").
   ; Return Values:  The name of the share on success, otherwise an empty string.
   ;                 ErrorLevel contains the system error code, if any.
   ; MSDN:           WNetGetConnection() -> http://msdn.microsoft.com/en-us/library/aa385453%28v=vs.85%29.aspx
   ; -------------------------------------------------------------------------------------------------------------------
   Get(Drive) {
      Static Length := 512
      ErrorLevel := 0
      If !RegExMatch(Drive, "i)^[" . This.MinDL . "-" . This.MaxDL . "]:$") { ; invalid drive
         ErrorLevel := This.ERROR_BAD_DEVICE
         Return ""
      }
      VarSetCapacity(Share, Length * 2, 0)
      If (Result := DllCall("Mpr.dll\WNetGetConnection", "Str", Drive, "Str", Share, "UIntP", Length, "UInt")) {
         ErrorLevel := Result
         Return ""
      }
      Return Share
   }
}
