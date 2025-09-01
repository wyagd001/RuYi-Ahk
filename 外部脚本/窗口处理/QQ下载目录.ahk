;|2.9|2025.01.04|1700
#Include <Ruyi>
QQFolder := A_MyDocuments "\Tencent Files"
F_Arr := [], F_Ind := 1
Loop, Files, %QQFolder%\*.*, D
{
  if fileexist(QQDownloadFolder := QQFolder "\" A_LoopFileName "\FileRecv")
  {
    if !CF_FolderIsEmpty(QQDownloadFolder)
    {
      F_Arr[F_Ind++] := QQDownloadFolder
    }
  }
}
if (F_Arr.Length() > 1)
{
  show_obj(F_Arr)
}
else if (F_Arr.Length() = 1)
{
  dpath := GetStringIndex(F_Arr[1], 1)
  run % dpath
  ;msgbox % F_Arr[1]
}
return

show_obj(obj, menu_name := "")
{
	if menu_name =
	{
		main = 1
		Random, rand, 100000000, 999999999
		menu_name = %A_Now%%rand%
	}
	Menu, % menu_name, add,
	Menu, % menu_name, DeleteAll
	for k,v in obj
	{
		Menu, % menu_name, add, % GetStringIndex(v, 2), MenuHandler
	}
	if main = 1
		menu, % menu_name, show
	return
}

MenuHandler:
dpath := GetStringIndex(F_Arr[A_ThisMenuItemPos], 1)
run % dpath
;msgbox % dpath
;run %dpath%,, UseErrorLevel
return