;|2.0|2023.07.01|1120
CandySel :=  A_Args[1]
if !CandySel
	exitapp
; 复制文字或图片后,在资源管理器窗口和桌面，
; 将复制的内容保存为文件
剪贴板到文件:
PasteToPath(CandySel)
return

PasteToPath(path)
{
    if !CF_IsFolder(path)
        return
    path := RegExReplace(path, "([^\\])$", "$1\")
    if DllCall("IsClipboardFormatAvailable", "Uint",1) or DllCall("IsClipboardFormatAvailable", "Uint",13) {
        paste_type := "文本文件"
    } else if DllCall("IsClipboardFormatAvailable", "Uint",2) {
        paste_type := "图片文件"
        pToken := Gdip_Startup()
    } else {
        return
    }
    
    clip := (paste_type == "文本文件" ? clipboard : Gdip_CreateBitmapFromClipboard())
    default_name := ""
    Loop {
        InputBox, filename, 保存复制内容到%paste_type%, 输入文件名:,, 360, 135,,,,, % default_name
        if ErrorLevel
            break
        filename := Trim(filename, OmitChars := " `t")
        if !IsFileName(filename) {
            MsgBox, 0x10, 无效文件名, 请输入有效的文件名!
            default_name := filename
            continue
        }
        if !InStr(filename, ".")
            filename := filename . (paste_type == "文本文件" ? ".txt" : ".png")
        fullname := path . filename
        default_name := filename
        if FileExist(fullname) and !(InStr(FileExist(fullname), "R") or CF_IsFolder(fullname)) {
            MsgBox, 0x134, 文件或文件夹已存在, 文件或文件夹 %filename% 已存在，是否替换?
            IfMsgBox, No
                continue
            try {
                FileDelete, %fullname%
                if (paste_type == "文本文件") {
                    FileAppend, %clip%, %fullname%, CP936
                } else {
                    SaveImage(clip, fullname)
                }
            } catch {
                MsgBox, 0x10, 创建文件失败, 可能您没有相应的权限?
            }
            break
        } else if FileExist(fullname) {
            MsgBox, 0x30, 文件或文件夹已存在, 文件或文件夹 '%filename%' 已存在，请重新命名。
            continue
        } else {
            try {
                if (paste_type == "文本文件") {
                    FileAppend, %clip%, %fullname%, CP936
                } else {
                    SaveImage(clip, fullname)
                }
            } catch {
                MsgBox, 0x10, 创建文件失败, 可能您没有相应的权限?
            }
            break
        }
    }
    if pToken
    Gdip_Shutdown(pToken)
}

SaveImage(pBitmap, filename)
{
    Gdip_SaveBitmapToFile(pBitmap, filename, Quality:=100)
    Gdip_DisposeImage(pBitmap)
}

IsFileName(filename)
{
    filename := Trim(filename, OmitChars := " `t")
    if !filename
        return false
    if filename in CON,PRN,AUX,NUL,COM1,COM2,COM3,COM4,COM5,COM6,COM7,COM8,COM9,LPT1,LPT2,LPT3,LPT4,LPT5,LPT6,LPT7,LPT8,LPT9
        return false
    if filename contains <,>,:,`",/,\,|,?,*
        return false
    return true
}

CF_IsFolder(sfile){
	if InStr(FileExist(sfile), "D")
	|| (sfile = """::{20D04FE0-3AEA-1069-A2D8-08002B30309D}""")
	;|| (SubStr(sfile, 1, 2) = "\\")   ; 局域网共享文件夹 如 \\Win11\Soft
		return 1
	else
		return 0
}