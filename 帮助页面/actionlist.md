---
layout: default
title: 如意百宝箱-Ahk
description: 如意百宝箱-Ahk 内置动作列表
---

[返回主页](index.md)

# [](#header-2) 内置动作列表

| 动作编号 | 图标码 | 按钮名称 | 动作对象 | 描述 | 动作 |
| ----------- | ----------- | ----------- | ----------- | ----------- |----------- |
|999|E710|添加按钮|如意面板|为面板的按钮指定要执行的动作|Cando&#124;BAdd|
|[1001](http://127.0.0.1:5151/runcom?aabb=1001)|E703|电脑图标|无条件|设置我的电脑中显示的图标(视频, 图片等六个文件夹..)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\此电脑图标设置.ahk"|
|[1002](http://127.0.0.1:5151/runcom?aabb=1002)|EE3F|桌面图标|无条件|设置桌面中显示的图标(此电脑, 回收站, 网络..)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\桌面图标设置.ahk"|
|[1003](http://127.0.0.1:5151/runcom?aabb=1003)|E71D|导航栏|无条件|资源管理器左侧导航栏中项目的设置(收藏夹, 库, 快速启动..)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\导航栏项目设置.ahk"|
|[1004](http://127.0.0.1:5151/runcom?aabb=1004)|E7AC|打开方式|无条件|查看扩展名的打开方式, 更改图标|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\文件打开方式查看.ahk"|
|[1005](http://127.0.0.1:5151/runcom?aabb=1005)|E703|电脑桌面图标|无条件|我的电脑和桌面添加自定义的链接图标|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\我的电脑和桌面添加特殊链接.ahk"|
|[1006](http://127.0.0.1:5151/runcom?aabb=1006)|E8AD|[快捷方式](/actions/1006.md)|无条件|设置快捷方式的小箭头图标和快捷方式字样|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\快捷方式箭头图标设置.ahk"|
|1007|f19d|资源管理器|菜单|资源管理器动作面板|menu&#124;资源管理器|
|1008|F8B0|注册表相关|子面板||gui&#124;系统优化|
|1009|e16d|复制路径|资源管理器|复制资源管理器当前窗口路径|setclip&#124;%Windy_CurWin_FolderPath%|
|1010|EDE3|通用菜单|菜单|选中文件的通用动作菜单|menu&#124;文件通用|
|1011|E70F|记事本打开|选中文件|使用记事本打开选定文件|openwith&#124;Notepad.exe|
|1012|E756|[CMD](/actions/1012.md)|资源管理器|打开cmd, 并跳转到当前资源管理器窗口路径|run&#124;cmd.exe /k cd /d "%Windy_CurWin_FolderPath%"|
|[1013](http://127.0.0.1:5151/runcom?aabb=1013)|f0b2|程序和功能|无条件|打开系统的程序管理删除界面|run&#124;appwiz.cpl|
|[1014](http://127.0.0.1:5151/runcom?aabb=1014)|ea6c|计算机管理|无条件|打开计算机管理(任务计划, 事件查看, 共享文件夹, 用户和组, 设备管理器, 磁盘管理, 服务管理)|run&#124;compmgmt.msc|
|[1015](http://127.0.0.1:5151/runcom?aabb=1015)|e9f5|服务管理|无条件|打开服务管理|run&#124;services.msc|
|[1016](http://127.0.0.1:5151/runcom?aabb=1016)|e9f9|任务管理器|无条件|打开任务管理器|run&#124;taskmgr.exe|
|[1017](http://127.0.0.1:5151/runcom?aabb=1017)|E70F|记事本|无条件|打开系统记事本|run&#124;notepad.exe|
|1018|EC7A|系统工具|子面板||gui&#124;系统工具|
|[1019](http://127.0.0.1:5151/runcom?aabb=1019)|E8EF|计算器|无条件|打开计算器|run&#124;calc.exe|
|[1020](http://127.0.0.1:5151/runcom?aabb=1020)|EF16|主策略|无条件|打开本地组策略编辑器|run&#124;gpedit.msc|
|[1021](http://127.0.0.1:5151/runcom?aabb=1021)|e835|启动配置|无条件|打开系统配置(msconfig, 启动, 引导)|run&#124;msconfig.exe|
|[1022](http://127.0.0.1:5151/runcom?aabb=1022)|EF58|注册表|无条件|打开注册表|run&#124;regedit.exe|
|[1023](http://127.0.0.1:5151/runcom?aabb=1023)|EA1F|系统信息|无条件|打开系统信息|run&#124;msinfo32.exe|
|[1024](http://127.0.0.1:5151/runcom?aabb=1024)|ee92|事件查看|无条件|打开系统事件查看器|run&#124;eventvwr.exe|
|[1025](http://127.0.0.1:5151/runcom?aabb=1025)|ef58|系统属性|无条件|打开系统属性|run&#124;control.exe system|
|[1026](http://127.0.0.1:5151/runcom?aabb=1026)|E756|cmd|无条件|打开 CMD|run&#124;cmd.exe|
|[1027](http://127.0.0.1:5151/runcom?aabb=1027)|EF16|安全策略|无条件|打开安全策略|run&#124;secpol.msc|
|[1028](http://127.0.0.1:5151/runcom?aabb=1028)|ebc4|磁盘清理|无条件|打开磁盘清理|run&#124;cleanmgr.exe|
|[1029](http://127.0.0.1:5151/runcom?aabb=1029)|e121|任务管理|无条件|打开系统任务计划程序|run&#124;taskschd.msc|
|1030|e728|通用目录|菜单|一些通用的目录面板(我的电脑,回收站等)|menu&#124;通用目录|
|1031|E734|通用目录|子面板|一些通用的目录面板(我的电脑,回收站等)|GUI&#124;通用目录|
|1032|E734|收藏夹|子面板|自定义的目录收藏夹|GUI&#124;自定义收藏夹|
|1033|f617|[水平最大化](/actions/1033.md)|任意窗口|水平最大化|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口移动.ahk" "%Windy_CurWin_id%" "水平最大化"|
|1034|f616|[垂直最大化](/actions/1034.md)|任意窗口|垂直最大化|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口移动.ahk" "%Windy_CurWin_id%" "垂直最大化"|
|1035|e728|通用2|子面板|选中文件的通用动作的子面板2|GUI&#124;文件通用2|
|1036|efa5|文件改名|选中文件|修改选中的文本文件的名称和扩展名|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件名修改.ahk" "%candysel%"|
|1037|f87e|[打开选中](/actions/1037.md)|选中对象|运行选中的文本(路径(程序, 文件, 目录), 网址, 注册表地址)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\运行选中的文本.ahk" "%CandySel%"|
|1038|E70F|[编辑链接](/actions/1038.md)|选中文件|编辑选中的lnk快捷方式文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\LnkEditor.ahk" "%CandySel%"|
|1039|e896|[放入同名](/actions/1039.md)|选中文件|将选中的文件放入同名的文件夹中(自动创建目录)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\放入同名文件夹.ahk" "%CandySel%"|
|1040|E8DE|[解散目录](/actions/1040.md)|选中文件|将选中文件夹中的文件移动到当前目录后, 删除选中文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\解散文件夹.ahk" "%CandySel%"|
|1041|E735|收藏夹|子面板|以当前窗口打开指定文件夹|GUI&#124;收藏夹_当前窗口|
|1042|E838|[C:\\](/actions/1042.md)|资源管理器|在当前资源管理器窗口打开动作中指定的目录 C:\ |run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\当前窗口打开.ahk" "C:\"|
|[1043](http://127.0.0.1:5151/runcom?aabb=1043)|eb41|百度|无条件|打开百度的网页|run&#124;https://www.baidu.com|
|1044|f17f|[转码](/actions/1044.md)|选中文件|将选中的文本文件转换编码|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文本文件转码.ahk" "%candysel%"|
|1045|eafc|[创建软硬链接](/actions/1045.md)|选中文件|为选中的文件创建软硬链接|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件创建软硬链接.ahk" "%candysel%"|
|1046|ed2b|[文件属性](/actions/1046.md)|选中文件|修改选中的文件的属性(只读, 系统, 隐藏, 修改时间等)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件属性.ahk" "%candysel%"|
|1047|e7ad|运行窗口进程|任意窗口|运行一次窗口同名的进程|run&#124;%Windy_CurWin_Fullpath%|
|1048|f71c|窗口进程目录|任意窗口|打开窗口进程文件所在的目录|run&#124;explorer.exe /select,%Windy_CurWin_Fullpath%|
|1049|E70E|[窗口置顶](/actions/1049.md)|任意窗口|将当前窗口置顶|canfunc&#124;CF_AlwaysOnTop&#124;%Windy_CurWin_id%|
|1050|F413|复制标题|任意窗口|复制窗口的标题栏文字|setclip&#124;%Windy_CurWin_Title%|
|1051|E894|结束同名所有|任意窗口|强制结束所有窗口同名进程|run&#124;%ComSpec% /c taskkill /im %Windy_CurWin_ProcName% /F&#124;&#124;hide|
|1052|e16d|复制(路径)|选中对象|将选中文件的路径/选中文字放入剪贴板|setclip&#124;%CandySel%|
|1053|e1d1|目标目录|选中文件|打开选中的lnk快捷方式文件目标所在目录|CanFunc&#124;CF_FileShortcutTarget&#124;%CandySel%|
|[1054](http://127.0.0.1:5151/runcom?aabb=1054)|e977|我的电脑|无条件|使用资源管理器以新窗口方式打开我的电脑|run&#124;::{20D04FE0-3AEA-1069-A2D8-08002B30309D}|
|[1055](http://127.0.0.1:5151/runcom?aabb=1055)|E107|回收站|无条件|使用资源管理器以新窗口方式打开回收站|run&#124;::{645FF040-5081-101B-9F08-00AA002F954E}|
|[1056](http://127.0.0.1:5151/runcom?aabb=1056)|ed25|桌面|无条件|使用资源管理器以新窗口方式打开桌面|run&#124;%A_Desktop%|
|[1057](http://127.0.0.1:5151/runcom?aabb=1057)|ed25|我的文档|无条件|使用资源管理器以新窗口方式打开我的文档|run&#124;%A_MyDocuments%|
|[1058](http://127.0.0.1:5151/runcom?aabb=1058)|e703|网络|无条件|使用资源管理器以新窗口方式打开网络|run&#124;::{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}|
|[1059](http://127.0.0.1:5151/runcom?aabb=1059)|E839|网络适配器|无条件|使用资源管理器以新窗口方式打开网络适配器|run&#124;::{21EC2020-3AEA-1069-A2DD-08002B30309D}\::{7007ACC7-3202-11D1-AAD2-00805FC1270E}|
|[1060](http://127.0.0.1:5151/runcom?aabb=1060)|ed25|上帝模式|无条件|使用资源管理器以新窗口方式打开上帝模式文件夹|run&#124;shell:::{ED7BA470-8E54-465E-825C-99712043E01C}|
|1061|e1d1|[文档所在目录](/actions/1061.md)|特定窗口|使用资源管理器以新窗口方式打开窗口编辑的文件所在的目录|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\打开的文件.ahk"|
|1062|E838|AD_JS|菜单|Chrome 浏览器地址栏运行 JS 脚本|Menu&#124;Chrome_Js|
|1063|f0f9|[编辑模式](/actions/1063.md)|Chrome|Chrome 浏览器开启网页编辑模式|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\Chrome地址栏打开.ahk" "javascript:void((function(){document.body.contentEditable='true'; document.designMode='on'; void 0})())"|
|1064|edb1|[!编辑模式](/actions/1064.md)|Chrome|Chrome 浏览器关闭网页编辑模式|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\Chrome地址栏打开.ahk" "javascript:document.body.contentEditable=false"|
|1065|f0f9|[强制复制](/actions/1065.md)|Chrome|Chrome 浏览器强制打开网页的右键复制功能|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\Chrome地址栏打开.ahk" "javascript:alert(document.onselectstart = document.onbeforecopy = document.oncontextmenu = document.onmousedown = document.onkeydown = function(){return true;});void(document.body.onmousedown='');void(document.body.contextmenu=''); void(document.body.onselectstart=''); void(document.body.onmouseup=''); void(document.body.oncopy='');"|
|1066|f552|获取权限|选中文件|设置选中文件的权限为管理员组|run&#124;cmd.exe /c takeown /f "%CandySel%" && icacls "%CandySel%" /grant administrators:F|
|1067|ed2b|[合并文件](/actions/1067.md)|选中文件|将选中的多个文本文件合并为一个文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\合并文本文件.ahk" "%candysel%"|
|1068|e907|[透明75%](/actions/1068.md)|任意窗口|将当前窗口透明度设为75%|canfunc&#124;CF_WinSetTransparent&#124;192|
|1069|e906|[透明50%](/actions/1068.md)|任意窗口|将当前窗口透明度设为50%|canfunc&#124;CF_WinSetTransparent&#124;128|
|1070|ef3b|[预览文件](/actions/1070.md)|选中文件|使用ahk预览选中的文件(文本, 图片, 压缩包...)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件预览.ahk" "%CandySel%"|
|1071|e929|打开方式|选中文件|弹出选中文件的打开方式菜单|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件打开方式.ahk" "%CandySel%"|
|1072|EDE3|窗口通用|菜单|当前窗口的通用动作的菜单|menu&#124;窗口通用|
|1073|E107|[永久删除](/actions/1073.md)|选中文件|永久删除选中的文件, 无确认提示|canfunc&#124;CF_FileDelete&#124;%CandySel%|
|[1074](http://127.0.0.1:5151/runcom?aabb=1074)|e193|画图|无条件|打开系统自带画图程序|run&#124;mspaint|
|1075|f69e|常用工具|子面板||Gui&#124;常用工具|
|[1076](http://127.0.0.1:5151/runcom?aabb=1076)|ea39|[隐藏图标](/actions/1076.md)|无条件|隐藏或恢复桌面图标|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\隐藏桌面所有图标.ahk"|
|1077|E107|[删空目录](/actions/1077.md)|资源管理器|删除资源管理器窗口当前文件夹下的所有空目录(每个文件夹只循环一次)|canfunc&#124;CF_FileRemoveBlankDir&#124;%Windy_CurWin_FolderPath%|
|[1078](http://127.0.0.1:5151/runcom?aabb=1078)|f608|1h后关机|无条件|1 小时后强制关机|run&#124;shutdown -s -t 3600|
|[1079](http://127.0.0.1:5151/runcom?aabb=1079)|f608|取消关机|无条件|取消强制关机|run&#124;shutdown -a|
|1080|f14a|[MD5](/actions/1080.md)|选中文件|计算选中文件的MD5值|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\MD5_File.ahk" "%CandySel%"|
|1081|e8b1|[交换文件名](/actions/1081.md)|选中文件|将当前选中的两个文件交换文件名|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\两个文件交换文件名.ahk" "%CandySel%"|
|1082|e775|[获取文本](/actions/1082.md)|任意窗口|获取任意窗口鼠标下的文本(例如 任务管理器的命令行)|cando&#124;获取鼠标下文本|
|1083|EDE3|窗口通用2|菜单|当前窗口的通用动作的菜单2|Menu&#124;窗口通用2|
|1084|e908|[透明关](/actions/1068.md)|任意窗口|将当前窗口透明度关闭|canfunc&#124;CF_WinSetTransparent&#124;255|
|1085|e8fc|[快捷方式到桌面](/actions/1085.md)|选中文件|创建文件快捷方式到桌面|canfunc&#124;CF_FileShortcutToDesk&#124;%CandySel%|
|1086|e126|[复制到Music](/actions/1086.md)|选中文件|复制选中的文件到动作中指定的目录|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\复制文件到指定文件夹.ahk" "%CandySel%" "G:\Music"|
|1087|e89a|[同步文件夹](/actions/1087.md)|资源管理器|左侧文件夹同步到右侧(左→右)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\打开的文件夹同步.ahk" "%Windy_CurWin_FolderPath%"|
|1088|e89a|[同步文件夹2](/actions/1087.md)|资源管理器|左侧文件夹同步到右侧(左→右)|canfunc&#124;ExecSend&#124;%Windy_CurWin_FolderPath%&#124;文件夹同步 ahk_class AutoHotkeyGUI|
|[1089](http://127.0.0.1:5151/runcom?aabb=1089)|e89a|[同步如意](/actions/1087.md)|无条件|左侧文件夹同步到右侧(左→右)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\打开的文件夹同步.ahk" "C:\Users\Administrator\Desktop\Ahk\如意百宝箱" "C:\Users\Administrator\Desktop\Ahk\如意百宝箱 - 发布版本\RuYi-Ahk"|
|1090|E734|网址收藏夹|子面板||gui&#124;网址收藏夹|
|1091|e728|网址收藏夹|菜单||menu&#124;网址收藏夹|
|1092|e8c1|[查看编码](/actions/1092.md)|选中文本|查看选中文本的编码|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\查看字符编码.ahk" "%CandySel%"|
|1093|e8a3|[搜索文件夹](/actions/1093.md)|资源管理器|使用文件名搜索资源管理器窗口当前文件夹中的文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹中搜索文件.ahk" "%Windy_CurWin_FolderPath%"|
|[1094](http://127.0.0.1:5151/runcom?aabb=1094)|ec27|IP设置|无条件|网络适配器的IP设置|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\网络连接IP设置.ahk"|
|1095|e928|[Hash](/actions/1095.md)|选中文件|计算选中文件的Hash值|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\HashCalc.ahk" "%CandySel%"|
|1096|ede4|[搜索文件内容](/actions/1096.md)|资源管理器|搜索资源管理器窗口当前文件夹中文本文件中的内容|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文本文件中查找字符.ahk" "%Windy_CurWin_FolderPath%"|
|1097|f6fa|[百度搜索](/actions/1097.md)|选中文本|百度搜索选中文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\当前浏览器打开.ahk" https://www.baidu.com/s?wd=%CandySel%|
|1098|f5a5|[文本比较1](/actions/1098.md)|选中对象|将选中对象(选中的文件或文本)放入文本对比的左侧界面|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文本比较.ahk" "%CandySel%"|
|[1099](http://127.0.0.1:5151/runcom?aabb=1099)|e768|自定义运行|无条件|自定义注册表中注册的exe文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\自定义运行命令.ahk"|
|1100|f5a6|[文本比较2](/actions/1098.md)|选中对象|将选中对象放入文本对比的右侧编辑框|canfunc&#124;ExecSend&#124;%CandySel%&#124;文本比较 ahk_class AutoHotkeyGUI|
|1101|f14a|[MD5对比1](/actions/1101.md)|选中文件|将选中文件放入MD5计算界面的上部编辑框|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\MD5.ahk" "%CandySel%"|
|1102|f14a|[MD5对比2](/actions/1101.md)|选中文件|将选中文件放入MD5计算界面的下部编辑框|canfunc&#124;ExecSend&#124;%CandySel%&#124;MD5验证 ahk_class AutoHotkeyGUI|
|1103|e928|[Hash2](/actions/1103.md)|选中文件|计算选中文件的Hash值|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\Hash_File.ahk" "%CandySel%"|
|1104|e124|[缩小50%](/actions/1104.md)|选中文件|将选中的图形文件尺寸缩小50%|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像缩小一半.ahk" "%CandySel%" "50"|
|1105|e19b|[灰度图像](/actions/1105.md)|选中文件|将选中的图形文件转换为灰度图像|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像变灰度.ahk" "%CandySel%"|
|1106|e16d|[放入剪贴板](/actions/1106.md)|选中文件|将选中的图形文件内容复制到剪贴板|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像内容放入剪贴板.ahk" "%CandySel%"|
|1107|e124|[品质压缩](/actions/1107.md)|选中文件|将选中的图形文件品质降低50%|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像质量压缩一半.ahk" "%CandySel%"|
|1108|e1a5|[移动到Music](/actions/1108.md)|选中文件|移动选中的文件到动作中指定的目录|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\移动文件到指定文件夹.ahk" "%CandySel%" "G:\Music"|
|1109|e8c8|[发送到打开的](/actions/1109.md)|选中文件|复制/移动选中文件到当前打开的目录|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\选中文件到打开的文件夹.ahk" "%CandySel%" "c:\123,d:\1 2\345"|
|1110|f093|[搜索帮助](/actions/1110.md)|选中文本|打开ahk中文帮助文件并跳转到选中的文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\Ahk脚本查帮助.ahk" "%CandySel%"|
|1111|f093|[搜索v2帮助](/actions/1111.md)|选中文本|打开ahkv2中文帮助文件并跳转到选中的文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\Ahk2脚本查帮助.ahk" "%CandySel%"|
|1112|e982|有道翻译|选中文本|使用有道翻译选中的文本(官网已停用免费API)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\有道翻译.ahk" "%CandySel%"|
|[1113](http://127.0.0.1:5151/runcom?aabb=1113)|E839|网络适配器|无条件|使用资源管理器以新窗口方式打开网络适配器|run&#124;rundll32.exe shell32.dll,Control_RunDLL ncpa.cpl|
|[1114](http://127.0.0.1:5151/runcom?aabb=1114)|E756|环境变量|无条件|打开系统环境变量的设置界面|run&#124;rundll32 sysdm.cpl,EditEnvironmentVariables|
|[1115](http://127.0.0.1:5151/runcom?aabb=1115)|f19d|[显示隐藏](/actions/1115.md)|无条件|资源管理器显示隐藏文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\显示隐藏文件.ahk"|
|[1116](http://127.0.0.1:5151/runcom?aabb=1116)|f618|[隐藏文件](/actions/1116.md)|无条件|资源管理器隐藏文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\不显示隐藏文件.ahk"|
|[1117](http://127.0.0.1:5151/runcom?aabb=1117)|ea49|[显示扩展名](/actions/1117.md)|无条件|资源管理器显示文件的扩展名|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\显示扩展名.ahk"|
|[1118](http://127.0.0.1:5151/runcom?aabb=1118)|e89f|[隐藏扩展名](/actions/1118.md)|无条件|资源管理器隐藏文件的扩展名|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\不显示扩展名.ahk"|
|1119|e16d|多文件名|选中文件|将选中文件的文件名放入剪贴板(支持多文件)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\多文件仅复制文件名.ahk" "%CandySel%"|
|1120|f17f|[剪贴板至文件](/actions/1120.md)|资源管理器|剪贴板保存为文件到当前文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\剪贴板保存为文件到当前文件夹.ahk" "%Windy_CurWin_FolderPath%"|
|1121|f19d|[最近打开](/actions/1121.md)|特定窗口|显示系统最近打开的文档的菜单|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\最近使用的文档.ahk"|
|[1122](http://127.0.0.1:5151/runcom?aabb=1122)|f093|无线调试|无条件|开启手机无线adb调试|run&#124;%A_ComSpec% /k "%A_ScriptDir%\引用程序\adb.exe" tcpip 5555|
|[1123](http://127.0.0.1:5151/runcom?aabb=1123)|f095|开启黑域|无条件|开启手机黑域|%A_ComSpec% /k "%A_ScriptDir%\引用程序\adb.exe" shell sh /data/data/me.piebridge.brevent/brevent.sh|
|[1124](http://127.0.0.1:5151/runcom?aabb=1124)|ef3b|[重启桌面](/actions/1124.md)|无条件|强制关闭所有资源管理器后重新打开|canfunc&#124;CF_restartexplorer|
|1125|e198|[窗口静音](/actions/1125.md)|任意窗口|任意窗口静音, 再次运行恢复|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口静音.ahk" "%Windy_CurWin_ProcName%"|
|1126|E70F|[浏览器打开](/actions/1126.md)|特定窗口|使用(当前打开的)浏览器打开当前窗口打开的文本文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\其他编辑器打开.ahk" "当前浏览器"|
|1127|e16d|复制进程路径|任意窗口|复制当前窗口的进程路径到剪贴板|setclip&#124;%Windy_CurWin_Fullpath%|
|1128|e70f|其他编辑|子面板|使用指定的编辑器打开当前窗口打开的文本文件|Gui&#124;编辑器打开|
|1129|E70F|[记事本](/actions/1129.md)|特定窗口|使用记事本编辑当前窗口打开的文本文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\其他编辑器打开.ahk" "notepad.exe"|
|1130|e99a|[恐龙彩蛋](/actions/1130.md)|Chrome|Chrome 浏览器断网时的恐龙游戏彩蛋|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\Chrome地址栏打开.ahk" "chrome://dino/"|
|1131|e12b|[Chrome URLs](/actions/1131.md)|Chrome|Chrome 浏览器的各种 URLs|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\Chrome地址栏打开.ahk" "chrome://about/"|
|1132|f0ae|下载内容|Chrome|按下Ctrl+J, 打开 Chrome 浏览器的下载记录|Keys&#124;^j|
|1133|ee93|历史记录|Chrome|按下Ctrl+H, 打开 Chrome 浏览器的下载记录|Keys&#124;^h|
|1134|ea8d|调试器|Chrome|按下F12,打开 Chrome 浏览器的调试器|Keys&#124;{F12}|
|1135|e845|恢复标签|Chrome|按下Ctrl+Shift+T, 重新打开 Chrome 浏览器关闭的标签页|Keys&#124;^+t|
|1136|ea39|关闭标签|Chrome|按下Ctrl+W, 关闭 Chrome 浏览器当前标签页|Keys&#124;^w|
|1137|e118|至底部|Chrome|按下End, 跳转到 Chrome 浏览器打开网页的底部|Keys&#124;{End}|
|1138|e898|至顶部|Chrome|按下Home, 跳转到 Chrome 浏览器打开网页的顶部|Keys&#124;{home}|
|1139|ecaa|冻结|WPS 表格|Excel, WPS 表格快捷键,冻结到选中单元格|Cando&#124;冻结到单元格|
|1140|e16e|筛选|WPS 表格|Excel, WPS 表格快捷键,按下 Ctrl+Shift+L, 进行筛选|Keys&#124;^+l|
|1141|e16d|复制网址|Chrome|获取 Chrome 浏览器地址栏的网址|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\GetBrowserURL.ahk"|
|1142|e16d|复制全部网址|Chrome|获取 Chrome 浏览器所有打开标签页的网址|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\GetBrowserURL.ahk" "All"|
|1143|f466|[IE浏览器打开](/actions/1143.md)|Chrome|使用IE浏览器打开 Chrome 浏览器当前标签页的网址|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\其他浏览器打开.ahk" "iexplorer.exe"|
|1144|f73d|快捷键|菜单|Chrome 浏览器的快捷键面板|Menu&#124;Chrome_快捷键|
|1145|e713|[Chrome 设置](/actions/1145.md)|Chrome|打开 Chrome 浏览器的设置页面|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\Chrome地址栏打开.ahk" "chrome://settings/"|
|1146|E70F|编辑器|子面板|文本编辑器子面板|Gui&#124;文本编辑器|
|[1147](http://127.0.0.1:5151/runcom?aabb=1147)|e703|控制面板|无条件|打开控制面板|run&#124;::{26EE0668-A00A-44D7-9371-BEB064C98683}\0|
|[1148](http://127.0.0.1:5151/runcom?aabb=1148)|e703|库|无条件|打开库|run&#124;::{031E4825-7B94-4DC3-B131-E946B44C8DD5}|
|1149|e16d|[复制目标路径](/actions/1149.md)|选中Lnk文件|复制快捷方式的目标路径到剪贴板|Canfunc&#124;CF_FileGetShortcut&#124;%CandySel%|
|[1150](http://127.0.0.1:5151/runcom?aabb=1150)|E756|PowerShell|无条件|打开 PowerShell|run&#124;powershell|
|1151|e16d|[复制命令行](/actions/1151.md)|任意窗口|复制窗口进程命令行到剪贴板|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\复制窗口命令行.ahk" "%Windy_CurWin_Pid%"|
|1152|f6fa|[Bing搜索](/actions/1152.md)|选中文本|Bing搜索选中文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\当前浏览器打开.ahk" https://cn.bing.com/search?q=%CandySel%|
|1153|f6fa|[Baidu/Bing](/actions/1153.md)|Chrome|百度 Bing 切换|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\百度Bing切换.ahk" "%Windy_CurWin_Class%"|
|1154|f6fa|[京东搜索](/actions/1154.md)|选中文本|京东搜索选中文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\当前浏览器打开.ahk" https://search.jd.com/Search?keyword=%CandySel%|
|1155|f6fa|搜索引擎|菜单|搜索引擎集合的菜单|Menu&#124;搜索引擎|
|1156|f6fa|[B站搜索](/actions/1156.md)|选中文本|B站搜索选中文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\当前浏览器打开.ahk" https://search.bilibili.com/all?keyword=%CandySel%|
|[1157](http://127.0.0.1:5151/runcom?aabb=1157)|ed25|如意目录|无条件|打开脚本所在目录|run&#124;"%A_ScriptDir%"|
|[1158](http://127.0.0.1:5151/runcom?aabb=1158)|ed25|AppData|无条件|打开 AppData 目录|run&#124;shell:AppData|
|[1159](http://127.0.0.1:5151/runcom?aabb=1159)|ed25|Rencent|无条件|打开 Rencent 目录|run&#124;shell:Rencent|
|1160|E734|收藏夹|子面板|注册表收藏夹, 打开动作中指定的注册表地址|Gui&#124;注册表_收藏夹|
|1161|E71B|[开机启动项目](/actions/1161.md)|注册表|在注册表窗口打开动作中指定的路径|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\注册表定位.ahk" "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"|
|1162|E71B|[系统服务](/actions/1162.md)|注册表|在注册表窗口打开动作中指定的路径|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\注册表定位.ahk" "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services"|
|1163|f73d|快捷键|子面板|Excel, WPS 表格快捷键集合|Gui&#124;Excel_快捷键|
|1164|E80A|全部边框|Excel|Excel, WPS 表格快捷键, 为选中单元格添加四周边框|Cando&#124;全部边框|
|1165|E77F|粘贴为数值|Excel|Excel, WPS 表格快捷键, 将选中单元格粘贴为数值|Cando&#124;粘贴为数值|
|1166|E77F|输入为数值|Excel|Excel, WPS 表格快捷键, 将选中单元格输入为数值|Cando&#124;输入为数值|
|1167|E8FF|打印预览|WPS 表格|Excel, WPS 表格快捷键, 按下 Ctrl+F2, 打印预览|Keys&#124;^{F2}|
|[1168](http://127.0.0.1:5151/runcom?aabb=1168)|eb55|[关闭显示器](/actions/1168.md)|无条件|关闭显示器屏幕(黑屏)|canfunc&#124;CF_CloseScreen|
|1169|E71B|[复制路径](/actions/1169.md)|注册表|复制注册表窗口打开的路径到剪贴板|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\注册表定位.ahk"|
|1170|e16d|[复制内容](/actions/1170.md)|选中文件|复制文本文件内容到剪贴板|canfunc&#124;CF_FileToClip&#124;%CandySel%|
|1171|e9a6|[截取窗口](/actions/1171.md)|任意窗口|截取窗口并存入脚本所在目录的截图目录中(客户区域不带窗口标题栏)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\截图.ahk" "" "Window"|
|[1172](http://127.0.0.1:5151/runcom?aabb=1172)|f617|[截取屏幕](/actions/1172.md)|无条件|截取显示器屏幕并存入脚本所在目录的截图目录中|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\截图.ahk"|
|1173|ed14|[二维码](/actions/1173.md)|选中文本|选中文字生成二维码|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\生成二维码.ahk" "%CandySel%"|
|1174|ec5c|[更改盘符](/actions/1174.md)|选中驱动器|更改选中驱动器的盘符|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\磁盘_更改盘符.ahk" "%CandySel%"|
|1175|eda2|[序列号](/actions/1175.md)|选中驱动器|读取选中驱动器的序列号|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\磁盘_读取序列号.ahk" "%CandySel%"|
|1176|ea5b|[AppId](/actions/1176.md)|任意窗口|更改窗口的AppId, 将窗口从当前任务栏分组中移除|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\更改appid.ahk" "%Windy_CurWin_id%"|
|1177|EDE3|[FolderMenu](/actions/1177.md)|选中文件夹|将选中文件夹以菜单形式显示|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\FolderMenu.ahk" "%CandySel%"|
|1178|EDE3|[FolderMenu](/actions/1178.md)|资源管理器|将资源管理器当前打开的文件夹以菜单形式显示|run#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\FolderMenu.ahk" "%Windy_CurWin_FolderPath%"|
|1179|EDE3|当前文件夹|子面板|资源管理器当前打开文件夹的相关动作集合的子面板|Gui&#124;资源管理器_当前文件夹|
|1180|EDE3|文件通用|子面板|选中文件的通用动作的子面板|Gui&#124;文件通用|
|1181|EDE3|通用2|菜单|选中文件的通用动作的菜单|Menu&#124;文件通用2|
|1182|EDE3|窗口通用|子面板|当前窗口的通用动作的子面板|Gui&#124;窗口通用|
|1183|EDE3|通用2|子面板|当前窗口的通用动作的子面板|Gui&#124;窗口通用2|
|1184|EDE3|目录通用|菜单|选中文件夹的通用动作的菜单|Menu&#124;文件夹通用|
|1185|f552|获取权限|选中文件|设置选中文件的权限为管理员|run&#124;cmd.exe /c takeown /f "%CandySel%" && icacls "%CandySel%" /grant administrator:F|
|1186|f2b7|百度网盘|选中文本|自动打开选中文本中的百度网盘网址, 并将提取码放入剪贴板和自动填写|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\百度网盘链接.ahk" "%CandySel%"|
|1187|e947|[关闭窗口](/actions/1187.md)|任意窗口|关闭窗口(chrome 等特定窗口为关闭标签页)|Cando&#124;关闭窗口|
|1188|e72b|[左半后退](/actions/1188.md)|任意窗口|浏览器发送后退快捷键, 其他窗口为移到左半屏幕|Cando&#124;左半后退|
|1189|e72a|[右半前进](/actions/1189.md)|任意窗口|浏览器发送前进快捷键, 其他窗口为移到右半屏幕|Cando&#124;右半前进|
|1190|e74b|[最小化](/actions/1190.md)|任意窗口|窗口最小化|Cando&#124;窗口最小化|
|1191|e74a|[最大化](/actions/1191.md)|任意窗口|窗口最大化|Cando&#124;窗口最大化|
|[1192](http://127.0.0.1:5151/runcom?aabb=1192)|ee92|[动作管理](/actions/1192.md)|无条件|动作管理|Cando&#124;TM_ActionM|
|[1193](http://127.0.0.1:5151/runcom?aabb=1193)|e1ce|最多运行|无条件|最多运行动作的子面板|canfunc&#124;ShowDBData&#124;execcount&#124;面板|
|[1194](http://127.0.0.1:5151/runcom?aabb=1194)|e728|最多运行|无条件|最多运行动作的菜单|canfunc&#124;ShowDBData&#124;execcount&#124;菜单|
|[1195](http://127.0.0.1:5151/runcom?aabb=1195)|e1cf|最近运行|无条件|最近运行动作的子面板|canfunc&#124;ShowDBData&#124;lastexectime&#124;面板|
|[1196](http://127.0.0.1:5151/runcom?aabb=1196)|f0e9|最近运行|无条件|最近运行动作的菜单|canfunc&#124;ShowDBData&#124;lastexectime&#124;菜单|
|1197|f2b7|[DllFunc](/actions/1197.md)|选中文件|查看选中Dll文件中的函数|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\Dll文件中的函数.ahk" "%CandySel%"|
|1198|e74c|[智能解压](/actions/1198.md)|选中文件|将选中的压缩文件解压到当前文件夹,并且只有一层文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\压缩文件智能解压.ahk" "%CandySel%"|
|[1199](http://127.0.0.1:5151/runcom?aabb=1199)|f5ed|窗口列表|无条件|列出系统中的所有窗口, 可以隐藏和显示|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口_显示或隐藏.ahk"|
|1200|f2b7|[进制转换](/actions/1200.md)|选中文本|将选中的10进数字转换为16进制, 或将选中的16进数字转换为10进制|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\数字_十进制十六进制转换.ahk" "%CandySel%"|
|1201|f2b7|[对应颜色](/actions/1201.md)|选中文本|查看选中数字对应的颜色|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\数字_查看代码对应的颜色.ahk" "%CandySel%"|
|1202|EDE3|文本通用|子面板|短文本的通用动作的子面板|Gui&#124;短文本通用|
|1203|EDE3|文本通用|菜单|选中短文本通用动作的菜单|Menu&#124;短文本通用|
|1204|EDE3|数字通用|菜单|选中数字通用动作的菜单|Menu&#124;数字通用|
|1205|e1df|[Exe2目录图标](/actions/1205.md)|选中文件|将选中exe文件的图标设为所在文件夹的图标|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\Exe图标设为文件夹图标.ahk" "%CandySel%"|
|1206|e8b7|[还原图标](/actions/1206.md)|选中文件夹|将选中文件夹的图标设为默认的图标|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\Exe图标设为文件夹图标.ahk" "%CandySel%"|
|1207|eb9f|提取图标|选中文件|提取选中文件(exe, dll)中的图标|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\提取图标.ahk" "%CandySel%"|
|1208|eb9f|关联图标|选中文件|保存选中文件关联的图标到文件所在文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\关联图标存为png文件.ahk" "%CandySel%" ".png"|
|[1209](http://127.0.0.1:5151/runcom?aabb=1209)|eb9f|测试|无条件|测试插件脚本里的例子|canfunc&#124;ExecSendToDll&#124;%CandySel%|
|1210|ed11|[完整歌单](/actions/1210.md)|Chrome|Chrome 浏览器开启网页端网易云的完整歌单|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\Chrome地址栏打开.ahk" "javascript:document.cookie='os=pc';f()"|
|1211|ea47|[下一页](/actions/1211.md)|Chrome|Chrome 浏览器自动下一页|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\Chrome地址栏打开.ahk" "javascript:var Re=new RegExp('(下~&#124;后)(一~&#124;\s)&#42;(页~&#124;頁~&#124;章~&#124;篇~&#124;翻)','i');var a=document.getElementsByTagName('A');for(var i=0;i<a.length;i++){if(Re.test(a[i].innerHTML)){if(a[i].href.substr(0,11).toLowerCase()=='javascript:')a[i].click();else document.location.href=a[i].href;break}}"|
|1212|ed11|[Ini_Fav](/actions/1212.md)|选中文件|Ini 文件显示为菜单(作为收藏夹使用)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\Ini_收藏夹菜单.ahk" "%CandySel%"|
|1213|ed11|[Ini_Opw](/actions/1213.md)|选中文件|Ini 文件显示为程序菜单, 使用菜单中的程序打开选中的文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\Ini_程序打开选中文件.ahk" "%CandySel%"|
|1214|f6fa|[百度搜索](/actions/1214.md)|选中文件|百度搜索选中文件的文件名|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\当前浏览器打开.ahk" https://www.baidu.com/s?wd=%CandySel_FileName%|
|1215|f093|Adb|子面板|手机Adb的子面板|Gui&#124;Adb|
|1216|e898|收藏夹|Chrome|快捷键打开Chrome的收藏夹|Keys&#124;^+o|
|[1217](http://127.0.0.1:5151/runcom?aabb=1217)|e89a|到手机|无条件|同步电脑文件夹到手机文件夹(参数指定文件夹)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\同步文件夹到手机.ahk" "H:\备份\同步文件夹" "/storage/emulated/0/1_文档/资料/同步文件夹"|
|[1218](http://127.0.0.1:5151/runcom?aabb=1218)|e952|连接手机|无条件|使用adb连接到手机|run&#124;%A_ComSpec% /k "%A_ScriptDir%\引用程序\adb.exe" connect 192.168.1.109:5555|
|1219|e89a|到手机|选中文件|发送电脑选中文件到手机的根目录|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\发送文件到手机目录.ahk" "%CandySel%"|
|[1220](http://127.0.0.1:5151/runcom?aabb=1220)|e9d2|股票行情|无条件|显示自定义股票当天的涨跌|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\股票当天行情.ahk"|
|1221|E734|收藏夹|子面板|浏览器收藏夹菜单的子面板|Gui&#124;浏览器收藏夹|
|[1222](http://127.0.0.1:5151/runcom?aabb=1222)|E734|[360收藏夹](/actions/1222.md)|无条件|将360浏览器的收藏夹显示为菜单(只支持一级文件夹, 参数 CandySel 请替换为收藏夹文件的路径)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\360浏览器收藏夹.ahk" "%CandySel%"|
|[1223](http://127.0.0.1:5151/runcom?aabb=1223)|E734|[Chrome收藏夹](/actions/1223.md)|无条件|将Chrome浏览器的收藏夹显示为菜单(只支持两级文件夹, 参数 CandySel 请替换为收藏夹文件的路径)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\Chrome收藏夹.ahk" "%CandySel%"|
|[1224](http://127.0.0.1:5151/runcom?aabb=1224)|e16d|[Edge收藏夹](/actions/1223.md)|无条件|将Edge浏览器的收藏夹显示为菜单(只支持两级文件夹, 参数 CandySel 请替换为收藏夹文件的路径)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\Chrome收藏夹.ahk" "%A_AppData%\..\Local\Microsoft\Edge\User Data\Default\bookmarks"|
|1225|e8a3|文件库搜索|选中对象|使用选中对象在文件库中搜索文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\数据库_文件库中搜索文件.ahk" "%CandySel%"|
|1226|e184|[打开目录](/actions/1226.md)|对话框|显示一个菜单, 对话框跳转到选择的项目|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\对话框_打开目录.ahk" "%Windy_CurWin_id%"|
|[1227](http://127.0.0.1:5151/runcom?aabb=1227)|ef58|系统属性|无条件|打开系统属性界面(高级系统设置)|run&#124;sysdm.cpl|
|1228|e982|搜狗翻译|选中文本|使用搜狗翻译选中的文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\搜狗翻译.ahk" "%CandySel%"|
|1229|e8b1|[查找重复](/actions/1229.md)|选中文件夹|查找选中文件夹中的重复文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\查找重复文件.ahk" "%CandySel%"|
|1230|E894|[结束进程](/actions/1230.md)|任意窗口|强制结束窗口进程|run&#124;%ComSpec% /c taskkill /pid %Windy_CurWin_Pid% /F&#124;&#124;hide|
|[1231](http://127.0.0.1:5151/runcom?aabb=1231)|ef58|环境变量|无条件|环境变量编辑备份脚本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\环境变量\环境变量.ahk"|
|1232|ef58|新增Path|资源管理器|将资源管理器当前打开的路径添加到环境变量Path中|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\环境变量\Environment.ahk" "%Windy_CurWin_FolderPath%"|
|[1233](http://127.0.0.1:5151/runcom?aabb=1233)|e1a4|[搜索动作](/actions/1233.md)|无条件|搜索和运行动作的界面|Cando&#124;ActionSR|
|1234|ec24|Dll注册|选中文件|注册选中的dll文件|run&#124;regsvr32.exe "%CandySel%"|
|1235|e789|Dll卸载|选中文件|卸载选中的dll文件|run&#124;regsvr32.exe /u "%CandySel%"|
|1236|e74c|Msi解压|选中文件|将选中的msi文件解压|run&#124;msiexec.exe /a "%CandySel%" /qb TARGETDIR="%CandySel_ParentPath%\%CandySel_FileNameNoExt%"|
|1237|e74c|chm解压|选中文件|解压缩选中的chm文件|run&#124;hh.exe -decompile %CandySel_FileNameNoExt% %CandySel_FileName%&#124;%CandySel_ParentPath%|
|1238|e8b1|前后交换|选中文件|重命名文件, 将文件名使用分隔符分为前后两部分,然后交换其位置|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件名前后交换.ahk" "%CandySel%"|
|1239|E734|[收藏夹](/actions/1239.md)|对话框|对话框跳转到ini文件中预设的文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\对话框_收藏夹.ahk" "%Windy_CurWin_id%"|
|[1240](http://127.0.0.1:5151/runcom?aabb=1240)|E7AC|测试动作|无条件|对话框显示动作中变量|msgbox&#124;你好啊~&#124;hello~&#124;Ahk&#124;%A_OSversion%|
|1241|e8f9|[任务栏按钮](/actions/1241.md)|任意窗口|移除或恢复窗口在任务栏的按钮|canfunc&#124;CF_WinRemoveTaskbarButton&#124;%Windy_CurWin_id%|
|1242|e982|[文本处理](/actions/1242.md)|选中文本|编辑选中的文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\文本处理.ahk" "%CandySel%"|
|1243|E894|[结束进程](/actions/1243.md)|任意窗口|强制结束窗口进程|canfunc&#124;CF_WinKill&#124;%Windy_CurWin_id%|
|1244|E894|[结束进程](/actions/1244.md)|任意窗口|强制结束窗口进程|canfunc&#124;CF_ProcessClose&#124;%Windy_CurWin_Pid%|
|1245|EDE3|通用3|菜单|选中文件的通用动作的菜单|Menu&#124;文件通用3|
|1246|EDE3|通用3|子面板|当前窗口的通用动作的子面板|Gui&#124;窗口通用3|
|1247|e8f9|[加入Ini_Fav](/actions/1247.md)|任意窗口|将窗口的进程(exe) 添加到 Ini收藏夹(向 ATA 发送动作编号)|SendMsgToATA&#124;1247|
|1248|eda4|[快捷方式到桌面](/actions/1248.md)|任意窗口|创建窗口的进程文件的文件快捷方式到桌面|canfunc&#124;CF_FileShortcutToDesk&#124;%Windy_CurWin_Fullpath%|
|1249|e8c8|文件夹结构|选中文件夹|将选中文件夹的结构复制到当前文件夹(仅复制选中文件夹及其下的子文件夹)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\复制文件夹结构到当前目录.ahk" "%CandySel%"|
|1250|e8c8|结构+空文件|选中文件夹|将选中文件夹的结构和空白文件复制到当前文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\复制文件夹结构到当前目录.ahk" "%CandySel%" 1|
|1251|e16d|复制文件名|选中文件|将选中文件的文件名放入剪贴板|setclip&#124;%CandySel_FileName%|
|1252|e8d3|Ahk控制|子面板|控制Ahk脚本的动作集|Gui&#124;A_脚本控制|
|1253|f259|[主窗口](/actions/1253.md)|Ahk窗口|主窗口|canfunc&#124;PostMessToAhk&#124;65300&#124;%Windy_CurWin_id%|
|1254|e8ee|[重启脚本](/actions/1254.md)|Ahk窗口|重启脚本|canfunc&#124;PostMessToAhk&#124;65303&#124;%Windy_CurWin_id%|
|1255|e70f|[编辑脚本](/actions/1254.md)|Ahk窗口|编辑脚本|canfunc&#124;PostMessToAhk&#124;65304&#124;%Windy_CurWin_id%|
|1256|e1c4|[挂起脚本](/actions/1254.md)|Ahk窗口|挂起脚本|canfunc&#124;PostMessToAhk&#124;65305&#124;%Windy_CurWin_id%|
|1257|edb4|[暂停脚本](/actions/1254.md)|Ahk窗口|暂停脚本|canfunc&#124;PostMessToAhk&#124;65306&#124;%Windy_CurWin_id%|
|1258|ea39|[退出脚本](/actions/1254.md)|Ahk窗口|退出脚本|canfunc&#124;PostMessToAhk&#124;65307&#124;%Windy_CurWin_id%|
|1259|e97b|[窗口微缩0.5](/actions/1259.md)|任意窗口|隐藏窗口后以动态缩略图方式显示(原窗口的0.5)(启动后快捷键 Alt+q)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口微缩.ahk" "%Windy_CurWin_id%"|
|1260|f19d|[窗口微缩0.3](/actions/1260.md)|任意窗口|隐藏窗口后以动态缩略图方式显示(原窗口的0.3)(启动后快捷键 Alt+q)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口微缩.ahk" "%Windy_CurWin_id%" "0.3"
|1261|f093|安装 Apk|选中文件|安装 Apk 文件到连接的手机|run&#124;%A_ComSpec% /k "%A_ScriptDir%\引用程序\adb.exe" install -r "%CandySel%"|
|[1262](http://127.0.0.1:5151/runcom?aabb=1262)|e8e8|Adb 命令|无条件|使用界面执行预设的 Adb 命令|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\Adb.ahk"|
|[1263](http://127.0.0.1:5151/runcom?aabb=1263)|e8a1|[面板管理](/actions/1263.md)|无条件|管理如意中的面板|Cando&#124;TM_BoardM|
|[1264](http://127.0.0.1:5151/runcom?aabb=1264)|e775|热字串管理|无条件|管理如意的热字串|Cando&#124;hotstrM|
|1265|e8ec|设置如意|子面板|管理和设置如意的子面板|Gui&#124;如意|
|1266|e9d5|多文件通用|子面板|多文件通用子面板|Gui&#124;多文件通用|
|1267|e1a5|移至新文件夹|选中文件|将选中的文件移动到同级的新建文件夹中|canfunc&#124;CF_FileMoveToFolder&#124;%CandySel%|
|1268|f103|[临时共享](/actions/1268.md)|选中文件|将选中文件共享到局域网, 局域网内的手机和电脑使用浏览器打开网址, 或手机扫码下载文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件临时共享.ahk" "%CandySel%"|
|1269|e8b3|[Zip压缩](/actions/1269.md)|选中文件|将选中的文件添加到 Zip 压缩包中(引用程序内置)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\7zip压缩.ahk" "%CandySel%"|
|1270|e74c|[Zip解压](/actions/1270.md)|选中文件|将选中的 Zip 文件自动解压到压缩包所在文件夹(引用程序内置)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\7zip智能解压.ahk" "%CandySel%"|
|1271|e74c|[Rar解压](/actions/1271.md)|选中文件|将选中的 Rar 文件自动解压到压缩包所在文件夹(引用程序内置)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\UnRar.ahk" "%CandySel%"|
|[1272](http://127.0.0.1:5151/runcom?aabb=1272)|f552|安全和维护|无条件|打开系统安全和维护界面|run&#124;wscui.cpl|
|[1273](http://127.0.0.1:5151/runcom?aabb=1273)|e9d9|性能监视器|无条件|打开系统性能监视器|run&#124;perfmon.exe|
|[1274](http://127.0.0.1:5151/runcom?aabb=1274)|e9f9|资源监视器|无条件|打开系统资源监视器|run&#124;resmon.exe|
|[1275](http://127.0.0.1:5151/runcom?aabb=1275)|e74e|磁盘管理|无条件|打开系统磁盘管理工具|run&#124;diskmgmt.msc|
|[1276](http://127.0.0.1:5151/runcom?aabb=1276)|ec26|共享管理|无条件|打开系统共享文件夹管理器|run&#124;fsmgmt.msc|
|[1277](http://127.0.0.1:5151/runcom?aabb=1277)|e8cf|用户和组|无条件|打开本机用户和组|run&#124;lusrmgr.msc|
|[1278](http://127.0.0.1:5151/runcom?aabb=1278)|ec31|屏幕键盘|无条件|打开系统的屏幕键盘|run&#124;osk.exe|
|[1279](http://127.0.0.1:5151/runcom?aabb=1279)|f5ff|电源选项|无条件|打开系统的电源选项|run&#124;powercfg.cpl|
|[1280](http://127.0.0.1:5151/runcom?aabb=1280)|f623|声音与音频|无条件|打开系统的声音与音频设置|run&#124;mmsys.cpl|
|[1281](http://127.0.0.1:5151/runcom?aabb=1281)|e95d|设备管理|无条件|打开系统的设备管理器|run&#124;hdwwiz.cpl|
|[1282](http://127.0.0.1:5151/runcom?aabb=1282)|f56d|设备管理|无条件|打开系统的设备管理器|run&#124;devmgmt.msc|
|[1283](http://127.0.0.1:5151/runcom?aabb=1283)|ec27|Internet|无条件|打开系统的 Internet 选项|run&#124;inetcpl.cpl|
|[1284](http://127.0.0.1:5151/runcom?aabb=1284)|ed15|用户账户|无条件|打开系统用户账户对话框|run&#124;netplwiz|
|[1285](http://127.0.0.1:5151/runcom?aabb=1285)|e995|音量合成|无条件|打开系统音量合成器|run&#124;sndvol.exe|
|[1286](http://127.0.0.1:5151/runcom?aabb=1286)|f8a6|文件选项|无条件|打开系统文件夹选项|run&#124;RunDll32.exe shell32.dll,Options_RunDLL|
|[1287](http://127.0.0.1:5151/runcom?aabb=1287)|f8a6|文件夹选项|无条件|打开系统文件夹选项|run&#124;control.exe folders|
|[1288](http://127.0.0.1:5151/runcom?aabb=1288)|f17f|字体设置|无条件|打开字体文件夹|run&#124;fonts|
|[1289](http://127.0.0.1:5151/runcom?aabb=1289)|f17f|字体设置|无条件|打开控制面板字体文件夹|run&#124;control.exe fonts|
|[1290](http://127.0.0.1:5151/runcom?aabb=1290)|e835|功能管理|无条件|打开启用或关闭 Windows 功能对话框|run&#124;OptionalFeatures.exe|
|[1291](http://127.0.0.1:5151/runcom?aabb=1291)|f69e|管理工具|无条件|打开控制面板管理工具文件夹|run&#124;control admintools|
|[1292](http://127.0.0.1:5151/runcom?aabb=1292)|ed5a|日期时间|无条件|打开控制面板日期和时间设置|run&#124;timedate.cpl|
|[1293](http://127.0.0.1:5151/runcom?aabb=1293)|e962|鼠标属性|无条件|打开控制面板鼠标属性|run&#124;main.cpl|
|[1294](http://127.0.0.1:5151/runcom?aabb=1294)|e775|区域和语言|无条件|打开控制面板区域和语言选项|run&#124;intl.cpl|
|[1295](http://127.0.0.1:5151/runcom?aabb=1295)|f8b0|任务栏设置|无条件|打开任务栏设置|run&#124;rundll32.exe shell32.dll,Options_RunDLL 1|
|1296|ed5a|[时间戳](/actions/1296.md)|选中文本|选中的文本进行时间戳和日期时间的互相转换|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\数字_时间戳转换.ahk" "%CandySel%"|
|1297|e71d|[文件列表](/actions/1297.md)|选中文件夹|显示选中文件夹中的所有文件的路径列表(整合版)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹_文件列表(整合版).ahk" "%CandySel%"|
|1298|e71d|[文件列表](/actions/1298.md)|选中文件夹|显示选中文件夹中的所有文件的路径列表(按 Ahk 遍历顺序)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹_文件列表.ahk" "%CandySel%"|
|1299|e71d|[文件列表](/actions/1299.md)|选中文件夹|显示选中文件夹中的所有文件的路径列表(按创建时间降序)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹_文件列表(按创建时间降序).ahk" "%CandySel%"|
|1300|e71d|[文件列表](/actions/1300.md)|选中文件夹|显示选中文件夹中的所有文件的路径列表(按最近修改时间降序)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹_文件列表(按最近修改时间降序).ahk" "%CandySel%"|
|1301|e71d|[文件列表](/actions/1301.md)|选中文件夹|显示选中文件夹中的所有文件的路径列表(按文件大小降序)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹_文件列表(按文件大小降序).ahk" "%CandySel%"|
|1302|e16d|[复制信息](/actions/1302.md)|选中文件|将资源管理器选中文件各列显示的信息复制到剪贴板|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\复制资源管理器各列的信息.ahk" "%CandySel%"|
|1303|e8c8|[ADS管理](/actions/1303.md)|选中文件夹|列出选中文件夹中带有ADS数据的文件, 并可以对ADS数据进行管理(新建, 删除, 另存为)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\管理文件ADS.ahk" "%CandySel%"|
|1304|f16c|[添加 ADS](/actions/1304.md)|选中文件|为选中的文件添加文本的 ADS 流(流名称为 ADS1, ADS2)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\添加文本到 ADS 流.ahk" "%CandySel%"|
|1305|ed5a|[HTML转文本](/actions/1305.md)|剪贴板|将剪贴板中的 HTML 源代码去掉标签转换为纯文本后粘贴|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\剪贴板中源代码转纯文本后粘贴.ahk"|
|1306|ed5a|[文本转HTML](/actions/1306.md)|剪贴板|将剪贴板中的 HTML 源代码转换为 HTML 后粘贴|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\剪贴板中源代码转html后粘贴.ahk"|
|1307|e844|[中英符号](/actions/1307.md)|选中文本|选中的单个标点符号中英互转(没选中时光标在标点后也可以进行转换)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\中英文符号转换.ahk" "%CandySel%" "%Windy_CurWin_id%"|
|1308|E77F|粘贴All|ET|将当前选中的单元格内容复制到所有以数字为名称的工作表的相同位置|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\ET_当前单元格内容复制到所有数字名称的工作表相同位置.ahk"|
|1309|f32a|软链接管理|选中文件夹|列出选中文件夹的软链接文件和文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\管理文件软链接.ahk" "%CandySel%"|
|1310|f32a|硬链接管理|选中文件夹|列出选中文件夹的硬链接文件和文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\管理文件硬链接.ahk" "%CandySel%"|
|1311|e16d|软硬链接检查|选中文件|检查选中文件是否存在硬链接文件, 或是否是软链接文件及显示其目标文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件软硬链接检查.ahk" "%CandySel%"|
|1312|E77F|列宽All|ET|所有以数字为名称的工作表的相同列的宽度设置为当前选中的单元格的列宽|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\ET_所有数字名称的工作表相同列设置当前单元格列宽.ahk"|
|[1313](http://127.0.0.1:5151/runcom?aabb=1313)|e8ec|[点击托盘](/actions/1313.md)|无条件|点击如意托盘图标显示面板(当前窗口设为桌面, 下部面板为未选中)|Cando&#124;TM_ShowMG|
|1314|E77F|水平对齐|ET|将当前选中的单元格对齐方式复制到所有以数字为名称的工作表的相同位置的单元格中|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\ET_当前单元格水平对齐方式复制到所有数字名称的工作表相同位置.ahk"|
|1315|e9d5|剪贴板|子面板|剪贴板子面板|Gui&#124;剪贴板通用|
|1316|f17f|[管理编码](/actions/1316.md)|选中文件夹|列出选中文件夹中文本文件编码, 批量转码|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\管理文本文件编码.ahk" "%CandySel%"|
|[1317](http://127.0.0.1:5151/runcom?aabb=1317)|e1e4|[Ini_Fav](/actions/1317.md)|无条件|Ini 文件显示为 Gui 面板(作为收藏夹使用)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\Ini_收藏夹界面.ahk"|
|1318|e802|插入列|ET|所有以数字为名称的工作表的相同位置的右侧插入一列|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\ET_数字名称的工作表相同位置右边批量插入一列.ahk"|
|1319|E803|删除列|ET|所有以数字为名称的工作表批量删除选中列|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\ET_数字名称的工作表批量删除选中列.ahk"|
|1320|f151|数字分表|子面板|ET_批量子面板|Gui&#124;ET_批量|
|[1321](http://127.0.0.1:5151/runcom?aabb=1321)|f142|Ahk 帮助|无条件|Autohotkey 帮助文件|run&#124;"%A_ScriptDir%\引用程序\AutoHotkeyLCN.chm"|
|[1322](http://127.0.0.1:5151/runcom?aabb=1322)|e11a|Ahk Spy|无条件|Autohotkey Spy|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\引用程序\WindowSpy.ahk"|
|1323|EDE3|窗口通用3|子面板|当前窗口的通用动作主面板3|Gui&#124;窗口通用3|
|1324|EDE3|窗口通用3|菜单|当前窗口的通用动作的菜单3|Menu&#124;窗口通用3|
|1325|e947|[关闭其他](/actions/1325.md)|任意窗口|关闭除当前窗口外的同进程名的所有其他窗口(拥有标题栏和最大化按钮的窗口)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\关闭同进程所有其他窗口.ahk"|
|1326|e947|[关闭其他](/actions/1326.md)|任意窗口|关闭除当前窗口外的所有其他窗口(只包括任务栏上可见的活动窗口)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\关闭所有其他窗口.ahk"|
|[1327](http://127.0.0.1:5151/runcom?aabb=1327)|e97c|[Bing壁纸](/actions/1327.md)|无条件|将Bing背景图片设置为桌面壁纸|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\Bing壁纸.ahk"|
|[1328](http://127.0.0.1:5151/runcom?aabb=1328)|e97c|壁纸路径|无条件|获取桌面壁纸的文件路径|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\壁纸路径.ahk"|
|[1329](http://127.0.0.1:5151/runcom?aabb=1329)|f738|整点敲钟|无条件|整点半点敲钟|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\时间_整点半点敲钟.ahk"|
|[1330](http://127.0.0.1:5151/runcom?aabb=1330)|f739|节日提醒|无条件|节日提醒|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\时间_节日提醒.ahk"|
|1331|e97c|[设为壁纸](/actions/1331.md)|选中文件|将选中图片文件设置为桌面壁纸(第一块屏幕)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件_设置壁纸.ahk" "%CandySel%"|
|[1332](http://127.0.0.1:5151/runcom?aabb=1332)|e97c|随机壁纸|无条件|将下载Bing背景图片的随机缓存文件设置为桌面壁纸|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\将指定文件设为壁纸.ahk"|
|1333|f17f|[文本批量](/actions/1333.md)|选中文件夹|对文件夹中文本文件进行批量操作(替换, 开头(/结尾)新增(/删除)一行)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文本文件批量操作.ahk" "%CandySel%"|
|[1334](http://127.0.0.1:5151/runcom?aabb=1334)|f384|重启以太网|无条件|禁用以太网后重新启用(Win7 中显示为本地连接)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\禁用启用网络连接.ahk"|
|[1335](http://127.0.0.1:5151/runcom?aabb=1335)|f385|重启以太网|无条件|禁用以太网后重新启用(Win7 中显示为本地连接)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\禁用启用网络连接2.ahk"|
|1336|e164|[Base64解](/actions/1336.md)|选中文本|将选中的Base64文本解密, 显示加密前的文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\Base64解密.ahk" "%CandySel%"|
|1337|e8dd|[Base64加](/actions/1337.md)|选中文本|将选中的文本进行Base64加密|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\Base64加密.ahk" "%CandySel%"|
|1338|e790|[Base64解](/actions/1338.md)|选中文本|将选中的Base64解密, 显示加密前的图片|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\Base64解密为图片.ahk" "%CandySel%"|
|1339|e790|[转Base64](/actions/1339.md)|选中文件|将选中图片文件转为Base64编码|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像转为Base64.ahk" "%CandySel%"|
|1340|eb41|[B64转HTML](/actions/1340.md)|剪贴板|将剪贴板中的 Base64 码转换为 HTML 后粘贴|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\剪贴板中的Base64转html后粘贴.ahk"|
|1341|e790|[B64转图片](/actions/1341.md)|剪贴板|将剪贴板中的 Base64 码转换为图片后粘贴|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\剪贴板中的Base64转图片后粘贴.ahk"|
|[1342](http://127.0.0.1:5151/runcom?aabb=1342)|f10d|[菜单管理](/actions/1342.md)|无条件|管理如意在资源管理器选中文件右键菜单中要显示的项目(添加,删除,备份,恢复)|Cando&#124;AddtoMenu|
|[1343](http://127.0.0.1:5151/runcom?aabb=1343)|f78a|[退出如意](/actions/1343.md)|无条件|退出如意|Cando&#124;TM_Exit|
|1344|e16d|[FileToClip](/actions/1344.md)|剪贴板|将路径对应的文件复制到剪贴板|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\根据路径将文件复制到剪贴板.ahk"  "%CandySel%"|
|[1345](http://127.0.0.1:5151/runcom?aabb=1345)|E70F|写字板|无条件|打开系统写字板|run&#124;wordpad.exe|
|[1346](http://127.0.0.1:5151/runcom?aabb=1346)|ec57|wmplayer|无条件|打开系统 wmplayer|run&#124;wmplayer.exe|
|[1347](http://127.0.0.1:5151/runcom?aabb=1347)|ec57|截图工具|无条件|打开系统截图工具|run&#124;SnippingTool.exe|
|[1348](http://127.0.0.1:5151/runcom?aabb=1348)|E70F|字符映射表|无条件|打开系统字符映射表|run&#124;charmap.exe|
|[1349](http://127.0.0.1:5151/runcom?aabb=1349)|e12e|放大镜|无条件|打开系统放大镜|run&#124;Magnify.exe|
|1350|e164|[文本对比](/actions/1350.md)|选中对象|网页版的文本对比|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\文本对比(WebView2).ahk2" "%CandySel%"|
|1351|f5a6|[文本对比2](/actions/1350.md)|选中对象|将选中对象放入文本对比的右侧界面|canfunc&#124;ExecSend&#124;%CandySel%&#124;文本对比 ahk_class AutoHotkey|
|1352|f17f|[批量重命名](/actions/1352.md)|选中文件夹|对文件夹中的文件进行批量重命名操作|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\批量重命名.ahk" "%CandySel%"|
|[1353](http://127.0.0.1:5151/runcom?aabb=1353)|e992|[静音切换](/actions/1353.md)|无条件|系统静音切换|canfunc&#124;CF_静音|
|[1354](http://127.0.0.1:5151/runcom?aabb=1354)|e198|[静音](/actions/1353.md)|无条件|系统静音|canfunc&#124;CF_静音&#124;1|
|[1355](http://127.0.0.1:5151/runcom?aabb=1355)|e995|[取消静音](/actions/1353.md)|无条件|系统取消静音|canfunc&#124;CF_静音&#124;0|
|[1356](http://127.0.0.1:5151/runcom?aabb=1356)|e7e8|[关机](/actions/1356.md)|无条件|关机|canfunc&#124;CF_关机或重启|
|[1357](http://127.0.0.1:5151/runcom?aabb=1357)|e7e8|[强制关机](/actions/1356.md)|无条件|强制关机|canfunc&#124;CF_关机或重启&#124;13|
|[1358](http://127.0.0.1:5151/runcom?aabb=1358)|e8ee|[重启](/actions/1356.md)|无条件|重启|canfunc&#124;CF_关机或重启&#124;2|
|[1359](http://127.0.0.1:5151/runcom?aabb=1359)|e8ee|[强制重启](/actions/1356.md)|无条件|强制重启|canfunc&#124;CF_关机或重启&#124;6|
|[1360](http://127.0.0.1:5151/runcom?aabb=1360)|f617|[截取屏幕](/actions/1360.md)|无条件|截取显示器屏幕并保存到脚本指定的路径(网页控制使用)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\截图.ahk" "%A_ScriptDir%\临时目录\Screen.jpg"|
|[1361](http://127.0.0.1:5151/runcom?aabb=1361)|e992|[显示桌面](/actions/1361.md)|无条件|最小化所有窗口(显示桌面)|canfunc&#124;CF_WinMinimizeAll|
|[1362](http://127.0.0.1:5151/runcom?aabb=1362)|E107|[清空回收站](/actions/1362.md)|无条件|清空回收站|canfunc&#124;CF_FileRecycleEmpty|
|[1363](http://127.0.0.1:5151/runcom?aabb=1363)|f8ac|上一首|无条件|播放器上一首(foobar2000, wmplayer, ttplayer, Winamp)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\播放器控制.ahk" "/prev"|
|[1364](http://127.0.0.1:5151/runcom?aabb=1364)|f8ae|暂停|无条件|播放器暂停(foobar2000, wmplayer, ttplayer, Winamp)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\播放器控制.ahk" "/pause"|
|[1365](http://127.0.0.1:5151/runcom?aabb=1365)|f8ad|下一首|无条件|播放器下一首(foobar2000, wmplayer, ttplayer, Winamp)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\播放器控制.ahk" "/next"|
|[1366](http://127.0.0.1:5151/runcom?aabb=1366)|edae|退出|无条件|播放器退出(foobar2000, wmplayer, ttplayer, Winamp)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\播放器控制.ahk" "/close"|
|[1367](http://127.0.0.1:5151/runcom?aabb=1367)|e94d|24点|无条件|4 个随机数字(1-10) 计算 24 点|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\游戏\24点.ahk"|
|[1368](http://127.0.0.1:5151/runcom?aabb=1368)|ecaa|俄罗斯方块|无条件|游戏: 俄罗斯方块|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\游戏\俄罗斯方块.ahk"|
|[1369](http://127.0.0.1:5151/runcom?aabb=1369)|e75f|数独|无条件|游戏: 数独|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\游戏\数独.ahk"|
|[1370](http://127.0.0.1:5151/runcom?aabb=1370)|f147|2048|无条件|游戏: 2048|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\游戏\2048.ahk"|
|[1371](http://127.0.0.1:5151/runcom?aabb=1371)|e9b9|贪吃蛇|无条件|游戏: 贪吃蛇|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\游戏\贪吃蛇.ahk"|
|[1372](http://127.0.0.1:5151/runcom?aabb=1372)|ecaa|俄罗斯方块|无条件|游戏: 俄罗斯方块|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\俄罗斯方块.ahk2"|
|[1373](http://127.0.0.1:5151/runcom?aabb=1373)|e8b0|鼠标残影|无条件|工具: 鼠标残影|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\鼠标残影.ahk"|
|[1374](http://127.0.0.1:5151/runcom?aabb=1374)|eb82|点击特效|无条件|工具: 鼠标点击视觉特效|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\鼠标点击视觉特效.ahk"|
|[1375](http://127.0.0.1:5151/runcom?aabb=1375)|f128|鼠标尾巴|无条件|工具: 鼠标尾巴|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\鼠标尾巴.ahk"|
|[1376](http://127.0.0.1:5151/runcom?aabb=1376)|e109|画十字|无条件|工具: 画十字(启动后快捷键 Alt+q)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\画十字.ahk"|
|1377|e8c1|uri编码转|选中文件|重命名: uri编码转中文字符|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件名_uri编码转中文字符.ahk" "%CandySel%"|
|1378|e8c1|爱词霸|选中文本|使用爱词霸翻译选中的文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\爱词霸词典.ahk" "%CandySel%"|
|1379|EDE3|目录通用2|菜单|选中文件夹的通用动作的菜单|Menu&#124;文件夹通用2|
|1380|EDE3|目录通用2|子面板|选中文件夹的通用动作的菜单|Gui&#124;文件夹通用2|
|1381|e8b7|彩色目录|子面板|彩色文件夹的子面板|Gui&#124;彩色目录|
|1382|e188@DD3c4F|[红色图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为红色.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "红色"|
|1383|e188@27BB27|[绿色图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为绿色.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "绿色"|
|1384|e188@2242DF|[蓝色图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为蓝色.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "蓝色"|
|1385|e188@6C2490|[蓝紫图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为蓝紫.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "蓝紫"|
|1386|e188@353535|[黑色图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为黑色.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "黑色"|
|1387|e188@C74A90|[紫色图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为紫色.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "紫色"|
|1388|e188@C3A81C|[金色图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为金色.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "金色"|
|1389|e188@FB9A12|[橘色图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为橘色.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "橘色"|
|1390|e188@BEBBB1|[银灰图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为银灰.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "银灰"|
|1391|e8b7@62CBB9|[青色图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为青色.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "青色"|
|1392|e188@E9AAAA|[粉红图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为粉红.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "粉红"|
|1393|e188@8D5E2F|[棕色图标](/actions/1382.md)|选中文件夹|将文件夹的图标设置为棕色.ico|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\彩色文件夹.ahk" "%CandySel%" "棕色"|
|1394|ef3b|测试|选中对象|测试插件脚本里的例子2|canfunc&#124;ExecSendToDll&#124;%CandySel%&#124;1394|
|[1395](http://127.0.0.1:5151/runcom?aabb=1395)|e11a|Ahk Spy|无条件|第三方的 Autohotkey Spy|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\AhkSpy.ahk"|
|1396|e11a|IconEx|选中文件|提取文件(Exe, Dll) 中的图标|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\IconEx.ahk" "%CandySel%"|
|1397|e8c1|Id3v2|选中文件|读取修改音频文件的标签|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\音频文件标签.ahk" "%CandySel%"|
|1398|e8c1|deepl|选中文本|使用deepl翻译选中的文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\Deepl翻译.ahk" "%CandySel%"|
|1399|e97c|[设为壁纸](/actions/1399.md)|选中文件|将选中图片文件设置为桌面壁纸(第二块屏幕)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件_设置壁纸.ahk" "%CandySel%" "2"|
|1400|EDE3|长文本|子面板|选中长文本的通用动作的子面板|Gui&#124;长文本通用|
|1401|f19d|[详细信息](/actions/1401.md)|选中文件|获取选中文件的额外属性|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件_额外的属性(ExtendedProperty).ahk" "%CandySel%"|
|1402|f19d|[查看属性](/actions/1402.md)|选中文件|获取选中文件的资源管理器详细信息列中能列出的属性|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件_额外的属性(GetDetailsOf).ahk" "%CandySel%"|
|1403|e197|[虚拟为磁盘 X](/actions/1403.md)|选中文件夹|将选中文件夹挂载为虚拟磁盘 X:|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹_虚拟磁盘.ahk" "%CandySel%" "X"|
|1404|e159|[卸载磁盘](/actions/1404.md)|选中驱动器|卸载文件夹挂载的虚拟磁盘|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹_虚拟磁盘.ahk" "%CandySel%"|
|1405|e197|[载为目录](/actions/1405.md)|选中磁盘|将选中磁盘挂载到指定文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\磁盘_挂载为文件夹.ahk" "%CandySel%" "C:\123"|
|1406|e159|[取消挂载](/actions/1406.md)|选中文件夹|将选中文件夹(分区挂载的文件夹) 取消挂载|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹_取消挂载.ahk" "%CandySel%"|
|1407|e8c1|Bing词典|选中文本|使用Bing网络词典翻译选中的单词文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\Bing词典.ahk" "%CandySel%"|
|1408|e8c1|有道词典|选中文本|使用有道网络词典翻译选中的单词文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\有道词典.ahk" "%CandySel%"|
|1409|ed11|[加入Ini_Fav](/actions/1409.md)|选中对象|将选中对象(文件, 网址) 添加到 Ini 收藏夹(向 ATA 发送动作编号)|SendMsgToATA&#124;1247&#124;%CandySel%|
|[1410](http://127.0.0.1:5151/runcom?aabb=1410)|edb4|[暂停如意](/actions/1410.md)|无条件|暂停如意|Cando&#124;TM_Pause|
|[1411](http://127.0.0.1:5151/runcom?aabb=1411)|e149|[重启如意](/actions/1411.md)|无条件|重启如意|Cando&#124;TM_Reload|
|[1412](http://127.0.0.1:5151/runcom?aabb=1412)|e8ec|[如意托盘菜单](/actions/1412.md)|无条件|显示如意的托盘菜单(右击托盘图标显示的菜单)|Cando&#124;TM_show|
|[1413](http://127.0.0.1:5151/runcom?aabb=1413)|e8ec|[如意设置](/actions/1413.md)|无条件|显示如意的设置界面|Cando&#124;TM_SettingsM|
|[1414](http://127.0.0.1:5151/runcom?aabb=1414)|e121|定时管理|无条件|自动运行动作的管理界面(启动跟随,定时动作,监控剪贴板,监控文件夹,监控窗口)|Cando&#124;TimingActionM|
|1415|f71c|窗口进程目录|任意窗口|打开窗口进程文件所在的目录(避免 QTTabBar 打开新窗口)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\打开窗口进程目录.ahk" "%Windy_CurWin_Fullpath%"|
|[1416](http://127.0.0.1:5151/runcom?aabb=1416)|f8af|移动鼠标|无条件|移动鼠标到指定坐标并点击鼠标左键|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\移动鼠标.ahk" "%CandySel%"|
|[1417](http://127.0.0.1:5151/runcom?aabb=1417)|e961|屏蔽键盘|无条件|临时屏蔽键盘按键|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\屏蔽键盘.ahk"|
|[1418](http://127.0.0.1:5151/runcom?aabb=1418)|E756|CMD|无条件|标准用户下以管理员权限打开 CMD|run&#124;runas /user:administrator cmd|
|[1419](http://127.0.0.1:5151/runcom?aabb=1419)|E756|UAC|无条件|打开 UAC 通知管理(拉到最底部只是关闭 UAC 通知, 并不是关闭 UAC)|run&#124;C:\WINDOWS\System32\UserAccountControlSettings.exe|
|[1420](http://127.0.0.1:5151/runcom?aabb=1420)|E756|UAC|无条件|打开 UAC 通知管理(以管理员身份打开)|run&#124;runas /user:administrator C:\WINDOWS\System32\UserAccountControlSettings.exe|
|1421|f19d|[文件属性](/actions/1421.md)|选中文件|打开选中文件系统属性对话框|CanFunc&#124;CF_OpenProp&#124;%CandySel%|
|[1422](http://127.0.0.1:5151/runcom?aabb=1422)|E756|远程协助|无条件|工具: 系统远程协助|run&#124;msra.exe|
|[1423](http://127.0.0.1:5151/runcom?aabb=1423)|E107|[回收站预览](/actions/1423.md)|无条件|显示回收站中的文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件预览.ahk" "::{645FF040-5081-101B-9F08-00AA002F954E}"|
|[1424](http://127.0.0.1:5151/runcom?aabb=1424)|f5a9|[同时编辑](/actions/1424.md)|选中文件|同时使用记事本打开两个文件夹下(当前打开的文件夹) 的同名文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\同时编辑两个同名的文件.ahk" "%CandySel%"|
|1425|EDE3|通用4|菜单|选中文件的通用动作的菜单|Menu&#124;文件通用4|
|1426|EDE3|通用4|子面板|选中文件的通用动作的子面板|Gui&#124;文件通用4|
|1427|EDE3|Ahk通用|菜单|选中ahk文件通用动作的菜单|Menu&#124;ahk文件通用|
|[1428](http://127.0.0.1:5151/runcom?aabb=1428)|e775|输入法指示|无条件|工具: 在鼠标旁边显示当前窗口输入法状态(A, 中, 英)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\输入法指示器.ahk"|
|[1429](http://127.0.0.1:5151/runcom?aabb=1429)|e8d2|[脚本管理器](/actions/1429.md)|无条件|Ahk 脚本管理器|Cando&#124;ScriptManager|
|[1430](http://127.0.0.1:5151/runcom?aabb=1430)|f597|托盘图标管理|无条件|显示隐藏系统托盘区域中图标|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\托盘图标管理器.ahk"|
|[1431](http://127.0.0.1:5151/runcom?aabb=1431)|e1e0|[普通权限](/actions/1431.md)|无条件|使用标准用户的权限创建任务计划,通过打开计划来打开文件(普通用户下以管理员权限运行如意以普通权限来打开文件)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\通过当前用户的权限新建任务计划并执行打开文件.ahk" "c:\windows\system32\cmd.exe"|
|[1432](http://127.0.0.1:5151/runcom?aabb=1432)|e1e0|[普通权限](/actions/1432.md)|无条件|使用当前 Shell 的权限(正常情况下为登录用户的权限) 打开文件(以管理员权限运行如意时想以普通用户的权限打开文件)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\通过桌面权限打开文件(ShellRun).ahk"  "cmd.exe"|
|[1433](http://127.0.0.1:5151/runcom?aabb=1433)|e198|[隐藏静音](/actions/1433.md)|无条件|将任意窗口隐藏并静音, 再次运行恢复|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\隐藏窗口并静音.ahk" "%Windy_CurWin_id%"|
|[1434](http://127.0.0.1:5151/runcom?aabb=1434)|ec80|保存桌面位置|无条件|将桌面图标位置信息保存到临时文件夹, 并删除7天前保存的文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\保存和恢复桌面图标位置.ahk"|
|[1435](http://127.0.0.1:5151/runcom?aabb=1435)|ec77|恢复桌面位置|无条件|利用先前保存的文件恢复桌面图标|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\保存和恢复桌面图标位置.ahk" "restore"|
|[1436](http://127.0.0.1:5151/runcom?aabb=1436)|ef3c|[获取颜色](/actions/1436.md)|无条件|查看选中数字对应的颜色, 并带有取色功能|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\取色小程序.ahk" "%CandySel%"|
|[1437](http://127.0.0.1:5151/runcom?aabb=1437)|f16a|[暂时隐藏](/actions/1437.md)|任意窗口|将任意窗口暂时隐藏 3 秒后恢复显示(任务栏按钮会被放到同类的最右边)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\暂时隐藏窗口.ahk" "%Windy_CurWin_id%"|
|1438|e8e7|[保存并运行](/actions/1438.md)|选中文本|将选中 Ahk 代码文本保存到当前用户的桌面并运行|canfunc&#124;CF_CopyToDesktopAndRun|
|1439|E70F|[打开本地网页](/actions/1439.md)|Chrome|使用文本编辑器打开浏览器正在浏览的本地文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\记事本打开浏览器当前浏览的本地文件.ahk" "%Windy_CurWin_Class%"|
|[1440](http://127.0.0.1:5151/runcom?aabb=1440)|E107|[回收站预览](/actions/1440.md)|无条件|显示当前登录用户的回收站中的文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\当前用户回收站中的文件信息.ahk"|
|[1441](http://127.0.0.1:5151/runcom?aabb=1441)|f58b|系统切换任务|无条件|显示系统切换窗口界面|Keys&#124;^!{Tab}|
|1442|f61b|[新建文本文件](/actions/1442.md)|特定窗口|在当前打开的目录新建文本文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件_新建.ahk" "%Windy_CurWin_FolderPath%" "文本文件"|
|1443|f407|[新建文件夹](/actions/1443.md)|特定窗口|在当前打开的目录新建文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件_新建.ahk"|
|[1444](http://127.0.0.1:5151/runcom?aabb=1444)|eda9|保存WPS菜单|无条件|保存 WPS 任务栏按钮的 JumpList 菜单文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\保存和恢复WPS任务栏的JumpList项目菜单.ahk"|
|[1445](http://127.0.0.1:5151/runcom?aabb=1445)|edaa|恢复WPS菜单|无条件|利用先前保存的 WPS 任务栏按钮的 JumpList 菜单文件来恢复 WPS 的任务栏按钮菜单|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\保存和恢复WPS任务栏的JumpList项目菜单.ahk" "restore"|
|[1446](http://127.0.0.1:5151/runcom?aabb=1446)|e1e1|任务栏快捷键|无条件|按下 Win 键在任务栏上显示编号, 然后使用 Win+ 数字键(1-9) 激活任务栏上的按钮的窗口(已经打开的)(适用于任务栏在底部的情况)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\任务栏按钮窗口热键切换.ahk" "1"|
|[1447](http://127.0.0.1:5151/runcom?aabb=1447)|e1e1|任务栏快捷键|无条件|按下 Win 键在任务栏上显示编号, 然后使用 Win+ 数字键(1-9) 激活任务栏上的按钮的窗口(所有)(适用于任务栏在底部的情况)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\任务栏按钮窗口热键切换.ahk" "0"|
|[1448](http://127.0.0.1:5151/runcom?aabb=1448)|e1e1|任务栏按钮列表|无条件|显示任务栏上按钮窗口列表的菜单(已经打开的窗口)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\指定激活任务栏按钮窗口.ahk" "menu"|
|[1449](http://127.0.0.1:5151/runcom?aabb=1449)|e1e1|指定任务栏按钮|无条件|按传入的数字激活任务栏上按钮窗口(已经打开的窗口)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\指定激活任务栏按钮窗口.ahk" "1"|
|1450|e8c1|Dll 文本|选中文本|根据注册表中的文本(如 notepad.exe,470) 查看 dll, exe 文件中的字符串|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\dll文本查看.ahk" "%CandySel%"|
|1451|ea3a|Dll 图标|选中文本|根据注册表中的文本(如 shell32.dll,-16802) 查看 dll, exe 文件中的图标|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\dll图标查看.ahk" "%CandySel%"|
|1452|EDE3|虚拟桌面|子面板|虚拟桌面动作的子面板|Gui&#124;虚拟桌面|
|[1453](http://127.0.0.1:5151/runcom?aabb=1453)|f146|[虚拟桌面1](/actions/1453.md)|无条件|切换到虚拟桌面1|SendMsgToATA&#124;&#124;1|
|[1454](http://127.0.0.1:5151/runcom?aabb=1454)|f147|[虚拟桌面2](/actions/1453.md)|无条件|切换到虚拟桌面2|SendMsgToATA&#124;&#124;2|
|[1455](http://127.0.0.1:5151/runcom?aabb=1455)|f148|[虚拟桌面3](/actions/1453.md)|无条件|切换到虚拟桌面3|SendMsgToATA&#124;1455&#124;3|
|1456|f093|[移到桌面1](/actions/1456.md)|任意窗口|将鼠标下的窗口移动到虚拟桌面1|SendMsgToATA&#124;&#124;%Windy_CurWin_Title%&#124;1|
|1457|f094|[移到桌面2](/actions/1456.md)|任意窗口|将鼠标下的窗口移动到虚拟桌面2|SendMsgToATA&#124;&#124;%Windy_CurWin_Title%&#124;2|
|1458|f095|[移到桌面3](/actions/1456.md)|任意窗口|将鼠标下的窗口移动到虚拟桌面3|SendMsgToATA&#124;1458&#124;%Windy_CurWin_Title%&#124;3|
|1459|f146|[移并跳桌面1](/actions/1459.md)|任意窗口|将鼠标下的窗口移动到虚拟桌面1, 并跳转到虚拟桌面1|SendMsgToATA&#124;&#124;%Windy_CurWin_Title%&#124;1|
|1460|f147|[移并跳桌面2](/actions/1459.md)|任意窗口|将鼠标下的窗口移动到虚拟桌面2, 并跳转到虚拟桌面2|SendMsgToATA&#124;&#124;%Windy_CurWin_Title%&#124;2|
|1461|f148|[移并跳桌面3](/actions/1459.md)|任意窗口|将鼠标下的窗口移动到虚拟桌面3, 并跳转到虚拟桌面2|SendMsgToATA&#124;&#124;%Windy_CurWin_Title%&#124;3|
|1462|ea44|[所有桌面显示窗口](/actions/1462.md)|任意窗口|将鼠标下的窗口在所有的虚拟桌面显示|SendMsgToATA&#124;&#124;%Windy_CurWin_Title%|
|1463|ea43|[所有桌面显示进程](/actions/1463.md)|任意窗口|将鼠标下的窗口进程在所有的虚拟桌面显示|SendMsgToATA&#124;&#124;%Windy_CurWin_Title%|
|1464|e122|[虚拟桌面找窗口](/actions/1464.md)|任意窗口|首次运行时将鼠标下的窗口标记, 再次运行时跳到窗口所在虚拟桌面(寻剑)|SendMsgToATA&#124;&#124;%Windy_CurWin_Title%|
|1465|ea63|[虚拟桌面窗口来](/actions/1465.md)|任意窗口|首次运行时将鼠标下的窗口标记, 再次运行时将标记窗口移到所在虚拟桌面(剑来)|SendMsgToATA&#124;&#124;%Windy_CurWin_Title%|
|1466|f19d|[微缩窗口0.3](/actions/1466.md)|任意窗口|以动态缩略图方式显示(原窗口的0.3)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\动态缩略图.ahk" "%Windy_CurWin_id%"|
|[1467](http://127.0.0.1:5151/runcom?aabb=1467)|e76c|[下一虚拟桌面](/actions/1467.md)|无条件|切换到下一虚拟桌面|SendMsgToATA&#124;1467|
|[1468](http://127.0.0.1:5151/runcom?aabb=1468)|e76b|[上一虚拟桌面](/actions/1468.md)|无条件|切换到上一虚拟桌面|SendMsgToATA&#124;|
|[1469](http://127.0.0.1:5151/runcom?aabb=1469)|e76c|[下一虚拟桌面](/actions/1469.md)|无条件|切换到下一虚拟桌面(VirtualDesktopAccessor_Win10/11.dll)|SendMsgToATA&#124;1469|
|[1470](http://127.0.0.1:5151/runcom?aabb=1470)|e76b|[上一虚拟桌面](/actions/1470.md)|无条件|切换到上一虚拟桌面|SendMsgToATA&#124;|
|[1471](http://127.0.0.1:5151/runcom?aabb=1471)|f146|[虚拟桌面1](/actions/1471.md)|无条件|切换到虚拟桌面1|SendMsgToATA&#124;&#124;0|
|[1472](http://127.0.0.1:5151/runcom?aabb=1472)|f147|[虚拟桌面2](/actions/1471.md)|无条件|切换到虚拟桌面2|SendMsgToATA&#124;&#124;1|
|[1473](http://127.0.0.1:5151/runcom?aabb=1473)|f148|[虚拟桌面3](/actions/1471.md)|无条件|切换到虚拟桌面3|SendMsgToATA&#124;&#124;2|
|1474|f146|[移并跳桌面1](/actions/1474.md)|任意窗口|将鼠标下的窗口移动到虚拟桌面1, 并跳转到虚拟桌面1|SendMsgToATA&#124;&#124;0&#124;%Windy_CurWin_Id%|
|1475|f147|[移并跳桌面2](/actions/1474.md)|任意窗口|将鼠标下的窗口移动到虚拟桌面2, 并跳转到虚拟桌面2|SendMsgToATA&#124;&#124;1&#124;%Windy_CurWin_Id%|
|1476|f148|[移并跳桌面3](/actions/1474.md)|任意窗口|将鼠标下的窗口移动到虚拟桌面3, 并跳转到虚拟桌面3|SendMsgToATA&#124;&#124;2&#124;%Windy_CurWin_Id%|
|1477|f354|[黑转透明](/actions/1477.md)|选中文件|将图片中的黑色转为透明|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像文件_指定颜色变透明.ahk" "%CandySel%" "0x000000"|
|1478|e790|[白转透明](/actions/1478.md)|选中文件|将图片中的白色转为透明|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像文件_指定颜色变透明.ahk" "%CandySel%" "0xFFFFFF"|
|1479|f406|[白转红](/actions/1479.md)|选中文件|将图片中的白色转为红色|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像文件_颜色替换.ahk" "%CandySel%" "0xFFFFFFFF" "0xFFFF0000"|
|1480|e790|[白转透明](/actions/1480.md)|选中文件|将图片中的白色转为透明|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像文件_颜色替换.ahk" "%CandySel%" "0xFFFFFFFF" "0x00000000"|
|1481|f406|[留白转红](/actions/1481.md)|选中文件|保留图片中的白色, 其他所有颜色转为红色|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像文件_保留指定颜色.ahk" "%CandySel%" "0xFFFFFFFF" "0xFFFF0000"|
|1482|eb9f|[转 Ico](/actions/1482.md)|选中文件|将选中的图片文件转为 Ico 文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像文件_转为Ico文件.ahk" "%CandySel%"|
|1483|eb3c|图片转换|子面板|图片转换动作子面板|Gui&#124;图片转换|
|1484|eb9f|[转为png](/actions/1484.md)|选中文件|将选中的图形文件转为png|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像缩小一半.ahk" "%CandySel%" "png"|
|1485|eb9f|[转为jpg](/actions/1485.md)|选中文件|将选中的图形文件转为jpg|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像缩小一半.ahk" "%CandySel%" "jpg"|
|[1486](http://127.0.0.1:5151/runcom?aabb=1486)|e115|系统设置|无条件|打开系统设置(Win10)|run&#124;ms-settings:system|
|[1487](http://127.0.0.1:5151/runcom?aabb=1487)|e783|系统关于|无条件|打开系统关于设置(Win10)|run&#124;ms-settings:about|
|[1488](http://127.0.0.1:5151/runcom?aabb=1488)|e7f4|屏幕设置|无条件|打开系统屏幕设置(Win10)|run&#124;ms-settings:display|
|[1489](http://127.0.0.1:5151/runcom?aabb=1489)|e895|更新设置|无条件|打开系统Windows更新设置(Win10)|run&#124;ms-settings:windowsupdate|
|[1490](http://127.0.0.1:5151/runcom?aabb=1490)|ed15|个性化设置|无条件|打开系统个性化设置(Win10)|run&#124;ms-settings:personalization|
|[1491](http://127.0.0.1:5151/runcom?aabb=1491)|e790|颜色设置|无条件|打开系统颜色设置(Win10)|run&#124;ms-settings:colors|
|[1492](http://127.0.0.1:5151/runcom?aabb=1492)|e771|主题设置|无条件|打开系统主题设置(Win10)|run&#124;ms-settings:themes|
|[1493](http://127.0.0.1:5151/runcom?aabb=1493)|e147|任务栏设置|无条件|打开系统任务栏设置(Win10)|run&#124;ms-settings:taskbar|
|[1494](http://127.0.0.1:5151/runcom?aabb=1494)|e185|字体设置|无条件|打开系统字体设置(Win10)|run&#124;ms-settings:fonts|
|[1495](http://127.0.0.1:5151/runcom?aabb=1495)|e179|应用和功能|无条件|打开系统应用和功能设置(Win10)|run&#124;ms-settings:appsfeatures|
|[1496](http://127.0.0.1:5151/runcom?aabb=1496)|e18d|启动设置|无条件|打开系统启动设置(Win10)|run&#124;ms-settings:startupapps|
|[1497](http://127.0.0.1:5151/runcom?aabb=1497)|e8c1|语言设置|无条件|打开系统语言设置(Win10)|run&#124;ms-settings:regionlanguage|
|[1498](http://127.0.0.1:5151/runcom?aabb=1498)|ed25|开始菜单|无条件|打开开始菜单目录|run&#124;shell:Start Menu|
|[1499](http://127.0.0.1:5151/runcom?aabb=1499)|ed25|SendTo|无条件|打开发送到目录|run&#124;shell:SendTo|
|[1500](http://127.0.0.1:5151/runcom?aabb=1500)|ed25|最近的文档|无条件|打开最近的文档目录|run&#124;shell:Recent|
|[1501](http://127.0.0.1:5151/runcom?aabb=1501)|ed25|用户目录|无条件|打开用户目录|run&#124;shell:Profile|
|[1502](http://127.0.0.1:5151/runcom?aabb=1502)|e839|桌面图标|无条件|打开桌面图标设置|run&#124;Rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0|
|[1503](http://127.0.0.1:5151/runcom?aabb=1503)|e9a6|[截取窗口](/actions/1503.md)|任意窗口|窗口截图并存入脚本所在目录的截图目录中(带窗口标题栏和鼠标光标)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\截图并自动保存.ahk" "" "Window" "%Windy_CurWin_Id%" "1"|
|1504|e982|文本编辑|子面板|文本编辑子面板|gui&#124;文本编辑|
|1505|e700|[去除空行](/actions/1505.md)|选中文本|如果有选中文本,去除选中文本中的空行(否则为全选文本)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\文本处理_去除空白行.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1506|e762|[整理序号](/actions/1506.md)|选中文本|如果有选中文本,按数字顺序整理选中文本的行号(否则为全选文本)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\文本处理_数字序号整理.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1507|f406|[留黑转白](/actions/1507.md)|选中文件|保留图片中的黑色, 其他所有颜色转为白色|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像文件_保留指定颜色.ahk" "%CandySel%" "0x000000" "0xFFFFFF"|
|[1508](http://127.0.0.1:5151/runcom?aabb=1508)|e7f4|屏保设置|无条件|打开屏幕保护程序设置|run&#124;rundll32.exe shell32.dll,Control_RunDLL desk.cpl,ScreenSaver,@ScreenSaver|
|[1509](http://127.0.0.1:5151/runcom?aabb=1509)|e7f4|气泡屏保|无条件|打开气泡屏幕保护程序|run&#124;%windir%\system32\Bubbles.scr /s|
|[1510](http://127.0.0.1:5151/runcom?aabb=1510)|e7f4|[启动屏保](/actions/1510.md)|无条件|打开设置的屏幕保护程序(如果没有设置, 则没有效果)|Cando&#124;RunScreenSaver|
|[1511](http://127.0.0.1:5151/runcom?aabb=1511)|e790|[浅色模式](/actions/1511.md)|无条件|打开系统浅色模式(Win10+)|Cando&#124;LightTheme|
|[1512](http://127.0.0.1:5151/runcom?aabb=1512)|f354|[深色模式](/actions/1512.md)|无条件|打开系统深色模式(Win10+)|Cando&#124;DarkTheme|
|[1513](http://127.0.0.1:5151/runcom?aabb=1513)|e18d|启动文件夹|无条件|打开开始菜单启动文件夹|run&#124;shell:startup|
|[1514](http://127.0.0.1:5151/runcom?aabb=1514)|ec27|网络设置|无条件|打开系统网络设置(Win10)|run&#124;ms-settings:network|
|1515|f7b6|[去除空格](/actions/1515.md)|选中文本|如果有选中文本, 去除选中文本中的所有空格(否则为全选文本)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\文本处理_去除空格.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1516|f5ad|[Ini_Fav](/actions/1516.md)|无条件|Ini 文件显示为列表面板(作为收藏夹使用)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\Ini_收藏夹列表.ahk" "%Windy_CurWin_Id%"|
|1517|e1e4|Ini_Fav|子面板|Ini_Fav相关动作的子面板|Gui&#124;Ini_Fav|
|1518|E894|[结束进程](/actions/1518.md)|选中文件|根据选中exe文件的名称来结束同名的进程|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\结束文件同名进程.ahk" "%CandySel%"|
|[1519](http://127.0.0.1:5151/runcom?aabb=1519)|e18d|锁定电脑|无条件|锁定电脑|run&#124;rundll32.exe user32.dll LockWorkStation|
|[1520](http://127.0.0.1:5151/runcom?aabb=1520)|e18d|[关屏锁定](/actions/1520.md)|无条件|关闭屏幕并锁定电脑|CombActions&#124;1519-1168|
|[1521](http://127.0.0.1:5151/runcom?aabb=1521)|f617|[截取屏幕](/actions/1521.md)|无条件|截取屏幕并存入脚本所在目录的截图目录中(带鼠标光标)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\截图并自动保存.ahk" "" "Screen" "0" "1"|
|[1522](http://127.0.0.1:5151/runcom?aabb=1522)|ef58|系统属性|无条件|打开系统属性界面(高级系统设置)第三个选项卡@控制面板|run&#124;sysdm.cpl ,3|
|[1523](http://127.0.0.1:5151/runcom?aabb=1523)|f577|[额外任务栏](/actions/1523.md)|无条件|打开额外任务栏|Cando&#124;CreateAppBar|
|[1524](http://127.0.0.1:5151/runcom?aabb=1524)|f577|任务栏自动隐藏|无条件|切换任务栏的自动隐藏|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\设置任务栏自动隐藏.ahk"|
|1525|f16d|[按钮颜色](/actions/1525.md)|无条件|更改额外任务栏上按钮的颜色|Cando&#124;ABBSetColor|
|1526|f16b|按钮颜色还原|无条件|重置额外任务栏上按钮的颜色|Cando&#124;ABBReSet|
|1527|f13f|更改文本|无条件|更改额外任务栏最上面文本的内容和颜色|Cando&#124;ABTSetTextAndColor|
|[1528](http://127.0.0.1:5151/runcom?aabb=1528)|eda8|摸鱼看股|无条件|更改额外任务栏最上面文本为上证指数当天价格和涨幅|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\摸鱼看股.ahk" "000001"|
|[1529](http://127.0.0.1:5151/runcom?aabb=1529)|f5b0|[随机播放](/actions/1529.md)|无条件|随机播放指定文件夹(列表) 中的音频文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\随机播放.ahk" "G:\music,G:\music\英文,G:\music\中文,G:\music\中文,G:\music\中文\G:\music\中文,G:\music\中文"|
|1530|f408|区域截图|无条件|拖动鼠标区域截图|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\区域截图.ahk"|
|1531|f408|搜狗截图|无条件|运行搜狗输入法的截图(带OCR)|Keys&#124;^!w|
|1532|f7b0|[中英分隔](/actions/1532.md)|编辑器窗口|如果有选中文本, 将选中部分的中英文字符使用空格分隔(否则为全选文本)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\文本处理_中英文隔开.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1533|f110|[中标转英](/actions/1533.md)|选中文本|如果有选中文本, 将选中部分的中文标点符号转为英文标点(否则为全选文本)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\中文标点转英文.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1534|f111|[英标转中](/actions/1534.md)|选中文本|如果有选中文本, 将选中部分的英文标点符号转为中文标点(否则为全选文本)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\英文标点转中文.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|[1535](http://127.0.0.1:5151/runcom?aabb=1524)|E77F|粘贴|无条件|发送粘贴快捷键|Keys&#124;^v|
|1536|e1c7|添加到自定义|选中对象|将选中(文件,文件夹,文本) 添加为自定义动作|Cando&#124;AddToCustomA|
|1537|e921|设置标题|选中文本|WPS_设置标题格式|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\WPS_设置标题格式.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1538|e8e3|设置正文|选中文本|WPS_设置正文格式|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\WPS_设置正文格式.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1539|e191|单元格底色|选中文本|ET_设置单元格底色|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\ET_设置单元格底色.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1540|e72d|发送到Lnk|选中文件|发送选中文件的快捷方式到如意的 Lnk 文件夹|Cando&#124;addToLnkFolder|
|1541|e8b0|移动窗口|任意窗口|移动窗口|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\任意位置移动窗口.ahk" "%Windy_CurWin_Id%" "移动窗口"|
|1542|e92d|窗口大小|任意窗口|拖动右键,改变窗口的大小|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\任意位置移动窗口.ahk" "%Windy_CurWin_Id%" "窗口大小"|
|1543|e8f4|[批量文件](/actions/1543.md)|选中文件夹|在选中文件夹下批量创建文件(文件夹), 一行一个|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹_批量创建文件.ahk" "%CandySel%" "X"|
|1544|e7b3|[验证身份证](/actions/1544.md)|选中文本|选中身份证号码, 验证是否有效|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\验证身份证号码.ahk" "%CandySel%"|
|1545|e12b|密码管理|Chrome|Chrome 浏览器密码管理器|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\Chrome地址栏打开.ahk" "chrome://password-manager/passwords"|
|1546|e12b|360密码|360浏览器|打开360浏览器密码管理页面|run&#124;%360se% "se://login-manager/"|
|1547|f716|发送到对话框|选中文本|将选中文本发送到 #32770 对话框窗口|canfunc&#124;SendTo32770&#124;%CandySel%&#124;{Enter}|
|1548|f156|文件合并|选中文件夹|列出选中文件夹中文本文件, 将选中文件合并|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\多文件合并.ahk" "%CandySel%"|
|1549|f1ad|搜狗输入法|任意窗口|激活搜狗拼音输入法|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\激活指定输入法.ahk" "搜狗拼音输入法" %Windy_CurWin_id%|
|1550|E77F|显示剪贴板|剪贴板|显示剪贴板当前的内容|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\显示剪贴板内容.ahk"|
|1551|f408|设置权限EO|选中文件|设置选中文件(夹)的权限|run&#124;cmd.exe /c takeown /f "%candysel%" && icacls "%candysel%" /grant EveryOne:F|
|1552|e8c1|语言设置|无条件|打开系统语言设置(Win7+)@控制面板|run&#124;rundll32.exe shell32.dll,Control_RunDLL input.dll|
|1553|e759|OCR|选中文件|使用本地OCR识别本地图片|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\本地OCR(Vis2).ahk" "%CandySel%"|
|1554|E753|天气|无条件|利用免费的天气api显示当天气温|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\天气.ahk" "101300501"|
|1555|e121|农历时间|无条件|显示农历时间|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\时间_显示农历.ahk"|
|1556|e7b3|验证身份证|选中文本|选中身份证号码, 验证是否有效|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\验证身份证号码(ToolTip).ahk" "%CandySel%"|
|1557|e947|关闭窗口|无条件|关闭当前鼠标下的窗口|canfunc&#124;CF_WinClose&#124;%Windy_CurWin_id%|
|1558|e1e3|移动窗口|无条件|移动当前鼠标下的窗口|canfunc&#124;CF_WinMove&#124;%Windy_CurWin_id%&#124;0~&#124;0~&#124;720~&#124;870|
|1559|e720|语音动作|无条件|开始语音识别,按说出的动作名称执行动作|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\语音动作.ahk2"|
|1560|e775|输入法指示|无条件|工具: 在鼠标旁边显示当前窗口输入法状态(A, 中, 英)|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\显示输入法状态.ahk2"|
|1561|e895|检测更新|无条件|检测如意主程序更新|Cando&#124;TM_UpdateCheck|
|1562|e895|更新脚本|无条件|检测如意外部脚本更新|Cando&#124;TM_updatewbscript|
|1563|e895|更新引用|无条件|检测如意引用程序更新|Cando&#124;TM_updateYYpro|
|1564|e8c8|提取文件|选中文件夹|将选中文件夹中的所有文件(不包括文件夹) 复制到同级文件夹中(可指定扩展名)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\复制文件夹下的所有文件到同级目录.ahk" "%CandySel%" "jpg"|
|1565|e121|天数计算|无条件|计算两个日期之间的天数, 或指定日期加上或减去指定天数得到的日期|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\时间_天数计算.ahk"|
|1566|e8c8|发送到|选中文件|复制/移动选中文件到指定的目录, 如果参数2没有指定文件夹则默认为桌面.|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\复制选中文件到指定的文件夹.ahk" "%CandySel%"|
|1567|eb56|文件头|选中文件|通过文件头判断文件真实扩展名|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件头分析文件格式.ahk" "%CandySel%"|
|1568|ea5b|贴边隐藏|任意窗口|窗口贴边隐藏, 参数为上下左右,鼠标移到边缘后自动显示隐藏窗口,鼠标移开后继续自动隐藏|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口_贴边隐藏.ahk" "%Windy_CurWin_id%" "左"|
|1569|e995|音量控制|无条件|控制扬声器,麦克风等播放录制设备的音量|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\音量控制.ahk"|
|1570|e1d6|麦克风静音|无条件|所有麦克风静音切换|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\麦克风静音.ahk"|
|1571|e812|[转上标](/actions/1571.md)|选中文本|如果有选中文本, 将选中字符转为上标,如果没有选中字符, 则选择前一个字符|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\字符转上标.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1572|e813|[转下标](/actions/1572.md)|选中文本|如果有选中文本, 将选中字符转为下标,如果没有选中字符, 则选择前一个字符|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\字符转下标.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1573|e164|ASCII|无条件|ASCII 字符表和网络字符表|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\ASCII.ahk" "%CandySel%"|
|1574|e823|世界时钟|无条件|世界时钟|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\时间_世界时钟.ahk"|
|1575|e916|倒计时|无条件|倒计时, 默认为 5 分钟倒计时|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\时间_倒计时.ahk" "300"|
|1576|e916|距离高考|无条件|距离高考天数倒计时|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\时间_距离天数.ahk" "20250607" "高考" "1"|
|1577|e713|金额大写|选中文本|数字金额转中文大写|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\金额大写.ahk" "%CandySel%"|
|1578|e713|启动服务|无条件|启动打印服务,系统服务管理(启动,停止,获取列表,获取服务信息)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\服务管理.ahk" "Spooler" "Start"|
|1579|e713|停止服务|无条件|停止打印服务,系统服务管理(启动,停止,获取列表,获取服务信息)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\服务管理.ahk" "Spooler" "Stop"|
|1580|e713|服务列表|无条件|获取活动的系统服务列表,系统服务管理(启动,停止,获取列表,获取服务信息)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\服务管理.ahk" "Active" "List"|
|1581|e713|服务信息|无条件|打印服务信息,系统服务管理(启动,停止,获取列表,获取服务信息)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\服务管理.ahk" "Spooler" "Info"|
|1582|e713|禁用服务|无条件|禁用打印服务,系统服务管理(启动,停止,获取列表,获取服务信息)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\服务管理.ahk" "Spooler" "4"|
|1583|e713|启动服务|选中文本|启动选中的服务|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\服务管理.ahk" "%CandySel%" "Start"|
|1584|f71c|嵌入桌面|任意窗口|将选中的窗口嵌入桌面(将桌面设为窗口的父窗口)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口_嵌入桌面.ahk" "%Windy_CurWin_id%"|
|1585|e713|修改计算机名|无条件|修改计算机名|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\修改计算机名.ahk"|
|1586|e93c|窗口穿透|无条件|当前窗口部分区域透明并穿透,使鼠标能操作下层窗口|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口穿透.ahk" "%Windy_CurWin_Id%"|
|1587|e750|系统错误|无条件|查询系统错误编号|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\查询系统错误编号.ahk" "%CandySel%"|
|1588|edc6|一键替换|选中文本|将选中文本一键替换为预设的文本|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\一键替换.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1589|e74e|TC启动|任意窗口|TC 文件管理器启动后自动点击数字按钮|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\TC启动后自动点击进入.ahk"|
|1590|f128|鼠标轨迹|无条件|工具: 鼠标轨迹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\鼠标轨迹.ahk"|
|1591|e957|数字语音|无条件|工具: 小键盘按键带语音|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\语音数字.ahk"|
|1592|e706|屏幕亮度|无条件|设置屏幕亮度为85, 参数1为亮度值(如"+10"/85), 参数2为对比度值(如"+10"/85)|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\屏幕亮度.ahk2" "85" "0"|
|1593|e706|屏幕对比度|无条件|设置屏幕对比度为60, 参数1为亮度值(如"-10"/85), 参数2为对比度值(如"-10"/85)|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\屏幕亮度.ahk2" "0" "60"|
|1594|e8b9|置底|任意窗口|将窗口放到底部(类似按下 Alt+Esc)|canfunc&#124;CF_WinMoveBottom&#124;%Windy_CurWin_id%|
|1595|f742|修改标题|任意窗口|修改窗口标题|canfunc&#124;CF_WinSetTitle&#124;%Windy_CurWin_id%|
|1596|ede5|中键增强|任意窗口|中键增强|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\鼠标中键增强.ahk" %Windy_CurWin_id%|
|1597|e8c8|复制结构|选中文件夹|将选中文件夹的结构复制到剪贴板中|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\复制文件夹结构到当前目录.ahk" "%CandySel%" 0|
|1598|f45e|公式助手|无条件|WPS 表格公式助手|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\公式助手.ahk"|
|1599|e7b3|验证银行卡|选中文本|选中银行卡号, 验证是否有效|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\验证银行卡.ahk" "%CandySel%"|
|1600|f56d|设备和打印机|无条件|打开设备和打印机页面@控制面板|run&#124;control printers|
|1601|e713|服务改手动|无条件|启用打印服务改为手动模式,系统服务管理(启动,停止,获取列表,获取服务信息)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\服务管理.ahk" "Spooler" "3"|
|1602|f56d|默认打印机|无条件|设置默认打印机|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\设置默认打印机.ahk"|
|1603|f10d|Win11菜单|无条件|win11右键菜单变为传统菜单|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\Win11右键菜单.ahk"|
|1604|e16d|隐藏文件|选中文件|切换选中文件的隐藏属性|canfunc&#124;CF_FileSetAttrib&#124;%CandySel%&#124;^H|
|1605|E753|天气2|无条件|利用免费的天气api显示当天气温|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\天气2.ahk"|
|1612|e191|高亮线|ET|ET_在当前选中的单元格下显示一条线|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\ET_设置高亮线.ahk" "%CandySel%" "%Windy_CurWin_Id%"|
|1613|f22c|复制文件|资源管理器|执行资源管理器选中文件的右键菜单(剪贴,复制,删除,属性等)|canfunc&#124;InvokeVerb&#124;复制|
|1614|e8c6|剪切文件|资源管理器|执行资源管理器选中文件的右键菜单(剪贴,复制,删除,属性等)|canfunc&#124;InvokeVerb&#124;剪切|
|1615|ed2b|文件属性|资源管理器|执行资源管理器选中文件的右键菜单(剪贴,复制,删除,属性等)|canfunc&#124;InvokeVerb&#124;属性|
|1616|f22c|复制文件|选中文件|执行指定文件的右键菜单(剪贴,复制,删除,属性等)|canfunc&#124;InvokeVerb&#124;复制&#124;%CandySel%|
|1617|e8c6|剪切文件|选中文件|执行指定文件的右键菜单(剪贴,复制,删除,属性等)|canfunc&#124;InvokeVerb&#124;剪切&#124;%CandySel%|
|1618|ed2b|文件属性|选中文件|执行指定文件的右键菜单(剪贴,复制,删除,属性等)|canfunc&#124;InvokeVerb&#124;属性&#124;%CandySel%|
|1619|f22c|网络和共享|无条件|网络和共享中心|run&#124;control /name Microsoft.NetworkAndSharingCenter|
|1620|f22c|网络和共享|无条件|网络和共享中心|run&#124;shell:::{8E908FC9-BECC-40F6-915B-F4CA0E70D03D}|
|1621|e1c6|添加到替换|选中文本|将选中文本添加到一键替换配置文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\添加单词到一键替换文件.ahk" "%CandySel%"|
|1622|e70a|清理托盘|无条件|清理强制结束进程后残留的系统托盘图标|canfunc&#124;TrayIcon_Clean|
|1623|e7c4|文件拆分|选中文件|将动作1548合并的文本文件拆分到桌面|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\合并的文本文件拆分到桌面.ahk" "%CandySel%"|
|1624|f13f|更改图标|指定参数|更改额外任务栏最上面文本的图标|Cando&#124;ABPSetPic|
|1625|f61f|可视化声音|无条件|当系统播放声音时,通过更改额外任务栏的图标可视化音量|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\AudioVisualizer.ahk"|
|1626|E70F|NotePad2打开|选中文件|使用 NotePad2 打开选定文件|openwith&#124;%Notepad2%|
|1627|E70F|Hex打开|选中文件|使用 HexEditor 打开选定文件|openwith&#124;%A_ScriptDir%\引用程序\x32\MiTeC_Hexadecimal_Editor.exe|
|1628|ed2a|新建菜单|无条件|显示资源管理器新建菜单|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\新建菜单.ahk" "%Windy_CurWin_id%"|
|1629|f0ee|文本转语音|选中文本|利用微软的语音API程序tts.exe实现文本转语音的功能(Win8+)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\文本转语音.ahk" "%CandySel%"|
|1630|f26e|小键盘鼠标|无条件|使用小键盘区域实现鼠标的移动,点击|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\小键盘鼠标.ahk"|
|1631|e8c1|查看编码|选中文本|查看选中文本的编码|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\查看字符编码2.ahk" "%CandySel%"|
|1632|e110|上半屏幕|任意窗口|窗口移到上半屏幕|Cando&#124;窗口上半屏幕|
|1633|e74b|下半屏幕|任意窗口|窗口移到下半屏幕|Cando&#124;窗口下半屏幕|
|1634|e742|左上屏幕|任意窗口|窗口移到屏幕左上角(1/4)|Cando&#124;窗口左上角屏幕|
|1635|e143|右上屏幕|任意窗口|窗口移到屏幕右上角(1/4)|Cando&#124;窗口右上角屏幕|
|1636|e1d9|左下屏幕|任意窗口|窗口移到屏幕左下角(1/4)|Cando&#124;窗口左下角屏幕|
|1637|e741|右下屏幕|任意窗口|窗口移到屏幕右下角(1/4)|Cando&#124;窗口右下角屏幕|
|1638|E70F|WV2打开|选中文件|使用 WebView2 打开选定文件|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\WebView2打开.ahk2" "%CandySel%"|
|1639|E70F|Docx(WV2)|选中文件|使用 WebView2 打开选定 Docx 文件|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\Docx(WebView2).ahk2" "%CandySel%"|
|1640|ea90|Pdfjs(WV2)|选中文件|使用 WebView2(pdfjs) 打开选定 Pdf 文件|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\pdfjs(WebView2).ahk2" "%CandySel%"|
|1641|e71e|搜索List|特定窗口|在拥有 SysListView 控件的窗口(如任务管理器, 服务管理, 程序管理),搜索列表第一列并定位|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\窗口处理\SysListView搜索和定位.ahk2" "%Windy_CurWin_Id%"|
|1642|ed2b|隐藏窗口|选中文件|隐藏窗口不再显示|canfunc&#124;CF_WinHide&#124;%Windy_CurWin_id%|
|1643|e87a|主屏幕|无条件或任意窗口|双屏幕时将光标移动到主屏幕|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\双屏幕鼠标助手.ahk" "主"|
|1644|e87b|副屏幕|无条件或任意窗口|双屏幕时将光标移动到副屏幕|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\双屏幕鼠标助手.ahk" "副"|
|1645|eda4|动态桌面|无条件|使用 WebView2 打开指定网页文件实现动态桌面的效果|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\动态桌面(WebView2).ahk2"|
|1646|E70F|编辑帮助|剪贴板|复制 Ahk 帮助文件路径时, 自动编辑当前复制路径的文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\自动编辑帮助文件.ahk"|
|1647|e8b9|透明|任意窗口|将窗口中的指定颜色透明|canfunc&#124;CF_WinSetTransColor&#124;FFFFFF|
|1648|e8b9|取消透明|任意窗口|取消窗口中的指定颜色透明|canfunc&#124;CF_WinSetTransColor|
|1649|e8b9|设为桌面|任意窗口|将窗口设为桌面(将窗口放到桌面层)|canfunc&#124;AttachToDesktop&#124;%Windy_CurWin_id%&#124;1|
|1650|e8b9|恢复正常|任意窗口|将设为桌面的窗口恢复正常|canfunc&#124;AttachToDesktop|
|1651|ea86|查看图片|选中文件|使用系统的照片查看器打开图片|canfunc&#124;viewpic&#124;%CandySel%|
|1652|e768|自定义用户文件夹|无条件|自定义注册表中的用户文件夹(User Shell Folders)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\自定义User Shell Folders.ahk"|
|1653|f408|文字识别|无条件|拖动鼠标区域截图并文字识别(64位系统,需自行下载 PaddleOCR 或 RapidOCR 模块)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\小区域文字识别.ahk"|
|1654|e80a|数字华容道|无条件|1-15 的数字单滑块拼图游戏|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\游戏\数字华容道.ahk"|
|1655|e74b|运行动作|指定参数|指定参数运行指定的动作|Cando&#124;SpecifyOptRun&#124;1216&#124;{Space}|
|1656|e71e|进程打开的文件|特定窗口|查看窗口进程打开占用的文件|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\窗口处理\GetOpenedFiles.ahk2" "%Windy_CurWin_Id%"|
|1657|ec16|FTP|无条件|打开FTP服务器共享如意目录|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\打开FTP服务器共享如意目录.ahk"|
|1658|ede4|查找大文件|选中文件夹|列出选中文件夹中的最大文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\查找大文件.ahk" "%CandySel%"|
|1659|ede4|查找大文件夹|选中文件夹|列出选中文件夹中的最大文件夹|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\查找大文件夹.ahk" "%CandySel%"|
|1660|E70F|APK解析|选中文件|查看选中的Apk的包名和版本号|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\Apk信息.ahk" "%CandySel%"|
|1661|e713|服务管理|无条件|将收藏的服务以列表形式显示并可管理和设置自启动方式|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\收藏服务管理(收藏列表).ahk"|
|1662|e1c8|ahk关联|无条件|将 Ahk 文件关联到 Autohotkey.exe|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\AHK 脚本关联工具.ahk"|
|1663|e1c8|ahk关联|无条件|将 Ahk 文件关联到如意下的 AutoHotkeyU32/64.exe|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\AHK 脚本一键关联.ahk"|
|1664|e1c8|ahk2关联|无条件|将 Ahk2 文件关联到如意下的 AutoHotkey32/64.exe|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\AHK 脚本一键关联.ahk" "ahk2"|
|1665|e9d2|股价查询|无条件|股票和基金当天价格查询|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\股票计算器.ahk"|
|1666|e71e|AppId|任意窗口|查看窗口进程的 AppId|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\GetAppId.ahk" "%Windy_CurWin_Id%"|
|1667|ede4|EV搜索|选中对象|使用 Everything 搜索关键字|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\Everything搜索.ahk" "%CandySel%"|
|1668|ea86|取消只读|选中文件|取消文件的只读属性|canfunc&#124;CF_FileSetAttrib&#124;%CandySel%&#124;-R|
|1669|e737|桌面便签|无条件|桌面便签|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\Sticky Notes.ahk"|
|1670|e736|单行阅读|无条件|单行载入文本文件(单词本,小说阅读)|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\单行阅读器.ahk"|
|1671|E703|自启动管理|无条件|电脑自启动项目管理|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\注册表\自启动程序管理.ahk"|
|1672|f193|扫描到|无条件|打开打印机的扫描功能|run&#124;wiaacmgr|
|1673|e16d|复制菜单|选中文件|弹出菜单来复制选中文件的路径和名称|Cando&#124;showcopymenu|
|1674|e713|进程监控|无条件|监控进程的打开与终止并记录到列表中|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\系统设置\进程监控.ahk"|
|1675|e713|窗口监控|无条件|监控窗口的创建与关闭并记录显示到列表中|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口监控.ahk"|
|1676|e12b★EBA1☆codicon|Github下载|无条件|科学下载Github文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\github.ahk" "%CandySel%"|
|1677|f4aa|Md(WV2)|选中文件|使用 WebView2(mdeditor) 打开选定 md 文件|run&#124;"%B_Autohotkey2%" "%A_ScriptDir%\外部脚本\V2\md(WebView2).ahk2" "%CandySel%"|
|1678|e8e7|运行选中代码|选中文本|将选中 Ahk 代码直接运行|canfunc&#124;RunAhkCode&#124;%CandySel%|
|1679|e121|退休日期计算|无条件|根据身份证或出生日期计算退休日期|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\计算退休日期.ahk" "%CandySel%"|
|1680|f69e|桌面画图|无条件|桌面画图工具|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\桌面画图.ahk"|
|1681|e713|窗口监控|无条件|监控窗口的创建与关闭并记录显示到列表中|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\窗口监控.ahk"|
|1682|e197|挂载为磁盘 X|选中文件夹|将选中网络文件夹挂载为虚拟磁盘 X:|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\网络文件夹_本地磁盘.ahk" "%CandySel%" "X"|
|1683|e159|卸载磁盘|选中驱动器|卸载网络文件夹挂载的虚拟磁盘|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\网络文件夹_本地磁盘.ahk" "%CandySel%"|
|1684|e197|挂载网络共享|无条件|挂载或卸载网络文件夹虚拟的磁盘|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\网络文件夹_本地磁盘.ahk" "%CandySel%"|
|1685|e197|挂载文件夹|无条件|挂载或卸载本地文件夹虚拟的磁盘|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\文件夹处理\文件夹_虚拟磁盘.ahk" "%CandySel%"|
|1686|e790|透明转红|选中文件|将图片中的透明像素转为红色|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文件处理\图像文件_透明像素转指定颜色.ahk" "%CandySel%" "0xFFFF0000"|
|1687|f8af★eb4d☆codicon|无界鼠标|无条件|鼠标移到边缘从对面边缘出来|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\无界鼠标.ahk"|
|1688|ea61|深色模式|任意窗口|切换窗口的深色模式与浅色模式|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\深色模式.ahk" "%Windy_CurWin_Id%"|
|1689|e754|聚光灯|无条件|激活窗口正常亮度, 窗口外区域变暗|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\聚光灯.ahk"|
|1690|e121|插入日期|无条件|插入日期|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\文本处理\插入日期.ahk" "%CandySel%"|
|1691|e8ec|最近选中|无条件@如意|显示最近选中列表管理界面|Cando&#124;CandySelListM|
|1692|e8ec|临时热键|无条件@如意|显示临时热键管理界面|Cando&#124;TempHotkeyM|
|1693|E70F|U32打开|特定窗口|使用 AHK 运行当前窗口打开的脚本文件|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\窗口处理\其他编辑器打开.ahk" "%AutoHotkeyU32%"|
|1694|eda8|股价提醒|无条件@股票|监控当前股价满足指定条件时提醒|run&#124;"%B_Autohotkey%" "%A_ScriptDir%\外部脚本\工具类\股价提醒.ahk"|