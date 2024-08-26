;|2.8|2024.08.26|1661
#SingleInstance Force
#NoEnv
;SetWorkingDir %A_ScriptDir%
SetBatchLines -1

Gui, Add, ListView, x10 y10 w800 h350 vMyList gdoubclick Checked, 序号|服务名称|显示名称|描述|是否运行|启动类型|可执行文件路径|服务类型|1|2|3|

arr:=["ATService", "Flash Helper Service", "FlashCenterSvc", "GLyhPassInputService", "HuaweiHiSuiteService64.exe", "PSBCInputService", "spacedeskService", "Spooler", "ToDesk_Service", "VMwareHostd", "VMnetDHCP", "VMware NAT Service", "wpscloudsvr", "XLServicePlatform"]
runstateObj := {1:"停止", 2:"正在启动", 3:"正在停止", 4:"运行", 5:"可恢复", 6:"可暂停", 7:"暂停"}
startTypeObj := {0:"启动", 1:"系统", 2:"自动", 3:"手动", 4:"禁用"}
startTypeValueObj := {"启动":0, "系统":1, "自动":2, "手动":3, "禁用":4}
ServiceTypeObj := { 1:"驱动程序服务", 2:"文件系统驱动", 16:"进程独立运行", 32:"共享进程", 256:"可与桌面交互", 272:"可交互独立进程"}

for k, v in arr
{
  是否运行 := Service_State(v)
  ServObj := Service_Info(v)
  Lv_Add("", k, v, ServObj.svcDispName, ServObj.svcDesc, runstateObj[是否运行], startTypeObj[ServObj.svcStartMode], ServObj.svcPathName, ServiceTypeObj[ServObj.svcType], ServObj.svcDep, ServObj.svcTrigger, ServObj.svcDelayed)
  ;Lv_Add("", k, v, ServObj.svcDispName, ServObj.svcDesc, runstateObj[是否运行], startTypeObj[ServObj.svcStartMode], ServObj.svcPathName, ServObj.svcType, ServObj.svcDep, ServObj.svcTrigger, ServObj.svcDelayed)
}
LV_ModifyCol()
LV_ModifyCol(2, 120)
LV_ModifyCol(3, 140)
LV_ModifyCol(4, 250)
LV_ModifyCol(5, 60)
LV_ModifyCol(6, 60)
LV_ModifyCol(7, 200)
Gui Show, AutoSize, 服务管理
Return

doubclick:
if (A_GuiEvent = "DoubleClick")
{
	RF := LV_GetNext("F")
	if RF
	{
		LV_GetText(ServName, RF, 2)
    gosub editserv
	}
}
return

editserv:
是否运行 := Service_State(ServName)
ServObj := Service_Info(ServName)
Gui, 99:default
Gui Font, s9, Segoe UI
Gui Add, Text, x17 y11 w70 h23 +0x200, 服务名称:
Gui Add, Edit, x104 y9 w324 h28 ReadOnly veServName, %ServName%
Gui Add, Text, x18 y49 w70 h23 +0x200, 显示名称:
Gui Add, Edit, x105 y49 w324 h28 ReadOnly, % ServObj.svcDispName
Gui Add, Text, x22 y96 w70 h23 +0x200, 描述:
Gui Add, Edit, x105 y96 w326 h102 ReadOnly, % ServObj.svcDesc
Gui Add, Text, x29 y225 w149 h23 +0x200, 可执行文件的路径:
Gui Add, Edit, x28 y262 w397 h23 ReadOnly, % ServObj.svcPathName
Gui Add, Text, x28 y389 w400 h2 +0x10
Gui Add, Text, x29 y323 w70 h23 +0x200, 启动类型:
Gui Add, DropDownList, x104 y324 w323 veServstartType, 自动|手动|禁用|自动(延迟启动)
GuiControl, ChooseString, ComboBox1, % startTypeObj[ServObj.svcStartMode]

Gui Add, Text, x34 y417 w70 h23 +0x200, 服务状态:
Gui Add, Edit, x106 y415 w321 h28 ReadOnly, % runstateObj[是否运行]

