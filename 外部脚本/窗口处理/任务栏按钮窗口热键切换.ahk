﻿;|2.4|2023.09.28|1446,1447
#SingleInstance Force
CandySel := A_Args[1]
SysGet, Output_Monitor, MonitorWorkArea
Monitor_w := Output_MonitorRight - Output_MonitorLeft
Monitor_y := Output_MonitorBottom - Output_MonitorTop - 20
return

$LWin::
TBT_Obj := GetTaskBarButton(CandySel)
if (LastCount = TBT_Obj.Count())
{
	sleep 300
	return
}
gui,1: default
gui, +DPIScale
gui, Destroy
gui, +owner
Gui, Margin, 0, 0
gui, Font, s20 CRed, Consolas
Gui, Color, FFFFFF
Gui, +E0x20  ; 使窗口透明,  使鼠标穿透
gui, -Border

loop % TBT_Obj.Count()
{
	;msgbox % TBT_Obj[A_Index]["x"] "-" TBT_Obj[A_Index]["y"]
	gui, add, text, % "x" TBT_Obj[A_Index]["x"] " y2", %A_index%
}

Gui, +LastFound  -Caption +ToolWindow
gui, show, % "x0 h50 y" Monitor_y " w" Monitor_w , 透明窗口
WinTrans := 85
WinSet, Transparent, %WinTrans%
WinSet, AlwaysOnTop, On, 透明窗口
LastCount := TBT_Obj.Count()
return

LWin Up::
gui, Destroy
LastCount := 0
if !hasactive
{
	send {RWin}
}
else
	hasactive := 0
Return

#IfWinExist 透明窗口 ahk_class AutoHotkeyGUI  
1::activeWin(1)
2::activeWin(2)
3::activeWin(3)
4::activeWin(4)
5::activeWin(5)
6::activeWin(6)
7::activeWin(7)
8::activeWin(8)
9::activeWin(9)
#If

activeWin(num)
{
	global TBT_Obj, hasactive
	Tmp_T := RegExReplace(TBT_Obj[num].title, "\s-\s\d .*$")
	if WinExist(Tmp_T)
		WinActivate, % Tmp_T
	else
		Send #%num%
	hasactive := 1
	;ToolTip % TBT_Obj[num].title "-" num
	Return
}

; 任务栏设置中不能选择  始终合并按钮
GetTaskBarButton(running := 1, TBBindex := 1)
{
	ControlGet, hwnd, hwnd,, MSTaskListWClass%TBBindex%, ahk_class Shell_TrayWnd
	accTaskBar := Acc_ObjectFromWindow(hwnd)
	TBT := {}
	T_index := 0
	For Each, Child In Acc_Children(accTaskBar)
	{
		Tmp_T := accTaskBar.accName(child)
		if !Tmp_T
			continue
		;If running && ((tmp:=Acc_Location(accTaskBar, child).w) > 50)
		If running && InStr(Tmp_T, "个运行窗口")   ; 会得到一个多余的项目  360安全浏览器 - 1 个运行窗口
		{
			; 7 - 有弹出菜单 - 哔哩哔哩 (゜-゜)つロ 干杯~-bilibili - 360安全浏览器 14.1 - 1 个运行窗口
			;msgbox % child " - " Acc_State(accTaskBar, child) " - " accTaskBar.accName(child)
			if !InStr(Acc_State2(accTaskBar, child), "不可见")
			{
				T_index ++
				TBT[T_index] := {}
				TBT[T_index]["x"] := Acc_Location(accTaskBar, child).x
				TBT[T_index]["y"] := Acc_Location(accTaskBar, child).y
				TBT[T_index]["title"] := Tmp_T
			}
		}
		If !running  && (tmp:=Acc_Location(accTaskBar, child).w) > 20
		{
			T_index ++
			TBT[T_index] := {}
			TBT[T_index]["x"] := Acc_Location(accTaskBar, child).x
			TBT[T_index]["y"] := Acc_Location(accTaskBar, child).y
			TBT[T_index]["title"] := Tmp_T
		}
	}
	return TBT
}

Acc_Init() {
	Static	h
	If Not	h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}

Acc_Query(Acc) { ; thanks Lexikos - www.autohotkey.com/forum/viewtopic.php?t=81731&p=509530#509530
	try return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}

Acc_Error(p="") {
	static setting:=0
	return p=""?setting:setting:=p
}

Acc_GetStateText(nState)
{
	nSize := DllCall("oleacc\GetStateText", "Uint", nState, "Ptr", 0, "Uint", 0)
	VarSetCapacity(sState, (A_IsUnicode?2:1)*nSize)
	DllCall("oleacc\GetStateText", "Uint", nState, "str", sState, "Uint", nSize+1)
	Return	sState
}

Acc_GetStateTextEx(nState) {
	static states := [ 0x0,0x1,0x10,0x100,0x10000,0x100000,0x1000000,0x2,0x20,0x200,0x2000
	                 , 0x20000,0x200000,0x2000000,0x20000000,0x4,0x40,0x400,0x4000,0x40000
	                 , 0x400000,0x40000000,0x8,0x80,0x800,0x8000,0x80000,0x800000 ]
	for i, n in states
	{
		if (nState & n)
			out .= Acc_GetStateText(n) ","
	}
	return RTrim(out, ",")
}

Acc_Children(Acc) {
	if ComObjType(Acc,"Name") != "IAccessible"
		ErrorLevel := "Invalid IAccessible Object"
	else {
		Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
		if DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
			Loop %cChildren%
				i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
			return Children.MaxIndex()?Children:
		} else
			ErrorLevel := "AccessibleChildren DllCall Failed"
	}
	if Acc_Error()
		throw Exception(ErrorLevel,-1)
}

Acc_Location(Acc, ChildId=0, byref Position="") { ; adapted from Sean's code
	try Acc.accLocation(ComObj(0x4003,&x:=0), ComObj(0x4003,&y:=0), ComObj(0x4003,&w:=0), ComObj(0x4003,&h:=0), ChildId)
	catch
		return
	Position := "x" NumGet(x,0,"int") " y" NumGet(y,0,"int") " w" NumGet(w,0,"int") " h" NumGet(h,0,"int")
	return	{x:NumGet(x,0,"int"), y:NumGet(y,0,"int"), w:NumGet(w,0,"int"), h:NumGet(h,0,"int")}
}

Acc_State(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetStateText(Acc.accState(ChildId)):"invalid object"
}

Acc_State2(Acc, ChildId=0) {
	try return ComObjType(Acc,"Name")="IAccessible"?Acc_GetStateTextEx(Acc.accState(ChildId)):"invalid object"
}

Acc_ObjectFromWindow(hWnd, idObject = -4)
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return	ComObjEnwrap(9,pacc,1)
}