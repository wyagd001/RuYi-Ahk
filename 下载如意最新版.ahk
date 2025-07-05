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
  IZip_File := A_ScriptDir "\临时目录\内置动作.zip"  ; gitee 判定 内置动作.ini 有违规内容, 只好压缩为zip文件了
  如一exeFile := A_ScriptDir "\临时目录\" 如一exe
  AnyToAhkexeFile := A_ScriptDir "\临时目录\" AnyToAhkexe
  IniFile := A_ScriptDir "\临时目录\内置动作.ini"

  包_目录 := A_ScriptDir
  解包_目录 := A_ScriptDir "\配置文件"
  内置动作文件 := A_ScriptDir "\配置文件\内置动作.ini"

	FileDelete, % 如一exeFile
	FileDelete, % AnyToAhkexeFile
  FileDelete, % H_File
  FileDelete, % IniFile

	UrlDownloadToFile, https://gitee.com/wyagd001/RuYi-Ahk/raw/main/%如一exe%, %如一exeFile%
  sleep 150
	UrlDownloadToFile, https://gitee.com/wyagd001/RuYi-Ahk/raw/main/%AnyToAhkexe%, %AnyToAhkexeFile%
  sleep 150
	UrlDownloadToFile, https://gitee.com/wyagd001/RuYi-Ahk/raw/main/配置文件/内置动作.ini, %IniFile%
  sleep 150
  UrlDownloadToFile, https://gitee.com/wyagd001/RuYi-Ahk/raw/main/引用程序/其它资源/帮助页面.zip, %H_File%
	sleep 150

  FileReadLine, FirstText, %IniFile%, 1
  if InStr(FirstText, "[action]")
  {
    FileCopy, %内置动作文件%, % A_ScriptDir "\配置文件\内置动作.ini.bak", 1
    FileMove, % IniFile, % 内置动作文件, 1
  }
  else
  {
    FileDelete, % IniFile
    UrlDownloadToFile, https://gitee.com/wyagd001/RuYi-Ahk/raw/main/配置文件/内置动作.zip, %IZip_File%
    FileGetSize, OutputVar, % IZip_File, K
    if (OutputVar > 20)
    {
      FileCopy, %内置动作文件%, % A_ScriptDir "\配置文件\内置动作.ini.bak", 1
      Run, %7ZG% x "%IZip_File%" -aoa -o"%解包_目录%"
    }
  }

  FileGetSize, OutputVar, % H_File, K
  if (OutputVar > 100)
    Run, %7ZG% x "%H_File%" -aoa -o"%包_目录%"
  sleep 600
  FileGetSize, OutputVar, % 如一exeFile, K
  if (OutputVar > 400)
    run "%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\更新程序.ahk" "%如一exe%"
}