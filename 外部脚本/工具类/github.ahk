;|2.8|2024.09.18|1676
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
CandySel := A_Args[1]

Gui Font, s9, Segoe UI
Gui Add, Text, x15 y15 w75 h31 +0x200, 网址
Gui Add, ComboBox, x125 y20 w400 vourl ggrurl, https://github.com/wyagd001/RuYi-Ahk||https://github.com/FuPeiJiang/VD.ahk|https://github.com/iseahound/ImagePut
;Gui Add, Radio, x126 y80 w120 h23 vcrurl, 原始文件
;Gui Add, Radio, x254 y80 w120 h23 vczip, 库打包zip
Gui Add, Text, x15 y90 w75 h31 +0x200, 原始URL
Gui Add, Edit, x125 y90 w399 h49 vrurl ggdurl
;Gui Add, DropDownList, x128 y174 w120, 随机代理|代理1|代理2|代理3|代理4|代理5|代理6|
Gui Add, Text, x15 y170 w75 h31 +0x200, 下载地址
Gui Add, Edit, x125 y170 w399 h49 vdurl
Gui Add, Button, x129 y240 w80 h23 gdownload, 下载
Gui Add, Button, x237 y240 w80 h23 gGuiClose, 取消

Gui Show, w550 h290, Github 文件下载
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
proxy := ["https://mirror.ghproxy.com/", "https://slink.ltd/", "https://moeyy.cn/gh-proxy/", "https://ghproxy.cc/", "https://cf.ghproxy.cc/", "https://gh.api.99988866.xyz/", "https://gh.ddlc.top/", "https://github.moeyy.xyz/", "https://ghps.cc/", "https://gitdl.cn/", "https://ghproxy.net/", "https://ghp.ci/", "https://github.tmby.shop/", "https://gh-proxy.com/", "https://gh.con.sh/", "https://ghproxy.cn/"]
Random, Tmp_Var, 1, 16

GuiControl,, durl, % proxy[Tmp_Var] rurl
return

download:
gui Submit, nohide
SplitPath, rurl, OutFileName
;msgbox % OutFileName
UrlDownloadToFile, % durl, %A_desktop%\%OutFileName%
return
