;|2.7|2024.07.14|1611
; A_Variables - AutoHotkey Built-in Variables v1.1.2
#SingleInstance Force
#NoEnv
#NoTrayIcon
SetWorkingDir %A_ScriptDir%

Global A := Array()
     , G := Array()
     , hLV
     , NT6 := DllCall("GetVersion") & 0xFF > 5
     , Indent := (NT6) ? "    " : ""

userObj := {}
OSObj := {}
YingJianObj := {}
YingJianObj["主板"] := {}
YingJianObj["CPU"] := {}
YingJianObj["BIOS"] := {}

B_index := 0
objWMIService := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\cimv2") 
colSettings := objWMIService.ExecQuery("select * from Win32_OperatingSystem")._NewEnum 
UserAccountProperties := objWMIService.ExecQuery("Select * From Win32_UserAccount")._NewEnum
BaseBoardProperties := objWMIService.ExecQuery("Select * From Win32_BaseBoard")._NewEnum
PhysicalMemoryProperties := objWMIService.ExecQuery("Select * From Win32_PhysicalMemory")._NewEnum
CPUProperties := objWMIService.ExecQuery("Select * From Win32_Processor")._NewEnum
DesktopMonitorProperties := objWMIService.ExecQuery("Select * From Win32_DesktopMonitor")._NewEnum
DiskDriveProperties := objWMIService.ExecQuery("Select * From Win32_DiskDrive")._NewEnum
DiskPartitionProperties := objWMIService.ExecQuery("Select * From Win32_LogicalDiskToPartition")._NewEnum
BIOSProperties := objWMIService.ExecQuery("Select * From Win32_BIOS")._NewEnum
DisplayProperties := objWMIService.ExecQuery("Select * From Win32_DisplayConfiguration")._NewEnum
VideoControlProperties := objWMIService.ExecQuery("Select * From win32_VideoController")._NewEnum
SoundDeviceProperties := objWMIService.ExecQuery("Select * From Win32_SoundDevice")._NewEnum
NetworkAdapterProperties := objWMIService.ExecQuery("Select * From Win32_NetworkAdapter")._NewEnum
NetworkAdapterConfigProperties := objWMIService.ExecQuery("Select * From Win32_NetworkAdapterConfiguration WHERE IPEnabled = True")._NewEnum
PrinterProperties := objWMIService.ExecQuery("Select * From Win32_Printer")._NewEnum

While colSettings[strOSItem] 
{
	OSobj["版本"] := strOSItem.Version
	OSobj["内存"] := Floor(strOSItem.TotalVisibleMemorySize / 1024 / 1000) "Gb"
	OSobj["安装时间"] := substr(strOSItem.InstallDate, 1, 14)
	OSobj["Windows序列号"] := strOSItem.SerialNumber
	OSobj["开机时间"] := substr(strOSItem.LastBootUpTime, 1, 14)
	OSobj["BootDevice"] := strOSItem.BootDevice
	OSobj["时区"] := Ceil(strOSItem.CurrentTimeZone / 60)
}

While UserAccountProperties[objProperty]
{
	if (objProperty["Name"] = "DefaultAccount") or (objProperty["Name"] = "Guest") or (objProperty["Name"] = "WDAGUtilityAccount")
		continue
	B_index ++
	userobj[B_index] := {}
	userobj[B_index]["Name"] := objProperty["Name"]
	userobj[B_index]["SID"] := objProperty["SID"]
}

While BaseBoardProperties[objProperty]
{
	YingJianObj["主板"]["制造商"] := objProperty["Manufacturer"]
	YingJianObj["主板"]["型号"] := objProperty["Product"]
	YingJianObj["主板"]["版本"] := objProperty["Version"]
}
B_Index := 0
While PhysicalMemoryProperties[objProperty]
{
	B_index ++
	YingJianObj["内存" B_Index] := {}
	YingJianObj["内存" B_Index]["大小"] := Floor(objProperty["Capacity"] / 1024 / 1000) "Gb"
	YingJianObj["内存" B_Index]["制造商"] := objProperty["Manufacturer"]
	YingJianObj["内存" B_Index]["速度"] :=  objProperty["Speed"] "Mhz"
}