Gui Add, Button, x34 y475 w80 h30 gstartserv, 启动
Gui Add, Button, x136 y474 w80 h30 gstopserv, 停止
;Gui Add, Button, x241 y474 w80 h30, 暂停
;Gui Add, Button, x340 y475 w80 h30, 恢复
if (runstateObj[是否运行] = "停止")
{
  GuiControl, Enable, Button1
  GuiControl, Disable, Button2
}
else if (runstateObj[是否运行] = "运行")
{
  GuiControl, Disable, Button1
  GuiControl, Enable, Button2
}
Gui Add, Button, x180 y560 w80 h30 gsave, 确定
Gui Add, Button, x265 y560 w80 h30 g99GuiClose, 取消
;Gui Add, Button, x350 y560 w80 h30, 应用
Gui Add, Text, x37 y539 w383 h2 +0x10

Gui Show, w441 h609, 服务编辑
Return

99GuiEscape:
99GuiClose:
  Gui,99: Destroy
return

GuiEscape:
GuiClose:
  Gui, Destroy
  exitapp
return

startserv:
Gui, 99:default
gui, submit, nohide
Service_Start(eServName)
svs := Service_State(eServName)
if (svs = 4)
{
  GuiControl, Disable, Button1
  GuiControl, Enable, Button2
}
return

stopserv:
Gui, 99:default
gui, submit, nohide
Service_Stop(eServName)
svs := Service_State(eServName)
if (svs = 1)
{
  GuiControl, Enable, Button1
  GuiControl, Disable, Button2
}
return

save:
Gui, 99:default
gui, submit, nohide
msgbox % startTypeValueObj[eServstartType]
;Service_Change_StartType(eServName, startTypeValueObj[eServstartType])
return

;MsgBox % Service_List("Active") ;Get List of Running Win32 Service

Service_List(State="", Type="", delimiter="`n"){
	if !State
		ServiceState := 0x3 ; SERVICE_STATE_ALL (0x00000003)
	else if (State="Active")
		ServiceState := 0x1 ; SERVICE_ACTIVE (0x00000001)
	else if (State="Inactive")
		ServiceState := 0x2 ; SERVICE_INACTIVE (0x00000002)
	else
		ServiceState := 0x3
	
	if !Type
		ServiceType := 0x30 ; SERVICE_WIN32 (0x00000030)
	else if (Type="Driver")
		ServiceType := 0xB ; SERVICE_DRIVER (0x0000000B)
	else if (Type="All")
		ServiceType := 0x3B ; sum of both
	else
		ServiceType := 0x30
		 
	SCM_HANDLE := OpenSCManager(0x0004) ; SC_MANAGER_ENUMERATE_SERVICE (0x0004)    

	EnumServicesStatus(SCM_HANDLE, ServiceType, ServiceState, 0, 0, bSize)
	
	VarSetCapacity(ENUM_SERVICE_STATUS, bSize, 0) ;prepare struct
	;msgbox % bSize
	EnumServicesStatus(SCM_HANDLE, ServiceType, ServiceState, &ENUM_SERVICE_STATUS, bSize, 0, ServiceCount)
	;msgbox % ServiceCount

	; debugbin(ENUM_SERVICE_STATUS, bSize, "456.txt")

	Loop, %ServiceCount%
	{
		;msgbox % String := StrGet(ENUM_SERVICE_STATUS+(A_Index-1)*36+4, "UTF-16")
		;msgbox % StrGet(NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*A_PtrSize*9+A_PtrSize), "UTF-16") " - " NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*A_PtrSize*9+A_PtrSize)

		if (A_PtrSize = 4)
			;addd := NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*(4+4+7*4)+A_PtrSize)  ; 服务显示名称
			addd := NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*(4+4+7*4))             ; 服务名
		ELSE
			;addd := NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*(8+8+7*4+4)+A_PtrSize)
			addd := NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*(8+8+7*4+4))
		;FileAppend(addd "`n")
		if !addd
			break
		if (addd != 0)
		{
			aa:=StrGet(addd, "UTF-16")
			;msgbox % aa
			result .= aa . delimiter
		}
	}

    CloseServiceHandle(SCM_HANDLE)
    Return result
}

