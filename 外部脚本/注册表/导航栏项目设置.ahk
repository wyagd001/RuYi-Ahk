global A_icon := Object("�ղؼ�", "{323CA680-C24D-4099-B94D-446DD2D7249E}", "��", "{031E4825-7B94-4dc3-B131-E946B44C8DD5}", "��ͥ��", "{B4FB3F98-C1EA-428d-A78A-D1F5659CBA93}", "����", "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}", "OneDrive", "{018D5C66-4533-4307-9B53-224DE2ED1FE6}", "���ٷ���", "{679f85cb-0220-4080-b29b-5540cc05aab6}")
global A_iconev := Object("�ղؼ�", "a0900100", "��", "b080010d", "��ͥ��", "b084010c", "����", "b0040064", "OneDrive", "f080004d", "���ٷ���", "a0100000")
global A_icondv := Object("�ղؼ�", "a9400100", "��", "b090010d", "��ͥ��", "b094010c", "����", "b0940064", "OneDrive", "f090004d", "���ٷ���", "a0600000")
global A_iconDy := Object("�ղؼ�", "vfav", "��", "vlib", "��ͥ��", "vhomegroup", "����", "vweb", "OneDrive", "voned", "���ٷ���", "vquickac")
global A_iconDy2 := Object("�ղؼ�", "vfav_32", "��", "vlib_32", "��ͥ��", "vhomegroup_32", "����", "vweb_32", "OneDrive", "voned_32", "���ٷ���", "vquickac_32")
global A_iconSt := Object("�ղؼ�", 0, "��", 0, "��ͥ��", 0, "����", 0, "OneDrive", 0, "���ٷ���", 0)
global A_iconSt2 := Object("�ղؼ�", 0, "��", 0, "��ͥ��", 0, "����", 0, "OneDrive", 0, "���ٷ���", 0)
for key in A_icon
{
	A_iconSt[key] := readshoworhide(key)
	A_iconSt2[key] := readshoworhide(key, 1)
}
if (A_PtrSize = 8)
{
	if FileExist(A_ScriptDir "\x64\SetACL.exe")
		AbsP := A_ScriptDir "\x64\SetACL.exe"
	else if FileExist(A_ScriptDir "\..\���ó���\x64\SetACL.exe")
	{
		VarSetCapacity(AbsP,260,0)
		DllCall("shlwapi\PathCombineW", "Str", AbsP, "Str", A_ScriptDir, "Str", "..\���ó���\x64\SetACL.exe")
	}
	else if FileExist(A_ScriptDir "\..\..\���ó���\x64\SetACL.exe")
	{
		VarSetCapacity(AbsP,260,0)
		DllCall("shlwapi\PathCombineW", "Str", AbsP, "Str", A_ScriptDir, "Str", "..\..\���ó���\x64\SetACL.exe")
	}
	else
		AbsP := A_ScriptDir "\SetACL.exe"
}
else
{
	if FileExist(A_ScriptDir "\x32\SetACL.exe")
		AbsP := A_ScriptDir "\x32\SetACL.exe"
	else if FileExist(A_ScriptDir "\..\���ó���\x64\SetACL.exe")
	{
		VarSetCapacity(AbsP,260,0)
		DllCall("shlwapi\PathCombineW", "Str", AbsP, "Str", A_ScriptDir, "Str", "..\���ó���\x64\SetACL.exe")
	}
	else if FileExist(A_ScriptDir "\..\..\���ó���\x32\SetACL.exe")
	{
		VarSetCapacity(AbsP,260,0)
		DllCall("shlwapi\PathCombineW", "Str", AbsP, "Str", A_ScriptDir, "Str", "..\..\���ó���\x64\SetACL.exe")
	}
	else
		AbsP := A_ScriptDir "\SetACL.exe"
}
global AbsP

Gui, Add, Button, x185 y310 w100 h30 gRestartExplorer, Ӧ�ò���������
Gui, Add, Button, xp+110 yp w70 h30 gGuiSave, ȷ��
Gui, Add, Button, xp+80 yp w70 h30 gGuiClose, ȡ��
Gui, Add, Button, xp+80 yp w70 h30 gGuiApply, Ӧ��

Gui, Add, Tab, x-4 y1 w530 h300, ��������Ŀ|�����ļ���
Gui, Tab, ��������Ŀ
Gui, Add, GroupBox, x10 y30 w500 h120,��������Ŀ(ȡ�����Ӧ������ͼ�꽫��ɾ��)
Gui, Add, CheckBox, % "xp+10 yp+30 w80 h20 vvfav Checked" A_iconSt["�ղؼ�"], �ղؼ�
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvlib Checked" A_iconSt["��"], ��
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvhomegroup Checked" A_iconSt["��ͥ��"], ��ͥ��
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvweb Checked" A_iconSt["����"], ����
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvoned Checked" A_iconSt["OneDrive"], OneDrive
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvquickac Checked" A_iconSt["���ٷ���"], ���ٷ���

