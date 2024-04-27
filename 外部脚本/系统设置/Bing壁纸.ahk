;|2.5|2024.01.22|1327
; 来源网址: https://blog.csdn.net/liuyukuan/article/details/73656922
ComObjError(0)
Today := SubStr(A_Now, 1, 8)
TodayWallpaper := 0
Loop, Files, %A_ScriptDir%\..\..\临时目录\*.jpg, F
{
	if !InStr(A_LoopFileName, "BZ_")
		continue
	FMT := SubStr(A_LoopFileTimeModified, 1, 8)
	
	if (FMT = Today)
	{
		TodayWallpaper := 1
		ToolTip, 今天已经下载过 Bing 壁纸了. 
		break
	}
}
if TodayWallpaper
{
	Sleep 3000
	ExitApp
}
BingWallpapers(imgpath)
;DllCall("SystemParametersInfo", UINT, 20, UINT, uiParam, STR, imgpath, UINT, 2)  ; 重启或注销后失效
; 多显示器情况下会导致所有显示器使用相同的壁纸
setWallpapers(imgpath)  ; 重启后不会失效
return

BingWallpapers(ByRef imgpath := "")
{
	;Winhttp := ComObjCreate("WinHttp.WinHttpRequest.5.1") ; 一些系统可能无法打开 json 文件
	Winhttp := ComObjCreate("Msxml2.XMLHTTP")
	Winhttp.Open("GET", "https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1",true)
	Winhttp.Send()
	Winhttp.WaitForResponse()
	sleep 1200
	r := Winhttp.ResponseText
	;msgbox % r
	if !r
	{
		UrlDownloadToFile, https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1, % A_ScriptDir . "\..\..\临时目录\bing.txt"
		FileRead, r, % A_ScriptDir . "\..\..\临时目录\bing.txt"
	}
	RegExMatch(r, "O)urlbase"":""(.*?)""", Match)
	Bpath := Match.Value(1)
	;RegExMatch(path, "\d*$", fname)
	url := "https://cn.bing.com" . Bpath . "_1920x1080.jpg"
	if !imgpath
	{
		Random, rand, 1, 6
		imgpath := A_ScriptDir . "\..\..\临时目录\BZ_" rand ".jpg"
	}
	imgpath := GetFullPathName(imgpath)
	URLDownloadToFile, % url, % imgpath
		return ErrorLevel
}

setWallpapers(sFile){  
; https://autohotkey.com/board/topic/15533-setwallpaper/  
sOpt  := "STRETCH"  
WPSTYLE_CENTER  := 0  
WPSTYLE_TILE    := 1  
WPSTYLE_STRETCH := 2  
WPSTYLE_MAX     := 3  
AD_APPLY_ALL    := 7  
pad := ComObjCreate("{75048700-EF1F-11D0-9888-006097DEACF9}", "{F490EB00-1240-11D1-9888-006097DEACF9}")  
DllCall(vtable(pad, 7), "Ptr", pad, "int64P", WPSTYLE_%sOpt%<<32|8, "Uint", 0)  ; SetWallpaperOptions  
DllCall(vtable(pad, 5), "Ptr", pad, "WStr", sFile, "Uint", 0)  ; SetWallpaper  
DllCall(vtable(pad, 3), "Ptr", pad, "Uint", AD_APPLY_ALL)  ; ApplyChanges  
ObjRelease(pad)  
return
}

vtable(ptr, n) {
    return NumGet(NumGet(ptr+0), n*A_PtrSize)  
}

GetFullPathName(path) {
    cc := DllCall("GetFullPathName", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
    VarSetCapacity(buf, cc*(A_IsUnicode?2:1))
    DllCall("GetFullPathName", "str", path, "uint", cc, "str", buf, "ptr", 0, "uint")
    return buf
}