While CPUProperties[objProperty]
{
	YingJianObj["CPU"]["型号"] := objProperty["Name"]
	YingJianObj["CPU"]["核"] := objProperty["NumberOfCores"]
}
B_Index := 0
While DesktopMonitorProperties[objProperty]
{
	B_index ++
	YingJianObj["显示器" B_Index] := {}
	YingJianObj["显示器" B_Index]["型号"] := substr(objProperty["PNPDeviceID"], 9, instr(objProperty["PNPDeviceID"], "\", , 10)-9)
	YingJianObj["显示器" B_Index]["宽"] := objProperty["ScreenWidth"]
	YingJianObj["显示器" B_Index]["高"] := objProperty["ScreenHeight"]
}
B_Index := 0
DskObj := MSFT_PhysicalDisk()
While DiskDriveProperties[objProperty]
{
	B_index ++
	YingJianObj["硬盘" B_Index] := {}
	YingJianObj["硬盘" B_Index]["型号"] := objProperty["Model"]
	for k, v in DskObj
	{
		if instr(objProperty["Model"], v.FriendlyName)
			YingJianObj["硬盘" B_Index]["类型"] := v.MediaType
	}
	YingJianObj["硬盘" B_Index]["大小"] := objProperty["Size"] / 1024 / 1024 / 1024
	YingJianObj["硬盘" B_Index]["序列号"] := objProperty["SerialNumber"]
	YingJianObj["硬盘" B_Index]["分区数"] := objProperty["Partitions"]
	YingJianObj["硬盘" B_Index]["DeviceID"] := objProperty["DeviceID"]
}
B_Index := 0
While DiskPartitionProperties[objProperty]
{
	if instr(objProperty["Antecedent"], "Disk #0")
		YingJianObj["硬盘1"]["分区"] .= substr(objProperty["Dependent"], instr(objProperty["Dependent"], "=")+2, 2) " "
	else if instr(objProperty["Antecedent"], "Disk #1")
		YingJianObj["硬盘2"]["分区"] .= substr(objProperty["Dependent"], instr(objProperty["Dependent"], "=")+2, 2) " "
	else if instr(objProperty["Antecedent"], "Disk #2")
		YingJianObj["硬盘3"]["分区"] .= substr(objProperty["Dependent"], instr(objProperty["Dependent"], "=")+2, 2) " "
	else if instr(objProperty["Antecedent"], "Disk #3")
		YingJianObj["硬盘4"]["分区"] .= substr(objProperty["Dependent"], instr(objProperty["Dependent"], "=")+2, 2) " "
}

B_Index := 0
While NetworkAdapterProperties[objProperty]
{
	if !objProperty["NetEnabled"]
		continue
	B_index ++
	YingJianObj["网络适配器" B_Index] := {}
	YingJianObj["网络适配器" B_Index]["MAC"] := objProperty["MACAddress"]
	YingJianObj["网络适配器" B_Index]["制造商"] := objProperty["Manufacturer"]
	YingJianObj["网络适配器" B_Index]["名称"] := objProperty["Name"]
	YingJianObj["网络适配器" B_Index]["显示名称"] := objProperty["NetConnectionID"]
	YingJianObj["网络适配器" B_Index]["Speed"] := Ceil(objProperty["Speed"] / 1000 / 1000)
}
While NetworkAdapterConfigProperties[objProperty]
{
	;msgbox % objProperty.IPAddress[0]
	if !instr(objProperty.IPAddress[0], A_IPAddress1)
		continue
	YingJianObj["网络适配器配置"] := {}
	YingJianObj["网络适配器配置"]["描述"] := objProperty["Description"]
	;YingJianObj["网络适配器配置"]["Ip"] := objProperty["IPAddress"]
	YingJianObj["网络适配器配置"]["子网掩码"] := objProperty["IPSubnet"]
	YingJianObj["网络适配器配置"]["默认网关"] := objProperty.DefaultIPGateway[0]
	YingJianObj["网络适配器配置"]["DNS"] := objProperty.DNSServerSearchOrder[0]
	YingJianObj["网络适配器配置"]["MAC"] := objProperty["MACAddress"]
}
B_Index := 0
While SoundDeviceProperties[objProperty]
{
	B_index ++
	YingJianObj["声卡" B_Index] := {}
	YingJianObj["声卡" B_Index]["名称"] := objProperty["Caption"]
}
While BIOSProperties[objProperty]
{
	YingJianObj["BIOS"]["制造商"] := objProperty["Manufacturer"]
	YingJianObj["BIOS"]["版本号"] := objProperty["SMBIOSBIOSVersion"]
}
B_Index := 0
While DisplayProperties[objProperty]
{
	B_index ++
	YingJianObj["显卡" B_Index] := {}
	YingJianObj["显卡" B_Index]["名称"] := objProperty["DeviceName"]
	YingJianObj["显卡" B_Index]["版本号"] := objProperty["DriverVersion"]
}
B_Index := 0
While VideoControlProperties[objProperty]
{
  B_index ++
	YingJianObj["GPU" B_Index] := {}
	YingJianObj["GPU" B_Index]["名称"] := objProperty["Caption"]
	YingJianObj["GPU" B_Index]["宽"] := objProperty["CurrentHorizontalResolution"]
	YingJianObj["GPU" B_Index]["高"] := objProperty["CurrentVerticalResolution"]
}
B_Index := 0
While PrinterProperties[objProperty]
{
	B_index ++
	YingJianObj["打印机" B_Index] := {}
	YingJianObj["打印机" B_Index]["名称"] := objProperty["DriverName"]
	YingJianObj["打印机" B_Index]["默认打印机"] := objProperty["Default"]
	YingJianObj["打印机" B_Index]["端口"] := objProperty["PortName"]
}

; AutoHotkey Information
G.Push([10, "AutoHotkey信息"])
A.Push(["A_AhkPath", A_AhkPath, 10])
A.Push(["A_AhkVersion", A_AhkVersion, 10])
A.Push(["A_IsUnicode", A_IsUnicode, 10])

; Operating System and User Information
G.Push([20, "操作系统"])
A.Push(["A_OSType", A_OSType, 20, "systeminfo"])
A.Push(["A_OSVersion(OS 版本)", A_OSVersion, 20, "systeminfo"])
A.Push(["A_Is64bitOS", A_Is64bitOS, 20, "systeminfo"])
A.Push(["A_PtrSize", A_PtrSize, 20, "systeminfo"])
A.Push(["A_Language", A_Language, 20, "systeminfo"])
A.Push(["A_ComputerName(主机名)", A_ComputerName, 20, "systeminfo"])
for k, v in OSobj
{
	A.Push([k, v, 20, "msinfo32"])
}

G.Push([30, "用户信息"])
A.Push(["A_UserName(当前用户名)", A_UserName, 30])
A.Push(["A_IsAdmin(管理员权限)", A_IsAdmin, 30])
for k, v in userobj
{
	A.Push([k "_用户名", v["Name"], 30])
	A.Push([k "_SID", v["SID"], 30])
}
; Screen Resolution
G.Push([40, "屏幕分辨率"])
A.Push(["A_ScreenWidth", A_ScreenWidth, 40])
A.Push(["A_ScreenHeight", A_ScreenHeight, 40])
A.Push(["A_ScreenDPI", A_ScreenDPI, 40])

; Script Properties
G.Push([50, "脚本属性"])
A.Push(["A_WorkingDir", A_WorkingDir, 50, "打开路径"])
A.Push(["A_ScriptDir", A_ScriptDir, 50, "打开路径"])
A.Push(["A_ScriptName", A_ScriptName, 50])
A.Push(["A_ScriptFullPath", A_ScriptFullPath, 50, "打开路径"])
A.Push(["A_ScriptHwnd", A_ScriptHwnd, 50])
A.Push(["A_IsCompiled", A_IsCompiled, 50])
A.Push(["A_IsSuspended", A_IsSuspended, 50])
A.Push(["A_IsPaused", A_IsPaused, 50])

; Date and Time
G.Push([60, "日期及时间"])
A.Push(["A_DDDD", A_DDDD, 60])
A.Push(["A_DDD", A_DDD, 60])
A.Push(["A_MDAY", A_MDAY, 60])
A.Push(["A_WDay", A_WDay, 60])
A.Push(["A_YDay", A_YDay, 60])
A.Push(["A_YWeek", A_YWeek, 60])
A.Push(["A_Now", A_Now, 60])
A.Push(["A_NowUTC", A_NowUTC, 60])
A.Push(["A_TickCount", A_TickCount, 60])

; Special Paths
G.Push([140, "特殊路径"])
A.Push(["A_Temp", A_Temp, 140, "打开路径"])
A.Push(["A_WinDir", A_WinDir, 140, "打开路径"])
A.Push(["ProgramFiles", ProgramFiles, 140, "打开路径"])
A.Push(["A_ProgramFiles", A_ProgramFiles, 140, "打开路径"])
A.Push(["A_AppData", A_AppData, 140, "打开路径"])
A.Push(["A_AppDataCommon", A_AppDataCommon, 140, "打开路径"])
A.Push(["A_Desktop", A_Desktop, 140, "打开路径"])
A.Push(["A_DesktopCommon", A_DesktopCommon, 140, "打开路径"])
A.Push(["A_StartMenu", A_StartMenu, 140, "打开路径"])
A.Push(["A_StartMenuCommon", A_StartMenuCommon, 140, "打开路径"])
A.Push(["A_Programs", A_Programs, 140, "打开路径"])
A.Push(["A_ProgramsCommon", A_ProgramsCommon, 140, "打开路径"])
A.Push(["A_Startup", A_Startup, 140, "打开路径"])
A.Push(["A_StartupCommon", A_StartupCommon, 140, "打开路径"])
A.Push(["A_MyDocuments", A_MyDocuments, 140, "打开路径"])
A.Push(["A_ComSpec", A_ComSpec, 140, "打开路径"])
A.Push(["ComSpec", ComSpec, 140, "打开路径"])

; IP Address
G.Push([150, "IP 地址"])
A.Push(["A_IPAddress1", A_IPAddress1, 150, "设置IP"])
A.Push(["A_IPAddress2", A_IPAddress2, 150, "设置IP"])
A.Push(["A_IPAddress3", A_IPAddress3, 150, "设置IP"])
A.Push(["A_IPAddress4", A_IPAddress4, 150, "设置IP"])
A.Push(["网络适配器", YingJianObj["网络适配器配置"]["描述"], 150, "ipconfig"])
A.Push(["默认网关", YingJianObj["网络适配器配置"]["默认网关"], 150, "ipconfig"])
A.Push(["MAC", YingJianObj["网络适配器配置"]["MAC"], 150, "ipconfig"])
A.Push(["DNS", YingJianObj["网络适配器配置"]["DNS"], 150, "ipconfig"])

; Cursor
G.Push([160, "光标"])
A.Push(["A_Cursor", A_Cursor, 160])
A.Push(["A_CaretX", A_CaretX, 160])
A.Push(["A_CaretY", A_CaretY, 160])

; Clipboard
G.Push([170, "剪贴板"])
A.Push(["Clipboard", Clipboard, 170])
A.Push(["ClipboardAll", ClipboardAll, 170])

G.Push([180, "硬件"])
A.Push(["主板", YingJianObj["主板"]["制造商"] " " YingJianObj["主板"]["型号"], 180])
B_Index := 1
while IsObject(YingJianObj["内存" B_Index])
{
	A.Push(["内存" B_Index, YingJianObj["内存" B_Index]["制造商"] " " YingJianObj["内存" B_Index]["大小"] " " YingJianObj["内存" B_Index]["速度"], 180])
	B_Index ++
}
A.Push(["CPU", YingJianObj["CPU"]["型号"] " (" YingJianObj["CPU"]["核"] " 核)", 180])
B_Index := 1
while IsObject(YingJianObj["显示器" B_Index])
{
	A.Push(["显示器" B_Index, YingJianObj["显示器" B_Index]["型号"] " " YingJianObj["显示器" B_Index]["宽"] "×" YingJianObj["显示器" B_Index]["高"], 180])
	B_Index ++
}
B_Index := 1
while IsObject(YingJianObj["硬盘" B_Index])
{
	A.Push(["硬盘" B_Index, YingJianObj["硬盘" B_Index]["型号"] " (" Ceil(YingJianObj["硬盘" B_Index]["大小"]) " GB) " YingJianObj["硬盘" B_Index]["类型"] " " YingJianObj["硬盘" B_Index]["分区"], 180])
	B_Index ++
}
B_Index := 1
while IsObject(YingJianObj["声卡" B_Index])
{
	A.Push(["声卡" B_Index, YingJianObj["声卡" B_Index]["名称"], 180])
	B_Index ++
}
A.Push(["BIOS", YingJianObj["BIOS"]["制造商"] " " YingJianObj["BIOS"]["版本号"], 180])
B_Index := 1
while IsObject(YingJianObj["显卡" B_Index])
{
	A.Push(["显卡" B_Index, YingJianObj["显卡" B_Index]["名称"] " " YingJianObj["显卡"]["版本号"], 180])
	B_Index ++
}
B_Index := 1
while IsObject(YingJianObj["GPU" B_Index])
{
  A.Push(["GPU" B_Index, YingJianObj["GPU" B_Index]["名称"] " " YingJianObj["GPU" B_Index]["宽"] "×" YingJianObj["GPU" B_Index]["高"], 180])
	B_Index ++
}
A.Push(["网络适配器1", YingJianObj["网络适配器1"]["名称"]  " (" Ceil(YingJianObj["网络适配器1"]["speed"]) " MB) " YingJianObj["网络适配器1"]["显示名称"], 180, "网络连接"])
B_Index := 1
while IsObject(YingJianObj["打印机" B_Index])
{
	A.Push(["打印机" B_Index, YingJianObj["打印机" B_Index]["名称"] " - " YingJianObj["打印机" B_Index]["端口"] (YingJianObj["打印机" B_Index]["默认打印机"]?" - 默认打印机":""), 180])
	B_Index ++
}

Gui +Resize
Gui Color, 0xFEFEFE

Gui Font, c0x003399, MS Shell Dlg 2
;Gui Font, c0x003399 s9, Segoe UI
Gui Add, Text, x15 y11 w630 h30, 下面显示系统和硬件信息. 

If (NT6) {
    Gui Font, s9 cBlack, Segoe UI
} Else {
    Gui Font, s10 cBlack, Lucida Console
}

Gui Add, ListView, hWndhLV vLV x-1 y48 w690 h339 LV0x4000, 名称|信息|预设动作
If (!NT6) {
    ; Increase row height on Windows XP
    LV_SetImageList(DllCall("ImageList_Create", "Int", 2, "Int", 20, "UInt", 0x18, "Int", 1, "Int", 1, "Ptr"), 1)
    GuiControl +Grid, SysListView321
}
Gui Font

; Footer area
Gui Add, TreeView, hWndhTV x-1 y386 w690 h48 BackgroundF1F5FB Disabled 
Gui Font, s9, Segoe UI
Gui Add, Edit, hWndhEdtSearch vSearch gSearch x10 y398 w186 h23 +0x2000000 ; WS_CLIPCHILDREN
DllCall("SendMessage", "Ptr", hEdtSearch, "UInt", 0x1501, "Ptr", 1, "WStr", "查找", "Ptr") ; Hint text
DllCall("SetParent", "Ptr", hPicSearch, "Ptr", hEdtSearch)
WinSet Style, -0x40000000, ahk_id %hPicSearch% ; -WS_CHILD
ControlFocus,, ahk_id %hEdtSearch%

Gui Show, w688 h432, 系统和硬件信息

Menu ContextMenu, Add, 复制`tCtrl+C, MenuHandler
Menu ContextMenu, Icon, 1&, shell32.dll, 135
Menu ContextMenu, Add, 复制变量, MenuHandler
Menu ContextMenu, Add, 复制值, MenuHandler
Menu ContextMenu, Add
Menu ContextMenu, Add, 全选`tCtrl+A, SelectAll
Menu ContextMenu, Add
Menu ContextMenu, Add, 打开预设动作, RunP


If (NT6) {
    Loop % G.Length() {
        LV_InsertGroup(hLV, G[A_Index][1], G[A_Index][2]) ; Define LV Groups
    }

    SendMessage 0x109D, 1, 0,, ahk_id %hLV% ; LVM_ENABLEGROUPVIEW

    DllCall("UxTheme.dll\SetWindowTheme", "Ptr", hLV, "WStr", "Explorer", "Ptr", 0)
}

ShowVariables()

OnMessage(0x100, "OnWM_KEYDOWN")
Return

Search:
    Gui Submit, NoHide
    ShowVariables(Search)
Return

ShowVariables(Filter:= "") {
    LV_Delete()
    GuiControl -Redraw, SysListView321

    For Index, Value in A {
        If (InStr(A[Index][1], Filter) || InStr(A[Index][2], Filter)) {
            Row := LV_Add("", Indent . A[Index][1], A[Index][2], A[Index][4])
            If (NT6 && A[Index][3] != "") {
                LV_SetGroup(hLV, Row, A[Index][3])
            }
        }
    }
    GuiControl +Redraw, SysListView321
    LV_ModifyCol(1, 170)
    LV_ModifyCol(2, 430)
}

GuiContextMenu:
    If (A_GuiControl == "LV" && LV_GetNext()) {
        Menu ContextMenu, Show    
    }
Return

MenuHandler:
    Copy(A_ThisMenuItemPos)
Return

Copy(Param) {
    Global

    Gui +LastFound
    ControlGetFocus Focus
    If (Focus == "Edit1") {
        Send ^C
        Return
    }

    Output := ""

    If (Param != 1) {
        Row := 0
        Col := (Param == 2) ? 1 : 2

        While(Row := LV_GetNext(Row)) {
            LV_GetText(Text, Row, Col)
            Output .= Text . "`r`n"
        }
    } Else {
        ControlGet Output, List, Selected, SysListView321
    }

    If (Output != "") {
        Output := RegExReplace(Output, "m`n)^\s+")
        Clipboard := RTrim(Output, " `t`r`n")
    }
}

SelectAll:
    Gui +LastFound
    ControlGetFocus Focus
    If (Focus == "Edit1") {
        Send ^A
        Return
    }

    ControlFocus, SysListView321
    LV_Modify(0, "Select")
Return

RunP:
Row := LV_GetNext("F")
LV_GetText(Text, Row, 3)
if (Text = "打开路径")
{
	LV_GetText(LPath, Row, 2)
	Run % LPath
}
else if (Text = "设置IP")
{
	Run "%A_AhkPath%" "%A_ScriptDir%\网络连接IP设置.ahk"
}
else if (Text = "网络连接")
{
	Run ::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{7007ACC7-3202-11D1-AAD2-00805FC1270E}
}
else if (Text = "systeminfo")
	run cmd /k systeminfo && pause
else if (Text = "msinfo32")
	run msinfo32.exe
else if (Text = "ipconfig")
	run cmd /k ipconfig /all
return

LV_InsertGroup(hLV, GroupID, Header, Index := -1) {
    Static iGroupId := (A_PtrSize == 8) ? 36 : 24
    NumPut(VarSetCapacity(LVGROUP, 56, 0), LVGROUP, 0)
    NumPut(0x15, LVGROUP, 4, "UInt") ; mask: LVGF_HEADER|LVGF_STATE|LVGF_GROUPID
    NumPut((A_IsUnicode) ? &Header : UTF16(Header, _), LVGROUP, 8, "Ptr") ; pszHeader
    NumPut(GroupID, LVGROUP, iGroupId, "Int") ; iGroupId
    NumPut(0x8, LVGROUP, iGroupId + 8, "Int") ; state: LVGS_COLLAPSIBLE
    SendMessage 0x1091, %Index%, % &LVGROUP,, ahk_id %hLV% ; LVM_INSERTGROUP
    Return ErrorLevel
}

LV_SetGroup(hLV, Row, GroupID) {
    Static iGroupId := (A_PtrSize == 8) ? 52 : 40
    VarSetCapacity(LVITEM, 58, 0)
    NumPut(0x100, LVITEM, 0, "UInt")  ; mask: LVIF_GROUPID
    NumPut(Row - 1, LVITEM, 4, "Int") ; iItem
    NumPut(GroupID, LVITEM, iGroupId, "Int")
    SendMessage 0x1006, 0, &LVITEM,, ahk_id %HLV% ; LVM_SETITEMA
    Return ErrorLevel
}

UTF16(String, ByRef Var) {
    VarSetCapacity(Var, StrPut(String, "UTF-16") * 2, 0)
    StrPut(String, &Var, "UTF-16")
    Return &Var
}

OnWM_KEYDOWN(wParam, lParam, msg, hWnd) {
    CtrlP := GetKeyState("Ctrl", "P")

    If (wParam == 65 && CtrlP) {
        GoSub SelectAll
        Return False
    }

    If (wParam == 67 && CtrlP) {
        Copy(1)
        Return False    
    }
}

GuiSize:
    ;AutoXYWH("w*", "Static2")
    AutoXYWH("wh", hLV)
    AutoXYWH("wy*", hTV)
    AutoXYWH("y" , hEdtSearch)
    AutoXYWH("y" , hPicSearch)
    WinSet Redraw,, ahk_id %hPicSearch%
Return

GuiEscape:
GuiClose:
    ExitApp

MSFT_PhysicalDisk()
{
	static DiskType := []
	static MediaType := { 0: "Unspecified", 3: "HDD", 4: "SDD", 5: "SCM" }
	try {
		for objItem in ComObjGet("winmgmts:\root\Microsoft\Windows\Storage").ExecQuery("SELECT * FROM MSFT_PhysicalDisk") {
			DiskType[A_Index, "FriendlyName"] := objItem.FriendlyName
			DiskType[A_Index, "MediaType"]    := MediaType[objItem.MediaType]
		}
		return DiskType
	}
	return ""
}

networkConfig:
for objItem in ComObjGet("winmgmts:\\.\root\CIMV2").ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True")
{
    if instr(objItem.IPAddress[0], A_IPAddress1)
    {
        MsgBox, % "Description:`t" objItem.Description[0] "`n"
                . "IPAddress:`t`t" objItem.IPAddress[0] "`n"
                . "IPSubnet:`t`t" objItem.IPSubnet[0] "`n"
                . "DefaultIPGateway:`t" objItem.DefaultIPGateway[0] "`n"
                . "DNS-Server:`t" objItem.DNSServerSearchOrder[0] ", " objItem.DNSServerSearchOrder[1] "`n"
                . "MACAddress:`t" objItem.MACAddress "`n"
                . "DHCPEnabled:`t" (objItem.DHCPEnabled[0] ? "No" : "Yes") "`n"

    }
}
return

AutoXYWH(DimSize, cList*){   ;https://www.autohotkey.com/boards/viewtopic.php?t=1079
  Static cInfo := {}

  If (DimSize = "reset")
    Return cInfo := {}

  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If !cInfo.hasKey(ctrlID) {
      ix := iy := iw := ih := 0	
      GuiControlGet i, %A_Gui%: Pos, %ctrl%
      MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
      fx := fy := fw := fh := 0
      For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) 
        If !RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)
          f%dim% := 1

      If (InStr(DimSize, "t")) {
        GuiControlGet hWnd, %A_Gui%: hWnd, %ctrl%
        hParentWnd := DllCall("GetParent", "Ptr", hWnd, "Ptr")
        VarSetCapacity(RECT, 16, 0)
        DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", &RECT)
        DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", &RECT, "UInt", 1)
        ix := ix - NumGet(RECT, 0, "Int")
        iy := iy - NumGet(RECT, 4, "Int")
      }

      cInfo[ctrlID] := {x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a, m:MMD}
    } Else {
      dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw, dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
      Options := ""
      For i, dim in cInfo[ctrlID]["a"]
        Options .= dim (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) A_Space
      GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
} } }

