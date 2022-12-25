CandySel := A_Args[1]
;WinGet, hGui, ID, 如意百宝箱 ahk_class AutoHotkeyGUI
/*
说明：如果是有独立的页面，则直接指向独立页面
否则，就是搜索
*/
Cando_查新版帮助:
	ahk中文帮助 := A_ScriptDir "\..\..\引用程序\AutoHotkeyLCN.chm"
	Ahk帮助标题 := "AutoHotkey 中文帮助"
	Ahk关键字表=Asc;AutoTrim;Block;BlockInput;Break;Catch;Chr;Click;ClipWait;ComObjActive;ComObjArray;ComObjConnect;ComObjCreate;ComObjError;ComObjFlags;ComObjGet;ComObjQuery;ComObjType;ComObjValue;Continue;Control;ControlClick;ControlFocus;ControlGet;ControlGetFocus;ControlGetPos;ControlGetText;ControlMove;ControlSend;ControlSetText;CoordMode;Critical;DetectHiddenText;DetectHiddenWindows;DllCall;Drive;DriveGet;DriveSpaceFree;Edit;Else;EnvAdd;EnvDiv;EnvGet;EnvMult;EnvSet;EnvSub;EnvUpdate;Exit;ExitApp;FileAppend;FileCopy;FileCopyDir;FileCreateDir;FileCreateShortcut;FileDelete;FileEncoding;FileExist;FileGetAttrib;FileGetShortcut;FileGetSize;FileGetTime;FileGetVersion;FileInstall;FileMove;FileMoveDir;FileOpen;FileRead;FileReadLine;FileRecycle;FileRecycleEmpty;FileRemoveDir;FileSelectFile;FileSelectFolder;FileSetAttrib;FileSetTime;Finally;For;Format;FormatTime;Func;GetKey;GetKeyState;Gosub;Goto;GroupActivate;GroupAdd;GroupClose;GroupDeactivate;Gui;GuiControl;GuiControlGet;GuiControls;Hotkey;Hotstring;IfBetween;IfEqual;IfExist;IfExpression;IfIn;IfInString;IfIs;IfMsgBox;IfWinActive;IfWinExist;ImageSearch;index;IniDelete;IniRead;IniWrite;Input;InputBox;InputHook;InStr;IsByRef;IsFunc;IsLabel;IsObject;KeyHistory;KeyWait;ListHotkeys;ListLines;ListVars;ListView;LoadPicture;Loop;LoopFile;LoopParse;LoopReadFile;LoopReg;Menu;MenuGetHandle;MenuGetName;MouseClick;MouseClickDrag;MouseGetPos;MouseMove;MsgBox;NumGet;NumPut;ObjAddRef;ObjBindMethod;OnClipboardChange;OnError;OnExit;OnMessage;Ord;OutputDebug;Pause;PixelGetColor;PixelSearch;PostMessage;Process;Progress;Random;RegDelete;RegExMatch;RegExReplace;RegisterCallback;RegRead;RegWrite;Reload;Return;Run;RunAs;Send;SendLevel;SendMode;SetBatchLines;SetControlDelay;SetDefaultMouseSpeed;SetEnv;SetExpression;SetFormat;SetKeyDelay;SetMouseDelay;SetNumScrollCapsLockState;SetRegView;SetStoreCapslockMode;SetTimer;SetTitleMatchMode;SetWinDelay;SetWorkingDir;Shutdown;Sleep;Sort;SoundBeep;SoundGet;SoundGetWaveVolume;SoundPlay;SoundSet;SoundSetWaveVolume;SplashTextOn;SplitPath;StatusBarGetText;StatusBarWait;StrGet;StringCaseSense;StringGetPos;StringLeft;StringLen;StringLower;StringMid;StringReplace;StringSplit;StringTrimLeft;StrPut;SubStr;Suspend;Switch;SysGet;Thread;Throw;ToolTip;Transform;TrayTip;TreeView;Trim;Try;Until;URLDownloadToFile;VarSetCapacity;While;WinActivate;WinActivateBottom;WinActive;WinClose;WinGet;WinGetActiveStats;WinGetActiveTitle;WinGetClass;WinGetPos;WinGetText;WinGetTitle;WinHide;WinKill;WinMaximize;WinMenuSelectItem;WinMinimize;WinMinimizeAll;WinMove;WinRestore;WinSet;WinSetTitle;WinShow;WinWait;WinWaitActive;WinWaitClose;#AllowSameLineComments;#ClipboardTimeout;#CommentFlag;#ErrorStdOut;#EscapeChar;#HotkeyInterval;#HotkeyModifierTimeout;#Hotstring;#If;#IfTimeout;#IfWinActive;#Include;#InputLevel;#InstallKeybdHook;#InstallMouseHook;#KeyHistory;#MaxHotkeysPerInterval;#MaxMem;#MaxThreads;#MaxThreadsBuffer;#MaxThreadsPerHotkey;#MenuMaskKey;#NoEnv;#NoTrayIcon;#Persistent;#Requires;#SingleInstance;#UseHook;#Warn;#WinActivateForce
	Ahk被查关键字=i)(^|;)%CandySel%($|;)

