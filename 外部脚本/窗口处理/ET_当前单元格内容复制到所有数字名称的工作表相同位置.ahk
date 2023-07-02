;|2.0|2023.07.01|1308
#SingleInstance force
Windo_ET_PasteAll:
Application := ComObjActive("ket.Application")
ActiveCell := Application.ActiveCell.Address   ; $A$1  当前活动单元格
ActiveCell := StrReplace(ActiveCell, "$")      ; A1
HasFormula := Application.ActiveSheet.Range(ActiveCell).HasFormula  ; 当前单元格是否有公式
ActiveCell_NumberFormat := Application.ActiveSheet.Range(ActiveCell).NumberFormat
if !HasFormula
	ActiveCellValue := Application.ActiveSheet.Range(ActiveCell).Value
else
	ActiveCellValue := Application.ActiveSheet.Range(ActiveCell).Formula

SheetsCount := Application.ActiveWorkbook.Sheets.Count
loop % SheetsCount
{
	SheetName := Application.ActiveWorkbook.Sheets(A_index).Name
	if CF_Isinteger(SheetName)   ; 工作表名为数字时进行复制
	{
		Application.Sheets(A_index).Range(ActiveCell).Value := ActiveCellValue
		Application.Sheets(A_index).Range(ActiveCell).NumberFormatLocal := ActiveCell_NumberFormat
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