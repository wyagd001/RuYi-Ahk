;|3.0|2025.07.25|1676
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
CandySel := A_Args[1]

A_RuYiDir := RuYi_GetRuYiDir()
RY_AsettingFile := A_RuYiDir "\配置文件\如一.ini"
RY_CsettingFile := A_RuYiDir "\配置文件\自定义\其他程序.ini"
IniRead, githubproxy, %RY_CsettingFile%, 其他程序, githubproxy
if githubproxy && InStr(githubproxy, "http")
  GithubProxy_Arr := StrSplit(githubproxy, ",", " ")
else
{
  IniRead, githubproxy, %RY_AsettingFile%, 其他程序, githubproxy
  if githubproxy && InStr(githubproxy, "http")
    GithubProxy_Arr := StrSplit(githubproxy, ",", " ")
}

Gui Font, s9, Segoe UI
Gui Add, Text, x15 y15 w75 h31 +0x200, 网址:
Gui Add, ComboBox, x100 y20 w420 vourl ggrurl, https://github.com/wyagd001/RuYi-Ahk||https://github.com/FuPeiJiang/VD.ahk|https://github.com/iseahound/ImagePut
;Gui Add, Radio, x126 y80 w120 h23 vcrurl, 原始文件
;Gui Add, Radio, x254 y80 w120 h23 vczip, 库打包zip
Gui Add, Text, x15 y60 w75 h31 +0x200, 原始URL:
Gui Add, Edit, x100 y60 w420 h49 vrurl ggdurl
;Gui Add, DropDownList, x128 y174 w120, 随机代理|代理1|代理2|代理3|代理4|代理5|代理6|
Gui Add, Text, x15 y120 w75 h31 +0x200, 下载URL:
Gui Add, Edit, x100 y120 w420 h49 vdurl
Gui Add, Text, x15 y180 w75 h31 +0x200, 下载地址:
Gui Add, ComboBox, x100 y180 w420 h90 r6 vdpath hwndhcbx, %A_desktop%||
PostMessage, 0x153, -1, 49,, AHK_ID %hcbx% ; CB_SETITEMHEIGHT = 0x153
;PostMessage, 0x153, -1, 50,, ahk_id %hcbx%  ; Set height of selection field.
;PostMessage, 0x153,  0, 50,, ahk_id %hcbx%  ; Set height of list items.
Gui Add, Button, x300 y240 w80 h30 gdownload, 下载
Gui Add, Button, x400 y240 w80 h30 gGuiClose, 取消

Gui Show, w550 h280, Github 文件下载
if CandySel
{
  GuiControl,, ourl, % CandySel
  GuiControl, ChooseString, ourl, % CandySel
}

gosub grurl
Return

GuiEscape:
GuiClose:
    ExitApp

grurl:
gui Submit, nohide
if InStr(ourl, "/blob/")
{
  rurl := StrReplace(ourl, "/blob/", "/")
  rurl := StrReplace(rurl, "/github.com/", "/raw.githubusercontent.com/")
}
else if InStr(ourl, "/raw.githubusercontent.com/")
  rurl := ourl
else if InStr(ourl, "/codeload.github.com/")
{
  rurl := StrReplace(ourl, "/codeload.github.com/", "/github.com/")
  rurl := StrReplace(rurl, "/zip/", "/archive/")
  rurl := rurl ".zip"
}
else if InStr(ourl, "/releases/")
  rurl := ourl
else if InStr(ourl, "/archive/")
  rurl := ourl
else
{
  if InStr(ourl, "/FuPeiJiang/VD.ahk")
    rurl := ourl "/archive/refs/heads/class_VD.zip"
  else if InStr(ourl, "/iseahound/ImagePut")
    rurl := ourl "/archive/refs/heads/master.zip"
  else
    rurl := ourl "/archive/refs/heads/main.zip"
}
rurl := StrReplace(rurl, "//", "/")
rurl := StrReplace(rurl, "https:/", "https://")
GuiControl,, rurl, % rurl
gosub gdurl
;msgbox % crurl
return

gdurl:
gui Submit, nohide
Random, Tmp_Var, 1, 9
GuiControl,, durl, % GithubProxy_Arr[Tmp_Var] rurl
return

download:
gui Submit, nohide
SplitPath, rurl, OutFileName
;msgbox % OutFileName
if fileexist(dpath) && CF_IsFolder(dpath)
  UrlDownloadToFile, % durl, %dpath%\%OutFileName%
else
{
  GuiControl, Text, dpath, % A_desktop
  UrlDownloadToFile, % durl, %A_desktop%\%OutFileName%
}
tooltip, 文件下载完毕!
sleep 3000
Tooltip
return