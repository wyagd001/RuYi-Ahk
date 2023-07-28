;|2.1|2023.07.28|1396
;来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=32750&hilit=IconEx
/* _______________________________________________________________________________________
   _____                ______          __  _					SKAN (Suresh Kumar A N)
  |_   _|              |  ____|        /_ || |  _  __      __   arian.suresh@gmail.com
    | |  ___ ___  _ __ | |__  __  __    | || |_| | \ \    / / Contributors: thebunnyrules(dragNdrop&quiet ops)
    | | / __/ _ \| '_ \|  __| \ \/ /    | ||___| |  \ \  / /
   _| || (_| (_) | | | | |____ >  <     | |    | |   \ \/ /     Created on    : 13-May-2008
  |_____\___\___/|_| |_|______/_/\_\    |_|(_) |_|    \__/      Last Modified : 12-Jun-2017

  
  
 [ I C O N  E X P L O R E R  A N D  E X T R A C T O R ]        Version : 1.4v-2
   _______________________________________________________________________________________
*/
#NoEnv
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
Process, Priority, , High

CandySel := A_Args[1]  ; exe, dll 文件
InputFilePath := CandySel
OutputPath := A_Args[2]  ; 图标输出目录
qUiet		   = %3% ; quiet  ; putting quiet in 3rd paremeter will get you a gui free extraction that will dump all the icons in your input file directly to OutputPath. If you don't want a seperate OutputPath, be sure to put "" second parameter

; These nested if blocks will check if you used the InputFilePath/OutputPath parameters are used. If they aren't, it will default to imageres.dll in system32 and the script folder for Deff 
if (InputFilePath="")
{
	if (OutputPath="")
	{
		Deff := A_ScriptDir  ; Default ICON save folder
	}
	else
	{
		Deff := OutputPath 
	}
	tFolder := fAllback
}
else
{
	SplitPath, InputFilePath, InputFile, InputPath, InputFileExtension
	if (OutputPath="")
	{
		Deff := iNputPath
	}
	else
	{
		Deff := OutputPath
	}
	tFolder := InputFilePath 
}

; ======================================================================================================================
SaveButton     := 0x79 -1      ; (VK code for F9) Note: modify -1 to -2 for F8 and so on...
KeyName        := "F9"         ; depends on the VK code you use above
fAllback	   := A_WinDir . "\System32\imageres.dll" ; default folder in address bar (in absence of parameters)
CallB          := RegisterCallback("EnumResNameProc")