Service_Info(ServiceName) {
	encoding := (!StrLen(Chr(0xFFFF))) ? "UTF-8" : "UTF-16"
	SCM_HANDLE := OpenSCManager(0xF003F)
	if !(SC_HANDLE := OpenService(SCM_HANDLE, ServiceName, 0x0001))
		result := 0
	Else
	{
		QueryServiceConfig(SC_HANDLE,,, bSize:=0)
		;DllCall("advapi32\QueryServiceConfig", "Ptr", SC_HANDLE, "Ptr", 0, "UInt", 0, "UInt*", bSize)
		;msgbox % bSize
		VarSetCapacity(QUERY_SERVICE_CONFIG, bSize, 0)
		QueryServiceConfig(SC_HANDLE, &QUERY_SERVICE_CONFIG, bSize)
		;DllCall("advapi32\QueryServiceConfig", "Ptr", SC_HANDLE, "Ptr", &QUERY_SERVICE_CONFIG, "UInt", bSize, "UInt*", 0)
		;debugbin(QUERY_SERVICE_CONFIG, bSize, "456.txt")
		If (bSize) {
			svcType := NumGet(QUERY_SERVICE_CONFIG,0,"UInt")
			svcStartMode := NumGet(QUERY_SERVICE_CONFIG,4,"UInt")
			svcErrCtl := NumGet(QUERY_SERVICE_CONFIG,8,"UInt")
			binPath_LPSTR := NumGet(QUERY_SERVICE_CONFIG,(A_PtrSize=4) ? 12 : 16, "UPtr")
			svcPathName := StrGet(binPath_LPSTR,encoding)
			;lpLoadOrderGroup:16:24
			;dwTagId:20:32
			depen_LPSTR := NumGet(QUERY_SERVICE_CONFIG,(A_PtrSize=4) ? 24 : 40, "UPtr")
			ServiceStartName_LPSTR := NumGet(QUERY_SERVICE_CONFIG,(A_PtrSize=4) ? 28 : 48, "UPtr")
			DispName_LPSTR := NumGet(QUERY_SERVICE_CONFIG,(A_PtrSize=4) ? 32 : 56, "UPtr")
			svcDispName := StrGet(DispName_LPSTR,encoding)
			;msgbox % svcPathName
			offset := 0, svcDep := {}, svcTrigger := 0, svcDelayed := false, svcDesc := ""
			While (curDep := StrGet(depen_LPSTR+offset,encoding)) {
				;msgbox % curDep
				svcDep[curDep] := ""
				offset += (StrLen(curDep) + 1) * ((A_PtrSize=4) ? 1 : 2)
			}

      SERVICE_CONFIG_DESCRIPTION:=1
			QueryServiceConfig2(SC_HANDLE, SERVICE_CONFIG_DESCRIPTION,,, bSize:=0)
			;DllCall("advapi32\QueryServiceConfig2", "Ptr", SC_HANDLE, "UInt", SERVICE_CONFIG_DESCRIPTION, "Ptr", 0, "UInt", 0, "UInt*", bSize)
			if (bSize) {
				VarSetCapacity(SERVICE_DESCRIPTION, bSize, 0)
				QueryServiceConfig2(SC_HANDLE, SERVICE_CONFIG_DESCRIPTION, &SERVICE_DESCRIPTION, bSize)
				;DllCall("advapi32\QueryServiceConfig2", "Ptr", SC_HANDLE, "UInt", SERVICE_CONFIG_DESCRIPTION, "Ptr", &SERVICE_DESCRIPTION, "UInt", bSize, "UInt*", 0)
       str_ptr := NumGet(SERVICE_DESCRIPTION, "UPtr")
			;msgbox % str_ptr
				svcDesc := str_ptr ? StrGet(str_ptr, encoding) : ""
;msgbox % svcDesc
			}

			SERVICE_CONFIG_DELAYED_AUTO_START_INFO:=3
			QueryServiceConfig2(SC_HANDLE, SERVICE_CONFIG_DELAYED_AUTO_START_INFO,,, bSize:=0)
			;DllCall("advapi32\QueryServiceConfig2", "Ptr", SC_HANDLE, "UInt", SERVICE_CONFIG_DELAYED_AUTO_START_INFO, "Ptr", 0, "UInt", 0, "UInt*", bSize)
			if (bSize) {
				VarSetCapacity(SERVICE_DELAYED_AUTO_START_INFO, bSize, 0)
				r := QueryServiceConfig2(SC_HANDLE, SERVICE_CONFIG_DELAYED_AUTO_START_INFO, &SERVICE_DELAYED_AUTO_START_INFO, bSize)
       svcDelayed := r ? NumGet(SERVICE_DELAYED_AUTO_START_INFO,"Char") : false
			}

			SERVICE_CONFIG_TRIGGER_INFO := 8
			QueryServiceConfig2(SC_HANDLE, SERVICE_CONFIG_TRIGGER_INFO,,, bSize:=0)
			if (bSize) {
				VarSetCapacity(SERVICE_TRIGGER_INFO, bSize, 0)
				r := QueryServiceConfig2(SC_HANDLE, SERVICE_CONFIG_TRIGGER_INFO, &SERVICE_TRIGGER_INFO, bSize)
				svcTrigger := NumGet(SERVICE_TRIGGER_INFO,"UInt")
			}
	}
	CloseServiceHandle(SC_HANDLE)
	result := {"svcName":ServiceName,"svcDispName":svcDispName,"svcStartMode":svcStartMode
					 ,"svcDesc":svcDesc,"svcPathName":svcPathName,"svcType":svcType,"svcDep":svcDep
					 ,"svcTrigger":svcTrigger,"svcDelayed":svcDelayed}
	}
	CloseServiceHandle(SCM_HANDLE)
	Return result
}

