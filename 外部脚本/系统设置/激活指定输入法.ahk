;|2.5|2024.02.15|1549

/*
CandySel := A_Args[1]
Windy_CurWin_id := A_Args[2]
CAthreadid := GetGUIThreadInfo(Windy_CurWin_id)
Gui, Add, Edit, x0 y0 w100 vName
Gui, show, w200 h55
b_index := 0
;msgbox % CAthreadid "-" Sthreadid "-" Windy_CurWin_id
return
*/

/*
; WIn7 64位测试时，任务栏中输入法图标无变化，但是程序的输入法会发生变化
; 但是只有在输入法是搜狗拼音时有效, 如果切换为美式键盘, 则 IME_SET 不能切换回中文拼音

; 在 WIn7 32位中测试, 如果默认输入法为英文键盘, 则程序不能切换输入法
; 但是程序窗口(任何窗口)手动从英文键盘切换到中文搜狗拼音后, 则按下快捷键则能切换到搜狗拼音
; 从上面推断 手动切换过中英输入法的窗口 能使用 IME_SET 设置切换输入法
; 从上推断 如果默认输入法为 搜狗拼音输入法 那么就能直接使用 IME_SET 设置切换输入法

e::
b_index ++
if mod(b_index, 2)=0
{
IME_SET(1, "A")
tooltip 偶数  中文
}
else
{
IME_SET(0, "A")
tooltip 奇数  英文
}
return
*/

/*
; win8 之前的系统 SendMessage 只对当前的进程有效
; WIn7 64位测试，系统程序如资源管理器和记事本无法更改，但是notepad2可以更换输入法, 360 安全浏览器也不能切换
; WIn7 32位测试 所有窗口程序都能切换
w::
	;DllCall("AttachThreadInput", "UInt", CAthreadid, "UInt", Sthreadid, "UInt", 1)
	winget,WinID,id, A
	IME_SetLayout("E0200804", WinID)
	;IME_SetLayout("E0200804", "A")
	;IME_SetLayout("E0200804", Shwnd)
	;DllCall("AttachThreadInput", "UInt", CAthreadid, "UInt", Sthreadid, "UInt", 0)
return
*/

/*
; win7 64位系统在两个输入法下能来回切换（在所有进程中）
; 三个输入法以上时， 只能在最近的两个输入法之间来回切换

r::
b_index ++
if mod(b_index, 2)=0
gosub NextIME
else
gosub preIME
return
*/


CandySel := A_Args[1]
Windy_CurWin_id := A_Args[2]

if !Windy_CurWin_Id   ; 使用动作热键调用时, 不会创建 获取当前窗口信息 的隐藏窗口
{
	WinGetTitle, h_hwnd, 获取当前窗口信息 ;ahk_class AutoHotkeyGUI
	Windy_CurWin_id := StrReplace(h_hwnd, "获取当前窗口信息_")
}
if !CandySel
{
	ControlGetText, CandySel, Edit1, 获取当前窗口信息_
}
;msgbox % Windy_CurWin_id

	; 界面激活时才会生效
Gui, Destroy
Gui, +ToolWindow -caption
Gui, Add, Edit, x0 y0 w1 vName
Gui, show, w1 h1
if (CandySel = "搜狗拼音输入法")
{
	TSF_ChangeCurrentLanguage(2052)
	i := TSF_ActiveLanguageProfile("{E7EA138E-69F8-11D7-A6EA-00065B844310}", "{E7EA138F-69F8-11D7-A6EA-00065B844311}", 2052)
	;tooltip % i

	if (A_OSversion = "Win_7") && (A_ptrsize = 4) && i   ; 未能在 win7 64位下测试成功
	{
		;IME_ActivateKeyboardLayout("E0200804")
		;IME_SET(1, "A")
		IME_SetLayout("E0200804", Windy_CurWin_id)   
		;SetLayout("E0200804", Windy_CurWin_id)
		;msgbox 123123
		;gosub NextIME
	}
	if (A_OSversion = "Win_7") && (A_ptrsize = 8) && i
	{
		RegRead, OutputVar, HKEY_CURRENT_USER\Keyboard Layout\Toggle, Layout Hotkey   ; 切换布局热键
		if (OutputVar=3)
			return
		loop 5
		{
			WinActivate, ahk_id %Windy_CurWin_id%
			if (OutputVar=1)
				send {Alt down}{Shift}{Alt up}
			if (OutputVar=2)
				send {ctrl down}{Shift}{ctrl up}
			sleep 300
			a := IME_GetKeyboardLayout()       ;, b := GetLayoutDisplayName(strreplace(a, "0x"))
			if (a = 0xE0200804)
			{
				;msgbox % a " - " b " - " Bhotkey
				break
			}
		}
	}
}
else if (CandySel = "QQ拼音输入法")
{
	TSF_ChangeCurrentLanguage(2052)
	i := TSF_ActiveLanguageProfile("{AE51F1C0-807F-4A64-AC55-F2ADF92E2603}", "{96EC4774-55A1-498B-827F-E95D5445B6C1}", 2052)
}
sleep 200
Gui, Destroy
return

