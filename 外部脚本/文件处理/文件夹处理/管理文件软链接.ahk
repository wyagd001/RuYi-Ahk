; 1309
CandySel := A_Args[1]
if !CandySel
{
	DetectHiddenWindows, On
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_ 
	DetectHiddenWindows, Off
}

ScriptName = Symlink
Version = 1.0 
#SingleInstance force 
#NoEnv
SetBatchLines -1
;~ SetTitleMatchMode,3
ComObjError(false)  
SymLink:={}
SymFilter:={}
LinkCountAll:=0
LinkCountCurrent:=0
Btn源文件位置_TT := "点击打开路径"
Btn链接路径为_TT := "点击打开路径"
Gui, 1:+Resize +MinSize +LastFound +Delimiter`n
Gui1HWND := WinExist()
Gui,Font,s11,Yahei Consolas Hybrid
Gui,1:Add,button,section h26, 搜索文件夹: 
Gui,1:Add,button,xs h26 vBtn源文件位置 gOpenEdt源文件路径, 源文件位置: 
Gui,1:Add,button,xs h26 vBtn链接路径为 gOpenEdt链接路径为, 链接路径为:
Gui,1:Add,Edit,ys+1 x+1 h24 w260 vSearchFolder, %CandySel%
Gui,1:Add,button,ys x+1 h26 vsearchbt gStartS, 搜索
Gui,1:Add,Edit,y+9 x+-308 h24 w310 vEdt源文件路径 readonly,
Gui,1:Add,Edit,y+10 xp w310 h24 vEdt链接路径为 readonly,
Gui,Font,s11 norm
Gui,Font,s11 bold
Gui,1:Add,Text,cF00200 xs vTxt项目 Section, 链接类型:
Gui,Font,s10 norm italic
Gui,1:Add,Edit,y+-23 x+5 w90 vEdt项目,
Gui,Font,norm s11 bold
Gui,1:Add,Text,ys x+12 vTxt名称, 文件名: 
Gui,Font,s10 norm italic
Gui,1:Add,Edit,y+-23 x+5 w100  vEdt名称,

Gui,Font,s10 norm 
Gui,1:Add,ListView,xs w409 -LV0x10 cblue Grid AltSubmit Backgroundffd282 vLVTSymlink gSymlinkLVT  hwndhwndLVTSymlink,类型`n文件名`n文件类型`n链接路径`n源文件路径
Menu, 打开目录, Add, 链接文件目录, MyContextMenu
Menu, 打开目录, Add, 源文件目录, MyContextMenu
Menu, MyContextMenu, Add, 打开目录, :打开目录
Menu, 复制路径, Add, 链接文件路径, MyContextMenu
Menu, 复制路径, Add, 源文件路径, MyContextMenu
Menu, MyContextMenu, Add, 复制路径,:复制路径
Menu, MyContextMenu, Add        
DriveGet, DriveList, List,Fixed        
Loop, Parse,DriveList
    n.=A_LoopField . ":,"
StringTrimRight, DriveList, n, 1
Menu, MyComputer, Add,本地磁盘(%DriveList%), LoopComputer
Loop, Parse,DriveList,`,
{
    DriveGet, n,Label,%A_LoopField%
    Menu, MyComputer, Add, %n% (%A_LoopField%), LoopComputer
}
Menu, MyContextMenu, Add, 搜索, :MyComputer
       
Menu, MyContextMenu, Add, 删除, MyContextMenu
Menu, tray, NoStandard
Menu, Tray, Tip, Symlink链接工具 
Menu, tray, add, 主界面, 主界面
Menu, tray, add, 重启, ReLoad
Menu, tray, add
Menu, tray, add, 退出, GuiClose
Menu, Tray, Default, 主界面
Menu, Tray, Click, 1    ;}
    
Guicontrol,focus,LVTSymlink
Gui, 1:Show, Hide, %ScriptName% v%Version%    【Link : %LinkCountAll%】
Gui, 1:Show       