AhkVersion     := A_AhkVersion . (A_IsUnicode ? (A_PtrSize = 8 ? " (U64)" : " (U32)") : " (ANSI)")
GuiTitle       := "IconEx - v1.4v   [ AutoHotkey  v" . AhkVersion . " ]"
RT_GROUP_ICON  := 14
RT_ICON        := 3
STM_SETIMAGE   := 0x172
If FileExist(A_Temp . "\IconEx.tmp") {
   FileRead, tFolder, %A_Temp%\IconEx.tmp
   FileDelete, %A_Temp%\IconEx.tmp
}
; ======================================================================================================================
Gui, Font, s10 Normal, Tahoma
Gui, Add, Combobox, x7 y7 w550 h21 Choose1 -Theme hwndhSHAC vtFolder, %tFolder%
ControlGet, hMyEdit, hWnd,, Edit1, ahk_id %hSHAC%
; SHAutoComplete():  Sean - http://www.autohotkey.com/forum/viewtopic.php?p=121621#121621
; For constants : http://www.codeproject.com/KB/edit/autocomp.aspx
DllCall("Shlwapi.dll\SHAutoComplete", "Ptr", hMyEdit, "UInt", 0x1|0x10000000)

		if (qUiet="quiet")
		{
			Gui, Add, ListView
			   , x7 y+5 h280 w235 -Theme -E0x200 +0x4 +0x8 +Border vLVR gLVR +BackGroundFFFFFA c444466 AltSubmit
			   , Resource File|Icons|IconGroup
			LV_ModifyCol(1 ,"170")
			LV_ModifyCol(2, "42 Integer")
			LV_ModifyCol(3, "0")
			SB_SetParts(40, 425)
			GoSub, UpdateResourceListSingleFile
			GoSub, ExtractIconResQuiet
			ExitApp ; // end of auto-execute section //
		}
		else if (qUiet="quietmain")
		{
			Gui, Add, ListView
			   , x7 y+5 h280 w235 -Theme -E0x200 +0x4 +0x8 +Border vLVR gLVR +BackGroundFFFFFA c444466 AltSubmit
			   , Resource File|Icons|IconGroup
			LV_ModifyCol(1 ,"170")
			LV_ModifyCol(2, "42 Integer")
			LV_ModifyCol(3, "0")
			SB_SetParts(40, 425)
			GoSub, UpdateResourceListSingleFile
			GoSub, ExtractIconResQuietMain
			ExitApp ; // end of auto-execute section //
		}
		else
		{
			Gui, Font, s8 Normal, Tahoma
			Gui, Add, Button, x+2 w33 h24 +Default gUpdateResourceList, &Go
			Gui, Add, Button, x+2 w52 h24 gSelectFolder, &Browse
			Gui, Add, ListView
			   , x7 y+5 h280 w235 -Theme -E0x200 +0x4 +0x8 +Border vLVR gLVR +BackGroundFFFFFA c444466 AltSubmit
			   , Resource File|Icons|IconGroup
			LV_ModifyCol(1 ,"170")
			LV_ModifyCol(2, "42 Integer")
			LV_ModifyCol(3, "0")
			Gui, Add, ListView
			   , x+0 yp h280 w405 -Theme +Icon -E0x200 +0x100 +BackGroundFFFFFC cBB2222 Border AltSubmit vLVI gLVI hwndLVC2
			Gui, Add, Hotkey, x2 y+79 w1 h1 +Disabled vHotkey gCreateSimpleIcon
			Loop 8 {
			   Ix += 1
			   Gui, Add, Picture, x+10 yp-70 0x1203 w70 h70 vI%Ix% hWndIcon%Ix% gSelectSimpleIcon
			   Gui, Add, Text, xp   yp+70 0x201  w70 h16 vIconT%Ix%, -
			}
			Gui, Add, Text, x2 y+79 w1 h1
			Loop 8 {
			   Ix += 1
			   Gui, Add, Picture, x+10 yp-70 0x1203 w70 h70 vI%Ix% hWndIcon%Ix% gSelectSimpleIcon
			   Gui, Add, Text, xp   yp+70 0x201  w70 h16 vIconT%Ix%, -
			}
			Gui, Add, Button, x7 y+30 gAccelerator, &File
			Gui, Add, Button, x+5     gAccelerator, &Icon
			Gui, Add, Button, x+5     gAccelerator, A&ddress Bar
			Gui, Add, Button, x+5     gAccelerator, &Reload
			Gui, Font
			Gui, Add, StatusBar, vSB gFindTarget
			SB_SetParts(40, 425)
			GoSub, UpdateResourceList
			SB_SetText("Type the path to a folder/file. Auto complete enabled", 2)
			Gui, Show, w655 h535, %GuiTitle%
			Return ; // end of auto-execute section //
		}
			
			Gui, Add, ListView
			   , x+0 yp h280 w405 -Theme +Icon -E0x200 +0x100 +BackGroundFFFFFC cBB2222 Border AltSubmit vLVI gLVI hwndLVC2
			Gui, Add, Hotkey, x2 y+79 w1 h1 +Disabled vHotkey gCreateSimpleIcon
			Loop 8 {
			   Ix += 1
			   Gui, Add, Picture, x+10 yp-70 0x1203 w70 h70 vI%Ix% hWndIcon%Ix% gSelectSimpleIcon
			   Gui, Add, Text, xp   yp+70 0x201  w70 h16 vIconT%Ix%, -
			}
			Gui, Add, Text, x2 y+79 w1 h1
			Loop 8 {
			   Ix += 1
			   Gui, Add, Picture, x+10 yp-70 0x1203 w70 h70 vI%Ix% hWndIcon%Ix% gSelectSimpleIcon
			   Gui, Add, Text, xp   yp+70 0x201  w70 h16 vIconT%Ix%, -
			}
			Gui, Add, Button, x7 y+30 gAccelerator, &File
			Gui, Add, Button, x+5     gAccelerator, &Icon
			Gui, Add, Button, x+5     gAccelerator, A&ddress Bar
			Gui, Add, Button, x+5     gAccelerator, &Reload
			Gui, Font
			Gui, Add, StatusBar, vSB gFindTarget
			SB_SetParts(40, 425)
			GoSub, UpdateResourceList
			SB_SetText("Type the path to a folder/file. Auto complete enabled", 2)
			Gui, Show, w655 h535, %GuiTitle%
			Return ; // end of auto-execute section //
			
