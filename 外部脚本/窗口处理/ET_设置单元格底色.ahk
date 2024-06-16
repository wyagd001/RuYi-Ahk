;|2.5|2023.07.01|1539
#SingleInstance force
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e77f.ico"

ket := ComObjActive("Ket.Application")
if OnOff := !OnOff
{
	ket.Selection.Interior.Colorindex := 6 
}
else
{
	ket.Selection.Interior.Colorindex :=  0
}
ket :=""
return