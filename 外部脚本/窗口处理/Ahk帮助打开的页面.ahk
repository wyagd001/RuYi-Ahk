;|2.3|2023.07.01|5065
;CandySel := A_Args[1]

Cando_查新版帮助:
wb := WBGet("ahk_class HH Parent")
sleep, 100
tmp_str := wb.document.url
tmp_str := SubStr(tmp_str, instr(tmp_str, "::") + 2)
tmp_str := StrReplace(tmp_str, "/", "\")
tmp_str := RegExReplace(tmp_str, "docs\\(.*)=", "docs\")
tmp_str := RegExReplace(tmp_str, "(.*)\.htm(.*)", "$1.htm")
Clipboard := tmp_str
sleep,100
wb := ""
Return

WBGet(WinTitle="ahk_class IEFrame", Svr#=1) {               ;// based on ComObjQuery docs
   static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
        , IID := "{0002DF05-0000-0000-C000-000000000046}"   ;// IID_IWebBrowserApp
;//     , IID := "{332C4427-26CB-11D0-B483-00C04FD90119}"   ;// IID_IHTMLWindow2
   SendMessage msg, 0, 0, Internet Explorer_Server%Svr#%, %WinTitle%
   if (ErrorLevel != "FAIL") {
      lResult:=ErrorLevel, VarSetCapacity(GUID,16,0)
      if DllCall("ole32\CLSIDFromString", "wstr","{332C4425-26CB-11D0-B483-00C04FD90119}", "ptr",&GUID) >= 0 {
         DllCall("oleacc\ObjectFromLresult", "ptr",lResult, "ptr",&GUID, "ptr",0, "ptr*",pdoc)
         return ComObj(9,ComObjQuery(pdoc,IID,IID),1), ObjRelease(pdoc)
      }
   }
}