Service_Start(ServiceName)
{
	ServiceName := _GetName_(ServiceName) 
	SCM_HANDLE := OpenSCManager(0x0001) ; SC_MANAGER_CONNECT (0x0001)    

	if !(SC_HANDLE := OpenService(SCM_HANDLE, ServiceName, 0x0010)) ; SERVICE_START (0x0010)
		result := -4 ;Service Not Found

	if !result
		result := StartService(SC_HANDLE)

	CloseServiceHandle(SC_HANDLE)
	CloseServiceHandle(SCM_HANDLE)
	return result
}

Service_Stop(ServiceName)
{
	ServiceName := _GetName_(ServiceName)

	SCM_HANDLE := OpenSCManager(0x0001) ; SC_MANAGER_CONNECT (0x0001)    

	if !(SC_HANDLE := OpenService(SCM_HANDLE, ServiceName, 0x0020)) ; SERVICE_STOP (0x0020)
		result := -4 ;Service Not Found

	if !result
	{
		VarSetCapacity(SERVICE_STATUS, (A_PtrSize=4)?28:32, 0)
		result := ControlService(SC_HANDLE, &SERVICE_STATUS)
;msgbox % result " - " ErrorLevel " - " A_LastError
}
	CloseServiceHandle(SC_HANDLE)
	CloseServiceHandle(SCM_HANDLE)
	return result
}


/* Windows Service Control Functions
-heresy

;MsgBox % Service_State("Print Spooler")
if Service_State("Print Spooler")=4 ;if Print Spooler service is running
    Service_Stop("Print Spooler") ;stop
else if Service_State("Print Spooler")=1 ;if Print Spooler service is not running
    Service_Start("Print Spooler") ;start

MsgBox % Service_State("Print Spooler")

- State codes from Service_State() 
	; Return Values
	; SERVICE_STOPPED (1) : The service is not running.
	; SERVICE_START_PENDING (2) : The service is starting.
	; SERVICE_STOP_PENDING (3) : The service is stopping.
	; SERVICE_RUNNING (4) : The service is running.
	; SERVICE_CONTINUE_PENDING (5) : The service continue is pending.
	; SERVICE_PAUSE_PENDING (6) : The service pause is pending.
	; SERVICE_PAUSED (7) : The service is paused.
*/
Service_State(ServiceName)
{ 
	ServiceName := _GetName_(ServiceName)
	;msgbox % ServiceName
	SCM_HANDLE := OpenSCManager(0x1)
	; SC_MANAGER_CONNECT (0x0001)

	if !SC_HANDLE := OpenService(SCM_HANDLE, ServiceName, 0x4)  ; SERVICE_QUERY_STATUS (0x0004)
		result := -4 ; Service Not Found

	if !result
	{
		VarSetCapacity(SC_STATUS, 28, 0) ; SERVICE_STATUS Struct
		h := QueryServiceStatus(SC_HANDLE, &SC_STATUS)
		;h := DllCall("advapi32\QueryServiceStatus", "UInt", SC_HANDLE, "UInt", &SC_STATUS)
		;msgbox % h " - " ErrorLevel " - " A_LastError
		;debugbin(&SC_STATUS, 28, "456.txt")
		result := !h ? False : NumGet(SC_STATUS, 4, "UInt") ;-1 or dwCurrentState
	}

    CloseServiceHandle(SC_HANDLE)
    CloseServiceHandle(SCM_HANDLE)
    return result
}

