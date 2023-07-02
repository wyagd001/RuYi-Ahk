;|2.0|2023.07.01|1326
Windy_CurWin_id := A_Args[1]
if !Windy_CurWin_id
{
	DetectHiddenWindows, On
	WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
}
WinGetTitle, Windy_CurWin_Title, Ahk_ID %Windy_CurWin_id% 

DetectHiddenWindows, Off

for k, title in GetTaskBarButton()
{
	Tmp_T := RegExReplace(title, "\s-\s\d .*$")
	if (Tmp_T != Windy_CurWin_Title)
		WinClose, % Tmp_T
}
exitapp

GetTaskBarButton(running := 1, TBBindex := 1)
{
	ControlGet, hwnd, hwnd,, MSTaskListWClass%TBBindex%, ahk_class Shell_TrayWnd
	accTaskBar := Acc_ObjectFromWindow(hwnd)
	TBT := []
	For Each, Child In Acc_Children(accTaskBar)
	{
		Tmp_T := accTaskBar.accName(child)
		if !Tmp_T
			continue
		If running && ((tmp:=Acc_Location(accTaskBar, child).w) > 50)
		{
			; 7-161 - 有弹出菜单 - 哔哩哔哩 (゜-゜)つロ 干杯~-bilibili - 360安全浏览器 14.1 - 1 个运行窗口
			;msgbox % child " - " tmp " - " Acc_State(accTaskBar, child) " - " accTaskBar.accName(child)
			TBT.Push(Tmp_T)
		}
		If !running
			TBT.Push(Tmp_T)
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

Acc_ObjectFromWindow(hWnd, idObject = -4)
{
	Acc_Init()
	If	DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return	ComObjEnwrap(9,pacc,1)
}