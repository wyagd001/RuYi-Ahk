;--------------------------------------
;  最简单的UIA获取文本  By FeiYue
;--------------------------------------

获取任务管理器文本:
WinActivate, ahk_id %Windy_CurWin_id%
sleep 1000
arr := UIA获取文本()
msgbox 4096,, % "Name --> " arr.Name "`n`nText --> " arr.ValueValue
return

UIA获取文本(x="", y="")
{
  static UIA:=ComObjCreate("{ff48dba4-60ef-4201-aa87-54103eef594e}"
    , "{30cbe57d-d9d0-452a-ab13-7ac5ac4825ee}")
  ;-- UIA.ElementFromPoint == 7
  DllCall(NumGet(NumGet(UIA+0)+7*A_PtrSize), "Ptr",UIA, "int64", (x=""||y=""
    ? 0*DllCall("GetCursorPos","Int64*",pt)+pt : x&0xFFFFFFFF|y<<32), "Ptr*",Element)
  arr:=[], VarSetCapacity(var, 8+2*A_PtrSize), NumPut(8, var, "short")
  For k, v in { Name : 30005, ValueValue : 30045 }
  {
    ;-- Element.GetCurrentPropertyValue == 10
    DllCall(NumGet(NumGet(Element+0)+10*A_PtrSize), "Ptr",Element, "int",v, "Ptr",&var)
    arr[k]:=StrGet(NumGet(var, 8, "ptr"), "utf-16")
  }
  ObjRelease(Element)
  return arr
}
