;|2.6|2024.04.26|1578,1579,多条目
CandySel := A_Args[1]
CandySel2 := A_Args[2]

if (CandySel2 = "Start")
{
	if (Service_State(CandySel) = 1)
	{
		Service_Start(CandySel)
		sleep 500
		if (Service_State(CandySel) = 4)
		{
			CF_ToolTip("服务" CandySel "启动成功.", 2500)
			;msgbox 11111
		}
	}
	else if (Service_State(CandySel) = 4)
	{
		CF_ToolTip("服务" CandySel "已经在运行.", 2500)
	}
}
else if (CandySel2 = "Stop")
{
;msgbox % Service_State(CandySel)
	if (Service_State(CandySel) = 4)
	{
		Service_Stop(CandySel)
		sleep 500
;msgbox % Service_State(CandySel)
		if (Service_State(CandySel) = 1)
		{
			CF_ToolTip("停止" CandySel "服务成功.", 2500)
			;msgbox 11111
		}
	}
	else if (Service_State(CandySel) = 1)
	{
		CF_ToolTip("服务" CandySel "没有在运行.", 2500)
		;msgbox 22222
	}
}
else if (CandySel2 = "List")
{
	msgbox % Service_List(CandySel)
}
sleep 3000
return

/* Windows Service Control Functions
-heresy

- Return Values
     1 : Success
     0 : Failure
    -4 : Service Not Found

- State codes from Service_State() 
    SERVICE_STOPPED (1) : The service is not running.
    SERVICE_START_PENDING (2) : The service is starting.
    SERVICE_STOP_PENDING (3) : The service is stopping.
    SERVICE_RUNNING (4) : The service is running.
    SERVICE_CONTINUE_PENDING (5) : The service continue is pending.
    SERVICE_PAUSE_PENDING (6) : The service pause is pending.
    SERVICE_PAUSED (7) : The service is paused.
*/

Service_List(State="", Type="", delimiter="`n"){
    if !State
        ServiceState := 0x3 ;SERVICE_STATE_ALL (0x00000003)
    else if (State="Active")
        ServiceState := 0x1 ;SERVICE_ACTIVE (0x00000001)
    else if (State="Inactive")
        ServiceState := 0x2 ;SERVICE_INACTIVE (0x00000002)
    else
        ServiceState := 0x3
    
    if !Type
        ServiceType := 0x30 ;SERVICE_WIN32 (0x00000030)
    else if (Type="Driver")
        ServiceType := 0xB ;SERVICE_DRIVER (0x0000000B)
    else if (Type="All")
        ServiceType := 0x3B ;sum of both
    else
        ServiceType := 0x30
       
    SCM_HANDLE := DllCall("advapi32\OpenSCManager"
                        , "Int", 0
                        , "Int", 0
                        , "UInt", 0x4) ;SC_MANAGER_ENUMERATE_SERVICE (0x0004)    

    DllCall("advapi32\EnumServicesStatus"
        , "UInt", SCM_HANDLE
        , "UInt", ServiceType
        , "UInt", ServiceState
        , "UInt", 0
        , "UInt", 0
        , "UIntP", bSize ;get required buffer size first
        , "UIntP", 0
        , "UIntP", 0)
    
    VarSetCapacity(ENUM_SERVICE_STATUS, bSize, 0) ;prepare struct
    ;msgbox % bSize
    DllCall("advapi32\EnumServicesStatus" ;actual enumeration
        , "UInt", SCM_HANDLE
        , "UInt", ServiceType
        , "UInt", ServiceState
        , "UInt", &ENUM_SERVICE_STATUS
        , "UInt", bSize
        , "UIntP", 0
        , "UIntP", ServiceCount
        , "UIntP", 0)
;msgbox % ServiceCount

;msgbox % debugbin(ENUM_SERVICE_STATUS, bSize, "456.txt")

;msgbox % &ENUM_SERVICE_STATUS "-" bSize
    Loop, %ServiceCount%
{
	;msgbox % String := StrGet(ENUM_SERVICE_STATUS+(A_Index-1)*36+4, "UTF-16")
	;msgbox % StrGet(NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*A_PtrSize*9+A_PtrSize), "UTF-16") " - " NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*A_PtrSize*9+A_PtrSize)


	if (A_PtrSize = 4)
		addd := NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*(4+4+7*4)+A_PtrSize)
	ELSE
		addd := NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*(8+8+7*4+4)+A_PtrSize)
	if !addd
		break
	if (addd != 0)
	{
		
		aa:=StrGet(addd, "UTF-16")
;msgbox % aa
		result .= aa . delimiter
	}

	;result .= StrGet(NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*A_PtrSize*9+A_PtrSize), "UTF-16") . delimiter