TSF_ChangeCurrentLanguage(langid)
{
	IID_ITFInputProcessorProfiles := "{1F02B6C5-7842-4EE6-8A0B-9A24183A95CA}"
	CLSID_InputProcessorProfile := "{33c53a50-f456-4884-b049-85fd643ecfed}"
	pIPP := ComObjCreate(CLSID_InputProcessorProfile, IID_ITFInputProcessorProfiles)
	h := DllCall(VTable(pIPP, 14), "ptr", pIPP, "uint", langid)
	;msgbox % h " - " ErrorLevel " - " A_LastError
	return h
}

/*
q::
Gui, Add, Edit, x0 y0 w10 vName
gui, show, w200 h100
IME_UnloadLayout(0x04090409)
*/
; win7_64位下测试无效
IME_ActivateKeyboardLayout(dwLayout)
{
	HKL := DllCall("LoadKeyboardLayout", "Str", dwLayout, "UInt", 1, "UInt")
	;msgbox % dec2hex(hkl)
	DllCall("ActivateKeyboardLayout", "UInt", HKL, "UInt", 256)
	DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, HKL)
}

NextIME:
DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, DllCall("ActivateKeyboardLayout", UInt, 1, UInt, 256))
;-- 对当前窗口激活下一输入法
Return

PreIME:
DllCall("SendMessage", UInt, WinActive("A"), UInt, 80, UInt, 1, UInt, DllCall("ActivateKeyboardLayout", UInt, 0, UInt, 256))
;-- 对当前窗口激活上一输入法
Return

/*
---------------------------
激活指定输入法.ahk
---------------------------
1: 0x08040804   美式键盘
2: 0xE0200804   搜狗

---------------------------
确定   w
---------------------------

w::
msgbox % IME_GetKeyboardLayoutList()
return
*/

/*
w::
IME_UnloadLayout(0xE0200804)
IME_UnloadLayout(0x04090409)
return
*/

; dwLayout 参数为数字 例如 0xE01F0804
IME_UnloadLayout(dwLayout)
{
	DllCall("UnloadKeyboardLayout", "uint",dwLayout)
	return
}

TSF_ActiveLanguageProfile(clsid, guid, langid)
{
	IID_ITFInputProcessorProfiles := "{1F02B6C5-7842-4EE6-8A0B-9A24183A95CA}"
	CLSID_InputProcessorProfile := "{33c53a50-f456-4884-b049-85fd643ecfed}"
	pIPP := ComObjCreate(CLSID_InputProcessorProfile, IID_ITFInputProcessorProfiles)
	VarSetCapacity(hclsid, 16, 0)
	h := DllCall("Ole32.dll\CLSIDFromString", "str", clsid, "ptr", &hclsid)
	VarSetCapacity(hguid, 16, 0)
	DllCall("Ole32.dll\IIDFromString", "str", guid, "ptr", &hguid)
	h := DllCall(VTable(pIPP, 10), "ptr", pIPP, "str", hclsid, "uint", langid, "str", hguid)
	;msgbox % h " - " ErrorLevel " - " A_LastError
	return h
}

VTable(ppv, idx) {
	Return NumGet(NumGet(ppv+0) + A_PtrSize * idx)
}

IME_GetKeyboardLayoutList()
{
	if count := DllCall("GetKeyboardLayoutList", "UInt", 0, "Ptr", 0)
		VarSetCapacity(hklbuf, count*A_PtrSize, 0)
	DllCall("GetKeyboardLayoutList", "UInt", count, "UPtr", &hklbuf)
	Loop, %count%
	{
		HKL := NumGet(hklbuf, A_PtrSize*(A_Index-1), "Uint")   ;  32位中 Ptr 改为 UPtr 有效
		HKL := Hex2Str(HKL, 8, true)
		HKLList .= A_Index ": " HKL "`n"
	}
	return HKLList
}

