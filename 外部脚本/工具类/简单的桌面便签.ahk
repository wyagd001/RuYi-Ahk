;|2.7|2024.05.23|1606
;--------------------------------------
; 简单的桌面便签  By FeiYue
;
; 用法：
;   1、新建可以打开新便签，便签中的内容会自动保存到文件
;   2、关闭便签时会保存内容，内容为空会删除保存文件
;--------------------------------------

Note("All")
return

Note(cmd="", id:="", args*)
{
  static init, dir, arr, oldx, oldy, oldt, myrun, timer
  ListLines, % (cmd="Timer") ? "Off" : A_ListLines
  if (!VarSetCapacity(init) && init:="1")
  {
    dir := A_ScriptDir "\..\..\配置文件\外部脚本\ahk_note\"
    , arr:=[], oldx:=oldy:=oldt:=""
    , myrun:=Func(A_ThisFunc).Bind("Run")
    , timer:=Func(A_ThisFunc).Bind("Timer")
  }
  Switch cmd
  {
  Case "Timer":
    clear:=[], Sec:=A_Sec//5
    For id,v in arr
    {
      ; 如果窗口被关闭，先保存一次再销毁窗口
      DetectHiddenWindows, Off
      if !WinExist("ahk_id " id)
      {
        Note("Save", id)
        Gui, %id%: Destroy
        clear[id]:=1
      }
      else
      {
        ; 每隔5秒自动保存一次
        if (oldt!=Sec)
          Note("Save", id)
        WinGetPos,,, w1, h1
        ControlGetPos, x, y, w, h, Edit1
        w2:=w1-x-x, h2:=h1-y-x
        if (w!=w2 || h!=h2)
          ControlMove, Edit1,,, w2, h2
      }
    }
    oldt:=Sec
    ; 清理全局数组，如果全部清空就停止定时器
    For id,v in clear
      arr.Delete(id)
    if arr.Count()<1
		{
      SetTimer,, Off
			exitapp
		}
		return
  Case "Save":
    DetectHiddenWindows, On
    if !WinExist("ahk_id " id)
      return
    WinGetTitle, f
    if !InStr(f, ".txt")
      return
    GuiControlGet, s, %id%:, Edit1
    ; 编辑框内容为空且窗口关闭，就删除磁盘文件
    DetectHiddenWindows, Off
    if (s="") && !WinExist("ahk_id " id)
    {
      FileDelete, % dir . f
      arr[id][1]:=s
      return
    }
    ; 编辑框内容改变才写入磁盘文件
    if (s!=arr[id][1])
    {
      arr[id][1]:=s
      if !FileExist(dir)
        FileCreateDir, % dir
      file:=FileOpen(dir . f,"w"), file.Write(s), file.Close()
    }
    return
  Case "Run":
    k:=Trim(A_GuiControl)
    if (k="新建")
      Note()
    else if (k="清空")
    {
      GuiControl, Focus, Edit1
      ControlSend, Edit1, {Ctrl Down}a{Ctrl Up}{Del}
    }
    else if (k="撤销")
    {
      GuiControl, Focus, Edit1
      ControlSend, Edit1, {Ctrl Down}z{Ctrl Up}
    }
    else if (k="删除")
    {
      GuiControl,, Edit1
      Gui, Hide
    }
    else if (k="退出所有")
    {
      exitapp
    }
    return
  Case "All":
    i:=0
    Loop Files, % dir "*.txt"
      Note(RegExReplace(A_LoopFilePath, ".*\\")), i++
    if (i=0)
      Note()
    return
  }

  ; 确定自动保存的文件名
  f:=cmd
  if !InStr(f, ".txt")
  {
    Loop
      f:=Format("{:03d}.txt", A_Index)
    Until !FileExist(dir . f)
    if !FileExist(dir)
      FileCreateDir, % dir
    FileAppend,, % dir . f
  }
  DetectHiddenWindows, Off
  if WinExist(f . " ahk_class AutoHotkeyGUI", "清空")
    return

  ; 备份默认GUI用于恢复
  Gui, +Hwndold_id

  ; 创建新Gui
  Gui, New, +AlwaysOnTop +LastFound +Hwndid +Resize +Owner -DPIScale
  Gui, Margin, 0, 0
  Gui, Font, s12
  For k,v in StrSplit("新建|清空|撤销|删除|退出所有", "|")
  {
    j:=(k=1) ? "":"x+0"
    Gui, Add, Button, %j% h30 Hwndctrl_id, %v%
    GuiControl, +g, %ctrl_id%, %myrun%
  }
  Gui, Add, Edit, xm w300 h150 -Wrap HScroll
  FileRead, s, % dir . f
  GuiControl,, Edit1, % s
  Gui, Show, Hide, % f
  WinGetPos, x, y, w, h
  if (oldx="" || oldy="")
    oldx:=x, oldy:=y
  else
  {
    x:=Round(oldx)+30, y:=Round(oldy)+30
    , (x>A_ScreenWidth-w || y>A_ScreenHeight-h)
    && (x:=0, y:=0), oldx:=x, oldy:=y
  }
  Gui, Show, % "x" x " y" y
  GuiControl, Focus, Edit1

  ; 在全局数组中保留各个窗口的编辑框内容
  GuiControlGet, s,, Edit1
  arr[id]:=[s]

  ; 利用绑定函数来启动定时器
  SetTimer, % timer, 100

  ; 恢复默认GUI
  Gui, %old_id%: Default
}
