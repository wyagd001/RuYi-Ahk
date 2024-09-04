;|2.8|2024.08.30|1657
if !WinExist("FTPserver v3.0")
{
  AbsolutePath := GetFullPathName(A_ScriptDir "\..\..")

  RegRead, 访问目录, HKEY_CURRENT_USER\SOFTWARE\Mini FTPserver\FTPserver3\设置, 访问目录
  if !访问目录
  {
    RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Mini FTPserver\FTPserver3\设置, 访问目录, %AbsolutePath%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\SOFTWARE\Mini FTPserver\FTPserver3\设置, 账户, anonymous
    RegWrite, REG_DWORD, HKEY_CURRENT_USER\SOFTWARE\Mini FTPserver\FTPserver3\设置, 上传文件, 1
  }
  sleep 300
  run %AbsolutePath%\引用程序\x32\FTPserver3.exe
  sleep 500
  WinWaitActive FTPserver v3.0 ahk_exe FTPserver3.exe
SetControlDelay -1
  ControlClick, Button8, FTPserver v3.0 ahk_exe FTPserver3.exe, , Left, 2, NA 
}
else
{
  WinActivate,  FTPserver v3.0 ahk_exe FTPserver3.exe
SetControlDelay -1
  ControlClick, Button8, FTPserver v3.0 ahk_exe FTPserver3.exe, , Left, 2, NA 
  ;msgbox, , , , 3
}

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}