/*
        result2 .= DllCall("MulDiv"
                        , "Int", NumGet(ENUM_SERVICE_STATUS, (A_Index-1)*36+4)
                        , "Int", 1
                        , "Int", 1, "str") . delimiter
*/
}

    DllCall("advapi32\CloseServiceHandle", "UInt", SCM_HANDLE)
    Return result
    
}

/*
BOOL EnumServicesStatusA(
  [in]                SC_HANDLE              hSCManager,
  [in]                DWORD                  dwServiceType,
  [in]                DWORD                  dwServiceState,
  [out, optional]     LPENUM_SERVICE_STATUSA lpServices,
  [in]                DWORD                  cbBufSize,
  [out]               LPDWORD                pcbBytesNeeded,
  [out]               LPDWORD                lpServicesReturned,
  [in, out, optional] LPDWORD                lpResumeHandle
);

LPENUM_SERVICE_STATUSA
指向缓冲区的指针，该缓冲区包含 一组ENUM_SERVICE_STATUS 结构，这些结构接收数据库中每个服务的名称和服务状态信息。 缓冲区必须足够大，以便保存结构及其成员指向的字符串。

此数组的最大大小为 256K 字节。 若要确定所需的大小，请为此参数指定 NULL，为 cbBufSize 参数指定 0


typedef struct _ENUM_SERVICE_STATUSA {
  LPSTR          lpServiceName;
  LPSTR          lpDisplayName;
  SERVICE_STATUS ServiceStatus;
} ENUM_SERVICE_STATUSA, *LPENUM_SERVICE_STATUSA;

*/

Service_Start(ServiceName)
{
    ServiceName := _GetName_(ServiceName) 

    SCM_HANDLE := DllCall("advapi32\OpenSCManager"
                        , "Int", 0 ;NULL for local
                        , "Int", 0
                        , "UInt", 0x1) ;SC_MANAGER_CONNECT (0x0001)    

    if !(SC_HANDLE := DllCall("advapi32\OpenService"
                            , "UInt", SCM_HANDLE
                            , "Str", ServiceName
                            , "UInt", 0x10)) ;SERVICE_START (0x0010)
        result := -4 ;Service Not Found

    if !result
        result := DllCall("advapi32\StartService"
                        , "UInt", SC_HANDLE
                        , "Int", 0
                        , "Int", 0)

    DllCall("advapi32\CloseServiceHandle", "UInt", SC_HANDLE)
    DllCall("advapi32\CloseServiceHandle", "UInt", SCM_HANDLE)
    return result
}

Service_Stop(ServiceName)
{
    ServiceName := _GetName_(ServiceName)

    SCM_HANDLE := DllCall("advapi32\OpenSCManager"
                        , "Int", 0 ;NULL for local
                        , "Int", 0
                        , "UInt", 0x1) ;SC_MANAGER_CONNECT (0x0001)    

    if !(SC_HANDLE := DllCall("advapi32\OpenService"
                            , "UInt", SCM_HANDLE
                            , "Str", ServiceName
                            , "UInt", 0x20)) ;SERVICE_STOP (0x0020)
        result := -4 ;Service Not Found

    if !result
        result := DllCall("advapi32\ControlService"
                        , "UInt", SC_HANDLE
                        , "Int", 1
                        , "Str", "")

    DllCall("advapi32\CloseServiceHandle", "UInt", SC_HANDLE)
    DllCall("advapi32\CloseServiceHandle", "UInt", SCM_HANDLE)
    return result
}