; ======================================================================================================================
UpdateResourceList:
   SendInput, {Escape}
   ControlGetText,tFolder,, ahk_id %hSHAC%
   If ! InStr(FileExist(tFolder), "D")
      Folder := tFolder
   Else Folder := tFolder . "\*.*"
   GoSub, SetFolder
   Gui, ListView, LVI
   LV_Delete()
   Gui, ListView, LVR
   LV_Delete()
   SB_SetText("  Loading files.. Please wait" , 2)
   FileCount := 0
   Loop, %Folder%
   {
      If A_LoopFileExt Not in EXE,DLL,CPL,SCR
         Continue
      hModule := LoadLibraryEx(A_LoopFileLongPath)
      If (hModule = 0)
         Continue
      IGCount := 0
      IconGroups := ""
      DllCall("Kernel32.dll\EnumResourceNames", "Ptr", hModule, "Ptr", 14, "Ptr", CallB, "Ptr", 0)
      DllCall("Kernel32.dll\FreeLibrary", "Ptr", hModule)
      If (IGCount = 0)
         Continue
      FileCount++
      StringUpper, FileName, A_LoopFileName
      Gui, ListView, LVR
      LV_ADD("", FileName, IGCount, IconGroups)
      SB_SetText("`t" . FileCount, 1)
   }
   SB_SetText("`t" . FileCount, 1)
   SB_SetText("  Done!" , 2)
   GuiControl, Focus, LVR
   RowNo := 1
   GoSub, LVRSUB
   Gui, ListView, LVI
   LV_Modify(1, "Select")
   Gui, ListView, LVR
   GuiControl, Focus, LVR
   LV_Modify(1, "Select")
   GuiControl, Focus, tFolder
Return

; ======================================================================================================================
UpdateResourceListSingleFile:

   Gui, ListView, LVI
   LV_Delete()
   Gui, ListView, LVR
   LV_Delete()


      If iNputFileExtension Not in EXE,DLL,CPL,SCR
         ExitApp
      hModule := LoadLibraryEx(iNputFilePath)
      If (hModule = 0)
         ExitApp
      IGCount := 0
      IconGroups := ""
      DllCall("Kernel32.dll\EnumResourceNames", "Ptr", hModule, "Ptr", 14, "Ptr", CallB, "Ptr", 0)
      DllCall("Kernel32.dll\FreeLibrary", "Ptr", hModule)
      If (IGCount = 0)
         ExitApp
      StringUpper, FileName, iNputFile
      Gui, ListView, LVR
      LV_ADD("", FileName, IGCount, IconGroups)

   GuiControl, Focus, LVR
   RowNo := 1
   GoSub, LVRSUBsingleFile
   Gui, ListView, LVI
   LV_Modify(1, "Select")
   Gui, ListView, LVR
   GuiControl, Focus, LVR
   LV_Modify(1, "Select")

Return

; ======================================================================================================================
UpdateResourceListSingleFile-broken:
      If iNputFileExtension Not in EXE,DLL,CPL,SCR
         Return
      hModule := LoadLibraryEx(iNputFilePath)
      If (hModule = 0)
         Return
      IGCount := 0
      IconGroups := ""
      DllCall("Kernel32.dll\EnumResourceNames", "Ptr", hModule, "Ptr", 14, "Ptr", CallB, "Ptr", 0)
      DllCall("Kernel32.dll\FreeLibrary", "Ptr", hModule)
      If (IGCount = 0)
         Return
      LV_ADD("", FileName, IGCount, IconGroups)

   GuiControl, Focus, LVR
   RowNo := 1
   GoSub, LVRSUBsingleFile
