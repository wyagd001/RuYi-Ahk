;|2.7|2024.07.11|1228
; 来源网址: https://www.autoahk.com/archives/44308
; author tmz
#Include <WinHttp>
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