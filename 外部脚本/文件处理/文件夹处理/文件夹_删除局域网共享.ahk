;|3.0|2025.08.19|1726
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
      item.Delete()
  }
}
else
{
  for item in LocalShare
  {
    if (item["Path"] = CandySel)
      item.Delete()
  }
}
return