/*
- Return Values
     1 : Success
     0 : Failure
    -4 : Service Not Found
*/
Service_Add(ServiceName, BinaryPath, StartType := "", DisplayName := ""){
    if !A_IsAdmin
        Return False

    SCM_HANDLE :=OpenSCManager(0x0002) ; SC_MANAGER_CREATE_SERVICE (0x0002)
    
    StartType := !StartType ? 0x3 : 0x2
    ;SERVICE_DEMAND_START(0x00000003) vs SERVICE_AUTO_START(0x00000002)
    SC_HANDLE := CreateService(SCM_HANDLE, ServiceName, DisplayName?DisplayName:ServiceName, 0xF01FF, 0x110, StartType, 0x1, BinaryPath)
    result := A_LastError ? SC_HANDLE "," A_LastError : 1
    CloseServiceHandle(SC_HANDLE)
    CloseServiceHandle(SCM_HANDLE)
    Return result
}

Service_Delete(ServiceName)
{
    if !A_IsAdmin ;Requires Administrator rights
        Return False
    ServiceName := _GetName_(ServiceName)    

    SCM_HANDLE := OpenSCManager(0x0001) ; SC_MANAGER_CONNECT (0x0001)

    if !(SC_HANDLE := OpenService(SCM_HANDLE, ServiceName, 0xF01FF)) ; SERVICE_ALL_ACCESS (0xF01FF)
        result := -4 ;Service Not Found

    if !result
        result := DeleteService(SC_HANDLE)

    CloseServiceHandle(SC_HANDLE)
    Return result    
}

Service_Change_StartType(ServiceName, sStartType) {
	if !A_IsAdmin ;Requires Administrator rights
        Return False
	SCM_HANDLE := OpenSCManager(0xF003F)
	hSvc := OpenService(SCM_HANDLE,ServiceName,0x0002)

	If (!hSvc) {
		result := 0
	} Else {
		result := ChangeServiceConfig(hSvc,,sStartType)
		CloseServiceHandle(hSvc)
	}
	CloseServiceHandle(SCM_HANDLE)
	Return result
}

