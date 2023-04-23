#SingleInstance force
folder1 :=  A_Args[1], folder2 :=  A_Args[2]
B_adb := A_ScriptDir "\..\..\引用程序\adb.exe"
; 1088

SyncFolder:
Gui,66: Destroy
Gui,66: Default
SplitPath, folder1, OutFileName

Gui, Add, text, x10 y10, 手机IP:
Gui, Add, ComboBox, xp+70 w300 vphoneip, 192.168.1.109:5555||192.168.1.214:5555|
Gui, Add, Button, xp+310 gconnectphone, 连接手机
Gui, Add, Button, xp+80 gdisconnectphone, 断开连接
Gui, Add, Button, xp+80 gcheckdevices, 查看连接

Gui, Add, text, x10 yp+30, 源文件夹:
Gui, Add, edit, xp+70 w480 h40 r2 vfolder1, % folder1
Gui, Add, text, xp+490, 手机文件夹:
folder2list := "/storage/emulated/0/1_文档/资料/同步文件夹||/storage/emulated/0/1我的文档/资料/同步文件夹"
Gui, Add, ComboBox, xp+80 w470 h60 vfolder2, % folder2list
if instr(folder2list, folder2)
	GuiControl, ChooseString, folder2, % folder2
else
{
	GuiControl,, folder2, % folder2
	GuiControl, ChooseString, folder2, % folder2
}
Gui, Add, ListView, x10 yp+45 w550 h500 vfilelist1 hwndHLV1 Checked AltSubmit gsync, 序号|文件名|修改日期|大小
Gui, Add, ListView, x570 yp w550 h500 vfilelist2 hwndHLV2 Checked AltSubmit gsync, 序号|文件名|修改日期|大小|相等
Gui, Add, Button, x10 yp+510 h30 gloderfolder, 加载列表
Gui, Add, Button, xp+70 h30 grpview, 预览结果
Gui, Add, Button, xp+70 h30 gsave, 执行同步
gui, show,, 文件夹同步
Menu, Tray, UseErrorLevel
Menu, filelistMenu, deleteall
Menu, filelistMenu, Add, 全不选, uncheckallfile
Menu, filelistMenu, Add, 下一个选中, jumpcheckedfile
Menu, filelistMenu, Add, 打开路径, openfilepfromlist
Menu, filelistMenu, Add, 删除选中文件, delfillefromlist
CmdRes := RunCmd(B_adb " devices")
if instr(CmdRes, "`t")
{
	if folder2 && (folder2 != folder1)
		gosub loderfolder
}
return

On_WM_NOTIFY(W, L, M, H) {
   Global HLV1, HLV2, IH
   HLV := NumGet(L + 0, "UPtr")
   If ((HLV = HLV1) || (HLV = HLV2)) && (NumGet(L + (A_PtrSize * 2), "Int") = -181) { ; LVN_ENDSCROLL
      XD := NumGet(L + (A_PtrSize * 3), 0, "Int")
      , YD := NumGet(L + (A_PtrSize * 3), 4, "Int")
      , HLV := (HLV = HLV1) ? HLV2 : HLV1
      , DllCall("SendMessage", "Ptr", HLV, "Int", 0x1014, "Ptr", XD, "Ptr", YD * IH) ; LVM_SCROLL
   }
}
;  --------------------------------------------------------------------------------------------------
LV_GetItemHeight(HLV) {
   VarSetCapacity(RC, 16, 0)
   If DllCall("SendMessage", "Ptr", HLV, "UInt", 0x100E, "Ptr", 0, "Ptr", &RC) ; LVM_GETITEMRECT
      Return (NumGet(RC, 12, "Int") - NumGet(RC, 4, "Int"))
   Return 0
}

loderfolder:
Gui, 66: Default
Gui, submit, nohide
tooltip % "正在对比文件夹, 请稍候..."
IniRead, 忽略目录, %folder1%\.忽略列表.ini, 目录, 忽略目录
IniRead, 忽略文件, %folder1%\.忽略列表.ini, 文件
Gui, ListView, filelist1
LV_Delete()
Gui, ListView, filelist2
LV_Delete()
folderobj1 := {}
folderobj2 := {}
flastwriteobj1:={}
flastwritehumanobj1 := {}
flastwriteobj2 := {}
flastwritehumanobj2 := {}
fsizeobj1 := {}
fsizeobj2 := {}
fMD5obj1 := {}
fMD5obj2 := {}
Tmp_Str := ""

