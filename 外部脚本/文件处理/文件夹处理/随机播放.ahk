;|2.9|2024.12.21|1529
#NoEnv
#SingleInstance Ignore
CandySel := A_Args[1]
LrcPath := "F:\Program Files\foobar2000\lyrics"
LrcPath_2 := "D:\Program Files\foobar2000\lyrics"
hidelrc := 0
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

Gui, 2: +LastFound +alwaysontop -Caption +Owner -SysMenu
Gui, 2:Margin, 0
Gui, 2:Color, FF0F0F
Gui, 2:Font, s24,msyh    ;Gui, 2:Font, s24 bold
Gui, 2:add, Text, w1000 r1.9 c%Lrcfontcolor% vlrc,
posy:=A_ScreenHeight-130
WinSet, TransColor, FF0F0F
WinSet, ExStyle, +0x20
Gui, 2:Show, Hide x150 y%posy%

if i
{
  PlayMusic(i)
  gosub Lrc
  settimer, changeIcon, -3000
  onmessage(0x3B9, "ContinuePlay")
  OnExit, _exit
}
return

_exit:
ExecSendToRuyi("1529",, 1526)
ExitApp

changeIcon:
ExecSendToRuyi("1529",, 1526)    ; 按钮颜色还原
Sleep 600
ExecSendToRuyi("1529||FF0000",, 1525)   ; 设置颜色
return

ContinuePlay(w, l, msg, hwnd)
{
	global MusicFolderArr, i
  i := ""
	while !i
	{
		Random, folderInd, 1,  MusicFolderArr.Length()
		i := RandomFile(MusicFolderArr[folderInd])
	}
  if i
  {
    PlayMusic(i)
    gosub Lrc
  }
}

