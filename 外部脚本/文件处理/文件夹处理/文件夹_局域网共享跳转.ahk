;|3.0|2025.08.25|1729
CandySel := A_Args[1]
if !CF_IsFolder(CandySel)
  Exitapp
SplitPath, CandySel, ShareName
objWMIService := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\cimv2")
LocalShare := objWMIService.ExecQuery("Select * From Win32_Share")
if Instr(CandySel, "\\")
{
  for item in LocalShare
  {
    if (item["Name"] = ShareName)
      Run % item["Path"]
  }
}
return