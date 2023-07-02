;|2.0|2023.07.01|1312
#SingleInstance force
Windo_ET_PasteAll:
Application := ComObjActive("ket.Application")
for Ocol in Application.Selection.Columns
{
	; Ocol.Column = 15 代表 o 列
	Col_Address := Application.Columns(Ocol.Column).Address  ; 得到 $O:$O 
	Col_Address := StrReplace(Col_Address, "$")
	StringSplit, OpCol_Address, Col_Address, `:

	Col_ColumnWidth := Application.ActiveSheet.Range(OpCol_Address1 1).ColumnWidth

	SheetsCount := Application.ActiveWorkbook.Sheets.Count
	loop % SheetsCount
	{
		SheetName := Application.ActiveWorkbook.Sheets(A_index).Name
		if CF_Isinteger(SheetName)   ; 工作表名为数字
		{
			Application.Sheets(A_index).Range(OpCol_Address1 1).ColumnWidth := Col_ColumnWidth
		}
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