class Computer
{
    ; ***** FUNCTIONS *****
    ;；1.获取CPU序列号函数
    ;方法一
    ;~ GetCpuID()
    ;~ {
    ;~ objSWbemObject:=ComObjGet("winmgmts:Win32_Processor.DeviceID='cpu0'")
    ;~ 序列号:=objSWbemObject.ProcessorId
    ;~ return,%序列号%
    ;~ }
    GetCpuID()
    {
        Version := computer.StdoutToVar_CreateProcess("wmic cpu get Processorid")
        if RegExMatch(Version, "iO)([\w `t]+)[`r`n `t]+([^`r`n]+)", match)
        {
            m_First := match.Value(1)
            m_Second := match.Value(2)
            return % m_Second
        }
    }
    ;;2.获取网卡硬件地址
    ;~ ;方法一
    ;~ GetMacAddress()
    ;~ {
    ;~ NetworkConfiguration:=ComObjGet("Winmgmts:").InstancesOf("Win32_NetworkAdapterConfiguration")
    ;~ for mo in NetworkConfiguration
    ;~ {
    ;~ if(mo.IPEnabled <> 0)
    ;~ return mo.MacAddress
    ;~ }
    ;~ }
    ;方法三
        GetMacAddress()
    {
        NetworkConfiguration := computer.StdoutToVar_CreateProcess("getmac")
        RegExMatch(NetworkConfiguration, ".*?([0-9A-Z].{16})(?!\w\\Device)", mac)
        return %mac1%
    }
    ;获取系统版本信息
    GetOSVersionInfo()
    {
        static Ver
        if !Ver
        {
            VarSetCapacity(OSVer, 284, 0)
            NumPut(284, OSVer, 0, "UInt")
            if !DllCall("GetVersionExW", "Ptr", &OSVer)
                return 0 ; GetSysErrorText(A_LastError)
            Ver := Object()
            Ver.MajorVersion      := NumGet(OSVer, 4, "UInt")
            Ver.MinorVersion      := NumGet(OSVer, 8, "UInt")
            Ver.BuildNumber       := NumGet(OSVer, 12, "UInt")
            Ver.PlatformId        := NumGet(OSVer, 16, "UInt")
            Ver.ServicePackString := StrGet(&OSVer+20, 128, "UTF-16")
            Ver.ServicePackMajor  := NumGet(OSVer, 276, "UShort")
            Ver.ServicePackMinor  := NumGet(OSVer, 278, "UShort")
            Ver.SuiteMask         := NumGet(OSVer, 280, "UShort")
            Ver.ProductType       := NumGet(OSVer, 282, "UChar")
            Ver.EasyVersion       := Ver.MajorVersion . "." . Ver.MinorVersion . "." . Ver.BuildNumber
        }
        return Ver
    }
    ;获取内存物理状态
    GlobalMemoryStatusEx()
    {
        static MEMORYSTATUSEX, init := VarSetCapacity(MEMORYSTATUSEX, 64, 0) && NumPut(64, MEMORYSTATUSEX, "UInt")
        if (DllCall("Kernel32.dll\GlobalMemoryStatusEx", "Ptr", &MEMORYSTATUSEX))
        {
            return { 2 : NumGet(MEMORYSTATUSEX, 8, "UInt64")
                , 3 : NumGet(MEMORYSTATUSEX, 16, "UInt64")
                , 4 : NumGet(MEMORYSTATUSEX, 24, "UInt64")
                , 5 : NumGet(MEMORYSTATUSEX, 32, "UInt64") }
        }
    }
    ; Im Original gilt "CP0"; zu CharSet CP850/CP858 vgl.: https://goo.gl/Y8xUYu , http://goo.gl/cMtc6i , https://goo.gl/ssCplI , https://goo.gl/s2P1jK
    StdoutToVar_CreateProcess(sCmd, sEncoding:="CP858", sDir:="", ByRef nExitCode:=0) 
    {
        DllCall( "CreatePipe",           PtrP,hStdOutRd, PtrP,hStdOutWr, Ptr,0, UInt,0 )
        DllCall( "SetHandleInformation", Ptr,hStdOutWr, UInt,1, UInt,1                 )
        VarSetCapacity( pi, (A_PtrSize == 4) ? 16 : 24,  0 )
        siSz := VarSetCapacity( si, (A_PtrSize == 4) ? 68 : 104, 0 )
        NumPut( siSz,      si,  0,                          "UInt" )
        NumPut( 0x100,     si,  (A_PtrSize == 4) ? 44 : 60, "UInt" )
        NumPut( hStdInRd,  si,  (A_PtrSize == 4) ? 56 : 80, "Ptr"  )
        NumPut( hStdOutWr, si,  (A_PtrSize == 4) ? 60 : 88, "Ptr"  )
        NumPut( hStdOutWr, si,  (A_PtrSize == 4) ? 64 : 96, "Ptr"  )
        if ( !DllCall( "CreateProcess", Ptr,0, Ptr,&sCmd, Ptr,0, Ptr,0, Int,True, UInt,0x08000000
            , Ptr,0, Ptr,sDir?&sDir:0, Ptr,&si, Ptr,&pi ) )
            return ""
            , DllCall( "CloseHandle", Ptr,hStdOutWr )
            , DllCall( "CloseHandle", Ptr,hStdOutRd )
        DllCall( "CloseHandle", Ptr,hStdOutWr ) ; The write pipe must be closed before Reading the stdout.
        VarSetCapacity(sTemp, 4095)
        while ( DllCall( "ReadFile", Ptr,hStdOutRd, Ptr,&sTemp, UInt,4095, PtrP,nSize, Ptr,0 ) )
        sOutput .= StrGet(&sTemp, nSize, sEncoding)
        DllCall( "GetExitCodeProcess", Ptr,NumGet(pi,0), UIntP,nExitCode )
        DllCall( "CloseHandle",        Ptr,NumGet(pi,0)                  )
        DllCall( "CloseHandle",        Ptr,NumGet(pi,A_PtrSize)          )
        DllCall( "CloseHandle",        Ptr,hStdOutRd                     )
        return sOutput
    }
}