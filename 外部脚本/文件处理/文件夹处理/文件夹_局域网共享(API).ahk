;|3.0|2025.08.20|1725
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?style=19&t=4655
CandySel := A_Args[1]
if !CF_IsFolder(CandySel)
  Exitapp
SplitPath, CandySel, ShareName

; 创建没有共享权限设置的完全控制的共享 
NET_API_STATUS_SUCCESS := 0
STYPE_DISKTREE := 0x00000000  ; 磁盘共享类型
; ==============================================
; 1. 计算结构体大小（关键！必须与系统位数匹配）
; ==============================================
; 每个指针成员（LPTSTR）在32位系统占4字节，64位占8字节
; DWORD成员固定占4字节
; 总大小 = 4个指针*指针大小 + 4个DWORD*4字节
PtrSize := A_PtrSize  ; 32位=4, 64位=8
StructSize := (4 * PtrSize) + (4 * 4)  ; 正确的大小计算

; 分配精确大小的内存（关键！避免内存溢出）
VarSetCapacity(SHARE_INFO_2, StructSize, 0)

; ==============================================
; 2. 填充结构体成员（按官方顺序，类型严格匹配）
; ==============================================
; [0] 共享名称（LPTSTR = 字符串指针）
NumPut(&ShareName, SHARE_INFO_2, 0 * PtrSize, "Ptr")

; [1] 共享类型（DWORD = 4字节无符号整数）
; 类型说明：0x80000000=隐藏共享，0x00000000=磁盘共享
STYPE_DISKTREE := 0x00000000
NumPut(STYPE_DISKTREE, SHARE_INFO_2, 1 * PtrSize, "UInt")

; [2] 备注（LPTSTR = 字符串指针）
ShareRemark := "AHk 创建的共享文件夹"
NumPut(&ShareRemark, SHARE_INFO_2, 2 * PtrSize, "Ptr")

; [3] 权限（DWORD = 已保留，必须为0）
NumPut(0, SHARE_INFO_2, 3 * PtrSize, "UInt")

; [4] 最大用户数（DWORD）
MaxUsers := 25
NumPut(MaxUsers, SHARE_INFO_2, 3 * PtrSize + 4, "UInt")

; [5] 当前用户数（DWORD，输出参数，填0即可）
NumPut(0, SHARE_INFO_2, 3 * PtrSize + 8, "UInt")

; [6] 本地路径（LPTSTR = 字符串指针）
NumPut(&CandySel, SHARE_INFO_2, 4 * PtrSize + 8, "Ptr")

; [7] 密码（LPTSTR，通常为NULL，即0）
NumPut(0, SHARE_INFO_2, 5 * PtrSize + 8, "Ptr")

; 3. 调用NetShareAdd API（必须以管理员权限运行）
; 函数原型：NET_API_STATUS NetShareAdd(LPCWSTR servername, DWORD level, LPBYTE buf, LPDWORD parm_err);
DllCall("netapi32.dll\NetShareAdd", "Ptr", 0, "UInt", 2, "Ptr", &SHARE_INFO_2, "UIntP", 0)

; 释放NetAPI资源（避免内存泄漏）
DllCall("netapi32.dll\NetApiBufferFree", "Ptr", &SHARE_INFO_2)

SetSecurityFile(CandySel, "S-1-1-0", "2032127", "3")  ; 安全 everyone 完全控制
return

; ComObjError(false)
; S-1-1-0   everyone
; AccessMask: 2032127 = FULL | 1179817 = READ | 1179958 = WRITE | 1245631 = CHANGE
; Flags: 0 = This folder only | 1 = This folder and files | 2 = This folder and subfolders | 3 = This folder, subfolders and files 
SetSecurityFile(File, Trustee, AccessMask, Flags)
{
	;dacl := ComObjCreate("AccessControlList")
	;sd := ComObjCreate("SecurityDescriptor")
	newAce := ComObjCreate("AccessControlEntry")
	sdutil := ComObjCreate("ADsSecurityUtility")
	sd := sdUtil.GetSecurityDescriptor(File, 1, 1)
	dacl := sd.DiscretionaryAcl
	newAce.Trustee := Trustee
	newAce.AccessMask := AccessMask
	newAce.AceFlags := Flags
	newAce.AceType := 0
	dacl.AddAce(newAce)
	sdutil.SetSecurityDescriptor(File, 1, sd, 1)
	Return A_LastError
}