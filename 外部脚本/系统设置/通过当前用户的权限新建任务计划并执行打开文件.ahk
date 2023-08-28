;|2.3|2023.08.24|1431
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
	if !CandySel
		exitapp
}

TaskUser(CandySel)
return

;来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=76&t=102099&sid=534fb169b1592e1f5891eff35eeb4f73&start=20
TaskUser(hfile)
{
	;This will add a task schedule as a standard user and run the program when Ahk is running as a admin.

	; this is the exe name as a title
	SplitPath, hfile, Target, Path

 	Title=%Target% 										

	; now remove the .exe from the title
	Title:= SubStr(Title,1,InStr(Title, .)-1)

	; this get the last user login
	RegRead, LastLogon, HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI, LastLoggedOnUser

	; this edits the last user logging removing the .
	stringtrimleft,last,LastLogon,1

	; this get the computers name
	RegRead, Mechine, HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName, ComputerName

	; Now to put the user id togeather
	UserID = %Mechine%%last%
	
	; this creates the task
	RunWait, %A_WinDir%\System32\schtasks.exe /CREATE /TN %Title% /TR %Path%\%Target% /sc ONCE /RU %UserID% /st 00:00 ,,hide
	
	; This will Run the task
	RunWait, %A_WinDir%\System32\schtasks.exe /Run /TN %Title% ,,hide
	
	;This will remove the task
	Run, %A_WinDir%\System32\schtasks.exe /Delete /TN %Title% /f ,,hide

	; Clears the varbs
	Target=
	Path=
	UserID=
	Title=
	LastLogon=
	Mechine=
}
