;|3.0|2025.07.15|1720
; 将剪贴板内容粘贴到选中文件（如果文本文件有内容则先删除）
; Run|"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\粘贴到选中文件.ahk" "%CandySel%"
CandySel := A_Args[1]
FileGetSize, OutputVar, % CandySel
if OutputVar > 0
  FileRecycle, % CandySel

FileAppend, % Clipboard, % CandySel, UTF-8
return