Service_State(ServiceName)
{ ; Return Values
; SERVICE_STOPPED (1) : The service is not running.
; SERVICE_START_PENDING (2) : The service is starting.
; SERVICE_STOP_PENDING (3) : The service is stopping.
; SERVICE_RUNNING (4) : The service is running.
; SERVICE_CONTINUE_PENDING (5) : The service continue is pending.
; SERVICE_PAUSE_PENDING (6) : The service pause is pending.
; SERVICE_PAUSED (7) : The service is paused.
    ServiceName := _GetName_(ServiceName)
;msgbox % ServiceName
    SCM_HANDLE := DllCall("advapi32\OpenSCManager"
                        , "Int", 0 ;NULL for local
                        , "Int", 0
                        , "UInt", 0x1) ;SC_MANAGER_CONNECT (0x0001)
                            
    if !(SC_HANDLE := DllCall("advapi32\OpenService"
                            , "UInt", SCM_HANDLE
                            , "Str", ServiceName
                            , "UInt", 0x4)) ;SERVICE_QUERY_STATUS (0x0004)
        result := -4 ;Service Not Found

    VarSetCapacity(SC_STATUS, 28, 0) ;SERVICE_STATUS Struct

    if !result
{
	h := DllCall("advapi32\QueryServiceStatus", "UInt", SC_HANDLE, "UInt", &SC_STATUS)
;msgbox % h " - " ErrorLevel " - " A_LastError
debugbin(SC_STATUS, 28, "456.txt")
        result := !h ? False : NumGet(SC_STATUS, 4, "UInt") ;-1 or dwCurrentState
}

    DllCall("advapi32\CloseServiceHandle", "UInt", SC_HANDLE)
    DllCall("advapi32\CloseServiceHandle", "UInt", SCM_HANDLE)
    return result
}

/*
typedef struct _SERVICE_STATUS {
  DWORD dwServiceType;
  DWORD dwCurrentState;
  DWORD dwControlsAccepted;
  DWORD dwWin32ExitCode;
  DWORD dwServiceSpecificExitCode;
  DWORD dwCheckPoint;
  DWORD dwWaitHint;
} SERVICE_STATUS, *LPSERVICE_STATUS;
*/

Service_Add(ServiceName, BinaryPath, StartType=""){
    if !A_IsAdmin
        Return False

    SCM_HANDLE := DllCall("advapi32\OpenSCManager"
                        , "Int", 0
                        , "Int", 0
                        , "UInt", 0x2) ;SC_MANAGER_CREATE_SERVICE (0x0002)
    
    StartType := !StartType ? 0x3 : 0x2
    ;SERVICE_DEMAND_START(0x00000003) vs SERVICE_AUTO_START(0x00000002)
    
    SC_HANDLE := DllCall("advapi32\CreateService"
                   , "UInt", SCM_HANDLE
                   , "Str", ServiceName
                   , "Str", ServiceName
                   , "UInt", 0xF01FF ;SERVICE_ALL_ACCESS (0xF01FF)
                   , "UInt", 0x110 ;SERVICE_WIN32_OWN_PROCESS(0x00000010) | SERVICE_INTERACTIVE_PROCESS(0x00000100)
    ;interactable service with desktop (requires local account)
    ;http://msdn.microsoft.com/en-us/library/ms683502(VS.85).aspx
                   , "UInt", StartType
                   , "UInt", 0x1 ;SERVICE_ERROR_NORMAL(0x00000001)
                   , "Str", BinaryPath
                   , "Str", "" ;No Group
                   , "UInt", 0 ;No TagId
                   , "Str", "" ;No Dependencies
                   , "Int", 0 ;Use LocalSystem Account
                   , "Str", "")
    result := A_LastError ? SC_HANDLE "," A_LastError : 1
    DllCall("advapi32\CloseServiceHandle", "UInt", SC_HANDLE)
    DllCall("advapi32\CloseServiceHandle", "UInt", SCM_HANDLE)
    Return result
}

