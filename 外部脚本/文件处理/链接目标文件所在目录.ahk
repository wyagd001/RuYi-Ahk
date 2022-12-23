CandySel := A_Args[1]
FileGetShortcut, %CandySel%, CandySel_LinkTarget
run, % "explorer.exe /select," CandySel_LinkTarget
Return