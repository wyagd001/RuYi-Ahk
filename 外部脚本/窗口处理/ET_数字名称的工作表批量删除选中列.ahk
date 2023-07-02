;|2.0|2023.07.01|1319
#SingleInstance force
Windo_ET_PasteAll:
Application := ComObjActive("ket.Application")
Seltect_StartColNum := Application.Selection.Column   ; 选中的起始列号
Seltect_ColCount := Application.Selection.Columns.Count
;msgbox % Seltect_StartColNum " - " Seltect_ColCount
SheetsCount := Application.ActiveWorkbook.Sheets.Count
loop % SheetsCount
{
	Osheet := Application.ActiveWorkbook.Sheets(A_index)
	SheetName := Osheet.Name
	
	if CF_Isinteger(SheetName) && (SheetName != Application.ActiveSheet.Name) ; 工作表名为数字
	{
		loop % Seltect_ColCount  ; 从最右开始删除
		{
			Del_col := Seltect_StartColNum + Seltect_ColCount - A_index
			;MsgBox % Del_col "!" SheetName "!" B_index
			Osheet.Columns(Del_col).Delete
		}
	}
}

loop % Seltect_ColCount
{
	Del_col := Seltect_StartColNum + Seltect_ColCount - A_index
	;MsgBox % Del_col " - " 111
	Application.ActiveSheet.Columns(Del_col).Delete
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