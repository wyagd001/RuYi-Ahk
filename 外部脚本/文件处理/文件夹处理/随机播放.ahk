;|2.4|2023.10.30|1529
#NoEnv
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}
;msgbox % CandySel
if instr(CandySel, ",")
	MusicFolderArr := StrSplit(CandySel, ",")
else
	MusicFolderArr := [CandySel]

while !i
{
	Random, folderInd, 1, MusicFolderArr.Length()
	i := RandomFile(MusicFolderArr[folderInd])
}

PlayMusic(i)
ExecSendToRuyi("1529",, 1526)
Sleep 600
ExecSendToRuyi("1529||FF0000",, 1525)
onmessage(0x3B9, "ContinuePlay")
OnExit, _exit
return

_exit:
ExecSendToRuyi("1529",, 1526)
ExitApp

ContinuePlay(w,l,msg,hwnd)
{
	global MusicFolderArr
	while !i
	{
		Random, folderInd, 1,  MusicFolderArr.Length()
		i := RandomFile(MusicFolderArr[folderInd])
	}
	PlayMusic(i)
}

PlayMusic(file)
{
	command := "open  """  file """"
	h := DllCall("Winmm\mciSendString", "Str", command, "uint", NULL, "uint", 0, "uint", NULL) ;加载
	if ErrorLevel
	{
		;msgbox % h " - " ErrorLevel " - " A_LastError
		FileAppend(h " - " ErrorLevel " - " A_LastError "`n")
	}
	command1 := "play """ file """ notify"
	;MsgBox % command1
	; " wait"  加上 wait 脚本卡住, 不再响应, 直到播放完毕
	h := DllCall("Winmm\mciSendString", "Str", command1, "uint", NULL, "uint", 0, "uint", A_ScriptHwnd)
	if ErrorLevel
	{
		;msgbox % h " - " ErrorLevel " - " A_LastError
		FileAppend(h " - " ErrorLevel " - " A_LastError "`n")
	}
	return
}

RandomFile(path)  ; 文件夹随机次数平均, 对于文件夹中文件数量比较多的文件夹随机到的次数会减少
{
	if !path
		return "空"
	static B_index := 0
	B_index ++
	if (B_index >= 10)
	{
		B_index = 0
		return 0
	}
	FirstF := path
	objShell := ComObjCreate("Shell.Application")
	if InStr(FileExist(path), "D")
	{
		objFolder := objShell.NameSpace(path)   
		;objFolderItem := objFolder.Self
	}
	else
	{
		SplitPath, path, name, dir
		FileAppend(dir " " B_index "`n")
		if (dir != FirstF)
			objFolder := objShell.NameSpace(dir)
	}
	Random, item, 1, objFolder.Items.Count
	r1 := objFolder.Items.Item(item-1).path
	;msgbox % r1 " aaaa"
	if InStr(FileExist(r1), "D")
	{
		return RandomFile(r1)
	}
	else
	{
		SplitPath, r1,,, ext
		if (ext = "MP3") or (ext = "wma") or (ext ="m4a")
		{
			return r1
		}
		else
		{
			return RandomFile(r1)  ; 某个文件夹下就没有 音频文件 造成无限循环
		}
	}
}

; Comm: Pause, Stop, Resume, Close, Status, seek, 简单版本的 MCI 执行一些不需要返回值的命令
MCICommand(comm, file)
{
	command := comm " """ file """" 
	DllCall("Winmm\mciSendString", "Str", command, "uint", NULL, "uint", 0, "uint",NULL)
	return
}

ExecSendToRuyi(ByRef StringToSend := "", Title := "如一 ahk_class AutoHotkey", wParam := 0, Msg := 0x4a) {
	VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
	SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
	NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)
	NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)

	DetectHiddenWindows, On
	if Title is integer
	{
		SendMessage, Msg, wParam, &CopyDataStruct,, ahk_id %Title%
		;msgbox % ErrorLevel  "qq"
	}
	else if Title is not integer
	{
		SetTitleMatchMode 2
		sendMessage, Msg, wParam, &CopyDataStruct,, %Title%
	}
	DetectHiddenWindows, Off
	return ErrorLevel
}