PlayMusic(file)
{
  ;command := "open """ file """"  ; 无别名
  DllCall("Winmm\mciSendString", "Str", "close myfile", "uint", NULL, "uint", 0, "uint", NULL)
	command := "open """ file """ alias myfile"
	h := DllCall("Winmm\mciSendString", "Str", command, "uint", NULL, "uint", 0, "uint", NULL) ; 加载
	if ErrorLevel or h
	{
		;msgbox % h " - " ErrorLevel " - " A_LastError
		CF_FileAppend(h " - " ErrorLevel " - " A_LastError " - " file "`n")
	}
  ;msgbox % command " | " h
	;command1 := "play """ file """ notify"  ; 无别名
  command1 := "play myfile notify"
	;MsgBox % command1
	; " wait"  加上 wait 脚本卡住, 不再响应, 直到播放完毕
	hSound := DllCall("Winmm\mciSendString", "Str", command1, "uint", NULL, "uint", 0, "uint", A_ScriptHwnd)
	if ErrorLevel
	{
		;msgbox % h " - " ErrorLevel " - " A_LastError
		CF_FileAppend(h " - " ErrorLevel " - " A_LastError "`n")
	}
	return hSound
}

!N::
DllCall("Winmm\mciSendString", "Str", "stop myfile", "uint", NULL, "uint", 0, "uint", NULL)
DllCall("Winmm\mciSendString", "Str", "close myfile", "uint", NULL, "uint", 0, "uint", NULL)
;DllCall("Winmm\mciSendString", "Str", "seek myfile to end", "uint", NULL, "uint", 0, "uint", NULL)
/*
	Random, folderInd, 1, MusicFolderArr.Length()
	i := RandomFile(MusicFolderArr[folderInd])
  if i
  {
    PlayMusic(i)
    gosub Lrc
  }
*/
return

RandomFile(hpath)  ; 文件夹随机次数平均, 对于文件夹中文件数量比较多的文件夹随机到的次数会减少
{
	if !hpath
		return 0
	static B_index := 0
	B_index ++
	if (B_index >= 10)
	{
		B_index = 0
		return 0
	}
	FirstF := hpath
	objShell := ComObjCreate("Shell.Application")
	if InStr(FileExist(hpath), "D")
	{
		objFolder := objShell.NameSpace(hpath)   
		;objFolderItem := objFolder.Self
	}
	else
	{
		SplitPath, hpath, name, dir
    ;msgbox % hpath
		CF_FileAppend(dir " " B_index "`n")
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

LrcShow:
	if (hidelrc=1)
	{
		hidelrc=0
		;IniWrite, 1, %A_ScriptDir%\tmp\setting.ini, AhkPlayer, ToolMode
		Gui,2:show
	}
	Else if (hidelrc=0)
	{
		hidelrc=1
		Gui,2:Hide
	}
	Else if (hidelrc=2)
	{
		hidelrc=0
		Gui,2:Hide
	}
Return

Lrc:
	lrcclear()
	SetTimer, clock, Off
	newname := ""
	SplitPath, i,,, ext, name
  ;tooltip % i "|" ext "|" name
	If FileExist(LrcPath "\" name ".lrc")
	{
    ;msgbox
		lrcECHO(LrcPath . "\" . name . ".lrc", name)
    Return
	}
	else If FileExist(LrcPath_2 "\" name ".lrc")
	{
		lrcECHO(LrcPath_2 . "\" . name . ".lrc", name)
    Return
	}
	Else
	{
		newname:=StrReplace(name, " - ", "-",,1)
		If FileExist(LrcPath "\" newname ".lrc")
		{
			lrcECHO(LrcPath . "\" . newname . ".lrc", name)
      Return
		}
		else If FileExist(LrcPath_2 "\" newname ".lrc")
		{
			lrcECHO(LrcPath_2 . "\" . newname . ".lrc", name)
      Return
		}
		Else
		{
			newname:=""
			Gui, 2:+LastFound
			GuiControl, 2:, lrc,%name%(歌词欠奉)
			SetTimer, hidenolrc, -6500
			Gui, 2:Show, NoActivate, %name% - AhkPlayer
      Return
		}
	}
Return

hidenolrc:
	Gui, 2:hide
Return

lrcPause(x)
{
	global
	Stime:=starttime
	If x=0
		SetTimer, lrcpause, Off
	Else
		SetTimer, lrcpause, 100
Return

lrcpause:
	passedtime:=A_TickCount-Pausetime
	starttime:=Stime+passedtime
Return
}

lrcECHO(lrcfile, GuiTitle){
	global
	Gui, 2:+LastFound
	;WinSet, TransColor, FF0F0F
	;WinSet, ExStyle, +0x20
	if hidelrc=0
		Gui, 2:Show, NoActivate, %GuiTitle% - AhkPlayer  ; 不激活窗体避免改变当前激活的窗口

	FileEncoding, % File_GetEncoding(lrcfile)

	; 读取lrc文件的内容
	n:=1
	temp:=1
	Loop, read, %lrcfile%
	{
		temp:=1
		Loop
		{
			temp:=InStr(A_LoopReadLine, "[","", temp)
			If (temp<>0)
			{
				IfInString,A_LoopReadLine,][
				{
					temp:=temp+1
					time%n%:=SubStr(A_LoopReadLine, temp, 8)
					sec%n%:=60*SubStr(time%n%, 1, 2)+SubStr(time%n%, 4, 5)
					If sec%n% is not Number
						Break
					lrc%n%:=SubStr(A_LoopReadLine, InStr(A_LoopReadLine,"]","",0)+1)
					n:=n+1
					continue
				}
				else
				{
					temp:=temp+1
					time%n%:=SubStr(A_LoopReadLine, temp, 8)
					sec%n%:=60*SubStr(time%n%, 1, 2)+SubStr(time%n%, 4, 5)
					If sec%n% is not Number
						sec%n%:=60*SubStr(time%n%, 1, 2)+SubStr(time%n%, 4, 2)
					If sec%n% is not Number
							Break
					lrc%n%:=SubStr(A_LoopReadLine, InStr(A_LoopReadLine,"]","",1)+1)
					lrc%n%:= RegExReplace(lrc%n%, "\[[0-9]+\:[0-9]+\.[0-9]+\]")
					; 原代码从右到左查找“]”，找到后从“]”位置+1，开始复制（复制全部）
					; lrc%n%:=SubStr(A_LoopReadLine, InStr(A_LoopReadLine,"]","",0)+1)
					n:=n+1
					; 原代码 continue  ,同一行查找多次,对[xxx][xxx]xxx格式有效  对[xxx]x[xxx]x[xxx]格式无效
					; continue
					Break
				}
			}
			Else
				Break
		}
	}

; 对时间戳进行排序
	Loop
	{
		n:=1
		flag:=0
		Loop
		{
			nx:=n+1
			If(sec%n% > sec%nx%) And (sec%nx%<>"")
			{
				flag+=1
				; 交换sec数据    实际可以只用一个变量做中介即可  不过 此处不影响程序执行的效率.
				tz:=sec%n%
				tx:=sec%nx%
				sec%n%:=tx
				sec%nx%:=tz
				; 交换lrc数据
				tz:=lrc%n%
				tx:=lrc%nx%
				lrc%n%:=tx
				lrc%nx%:=tz
			}
			n:=n+1
			If(sec%nx%="")	;如果下一个元素为空，则退出循环
				Break
		}
		If(flag=0)
			Break
	}

	t:=1
	GuiControl, 2:, lrc, % lrc%t%
	lrcpos := lrcpos?lrcpos:0
	starttime := A_TickCount - lrcpos
	lrcpos = 0
	maxsec:=n-1
	FileEncoding, CP1200
	SetTimer, clock, 50
	Return

	clock:
	nowtime := (A_TickCount - starttime)/1000
	min := floor(nowtime/60)
	SetFormat, Float, 5.2
	sec := nowtime - min*60

	tx:=t+1
	/*原版代码
	If ( (min*60+sec) >= sec%t% and (min*60+sec) <= sec%tx% )
	{
		GuiControl, 2:, lrc, % lrc%t%
		t := t+1
		If (t > n)
		t := 1
	}
	*/
	If ( (min*60+sec) >= sec%t% and (min*60+sec) <= sec%tx% )
	GuiControl, 2:, lrc, % lrc%t%

	If ( (min*60+sec) >= sec%t% )
	{
		t := t+1
		If (t > n)
			t := 1
	}

	loop
	{
		If ( (min*60+sec) >= sec%maxsec%)
			break
		If ( (min*60+sec) >= sec%t%)
			t := t+1
		else
			break
		If (t > n)
			t := 1
	}
Return
}

lrcClear(){
	global
	count:=1
	SetTimer, lrcpause, Off
	Loop, 99			;清空变量
	{
		min%count%:=""
		sec%count%:=""
		lrc%count%:=""
		count+=1
	}
}