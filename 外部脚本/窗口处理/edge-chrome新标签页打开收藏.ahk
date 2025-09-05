;|3.0|2025.09.01|1733
; 来源网址: https://www.bilibili.com/opus/1048963728195715094
#NoEnv
#SingleInstance Ignore
;#NoTrayIcon			;隐藏托盘图标
SetBatchLines, -1
DetectHiddenWindows, On
#InstallKeybdHook
#InstallMouseHook
SetBatchLines, -1

; 初始化变量
global targetProcess := "msedge.exe"
global targetProcess2 := "chrome.exe"
global lastClickTime := 0

;^!Esc::ExitApp ; 按下 Ctrl+Alt+Esc 退出脚本
~LButton::
    try{
        ; 获取鼠标位置信息
        MouseGetPos, mouseX, mouseY, winID

        ; 检测目标进程
        WinGet, processName, ProcessName, ahk_id %winID%
        if (processName != targetProcess && processName != targetProcess2)
            return

        critical 100
         
         Acc := Acc_ObjectFromPoint(child)
        try {
             value := Acc.accName(child)
        } catch {
            return
        }
         roleName :=Acc_GetRoleText(Acc.accRole(0))

    if (lasty <= 34)
    {
      if (A_ThisHotkey = A_PriorHotkey && A_TimeSincePriorHotkey < 300)
      {
        if(roleName = "文字") or (roleName = "窗格")
        {
          Send, ^w  ; 关闭标签页
          return
        }
      }
    }
        ; 防重复触发（200ms间隔）
        if (A_TickCount - lastClickTime < 200)
            return
        lastClickTime := A_TickCount


        
        ;MsgBox 当前角色：%value%`n父级角色：%roleName%
        ;ToolTip 当前角色：%value%`n父级角色：%roleName%
        ; 获取可访问对象
        try {
            
            desc := Acc_GetInfoUnderCursor().text,
           
        } catch {
            return
        }
         
        
        ; 检查描述有效性
        if (desc == "")
            return
        ;判断是否是网址
        if (CheckURL(desc)&&(roleName != "框线项目" && roleName !="单元格")) {
           ;MsgBox 当前角色：%value%`n父级角色：%roleName%
        } else {
            ;Tip(SubStr(desc, 1, 2000))
            if(roleName != "框线项目" &&  value != "主页" && value != "首页"){
                ;MsgBox 当前角色：%value%`n父级角色：%roleName%
                return
            }
            
                
        }
        
        ;Tip(SubStr(desc, 1, 2000))
        ; 执行组合键操作
        critical off
        Send {Ctrl Down}{Shift Down}
        Click Down Left  ; 保持左键按下状态
        KeyWait, LButton  ; 等待左键释放    ;Click Up Left  ;
        Click Down
        ;可能会点击多次，打开多个页面，用下面的一次发送
        ;Click Up Left
        ;Send {Shift Up}{Ctrl Up}
        
        Send {Shift Up}{Ctrl Up}
        Click Up
        ;下面是关闭收藏的点击弹窗
         Acc := Acc_ObjectFromPoint(child)
        parent := Acc.accParent()
        parentRole := Acc_GetRoleText(parent.accRole(0))
        value := Acc.accDescription(child) 
        
        if (parentRole == "弹出式菜单"){
            ;MsgBox 当前角色：%value%`n父级角色：%parentRole%
            hwnd := DllCall("GetAncestor", "Ptr", Acc_WindowFromObject(parent), "UInt", 2)
            if hwnd {
                WinActivate, ahk_id %hwnd%
                PostMessage, 0x001F, 0, 0, , ahk_id %hwnd%
                Sleep, 200 ; 等待菜单关闭
                if WinExist("ahk_id " hwnd)
                    MsgBox 关闭失败，尝试其他方法
            }
        }
    }catch{}
    
return

;F1::
;obj := Acc_GetInfoUnderCursor() ; , id:=obj.hwnd
;WinGetTitle, BiaoTi, ahk_id %id%
;WinGetClass, class, ahk_id %id%
;tt:=Trim(class="" ? BiaoTi : BiaoTi " ahk_class " class)
;Tip(SubStr(Acc_GetInfoUnderCursor().text, 1, 2000))
;return

; 通过Path获取文本【废】
;F3::
;WinGet, id, ID, Everything ahk_class EVERYTHING
;; MsgBox,% id
;MsgBox % Acc_GetTextFromPath(id,"3.4") ; 返回搜索
;; MsgBox,% Acc_GetAllText(0x1194A)  ;成功,但速度比较慢
;return 
CheckURL(text) {
    ; 综合正则表达式（覆盖大多数情况）
    regex := "\b(localhost|(?:[a-z0-9-]+\.)+[a-z]{2,}|(?:\d{1,3}\.){3}\d{1,3}|\[?[a-f0-9:]+]?)(:\d+)?\b"
    return RegExMatch(text, regex)
}
Tip(s:="", Period:="") {
  SetTimer %A_ThisFunc%, % s="" ? "Off" : "-" (Period="" ? 1500 : Period)
  ToolTip %s%, , , 17
}

;===================== 以下这段附加的是专门用来取path =====================
GetInfoUnderCursor() {
  Acc := Acc_ObjectFromPoint(child)
  if !value := Acc.accValue(child)
    value := Acc.accName(child)
  accPath := GetAccPath(acc, hwnd).path
  return {text: value, path: accPath, hwnd: hwnd}
}

GetAccPath(Acc, byref hwnd="") {
  hwnd := Acc_WindowFromObject(Acc)
  WinObj := Acc_ObjectFromWindow(hwnd)
  WinObjPos := Acc_Location(WinObj).pos
  while Acc_WindowFromObject(Parent:=Acc_Parent(Acc)) = hwnd {
    t2 := GetEnumIndex(Acc) "." t2
    if Acc_Location(Parent).pos = WinObjPos
      return {AccObj:Parent, Path:SubStr(t2,1,-1)}
    Acc := Parent
  }
  while Acc_WindowFromObject(Parent:=Acc_Parent(WinObj)) = hwnd
    t1.="P.", WinObj:=Parent
  return {AccObj:Acc, Path:t1 SubStr(t2,1,-1)}
}

GetEnumIndex(Acc, ChildId=0) {
  if Not ChildId {
    ChildPos := Acc_Location(Acc).pos
    For Each, child in Acc_Children(Acc_Parent(Acc))
      if IsObject(child) and Acc_Location(child).pos=ChildPos
        return A_Index
  } 
  else {
    ChildPos := Acc_Location(Acc,ChildId).pos
    For Each, child in Acc_Children(Acc)
      if Not IsObject(child) and Acc_Location(Acc,child).pos=ChildPos
        return A_Index
  }
}
;===================== 以上这段附加的是专门用来取path =====================

;下面是Acc库 ，勿动
Acc_Get(Cmd, ChildPath="", ChildID:=0, WinTitle="", WinText="", ExcludeTitle="", ExcludeText=""){
  static properties := {Action:"DefaultAction", DoAction:"DoDefaultAction", Keyboard:"KeyboardShortcut"}
  AccObj := IsObject(WinTitle) ? WinTitle
    : Acc_ObjectFromWindow(WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText), 0 )
  If ComObjType(AccObj, "Name") != "IAccessible"
    ErrorLevel := "Could not access an IAccessible Object"
  Else
  {
    StringReplace, ChildPath, ChildPath, _, %A_Space%, All
    AccError:=Acc_Error(), Acc_Error(true)
    Loop Parse, ChildPath, ., %A_Space%
      Try
      {
        If A_LoopField is digit
          Children:=Acc_Children(AccObj), m2:=A_LoopField ; mimic "m2" output In Else-statement
        Else
          RegExMatch(A_LoopField, "(\D*)(\d*)", m)
        , Children:=Acc_ChildrenByRole(AccObj, m1), m2:=(m2?m2:1)
        If Not Children.HasKey(m2)
          Throw
        AccObj := Children[m2]
      }
      Catch
      {
        ErrorLevel:="Cannot access ChildPath Item #" A_Index " -> " A_LoopField, Acc_Error(AccError)
        If Acc_Error()
          Throw Exception("Cannot access ChildPath Item", -1, "Item #" A_Index " -> " A_LoopField)
        Return
      }
    Acc_Error(AccError)
    StringReplace, Cmd, Cmd, %A_Space%, , All
    properties.HasKey(Cmd)? Cmd:=properties[Cmd]:""
    Try
    {
      If (Cmd = "Location")
        AccObj.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0)
      , ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
      , ret_val := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int")
      . " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")
      Else If (Cmd = "Object")
        ret_val := AccObj
      Else If Cmd In Role,State
        ret_val := Acc_%Cmd%(AccObj, ChildID+0)
      Else If Cmd In ChildCount,Selection,Focus
        ret_val := AccObj["acc" Cmd]
      Else
        ret_val := AccObj["acc" Cmd](ChildID+0)
    }
    Catch
    {
      ErrorLevel := """" Cmd """ Cmd Not Implemented"
      If Acc_Error()
        Throw Exception("Cmd Not Implemented", -1, Cmd)
      Return
    }
    Return ret_val, ErrorLevel:=0
  }
  If Acc_Error()
    Throw Exception(ErrorLevel,-1)
}

Acc_GetInfoUnderCursor(){
  Acc := Acc_ObjectFromPoint(child)
  ;Try value := Acc.accValue(child) ; 这句也可以注释掉，不影响取文本
  ;If (!value)
    ;Try value := Acc.accName(child)
    Try value := Acc.accDescription(child) ;改成取描述
  ; accPath := Acc_GetAccPath(acc, hwnd).path
  ; Return {text: value, path: accPath, hwnd: hwnd}
  Return {text: value} ; 简化以上两条达到优化加速
}

Acc_GetAccPath(Acc, Byref hwnd=""){
  hwnd:=Acc_WindowFromObject(Acc)
  While (Acc_WindowFromObject(Parent:=Acc_Parent(Acc))=hwnd)
    t2 := Acc_GetEnumIndex(Acc) "." t2, Acc := Parent
  Return {AccObj:Acc, Path:SubStr(t2,1,-1)}
}

Acc_GetEnumIndex(Acc, ChildId=0){
  If (!ChildId)
  {
    Role:=Name:=""
    Try Role:=Acc.accRole(0)
    Try Name:=Acc.accName(0)
    Count:=Acc.accChildCount, Pos:=Acc_Location(Acc).pos
    For Each, child In Acc_Children(Acc_Parent(Acc))
    {
      If Not IsObject(child)
        Continue
      vRole:=vName:=""
      Try vRole:=child.accRole(0)
      Try vName:=child.accName(0)
      If (Role=vRole && Name=vName && Count=child.accChildCount
        && Pos=Acc_Location(child).pos)
      Return A_Index
    }
  }
  Else
  {
    Role:=Name:=""
    Try Role:=Acc.accRole(ChildId)
    Try Name:=Acc.accName(ChildId)
    Pos:=Acc_Location(Acc,ChildId).pos
    For Each, child In Acc_Children(Acc)
    {
      If IsObject(child)
        Continue
      vRole:=vName:=""
      Try vRole:=Acc.accRole(child)
      Try vName:=Acc.accName(child)
      If (Role=vRole && Name=vName
        && Pos=Acc_Location(Acc,child).pos)
      Return A_Index
    }
  }
}

Acc_Location(Acc, ChildId=0){
  Try Acc.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
  Catch
    Return
  Return {x:NumGet(x,0,"int"), y:NumGet(y,0,"int"), w:NumGet(w,0,"int"), h:NumGet(h,0,"int")
    , pos:"x" NumGet(x,0,"int")" y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")}
}

Acc_Parent(Acc){
  Try parent:=Acc.accParent
  Return parent?Acc_Query(parent):""
}

Acc_Child(Acc, ChildId=0){
  Try child:=Acc.accChild(ChildId)
  Return child?Acc_Query(child):""
}

Acc_Init(){
  Static h
  If (!h && !(h:=DllCall("GetModuleHandle", "Str", "oleacc", "Ptr")))
    h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}

Acc_WindowFromObject(pacc){
  Acc_Init()
  If (DllCall("oleacc\WindowFromAccessibleObject", "Ptr"
    , IsObject(pacc)?ComObjValue(pacc):pacc, "Ptr*", hWnd)=0)
    Return hWnd
}

Acc_ObjectFromEvent(ByRef _idChild_, hWnd, idObject, idChild){
  Acc_Init()
  If (DllCall("oleacc\AccessibleObjectFromEvent", "Ptr", hWnd
    , "UInt", idObject, "UInt", idChild, "Ptr*", pacc, "Ptr"
    , VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0)
    Return ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
}

Acc_ObjectFromPoint(ByRef _idChild_ = "", x = "", y = ""){
  Acc_Init()
  If (DllCall("oleacc\AccessibleObjectFromPoint", "Int64", x==""||y==""
    ? 0*DllCall("GetCursorPos","Int64*",pt)+pt:x&0xFFFFFFFF|y<<32, "Ptr*", pacc
    , "Ptr", VarSetCapacity(varChild,8+2*A_PtrSize,0)*0+&varChild)=0)
    Return ComObjEnwrap(9,pacc,1), _idChild_:=NumGet(varChild,8,"UInt")
}

Acc_ObjectFromWindow(hWnd, idObject := -4){
  Acc_Init()
  If DllCall("oleacc\AccessibleObjectFromWindow"
    , "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", (VarSetCapacity(IID,16)
  +NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64")
  +NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,IID,8,"Int64"))*0
  +&IID, "Ptr*", pacc)=0
  Return ComObjEnwrap(9,pacc,1)
}

Acc_Children(Acc){
  If (ComObjType(Acc,"Name") != "IAccessible")
    ErrorLevel := "Invalid IAccessible Object"
  Else
  {
    Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
    If DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0
      , "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0
    +&varChildren, "Int*",cChildren)=0
    {
      Loop %cChildren%
        i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i)
      , Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child)
      , NumGet(varChildren,i-8)=9?ObjRelease(child):""
      Return Children.MaxIndex()?Children:""
    } Else
    ErrorLevel := "AccessibleChildren DllCall Failed"
  }
  If Acc_Error()
    Throw Exception(ErrorLevel,-1)
}

Acc_ChildrenByRole(Acc, Role){
  If (ComObjType(Acc,"Name")!="IAccessible")
    ErrorLevel := "Invalid IAccessible Object"
  Else
  {
    Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
    If DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc)
      , "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren
    , cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0
    {
      Loop %cChildren%
      {
        i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i)
        If NumGet(varChildren,i-8)=9
          AccChild:=Acc_Query(child), ObjRelease(child)
        , Acc_Role(AccChild)=Role?Children.Insert(AccChild):""
        Else
          Acc_Role(Acc, child)=Role?Children.Insert(child):""
      }
      Return Children.MaxIndex()?Children:"", ErrorLevel:=0
    } Else
    ErrorLevel := "AccessibleChildren DllCall Failed"
  }
  If Acc_Error()
    Throw Exception(ErrorLevel,-1)
}

Acc_Query(Acc){
  Try Return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}

Acc_Role(Acc, ChildId=0){
  Try Return ComObjType(Acc,"Name")="IAccessible"
    ? Acc_GetRoleText(Acc.accRole(ChildId)):"invalid object"
}
  
Acc_State(Acc, ChildId=0){
  Try Return ComObjType(Acc,"Name")="IAccessible"
    ? Acc_GetStateText(Acc.accState(ChildId)):"invalid object"
}
  
Acc_GetRoleText(nRole){
  Acc_Init()
  nSize := DllCall("oleacc\GetRoleText", "Uint", nRole, "Ptr", 0, "Uint", 0)
  VarSetCapacity(sRole, (A_IsUnicode?2:1)*nSize)
  DllCall("oleacc\GetRoleText", "Uint", nRole, "str", sRole, "Uint", nSize+1)
  Return sRole
}

Acc_GetStateText(nState){
  Acc_Init()
  nSize := DllCall("oleacc\GetStateText", "Uint", nState, "Ptr", 0, "Uint", 0)
  VarSetCapacity(sState, (A_IsUnicode?2:1)*nSize)
  DllCall("oleacc\GetStateText", "Uint", nState, "str", sState, "Uint", nSize+1)
  Return sState
}

Acc_Error(p=""){
  static setting:=0
  Return p=""?setting:setting:=p
}

GetPhysicalCursorPos(ByRef x:="", ByRef y:=""){
  If (x==""||y==""){
    CoordMode, Mouse, Screen
    MouseGetPos, x, y, hwnd
  }
  If (A_ScreenDPI!=96){
    WinGetPos, x0, y0, , , ahk_id %hwnd%
    x:=(x-x0)/DPI+x0, y:=(y-y0)/DPI+y0
  }
}

;GetPhysicalCursorPos(ByRef x:="", ByRef y:=""){
;  If (x==""||y==""){
;    CoordMode, Mouse, Screen
;    MouseGetPos, x, y, hwnd
;  }
;  ;If (A_ScreenDPI!=96){
;    WinGetPos, x0, y0, , , ahk_id%hwnd%
;    x:=(x-x0)/A_ScreenDPI+x0, y:=(y-y0)/A_ScreenDPI+y0
;  ;}
;}