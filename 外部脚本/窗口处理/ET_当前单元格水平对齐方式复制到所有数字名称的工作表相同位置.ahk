;|2.0|2023.07.01|1308
#SingleInstance force
Windo_ET_PasteAll:
Application := ComObjActive("ket.Application")
ActiveCell := Application.ActiveCell.Address   ; $A$1  当前活动单元格
ActiveCell := StrReplace(ActiveCell, "$")      ; A1
ActiveCell_HorizontalAlignment := Application.ActiveSheet.Range(ActiveCell).HorizontalAlignment

SheetsCount := Application.ActiveWorkbook.Sheets.Count
loop % SheetsCount
{
	SheetName := Application.ActiveWorkbook.Sheets(A_index).Name
	if CF_Isinteger(SheetName)   ; 工作表名为数字
	{
		Application.Sheets(A_index).Range(ActiveCell).HorizontalAlignment := ActiveCell_HorizontalAlignment
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