;|2.6|2024.04.28|1585
; 来源网址: https://www.autohotkey.com/board/topic/54220-how-to-change-netbios-computer-name/

InputBox, NewComputerName, 修改计算机名, 当前计算机名为: %A_ComputerName%`n`n请输入新计算机名称:, , , 170
if ErrorLevel
	exitapp
else
{
	regwrite, reg_sz, HKLM\System\CurrentControlSet\Control\ComputerName\ActiveComputerName, ComputerName, %NewComputerName%
	regwrite, reg_sz, HKLM\System\CurrentControlSet\Control\ComputerName\ComputerName, ComputerName, %NewComputerName%
	regwrite, reg_sz, HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters, NV Hostname, %NewComputerName%
	regwrite, reg_sz, HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters, Hostname, %NewComputerName%
	;SetComputerName(NewComputerName)
}
return

SetComputerName(ComputerName)
{
    if (StrLen(ComputerName) > 31)
        return "ComputerName is too long (max 31 chars)"
    if !(DllCall("SetComputerName", "Str", ComputerName))
        return "Error in SetComputerName: " A_LastError
    return true
}

; DllCall("GetComputerName", "Str", ComputerName, "uint", 128)
; wmic ComputerSystem where "name='%ComputerName%'" call rename "New-Computer-Name"
; wmic computersystem where Name="%COMPUTERNAME%" call JoinDomainOrWorkgroup Name="%work1%"

/*
计算机\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters

下面把电脑名改为“计算机名”为例，复制以下内容另存为.reg 文件双击导入注册表即可（重启电脑生效）
Windows Registry Editor Version 5.00
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\ComputerName]
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\ComputerName\ComputerName]
"ComputerName"="计算机名"
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\ComputerName\ActiveComputerName]
"ComputerName"="计算机名"
[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\Tcpip\Parameters]
"NV Hostname"="计算机名"
"Hostname"="计算机名"
*/