;有doc可打开
	if RegExMatch(Ahk关键字表, Ahk被查关键字)
	{
		IfWinNotExist, %Ahk帮助标题%
		{
			;VarSetCapacity(ak, ak_size := 8+5*A_PtrSize+4, 0) ; HH_AKLINK struct
			;NumPut(ak_size, ak, 0, "UInt")
			;NumPut(&CandySel, ak, 8)
			;if !DllCall("HHCtrl.ocx\HtmlHelp", "Ptr", hGui, "str", ahk中文帮助, "UInt", 0x000D, "ptr", &ak)
			;{
				Run, %ahk中文帮助%
				WinWait, %Ahk帮助标题%,, 5
				WinActivate, %Ahk帮助标题%
				sleep, 2000
				wb := WBGet("ahk_class HH Parent")
				StringReplace, 直接打开, CandySel, #, _
				Ahk跳转的地址 = /docs/lib/%直接打开%.htm
				myURL = mk:@MSITStore:%ahk中文帮助%::%Ahk跳转的地址%
				wb.Navigate(myURL)
				wb := ""
			;}
		Return
		}
		IfWinExist,%Ahk帮助标题%
		{
			WinActivate, %Ahk帮助标题%
			gosub monishuru
		}
	}
;没有则搜索
	Else
	{
;是否已经运行
		IfWinNotExist, %Ahk帮助标题%
		{
			Run, %ahk中文帮助%
			WinWait, %Ahk帮助标题%,, 5
		}
		WinActivate, %Ahk帮助标题%
		gosub monishuru2
	}
Return

monishuru:
Thread, NoTimers
sleep,1000
WinGetPos, X, Y,,, %Ahk帮助标题%
mousemove, % X+150, % Y+77

wb := WBGet("ahk_class HH Parent")
sleep,100
wb.document.querySelector("#head > div > div.h-tabs > ul > li:nth-child(2)").click()
wb.document.getElementsByTagName("input")[0].value := CandySel
wb.document.getElementsByTagName("input")[0].focus()
;click
sleep,100
ControlSend,Internet Explorer_Server1,{enter},%Ahk帮助标题%
ControlSend,Internet Explorer_Server1,{enter},%Ahk帮助标题%
wb := ""
return

monishuru2:
Thread, NoTimers
sleep,2500
;send !S
WinGetPos, X, Y,,, %Ahk帮助标题%
mousemove, % X+250, % Y+77

wb := WBGet("ahk_class HH Parent")
sleep,100
wb.document.querySelector("#head > div > div.h-tabs > ul > li:nth-child(3)").click()
wb.document.getElementsByTagName("input")[1].value := CandySel
wb.document.getElementsByTagName("input")[1].focus()
;click
sleep 200
ControlSend,Internet Explorer_Server1,{enter},%Ahk帮助标题%
ControlSend,Internet Explorer_Server1,{enter},%Ahk帮助标题%
wb := ""
return

WBGet(WinTitle="ahk_class IEFrame", Svr#=1) {               ;// based on ComObjQuery docs
   static msg := DllCall("RegisterWindowMessage", "str", "WM_HTML_GETOBJECT")
        , IID := "{0002DF05-0000-0000-C000-000000000046}"   ;// IID_IWebBrowserApp
;//     , IID := "{332C4427-26CB-11D0-B483-00C04FD90119}"   ;// IID_IHTMLWindow2
   SendMessage msg, 0, 0, Internet Explorer_Server%Svr#%, %WinTitle%
   if (ErrorLevel != "FAIL") {
      lResult:=ErrorLevel, VarSetCapacity(GUID,16,0)
      if DllCall("ole32\CLSIDFromString", "wstr","{332C4425-26CB-11D0-B483-00C04FD90119}", "ptr",&GUID) >= 0 {
         DllCall("oleacc\ObjectFromLresult", "ptr",lResult, "ptr",&GUID, "ptr",0, "ptr*",pdoc)
         return ComObj(9,ComObjQuery(pdoc,IID,IID),1), ObjRelease(pdoc)
      }
   }
}