if !CandySel {
	ToolTip, 没有指定搜索文件夹！ `n可以选择磁盘搜索:, 330, 195
	menu, MyComputer, show, 30, 175
	ToolTip
}
Else
	Gosub StartS

OnMessage(0x201, "WM_LBUTTONDown")
OnMessage(0x200, "WM_MOUSEMOVE")
Return

;---函数
WM_LBUTTONDOWN(){
	static OldGuiControl
	;~ Gui,submit,nohide
	if InStr(A_GuiControl, "Edt") && (A_GuiControl <> OldGuiControl)
	{
		GuiControl, Focus, %A_GuiControl%
		Send, ^a
		OldGuiControl := A_GuiControl
		return 1
	}
	OldGuiControl := A_GuiControl
	return 
}

WM_MOUSEMOVE(){
	static CurrControl, PrevControl, _TT  ; _TT 保持为空以便用于下面的 ToolTip 命令.
	CurrControl := A_GuiControl
	;~ tooltip,%a_guicontrol%
	If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
	{
		ToolTip  ; 关闭之前的工具提示.
		SetTimer, DisplayToolTip, 1000
		PrevControl := CurrControl
	}
	return
	
	DisplayToolTip:
	SetTimer, DisplayToolTip, Off
	try 
	{
		ToolTip % %CurrControl%_TT  ; 前导的百分号表示要使用表达式.
	}
	SetTimer, RemoveToolTip, 3000
	return
	
	RemoveToolTip:
	SetTimer, RemoveToolTip, Off
	ToolTip
	return
}

;---子程序
LoopComputer:
IfInString, A_ThisMenuItem,本地磁盘
	SearchFolder := DriveList
else
	SearchFolder := RegExReplace(A_ThisMenuItem, ".*\((.:)\)", "$1")
GuiControl,, SearchFolder, %SearchFolder%
StartS:
LV_Delete()
Gui, submit, nohide
LV_Addn:=0  ;计算添加数量
ToolTip
IconNum:=0
GuiControl, -Redraw, LVTSymlink
;~ FlashTrayIcon()
Settimer, FlashTrayIcon, 500
TrayTip,, 疯狂搜索中...`n请稍候!
Gui, 1:Show,, %ScriptName% v%Version%    【Link : %LinkCountAll%】    疯狂搜索中！　`n请稍候...
SearchFolder := RegExReplace(SearchFolder, "\\$", "")     ; 删除最后的"\"号
;msgbox % SearchFolder
Loop, parse, SearchFolder, `,
{
	RunWait, %comspec% /c dir "%A_LoopField%\*.*" /al /s > %A_Temp%\Symlink.txt,,Hide
	Sleep,100
	FileRead, Symlinktxt, %A_Temp%\Symlink.txt 
	Loop, parse, Symlinktxt, `n, `r, %A_Space%
	{
		;MsgBox,=%A_LoopField%=
		If A_Index=1    ;判断中文系统/英文系统
				StrReplaceDIR:=InStr(A_LoopField, "驱动器") ? " 的目录":"Directory of "
		else If A_Index>3   ;第四行开始读起
		{
			StringReplace, str, A_LoopField, %StrReplaceDIR%       ;取得链接上一级目录
			If !ErrorLevel
				SymlnkDIR:=SubStr(str, 0,1)="\" ? str : str . "\"      ;补充"\"
			else if RegExMatch(A_LoopField, "i)<(.+?)>.*?\s([^\s].+)\s\[(.+?)\]", m)
			{       ;m1---类型    m2---文件名    m3---源文件目录
				n:=0
				For Key,val in SymLink
				{
					for k,v in val
					{
						;~ ToolTip,%k%
						if (k=SymlnkDIR . m2)      ;链接文件目录已存在!
						{
								n:=1
								Break
						}
					}
				}
				if n=0
				{
					LV_Addn+=1
					LV_Add("Select",m1,m2,m1,SymlnkDIR . m2,m3)
					Symlink[m1,SymlnkDIR . m2]:=[m2,m1,m3]
				}
			}
		}
	}
}
LV_ModifyCol() 
GuiControl, +Redraw, LVTSymlink
GUICONTROL, focus, LVTSymlink
SoundPlay, *64
TrayTip,, 搜索完毕`n发现: %LV_Addn%个软链接        
Settimer, FlashTrayIcon, Off   
LinkCountAll += LV_Addn  
Gui, 1:Show,, %ScriptName% v%Version%    【Link : %LinkCountAll% ﹢〈搜索到%LV_Addn%个〉】
Gosub, submenu
Return

GuiContextMenu:
if A_GUICONTROL=LVTSymlink
{
	menu,MyContextMenu,show
	Return
}
return

项目筛选:
    Menu,项目筛选,ToggleCheck,%A_ThisMenuItem%
    ;~ MsgBox,% SymFilter[A_ThisMenuItem]
    if SymFilter[A_ThisMenuItem]=1
    {
        SymFilter[A_ThisMenuItem]:=""
        IniDelete,%inifile%,Symbolic Filter,%A_ThisMenuItem%
    }
    Else
    {
        SymFilter[A_ThisMenuItem]:=1
        IniWrite,1,%inifile%,Symbolic Filter,%A_ThisMenuItem%
    }
    Key:=A_ThisMenuItem
项目筛选_:
    GuiControl, -Redraw,LVTSymlink
    if SymFilter[Key]=1
    {
        RowNumber = 1  ; 这会使得首次循环从顶部开始搜索.
        Loop
        {
            LV_GetText(RetrievedText, RowNumber,1)
            if (RetrievedText=Key)
                LV_Delete(RowNumber)    ; 从 ListView 中删除行.
            else
            {
                RowNumber+=1
                if (RowNumber>=LV_GetCount())
                    break
            }
        }
    }
    else
    {
        for k,v in Symlink[Key]
        {
            for k1,v1 in v
                var%k1%:=v1
            Str:=(!FileExist(k) || !FileExist(var3)) ? "Select" : ""       ;检查空链接
            LV_Add(Str,Key,var1,var2,k,var3)
        }
    } 
    GuiControl, +Redraw,LVTSymlink
return

MyContextMenu:
	If A_ThisMenuItem=链接文件目录   
	{                
		LV_GetText(OutputVar4, LV_GetNext(0, "Focused"),4)
		Run,explorer.exe /select`, %OutputVar4%
		Return
	}
	Else If A_ThisMenuItem=源文件目录   
	{   
		LV_GetText(OutputVar5, LV_GetNext(0, "Focused"),5)
		Run,explorer.exe /select`, %OutputVar5%
		Return
	}
	Else If A_ThisMenuItem=链接文件路径   
	{                
		LV_GetText(OutputVar4, LV_GetNext(0, "Focused"),4)
		Clipboard:=OutputVar4
		TrayTip,,已复制
		Return
	}
	Else If A_ThisMenuItem=源文件路径   
	{                
		LV_GetText(OutputVar5, LV_GetNext(0, "Focused"),5)
		Clipboard:=OutputVar5
		TrayTip,,已复制
		Return
	}
	Else If A_ThisMenuItem=删除
	{
		if LV_GetCount("Selected")>1
		{
			Loop % LV_GetCount()
				LV_Modify(A_Index, "-Select")
			Return
		}
		LV_GetText(OutputVar1, LV_GetNext(0, "Focused"),1)
		LV_GetText(OutputVar4, LV_GetNext(0, "Focused"),4)
		MsgBox,1,Symlink文件链接删除,
		(    
			链接目录: %OutputVar4%
			源文件目录: %OutputVar5%
			-----确定要删除该链接吗?-----
		)
		IfMsgBox, OK
		{
			if FileExist(OutputVar4)="D"
					FileRemoveDir,%OutputVar4%,1
			else
					FileDelete,%OutputVar4%
			LV_Delete(LV_GetNext(0, "Focused"))
			Symlink[OutputVar1].Remove(OutputVar4)
		}
		Return
	}
return

Reload:
    Reload

_ToolTip:
    ToolTip
Return

主界面:
    Gui, 1:Show
return   

FlashTrayIcon:  ;闪烁图标   ;{
IconNum:=!IconNum
if IconNum
    Menu, Tray, Icon, SHELL32.dll, 50
else
    Menu, Tray, Icon, *
Return

SubMenu:
if SymLink._NewEnum().next()      ;判断是否空数组
{
    for key,val in SymLink
    {
        Menu, 项目筛选, Add,%key%, 项目筛选
        IF SymFilter[key]=1
            Menu, 项目筛选, UnCheck,%key%
        else
            Menu, 项目筛选, Check,%key%
    }
    Menu, MyContextMenu, Add, 项目筛选, :项目筛选
}
Return

;~ ------Gui 子程序
SymlinkLVT:
Gui, 1:Submit, NoHide  
if (A_GuiEvent = "Normal") or (A_GuiEvent = "DoubleClick")
{
        ;~ MsgBox,% A_EventInfo
    if A_EventInfo
    {
        ;~ MsgBox, % LV_GetCount()
        ;~ tooltip,% A_EventInfo
        Loop % LV_GetCount("Column")
            LV_GetText(LVTSymlink%A_Index%, A_EventInfo, A_Index)
;         LV_GetText(LVTSymlink2, A_EventInfo, 2)
;         LV_GetText(LVTSymlink3, A_EventInfo, 3)
;         LV_GetText(LVTSymlink4, A_EventInfo, 4)
        GuiControl,,Edt链接路径为,%LVTSymlink4%
        GuiControl,,Edt源文件路径,%LVTSymlink5%
        GuiControl,,Edt项目,%LVTSymlink1%
        GuiControl,,Edt名称,%LVTSymlink2%            
        ;~ MsgBox,%LVTSymlink1%
        ;~ Symlink[FocusedColumn1,FocusedColumn4] := Symlink[Edt项目].Remove(FocusedColumn4)
    }
    Return
}
Return

OpenEdt源文件路径:
Gui,submit,nohide
if FileExist(Edt源文件路径)
{
	Run,explorer.exe /select`, %Edt源文件路径%
	;MsgBox % Edt源文件路径
}
Return

