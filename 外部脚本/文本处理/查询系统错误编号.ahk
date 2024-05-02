;|2.6|2024.05.01|1587
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=28&t=108312
CandySel := A_Args[1]
Run % A_ScriptDir "\..\..\引用程序\x32\MSWinErr.exe"
sleep 400
send % CandySel
return