Gui, Add, GroupBox, x10 y165 w500 h120, 32λ����򿪶Ի���(�����������ö���Ҫ����explorer�Żῴ��Ч��)
Gui, Add, CheckBox, % "xp+10 yp+30 w80 h20 vvfav_32 Checked" A_iconSt2["�ղؼ�"], �ղؼ�
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvlib_32 Checked" A_iconSt2["��"], ��
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvhomegroup_32 Checked" A_iconSt2["��ͥ��"], ��ͥ��
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvweb_32 Checked" A_iconSt2["����"], ����
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvoned_32 Checked" A_iconSt2["OneDrive"], OneDrive
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvquickac_32 Checked" A_iconSt2["���ٷ���"], ���ٷ���

Gui, Tab, �����ļ���
Gui, Add, GroupBox, x10 y30 w500 h120, ����
Gui, Add, CheckBox, % "xp+10 yp+30 w120 h20 vv3d Checked" A_iconSt["3d"], ����Ŀ
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvpicture Checked" A_iconSt["ͼƬ"], ͼƬ
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvdocument Checked" A_iconSt["�ĵ�"], �ĵ�
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdownload Checked" A_iconSt["����"], ����
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvmusic Checked" A_iconSt["����"], ����
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdesktop Checked" A_iconSt["����"], ����

Gui, Add, GroupBox, x10 y165 w500 h120, 32λ����򿪶Ի���
Gui, Add, CheckBox, % "xp+10 yp+30 w120 h20 vv3d_32 Checked" A_iconSt2["3d"], ����Ŀ

gui, show, , ��Դ��������������Ŀ����ʾ/����
return

GuiEscape:
GuiClose:
Gui, Destroy
exitapp
return

GuiApply:
Gui, submit, nohide
for key, value in A_iconDy
{
	tmp_val := %value%
	if (A_iconSt[key] != tmp_val)
	{
		;msgbox % A_iconSt2[key] " - " tmp_val
		A_iconSt[key] := tmp_val
		writeshoworhide(key, tmp_val)
	}
}
for key, value in A_iconDy2
{
	tmp_val := %value%
	if (A_iconSt2[key] != tmp_val)
	{
		;msgbox % A_iconSt2[key] " - " tmp_val
		A_iconSt2[key] := tmp_val
		writeshoworhide(key, tmp_val, 1)
	}
}
return

GuiSave:
gosub GuiApply
Gui, Destroy
exitapp
return

RestartExplorer:
gosub GuiApply
RestartExplorer()
return

readshoworhide(sKey, x32:=0)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_CLASSES_ROOT\CLSID\" tmp_val "\ShellFolder"
	if x32
		APath := "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\" tmp_val "\ShellFolder"
	
	RegRead, OutputVar, %APath%, Attributes
	tmp_val2 := "0x" A_iconev[sKey]
	tmp_val2 := tmp_val2 + 0x0
	;msgbox % tmp_val " - " tmp_val2 " - " A_iconev[sKey] " - " OutputVar
	if (OutputVar = tmp_val2)
	return 1
	else
	return 0
}

writeshoworhide(sKey, show:=1, x32:=0)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_CLASSES_ROOT\CLSID\" tmp_val "\ShellFolder"
	if x32
		APath := "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\" tmp_val "\ShellFolder"

	if show
		tmp_val2 := "0x" A_iconev[sKey]
	else
		tmp_val2 := "0x" A_icondv[sKey]
	tmp_val2 := tmp_val2 + 0x0
	RegWrite, REG_DWORD, %APath%, Attributes, %tmp_val2%
	if ErrorLevel && (A_LastError = 5)
	;msgbox % sKey " - " ErrorLevel " - " A_LastError
	{
		run, %AbsP% -on "%APath%" -ot reg -actn setowner -ownr "n:Administrators",,hide
		sleep 1000
		run, %AbsP% -on "%APath%" -ot reg -actn ace -ace "n:Administrators;p:full",,hide
		sleep 1000
		RegWrite, REG_DWORD, %APath%, Attributes, %tmp_val2%
		if ErrorLevel
			msgbox % AbsP " - " ErrorLevel " - " A_LastError
	}
}

RegKeyExist(sKey, x32:=0) {
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace"
	if x32
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace"
	tmp_val := A_icon[sKey]
	Loop, Reg, %APath%, K
	{
		if (A_LoopRegName = tmp_val)
			return, 1
	}
	return 0
}

RestartExplorer()
{
	run, taskkill /f /im explorer.exe,,hide
	sleep 1000
	run, explorer.exe
}