OpenEdt链接路径为:
Gui,submit,nohide
if FileExist(Edt链接路径为)
{
	Run,explorer.exe /select`, %Edt链接路径为%
	;MsgBox % Edt链接路径为
}
Return

GuiSize:
  Anchor("LVTSourceDir","w")
  Anchor("LVTTargetDir","w")
  Anchor("LVTSymlink","wh")
  Anchor("SearchFolder","w")
  Anchor("Edt名称","w")
  Anchor("Edt源文件路径","w")
  Anchor("Edt链接路径为","w")
  Anchor("searchbt","x")
Return

GuiClose:
Gui, 1:Submit, NoHide
Gui,Cancel
ExitApp
Return

;---函数
; 检查文件是否是软链接
Symlink(filepath, ByRef target="", ByRef filename="", ByRef filetype="") {
	if RegExMatch(filepath,"^\w:\\?$") ;returns 0 if it is a root directory
		return 0
	SplitPath, filepath, filename, pdir
	dhw := A_DetectHiddenWindows
	DetectHiddenWindows On
	Run "%ComSpec%" /k,, Hide, pid
	while !(hConsole := WinExist("ahk_pid" pid))
		Sleep 10
	DllCall("AttachConsole", "UInt", pid)
	DetectHiddenWindows %dhw%
	objShell := ComObjCreate("WScript.Shell")
	objExec := objShell.Exec(comspec " /c dir /al """ (InStr(FileExist(filepath),"D") ? pdir "\" : filepath) """")
	While !objExec.Status
		Sleep 100
	cmd_result := objExec.StdOut.ReadAll()
	DllCall("FreeConsole")
	Process Exist, %pid%
	if (ErrorLevel == pid)
		Process Close, %pid%
	if RegExMatch(cmd_result,"<(.+?)>.*?\b(" filename ")\b.*?\[(.+?)\]",m)
	{
		filename:=m2,filetype:=m1, target:=m3
	;~ MsgBox,%filename%=%filetype%=
	;~ if (filetype="SYMLINK")
		;~ filetype := "File"
	;~ else if (filetype="SYMLINKD")
		;~ filetype := "Directory"
		return 1
	}
	else
		return 0
}

FlashTrayIcon(ms_loop = 500, s_stop = 0) {      ; 功能: 闪烁托盘图标
    static defaultIcon, blankIcon
; 参数:
;   ms_loop - 闪烁间隔（毫秒）。如果为 0，则停止闪烁。
;   s_stop  - 多少秒后停止闪烁
    defaultIcon := A_IconFile ? A_IconFile : A_IsCompiled ? A_ScriptFullPath : A_AhkPath

    SetTimer, __FlashTrayIcon_Timer, % ms_loop ? ms_loop : "Off"
    SetTimer, __FlashTrayIcon_StopTimer, % s_stop ? (s_stop * 1000) : "Off"
    Return
    
    __FlashTrayIcon_Timer:
        blankIcon := !blankIcon
        
        If blankIcon
            Menu, Tray, Icon, SHELL32.dll, 50
        Else
            Menu, Tray, Icon, % defaultIcon
    Return
    
    __FlashTrayIcon_StopTimer:
        SetTimer, __FlashTrayIcon_Timer, Off
        Menu, Tray, Icon, % defaultIcon
    Return
}

EM_GETSEL(HWND, ByRef Start, ByRef End) {	;--取得光标位置; Start  -  receives the start of the current selection
; End    -  receives the end of the current selection
; ======================================================================================================================
   ; EM_GETSEL = 0x00B0 -> msdn.microsoft.com/en-us/library/bb761598(v=vs.85).aspx
   Start := End := 0
   DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", 0x00B0, "UIntP", Start, "UIntP", End, "Ptr")
   Start++, End++
   Return True
}

EM_SETSEL(HWND, Start, End) {
; ======================================================================================================================
; Selects a range of characters in an edit control.
; Start  -  the character index of the start of the selection.
; End    -  the character index of the end of the selection.
; ======================================================================================================================
   ; EM_SETSEL = 0x00B1 -> msdn.microsoft.com/en-us/library/bb761661(v=vs.85).aspx
   Return DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", 0x00B1, "Ptr", Start - 1, "Ptr", End - 1, "Ptr")
}

Anchor(c, a, r = false) { ; v3.5.1 - Titan
	static d
	GuiControlGet, p, Pos, %c%
	If !A_Gui or ErrorLevel
		Return
	i = x.w.y.h./.7.%A_GuiWidth%.%A_GuiHeight%.`n%A_Gui%:%c%=
	StringSplit, i, i, .
	d .= (n := !InStr(d, i9)) ? i9 :
	Loop, 4
		x := A_Index, j := i%x%, i6 += x = 3
		, k := !RegExMatch(a, j . "([\d.]+)", v) + (v1 ? v1 : 0)
		, e := p%j% - i%i6% * k, d .= n ? e . i5 : ""
		, RegExMatch(d, RegExReplace(i9, "([[\\\^\$\.\|\?\*\+\(\)])", "\$1")
		. "(?:([\d.\-]+)/){" . x . "}", v)
		, l .= InStr(a, j) ? j . v1 + i%i6% * k : ""
	r := r ? "Draw" :
	GuiControl, Move%r%, %c%, %l%
}

DisplaySize(FileSize) {
	Static KB := 1024
	Static MB := KB * 1024
	Static GB := MB * 1024
	Return (FileSize >= GB) ? (Round(FileSize / GB, 2) . " GB")
			: (FileSize >= MB) ? (Round(FileSize / MB) . " MB")
			: (FileSize >= KB) ? (Round(FileSize / KB) . " kB")
			: (FileSize < KB) ? (Round(FileSize) . " byte")
		: FileSize
}