Return


; ======================================================================================================================
LVR:
   If (A_GuiEvent = "k") {
      If (A_EventInfo = 40 || A_EventInfo = 38) {
         RowNo := LV_GetNext(0, "Focused")
         GoTo, LVRSUB
         Return
      }
      If (A_EventInfo = SaveButton) {
         RowNo := LV_GetNext(0, "Focused")
         If (RowNo <> 0)
            GoSub, ExtractIconRes
         Return
      }
   }
   If (A_GuiEvent <> "Normal")
      Return
   RowNo := A_EventInfo
   If (RowNo = 0) {
      Loop, 16 {
         GuiControl, , IconT%A_Index%, -
         SendMessage, %STM_SETIMAGE%, 0x1, 0, , % "ahk_id " . Icon%A_Index%
      }
      Gui, ListView, LVI
      LV_Delete()
      If (ImageListID)
         IL_Destroy(ImageListID)
      ImageListID := 0
      SB_SetText("", 2)
      SB_SetText("", 3)
      Return
   }
LVRSUB:
   Gui, ListView, LVR
   LV_GetText(File, RowNo,1)
   LV_GetText(IGC, RowNo,2)
   LV_GetText(IG, RowNo,3)
   SB_SetText("Press <" . KeyName . "> to save all icons in " . File , 2)
   Gui, ListView, LVI
   LV_Delete()
   If (ImageListID)
      IL_Destroy(ImageListID)
   ImageListID := IL_Create(10, 10, 1)
   LV_SetImageList(ImageListID)
   Loop, %IGC%
      IL_Add(ImageListID, tFolder . "\" . File, A_Index)
   Loop, Parse, IG, |
   {
      Gui, ListView, LVI
      LV_Add("Icon" . A_Index, A_LoopField)
   }
   RowNo := 1
   GoSub, LVISUB
   Gui, ListView, LVR
Return
; ======================================================================================================================
LVRSUBsingleFile:
   LV_GetText(File, RowNo,1)
   LV_GetText(IGC, RowNo,2)
   LV_GetText(IG, RowNo,3)
   LV_Delete()
Return
; ======================================================================================================================
LVI:
   Gui, ListView, LVI
   If (A_GuiEvent = "k") {
      If (A_EventInfo >= 37) && (A_EventInfo <= 40) {
         RowNo := LV_GetNext(0, "Focused")
         LV_GetText(IconGroup, RowNo, 1)
         SB_SetText("Press <" . KeyName . "> to save the Icon Group " . IconGroup, 2)
         GoTo, LVISUB
         Return
      }
      If (A_EventInfo = SaveButton) {
         RowNo := LV_GetNext(0, "Focused")
         If (RowNo <> 0)
            GoSub, ExtractIcon
         Return
      }
      If (A_EventInfo = 0x79) {
       GoSub, ApplyIconToFolder
       Return
      }
   }
   If (A_GuiEvent <> "Normal")
      Return
   RowNo := A_EventInfo
   LV_GetText(IconGroup, RowNo, 1)
   SB_SetText("Press <" . KeyName . "> to save the Icon Group " . IconGroup, 2)
LVISUB:
   Gui, ListView, LVI
   LV_GetText(IconGroup, RowNo,1)
   hMod := LoadLibraryEx(tFolder . "\" . File)
   Buff := GetResource(hMod, IconGroup, RT_GROUP_ICON, nSize, hResData)
   Icos := NumGet(Buff + 4, 0, "UShort")
   Buff += 6
   SB_SetText("`t" . Icos . " Icons in < Group " . IconGroup . " >", 3)
   Loop, %Icos% {
      W   := NumGet(Buff + 0,  0, "UChar")
      H   := NumGet(Buff + 0,  1, "UChar")
      BPP := NumGet(Buff + 0,  6, "UShort")
      nID := NumGet(Buff + 0, 12, "UShort")
      Buff += 14
      If ((W + H) = 0) {
         SendMessage, %STM_SETIMAGE%, 0x1, 0, , % "ahk_id " . Icon%A_Index%
         DllCall("Kernel32.dll\FreeResource", "Ptr", hResData)
         GuiControl, ,IconT%A_Index%, PNG ICON
         Continue
      }
      IconD := GetResource(hMod, nID, RT_ICON, nSize, hResData)
      Wi := (W > 64) ? 64 : W
      Hi := (H > 64) ? 64 : H
      hIcon := DllCall("User32.dll\CreateIconFromResourceEx", "Ptr", IconD, "UInt", BPP, "Int", 1
                        , "UInt", 0x00030000, "Int", Wi, "Int", Hi, "UInt",(LR_SHARED := 0x8000), "UPtr")
      SendMessage, %STM_SETIMAGE%, 0x1,     0, , % "ahk_id " . Icon%A_Index%
      SendMessage, %STM_SETIMAGE%, 0x1, hIcon, , % "ahk_id " . Icon%A_Index%
      DllCall("Kernel32.dll\FreeResource", "Ptr", hResData)
      GuiControl, , IconT%A_Index%, %W%x%H%-%BPP%b
      filep := tFolder "\" File
      Ahk_IconGroup := IndexOfIconResource(filep, IconGroup)
			;tooltip % IconGroup " - " Ahk_IconGroup
      GuiControl,, I%A_Index%, *icon%Ahk_IconGroup% *w%W% *h-1 %filep%
   }
   Loop % (16 - Icos) {
      Ix := Icos + A_Index
      GuiControl, , IconT%Ix%, -
      SendMessage, %STM_SETIMAGE%, 0x1, 0, , % "ahk_id " . Icon%Ix%
   }
   DllCall("Kernel32.dll\FreeResource", "Ptr", hResData)
   DllCall("Kernel32.dll\FreeLibrary", "Ptr", hModule)
Return
; ======================================================================================================================
ExtractIconRes:
   FileSelectFolder, TargetFolder, *%DEFF%, 3, Extract Icons! Where to?
   If (TargetFolder = "")
      Return
   GoSub, SetFolder
   hModule := LoadLibraryEx(tFolder . "\" . File)
   Loop, Parse, IG, |
   {
      FileN := SubStr("000" . A_Index, -3) . "-" . SubStr("00000" . A_LoopField, -4) . ".ico"
      SB_SetText((FileN := TargetFolder . "\" . FileN), 2)
      IconGroup := A_LoopField
      GoSub, WriteIcon
   }
   DllCall("Kernel32.dll\FreeLibrary", "Ptr", hModule)
   SB_SetText(IGC . " Icons extracted!", 2)
   DllCall("Kernel32.dll\Sleep", "UInt", 1000)
   SB_SetText(TargetFolder, 2)
Return
; ======================================================================================================================
ExtractIconResQuiet:
   ;FileSelectFolder, TargetFolder, *%DEFF%, 3, Extract Icons! Where to?
   ;If (TargetFolder = "")
   ;   Return
   TargetFolder := Deff
   GoSub, SetFolder
   hModule := LoadLibraryEx(tFolder . "\" . File)
   mainIcon := true
   Loop, Parse, IG, |
   {
	  if (mainIcon)
	  {
		FileN := iNputFile . ".main.ico"
		mainIcon := false
	  }
	  else
	  {
		FileN := iNputFile . ".secondary." . SubStr("000" . A_Index, -3) . "-" . SubStr("00000" . A_LoopField, -4) . ".ico"
      }
	  SB_SetText((FileN := TargetFolder . "\" . FileN), 2)
      IconGroup := A_LoopField
      GoSub, WriteIconSINGLEfile
   }
   DllCall("Kernel32.dll\FreeLibrary", "Ptr", hModule)
   SB_SetText(IGC . " Icons extracted!", 2)
   DllCall("Kernel32.dll\Sleep", "UInt", 1000)
   SB_SetText(TargetFolder, 2)
Return
; ======================================================================================================================
ExtractIconResQuietMain:
   TargetFolder := Deff
   GoSub, SetFolder
   hModule := LoadLibraryEx(tFolder . "\" . File)
   Loop, Parse, IG, |
   {
		FileN := iNputFile . ".main.ico"
		SB_SetText((FileN := TargetFolder . "\" . FileN), 2)
		IconGroup := A_LoopField
		GoSub, WriteIconSINGLEfile
		break
   }
   DllCall("Kernel32.dll\FreeLibrary", "Ptr", hModule)
   SB_SetText(IGC . " Icons extracted!", 2)
   DllCall("Kernel32.dll\Sleep", "UInt", 1000)
   SB_SetText(TargetFolder, 2)
Return
; ======================================================================================================================
ExtractIcon:
   LV_GetText(IconGroup, RowNo, 1)
   FileN := SaveIcon(Deff . "\" . File . "_IG" . SubStr("_00000" . IconGroup, -4) . ".ico")
   If (FileN = "")
      Return
   hModule := LoadLibraryEx(tFolder . "\" . File)
   GoSub, WriteIcon
   DllCall("Kernel32.dll\FreeLibrary", "Ptr", hModule)
   SB_SetText(FileN, 2)
Return
; ======================================================================================================================
WriteIcon:
   hFile := FileOpen(FileN, "rw", "CP0")
   sBuff := GetResource(hModule, IconGroup, RT_GROUP_ICON, nSize, hResData)
   Icons := NumGet(sBuff + 0, 4, "UShort")
   hFile.RawWrite(sBuff + 0, 6)
   sBuff += 6
   Loop, %Icons% {
      hFile.RawWrite(sBuff + 0, 14)
      hFile.WriteUShort(0)
      sBuff += 14
   }
   DllCall("Kernel32.dll\FreeResource", "Ptr", hResData)
   EOF := hFile.Pos
   hFile.Pos := 18
   Loop %Icons% {
      nID := hFile.ReadUShort()
      hFile.Seek(-2, 1)
      hFile.WriteUInt(EOF)
      DataOffSet := hFile.Pos
      sBuff := GetResource(hModule, nID, RT_ICON, nSize, hResData)
      hFile.Seek(-0, 2)
      hFile.RawWrite(sBuff + 0, nSize)
      DllCall("Kernel32.dll\FreeResource", "Ptr", hResData)
      EOF := hFile.Pos
      hFile.Pos := DataOffset + 12
   }
   hFile.CLose()
Return
; ======================================================================================================================
WriteIconSINGLEfile:
   hFile := FileOpen(FileN, "rw", "CP0")
   sBuff := GetResource(hModule, IconGroup, RT_GROUP_ICON, nSize, hResData)
   Icons := NumGet(sBuff + 0, 4, "UShort")
   hFile.RawWrite(sBuff + 0, 6)
   sBuff += 6
   Loop, %Icons% {
      hFile.RawWrite(sBuff + 0, 14)
      hFile.WriteUShort(0)
      sBuff += 14
   }
   DllCall("Kernel32.dll\FreeResource", "Ptr", hResData)
   EOF := hFile.Pos
   hFile.Pos := 18
   Loop %Icons% {
      nID := hFile.ReadUShort()
      hFile.Seek(-2, 1)
      hFile.WriteUInt(EOF)
      DataOffSet := hFile.Pos
      sBuff := GetResource(hModule, nID, RT_ICON, nSize, hResData)
      hFile.Seek(-0, 2)
      hFile.RawWrite(sBuff + 0, nSize)
      DllCall("Kernel32.dll\FreeResource", "Ptr", hResData)
      EOF := hFile.Pos
      hFile.Pos := DataOffset + 12
   }
   hFile.CLose()
Return
; ======================================================================================================================
SelectSimpleIcon:
   StringTrimLeft, FNo ,A_GuiControl, 1
   GuiControlGet, IconT%fNo%
   If ((IconT := IconT%fNo%) = "-")
      Return
   SB_SetText("Press <" . KeyName . "> to save Icon " . IconT . " from Icon Group " . IconGroup , 2)
   GuiControl, Enable, Hotkey
   GuiControl, Focus,  Hotkey
   GuiControl, ,Hotkey
   SetTimer, DisableHotkey, -5000
Return
; ======================================================================================================================
DisableHotkey:
   GuiControlGet, Hotkey, Enabled
   If (Hotkey) {
      GuiControl, ,Hotkey
      GuiControl, Disable, Hotkey
      GuiControl, Focus, LVI
      StatusBarGetText, SbTxt, 2, IconEx
      InStr(SbTxt, "to save Icon") ? SB_SetText("", 2) :
   }
Return
; ======================================================================================================================
CreateSimpleIcon:
   SB_SetText("", 2)
   GuiControlGet, Hotkey
   GuiControl, Disable, Hotkey
   IfNotEqual, Hotkey, %KeyName%, Return

   FileN := SaveIcon(Deff . "\" . File . "_" . SubStr("0000" IconGroup, -4) . "_"
                    . SubStr("0" . FNo, -1) . "_" . IconT . ".ico")
   If (FileN = "")
      Return
   hModule := LoadLibraryEx(tFolder . "\" . File)
   Buffer := GetResource(hModule, IconGroup, RT_GROUP_ICON, nSize, hResData)
   tBuff := Buffer + 6 + ((Fno - 1) * 14)
   nID := Numget(tBuff + 0, 12, "Ushort")
   hFile := FileOpen(FileN, "w", "CP0")
   hFile.WriteUShort(0)
   hFile.WriteUShort(1)
   hFile.WriteUShort(1)
   hFile.RawWrite(tBuff + 0, 12)
   hFile.WriteUInt(22)
   DllCall("Kernel32.dll\FreeResource", "Ptr", hResData)
   Buff := GetResource(hModule, nID, RT_ICON, nSize, hResData)
   hFile.RawWrite(Buff + 0, nSize)
   hFile.Close()
   DllCall("Kernel32.dll\FreeResource", "Ptr", hResData)
   DllCall("Kernel32.dll\FreeLibrary", "Ptr", hModule)
   SB_SetText(FileN, 2)
Return
; ======================================================================================================================
FindTarget:
   StatusBarGetText, SB, 2, A
   If FileExist(SB)
      Run, %COMSPEC% /c "Explorer /select`, %SB%", ,Hide
Return
; ======================================================================================================================
SetFolder:
   ControlGetText, tFolder, , ahk_id %hSHAC%
   If !InStr(FileExist(tFolder), "D") {
      SplitPath, tFolder, , tFolder
      StringUpper, tFolder, tFolder
      ControlSetText, , %tFolder%, ahk_id %hSHAC%
   }
Return
; ======================================================================================================================
SelectFolder:
   GoSub, SetFolder
   FileSelectFolder, nFolder, *%tFolder%, , Select a Resource Folder
   If (nFolder = "")
      Return
   ControlSetText, ,%nFolder%, ahk_id %hSHAC%
   GoSub, SetFolder
   GoSub, UpdateResourceList
Return
; ======================================================================================================================
Accelerator:
   If (A_GuiControl = "&File")
      GuiControl, Focus, LVR
   Else If (A_GuiControl = "&Icon")
      GuiControl, Focus, LVI
   ELse If (A_GuiControl = "A&ddress Bar")
      GuiControl,Focus,tFolder
   Else If (A_GuiControl = "&Reload") && FileExist(tFolder . "\" . File) {
      FileAppend, %tFolder%\%File%, %A_Temp%\IconEx.tmp
      Reload
   }
Return
; ======================================================================================================================
ApplyIconToFolder:
   FileSelectFolder, applyFolder, ::{20d04fe0-3aea-1069-a2d8-08002b30309d}, 0, Apply FolderIcon
   If (applyFolder= "" || ErrorLevel)
      Return
   DesktopIni := applyFolder . "\Desktop.ini"
   IniRead, iconFile, %DesktopIni%, .ShellClassInfo, IconFile, %A_Space%
   If (SubStr(iconFile, 1, 7) == "IconEx_")
      FileDelete, %applyFolder%\%iconFile%
   iconFile := ("IconEx_" . HashStr(A_Now) . ".ico")
   FileN := applyFolder . "\" . iconFile
   hModule := LoadLibraryEx(tFolder . "\" . File)
   LV_GetText(IconGroup, RowNo, 1)
   GoSub, WriteIcon
   DllCall("Kernel32.dll\FreeLibrary", "Ptr", hModule)
   SB_SetText(FileN, 2)
   IniWrite, %IconFile%, %DesktopIni%, .ShellClassInfo, IconFile
   IniWrite, 0         , %DesktopIni%, .ShellClassInfo, IconIndex
   FileSetAttrib, +S,  %applyFolder%
   FileSetAttrib, +SH, %DesktopIni%
   FileSetAttrib, +SH, %FileN%
   ; SHCNE_ASSOCCHANGED := 0x8000000
   DllCall("Shell32.dll\SHChangeNotify", "Int", 0x8000000, "UInt", 0x0, "Ptr", 0, "Ptr" ,0)
   Run, Properties "%applyFolder%"
Return
; ======================================================================================================================
GuiContextMenu:
   StatusBarGetText, SbTxt, 2, IconEx
   StringTrimLeft, SbTxt, SbTxt, 14
   If (SubStr(SbTxt, 1, 4) = "save")
      SendInput, {%KeyName%}
Return
; ======================================================================================================================
GuiClose:
ExitApp
; ======================================================================================================================
EnumResNameProc(hModule, lpszType, lpszName, lParam) {
   Global IconGroups, IGCount
   If (lpszName > 0xFFFF)
      lpszName := StrGet(lpszName)
   IconGroups .= (IconGroups <> "" ? "|" : "") . lpszName
   IGCount++
   Return True
}
; ======================================================================================================================
GetResource(hModule, rName, rType, ByRef nSize, ByRef hResData) {
   Arg := (rName + 0 = "") ? &rName : rName
   hResource := DllCall("Kernel32.dll\FindResource", "Ptr", hModule, "Ptr", Arg, "Ptr", rType, "UPtr")
   nSize     := DllCall("Kernel32.dll\SizeofResource", "Ptr", hModule, "Ptr", hResource, "UInt")
   hResData  := DllCall("Kernel32.dll\LoadResource", "Ptr", hModule, "Ptr" , hResource, "UPtr")
   Return DllCall("Kernel32.dll\LockResource", "Ptr", hResData, "UPtr")
}
; ======================================================================================================================
SaveIcon(Filename, Prompt := "Save Icon As") {
   FileSelectFile, File, 16, %Filename%, %Prompt%, Icon (*.ico)
   Return ((File <> "" && SubStr(File, -3) <> ".ico") ? File . ".ico" : File)
}
; ======================================================================================================================
LoadLibraryEx(File) {
   Return DllCall("Kernel32.dll\LoadLibraryEx", "Str", File, "Ptr", 0, "UInt", 0x02, "UPtr")
}
; ======================================================================================================================
HashStr(sStr) {
   VarSetCapacity(hHash, 16, 0)
   DllCall("Shlwapi.dll\UrlHash", "Str", sStr, "UIntP", dHash, "UInt", 4)
   If (A_IsUnicode)
      DllCall("msvcrt.dll\swprintf", "Str", hHash, "Str", "%08X", "UInt", dHash)
   Else
      DllCall("msvcrt.dll\sprintf", "Str", hHash, "Str", "%08X", "UInt", dHash)
   Return hHash
}

IndexOfIconResource(Filename, ID)
{
    hmod := DllCall("GetModuleHandle", "str", Filename, "ptr")
    ; If the DLL isn't already loaded, load it as a data file.
    loaded := !hmod
        && hmod := DllCall("LoadLibraryEx", "str", Filename, "ptr", 0, "uint", 0x2, "ptr")
    
    enumproc := RegisterCallback("IndexOfIconResource_EnumIconResources","F")
    param := {ID: ID, index: 0, result: 0}
    
    ; Enumerate the icon group resources. (RT_GROUP_ICON=14)
    DllCall("EnumResourceNames", "ptr", hmod, "ptr", 14, "ptr", enumproc, "ptr", &param)
    DllCall("GlobalFree", "ptr", enumproc)
    
    ; If we loaded the DLL, free it now.
    if loaded
        DllCall("FreeLibrary", "ptr", hmod)
    
    return param.result
}

IndexOfIconResource_EnumIconResources(hModule, lpszType, lpszName, lParam)
{
    param := Object(lParam)
    param.index += 1

    if (lpszName = param.ID)
    {
        param.result := param.index
        return false    ; break
    }
    return true
}