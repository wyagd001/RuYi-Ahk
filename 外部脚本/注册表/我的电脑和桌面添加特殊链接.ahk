;��Դ��ַ: http://thinkai.net/page/16
;��������
Gui, Add, Text, x0 y0 w40 h20 , ����:
Gui, Add, Edit, x50 y0 w280 h20 vname,
Gui, Add, Button, x330 y0 w80 h20 gapply, Ӧ��
Gui, Add, Button, x410 y0 w40 h20 ghelp, ��
Gui, Add, Text, x0 y20 w40 h20 , ͼ��
Gui, Add, Picture, x40 y20 w24 h24 vsico,
Gui, Add, Edit, x64 y20 w346 h20 vicon,
Gui, Add, Button, x410 y20 w40 h20 gselectico, ���
Gui, Add, Text, x0 y50 w50 h20 , �Ҽ��˵�
Gui, Add, text, x0 y70 w40 h20 , �˵���
Gui, add, Edit, x40 y70 w100 h20 vmenu_name,
Gui, Add, text, x140 y70 w40 h20 , ������
Gui, add, Edit, x180 y70 w230 h20 vmenu_cmd,
Gui, Add, Button, x410 y70 w40 h20 gadd, ���
Gui, add, ListView, xo y90 w450 h100, id|�Ƿ�Ĭ��|����|����
Gui, Show, , �ҵĵ���/����������� By Thinkai
;��ʼ��
option := object()
option["index"] := 0
Return

add:
gui, submit, nohide ;��ȡ��
if (menu_name and menu_cmd) ;�Ѿ���д
{
	option["index"]++
	Default = ��
	MsgBox, 36, ��ʾ, �Ƿ���ΪĬ���
	IfMsgBox, Yes
	{
		option["default"] := option["index"]
		Default = ��
		loop % LV_GetCount() ;����lv����ʾ
		{
		LV_Modify(A_index, , , "��")
		}
	}
	;��ֵ�Ǹ�����
	option[option["index"]] := object()
	option[option["index"]]["name"] := menu_name
	option[option["index"]]["cmd"] := menu_cmd
	LV_Add("",option["index"],default,menu_name,menu_cmd) ;��ӵ��б� �б�ֻ����ʾ ִ�д�������
	LV_ModifyCol() ;�����п�
	;�����д��
	GuiControl, , menu_name,
	GuiControl, , menu_cmd,
}
Return


apply:
gui, submit, nohide
if (name and icon)
{
	Random, n5, 10000, 99999
	clsid = {FD4DF9E0-E3DE-11CE-BFCF-ABCD1DE%n5%} ;���CLSID
	;if (A_Is64bitOS && (!InStr(A_OSType,"WIN_2003") or !InStr(A_OSType,"WIN_XP") or !InStr(A_OSType,"WIN_2000"))) ;���°�64λϵͳ
	;	item = Software\Classes\Wow6432Node\CLSID\%clsid%
	;Else
		item = Software\Classes\CLSID\%clsid%
	;���������CLSID��
	RegWrite, REG_SZ, HKCU, %item%, , %name% ;��ʾ����
	RegWrite, REG_SZ, HKCU, %item%, InfoTip, �Ҽ��鿴%name%������Ŀ ;��ͣ��ʾ
	RegWrite, REG_SZ, HKCU, %item%, LocalizedString, %name%
	RegWrite, REG_SZ, HKCU, %item%, System.ItemAuthors, �Ҽ��鿴%name%������Ŀ
	RegWrite, REG_SZ, HKCU, %item%, TileInfo, prop:System.ItemAuthors
	RegWrite, REG_SZ, HKCU, %item%\DefaultIcon, , %icon% ;ͼ��
	RegWrite, REG_SZ, HKCU, %item%\InprocServer32, , %SystemRoot%\system32\shdocvw.dll
	RegWrite, REG_SZ, HKCU, %item%\InprocServer32, ThreadingModel, Apartment
	;ѭ���������
	Loop % option["index"]
	{
	mname := option[A_index]["name"]
	mcmd := option[A_index]["cmd"]
	if option["default"] = A_index
		RegWrite, REG_SZ, HKCU, %item%\Shell, , n_%A_Index%
	RegWrite, REG_SZ, HKCU, %item%\Shell\n_%A_Index%, , %mname% ;����
	RegWrite, REG_SZ, HKCU, %item%\Shell\n_%A_Index%\Command, , %mcmd% ;����
	}
	;RegWrite, REG_BINARY, HKCU, %item%, Attributes, 00000000 ;����
	RegWrite, REG_SZ, HKCU, Software\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%clsid%, , %name% ;��ӵ��ҵĵ���
	RegWrite, REG_SZ, HKCU, SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\%clsid%, , %name% ;��ӵ�����
	;����ж��reg
	FileAppend, Windows Registry Editor Version 5.00, %A_ScriptDir%\ж��%name%.reg
	FileAppend, `n[-HKEY_CURRENT_USER\%item%], %A_ScriptDir%\ж��%name%.reg
	FileAppend, `n[-HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\%clsid%], %A_ScriptDir%\ж��%name%.reg
	FileAppend, `n[-HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\%clsid%], %A_ScriptDir%\ж��%name%.reg
	MsgBox, 4128, ��ʾ, �Ѵ���ͼ�꣬���������ֶ�ˢ�£�`n��Ҫж�أ����ڳ���Ŀ¼��`n˫��"ж��%name%.reg"ж��!
}
;���������д
GuiControl, , menu_name,
GuiControl, , menu_cmd,
GuiControl, , icon,
GuiControl, , name,
GuiControl, , sico,
LV_Delete()
option := object()
option["index"] := 0
Return

selectico:
gui +owndialogs
fileselectfile, icon, 1, %lastdir%, ��һͼ���ļ�, ͼ���ļ�(*.ico;*.exe)
if icon =
	Return
GuiControl, , icon, %icon%
guicontrol, , sico, %icon%
Return

help:
MsgBox, 4128, ����, �����ơ�Ϊ���ҵĵ��Ժ�������ʾ������`n��ͼ�ꡱΪ���ҵĵ��Ժ�������ʾ��ͼ��`n���˵��������Ҽ��˵��е�����������ʹ�á�(&e)�����ֿ�ݼ�`n�������С�Ϊ��ʱִ�е����`n`n��Ҫж�أ����ڳ���Ŀ¼��`n˫��ж��xx.regж�ء�, 10
Return

show_obj(obj,menu_name:=""){
if menu_name =
    {
    main = 1
    Random, rand, 100000000, 999999999
    menu_name = %A_Now%%rand%
    }
Menu, % menu_name, add,
Menu, % menu_name, DeleteAll
for k,v in obj
{
if (IsObject(v))
	{
    Random, rand, 100000000, 999999999
	submenu_name = %A_Now%%rand%
    Menu, % submenu_name, add,
    Menu, % submenu_name, DeleteAll
	Menu, % menu_name, add, % k ? "��" k "��[obj]" : "", :%submenu_name%
    show_obj(v,submenu_name)
	}
Else
	{
	Menu, % menu_name, add, % k ? "��" k "��" v: "", MenuHandler
	}
}
if main = 1
    menu,% menu_name, show
}


MenuHandler:
return

GuiClose:
ExitApp