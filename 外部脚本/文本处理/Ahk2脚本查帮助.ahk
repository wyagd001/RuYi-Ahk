;|2.0|2023.07.01|1111
CandySel := A_Args[1]
/*
说明：如果是有独立的页面，则直接指向独立页面
否则，就是搜索
*/
Cando_查新版帮助:
	ahk中文帮助 := A_ScriptDir "\..\..\引用程序\2.0\AutoHotkey2.0.chm"
	Ahk帮助标题 := "AutoHotkey v2 中文帮助"
	Ahk关键字表=Array;Block;BlockInput;Break;Buffer;CallbackCreate;CaretGetPos;Catch;Class;Chr;Click;ClipboardAll;ClipWait;ComCall;ComObjActive;ComObjArray;ComObjConnect;ComObject;ComObjFlags;ComObjFromPtr;ComObjGet;ComObjQuery;ComObjType;ComObjValue;ComValue;Continue;Control;ControlAddItem;ControlChooseIndex;ControlChooseString;ControlClick;ControlDeleteItem;ControlFindItem;ControlFocus;ControlGetChecked;ControlGetChoice;ControlGetClassNN;ControlGetEnabled;ControlGetFocus;ControlGetHwnd;ControlGetIndex;ControlGetItems;ControlGetPos;ControlGetStyle;ControlGetText;ControlGetVisible;ControlHide;ControlHideDropDown;ControlMove;ControlSend;ControlSetChecked;ControlSetEnabled;ControlSetStyle;ControlSetText;ControlShow;ControlShowDropDown;CoordMode;Critical;DateAdd;DateDiff;DetectHiddenText;DetectHiddenWindows;DirCopy;DirCreate;DirDelete;DirExist;DirMove;DirSelect;DllCall;Download;Drive;DriveEject;DriveGetCapacity;DriveGetFileSystem;DriveGetLabel;DriveGetList;DriveGetSerial;DriveGetSpaceFree;DriveGetStatus;DriveGetStatusCD;DriveGetType;DriveLock;DriveSetLabel;DriveUnlock;Edit;EditGetCurrentCol;EditGetCurrentLine;EditGetLine;EditGetLineCount;EditGetSelectedText;EditPaste;Else;EnvGet;EnvSet;Exit;ExitApp;FileAppend;FileCopy;FileCreateShortcut;FileDelete;FileEncoding;FileExist;FileGetAttrib;FileGetShortcut;FileGetSize;FileGetTime;FileGetVersion;FileInstall;FileMove;FileOpen;FileRead;FileRecycle;FileRecycleEmpty;FileSelect;FileSetAttrib;FileSetTime;Finally;Float;For;Format;FormatTime;GetKeyName;GetKeySC;GetKeyState;GetKeyVK;GetMethod;Goto;GroupActivate;GroupAdd;GroupClose;GroupDeactivate;Gui;GuiControl;GuiControlGet;GuiControls;Hotkey;Hotstring;If;ImageSearch;index;IniDelete;IniRead;IniWrite;Input;InputBox;InputHook;InStr;Integer;Is;IsLabel;IsObject;IsSet;KeyHistory;KeyWait;ListHotkeys;ListLines;ListVars;ListView;ListViewGetContent;LoadPicture;Loop;LoopFiles;LoopParse;LoopRead;LoopReg;Map;Menu;MenuFromHandle;MenuSelect;MonitorGet;MonitorGetCount;MonitorGetName;MonitorGetPrimary;MonitorGetWorkArea;MouseClick;MouseClickDrag;MouseGetPos;MouseMove;MsgBox;NumGet;NumPut;ObjAddRef;ObjBindMethod;Object;OnClipboardChange;OnError;OnExit;OnMessage;Ord;OutputDebug;Pause;PixelGetColor;PixelSearch;PostMessage;Process;ProcessClose;ProcessExist;ProcessGetName;ProcessGetParent;ProcessSetPriority;ProcessWait;ProcessWaitClose;Random;RegCreateKey;RegDelete;RegDeleteKey;RegExMatch;RegExReplace;RegRead;RegWrite;Reload;Return;Run;RunAs;Send;SendLevel;SendMode;SetBatchLines;SetControlDelay;SetDefaultMouseSpeed;SetEnv;SetExpression;SetFormat;SetKeyDelay;SetMouseDelay;SetNumScrollCapsLockState;SetRegView;SetStoreCapslockMode;SetTimer;SetTitleMatchMode;SetWinDelay;SetWorkingDir;Shutdown;Sleep;Sort;SoundBeep;SoundGet;SoundGetWaveVolume;SoundPlay;SoundSet;SoundSetWaveVolume;SplashTextOn;SplitPath;StatusBarGetText;StatusBarWait;StrCompare;StrGet;String;StrLen;StrLower;StrPtr;StrPut;StrReplace;StrSplit;;SubStr;Suspend;Switch;SysGet;SysGetIPAddresses;Thread;Throw;ToolTip;TraySetIcon;TrayTip;TreeView;Trim;Try;Type;Until;VarSetStrCapacity;VerCompare;While;WinActivate;WinActivateBottom;WinActive;WinClose;WinExist;WinGetClass;WinGetClientPos;WinGetControls;WinGetControlsHwnd;WinGetCount;WinGetID;WinGetIDLast;WinGetList;WinGetMinMax;WinGetPID;WinGetPos;WinGetProcessName;WinGetProcessPath;WinGetStyle;WinGetText;WinGetTitle;WinGetTransColor;WinGetTransparent;WinHide;WinKill;WinMaximize;WinMinimize;WinMinimizeAll;WinMove;WinMoveBottom;WinMoveTop;WinRedraw;WinRestore;WinSetAlwaysOnTop;WinSetEnabled;WinSetRegion;WinSetStyle;WinSetTitle;WinSetTransColor;WinSetTransparent;WinShow;WinWait;WinWaitActive;WinWaitClose;#ClipboardTimeout;#DllLoad;#ErrorStdOut;#HotIf;#HotIfTimeout;#Include;#InputLevel;#MaxThreads;#MaxThreadsBuffer;#MaxThreadsPerHotkey;#NoTrayIcon;#Requires;#SingleInstance;#SuspendExempt;#UseHook;#Warn;#WinActivateForce
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
			;	msgbox % ErrorLevel " - " A_LastError
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
		IfWinNotExist,%Ahk帮助标题%
		{
			Run, %ahk中文帮助%
			WinWait,%Ahk帮助标题%,,5
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
WinGetPos, X, Y,,,%Ahk帮助标题%
mousemove, % X+250, % Y+77
;click

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