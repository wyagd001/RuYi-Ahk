;|2.6|2024.04.17|1220
SetFormat, float, 10.4

; <title>上证指数 3167.24 +1.08%(33.99)股票价格-行情-走势图-行情-金融界</title>
; [\+\-]?\d+\.\d+%?

settingInifile := A_ScriptDir "\股票当天行情.ini"
settingobj := ini2obj(settingInifile)
Global settingobj, settingInifile
ColorsOn := settingobj["选项"]["显示颜色"]
speccolor := settingobj["选项"]["仅五六列显示颜色"]
Gui, Add, ListView, w680 h250 hwndHLV vgupiaolistview, 序号|股票代码|股票名称|价格点数|涨跌|涨幅|涨跌(元)|持仓份额|成本价(元)|盈亏(元)|
CLV := New LV_Colors(HLV)
Gui, Add, Button, grefresh, 刷新
Gui, Add, CheckBox, xp+60 yp vColorsOn ggcolor h25, 是否显示颜色
Gui, Add, CheckBox, xp+120 yp vspeccolor ggcolor h25, 仅5,6列显示颜色

Gui, Add, Button, x700 y5 w60 geditnewrow, 新增
Gui, Add, Button, xp yp+28 w60 geditrow, 编辑
Gui, Add, Button, xp yp+28 w60 gDelListItem, 删除

Gui, Add, Button, xp yp+40 w60 gMoveRow_Up, 向上
Gui, Add, Button, xp yp+28 w60 gMoveRow_Down, 向下

Gui, Add, Button, xp yp+40 w60 gopenweb, 打开网页
Gui, Add, Button, xp yp+28 w60 gopensetfile, 打开配置

GuiControl,, ColorsOn, % ColorsOn
GuiControl,, speccolor, % speccolor
Gui, Show, AutoSize, 股票当天行情
gosub refresh
return

refresh:
Gui, Default 
CLV.clear()
LV_Delete()
;GuiControl, -redraw, gupiaolistview  ; 会导致 ListView 冻结
for k,v in settingobj["股票"]
{
	;msgbox % v
	code := GetStringIndex(v, 1), name := GetStringIndex(v, 2), fene := GetStringIndex(v, 3), chengben := GetStringIndex(v, 4)
	Tmp_Obj := Gupiao(code)
	LV_Add("", A_Index, code, name?name:Tmp_Obj["名称"], Tmp_Obj["价格"], Tmp_Obj["涨跌"], Tmp_Obj["涨幅"], fene * Tmp_Obj["涨跌"], fene, chengben, fene * Tmp_Obj["价格"] - fene * chengben)
}
LV_ModifyCol()
LV_ModifyCol(1, "Logical 40")
LV_ModifyCol(2, "Logical 60")
LV_ModifyCol(4, "Logical 60")
LV_ModifyCol(5, "Logical")
LV_ModifyCol(8, 60)
LV_ModifyCol(9, 80)

if ColorsOn
{
	CLV.OnMessage()
	Loop, % LV_GetCount()
	{
		LV_GetText(OutputVar, A_Index, 5)
		;ToolTip % ColorsOn "|" OutputVar
		if (OutputVar + 0 > 0)
		{
			if !speccolor
				CLV.Row(A_Index, , "0xFF0000")
			else
			{
				CLV.Cell(A_Index, 5,, "0xFF0000")
				CLV.Cell(A_Index, 6,, "0xFF0000")
			}
		}
		else if (OutputVar = "--")
		{
			;ToolTip % ColorsOn "|" OutputVar
			if !speccolor
				CLV.Row(A_Index, , "0x000000")
			else
			{
				CLV.Cell(A_Index, 5,, "0x000000")
				CLV.Cell(A_Index, 6,, "0x000000")
			}
		}
		else if (OutputVar + 0 < 0)
		{
			if !speccolor
				CLV.Row(A_Index, , "0x00FF00")
			else
			{
				CLV.Cell(A_Index, 5,, "0x00FF00")
				CLV.Cell(A_Index, 6,, "0x00FF00")
			}
		}
	}
}
;GuiControl, +redraw, gupiaolistview
return

gcolor:
Gui, Submit, NoHide
If (ColorsOn)
{
	CLV.OnMessage()    ; 开启颜色
	GuiControl, Enable, speccolor
}
Else
{
	CLV.OnMessage(False)    ; 关闭颜色
	GuiControl, Disable, speccolor
}
settingobj["选项"]["仅五六列显示颜色"] := speccolor
settingobj["选项"]["显示颜色"] := ColorsOn
obj2ini(settingobj, settingInifile)
return

GuiClose:
ExitApp

Gupiao(Code)
{
	if (Code="000001") or (instr(code, "6") = 1) or (instr(code, "51") = 1) or (instr(code, "56") = 1) or (instr(code, "58") = 1)  ; 股票和ETF
		url := "https://summary.jrj.com.cn/stock/sh/" code
	else
		url := "https://summary.jrj.com.cn/stock/sz/" code
	webs := WinHttp.URLGet(url, "Charset:UTF-8")
	;if (code=515980)
		;msgbox % webs
	RegExMatch(webs, "<title>(.*)?</title>", Wtitle)
	RegExMatch(Wtitle1, "([\+\-]?\d+\.\d+%?)\s([\+\-]?\d+\.\d+%?)\(([\+\-]?\d+\.\d+%?)", Value)
	if !Value3
		RegExMatch(Wtitle1, "([\+\-]?\d+\.\d+%?)\s([\+\-]?\d+\.\d+%?)\((\-\-)", Value)
	;msgbox % Value2
	GPOBJ := {}
	GPOBJ["价格"] := Value1
	GPOBJ["涨幅"] := Value2
	GPOBJ["涨跌"] := Value3
	Array := StrSplit(Wtitle1, " ")
	GPOBJ["名称"] := Array[1]
	return GPOBJ
}

ini2obj(file)
{
	iniobj := {}
	FileRead, filecontent, %file% ;加载文件到变量
	StringReplace, filecontent, filecontent, `r, , All
	StringSplit, line, filecontent, `n, , ;用函数分割变量为伪数组
	Loop ;循环
	{
		if A_Index > %line0%
			Break
		content = % line%A_Index% ; 赋值当前行
		if (instr(content, ";") = 1)  ; 每行第一个字符为 ; 为注释跳过
			continue
		FSection := RegExMatch(content, "\[.*\]") ;正则表达式匹配section
		if FSection = 1 ;如果找到
		{
			TSection := RegExReplace(content, "\[(.*)\]", "$1") ; 正则替换并赋值临时section $为向后引用
			iniobj[TSection] := {}
		}
		Else
		{
			FKey := RegExMatch(content, "^.*=.*")    ;正则表达式匹配key
			if FKey
			{
				TKey := RegExReplace(content, "^(.*?)=.*", "$1")   ; 正则替换并赋值临时key
				;StringReplace, TKey, TKey, ., _, All               ; 会将键中的 "." 自动替换为 "_". 快捷键中有 ., 所以注释掉了
				TValue := RegExReplace(content, "^.*?=(.*)", "$1") ; 正则替换并赋值临时value
				if TKey
					iniobj[TSection][TKey] := TValue
			}
		}
	}
	Return iniobj
}

