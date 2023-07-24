;|2.1|2023.07.24|1373
#SingleInstance, Force
#NoEnv
;~ #Persistent
;~ #NoTrayIcon

    ;~ 曙飙曳影 v0.1
        ;~ --  自定义鼠标跟随文字或图形

    ;~ v0.1
        ;~ - 初步实现基本功能

    ;~ 不足
        ;~ * 延时太长时如鼠标位于曳影上则操作失效、并失去浮动焦点
        ;~ * 性能可能较低
        ;~ * 没有设置界面，设置项少
        ;~ * 没有 α 通道文字的锯齿阴影会造成画面破坏

CoordMode, Mouse, Screen
SetWinDelay, -1
SetBatchLines, -1

global GUIFlag :={}, thisWin := 1, UsrTxt, UsrPic, TransC:="F0F0F0"
    , thisFileName := RegExReplace(A_ScriptName, "\.([^\.]*)")
    , DFIcon := thisFileName ".ico"
    , exeName := "曙飙曳影"
    , exeVer := "v0.1"
    , exeVerSub := "beta"

;~ ************************** 基本设置 **************************
    , TGUI := 15            ;   拖曳数量             (默认8)
    , LagTime := 15         ;   拖曳时留影时间间隔   (ms)
    , TransP := 150         ;   曳影透明度           (0~255)
    , ClearFrame := 4       ;   曳影消除延迟帧数     (默认 4 帧)
    , FrameX := 5           ;   曳影帧左上相对鼠标热点偏移量，同时也是图像左上角位置
    , FrameY := 5           ;       只需设置文字左上角与其相对位置即可

;~ ************************** 曳影设置 **************************
; ♡♥♣◐◑☆★○●♫♬❉*✿❃❀❤⋚⋛†❥
    , DFTxt := "❤"       ;   默认曳影文字
    , UseTxt := 1           ;   是否使用文字
    , FntX := 6             ;   文字偏移
    , FntY := 10
    , FntType := "微软雅黑" ;   设置曳影字体
    , FntSize := 8
    , FntEx := "Bold"
    , FntQuality := 
    , RandomColor := 1
    , FntColor := "Red"     ;   字体设置，标准 Windows 字形设置
    , DFPic := DFIcon
                            ;   曳影图像文件，Windows 支持为准，默认为同名 .ico
    , UsePic := 0           ;   是否使用图像
    , PicW := 32            ;   图像尺寸
    , PicH := -1            ;   其中一个设置 -1 则以另一个为比例缩放
;~ ************************** 设置结束 **************************

if FileExist(DFIcon)
    Menu, Tray, Icon , % DFIcon
else if A_IsCompiled
    Menu, Tray, Icon , % thisFileName ".exe"

Menu, Tray, Tip, % exeName " - " exeVer (exeVerSub?"(" exeVerSub ")":)

biuldFollow()

SetTimer, FollowMonitor, % LagTime

return

biuldFollow()
{
    loop % TGUI
    {
        if RandomColor
        {
          Random, R, 0, 255
          Random, G, 0, 255
          Random, B, 0, 255
          FntColor := Format("{1:x}{2:x}{3:x}", R, G, B)
        }
        gui, % "WinName" A_Index ":New", HwndFollowID%A_Index% AlwaysOnTop ToolWindow -Caption Disabled
        GUIFlag[A_Index] := {ID:FollowID%A_Index%, time:A_TickCount, Pos:{}}
        gui, font, % "s" FntSize " " FntEx " q" FntQuality " c" FntColor, % FntType
        if (FileExist(DFPic) && UsePic)
            Gui, WinName%A_Index%:Add, Picture, % "x0 y0 w" PicW " h" PicH " vUsrPic gFrameClick", % DFPic
        if UseTxt
            Gui, WinName%A_Index%:Add, Text, % "x" FntX " y" FntY " vUsrTxt gFrameClick", % DFTxt
        Gui, WinName%A_Index%:Color, % TransC
        WinSet, Style, -0xC00000, % "ahk_id " GUIFlag[A_Index].ID
        Gui, WinName%A_Index%:Show, % "NA AutoSize X" A_ScreenWidth " Y" A_ScreenHeight
        WinSet, TransColor, % TransC " " TransP, % "ahk_id " GUIFlag[A_Index].ID
        Gui, WinName%A_Index%:Hide
    }
}
return

FollowMonitor:
    Wname:="WinName" thisWin
        , Whwnd:=GUIFlag[thisWin].ID
    if (A_TickCount - GUIFlag[FollowWinNext(thisWin-2)].time<LagTime)
        return
    GUIFlag[thisWin].time:=A_TickCount
        , thisWin:=FollowWinNext(thisWin)
    FollowDrawGui(thisWin)
return

FollowDrawGui(WNow:=1)
{
    static noMove := 0
    static X:=1, Y:=2
    WNxt:=FollowWinNext(WNow)
        , WPrv:=FollowWinNext(WNow-2)
    Gui, WinName%WNxt%:Hide
    MouseGetPos, OutputVarX, OutputVarY
    GUIFlag[WNow].Pos := [OutputVarX, OutputVarY]
    if (GUIFlag[WNow].Pos[X]=GUIFlag[FollowWinNext(WNow-2)].Pos[X] 
        && GUIFlag[WNow].Pos[Y]=GUIFlag[FollowWinNext(WNow-2)].Pos[Y])
    {
        if (++noMove<ClearFrame)
            return
        loop % TGUI - ClearFrame
        {
            Gui, % "WinName" FollowWinNext(thisWin+A_Index) ":Hide"
        }
        noMove := 0
        return
    }
    Gui, WinName%WNow%:Hide
    Gui, WinName%WNow%:Show, % "NA X" OutputVarX + FrameX " Y" OutputVarY + FrameY
}

FollowWinNext(WNum)
{
    return FNext(WNum, TGUI)
}

FNext(WNum:=1, Max := 1, Min:=1, Rev:=0, Step:=1)
{
    return  !WNum
        ? Min
        : (WNum>=Max)
            ? FNext(WNum - Max, Max, Min, Rev, Step)
            : (WNum < Min)
                ? FNext(WNum + Max, Max, Min, Rev, Step)
                : WNum + Step
}

FrameClick(arg*)
{
    CtrlHwnd := arg[1]
        , GuiEvent := arg[2]
        , EventInfo := arg[3]
        , ErrorLevel := arg[4]
}