; SC_MANAGER_ALL_ACCESS := 0xF003F
OpenSCManager(AR) {
	f := (!StrLen(Chr(0xFFFF))) ? "OpenSCManagerA" : "OpenSCManagerW"
	Return DllCall("advapi32\" f, "Ptr", 0, "Ptr", 0, "UInt", AR)
}

; SERVICE_CHANGE_CONFIG (0x0002)
OpenService(SCM_HANDLE, ServiceName, AR) {
	f := (!StrLen(Chr(0xFFFF))) ? "OpenServiceA" : "OpenServiceW"
	Return DllCall("advapi32\" f, "UInt", SCM_HANDLE, "Str", ServiceName, "UInt", AR)
}

CloseServiceHandle(Handle) {
	DllCall("advapi32\CloseServiceHan}dle", "Ptr", Handle)
}

ChangeServiceConfig(hService, sType := 0xFFFFFFFF, sStartType := 0xFFFFFFFF) {
	;SERVICE_BOOT_START:=0x00000000       启动
	;SERVICE_SYSTEM_START:=0x00000001     系统
	;SERVICE_AUTO_START:=0x00000002       自动
	;SERVICE_DEMAND_START:=0x00000003     手动
	;SERVICE_DISABLED:=0x00000004         禁用
	;SERVICE_NO_CHANGE:=0xFFFFFFFF
	f := (!StrLen(Chr(0xFFFF))) ? "ChangeServiceConfigA" : "ChangeServiceConfigW"
	Return DllCall("advapi32\" f, "Ptr", hService, "UInt", sType, "UInt", sStartType, "UInt", 0xFFFFFFFF, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0, "Ptr", 0)
}

Description_Service(hService, Description)
{
	f := (!StrLen(Chr(0xFFFF))) ? "ChangeServiceConfig2A" : "ChangeServiceConfig2W"
	cResult := DllCall("advapi32\" f, "UInt", hService, "UInt", 1, "Str*", Description)
	;cResult := DllCall("advapi32\" f, "UInt", hService, "UInt", 1, "Ptr", Description)
	Return cResult
}

QueryServiceConfig(hService, ServiceConfig := 0, BufSize := 0, ByRef BytesNeeded := 0) {
	f := (!StrLen(Chr(0xFFFF))) ? "QueryServiceConfigA" : "QueryServiceConfigW"
	Return DllCall("advapi32\" f, "Ptr", hService, "Ptr", ServiceConfig, "UInt", BufSize, "UInt*", BytesNeeded)
}

QueryServiceConfig2(hService, InfoLevel:=0, Buff:=0, BufSize:=0, ByRef BytesNeeded:=0) {
	f := (!StrLen(Chr(0xFFFF))) ? "QueryServiceConfig2A" : "QueryServiceConfig2W"
	Return DllCall("advapi32\" f,"Ptr",hService, "UInt", InfoLevel, "Ptr", Buff, "UInt", BufSize, "UInt*", BytesNeeded)
}

EnumServicesStatus(hService, sType, sState, lpServices:=0, BufSize:=0, ByRef BytesNeeded:=0, ByRef sCount:=0, ByRef ResumeHandle:=0) {
	f := (!StrLen(Chr(0xFFFF))) ? "EnumServicesStatusA" : "EnumServicesStatusW"
    Return DllCall("advapi32\" f
           ,"Ptr", hService, "UInt", sType, "UInt", sState, "Ptr", lpServices
           ,"UInt", BufSize, "UInt*", BytesNeeded,"UInt*", sCount, "UInt*", ResumeHandle)
}

QueryServiceStatus(hService, SC_STATUS) {
	Return DllCall("advapi32\QueryServiceStatus", "Ptr", hService, "Ptr", SC_STATUS)
}

StartService(hService) {
	f := (!StrLen(Chr(0xFFFF))) ? "StartServiceA" : "StartServiceW"
	Return DllCall("advapi32\" f, "UPtr", hService, "UInt", 0, "Ptr", 0)
}

ControlService(hService, SERVICE_STATUS := 0) {
	Return DllCall("advapi32\ControlService", "UPtr", hService, "UInt", 1, "Ptr", SERVICE_STATUS)
}

CreateService(SCM_HANDLE, ServiceName, DisplayName:="", dwDesiredAccess:=0xF01FF, dwServiceType:=0x00000010, dwStartType:=2, dwErrorControl:=0x00000001, lpBinaryPathName:=0) {
  funcName2 := (!StrLen(Chr(0xFFFF))) ? "CreateServiceA" : "CreateServiceW"
 
	Return DllCall("advapi32\" funcName2
                   , "Ptr", SCM_HANDLE ; UInt?
                   , "Str", ServiceName
                   , "Str", (!DisplayName ? ServiceName : DisplayName)
                   , "UInt", dwDesiredAccess ;SERVICE_ALL_ACCESS (0xF01FF)
                   , "UInt", dwServiceType ;SERVICE_WIN32_OWN_PROCESS(0x00000010) | SERVICE_INTERACTIVE_PROCESS(0x00000100)
    ;;;;;; interactable service with desktop (requires local account)
    ;;;;;; http://msdn.microsoft.com/en-us/library/ms683502(VS.85).aspx
                   , "UInt", dwStartType
                   , "UInt", dwErrorControl ;SERVICE_ERROR_NORMAL(0x00000001)
                   , "Str", lpBinaryPathName
                   , "Ptr",  0 ;No Group (string)
                   , "UInt", 0 ;No TagId
                   , "Ptr",  0 ;No Dependencies (string)
                   , "Int",  0 ;Use LocalSystem Account
                   , "Ptr",  0) ;(String)
}

DeleteService(hService) {
	Return DllCall("advapi32\DeleteService", "Ptr", hService)
}

_GetName_(DisplayName)
{ ;Internal, Gets Service Name from Display Name, 
    SCM_HANDLE := DllCall("advapi32\OpenSCManager", "Int", 0, "Int", 0, "UInt", 0x1) ;SC_MANAGER_CONNECT (0x0001)    

    DllCall("advapi32\GetServiceKeyName" ;Get Buffer Size
            , "Uint", SCM_HANDLE   ; 服务管理句柄
            , "Str", DisplayName    ; 服务显示名称
            , "Int", 0      
            , "UintP", Len)

    VarSetCapacity(Buffer, Len * 2) ;Prepare Buffer
;msgbox % Len * 2
   h := DllCall("advapi32\GetServiceKeyName" ;Get Actual Service Name
        , "Uint", SCM_HANDLE
        , "Str", DisplayName
        , "Uint", &Buffer         ; 服务名称
        , "UintP", Len * 2)
;msgbox % h " - " ErrorLevel " - " A_LastError
;debugbin(Buffer, Len * 2, "456.txt")
 Output := StrGet(&Buffer, Len * 2, "UTF-16")
;msgbox % &Buffer
    ;Loop, % Len//2    
    ;    Output .= Chr(NumGet(Buffer, A_Index-1, "Char"))

    return !Output ? DisplayName : Output
}