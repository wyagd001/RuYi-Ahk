;|2.9|2025.04.06|1699
WeChatFolder := A_MyDocuments "\WeChat Files"
F_Arr := [], F_Ind := 1
Loop, Files, %WeChatFolder%\*.*, D
{
  if fileexist(WeChatDownloadFolder := WeChatFolder "\" A_LoopFileName "\FileStorage\File")
  {
    if !CF_FolderOnlyOneFolder(WeChatDownloadFolder)
    {
      F_Arr[F_Ind++] := WeChatDownloadFolder "|" A_LoopFileName
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
  if fileexist(dpath "\" A_YYYY "-" A_MM)
    run % dpath "\" A_YYYY "-" A_MM
  else
    run % dpath
  ;msgbox % F_Arr[1]
}
else
{
  loop Files, D:\*, D
  {
    ;msgbox % A_LoopFileFullPath
    if fileexist(A_LoopFileFullPath "\WeChat Files")
    {
      WeChatFolder := A_LoopFileFullPath "\WeChat Files"
      ;msgbox % WeChatFolder
      Loop, Files, %WeChatFolder%\*.*, D
      {
        if fileexist(WeChatDownloadFolder := WeChatFolder "\" A_LoopFileName "\FileStorage\File")
        {
          if !CF_FolderOnlyOneFolder(WeChatDownloadFolder)
          {
            F_Arr[F_Ind++] := WeChatDownloadFolder "|" A_LoopFileName
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
        if fileexist(dpath "\" A_YYYY "-" A_MM)
          run % dpath "\" A_YYYY "-" A_MM
        else
          run % dpath
        ;msgbox % F_Arr[1]
      }
    break
    }
  }
}
return

CF_FolderOnlyOneFolder(sfolder)
{
  Loop, Files, %sfolder%\*.*, D
  {
    R_Index := A_Index
    if (A_Index = 2)
      return 0
  }
  if (R_Index = 1)
    return 1
}

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

GetStringIndex(String, Index := "", MaxParts := -1, SplitStr := "|")
{
	arrCandy_Cmd_Str := StrSplit(String, SplitStr, " `t", MaxParts)
	if Index
	{
		NewStr := arrCandy_Cmd_Str[Index]
		return NewStr
	}
	else
		return arrCandy_Cmd_Str
}

MenuHandler:
dpath := GetStringIndex(F_Arr[A_ThisMenuItemPos], 1)
if fileexist(dpath "\" A_YYYY "-" A_MM)
  run % dpath "\" A_YYYY "-" A_MM
else
  run % dpath
;msgbox % dpath
;run %dpath%,, UseErrorLevel
return