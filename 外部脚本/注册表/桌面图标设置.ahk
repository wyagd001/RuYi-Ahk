global A_icon := Object("�����", "{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "����վ", "{645FF040-5081-101B-9F08-00AA002F954E}", "�û����ļ�", "{59031a47-3f72-44a7-89c5-5595fe6b30ee}", "�������", "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}", "����", "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}", "��", "{031E4825-7B94-4dc3-B131-E946B44C8DD5}")
;global A_icon2 := Object()
global A_iconDy := Object("�����", "vcomputer", "����վ", "vrecycle", "�û����ļ�", "vdocument", "�������", "vcontrol","����", "vweb", "��", "vlib")
global A_iconDy2 := Object("�����", "vcomputer_all", "����վ", "vrecycle_all", "�û����ļ�", "vdocument_all", "�������", "vcontrol_all", "����", "vweb_all", "��", "vlib_all")
global A_iconDy3 := Object("�����", "vcomputer_fsys", "����վ", "vrecycle_fsys", "�û����ļ�", "vdocument_fsys", "�������", "vcontrol_fsys", "����", "vweb_fsys", "��", "vlib_fsys")
global A_iconSt := Object("�����", 0, "����վ", 0, "�û����ļ�", 0, "�������", 0, "����", 0, "��", 0)
global A_iconSt2 := Object("�����", 0, "����վ", 0, "�û����ļ�", 0, "�������", 0, "����", 0, "��", 0)
global A_iconSt3 := Object("�����", 0, "����վ", 0, "�û����ļ�", 0, "�������", 0, "����", 0, "��", 0)
for key in A_icon
{
	A_iconSt[key] := readshoworhide(key)
	A_iconSt2[key] := readshoworhide(key, 1)
}

Gui, Add, Button, x295 y310 w70 h30 gGuiSave, ȷ��
Gui, Add, Button, xp+80 yp w70 h30 gGuiClose, ȡ��
Gui, Add, Button, xp+80 yp w70 h30 gGuiApply, Ӧ��

Gui, Add, Tab, x-4 y1 w530 h300, ����|����
Gui, Tab, ����
Gui, Add, GroupBox, x10 y30 w500 h120, ��ǰ�û�
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvcomputer gdelfollow Checked" A_iconSt["�����"], �����
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvcomputer_fsys gfollowsys Checked" A_iconSt3["�����"], ����ϵͳ
Gui, Add, CheckBox, % "xp+120 yp w80 h20 vvrecycle gdelfollow Checked" A_iconSt["����վ"], ����վ
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvrecycle_fsys gfollowsys Checked" A_iconSt3["����վ"], ����ϵͳ
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvdocument gdelfollow Checked" A_iconSt["�û����ļ�"], �û����ļ�
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvdocument_fsys gfollowsys Checked" A_iconSt3["�û����ļ�"], ����ϵͳ
Gui, Add, CheckBox, % "xp+120 yp w80 h20 vvcontrol gdelfollow Checked" A_iconSt["�������"], �������
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvcontrol_fsys gfollowsys Checked" A_iconSt3["�û����ļ�"], ����ϵͳ
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvweb gdelfollow Checked" A_iconSt["����"], ����
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvweb_fsys gfollowsys Checked" A_iconSt3["�û����ļ�"], ����ϵͳ

Gui, Add, GroupBox, x10 y165 w500 h120, ϵͳ(�����û�)
Gui, Add, CheckBox, % "xp+10 yp+30 w80 h20 vvcomputer_all Checked" A_iconSt2["�����"], �����
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvrecycle_all Checked" A_iconSt2["����վ"], ����վ
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvdocument_all Checked" A_iconSt2["�û����ļ�"], �û����ļ�
Gui, Add, CheckBox, % "xp+150 yp w80 h20 vvcontrol_all Checked" A_iconSt2["�������"], �������
Gui, Add, CheckBox, % "xp-150 yp+30 w80 h20 vvweb_all Checked" A_iconSt2["����"], ����
;Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvlib_all Checked" A_iconSt["��"], ��

Gui, Tab, ����
Gui, Add, GroupBox, x10 y30 w500 h120, ��ǰ�û�(��Ҫ��������ѡ�������Ч)
Gui, Add, CheckBox, % "x20 yp+30 w80 h20 vvlib gdelfollow Checked" A_iconSt["��"], ��
Gui, Add, CheckBox, % "xp+80 yp w80 h20 vvlib_fsys gfollowsys Checked" A_iconSt3["��"], ����ϵͳ
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvpicture Checked" A_iconSt["ͼƬ"], ͼƬ
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvdocument Checked" A_iconSt["�ĵ�"], �ĵ�
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdownload Checked" A_iconSt["����"], ����
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvmusic Checked" A_iconSt["����"], ����
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdesktop Checked" A_iconSt["����"], ����

Gui, Add, GroupBox, x10 y165 w500 h120, ϵͳ(�����û�)(��Ҫ��������ѡ�������Ч)
Gui, Add, CheckBox, % "xp+10 yp+30 w120 h20 vvlib_all Checked" A_iconSt2["��"], ��

gui, show, , ����ͼ�����ʾ/����
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
		A_iconSt[key] := tmp_val
		writeshoworhide(key, !tmp_val)
	}
}
for key, value in A_iconDy2
{
	tmp_val := %value%
	if (A_iconSt2[key] != tmp_val)
	{
		A_iconSt2[key] := tmp_val
		writeshoworhide(key, !tmp_val, 1)
	}
}
return

GuiSave:
gosub GuiApply
Gui, Destroy
exitapp
return

followsys:
Gui, submit, nohide
tmp_val := %A_GuiControl%
;tooltip % A_GuiControl " - " tmp_val
if (tmp_val=1)
{
	for key, value in A_iconDy3
	{
		if (value=A_GuiControl)
		{
			GuiControl,, % A_iconDy[key], 0
			A_iconSt[key] := 0
			delusersetting(key)
			break
		}
	}
}
return

delfollow:
Gui, submit, nohide
tmp_val := %A_GuiControl%
if (tmp_val=1)
{
	for key, value in A_iconDy
	{
		if (value=A_GuiControl)
		{
			GuiControl,, % A_iconDy3[key], 0
			break
		}
	}
}
return

readshoworhide(sKey, alluser:=0)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	if alluser
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	RegRead, OutputVar, %APath%, %tmp_val%
	;msgbox % sKey " - " tmp_val " - " OutputVar " - " ErrorLevel " - " A_LastError 
	if (OutputVar = 1)
	return 0
	if (OutputVar = 0)
	return 1
	if (ErrorLevel=1) && (A_LastError=2)
	{
		A_iconSt3[skey] := 1
	return 0
	}
}

delusersetting(sKey)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	RegDelete, %APath%, %tmp_val%
}

writeshoworhide(sKey, sValue:=0, alluser:=0)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	if alluser
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel"
	RegWrite, REG_DWORD, %APath%, %tmp_val%, %sValue%
	;msgbox % APath " - " tmp_val " - " sValue " - " ErrorLevel " - " A_LastError
	;msgbox % sValue " - " sKey " - " RegKeyExist(sKey)
	if (sValue = 1) && (sKey = "��") && !RegKeyExist(sKey)
	{
		RegWrite, REG_SZ, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{031E4825-7B94-4dc3-B131-E946B44C8DD5}
	}
*/
}

RegKeyExist(sKey, x32:=0) {
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"
	if x32
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace"
	tmp_val := A_icon[sKey]
	Loop, Reg, %APath%, K
	{
		if (A_LoopRegName = tmp_val)
			return, 1
	}
	return 0
}
