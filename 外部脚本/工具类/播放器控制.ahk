;|2.1|2023.07.21|13xx
CandySel := A_Args[1]
if (CandySel = "/prev")
	gosub play_prev
else if (CandySel = "/pause")
	gosub play_pause
else if (CandySel = "/next")
	gosub play_next
else if (CandySel = "/close")
	gosub play_close
Return

activeplayer(){
	global foobar2000
	DetectHiddenWindows On
	SetTitleMatchMode 2
	If WinExist(" - AhkPlayer")
		return "AhkPlayer"
	else if (foo := ProcessExist("foobar2000.exe"))
	{
		WinGet, foobar2000, ProcessPath, ahk_pid %foo%
		;msgbox % foobar2000
		return "foobar2000"
	}
	else if ProcessExist("iTunes.exe")
		return "iTunes"
	else if ProcessExist("Wmplayer.exe")
		return "Wmplayer"
	else if ProcessExist("TTPlayer.exe")
		return "TTPlayer"
	else if ProcessExist("Winamp.exe")
		return "Winamp"
}

ProcessExist(Name){
	Process, Exist, %Name%
	return Errorlevel
}

play_prev:
activeplayer := activeplayer()
If (activeplayer = "AhkPlayer")
	Send, ^+{F3}
If (activeplayer = "foobar2000")
	Run %foobar2000% /prev,, UseErrorLevel
If (activeplayer="wmplayer")
	postMessage 0x111, 18810,,, ahk_class WMPlayerApp
If (activeplayer = "Winamp")
	postMessage 0x111, 40044,,, ahk_class Winamp v1.x
If (activeplayer = "ttplayer")
	postMessage 0x111, 0x7d05 ,,, ahk_class TTPlayer_PlayerWnd
If (activeplayer ="itunes")
	ControlSend, ahk_parent, ^{left}, iTunes ahk_class iTunes
Return

play_pause:
activeplayer := activeplayer()
If (activeplayer="AhkPlayer")
	Send, ^+P
If (activeplayer = "foobar2000")
	Run %foobar2000% /playpause,, UseErrorLevel
If (activeplayer = "wmplayer")
	SendMessage 0x111, 18808, , ,ahk_class WMPlayerApp
If (activeplayer = "Winamp")
	postMessage 0x111, 40046,,, ahk_class Winamp v1.x
If (activeplayer = "ttplayer")
	postMessage 0x111, 0x7d00,,, ahk_class TTPlayer_PlayerWnd
If (activeplayer="itunes")
	ControlSend, ahk_parent, {space}, iTunes ahk_class iTunes
Return

play_next:
activeplayer := activeplayer()
;msgbox % foobar2000
If (activeplayer = "AhkPlayer")
	Send, ^+{F5}
If (activeplayer = "foobar2000")
	Run %foobar2000% /next,, UseErrorLevel
If (activeplayer = "wmplayer")
	SendMessage 0x111,18811, , , ahk_class WMPlayerApp
If (activeplayer = "Winamp")
	postMessage 0x111, 40048 ,,, ahk_class Winamp v1.x
If (activeplayer ="ttplayer")
	postMessage 0x111, 0x7d06,,, ahk_class TTPlayer_PlayerWnd
If (activeplayer = "itunes")
	ControlSend, ahk_parent, ^{right}, iTunes ahk_class iTunes
Return

play_close:
activeplayer := activeplayer()
If (activeplayer="AhkPlayer")
	Send, ^+E
If (activeplayer="foobar2000")
	Run %foobar2000% /quit,, UseErrorLevel
If (activeplayer = "wmplayer")
	SendMessage 0x111, 57665, , , ahk_class WMPlayerApp
If (activeplayer = "Winamp")
	postMessage 0x111, 40001 ,,, ahk_class Winamp v1.x
If (activeplayer = "ttplayer")
	postMessage 0x0010, 0,,, ahk_class TTPlayer_PlayerWnd
If (activeplayer="itunes")
	Process, Close, itunes.exe
Return