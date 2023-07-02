;|2.0|2023.07.01|1036
CandySel := A_Args[1]
DetectHiddenWindows, On
WinGetTitle, h_hwnd, 获取当前窗口信息
Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
if !Windy_CurWin_id
	Windy_CurWin_id := WinExist("A")

; 资源管理器F2重命名时，原生功能按Tab跳转到下一个文件
;
; 1036
filerename:
StringSplit, ary, CandySel, `n, `r
curpath = %ary1%
If ary0=1
{
      FileGetAttrib,attributes,%ary1%
      If ErrorLevel
      {
        MsgBox 文件不存在或没有访问权限
        Return
      }
      IfNotInString, attributes ,D
      {
        Gosub,FilerenameGui
        Return
      }
}
Return
;#IfWinActive

FilerenameGui:
Gui,Default
Gui,Destroy
Gui,Submit 
gui,+AlwaysOnTop   +Owner +LastFound -MinimizeBox
WinSetTitle,,,文件名修改
Gui,Add,Text,xm yp+10,文件名：
Gui,Add,Edit,xp+50  H20 W220 vname_no_ext
Gui,Add,Text,xm yp+30,扩展名：
Gui,Add,Edit,xp+50 yp H20 W220 vExt
Gui,Add,Button,xm yp+30 W60 gFilePrex,上一个(&P)
Gui,Add,Button,xm+70 yp W60 gFileNext,下一个(&N)
Gui,Add,Button,xm+140 yp W100 gApplyOff Default,修改`&&关闭(&S)
Gosub,SingleInit2
Gui,Show,W300 H100
Return

FilePrex:
Gosub,ApplyOff
WinActivate, ahk_id %Windy_CurWin_id%
send,{Up}
Gosub,filerename
Return

FileNext:
Gosub,ApplyOff
WinActivate, ahk_id %Windy_CurWin_id%
send,{Down}
Gosub,filerename
Return

SingleInit2:
SplitPath, curpath,,newpath, ext, name_no_ext

GuiControl,,name_no_ext,%name_no_ext%
GuiControl,,ext,%ext%
Return

ApplyOff:
Gui,Submit
charsToRemove =
(
\\
/
:
*
?
<
>
"
|
)

name_no_ext := RegExReplace(name_no_ext,"[" . charsToRemove . "]")
newpath2 =
if !ext
newpath2 = %newpath%\%name_no_ext%
newpath = %newpath%\%name_no_ext%.%ext%

If ((newpath = curpath) or (newpath2 = curpath))
{
Gui,Destroy
Return
}
IfExist,%newpath%
  MsgBox,4112,错误,该文件名%newpath%-%newpath%已经存在!,3
else
  FileMove,%curpath%,%newpath%,0
Gui,Destroy
Return

GuiClose:
GuiEscape:
Gui,Destroy
exitapp
Return