;|2.8|2024.10.28|1403
#SingleInstance force
CandySel := A_Args[1]
param := A_Args[2]

if !CandySel or (StrLen(CandySel) > 2 && !param) or (CandySel = "Gui")
{
  DLL := "D:E:F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:"
  DriveGet, DGOPV, List
  Array := StrSplit(DGOPV)
  for k, v In Array
  {
    ;msgbox % k "|" v
    DLL := StrReplace(DLL, v ":")
  }
   DLL := StrReplace(DLL, ":", ":|")

  ;MsgBox, % DriveMap.Add(param, CandySel)

  ;MsgBox, % (Share := DriveMap.Get("p:")) . " - " . ErrorLevel
  ;MsgBox, % DriveMap.Del("p:")
  ;MsgBox, % DriveMap.Add("p:", Share)
  Gui, add, text, x5 y5, 文件夹:
  Gui, add, Edit, x120 y5 w300 h20 vfolder, %CandySel%

  Gui, add, text, x5 y35, 虚拟盘符:
  Gui, add, ComboBox, x120 y35 w300 h120 vxunipanfu ggetxunifolder, %Dll%

  Gui, add, text, x5 y+10, 模式:
  Gui, add, ComboBox, x120 y65 w300 h60 vmode gchangemode, 挂载||卸载
  Gui, add, button, x430 yp w60 h20 gruncom, 执行

  Gui, show,, 挂载文件夹为虚拟磁盘
  GuiControl, ChooseString, xunipanfu, % param
  Return
}
if (StrLen(CandySel) = 2) or (StrLen(CandySel) = 3)   ; 选中盘符
{
  CandySel := trim(CandySel, """")  ; 会在末尾有个 ' " ', "K:\"  转义成了 ' K:" '  参数中路径 \ 应改为 \\
  devname := QueryDosDevice(CandySel)[1]
  if (InStr(devname, "\??\") = 1)
  {
    DefineDosDevice(CandySel)
  }
  else
    msgbox, 磁盘 %CandySel% 不是文件夹挂载的虚拟磁盘, 程序退出
  ExitApp
}
else if (StrLen(CandySel) > 2) && param
{
  if !InStr(param, ":")
    param := param ":"
  if InStr(FileExist(CandySel), "D") or InStr(CandySel, "\Device\HarddiskVolume")
    DefineDosDevice(param, CandySel)
  ExitApp
}
Return

runcom:
gui Submit, Nohide
if (mode = "卸载")
{
  if (InStr(folder, "\??\") = 1)
  {
    DefineDosDevice(xunipanfu)
  }
  else
    msgbox, 磁盘 %xunipanfu% 不是文件夹挂载的虚拟磁盘, 不会卸载该盘符
}
else if (mode = "挂载")
{
  DefineDosDevice(xunipanfu, folder)
}
return

getxunifolder:
gui Submit, Nohide
if (mode = "卸载")
{
  devname := QueryDosDevice(xunipanfu)[1]
  GuiControl,, folder, % devname
}
return

changemode:
gui Submit, Nohide
if (mode = "卸载")
{
  DriveGet, DGOPV, List
  Array := StrSplit(DGOPV)
  for k, v In Array
  {
    ;msgbox % k "|" v
    DGOPV := StrReplace(DGOPV, v, v ":|")
  }
  GuiControl, , xunipanfu, |%DGOPV%
  ;msgbox % DLL
}
else if (mode = "挂载")
{
  DLL := "D:E:F:G:H:I:J:K:L:M:N:O:P:Q:R:S:T:U:V:W:X:Y:Z:"
  DriveGet, DGOPV, List
  Array := StrSplit(DGOPV)
  for k, v In Array
  {
    ;msgbox % k "|" v
    DLL := StrReplace(DLL, v ":")
  }
  DLL := StrReplace(DLL, ":", ":|")
  GuiControl, , xunipanfu, |%DLL%
}
return

guiclose:
Gui, Destroy
ExitApp

/*
q::
;DefineDosDevice("N:")
;DefineDosDevice("N:","Z:")
*/

/*
https://learn.microsoft.com/zh-cn/windows/win32/api/fileapi/nf-fileapi-definedosdevicew?redirectedfrom=MSDN

; DefineDosDevice 定义、重新定义或删除 MS-DOS 设备名称.

所做的更改重启后都会恢复
所做的更改重启后都会恢复
所做的更改重启后都会恢复

; 运行 DefineDosDevice("J:")  
; 卸载真实的磁盘后, 我的电脑中无法显示 J:(被删除了), 磁盘管理中会出现问题, 有卷标但没有驱动号, 并且无法更改驱动号
; 使用 DefineDosDevice("J:", "\Device\HarddiskVolume9") 能在我的电脑中恢复显示, 但磁盘管理中仍有问题无法正常
; DefineDosDevice("Volume{600451AA-0000-0000-0000-9000AC000000}")  我的电脑中正常访问, 但是磁盘管理中卷标都会无法正常显示
; DefineDosDevice("Volume{600451AA-0000-0000-0000-9000AC000000}", "\Device\HarddiskVolume9")

; 以上所有不正常的问题, 重启后都会恢复

flags: DllCall 调用的第一个参数
DDD_EXACT_MATCH_ON_REMOVE
0x00000004
如果此值与 DDD_REMOVE_DEFINITION一起指定，则函数将使用完全匹配来确定要删除的映射。 使用此值可确保不会删除未定义的内容。
DDD_NO_BROADCAST_SYSTEM
0x00000008
不要广播 WM_SETTINGCHANGE 消息。 默认情况下，将广播此消息以通知 shell 和应用程序更改。
DDD_RAW_TARGET_PATH
0x00000001
按原样使用 lpTargetPath 字符串。 否则，它将从 MS-DOS 路径转换为路径。(例如 \Device\HarddiskVolume10 自动转为 C:\Device\HarddiskVolume10)
DDD_REMOVE_DEFINITION
0x00000002
删除指定设备的指定定义。 为了确定要删除的定义，该函数将遍览设备的映射列表，根据与此设备关联的每个映射的前缀查找 lpTargetPath 的匹配项。 匹配的第一个映射是删除的映射，然后函数返回。
如果 lpTargetPath 为 NULL 或指向 NULL 字符串的指针，则该函数将删除与设备关联的第一个映射，并弹出推送的最新映射。 如果没有任何内容可弹出，则将删除设备名称。

如果未指定此值， 则 lpTargetPath 参数指向的字符串将成为此设备的新映射。
sPath 字符串是 MS-DOS 路径字符串，除非指定 了DDD_RAW_TARGET_PATH 标志，在这种情况下，此字符串是路径字符串。

参数
sPath:  文件夹路径 如 C:\Test 或 \Device\HarddiskVolume1\Test
返回值:  失败时为 0, 成功时, 非 0 值.
*/
DefineDosDevice(sDevice, sPath = "")
{
	sDevice := RTrim(sDevice, " \")
	sPath := RTrim(sPath, " \")
	flags := sPath ? (InStr(sPath, ":") ? 0 : 1) : 1|2
	;msgbox % flags
	Return DllCall("DefineDosDevice", "Uint", flags, "str", sDevice, "str", sPath)
}

; https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-querydosdevicew
; Retrieves information about the specified MS-DOS device.
; 成功时返回数组
; 参数可以为  C:, Volume{600451AA-0000-0000-0000-9000AC000000}, 或空字符串
; 返回值: 字符串数组     \Device\HarddiskVolume1, 
QueryDosDevice(sDevice = "")
{
	sDevice := RTrim(sDevice, " \")
	sDevice := LTrim(sDevice, "?\")
;msgbox % sDevice
	size := sDevice ? 520 : 32768
	VarSetCapacity(sPath, size, 0)
	hSize := DllCall("QueryDosDevice", sDevice ? "Str" : "Ptr", sDevice ? sDevice : 0, "Str", sPath, "Uint", size)
	Name := "", List := [], Ptr := &sPath

	;msgbox % hSize " - " ErrorLevel " - " A_LastError
	;FileName := A_Desktop "\456.txt"
	;file := FileOpen(FileName, "rw")
	;File.RawWrite(&sPath, 256)
	;File.Close()

; Size the number of bytes comprising the formatted return Value.
;   on whether PATHS/PATH contain Unicode characters. It CAN happen that
;   calling QueryDosDeviceW("E:") returns "25: \Device\Harddiskvolume3" and
;   calling QueryDosDeviceW("V:") returns "34: \??\E:\bin\apps" because the
;   \??\ prefix implies a Unicode string.

	if !hSize && Errorlevel  
	return 0
	while StrLen(Name := StrGet(Ptr))
	{
		;msgbox % Ptr " - " Name " - " StrPut(Name, "UTF-16")
		List.Push(Name) , Ptr := Ptr+StrPut(Name, "UTF-16")*2
	}
	Return List   ; 返回数组
}