Service_Delete(ServiceName)
{
    if !A_IsAdmin ;Requires Administrator rights
        Return False
    ServiceName := _GetName_(ServiceName)    

    SCM_HANDLE := DllCall("advapi32\OpenSCManager"
                        , "Int", 0 ;NULL for local
                        , "Int", 0
                        , "UInt", 0x1) ;SC_MANAGER_CONNECT (0x0001)

    if !(SC_HANDLE := DllCall("advapi32\OpenService"
                            , "UInt", SCM_HANDLE
                            , "Str", ServiceName
                            , "UInt", 0xF01FF)) ;SERVICE_ALL_ACCESS (0xF01FF)
        result := -4 ;Service Not Found

    if !result
        result := DllCall("advapi32\DeleteService", "Uint", SC_HANDLE)

    DllCall("advapi32\CloseServiceHandle", "UInt", SC_HANDLE)
    Return result    
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

/*

BOOL EnumServicesStatusA(
  [in]                SC_HANDLE              hSCManager,
  [in]                DWORD                  dwServiceType,
  [in]                DWORD                  dwServiceState,
  [out, optional]     LPENUM_SERVICE_STATUSA lpServices,
  [in]                DWORD                  cbBufSize,
  [out]               LPDWORD                pcbBytesNeeded,
  [out]               LPDWORD                lpServicesReturned,
  [in, out, optional] LPDWORD                lpResumeHandle
);

[out, optional] lpServices

指向缓冲区的指针，该缓冲区包含 一组ENUM_SERVICE_STATUS 结构，这些结构接收数据库中每个服务的名称和服务状态信息。 缓冲区必须足够大，以便保存结构及其成员指向的字符串。

此数组的最大大小为 256K 字节。 若要确定所需的大小，请为此参数指定 NULL，为 cbBufSize 参数指定 0。 函数将失败， GetLastError 将返回ERROR_INSUFFICIENT_BUFFER。 该“bbytesNeeded”参数将接收所需大小。

Windows Server 2003 和 Windows XP： 此数组的最大大小为 64K 字节。 自 Windows Server 2003 SP1 和 Windows XP SP2 起，此限制已增加。

typedef struct _ENUM_SERVICE_STATUSA {
  LPSTR          lpServiceName;
  LPSTR          lpDisplayName;
  SERVICE_STATUS ServiceStatus;
} ENUM_SERVICE_STATUSA, *LPENUM_SERVICE_STATUSA;

ServiceStatus  结构

typedef struct _SERVICE_STATUS {
  DWORD dwServiceType;
  DWORD dwCurrentState;
  DWORD dwControlsAccepted;
  DWORD dwWin32ExitCode;
  DWORD dwServiceSpecificExitCode;
  DWORD dwCheckPoint;
  DWORD dwWaitHint;
} SERVICE_STATUS, *LPSERVICE_STATUS;
*/

/*
20240417195103.ahk
---------------------------
44308072-8920

44316928    02 a4 39 00
44316842    02 a4 38 aa
44316738
44316692

00000000h: 30 39 A4 02 00 39 A4 02 30 00 00 00 04 00 00 00 ; 09?.9?0.......
00000010h: 81 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ; ?..............
00000020h: 00 00 00 00                                     ; ....

00000024h: EC 38 A4 02 AA 38 A4 02 10 01 00 00 04 00 00 00 ; ????........
00000034h: 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ; ................
00000044h: 00 00 00 00                                     ; ....

00000c18h: 00 23 A4 02 A4 22 A4 02 F0 00 00 00 04 00 00 00 ; .#????......
00000c28h: 01 05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ; ................
00000c38h: 00 00 00 00 57 00 69 00                         ; ....W.i.

00000c10h: 00 00 00 00 00 00 00 00 00 23 A4 02 A4 22 A4 02 ; .........#???
00000c20h: F0 00 00 00 04 00 00 00 01 05 00 00 00 00 00 00 ; ?..............
00000c30h: 00 00 00 00 00 00 00 00 00 00 00 00 57 00 69 00 ; ............W.i.

c3c   3132
*/