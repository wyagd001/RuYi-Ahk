;|2.2|2023.08.01|1332
Random, rand, 1, 5
imgpath := A_ScriptDir . "\..\..\临时目录\BZ_" rand ".jpg"
imgpath := GetFullPathName(imgpath)
if !fileexist(imgpath)
{
	Random, rand, 1, 5
	imgpath := A_ScriptDir . "\临时目录\BZ_" rand ".jpg"
}
;msgbox %  imgpath

; 多显示器情况下会导致所有显示器使用相同的壁纸
;DllCall("SystemParametersInfo", UINT, 20, UINT, uiParam, STR, imgpath, UINT, 2)  ; 重启或注销后失效
if fileexist(imgpath)
	setWallpapers(imgpath)  ; 重启后不会失效
return

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