/*
w::
msgbox % IME_GetKeyboardLayout()
return
*/

/*
;1: 0x08040804   美式键盘
;2: 0xE0200804   搜狗
*/

;                          Ptr       UPtr
; 英语美国 美式键盘    0x4090409    0x4090409
; 中文简体 美式键盘    0x8040804    0x8040804
; 智能ABC             -0x1FE0F7FC   0xE01F0804
; 搜狗拼音            -0x1FDDF7FC   0xE0220804
IME_GetKeyboardLayout(WinTitle="A")
{
	ControlGet,hwnd,HWND,,,%WinTitle%
	ThreadID := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "Ptr", 0 )
	; ThreadID 指定线程id，0 表示本进程
	HKL := DllCall("GetKeyboardLayout", "UInt", ThreadID, "UInt") ; UPtr, Ptr 感觉都不行
hWord	:= HKL >> 16
lWord	:= HKL & 0xFFFF
oHKL := strreplace(dec2hex(hWord) "0" dec2hex(lWord), "0x")
;tooltip % oHKL "`n" dec2hex(hWord) "|" hWord "`n" dec2hex(lWord) "|" lWord
	HKL := dec2hex(HKL)

Return HKL
}


/*
w::
tooltip % IME_GetKeyboardLayoutName()
return
*/

; win8之前只对调用调用线程或当前进程有效，
; 即只对本脚本有效 例如脚本的Gui界面的edit输入控件中切换，对其他程序无效。
; win7 测试 搜狗 E0220804 智能ABC E01F0804
IME_GetKeyboardLayoutName()
{
	VarSetCapacity(Str, 16)
	DllCall("GetKeyboardLayoutName", "Str", Str)
	Return Str
}

GetLayoutDisplayName(subkey, usemui := 1)
{
	Static key := "SYSTEM\CurrentControlSet\Control\Keyboard Layouts"
	RegRead, mui, HKLM, %key%\%subkey%, Layout Display Name
	if (!mui OR !usemui)
		RegRead, Dname, HKLM, %key%\%subkey%, Layout Text
	else
		Dname := SHLoadIndirectString(mui)
	Return Dname
}

SHLoadIndirectString(in)	; uses WStr for both in and out
{
	VarSetCapacity(out, 2*(sz:=256), 0)
	DllCall("shlwapi\SHLoadIndirectString", "Str", in, "Str", out, "UInt", sz, "Ptr", 0)
	return out
}

/*
q::
	winget,WinID,id, A
	SetLayout("E0040804", WinID)
return
*/

SetLayout(Layout, WinID:=""){
	DllCall("SendMessage", "UInt", WinID=""?WinExist("A"):WinID, "UInt", "80", "UInt", "1", "UInt", (DllCall("LoadKeyboardLayout", "Str", Layout, "UInt", "257", "UInt")))
}

IME_SetLayout(dwLayout, WinID := "A"){  ; 修改当前窗口输入法
	if (WinID = "A") or (WinID = "")
	{
		whwnd := WinExist("A")
		;msgbox 222
	}
	else
		whwnd := WinID
	HKL := DllCall("LoadKeyboardLayout", "Str", dwLayout, "UInt", 1, "UInt")
	;msgbox % dec2hex(HKL)
	ControlGetFocus, ctl, ahk_id %whwnd%
	; win8 之前的系统 SendMessage 只对当前的进程有效
	; WIn7 64位测试，系统程序如资源管理器和记事本无法更改，但是notepad2可以更换输入法
	SendMessage, 0x50, 1, HKL, %ctl%, ahk_id %whwnd%
	;msgbox % dec2hex(HKL) "-" ctl "-" whwnd
}

GetGUIThreadInfo(WinID := "A")
{
	if (WinID = "A") or (WinID = "")
	{
		whwnd := WinExist("A")
	}
	else
		whwnd := WinID

	ControlGet, chwnd, HWND,,, ahk_id %whwnd%

	vTID := DllCall("user32\GetWindowThreadProcessId", Ptr, whWnd, UIntP, 0, UInt)
	ptrSize := !A_PtrSize ? 4 : A_PtrSize
	VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	return  hwnd := DllCall("GetGUIThreadInfo", "Uint", vTID, "Ptr", &stGTI)
	             ? NumGet(stGTI, 8+PtrSize, "Ptr") : chwnd
}


