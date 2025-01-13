updateexe()

updateexe()
{
	B_Autohotkey := A_ScriptDir "\引用程序\" (A_PtrSize = 8 ? "AutoHotkeyU64.exe" : "AutoHotkeyU32.exe")
	if (A_PtrSize = 8)
	{
		如一exe := "如一.exe"
		AnyToAhkexe := "AnyToAhk.exe"
	}
	else
	{
		如一exe := "如一_x32.exe"
		AnyToAhkexe := "AnyToAhk_x32.exe"
	}
  7ZG := A_ScriptDir "\引用程序\x32\7zG.exe"
  H_File := A_ScriptDir "\临时目录\帮助页面.zip"
  包_目录 := A_ScriptDir
  如一exeFile := A_ScriptDir "\临时目录\" 如一exe
  AnyToAhkexeFile := A_ScriptDir "\临时目录\" AnyToAhkexe

	FileDelete, % 如一exeFile
	FileDelete, % AnyToAhkexeFile
  FileDelete, % H_File
	UrlDownloadToFile, https://gitee.com/wyagd001/RuYi-Ahk/raw/main/%如一exe%, %如一exeFile%
  sleep 150
	UrlDownloadToFile, https://gitee.com/wyagd001/RuYi-Ahk/raw/main/%AnyToAhkexe%, %AnyToAhkexeFile%
  sleep 150
	UrlDownloadToFile, https://gitee.com/wyagd001/RuYi-Ahk/raw/main/配置文件/内置动作.ini, %A_ScriptDir%\临时目录\内置动作.ini
  sleep 150
  UrlDownloadToFile, https://gitee.com/wyagd001/RuYi-Ahk/raw/main/引用程序/其它资源/帮助页面.zip, %H_File%
	sleep 150
	FileMove, % A_ScriptDir "\临时目录\内置动作.ini", % A_ScriptDir "\配置文件\内置动作.ini", 1
  FileGetSize, OutputVar, % H_File, K
  if (OutputVar > 100)
    Run, %7ZG% x "%H_File%" -aoa -o"%包_目录%"
  sleep 600
	run "%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\更新程序.ahk" "%如一exe%"
}