if folder1
Loop, Files, %folder1%\*.*, DFR
{
	if A_LoopFileAttrib contains H,R,S
		continue
	relativePS := StrReplace(A_LoopFilePath, folder1 "\")
	if relativePS contains %忽略目录%
		Continue
	if instr(忽略文件, relativePS)
		Continue

	if InStr(A_LoopFileAttrib, "D")
		folderobj1[relativePS] := "folder"
	else
		folderobj1[relativePS] := 1

	flastwriteobj1[relativePS] := SubStr(A_LoopFileTimeModified, 1, 12)
	FormatTime, Out_time, % A_LoopFileTimeModified, yyyy-MM-dd HH:mm
	flastwritehumanobj1[relativePS] := Out_time
	fsizeobj1[relativePS] := A_LoopFileSize

	Tmp_Str .= relativePS "`n"
}

if folder2
{
	;FileEncoding, UTF-8
	;Loop, Read, C:\Users\Administrator\Desktop\DevDir (2).lst
	CmdRes := RunCmd(B_adb " shell ls -lR " folder2,, "CP65001")
	;msgbox % CmdRes
	loop, parse, CmdRes, `n, `r
	{
		if !A_LoopField
			continue
		if instr(A_LoopField, "total")
			continue
		if instr(A_LoopField, folder2)
		{
			tmp_folder := StrReplace(A_LoopField, folder2, "")
			tmp_folder := StrReplace(tmp_folder, ":", "")
			tmp_folder := StrReplace(tmp_folder, "/", "\")
			tmp_folder := Trim(tmp_folder, "\")
			continue
		}
		regexmatch(A_LoopField, "Ui)^[drwx\-]+[ ]+[0-9]+[ ]+[a-z\_\-0-9]+[ ]+[a-z\_\-0-9]+[ ]+([0-9]+)[ ]+([0-9]{4}-[0-9]{2}-[0-9]{2} *[0-9]{2}:[0-9]{2}) +(.*)$", xx_)
		if ( xx_3 = "" )
			continue
		else
		{
			if tmp_folder
				relativePS := tmp_folder "\" xx_3
			else
				relativePS := xx_3
			if (instr(A_LoopField, "d") = 1)
			{
				folderobj2[relativePS] := "folder"
				fsizeobj2[relativePS] := 0
			}
			else
			{
				folderobj2[relativePS] := 1
				flastwritehumanobj2[relativePS] := xx_2
				Out_time := StrReplace(xx_2, " ", "")
				Out_time := StrReplace(Out_time, "-", "")
				Out_time := StrReplace(Out_time, ":", "")
				flastwriteobj2[relativePS] := Out_time
				fsizeobj2[relativePS] := xx_1
			}
			Tmp_Str .= relativePS "`n"
		}
	}
}

Tmp_Str := Trim(Tmp_Str, "`n")
Sort, Tmp_Str, U

GuiControl, -redraw, filelist1
GuiControl, -redraw, filelist2
Loop, parse, Tmp_Str, `n, `r
{
	Gui, ListView, filelist1
	if folderobj1.HasKey(A_LoopField)
	{
		LV_Add("", A_Index, A_LoopField, flastwritehumanobj1[A_LoopField], fsizeobj1[A_LoopField])
	}
	else
	{
		LV_Add("", A_Index, "空")
	}

	Gui, ListView, filelist2
	if folderobj2.HasKey(A_LoopField)
	{
		if (fsizeobj1[A_LoopField] = fsizeobj2[A_LoopField])   ; 文件大小相等
		{
			; 手机中的文件的修改时间大于电脑时判断为相同
				if (flastwriteobj1[A_LoopField] <= flastwriteobj2[A_LoopField]) or (folderobj2[A_LoopField] = "folder")
				{
					LV_Add("", A_Index, A_LoopField, flastwritehumanobj2[A_LoopField], fsizeobj2[A_LoopField], "是")
				}
				else
				{
					LV_Add("", A_Index, A_LoopField, flastwritehumanobj2[A_LoopField], fsizeobj2[A_LoopField], "否")
					Gui, ListView, filelist1
					LV_Modify(A_Index, "check")    ; 文件大小相同但是最近修改时间不同则勾选左侧
				}
		;msgbox % flastwriteobj1[A_LoopField] " - " flastwriteobj2[A_LoopField]
		}
		else   ; 文件大小不相等
		{
			LV_Add("", A_Index, A_LoopField, flastwritehumanobj2[A_LoopField], fsizeobj2[A_LoopField], "否")
			if folderobj1.HasKey(A_LoopField)   ; 左侧也存在该文件, 勾选左侧
			{
				Gui, ListView, filelist1
				LV_Modify(A_Index, "check")
			}
			else                                ; 左侧不存在该文件, 勾选右侧  
				LV_Modify(A_Index, "check")
		}
	}
	else
	{
		LV_Add("", A_Index, "空")
		Gui, ListView, filelist1
		LV_Modify(A_Index, "check")
	}
}

Gui, ListView, filelist1
{
	LV_ModifyCol()
	LV_ModifyCol(1, "Logical")
	LV_ModifyCol(2, 300)
	LV_ModifyCol(5, 220)
}
Gui, ListView, filelist2
{
	LV_ModifyCol()
	LV_ModifyCol(1, "Logical")
	LV_ModifyCol(2, 300)
}

GuiControl, +redraw, filelist1
GuiControl, +redraw, filelist2

CF_ToolTip("对比完成", 3000)
IH := LV_GetItemHeight(HLV1)
OnMessage(0x004E, "On_WM_NOTIFY")
return

sync:
if (A_GuiControl = "filelist1") && (A_GuiEvent = "Normal")
{
	Gui, ListView, filelist1
	RF := LV_GetNext("F")
	Gui, ListView, filelist2
	LV_Modify(0, "-Select")
	if RF
		LV_Modify(RF, "Select Focus Vis")
}
if (A_GuiControl = "filelist2") && (A_GuiEvent = "Normal")
{
	Gui, ListView, filelist2
	RF := LV_GetNext("F")
	Gui, ListView, filelist1
	LV_Modify(0, "-Select")
	if RF
		LV_Modify(RF, "Select Focus Vis")
}
return

save:
Gui, 66: Default
Gui, ListView, filelist1
RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	;msgbox % RowNumber
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break

	LV_GetText(Tmp_Str, RowNumber, 2)
	if (folderobj1[Tmp_Str] = "folder" )   ; 新建文件夹
	{
		phonefp := folder2 "\" Tmp_Str
		phonefp := StrReplace(phonefp, "\", "/")
		CmdRes := RunCmd(B_adb " shell mkdir " phonefp,, "CP65001")
	}
	else   ; 同步文件
	{
		phonefp := folder2 "\" Tmp_Str
		phonefp := StrReplace(phonefp, "\", "/")
		;msgbox % B_adb " push " folder1 "\" Tmp_Str " " phonefp
		CmdRes := RunCmd(B_adb " push " folder1 "\" Tmp_Str " " phonefp,, "CP65001")
		;msgbox % CmdRes
	}
}

Gui, ListView, filelist2
RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break
	LV_GetText(Tmp_Str, RowNumber, 2)
	if (folderobj2[Tmp_Str] = "folder" )
		Continue
	else            ; 删除右侧有而左侧没有的文件
	{
		phonefp := folder2 "\" Tmp_Str
		phonefp := StrReplace(phonefp, "\", "/")
		CmdRes := RunCmd(B_adb " shell rm " phonefp,, "CP65001")
	}
}

RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break
	LV_GetText(Tmp_Str, RowNumber, 2)
	if (folderobj2[Tmp_Str] = "folder" )
	{
		phonefp := folder2 "\" Tmp_Str
		phonefp := StrReplace(phonefp, "\", "/")
		CmdRes := RunCmd(B_adb " shell rmdir " phonefp,, "CP65001") ; 删空目录
	}
}
CF_ToolTip("同步完成", 3000)
return

rpview:
Gui, 66: Default

Gui, ListView, filelist1
RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Tmp_Str := ""
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	;msgbox % RowNumber
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break

	LV_GetText(Tmp_Value, RowNumber, 2)
	Tmp_index := Format("{:04}", A_Index)
	if (folderobj1[Tmp_Value] = "folder" )
		Tmp_Str .= Tmp_index ". 新建文件夹: " Tmp_Value "`n"
	else
	{
		if folderobj2[Tmp_Value]
			Tmp_Str .= Tmp_index ". 同步的文件: "  Tmp_Value "`n"
		else
			Tmp_Str .= Tmp_index ". 新建的文件: "  Tmp_Value "`n"
	}
}

Gui, ListView, filelist2
RowNumber := 0
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break
	LV_GetText(Tmp_Value, RowNumber, 2)
	Tmp_index := Format("{:04}", A_Index)
	if (folderobj2[Tmp_Value] = "folder" )
		Tmp_Str .= Tmp_index ". 删除的文件夹: " Tmp_Value "`n"
	else
		Tmp_Str .= Tmp_index ". 删除的文件: " Tmp_Value "`n"
}
;msgbox % Tmp_Str
GuiText(Tmp_Str, 500, 20)
return

delfillefromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
		FileDelete %folder1%\%Tmp_Str%
		LV_Modify(RF, "-check",, "空", "", "", "")
}
return

openfilepfromlist:
Gui,66: Default
RF := LV_GetNext("F")
Tmp_Str := ""
if RF
{
	LV_GetText(Tmp_Str, RF, 2)
}
if Tmp_Str
{
	SplitPath, Tmp_Str,, OutDir
	Run, %OutDir%
	;Run, explorer.exe /select`, %folder1%\%Tmp_Str%
}
return

uncheckallfile:
Gui,66: Default
LV_Modify(0, "-check")
return

jumpcheckedfile:
Gui,66: Default
RF := LV_GetNext("F")
if RF
{
	RFF := LV_GetNext(RF, "C")
	if !RFF
		RFF := LV_GetNext(RF+1, "C")
	LV_Modify(RFF, "Focus Vis")
}
return

GuiText(Gtext, w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	Return
}

66GuiClose:
66Guiescape:
Gui,66: Destroy
Gui,GuiText: Destroy
exitapp
Return

66GuiContextMenu:
if (A_GuiControl = "filelist1")
{
	Gui, ListView, filelist1
	lvfolder := 1
	Menu, filelistMenu, Show
}
return

CF_ToolTip(tipText, delay := 1000)
{
	ToolTip
	ToolTip, % tipText
	SetTimer, RemoveToolTip, % "-" delay
return

RemoveToolTip:
	ToolTip
return
}

connectphone:
Gui, 66: Default
Gui, submit, nohide
CmdRes := RunCmd(B_adb " connect " phoneip)
if (instr(CmdRes, "connected to") = 1)
{
	if instr(RunCmd(B_adb " devices"), phoneip)
		CF_ToolTip("连接成功", 3000)
}
else if instr(CmdRes, "already connected to")
	CF_ToolTip("连接成功", 3000)
else
	msgbox % CmdRes
return

disconnectphone:
Gui, 66: Default
Gui, submit, nohide
CmdRes := RunCmd(B_adb " disconnect " phoneip)
if instr(CmdRes, "disconnected")
	CF_ToolTip("已断开连接", 3000)
else
	msgbox % CmdRes
return

checkdevices:
Gui, 66: Default
Gui, submit, nohide
msgbox % RunCmd(B_adb " devices")
return

RunCmd(CmdLine, WorkingDir:="", Cp:="CP0") { ; Thanks Sean!  SKAN on D34E @ tiny.cc/runcmd 
  Local P8 := (A_PtrSize=8),  pWorkingDir := (WorkingDir ? &WorkingDir : 0)                                                
  Local SI, PI,  hPipeR:=0, hPipeW:=0, Buff, sOutput:="",  ExitCode:=0,  hProcess, hThread
                   
  DllCall("CreatePipe", "PtrP",hPipeR, "PtrP",hPipeW, "Ptr",0, "UInt",0)
, DllCall("SetHandleInformation", "Ptr",hPipeW, "UInt",1, "UInt",1)
    
  VarSetCapacity(SI, P8? 104:68,0),      NumPut(P8? 104:68, SI)
, NumPut(0x100, SI,  P8? 60:44,"UInt"),  NumPut(hPipeW, SI, P8? 88:60)
, NumPut(hPipeW, SI, P8? 96:64)   

, VarSetCapacity(PI, P8? 24:16)               

  If not DllCall("CreateProcess", "Ptr",0, "Str",CmdLine, "Ptr",0, "UInt",0, "UInt",True
              , "UInt",0x08000000 | DllCall("GetPriorityClass", "Ptr",-1,"UInt"), "UInt",0
              , "Ptr",pWorkingDir, "Ptr",&SI, "Ptr",&PI )  
     Return Format( "{1:}", "" 
          , DllCall("CloseHandle", "Ptr",hPipeW)
          , DllCall("CloseHandle", "Ptr",hPipeR)
          , ErrorLevel := -1 )
  DllCall( "CloseHandle", "Ptr",hPipeW)

, VarSetCapacity(Buff, 4096, 0), nSz:=0   
  While DllCall("ReadFile",  "Ptr",hPipeR, "Ptr",&Buff, "UInt",4094, "PtrP",nSz, "UInt",0)
    sOutput .= StrGet(&Buff, nSz, Cp)

  hProcess := NumGet(PI, 0),  hThread := NumGet(PI,4)
, DllCall("GetExitCodeProcess", "Ptr",hProcess, "PtrP",ExitCode)
, DllCall("CloseHandle", "Ptr",hProcess),    DllCall("CloseHandle", "Ptr",hThread)
, DllCall("CloseHandle", "Ptr",hPipeR),      ErrorLevel := ExitCode  
Return sOutput  
}