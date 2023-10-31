;|2.4|2023.10.03|1518
#SingleInstance force
CandySel := A_Args[1]

SplitPath, CandySel, CandySel_FileName, CandySel_ParentPath, CandySel_Ext, CandySel_FileNameNoExt, CandySel_Drive
Process, Close, % CandySel_FileName
Return