/*
w::
tooltip % IME_Get()
return
*/

;-----------------------------------------------------------
; IME状态的获取
;  WinTitle="A"    対象Window
;  返回值          1:ON / 0:OFF
;-----------------------------------------------------------
IME_GET(WinTitle="A")  {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , Ptr, DllCall("imm32\ImmGetDefaultIMEWnd", Ptr,hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          , UPtr, 0x0005  ;wParam  : IMC_GETOPENSTATUS
          ,  Ptr, 0)      ;lParam  : 0
}

/*
w::
tooltip % IME_Set(0)
return
*/

;-----------------------------------------------------------
; IME_SET 设置输入法状态
; SetSts := 0 英文
; SetSts := 1 中文
; IME状态的设置
;   SetSts          1:ON / 0:OFF
;   WinTitle="A"    対象Window
;   返回值          0:成功 / 0以外:失败
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle="A")    {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , Ptr, DllCall("imm32\ImmGetDefaultIMEWnd", Ptr, hwnd)
          , UInt, 0x0283  ;Message : WM_IME_CONTROL
          , UPtr, 0x006   ;wParam  : IMC_SETOPENSTATUS
          ,  Ptr, SetSts) ;lParam  : 0 or 1
}

;===========================================================================
;    0000xxxx    假名输入
;    0001xxxx    罗马字输入方式
;    xxxx0xxx    半角
;    xxxx1xxx    全角
;    xxxxx000    英数
;    xxxxx001    平假名
;    xxxxx011    片假名

; IME输入模式(所有IME共有)
;   DEC  HEX    BIN
;     0 (0x00  0000 0000)  假名   半英数
;     3 (0x03  0000 0011)         半假名
;     8 (0x08  0000 1000)         全英数
;     9 (0x09  0000 1001)         全字母数字
;    11 (0x0B  0000 1011)         全片假名
;    16 (0x10  0001 0000)   罗马字半英数
;    19 (0x13  0001 0011)         半假名
;    24 (0x18  0001 1000)         全英数
;    25 (0x19  0001 1001)         平假名
;    27 (0x1B  0001 1011)         全片假名

;  ※ 区域和语言选项 - [详细信息] - 高级设置
;     - 将高级文字服务支持应用于所有程序
;    当打开时似乎无法获取该值
;    (谷歌日语输入β必须在此打开，所以无法获得值)

;-------------------------------------------------------
; 获取IME输入模式
;   WinTitle="A"    対象Window
;   返回值          输入模式
;--------------------------------------------------------

; win7 x32
; 中文简体 美式键盘  返回 0。
; 
;               QQ拼音输入法中文输入模式   QQ拼音英文输入模式     搜狗输入法中文      搜狗输入法英文
; 半角+中文标点        1025                                        268436481(1025)
; 半角+英文标点           1　                    1024              268435457(1)        268435456(0)
; 全角+中文标点        1033                                        268436489(1033)
; 全角+英文标点           9                      1032              268435465(9)        268435464(8)

;                智能ABC中文输入标准模式    智能ABC中文输入双打模式    智能ABC英文标准   智能ABC英文双打
; 半角+中文标点        1025                   -2147482623(1025)          1024               -2147482624
; 半角+英文标点           1                   -2147483647(1)                0               -2147483648
; 全角+中文标点        1033                   -2147482615(1033)          1032               -2147482616
; 全角+英文标点           9                   -2147483639(9)                8               -2147483640


; win7 32
; 智能ABC, 微软拼音  1
; 中文简体- 美式键盘  1

; win10 64
; 手心输入法  英文  1  无法根据 IME_GetConvMode  判断手心输入法的中英文输入状态
; 手心输入法  中文  1
; 微软拼音    英文  0
; 微软拼音    中文  1025

/*
q::
tooltip % IME_GetConvMode()
return
*/

IME_GetConvMode(WinTitle="A")   {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
          , "UInt", 0x0283  ;Message : WM_IME_CONTROL
          ,  "Int", 0x001   ;wParam  : IMC_GETCONVERSIONMODE
          ,  "Int", 0) & 0xffff     ;lParam  : 0 ， & 0xffff 表示只取低16位
}