obj2ini(obj, file){
	if (!isobject(obj) or !file)
		Return 0
	for k,v in obj
	{
		for key,value in v                                  ; 删除的键值不会保存
		{
			IniWrite, %value%, %file%, %k%, %key%
			;fileappend %key%-%value%`n, %A_desktop%\123.txt
		}
	}
Return 1
}

GetStringIndex(String, Index := "")
{
	arrCandy_Cmd_Str := StrSplit(String, "|", " `t")
	if Index
	{
		NewStr := arrCandy_Cmd_Str[Index]
		return NewStr
	}
	else
		return arrCandy_Cmd_Str
}

opensetfile:
run, % settingInifile
return

openweb:
RF := LV_GetNext(0, "F")
if RF
	LV_GetText(R_Code, RF, 2)
run http://fund.eastmoney.com/%R_Code%.html
return

editrow:
RF := LV_GetNext(0, "F")
if RF
{
	LV_GetText(R_index, RF, 1)
	LV_GetText(R_Code, RF, 2)
	LV_GetText(R_Name, RF, 3)
	LV_GetText(R_Share, RF, 8)
	LV_GetText(R_Price, RF, 9)
}
editnewrow:
Gui, 98:Destroy
Gui, 98:+Owner1
Gui, 1:+Disabled
Gui, 98:Default
Gui, Submit, NoHide
if !R_index && !R_Code
	R_index := settingobj["股票"].Count()+1
Gui, Add, Text, x20 y20 w50 h20, 编号：
Gui, Add, Text, x20 y50 w60 h20, 股票代码：
Gui, Add, Text, x20 y80 w80 h20, 股票名称：
Gui, Add, Text, x20 y110 w80 h20, 持有份额：
Gui, Add, Text, x20 y140 w80 h20, 成本价格：

Gui, Add, Edit, x110 y20 w100 h20 readonly vR_index, %R_index%
Gui, Add, Edit, x110 y50 w100 h20 vR_Code, %R_Code%
Gui, Add, Edit, x110 y80 w100 h20 vR_Name, %R_Name%
Gui, Add, Edit, x110 y110 w100 h20 vR_Share, %R_Share%
Gui, Add, Edit, x110 y140 w100 h20 vR_Price, %R_Price%

Gui, Add, Button, x200 y170 w70 h30 g98ButtonOK, 确定
Gui, Add, Button, x280 y170 w70 h30 g98GuiClose Default, 取消
Gui, Show,, 股票基金项目编辑
Return

98ButtonOK:
Gui, 98:Submit
Gui, 98:Destroy
Gui, 1:Default
Gui, 1:-Disabled
Gui, Submit, NoHide
settingobj["股票"][R_index] := R_Code "|" R_Name "|" R_Share "|" R_Price
Tmp_Obj := Gupiao(R_Code)
LV_Modify(R_index, "", R_index, R_Code, R_Name, Tmp_Obj["价格"], Tmp_Obj["涨跌"], Tmp_Obj["涨幅"], R_Share * Tmp_Obj["涨跌"], R_Share, R_Price, R_Share * Tmp_Obj["价格"] - R_Share * R_Price)
obj2ini(settingobj, settingInifile)
;RefreshData("股票")
R_index := R_Code := R_Name := R_Share := R_Price := ""
return

98GuiEscape:
98GuiClose:
Gui, 1:-Disabled
Gui, 98:Destroy
R_index := R_Code := R_Name := R_Share := R_Price := ""
Return

MoveRow_Up:
Gui, Submit, NoHide
LV_MoveRow()
LV_RowIndexOrder()
LV_ListToObj("股票")
Return

MoveRow_Down:
Gui, Submit, NoHide
LV_MoveRow(0)
LV_RowIndexOrder()
LV_ListToObj("股票")
Return

LV_MoveRow(moveup = true) {
	; Original by diebagger (Guest) from:
	; http://de.autohotkey.com/forum/viewtopic.php?p=58526#58526
	; Slightly Modifyed by Obi-Wahn
	If moveup not in 1,0
		Return	; If direction not up or down (true or false)
	while x := LV_GetNext(x)	; Get selected lines
		i := A_Index, i%i% := x
	If (!i) || ((i1 < 2) && moveup) || ((i%i% = LV_GetCount()) && !moveup)
		Return	; Break Function if: nothing selected, (first selected < 2 AND moveup = true) [header bug]
				; OR (last selected = LV_GetCount() AND moveup = false) [delete bug]
	cc := LV_GetCount("Col"), fr := LV_GetNext(0, "Focused"), d := moveup ? -1 : 1
	; Count Columns, Query Line Number of next selected, set direction math.
	Loop, %i% {	; Loop selected lines
		r := moveup ? A_Index : i - A_Index + 1, ro := i%r%, rn := ro + d
		; Calculate row up or down, ro (current row), rn (target row)
		Loop, %cc% {	; Loop through header count
			LV_GetText(to, ro, A_Index), LV_GetText(tn, rn, A_Index)
			; Query Text from Current and Targetrow
			LV_Modify(rn, "Col" A_Index, to), LV_Modify(ro, "Col" A_Index, tn)
			; Modify Rows (switch text)
		}
		LV_Modify(ro, "-select -focus"), LV_Modify(rn, "select vis")
		If (ro = fr)
			LV_Modify(rn, "Focus")
	}
}

LV_RowIndexOrder()
{
	loop % LV_GetCount()
	{
		LV_Modify(A_index, , A_index)
	}
}

LV_ListToObj(SubObjName)
{
	loop % LV_GetCount()
	{
		LV_GetText(R_index, A_index, 1)
		LV_GetText(R_Code, A_index, 2)
		LV_GetText(R_Name, A_index, 3)
		LV_GetText(R_Share, A_index, 8)
		LV_GetText(R_Price, A_index, 9)
		settingobj[SubObjName][R_index] := R_Code "|" R_Name "|" R_Share "|" R_Price
	}
	obj2ini(settingobj, settingInifile)
}

DelListItem:
Gui, Submit, NoHide
RowNumber := 0, TmpArr := []
Loop
{
	RowNumber := LV_GetNext(RowNumber)
	if not RowNumber
		Break

	LV_GetText(Tmp_Str, RowNumber, 1)
	;msgbox % RowNumber "|" Tmp_Str
	TmpArr.Push(Tmp_Str)
}
Loop % TmpArr.Length()
{
	Tmp_Index := TmpArr.Pop()
	;msgbox % Tmp_Index
	settingobj["股票"].RemoveAt(Tmp_Index)
	IniDelete, % settingInifile, 股票, % settingobj["股票"].Count()+1
}
obj2ini(settingobj, settingInifile)
;RefreshData(Comb)
return


; https://autohotkey.com/board/topic/9529-urldownloadtovar/page-7
; URL,Charset="",URLCodePage="",Proxy="",ProxyBypassList="",Cookie="",Referer="",UserAgent="",EnableRedirects="",Timeout=-1
; http://ahkcn.net/thread-5658.html

/*
更新日志：
	2018.10.20
	URLDownloadToFile 和 URLDownloadToVar  二者合并为URLGet
	URLPost 添加gzip解压函数和下载功能
	修改版本号为：1.5

	2015.09.12
	优化代码结构
	版本号为1.4

	2015.09.11
	修正超时会在错误时间被激活的问题。（http://ahkcn.net/thread-5658-post-33736.html#pid33736）
	以下是tmplinshi对这个问题的详细描述。
	----------------------------------------------------------------------------------------------
	WebRequest.WaitForResponse(超时秒数)
	默认情况下，这个超时秒数并不是你设置为空就一直等待，设置 60 就等待 60 秒。而是要受限于默认的超时设置。

	默认的超时设置为:
	解析超时: 0 秒
	连接超时: 60 秒
	发送超时: 30 秒
	接收超时: 30 秒

	WaitForResponse 应该是指接收超时吧。所以呢，默认的话即使你设置 WaitForResponse(60) 实际上还是最多就等待 30 秒。。

	默认值可以通过 WebRequest.SetTimeouts(解析超时, 连接超时, 发送超时, 接收超时) 来设置，详见 MSDN 的说明。比如把接收超时修改为 120 秒 —— WebRequest.SetTimeouts(0, 60000, 30000, 120000)

	这点没有明白可把我害惨了。最近写的一个查询软件，经常查询失败。我原本以为是网站无响应，因为我没有设置超时，以为软件会一直等待（但是上面说了，“一直等待”会受限于?默认的最大超时）。后来仔细看抓包数据，看到每次都 30 秒超时返回。而用浏览器测试却正常，在 40 多秒的时候返回了结果，这才发觉是软件不对劲。

	希望更多人知道这点说明，有空我还要再发几个帖子说明这一点。。另外@兔子 你也可以修改下代码，如果传递的超时超过了默认的 30 秒则调用一下 SetTimeouts。
	----------------------------------------------------------------------------------------------
	版本号为1.3

	2015.06.05
	添加静态变量Status、StatusText，用法和ResponseHeaders一致。
	添加新功能，若指定状态码与重试次数，将重试n次，直至状态码与预期一致。
	版本号为1.2

已知问题：
	不支持gzip压缩后的数据。正常情况下，你不向服务器说明你需要gzip压缩后的数据，它们是不会给你发送的，所以没影响。
	cookie没有实现像浏览器那样的自动管理。但是你可以在需要的时候随时取出，自行管理。
*/

class WinHttp
{

	static ResponseHeaders:=[],Status:="",StatusText:="",extra:=[]

	/*
	*****************版本*****************
	URLGet v 1.5

	*****************说明*****************
	此函数与内置命令 UrlDownloadToFile 的区别有以下几点：
	1.下载速度更快，大概100%。
	2.内置命令执行时，整个AHK程序都是卡顿状态。此函数不会。
	3.内置命令下载一些诡异网站（例如“牛杂网”）时，会概率性让进程或线程彻底死掉。此函数不会。
	4.支持设置网页字符集、URL的编码。乱码问题轻松解决。
	5.支持设置所有“Request Header”。常见的有：Cookie、Referer、User-Agent。网站检测问题轻松解决。
	6.支持设置超时，不必死等。
	7.支持设置代理及白名单。
	8.支持设置是否自动重定向网址。
	9.“RequestHeaders”参数格式与chrome的开发者工具中的“Request Header”相同，因此可直接复制过来就用，方便调试。
	10.支持存取“Cookie”，可用于模拟登录状态。
	11.支持判断网页返回时的状态码，例如200，404等。

	*****************参数*****************
	URL 网址，必须包含类似“http://”的开头。“www.”最好也带上，有些网站需要。
	Options、RequestHeaders的格式为：每行一个参数，行首至第一个冒号为参数名，之后至行尾为参数值。多个参数换行。具体可参照“解析信息到对象()”注释中的例子。

	*****************Options*****************
	支持以下7种(9种)设置，输入其它值无任何效果，无大小写要求。
	Charset 网页字符集，不能是“936”之类的数字，必须是“gb2312”这样的字符。
	URLCodePage URL的编码，是“936”之类的数字，默认是“65001”。有些网站需要UTF-8，有些网站又需要gb2312。
	proxy_setting 代理服务器设置，0表示使用“Proxycfg.exe”的设置；1表示无视“Proxy”指定的代理而直接连接；2表示使用“Proxy”指定的代理。
	Proxy 代理服务器，是形如“http://www.tuzi.com:80”的字符。程序会根据此处的值自动设置合适的“proxy_setting”，即通常情况下不用管“proxy_setting”，除非你想自己控制。
	ProxyBypassList 代理服务器绕行名单，是形如“*.microsoft.com”的域名。符合域名的网址，将不通过代理服务器访问。
	EnableRedirects 重定向，默认获取跳转后的页面信息，0为不跳转。
	Timeout 超时，单位为秒，默认不使用超时（Timeout=-1）。
	expected_status	状态码，通常200表示网页正常，404表示网页找不到了。设置后当网页返回的状态码与此处不一致则抛出调试信息并报错（故使用此参数后建议同时使用try语句）。
	number_of_retries	重试次数（与状态码配对使用），当网页返回的状态码与期望状态码不一致时，可以重试的次数。

	*****************RequestHeaders*****************
	支持所有RequestHeader，大小写的改变可能会影响结果。常见的有以下这些。
	Cookie ，常用于登录验证。
	Referer 引用网址，常用于防盗链。
	User-Agent 用户信息，常用于防盗链。
	Content-Type  application/x-www-form-urlencoded

	*****************注意*****************
	每次下载操作后，“ResponseHeaders”这个变量中存储的就是每次访问网址时，服务器返回的“ResponseHeaders”。当然，它已经被解析成对象了?，方便直接使用。
	不需要的时候，可以不用管它。需要的时候，则在下载网址后，紧接着读取这个对象就行了。
	例如“obj:=WinHttp.ResponseHeaders”，此时obj中就包含了刚才访问网址时服务器返回的所有“ResponseHeaders”。
	于是“MsgBox, % obj["Content-type"]”，就得到了“Content-type”。
	于是“MsgBox, % obj["Set-Cookie"]”，就得到了“Set-Cookie”。
	上面的“Set-Cookie”，就是cookie。

	需要注意的是，由于“Set-Cookie”很可能一次返回了多条，所以如果存在多条“Set-Cookie”，它们是用“`r`n”分隔的。
	“Status”和“StatusText”用法与“ResponseHeaders”一致，区别为前两者是纯变量。
	例如“MsgBox, % WinHttp.Status”，就得到了状态码。

	;~ 所以整体来说就是
	WinHttp.UrlGet("http://www.baidu.com")
	obj:=WinHttp.ResponseHeaders
	MsgBox, % obj["Set-Cookie"]
	MsgBox, 上面那个就是cookie

	类似下面的参数不要加入到“RequestHeaders”中，它表示浏览器支持gzip数据压缩，会导致服务器发送压缩后的数据过来，也就会出错。
	Accept-Encoding:gzip,deflate,sdch
	*/
	UrlGet(URL, Options:="", RequestHeaders:="", FilePath:="")
	{
		Options:=this.解析信息到对象(Options)
		RequestHeaders:=this.解析信息到对象(RequestHeaders)

		ComObjError(0) 							;禁用 COM 错误通告。禁用后，检查 A_LastError 的值，脚本可以实现自己的错误处理
		WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

		if (URL="") 								; 参数全为空 返回重置的 WinHttp 对象
		return ComObjCreate("WinHttp.WinHttpRequest.5.1")

		if (Options["URLCodePage"]<>"")    							;设置URL的编码
			WebRequest.Option(2):=Options["URLCodePage"]
		if (Options["EnableRedirects"]<>"")							;设置是否获取跳转后的页面信息
			WebRequest.Option(6):=Options["EnableRedirects"]
		;proxy_setting没值时，根据Proxy值的情况智能设定是否要进行代理访问。
		;这样的好处是多数情况下需要代理时依然只用给出代理服务器地址即可。而在已经给出代理服务器地址后，又可以很方便的对是否启用代理进行开关。
		if (Options["proxy_setting"]="" and Options["Proxy"]<>"")
			Options["proxy_setting"]:=2										;0表示 Proxycfg.exe 运行了且遵循 Proxycfg.exe 的设置（没运行则效果同设置为1）。1表示忽略代理直连。2表示使用代理
		if (Options["proxy_setting"]="" and Options["Proxy"]="")
			Options["proxy_setting"]:=1
		;设置代理服务器。微软的代码 SetProxy() 是放在 Open() 之前的，所以我也放前面设置，以免无效
		WebRequest.SetProxy(Options["proxy_setting"],Options["Proxy"],Options["ProxyBypassList"])
		if (Options["Timeout"]="")											;Options["Timeout"]如果被设置为-1，并不代表无限超时，而是依然遵循SetTimeouts第4个参数设置的最大超时时间
			WebRequest.SetTimeouts(0,60000,30000,0)			;0或-1都表示超时无限等待，正整数则表示最大超时（单位毫秒）
		else if (Options["Timeout"]>30)									;如果超时设置大于30秒，则需要将默认的最大超时时间修改为大于30秒
			WebRequest.SetTimeouts(0,60000,30000,Options["Timeout"]*1000)
		else
			WebRequest.SetTimeouts(0,60000,30000,30000)	;此为SetTimeouts的默认设置。这句可以不加，因为默认就是这样，加在这里是为了表述清晰。

		WebRequest.Open("GET", URL, true)   						;true为异步获取。默认是false，龟速的根源！！！卡顿的根源！！！

		;SetRequestHeader() 必须 Open() 之后才有效
		for k, v in RequestHeaders
		{
			if (k="Cookie")
			{
				WebRequest.SetRequestHeader("Cookie","tuzi")    ;先设置一个cookie，防止出错，msdn推荐这么做
				WebRequest.SetRequestHeader("Cookie",v)
			}
			else
				WebRequest.SetRequestHeader(k,v)
		}

		Loop
		{
			WebRequest.Send()
			WebRequest.WaitForResponse(-1)  ; 等待
			;WaitForResponse方法确保获取的是完整的响应。-1表示总是使用SetTimeouts设置的超时

			;获取状态码，一般status为200说明请求成功
			this.Status:=WebRequest.Status()
			this.StatusText:=WebRequest.StatusText()

			if (Options["expected_status"]="" or Options["expected_status"]=this.Status)
				break
				;尝试指定次数后页面返回的状态码依旧与预期状态码不一致，则抛出错误及详细错误信息（可使用我另一个错误处理函数专门记录处理它们）
			;即使number_of_retries为空，表达式依然成立，所以不用为number_of_retries设置初始值。
			else if (A_Index>=Options["number_of_retries"])
			{
				this.extra.URL:=URL
				this.extra.Expected_Status:=Options["expected_status"]
				this.extra.Status:=this.Status
				this.extra.StatusText:=this.StatusText
				throw, Exception("经过" Options.number_of_retries "次尝试后，服务器返回状态码依旧与期望值不一致", -1, Object(this.extra))
			}
		}

		if (Options["Charset"]<>"") or (FilePath<>"")						;设置字符集或保存文件
		{
			this.ResponseHeaders:=this.解析信息到对象(WebRequest.GetAllResponseHeaders())
			ADO:=ComObjCreate("adodb.stream")   		;使用 adodb.stream 编码返回值。参考 http://bbs.howtoadmin.com/ThRead-814-1-1.html
			ADO.Type:=1														;以二进制方式操作
			ADO.Mode:=3 													;可同时进行读写
			ADO.Open()  														;开启物件
			ADO.Write(WebRequest.ResponseBody())
			; 写入物件。注意没法将 WebRequest.ResponseBody() 存入一个变量，所以必须用这种方式写文件.
			if(FilePath<>"")
			{
				ADO.SaveToFile(FilePath,2)   						 	;文件存在则覆盖
				ADO.Close()
			return, 1
			}
			Else
			{
			; 注意 WebRequest.ResponseBody() 获取到的是无符号的bytes，通过 adodb.stream 转换成字符串string
				ADO.Position:=0 												;从头开始
				ADO.Type:=2 														;以文字模式操作
				ADO.Charset:=Options["Charset"]    				;设定编码方式
				ret_var:=ADO.ReadText()   								;将物件内的文字读出
				ADO.Close()
			return, ret_var
			}
		}
		Else
		{
			this.ResponseHeaders:=this.解析信息到对象(WebRequest.GetAllResponseHeaders())
		return, WebRequest.ResponseText()
		}
	}

	/*
	*****************版本*****************
	UrlPost v 1.5

	*****************说明*****************
	此函数与内置命令 UrlDownloadToFile 的区别有以下几点：
	1.直接下载到变量，没有临时文件。
	2.下载速度更快，大概100%。
	3.内置命令执行时，整个AHK程序都是卡顿状态。此函数不会。
	4.内置命令下载一些诡异网站（例如“牛杂网”）时，会概率性让进程或线程彻底死掉。此函数不会。
	5.支持设置网页字符集、URL的编码。乱码问题轻松解决。
	6.支持设置所有“Request Header”。常见的有：Cookie、Referer、User-Agent、Referer、X-Requested-With。网站检测问题轻松解决。
	7.支持设置超时，不必死等。
	8.支持设置代理及白名单。
	9.支持设置是否自动重定向网址。
	10.“RequestHeaders”参数格式与chrome的开发者工具中的“Request Header”相同，因此可直接复制过来就用，方便调试。
	11.使用“POST”方法，因此可上传数据。
	12.支持存取“Cookie”，可用于模拟登录状态。
	13.支持判断网页返回时的状态码，例如200，404等。

	*****************参数*****************
	URL 网址，必须包含类似“http://”的开头。“www.”最好也带上，有些网站需要。
	Data 数据，默认是文本，即开发者工具中“Request Payload”段中的内容。
	Options、RequestHeaders的格式为：每行一个参数，行首至第一个冒号为参数名，之后至行尾为参数值。多个参数换行。具体可参照“解析信息到对象()”注释中的例子。

	*****************Options*****************
	支持以下6种设置，输入其它值无任何效果，无大小写要求。
	Charset 网页字符集，不能是“936”之类的数字，必须是“gb2312”这样的字符。
	URLCodePage URL的编码，是“936”之类的数字，默认是“65001”。有些网站需要UTF-8，有些网站又需要gb2312。
	proxy_setting 代理服务器设置，0表示使用“Proxycfg.exe”的设置；1表示无视“Proxy”指定的代理而直接连接；2表示使用“Proxy”指定的代理。
	Proxy 代理服务器，是形如“http://www.tuzi.com:80”的字符。程序会根据此处的值自动设置合适的“proxy_setting”，即通常情况下不用管“proxy_setting”，除非你想自己控制。
	ProxyBypassList 代理服务器绕行名单，是形如“*.microsoft.com”的域名。符合域名的网址，将不通过代理服务器访问。
	EnableRedirects 重定向，默认获取跳转后的页面信息，0为不跳转。
	Timeout 超时，单位为秒，默认不使用超时（Timeout=-1）。
	expected_status	状态码，通常200表示网页正常，404表示网页找不到了。设置后当网页返回的状态码与此处不一致则抛出调试信息并报错（故使用此参数后建议同时使用try语句）。
	number_of_retries	重试次数（与状态码配对使用），当网页返回的状态码与期望状态码不一致时，可以重试的次数。

	*****************RequestHeaders*****************

	*****************注意*****************
	类似下面的参数加入到“RequestHeaders”中，表示浏览器支持gzip数据压缩，会导致服务器发送压缩后的数据过来。
	Accept-Encoding:gzip,deflate,sdch。 添加解压函数，未测试实际的效果。
	*/

	UrlPost(URL, PostData, Options:="", RequestHeaders:="",FilePath:="")
	{
		Options:=this.解析信息到对象(Options)
		RequestHeaders:=this.解析信息到对象(RequestHeaders)

		ComObjError(0) 														 		;禁用 COM 错误通告。禁用后，检查 A_LastError 的值，脚本可以实现自己的错误处理
		WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")

		if (Options["URLCodePage"]<>"")    							;设置URL的编码
			WebRequest.Option(2):=Options["URLCodePage"]
		if (Options["EnableRedirects"]<>"")							;设置是否获取跳转后的页面信息
			WebRequest.Option(6):=Options["EnableRedirects"]
		;proxy_setting没值时，根据Proxy值的情况智能设定是否要进行代理访问。
		;这样的好处是多数情况下需要代理时依然只用给出代理服务器地址即可。而在已经给出代理服务器地址后，又可以很方便的对是否启用代理进行开关。
		if (Options["proxy_setting"]="" and Options["Proxy"]<>"")
			Options["proxy_setting"]:=2										;0表示 Proxycfg.exe 运行了且遵循 Proxycfg.exe 的设置（没运行则效果同设置为1）。1表示忽略代理直连。2表示使用代理
		if (Options["proxy_setting"]="" and Options["Proxy"]="")
			Options["proxy_setting"]:=1
		;设置代理服务器。微软的代码 SetProxy() 是放在 Open() 之前的，所以我也放前面设置，以免无效
		WebRequest.SetProxy(Options["proxy_setting"],Options["Proxy"],Options["ProxyBypassList"])
		if (Options["Timeout"]="")											;Options["Timeout"]如果被设置为-1，并不代表无限超时，而是依然遵循SetTimeouts第4个参数设置的最大超时时间
			WebRequest.SetTimeouts(0,60000,30000,0)			;0或-1都表示超时无限等待，正整数则表示最大超时（单位毫秒）
		else if (Options["Timeout"]>30)									;如果超时设置大于30秒，则需要将默认的最大超时时间修改为大于30秒
			WebRequest.SetTimeouts(0,60000,30000,Options["Timeout"]*1000)
		else
			WebRequest.SetTimeouts(0,60000,30000,30000)	;此为SetTimeouts的默认设置。这句可以不加，因为默认就是这样，加在这里是为了表述清晰。

		WebRequest.Open("POST", URL, true)   ;true为异步获取。默认是false，龟速的根源！！！卡顿的根源！！！

		;SetRequestHeader() 必须 Open() 之后才有效
		for k, v in RequestHeaders
		{
			if (k="Cookie")
			{
				WebRequest.SetRequestHeader("Cookie","tuzi")    ;先设置一个cookie，防止出错，msdn推荐这么做
				WebRequest.SetRequestHeader("Cookie",v)
			}
			else
			WebRequest.SetRequestHeader(k,v)
		}
		if (RequestHeaders["Content-Type"]="")
			WebRequest.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
		Loop
		{
			WebRequest.Send(PostData)
			WebRequest.WaitForResponse(-1)								;WaitForResponse方法确保获取的是完整的响应。-1表示总是使用SetTimeouts设置的超时

			;获取状态码，一般status为200说明请求成功
			this.Status:=WebRequest.Status()
			this.StatusText:=WebRequest.StatusText()

			if (Options["expected_status"]="" or Options["expected_status"]=this.Status)
				break
			;尝试指定次数后页面返回的状态码依旧与预期状态码不一致，则抛出错误及详细错误信息（可使用我另一个错误处理函数专门记录处理它们）
			;即使number_of_retries为空，表达式依然成立，所以不用为number_of_retries设置初始值。
			else if (A_Index>=Options["number_of_retries"])
			{
				this.extra.URL:=URL
				this.extra.Expected_Status:=Options["expected_status"]
				this.extra.Status:=this.Status
				this.extra.StatusText:=this.StatusText
				throw, Exception("经过" Options.number_of_retries "次尝试后，服务器返回状态码依旧与期望值不一致", -1, Object(this.extra))
			}
		}
		if (Options["Accept-Encoding"]<>"") && (WebRequest.GetResponseHeader("Content-Encoding") = "gzip")
		{
			this.ResponseHeaders:=this.解析信息到对象(WebRequest.GetAllResponseHeaders())
			body := WebRequest.ResponseBody
			size := body.MaxIndex() + 1
		
			VarSetCapacity(data, size)
			DllCall("oleaut32\SafeArrayAccessData", "ptr", ComObjValue(body), "ptr*", pdata)
			DllCall("RtlMoveMemory", "ptr", &data, "ptr", pdata, "ptr", size)
			DllCall("oleaut32\SafeArrayUnaccessData", "ptr", ComObjValue(body))
			size := GZIP_DecompressBuffer(data, size)
			if(FilePath<>"")
			{
				FileOpen(FilePath, "w").RawWrite(&data, size)
			return 1
			}
			else
			return StrGet(&data, size, Options["Charset"])
		}

		if (Options["Charset"]<>"") or (FilePath<>"")									;设置字符集
		{
			this.ResponseHeaders:=this.解析信息到对象(WebRequest.GetAllResponseHeaders())
			ADO:=ComObjCreate("adodb.stream") 		 	;使用 adodb.stream 编码返回值。参考 http://bbs.howtoadmin.com/ThRead-814-1-1.html
			ADO.Type:=1 														;以二进制方式操作
			ADO.Mode:=3 													;可同时进行读写
			ADO.Open()  														;开启物件
			ADO.Write(WebRequest.ResponseBody())    	;写入物件。注意 WebRequest.ResponseBody() 获取到的是无符号的bytes，通过 adodb.stream 转换成字符串string
			if(FilePath<>"")
			{
				ADO.SaveToFile( FilePath, 2 )
				oADO.Close()
				return, 1
			}
			else
			{
				ADO.Position:=0 												;从头开始
				ADO.Type:=2 														;以文字模式操作
				ADO.Charset:=Options["Charset"]   				;设定编码方式
				ret_var:=ADO.ReadText()   								;将物件内的文字读出
				ADO.Close()
				return, ret_var
			}
		}
		else
		{
			this.ResponseHeaders:=this.解析信息到对象(WebRequest.GetAllResponseHeaders())
		return, WebRequest.ResponseText()
		}
	}

	/*
	infos的格式：每行一个参数，行首至第一个冒号为参数名，之后至行尾为参数值。多个参数换行。
	换句话说，chrome的开发者工具中“Request Header”那段内容直接复制过来就能用。
	需要注意第一行“GET /?tn=sitehao123 HTTP/1.1”其实是没有任何作用的，因为没有“:”。但复制过来了也并不会影响正常解析。

	infos=
	(
	GET /?tn=sitehao123 HTTP/1.1
	Host: www.baidu.com
	Connection: keep-alive
	Cache-Control: max-age=0
	Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
	User-Agent: Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36 SE 2.X MetaSr 1.0
	DNT: 1
	Referer: http://www.hao123.com/
	Accept-Encoding: gzip,deflate,sdch
	Accept-Language: zh-CN,zh;q=0.8
	)
	*/
	解析信息到对象(infos)
	{
		if (IsObject(infos)=1)
			return, infos

		;以下两步可将“infos”换行符统一为`r`n，避免正则表达式提取时出错
		StringReplace, infos, infos, `r`n, `n, All
		StringReplace, infos, infos, `n, `r`n, All

		infos_temp:=GlobalRegExMatch(infos,"m)(^.*?):(.*$)",1)
		;将正则匹配到的信息存入新的对象中，像这样{"Connection":"keep-alive","Cache-Control":"max-age=0"}
		infos:=[]
		Loop, % infos_temp.MaxIndex()
		{
			name:=Trim(infos_temp[A_Index].Value[1], " `t`r`n`v`f")						;Trim()的作用就是把“abc: haha”中haha的多余空白符消除
			value:=Trim(infos_temp[A_Index].Value[2], " `t`r`n`v`f")

			;“Set-Cookie”是可以一次返回多条的。
			if (name="Set-Cookie")
				infos[name].=value . "`r`n"
			else
				infos[name]:=value
		}

		return, infos
	}

	/*
	在“GetAllResponseHeaders”中，“Set-Cookie”可能一次存在多个，比如“Set-Cookie:name=a; domain=xxx.com `r`n Set-Cookie:name=b; domain=www.xxx.com”。
	之后向服务器发送cookie的时候，会先验证domain，再验证path，两者都成功，再发送所有符合条件的cookies。
	domain的匹配方式是从字符串的尾部开始比较。
	path的匹配方式是从头开始逐字符串比较（例如/blog与/blog、/blogrool等等都匹配）。需要注意的是，path只在domain完成匹配后才比较。
	当下次访问“www.xxx.com”时，由于有2个符合条件的cookie，所以发送给服务器的cookie应该是“name=b; name=a”。
	当下次访问“xxx.com”时，由于只有1个符合条件的cookie，所以发送给服务器的cookie应该是“name=a”。
	规则是，path越详细，越靠前。domain越详细，越靠前（domain和path加起来就是网址了）。
	另外需要注意的是，“Set-Cookie”中没有domain或者path的话，则以当前url为准。
	如果要覆盖一个已有的cookie值，那么需要创建一个name、domain、path，完全相同的“Set-Cookie”（name就是“cookie:name=value; path=/”中的name）。
	当一个cookie存在，并且可选条件允许的话，该cookie的值会在接下来的每个请求中被发送至服务器。
	其值被存储在名为Cookie的HTTP消息头中，并且只包含了cookie的值，其它的选项全部被去除（expires，domain，path，secure全部没有了）。
	如果在指定的请求中有多个cookies，那么它们会被分号和空格分开，例如：（Cookie:value1 ; value2 ; name1=value1）
	在没有expires选项时，cookie的寿命仅限于单一的会话中。浏览器的关闭意味这一次会话的结束，所以会话cookie只存在于浏览器保持打开的状态之下。
	如果expires选项设置了一个过去的时间点，那么这个cookie会被立即删除。
	最后一个选项是secure。不像其它选项，该选项只是一个标记并且没有其它的值。
	“http://my.oschina.net/hmj/blog/69638” 参考答案。
	要想做到完全如浏览器般自动管理cookies，每个链接发对应的cookie，难度颇大。模拟登录什么的，可以一步一步提取所需cookie再发送给服务器。综合考虑，暂时不写自动管理。
	*/

	;管理cookie(cookie)
	;{
	;	return
	;}
}

GZIP_DecompressBuffer( ByRef var, nSz ) { ; 'Microsoft GZIP Compression DLL' SKAN 20-Sep-2010
; Decompress routine for 'no-name single file GZIP', available in process memory.
; Forum post :  www.autohotkey.com/forum/viewtopic.php?p=384875#384875
; Modified by Lexikos 25-Apr-2015 to accept the data size as a parameter.
	
; Modified version by tmplinshi
	static hModule, _
	static GZIP_InitDecompression, GZIP_CreateDecompression, GZIP_Decompress
     , GZIP_DestroyDecompression, GZIP_DeInitDecompression

	If !hModule {
		If !hModule := DllCall("LoadLibrary", "Str", "gzip.dll", "Ptr")		
		;If !hModule := DllCall(A_ScriptDir "\lib\gzip.dll", "Str", "gzip.dll", "Ptr")
		{			
			MsgBox % "Error: Loading gzip.dll failed! Exiting App."
			ExitApp
		}
		For k, v in ["InitDecompression","CreateDecompression","Decompress","DestroyDecompression","DeInitDecompression"]
			GZIP_%v% := DllCall("GetProcAddress", Ptr, hModule, "AStr", v, "Ptr")
		
		_ := { base: {__Delete: "GZIP_DecompressBuffer"} }
	}
	If !_ 
		Return DllCall("FreeLibrary", "Ptr", hModule)
	
	vSz :=  NumGet( var,nsz-4 ), VarSetCapacity( out,vsz,0 )
	DllCall( GZIP_InitDecompression )
	DllCall( GZIP_CreateDecompression, UIntP,CTX, UInt,1 )
	If ( DllCall( GZIP_Decompress, UInt,CTX, UInt,&var, UInt,nsz, UInt,&Out, UInt,vsz
    , UIntP,input_used, UIntP,output_used ) = 0 && ( Ok := ( output_used = vsz ) ) )
		VarSetCapacity( var,64 ), VarSetCapacity( var,0 ), VarSetCapacity( var,vsz,32 )
    , DllCall( "RtlMoveMemory", UInt,&var, UInt,&out, UInt,vsz )
	DllCall( GZIP_DestroyDecompression, UInt,CTX ),  DllCall( GZIP_DeInitDecompression )
	Return Ok ? vsz : 0
}

;此函数和 RegExMatch() 有两个区别
;1.仅 3 个参数,第三个参数为 StartingPosition
;2.返回值是数组对象,其每个值都是使用 "O" 选项返回的匹配对象
;可用 返回值.1.Pos[0] 或 返回值[2].Len[1] 等方式获取每个捕获的各种信息. 具体可以获取到什么,请参考 "匹配对象"
;可用 返回值.MaxIndex()="" 判断无匹配
GlobalRegExMatch(Haystack,NeedleRegEx,StartingPosition)
  {
    ObjOut:=[]
    NeedleRegEx:=正则添加O选项(NeedleRegEx)					;为正则添加 "O" 选项
    Loop
      {
        RegExMatch(Haystack,NeedleRegEx,UnquotedOutputVar,StartingPosition)	;注意第三个参数,无需引号却实现了添加引号后的效果…… 混乱的根源就在这些地方……
        If (UnquotedOutputVar.Value[0]="")					;不能直接使用该函数返回值判断是否找到内容. 在表达式为 "0*$" ,待匹配字串为 "100.101" ,会出现返回 位置8 , 长度0 的错误
            break								;匹配值为空(隐含函数失败),则退出循环避免死循环
        StartingPosition:=UnquotedOutputVar.Pos[0]+UnquotedOutputVar.Len[0]	;匹配成功则设置下次匹配起点为上次成功匹配字符串的末尾. 这样可以使表达式 "ABCABC" ,匹配字符串 "ABCABCABCABC" 时返回 2 次结果
        ObjOut.Insert(UnquotedOutputVar)
      }
    return,ObjOut
  }

;此函数作用等同 RegExMatch() ,主要意义是统一返回值格式,便于处理
RegExMatchLikeGlobal(Haystack,NeedleRegEx,StartingPosition)
  {
    ObjOut:=[]
    NeedleRegEx:=正则添加O选项(NeedleRegEx)					;为正则添加 "O" 选项
    RegExMatch(Haystack,NeedleRegEx,UnquotedOutputVar,StartingPosition)
    If (UnquotedOutputVar.Value[0]<>"")
        ObjOut.Insert(UnquotedOutputVar)
    return,ObjOut
  }

;此函数用于给正则表达式添加 "O" 选项,使得输出变量为匹配对象,便于分析处理
;返回值将确保 "O" 选项存在并仅存一个,不会出现 OimO)abc.* 这种情况
;输入到此函数中的正则表达式为不带引号的正则,可包含选项. 例如 im)abc.* 将被支持. "im)123.*" 不被支持
正则添加O选项(NeedleRegEx)
{
  选项分隔符位置:=InStr(NeedleRegEx,")")
  If (选项分隔符位置<>0)
    {
      正则选项:=SubStr(NeedleRegEx,1,选项分隔符位置)
      正则:=SubStr(NeedleRegEx,选项分隔符位置+1)
      StringCaseSense, On			;大小写敏感
      StringReplace, temp, 正则选项, i, , All	;以下是正则表达式选项中可能存在的字符
      StringReplace, temp, temp, m, , All
      StringReplace, temp, temp, s, , All
      StringReplace, temp, temp, x, , All
      StringReplace, temp, temp, A, , All
      StringReplace, temp, temp, D, , All
      StringReplace, temp, temp, J, , All
      StringReplace, temp, temp, U, , All
      StringReplace, temp, temp, X, , All
      StringReplace, temp, temp, P, , All
      StringReplace, temp, temp, S, , All
      StringReplace, temp, temp, C, , All
      StringReplace, temp, temp, O, , All
      StringReplace, temp, temp, `n, , All
      StringReplace, temp, temp, `r, , All
      StringReplace, temp, temp, `a, , All
      StringReplace, temp, temp, %A_Space%, , All
      StringReplace, temp, temp, %A_Tab%, , All
      StringCaseSense, Off
      If (temp=")")				;若最后结果仅剩闭括号 ")" ,说明这个括号的作用是选项分隔符
        {
          If (InStr(正则选项,"O",1)<>0)		;大小写敏感的检查选项中是否存在 "O" 选项,需确保其存在并唯一
              return,NeedleRegEx		;存在选项 "O" 则直接返回
          Else
              return,"O" . 正则选项 . 正则	;添加选项 "O" 并返回
        }
    }
  return,"O)" . NeedleRegEx
}

; ======================================================================================================================
; Namespace:      LV_Colors
; Function:       Individual row and cell coloring for AHK ListView controls.
; Tested with:    AHK 1.1.23.05 (A32/U32/U64)
; Tested on:      Win 10 (x64)
; Changelog:
;     1.1.04.01/2016-05-03/just me - added change to remove the focus rectangle from focused rows
;     1.1.04.00/2016-05-03/just me - added SelectionColors method
;     1.1.03.00/2015-04-11/just me - bugfix for StaticMode
;     1.1.02.00/2015-04-07/just me - bugfixes for StaticMode, NoSort, and NoSizing
;     1.1.01.00/2015-03-31/just me - removed option OnMessage from __New(), restructured code
;     1.1.00.00/2015-03-27/just me - added AlternateRows and AlternateCols, revised code.
;     1.0.00.00/2015-03-23/just me - new version using new AHK 1.1.20+ features
;     0.5.00.00/2014-08-13/just me - changed 'static mode' handling
;     0.4.01.00/2013-12-30/just me - minor bug fix
;     0.4.00.00/2013-12-30/just me - added static mode
;     0.3.00.00/2013-06-15/just me - added "Critical, 100" to avoid drawing issues
;     0.2.00.00/2013-01-12/just me - bugfixes and minor changes
;     0.1.00.00/2012-10-27/just me - initial release
; ======================================================================================================================
; CLASS LV_Colors
;
; The class provides six public methods to set individual colors for rows and/or cells, to clear all colors, to
; prevent/allow sorting and rezising of columns dynamically, and to deactivate/activate the message handler for
; WM_NOTIFY messages (see below).
;
; The message handler for WM_NOTIFY messages will be activated for the specified ListView whenever a new instance is
; created. If you want to temporarily disable coloring call MyInstance.OnMessage(False). This must be done also before
; you try to destroy the instance. To enable it again, call MyInstance.OnMessage().
;
; To avoid the loss of Gui events and messages the message handler might need to be set 'critical'. This can be
; achieved by setting the instance property 'Critical' ti the required value (e.g. MyInstance.Critical := 100).
; New instances default to 'Critical, Off'. Though sometimes needed, ListViews or the whole Gui may become
; unresponsive under certain circumstances if Critical is set and the ListView has a g-label.
; ======================================================================================================================
Class LV_Colors {
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; META FUNCTIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; __New()         Create a new LV_Colors instance for the given ListView
   ; Parameters:     HWND        -  ListView's HWND.
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 StaticMode  -  Static color assignment, i.e. the colors will be assigned permanently to the row
   ;                                contents rather than to the row number.
   ;                                Values:  True/False
   ;                                Default: False
   ;                 NoSort      -  Prevent sorting by click on a header item.
   ;                                Values:  True/False
   ;                                Default: True
   ;                 NoSizing    -  Prevent resizing of columns.
   ;                                Values:  True/False
   ;                                Default: True
   ; ===================================================================================================================
   __New(HWND, StaticMode := False, NoSort := True, NoSizing := True) {
      If (This.Base.Base.__Class) ; do not instantiate instances
         Return False
      If This.Attached[HWND] ; HWND is already attached
         Return False
      If !DllCall("IsWindow", "Ptr", HWND) ; invalid HWND
         Return False
      VarSetCapacity(Class, 512, 0)
      DllCall("GetClassName", "Ptr", HWND, "Str", Class, "Int", 256)
      If (Class <> "SysListView32") ; HWND doesn't belong to a ListView
         Return False
      ; ----------------------------------------------------------------------------------------------------------------
      ; Set LVS_EX_DOUBLEBUFFER (0x010000) style to avoid drawing issues.
      SendMessage, 0x1036, 0x010000, 0x010000, , % "ahk_id " . HWND ; LVM_SETEXTENDEDLISTVIEWSTYLE
      ; Get the default colors
      SendMessage, 0x1025, 0, 0, , % "ahk_id " . HWND ; LVM_GETTEXTBKCOLOR
      This.BkClr := ErrorLevel
      SendMessage, 0x1023, 0, 0, , % "ahk_id " . HWND ; LVM_GETTEXTCOLOR
      This.TxClr := ErrorLevel
      ; Get the header control
      SendMessage, 0x101F, 0, 0, , % "ahk_id " . HWND ; LVM_GETHEADER
      This.Header := ErrorLevel
      ; Set other properties
      This.HWND := HWND
      This.IsStatic := !!StaticMode
      This.AltCols := False
      This.AltRows := False
      This.NoSort(!!NoSort)
      This.NoSizing(!!NoSizing)
      This.OnMessage()
      This.Critical := "Off"
      This.Attached[HWND] := True
   }
   ; ===================================================================================================================
   __Delete() {
      This.Attached.Remove(HWND, "")
      This.OnMessage(False)
      WinSet, Redraw, , % "ahk_id " . This.HWND
   }
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PUBLIC METHODS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; ===================================================================================================================
   ; Clear()         Clears all row and cell colors.
   ; Parameters:     AltRows     -  Reset alternate row coloring (True / False)
   ;                                Default: False
   ;                 AltCols     -  Reset alternate column coloring (True / False)
   ;                                Default: False
   ; Return Value:   Always True.
   ; ===================================================================================================================
   Clear(AltRows := False, AltCols := False) {
      If (AltCols)
         This.AltCols := False
      If (AltRows)
         This.AltRows := False
      This.Remove("Rows")
      This.Remove("Cells")
      Return True
   }
   ; ===================================================================================================================
   ; AlternateRows() Sets background and/or text color for even row numbers.
   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   AlternateRows(BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      This.AltRows := False
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["ARB"] := (BkBGR <> "") ? BkBGR : This.BkClr
      This["ART"] := (TxBGR <> "") ? TxBGR : This.TxClr
      This.AltRows := True
      Return True
   }
   ; ===================================================================================================================
   ; AlternateCols() Sets background and/or text color for even column numbers.
   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   AlternateCols(BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      This.AltCols := False
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["ACB"] := (BkBGR <> "") ? BkBGR : This.BkClr
      This["ACT"] := (TxBGR <> "") ? TxBGR : This.TxClr
      This.AltCols := True
      Return True
   }
   ; ===================================================================================================================
   ; SelectionColors() Sets background and/or text color for selected rows.
   ; Parameters:     BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default selected background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default selected text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   SelectionColors(BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      This.SelColors := False
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["SELB"] := BkBGR
      This["SELT"] := TxBGR
      This.SelColors := True
      Return True
   }
   ; ===================================================================================================================
   ; Row()           Sets background and/or text color for the specified row.
   ; Parameters:     Row         -  Row number
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> default text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   Row(Row, BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      If This.IsStatic
         Row := This.MapIndexToID(Row)
      This["Rows"].Remove(Row, "")
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      This["Rows", Row, "B"] := (BkBGR <> "") ? BkBGR : This.BkClr
      This["Rows", Row, "T"] := (TxBGR <> "") ? TxBGR : This.TxClr
      Return True
   }
   ; ===================================================================================================================
   ; Cell()          Sets background and/or text color for the specified cell.
   ; Parameters:     Row         -  Row number
   ;                 Col         -  Column number
   ;                 Optional ------------------------------------------------------------------------------------------
   ;                 BkColor     -  Background color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> row's background color
   ;                 TxColor     -  Text color as RGB color integer (e.g. 0xFF0000 = red) or HTML color name.
   ;                                Default: Empty -> row's text color
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   Cell(Row, Col, BkColor := "", TxColor := "") {
      If !(This.HWND)
         Return False
      If This.IsStatic
         Row := This.MapIndexToID(Row)
      This["Cells", Row].Remove(Col, "")
      If (BkColor = "") && (TxColor = "")
         Return True
      BkBGR := This.BGR(BkColor)
      TxBGR := This.BGR(TxColor)
      If (BkBGR = "") && (TxBGR = "")
         Return False
      If (BkBGR <> "")
         This["Cells", Row, Col, "B"] := BkBGR
      If (TxBGR <> "")
         This["Cells", Row, Col, "T"] := TxBGR
      Return True
   }
   ; ===================================================================================================================
   ; NoSort()        Prevents/allows sorting by click on a header item for this ListView.
   ; Parameters:     Apply       -  True/False
   ;                                Default: True
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   NoSort(Apply := True) {
      If !(This.HWND)
         Return False
      If (Apply)
         This.SortColumns := False
      Else
         This.SortColumns := True
      Return True
   }
   ; ===================================================================================================================
   ; NoSizing()      Prevents/allows resizing of columns for this ListView.
   ; Parameters:     Apply       -  True/False
   ;                                Default: True
   ; Return Value:   True on success, otherwise false.
   ; ===================================================================================================================
   NoSizing(Apply := True) {
      Static OSVersion := DllCall("GetVersion", "UChar")
      If !(This.Header)
         Return False
      If (Apply) {
         If (OSVersion > 5)
            Control, Style, +0x0800, , % "ahk_id " . This.Header ; HDS_NOSIZING = 0x0800
         This.ResizeColumns := False
      }
      Else {
         If (OSVersion > 5)
            Control, Style, -0x0800, , % "ahk_id " . This.Header ; HDS_NOSIZING
         This.ResizeColumns := True
      }
      Return True
   }
   ; ===================================================================================================================
   ; OnMessage()     Adds/removes a message handler for WM_NOTIFY messages for this ListView.
   ; Parameters:     Apply       -  True/False
   ;                                Default: True
   ; Return Value:   Always True
   ; ===================================================================================================================
   OnMessage(Apply := True) {
      If (Apply) && !This.HasKey("OnMessageFunc") {
         This.OnMessageFunc := ObjBindMethod(This, "On_WM_Notify")
         OnMessage(0x004E, This.OnMessageFunc) ; add the WM_NOTIFY message handler
      }
      Else If !(Apply) && This.HasKey("OnMessageFunc") {
         OnMessage(0x004E, This.OnMessageFunc, 0) ; remove the WM_NOTIFY message handler
         This.OnMessageFunc := ""
         This.Remove("OnMessageFunc")
      }
      WinSet, Redraw, , % "ahk_id " . This.HWND
      Return True
   }
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PRIVATE PROPERTIES  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   Static Attached := {}
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; PRIVATE METHODS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   ; +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   On_WM_NOTIFY(W, L, M, H) {
      ; Notifications: NM_CUSTOMDRAW = -12, LVN_COLUMNCLICK = -108, HDN_BEGINTRACKA = -306, HDN_BEGINTRACKW = -326
      Critical, % This.Critical
      If ((HCTL := NumGet(L + 0, 0, "UPtr")) = This.HWND) || (HCTL = This.Header) {
         Code := NumGet(L + (A_PtrSize * 2), 0, "Int")
         If (Code = -12)
            Return This.NM_CUSTOMDRAW(This.HWND, L)
         If !This.SortColumns && (Code = -108)
            Return 0
         If !This.ResizeColumns && ((Code = -306) || (Code = -326))
            Return True
      }
   }
   ; -------------------------------------------------------------------------------------------------------------------
   NM_CUSTOMDRAW(H, L) {
      ; Return values: 0x00 (CDRF_DODEFAULT), 0x20 (CDRF_NOTIFYITEMDRAW / CDRF_NOTIFYSUBITEMDRAW)
      Static SizeNMHDR := A_PtrSize * 3                  ; Size of NMHDR structure
      Static SizeNCD := SizeNMHDR + 16 + (A_PtrSize * 5) ; Size of NMCUSTOMDRAW structure
      Static OffItem := SizeNMHDR + 16 + (A_PtrSize * 2) ; Offset of dwItemSpec (NMCUSTOMDRAW)
      Static OffItemState := OffItem + A_PtrSize         ; Offset of uItemState  (NMCUSTOMDRAW)
      Static OffCT :=  SizeNCD                           ; Offset of clrText (NMLVCUSTOMDRAW)
      Static OffCB := OffCT + 4                          ; Offset of clrTextBk (NMLVCUSTOMDRAW)
      Static OffSubItem := OffCB + 4                     ; Offset of iSubItem (NMLVCUSTOMDRAW)
      ; ----------------------------------------------------------------------------------------------------------------
      DrawStage := NumGet(L + SizeNMHDR, 0, "UInt")
      , Row := NumGet(L + OffItem, "UPtr") + 1
      , Col := NumGet(L + OffSubItem, "Int") + 1
      , Item := Row - 1
      If This.IsStatic
         Row := This.MapIndexToID(Row)
      ; CDDS_SUBITEMPREPAINT = 0x030001 --------------------------------------------------------------------------------
      If (DrawStage = 0x030001) {
         UseAltCol := !(Col & 1) && (This.AltCols)
         , ColColors := This["Cells", Row, Col]
         , ColB := (ColColors.B <> "") ? ColColors.B : UseAltCol ? This.ACB : This.RowB
         , ColT := (ColColors.T <> "") ? ColColors.T : UseAltCol ? This.ACT : This.RowT
         , NumPut(ColT, L + OffCT, "UInt"), NumPut(ColB, L + OffCB, "UInt")
         Return (!This.AltCols && !This.HasKey(Row) && (Col > This["Cells", Row].MaxIndex())) ? 0x00 : 0x20
      }
      ; CDDS_ITEMPREPAINT = 0x010001 -----------------------------------------------------------------------------------
      If (DrawStage = 0x010001) {
         ; LVM_GETITEMSTATE = 0x102C, LVIS_SELECTED = 0x0002
         If (This.SelColors) && DllCall("SendMessage", "Ptr", H, "UInt", 0x102C, "Ptr", Item, "Ptr", 0x0002, "UInt") {
            ; Remove the CDIS_SELECTED (0x0001) and CDIS_FOCUS (0x0010) states from uItemState and set the colors.
            NumPut(NumGet(L + OffItemState, "UInt") & ~0x0011, L + OffItemState, "UInt")
            If (This.SELB <> "")
               NumPut(This.SELB, L + OffCB, "UInt")
            If (This.SELT <> "")
               NumPut(This.SELT, L + OffCT, "UInt")
            Return 0x02 ; CDRF_NEWFONT
         }
         UseAltRow := (Item & 1) && (This.AltRows)
         , RowColors := This["Rows", Row]
         , This.RowB := RowColors ? RowColors.B : UseAltRow ? This.ARB : This.BkClr
         , This.RowT := RowColors ? RowColors.T : UseAltRow ? This.ART : This.TxClr
         If (This.AltCols || This["Cells"].HasKey(Row))
            Return 0x20
         NumPut(This.RowT, L + OffCT, "UInt"), NumPut(This.RowB, L + OffCB, "UInt")
         Return 0x00
      }
      ; CDDS_PREPAINT = 0x000001 ---------------------------------------------------------------------------------------
      Return (DrawStage = 0x000001) ? 0x20 : 0x00
   }
   ; -------------------------------------------------------------------------------------------------------------------
   MapIndexToID(Row) { ; provides the unique internal ID of the given row number
      SendMessage, 0x10B4, % (Row - 1), 0, , % "ahk_id " . This.HWND ; LVM_MAPINDEXTOID
      Return ErrorLevel
   }
   ; -------------------------------------------------------------------------------------------------------------------
   BGR(Color, Default := "") { ; converts colors to BGR
      Static Integer := "Integer" ; v2
      ; HTML Colors (BGR)
      Static HTML := {AQUA: 0xFFFF00, BLACK: 0x000000, BLUE: 0xFF0000, FUCHSIA: 0xFF00FF, GRAY: 0x808080, GREEN: 0x008000
                    , LIME: 0x00FF00, MAROON: 0x000080, NAVY: 0x800000, OLIVE: 0x008080, PURPLE: 0x800080, RED: 0x0000FF
                    , SILVER: 0xC0C0C0, TEAL: 0x808000, WHITE: 0xFFFFFF, YELLOW: 0x00FFFF}
      If Color Is Integer
         Return ((Color >> 16) & 0xFF) | (Color & 0x00FF00) | ((Color & 0xFF) << 16)
      Return (HTML.HasKey(Color) ? HTML[Color] : Default)
   }
}