global A_icon := Object("��Ƶ", "{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}", "ͼƬ", "{24ad3ad4-a569-4530-98e1-ab02f9417aa8}", "�ĵ�", "{d3162b92-9365-467a-956b-92703aca08af}", "����", "{088e3905-0323-4b02-9826-5d99428e115f}", "����", "{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}", "����", "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}", "3D", "{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}")
global A_icon2 := Object("��Ƶ", "{35286a68-3c57-41a1-bbb1-0eae73d76c95}", "ͼƬ", "{0ddd015d-b06c-45d5-8c4c-f59713854639}", "�ĵ�", "{f42ee2d3-909f-4907-8871-4c22fc0bf756}", "����", "{7d83ee9b-2244-4e70-b1f5-5393042af1e4}", "����", "{a0c69a99-21c8-4671-8703-7934162fcf1d}", "����", "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}", "3D", "{31C0DD25-9439-4F12-BF41-7FF4EDA38722}")
global A_iconDy := Object("��Ƶ", "vvideo", "ͼƬ", "vpicture", "�ĵ�", "vdocument", "����", "vdownload","����", "vmusic","����", "vdesktop", "3D", "v3d")
global A_iconDy2 := Object("��Ƶ", "vvideo_32", "ͼƬ", "vpicture_32", "�ĵ�", "vdocument", "����", "vdownload_32","����", "vmusic_32","����", "vdesktop_32", "3D", "v3d_32")
global A_iconSt := Object("��Ƶ", 0, "ͼƬ", 0, "�ĵ�", 0, "����", 0,"����", 0,"����", 0)
global A_iconSt2 := Object("��Ƶ", 0, "ͼƬ", 0, "�ĵ�", 0, "����", 0,"����", 0,"����", 0)
for key in A_icon
{
	A_iconSt[key] := readshoworhide(key)
	A_iconSt2[key] := readshoworhide(key, 1)
}

Gui, Add, Button, x295 y310 w70 h30 gGuiSave, ȷ��
Gui, Add, Button, xp+80 yp w70 h30 gGuiClose, ȡ��
Gui, Add, Button, xp+80 yp w70 h30 gGuiApply, Ӧ��

Gui, Add, Tab, x-4 y1 w530 h300, 6���ļ���|�����ļ���
Gui, Tab, 6���ļ���
Gui, Add, GroupBox, x10 y30 w500 h120, �˵���6���ļ���ͼ��
Gui, Add, CheckBox, % "xp+10 yp+30 w40 h20 vvvideo Checked" A_iconSt["��Ƶ"], ��Ƶ
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvpicture Checked" A_iconSt["ͼƬ"], ͼƬ
Gui, Add, CheckBox, % "xp-150 yp+30 w40 h20 vvdocument Checked" A_iconSt["�ĵ�"], �ĵ�
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvdownload Checked" A_iconSt["����"], ����
Gui, Add, CheckBox, % "xp-150 yp+30 w40 h20 vvmusic Checked" A_iconSt["����"], ����
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvdesktop Checked" A_iconSt["����"], ����

Gui, Add, GroupBox, x10 y165 w500 h120, 32λ����(�򿪶Ի����)
Gui, Add, CheckBox, % "xp+10 yp+30 w40 h20 vvvideo_32 Checked" A_iconSt2["��Ƶ"], ��Ƶ
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvpicture_32 Checked" A_iconSt2["ͼƬ"], ͼƬ
Gui, Add, CheckBox, % "xp-150 yp+30 w40 h20 vvdocument_32 Checked" A_iconSt2["�ĵ�"], �ĵ�
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvdownload_32 Checked" A_iconSt2["����"], ����
Gui, Add, CheckBox, % "xp-150 yp+30 w40 h20 vvmusic_32 Checked" A_iconSt2["����"], ����
Gui, Add, CheckBox, % "xp+150 yp w40 h20 vvdesktop_32 Checked" A_iconSt2["����"], ����

Gui, Tab, �����ļ���
Gui, Add, GroupBox, x10 y30 w500 h120, �����ļ���ͼ��
Gui, Add, CheckBox, % "xp+10 yp+30 w120 h20 vv3d Checked" A_iconSt["3d"], 3D ����
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvpicture Checked" A_iconSt["ͼƬ"], ͼƬ
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvdocument Checked" A_iconSt["�ĵ�"], �ĵ�
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdownload Checked" A_iconSt["����"], ����
;Gui, Add, CheckBox, % "xp-150 yp+30 w120 h20 vvmusic Checked" A_iconSt["����"], ����
;Gui, Add, CheckBox, % "xp+150 yp w120 h20 vvdesktop Checked" A_iconSt["����"], ����

Gui, Add, GroupBox, x10 y165 w500 h120, 32λ����򿪶Ի���
Gui, Add, CheckBox, % "xp+10 yp+30 w120 h20 vv3d_32 Checked" A_iconSt2["3d"], 3D ����

gui, show, , �˵������ļ���ͼ�����ʾ/����
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
		writeshoworhide(key, tmp_val)
	}
}
for key, value in A_iconDy2
{
	tmp_val := %value%
	if (A_iconSt2[key] != tmp_val)
	{
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

readshoworhide(sKey, x32:=0)
{
	if !x32
	{
		if !RegKeyExist(sKey)
		return 0
	}
	tmp_val := A_icon2[sKey]
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\" tmp_val "\PropertyBag"
	if x32
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\" tmp_val "\PropertyBag"
	
	RegRead, OutputVar, %APath%, ThisPCPolicy
	;msgbox % sKey " - " tmp_val " - " OutputVar
	if (OutputVar = "Hide")
	return 0
	else
	return 1
}

writeshoworhide(sKey, show:=1, x32:=0)
{
	tmp_val := A_icon[sKey]
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\" tmp_val
	if x32
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\" tmp_val
	if show && !RegKeyExist(sKey, x32)
	{
		RegWrite, REG_SZ, %APath%
	}

	tmp_val := A_icon2[sKey]
	APath := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\" tmp_val "\PropertyBag"
	if x32
		APath := "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\" tmp_val "\PropertyBag"
	if show
	{
		RegWrite, REG_SZ, %APath%, ThisPCPolicy, Show
		;msgbox % APath " - " ErrorLevel " - " A_LastError 
	}
	else
	{
		RegWrite, REG_SZ, %APath%, ThisPCPolicy, Hide
		;msgbox % APath " - " ErrorLevel " - " A_LastError 
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
