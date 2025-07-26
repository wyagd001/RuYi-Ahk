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
  IZip_File := A_ScriptDir "\临时目录\内置动作.zip"
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

	githubdownload(如一exe)
  sleep 150
	githubdownload(AnyToAhkexeFile)
  sleep 150
	githubdownload("配置文件\内置动作.ini")
  sleep 150
  githubdownload("引用程序\其它资源\帮助页面.zip")
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
    githubdownload("配置文件\内置动作.zip")
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

githubdownload(sfilename)
{
  proxy := ["https://gh.h233.eu.org/", "https://ghproxy.1888866.xyz/", "https://gh.ddlc.top/", "https://slink.ltd/", "https://gh-proxy.com/", "https://hub.gitmirror.com/", "https://down.sciproxy.com/", "https://gh-proxy.net/", "https://github.moeyy.xyz/"]
	SplitPath, sfilename, OutFileName
	websfilename := StrReplace(sfilename, "\", "/")
	Tmp_File := A_ScriptDir "\临时目录\" OutFileName
  return_Val := 0
		loop, 9
		{
			UrlDownloadToFile, % proxy[A_index] "https://raw.githubusercontent.com/wyagd001/RuYi-Ahk/main/" websfilename, %Tmp_File%
			if ErrorLevel
			{
				continue
			}
			else
			{
        FileGetSize, OutputVar, % Tmp_File, K
        if (OutputVar>20)   ; 大于20k视为下载成功
        {
            return_Val := 1
            break
        }
				else
        {
          FileDelete % Tmp_File
					continue
        }
			}
    }
		if (return_Val = 0)
			return 0   ; 发生错误直接返回 0
}