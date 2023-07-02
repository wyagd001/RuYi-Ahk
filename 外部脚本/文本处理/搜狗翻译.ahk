;|2.0|2023.07.01|1228
; 来源网址: https://www.autoahk.com/archives/44308
; author tmz
#SingleInstance force
SoGouTrans.select_word := A_Args[1]
CoordMode, Mouse, Screen
MouseGetPos, xpos, ypos
; 1228
搜狗网络翻译:
SoGouTrans.create_transhtml_gui(xpos, ypos)
return

~LButton up::
WinGetActiveTitle, active_title
if(active_title = SoGouTrans.html_title)
	return
else
{
	gui, translate2:destroy
	exitapp
}
return

GuiEscape:
Gui Translate2:Destroy
exitapp
return

class SoGouTrans
{
	static html_title := "ahk_translate_result_v1"  ;翻译的小图标
	static html_scala := 0.8  ;缩放 范围(0-1] （0最小，1最大)
	static html_hwnd ;html的句柄
	static select_word ;选中字符
	static html_head ;缓存头部
	static html_foot ;缓存尾部
	static gui_width := 520 ;显示html的宽度，缩放之前
	static ignore_title ;忽略翻译的
	static grid_width := 15 ;背景取样格子大小,单位像素
	;显示翻译结果gui
	create_transhtml_gui(obs_x,obs_y)
	{
		;msgbox % SoGouTrans.select_word
		html_page := SoGouTrans.get_sogou_word_htmlreuslt(SoGouTrans.select_word, "en")
		;msgbox % html_page
		html_page := html_page ? html_page : SoGouTrans.get_sougou_sentence_htmlresult(SoGouTrans.select_word, "zh-CHS")
		if(!html_page)
			return
		global WB ; 浏览器对象
		global MenuHwnd2 ; 句柄
		gui_width := SoGouTrans.gui_width * SoGouTrans.html_scala
		;gui_width := 830 * SoGouTrans.html_scala
		gui_title := SoGouTrans.html_title ; ahk翻译
		Gui,translate2:New,, % gui_title
		;sleep ,100
		Gui,translate2:Add, ActiveX, x0 y0 w%gui_width% h1080 vWB, Shell.Explorer  ; 最后一个参数是ActiveX组件的名称。
		;Gui,translate2:Add, ActiveX, x0 y0 w600 h1080 vWB, Shell.Explorer  ; 最后一个参数是ActiveX组件的名称。
		Gui, translate2:Color, 30f0ca
		;tooltip % "xx2:" WB.readystate
		Gui,translate2:+LastFound +HwndMenuHwnd2  +AlwaysOnTop -Caption +ToolWindow
		SoGouTrans.html_hwnd:=MenuHwnd2
		WB.silent := true ; Surpress JS Error boxes
		;msgBox % SoGouTrans.select_word
		;msgBox % html_page
		;html_page := "<h1>hello world!</h1>"
		SoGouTrans.Display(WB, html_page)
		while WB.readystate != 4 or WB.busy
			sleep 10
		;div_w := WB.document.getElementById("mainDiv").offsetWidth
		div_h := WB.document.getElementById("mainDiv").offsetHeight
		div_h := (div_h - 20) * SoGouTrans.html_scala - 17
		div_w := gui_width-16
		;msgBox % div_w
		;Gui translate2:Show, x%obs_x% y%obs_y% w%div_w% h%div_h% NoActivate
		SoGouTrans.show_transhtml_gui(obs_x, obs_y, div_w, div_h)
		;WinSet, TransColor, 000000 250
		Util.FrameShadow(MenuHwnd2) ; 窗口阴影
		WinSet, AlwaysOnTop, Off, % gui_title ; 去掉总在最上面限制，在切换窗口的时候可以隐藏，但是并不会关闭
	}
	; 调整gui显示的位置，对边界进行处理,gui_w,gui_h是窗口缩放后的宽度高度，x,y是绝对位置
	show_transhtml_gui(obs_x, obs_y, div_w, div_h)
	{
		line_height := 32
		screen_w := A_ScreenWidth ; 屏幕宽度
		screen_h := A_ScreenHeight ; 屏幕高度
		; 处理右边界
		if(obs_x + div_w > screen_w)
		{
			obs_x := screen_w-div_w
		}
		; 处理下边界
		if(obs_y + div_h > screen_h)
		{
			obs_y := obs_y-line_height-div_h
			gui,translate:destroy ;不显示图标了
		}
		Gui translate2:Show, x%obs_x% y%obs_y% w%div_w% h%div_h% NoActivate
		Gui translate2:Show, x%obs_x% y%obs_y% w%div_w% h%div_h%
	}
	;展示html
	Display(WB, html_str)
	{
		Count := 0
		while % FileExist(f := A_Temp "\" A_TickCount A_NowUTC "-tmp" Count ".DELETEME.html")
			Count+=1
		FileAppend, %html_str%, %f%, UTF-8
		;f=C:\Users\Administrator\Desktop\xx4.html
		WB.Navigate("file://" . f)
		;msgBox % WB.readystate
	}
	; 获取搜狗输翻译html片段, keyword 要翻译的词汇，language 要翻译成的语言（翻译句子）
	get_sougou_sentence_htmlresult(keyword, language)
	{
		uri = https://fanyi.sogou.com/text?keyword=%keyword%&transfrom=auto&transto=%language%&model=general
		uri := Util.urlEncode(uri)
		;msgbox % uri
		result := WinHttp.UrlGet(uri)

		start_element = <div class="trans-to-bar"> ; 搜索结果只有一个
		end_element = <div class="operate-box"> ; 搜索结果有两个以上，必须以上面一个变量开始搜索
		StringReplace, result, result, "//, "https://, All ; 把路径转换为绝对路径
		if(SoGouTrans.get_resulthtml_headfoot(result))
		{
			html_head_frag := SoGouTrans.html_head
			html_foot_frag := SoGouTrans.html_foot
		}
		else
		{
			return
		}
		start_pos := instr(result, start_element, 1, 1) ; 参数依次是1.目标字符，2.要匹配的字符，3.是否大小写敏感，4.起始位置
		if(!start_pos)
			return
		; 参数依次是1.目标字符，2.要匹配的字符，3.是否大小写消息敏感，4.起始位置
		end_pos := instr(result, end_element, 1, start_word_post)
		if(!end_pos)
			return
		sentence_resulthtml_frag := subStr(result, start_pos, end_pos-start_pos)
		border_color := SoGouTrans.ico_color
		html_scala := SoGouTrans.html_scala
		div_w := SoGouTrans.gui_width "px"
		;StringReplace, sentence_resulthtml_frag, sentence_resulthtml_frag, <div class="trans-box" >, <div class="trans-box" style="width:%div_w%">
		left_div_html = <div id="mainDiv" style="zoom:%html_scala%;border-top:5px solid #%border_color%;width:%div_w%"><div class="trans-box"><div id="trans-to" class="trans-to"><div class="trans-con">
		result_html = %html_head_frag% %left_div_html% %sentence_resulthtml_frag% </div></div></div></div>%html_foot_frag% ;加入div用于计算html的size
		;fileAppend ,% result_html ,C:\Users\Administrator\Desktop\sentence.html,Utf-8
		return result_html
	}
	; 获取搜狗输翻译html片段, keyword 要翻译的词汇，language 要翻译成的语言（翻译单词或者短语）
	get_sogou_word_htmlreuslt(keyword, language)
	{
		uri = https://fanyi.sogou.com/text?keyword=%keyword%&transfrom=auto&transto=%language%&model=general
		uri := Util.urlEncode(uri)
		result := WinHttp.UrlGet(uri)
		;msgbox % result

		StringReplace, result, result, "//, "https://, All ;把路径转换为绝对路径
		;msgBox ~ok3
		;fileAppend ,% result ,C:\Users\Administrator\Desktop\xx.html,Utf-8
		start_word = <div class="word-details-card
		end_word = <div class="dictionary-list">
		if(SoGouTrans.get_resulthtml_headfoot(result))
		{
			html_head_frag := SoGouTrans.html_head ;
			html_foot_frag := SoGouTrans.html_foot ;
		}
		else
		{
			return
		}
		start_word_post := instr(result,start_word,1,1)
		if(!start_word_post)
			return
		;msgBox ~3
		end_word_post := instr(result,end_word,1,start_word_post)
		if(!end_word_post || end_word_post < start_word_post)
			return
		;msgBox ~4
		key_word_frag := subStr(result,start_word_post,end_word_post-start_word_post)
		border_color := SoGouTrans.ico_color
		html_scala := SoGouTrans.html_scala
		left_div_html = <div id="mainDiv" style="zoom:%html_scala%;border-top:5px solid #%border_color%"><div class="container" style="width: 50`%"><div class="trans-main" style="width: 200`%"><div class="main-left">
		result_html = %html_head_frag% %left_div_html% %key_word_frag% </div></div></div></div>%html_foot_frag% ; 加入div用于计算html的size
		;fileAppend ,% result_html ,C:\Users\Administrator\Desktop\xx4.html,Utf-8
		;fileAppend ,% key_word_frag ,C:\Users\Administrator\Desktop\key_word_frag.html,Utf-8
		;MsgBox % result_html
		return result_html
	}
	;获取翻译结果的html的头尾，并保存
	get_resulthtml_headfoot(html)
	{
		result := html
		body_start = <!--[if lte IE 9]>
		body_end = </div><script>
		if(SoGouTrans.html_head && SoGouTrans.html_foot)
		{
			return 1
		}
		else
		{
			body_start_post := instr(result,body_start,1,1)
			if(!body_start_post)
				return
			;msgBox ~1
			body_end_post := instr(result, body_end, 1, body_start_post)
			if(!body_end_post || body_end_post < body_start_post )
				return
			;msgBox ~2
			html_head_frag := subStr(result,1, body_start_post-1)
			html_foot_frag := subStr(result,body_end_post + strLen("</div>"))
			SoGouTrans.html_head := html_head_frag
			SoGouTrans.html_foot := html_foot_frag
				return 1
		}
	}
	;计算背景颜色，采集20个点，判断颜色最多的，去掉背景会残留只有融入背景才能让图形更圆滑
	calculate_bg_color(obs_x,obs_y,font_size)
	{
		grid_width := SoGouTrans.grid_width ;取样格子宽度
		x:=obs_x+font_size+10
		y:=obs_y+font_size+10
		color_map:={}
		loop , 5
		{
			i:=A_Index
			loop 4
			{
				j:=A_Index
				PixelGetColor,current_color, % x+j*grid_width,% obs_y+i*grid_width ,RGB
				;                msgBox % x+j*grid_width "," y+i*grid_width " color:" current_color
				if(!color_map[current_color])
					color_map[current_color]:=1
				else
					color_map[current_color]:=color_map[current_color]+1
			}
		}
		tmp_count:=0
		tmp_color:=0
		for key,value in color_map
		{
			if(color_map[key]>tmp_count)
			{
				tmp_count:=color_map[key]
				tmp_color:=key
			}
		}
		;        msgBox % msg "color:" Util.ToBase(tmp_color,16)
		return Util.ToBase(tmp_color,16)
	}
}

