; 1318
#SingleInstance force
Windo_ET_PasteAll:
Application := ComObjActive("ket.Application")
Seltect_StartColNum := Application.Selection.Column   ; 选中的起始列号
Seltect_ColCount := Application.Selection.Columns.Count
InsertColNum := Seltect_StartColNum + Seltect_ColCount   ; 选中的结束列号 + 1 (即要插入的列号)
;MsgBox % InsertColNum
SheetsCount := Application.ActiveWorkbook.Sheets.Count
loop % SheetsCount
{
	SheetName := Application.ActiveWorkbook.Sheets(A_index).Name
	if CF_Isinteger(SheetName)   ; 工作表名为数字
	{
		Application.Sheets(A_index).Columns(InsertColNum).Insert
	}
}

Application:=""
return

CF_Isinteger(ByRef hNumber){
	if hNumber is integer
	{
		hNumber := Round(hNumber)
		return true
	}
}