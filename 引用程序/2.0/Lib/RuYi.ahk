RuYi_GetRuYiDir()
{
  if FileExist(A_ScriptDir "\如一.exe")
    return A_ScriptDir
  if FileExist(A_ScriptDir "\..\如一.exe")
    return GetFullPathName(A_ScriptDir "\..")
  else if FileExist(A_ScriptDir "\..\..\如一.exe")
    return GetFullPathName(A_ScriptDir "\..\..")
  else if FileExist(A_ScriptDir "\..\..\..\如一.exe")
    return GetFullPathName(A_ScriptDir "\..\..\..")
  else if FileExist(A_ScriptDir "\..\..\..\..\如一.exe")
    return GetFullPathName(A_ScriptDir "\..\..\..\..")
  else if FileExist(A_ScriptDir "\..\..\..\..\..\如一.exe")
    return GetFullPathName(A_ScriptDir "\..\..\..\..\..")
}

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetStrCapacity(&buf, cc*2)
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}