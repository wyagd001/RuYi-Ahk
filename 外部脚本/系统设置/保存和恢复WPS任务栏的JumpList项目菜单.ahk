;|2.3|2023.08.30|1444,1445
CandySel := A_Args[1]
SourceFileName := A_AppData "\Microsoft\Windows\Recent\AutomaticDestinations\579438f135536aec.automaticDestinations-ms"

if !CandySel
{
	if instr(A_OSVersion, "10.")   ; Win 10
		BackFileName := A_ScriptDir "\..\..\临时目录\WPS\579438f135536aec-WIN_10_" SubStr(A_Now, 1, 8) ".automaticDestinations-ms"
	else                           ; Win 7
		BackFileName := A_ScriptDir "\..\..\临时目录\WPS\579438f135536aec-" A_OSVersion "_" SubStr(A_Now, 1, 8) ".automaticDestinations-ms"
	FileDelete, % BackFileName                  ; 删除今天的备份文件, 如果有
	if !FileExist(A_ScriptDir "\..\..\临时目录\WPS")
		FileCreateDir, % A_ScriptDir "\..\..\临时目录\WPS"
	FileCopy, %SourceFileName%, %BackFileName%
	Var := A_Now
	EnvAdd, Var, -7, days
	DelFileName := StrReplace(BackFileName, SubStr(A_Now, 1, 8), SubStr(Var, 1, 8))
	FileDelete, % DelFileName                  ; 删除 7 天前的备份文件, 如果有
	return
}
else if (CandySel="restore")
{
	Loop, Files, % A_ScriptDir "\..\..\临时目录\WPS\*.automaticDestinations-ms"
	{
		menu, RS_WPSJumpList, Add, % A_LoopFileName, Restore
	}
	menu, RS_WPSJumpList, Show
}
return

Restore:
RSFileName := A_ScriptDir "\..\..\临时目录\WPS\" A_ThisMenuItem
FileCopy, %RSFileName%, %SourceFileName%, 1
return

/*
openfolder:
Gui, Submit, NoHide
SplitPath, filepath, , folderpath
run % "explorer.exe /select," filepath
return
*/