json(ByRef js, s, v = "")
{
	j = %js%
	Loop, Parse, s, .
	{
		p = 2
		RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
		Loop {
			If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
				. "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
				Return
			Else If (x2 == q2 or q2 == "*") {
				j = %x3%
				z += p + StrLen(x2) - 2
				If (q3 != "" and InStr(j, "[") == 1) {
					StringTrimRight, q3, q3, 1
					Loop, Parse, q3, ], [
					{
						z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
						j = %x1%
					}
				}
				Break
			}
			Else p += StrLen(x)
		}
	}
	If v !=
	{
		vs = "
		If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
			and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
			vs := "", v := vx1
		StringReplace, v, v, ", \", All
		js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
	}
	Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
		? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
}

class Util
{
	;解码unicode
	decodeUtf8(value)
	{
		i := 0
		while (i := InStr(value, "\",, i+1))
		{
			if !(SubStr(value, i+1, 1) == "u")
			SoGouTrans.ParseError("\", text, pos - StrLen(SubStr(value, i+1)))
			uffff := Abs("0x" . SubStr(value, i+2, 4))
			if (A_IsUnicode || uffff < 0x100)
				value := SubStr(value, 1, i-1) . Chr(uffff) . SubStr(value, i+6)
		}
		Return,value
	}
	ToBase(n,b)
	{
		return (n < b ? "" : Util.ToBase(n//b,b)) . ((d:=Mod(n,b)) < 10 ? d : Chr(d+55))
	}

	urlEncode(url, enc="UTF-8")
	{
		StrPutVar(Url, Var, Enc)
		BackUp_FmtInt := A_FormatInteger
		SetFormat, IntegerFast, H
		Loop
		{
			Code := NumGet(Var, A_Index - 1, "UChar")
			If (!Code)
				Break
			If (Code >= 0x00 && Code <= 0x7A)
				Res .= Chr(Code)
			Else
				Res .= "%" . SubStr(Code + 0x100, -1)
		}
		SetFormat, IntegerFast, %BackUp_FmtInt%
		Return, Res
	}

	;窗口加上阴影
	FrameShadow(HGui)
	{
		DllCall("dwmapi\DwmIsCompositionEnabled","IntP",_ISENABLED) ; Get if DWM Manager is Enabled
		if !_ISENABLED ; if DWM is not enabled, Make Basic Shadow
			DllCall("SetClassLong","UInt",HGui,"Int",-26,"Int",DllCall("GetClassLong","UInt",HGui,"Int",-26)|0x20000)
		else
			VarSetCapacity(_MARGINS,16)
			, NumPut(0,&_MARGINS,0,"UInt")
			, NumPut(0,&_MARGINS,4,"UInt")
			, NumPut(1,&_MARGINS,8,"UInt")
			, NumPut(0,&_MARGINS,12,"UInt")
			, DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", HGui, "UInt", 2, "Int*", 2, "UInt", 4)
			, DllCall("dwmapi\DwmExtendFrameIntoClientArea", "Ptr", HGui, "Ptr", &_MARGINS)
	}
}

SkSub_UrlEncode(str, enc="UTF-8")       ;From Ahk Forum
{
    enc:=trim(enc)
    If enc=
        Return str
   hex := "00", func := "msvcrt\" . (A_IsUnicode ? "swprintf" : "sprintf")
   VarSetCapacity(buff, size:=StrPut(str, enc)), StrPut(str, &buff, enc)
   While (code := NumGet(buff, A_Index - 1, "UChar")) && DllCall(func, "Str", hex, "Str", "%%%02X", "UChar", code, "Cdecl")
		encoded .= hex
   Return encoded
}

soundpaly:
	if !IsObject(spovice)
		spovice:=ComObjCreate("sapi.spvoice")
	spovice.Speak(Youdao_keyword)
Return

StrPutVar(Str, ByRef Var, Enc = "", ExLen = 0)
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1) + ExLen
	VarSetCapacity(Var, Len, 0)
	Return StrPut(Str, &Var, Enc)
}

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

		ComObjError(0) 							; 禁用 COM 错误通告。禁用后，检查 A_LastError 的值，脚本可以实现自己的错误处理
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
		if (Options["Timeout"]="")											; Options["Timeout"]如果被设置为-1，并不代表无限超时，而是依然遵循SetTimeouts第4个参数设置的最大超时时间
			WebRequest.SetTimeouts(0,60000,30000,0)			; 0或-1都表示超时无限等待，正整数则表示最大超时（单位毫秒）
		else if (Options["Timeout"]>30)									; 如果超时设置大于30秒，则需要将默认的最大超时时间修改为大于30秒
			WebRequest.SetTimeouts(0,60000,30000,Options["Timeout"]*1000)
		else
			WebRequest.SetTimeouts(0,60000,30000,30000)	; 此为SetTimeouts的默认设置。这句可以不加，因为默认就是这样，加在这里是为了表述清晰。

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