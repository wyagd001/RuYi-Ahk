;|3.0|2025.08.16|1728
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?style=19&t=4655
CandySel := A_Args[1]
if !CF_IsFolder(CandySel)
  Exitapp
SplitPath, CandySel, ShareName
; 创建 everyone 只读的共享 
ComObjGet( "winmgmts:Win32_Share" ).Create(CandySel, ShareName, 0, 25, "AHk 创建的共享文件夹" )
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