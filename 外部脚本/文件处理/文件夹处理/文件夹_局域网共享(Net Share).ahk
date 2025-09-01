;|3.0|2025.08.16|1725
CandySel := A_Args[1]
if !CF_IsFolder(CandySel)
  Exitapp
SplitPath, CandySel, ShareName

; 共享并设置共享权限
RunWait, %ComSpec% /c net share %ShareName%=%CandySel% /GRANT:Everyone`,FULL,, Hide
; 设置 NTFS 权限
RunWait, %ComSpec% /c icacls "%CandySel%" /grant Everyone:(OI)(CI)F /T,, Hide
;msgbox %ComSpec% /c net share %ShareName%=%FolderPath% /GRANT:Everyone`,FULL
Return