/*
; 测试时 搜狗的全半角切换快捷键关闭时,不能切换到搜狗的全角
w::
tooltip % IME_SetConvMode(1)
return
*/

;-------------------------------------------------------
; IME输入模式设置
;   ConvMode        输入模式
;   WinTitle="A"    対象Window
;   返回值          0:成功 / 0以外:失败
;--------------------------------------------------------
IME_SetConvMode(ConvMode, WinTitle="A")   {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
          , "UInt", 0x0283      ;Message : WM_IME_CONTROL
          , "UPtr", 0x002       ;wParam  : IMC_SETCONVERSIONMODE
          ,  "Ptr", ConvMode)   ;lParam  : CONVERSIONMODE
}

/*
q::
tooltip % IME_GetSentenceMode()
return
*/

;===========================================================================
; IME 转换模式(ATOK由ver.16测试，可能会略有不同，具体取决于版本)

;   MS-IME  0:无转换 / 1:人名/地名                    / 8:通用    /16:口语
;   ATOK系  0:固定   / 1:复合词              / 4:自动 / 8:联文
;   WXG              / 1:复合词  / 2:无变换  / 4:自动 / 8:联文
;   SKK系            / 1:正常(不存在其他模式?)
;   Googleβ                                          / 8:正常
;------------------------------------------------------------------
; IME 转换模式获取
;   WinTitle="A"    対象Window
;   返回值 MS-IME  0:无转换 1:人名/地名               8:一般    16:口语
;          ATOK系  0:固定   1:复合词           4:自动 8:联文
;          WXG4             1:复合词  2:无转换 4:自动 8:联文
;------------------------------------------------------------------
; 此消息由应用程序发送到输入法编辑器(IME)窗口，以获得当前句子模式。
; 返回IME语句模式值的组合。
; 测试时，WIN7 下切换到 搜狗拼音/智能ABC/QQ拼音 时返回值都为0，英文键盘返回值为8
IME_GetSentenceMode(WinTitle="A")   {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
          , "UInt", 0x0283  ;Message : WM_IME_CONTROL
          , "UPtr", 0x003   ;wParam  : IMC_GETSENTENCEMODE
          ,  "Ptr", 0)      ;lParam  : 0
}

;----------------------------------------------------------------
; IME 转换模式设置
;   SentenceMode
;       MS-IME  0:無変換 1:人名/地名               8:一般    16:話し言葉
;       ATOK系  0:固定   1:複合語           4:自動 8:連文節
;       WXG              1:複合語  2:無変換 4:自動 8:連文節
;   WinTitle="A"    対象Window
;   返回值          0:成功 / 0以外:失败
;-----------------------------------------------------------------
IME_SetSentenceMode(SentenceMode,WinTitle="A")  {
    hwnd :=GetGUIThreadInfo_hwndActive(WinTitle)
    return DllCall("SendMessage"
          , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd)
          , "UInt", 0x0283          ;Message : WM_IME_CONTROL
          , "UPtr", 0x004           ;wParam  : IMC_SETSENTENCEMODE
          ,  "Ptr", SentenceMode)   ;lParam  : SentenceMode
}

GetGUIThreadInfo_hwndActive(WinTitle="A")
{
	ControlGet,hwnd,HWND,,,%WinTitle%
	if	(WinActive(WinTitle))	{
	  ptrSize := !A_PtrSize ? 4 : A_PtrSize
	  VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
	  NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
	return  hwnd := DllCall("GetGUIThreadInfo", "Uint", 0, "Ptr", &stGTI)
	             ? NumGet(stGTI, 8+PtrSize, "Ptr") : hwnd
  }
  else
  return  hwnd
}


Hex2Str(val, len, x:=false)
;================================================================
{
	SetFormat, IntegerFast, D
	VarSetCapacity(out, len*2, 32)
	DllCall("msvcrt\sprintf", "AStr", out, "AStr", "%0" len "I64X", "UInt64", val, "CDecl")
	Return x ? "0x" out : out
}

dec2hex(d)
{
	BackUp_FmtInt := A_FormatInteger
	SetFormat, integer, H
	h := d+0
	SetFormat, IntegerFast, %BackUp_FmtInt%
	return h
}