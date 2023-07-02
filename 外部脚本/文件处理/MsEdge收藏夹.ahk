;|2.0|2023.07.01|1224
; FoxMod : 2014-7-8  注释掉了将 中文转换为 \uXXXX 的一部分代码
; https://github.com/cocobelgica/AutoHotkey-JSON.git
CandySel := A_Args[1]
if !CandySel
	CandySel := A_AppData "\..\Local\Microsoft\Edge\User Data\Default\bookmarks"
if !FileExist(CandySel)
{
	InputBox, CandySel, Edge 收藏夹, 请输入 Edge 浏览器收藏夹文件 bookmarks 的路径,, 640, 140
	if ErrorLevel
		ExitApp
}
if !FileExist(CandySel)
	ExitApp
ATA_settingFile := A_ScriptDir "\..\..\配置文件\如一.ini"
FileRead, OutputVar, % "*P65001 " CandySel
;msgbox % OutputVar "`n" filename
Myobj := JSON.parse(OutputVar)
uRLobj:={}
for k, v in Myobj.roots.bookmark_bar.children
{
	uRLobj[Myobj.roots.bookmark_bar.children[k].name] := Myobj.roots.bookmark_bar.children[k].url
	if (k > 20)
		break
}
show_obj(uRLobj)
return

show_obj(obj, menu_name := ""){
	if menu_name =
	{
		main = 1
		Random, rand, 100000000, 999999999
		menu_name = %A_Now%%rand%
	}
	;Menu, % menu_name, add,
	;Menu, % menu_name, DeleteAll
	for k,v in obj
	{
		if (IsObject(v))
		{
			submenu_name = %k%
			Menu, % submenu_name, add,
			Menu, % submenu_name, DeleteAll
			Menu, % menu_name, add, % k ? k : "", :%submenu_name%
			show_obj(v, submenu_name)
		}
		Else
		{
			Menu, % menu_name, add, % k, MenuHandler
		}
	}
	if main = 1
		menu,% menu_name, show
}

MenuHandler:
Candy_Cmd := uRLobj[A_ThisMenuItem]
;run %Candy_Cmd% %CandySel%,, UseErrorLevel
WinGet, Windy_CurWin_Fullpath, ProcessPath, A
WinGet, OutPID, PID, A
SplitPath, Windy_CurWin_Fullpath, Windy_CurWin_ProcName
ATA_filepath := Candy_Cmd
Gosub CurrentWebOpen
return

CurrentWebOpen:
IniRead, Default_Browser, %ATA_settingFile%, Browser, Default_Browser, %A_Space%
IniRead, url, %ATA_settingFile%, Browser, Default_Url
IniRead, InUse_Browser, %ATA_settingFile%, Browser, InUse_Browser
;msgbox % Default_Browser " - " ATA_settingFile
If Default_Browser
{
	Loop, parse, url, |
	{
		IfInString, ATA_filepath, %A_LoopField%    ;ATA_filepath有特定字符时使用默认浏览器打开
		{
			Loop, parse, Default_Browser, `,
			{
				run %A_LoopField% "%ATA_filepath%",, UseErrorLevel
				if !ErrorLevel
				break
			}
			if (ErrorLevel = "error")
				msgbox A_LastError
			return
		}
	}
}
br := 0
if InStr(InUse_Browser, Windy_CurWin_ProcName)   ;当前窗口在使用的浏览器列表当中
{
	If(Windy_CurWin_ProcName = "chrome.exe" or Windy_CurWin_ProcName = "firefox.exe")
	{
			pid := GetCommandLine2(OutPID)
			run, %pid% "%ATA_filepath%"
			br :=1
	}
	else
	{
			pid := GetModuleFileNameEx(OutPID)
			;msgbox %pid% "%ATA_filepath%"
			run, %pid% "%ATA_filepath%"
			br := 1
	}
}
StringSplit, BApp, InUse_Browser, `,     ;当前窗口进程名不在使用的浏览器列表当中
LoopN := 1
if !br
{
	Loop, %BApp0%
	{
		BCtrApp := BApp%LoopN%
		LoopN++
		Process, Exist, %BCtrApp%
		If (errorlevel<>0)    ;  使用的浏览器列表当中的浏览器进程是否存在
		{
			NewPID = %ErrorLevel%
			If(BCtrApp = "chrome.exe" or BCtrApp = "firefox.exe")
			{
				pid := GetCommandLine2(NewPID)
				;pid := GetCommandLine(NewPID)
				;FileAppend , %pid%`n, %A_desktop%\123.txt
				run, %pid% "%ATA_filepath%"
				br :=1
				break
			}
			else
			{
				pid := GetModuleFileNameEx(NewPID)
				;FileAppend , %pid%`n, %A_desktop%\123.txt
				run, %pid% "%ATA_filepath%"
				br := 1
				break
			}
		}
	}
}
if !br   ; 没有打开的浏览器时使用默认的浏览器
{
	If Default_Browser
	{
		Loop, parse, Default_Browser, `,
		{
			run %A_LoopField% "%ATA_filepath%",, UseErrorLevel
			if !ErrorLevel
			break
		}
		if (ErrorLevel = "error") && (A_LastError = 2)
		{
			msgbox % "找不到默认的浏览器, 请检查设置文件的 Default_Browser 条目, 指定默认的浏览器位置或名称."
		}
	}
	else
	{
		run iexplore.exe %ATA_filepath%,, UseErrorLevel
		if (ErrorLevel = "error")
		msgbox 请检查网址: %ATA_filepath%
	}
}
return

GetModuleFileNameEx(p_pid)
{
	if A_OSVersion in WIN_95,WIN_98,WIN_ME,WIN_XP
	{
		MsgBox, Windows 版本 (%A_OSVersion%) 不支持。Win 7 及以上系统才能正常使用。
		return
	}

	h_process := DllCall("OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid)
	if ( ErrorLevel or h_process = 0 )
		return

	name_size = 255
	VarSetCapacity(name, name_size)

	result := DllCall("psapi.dll\GetModuleFileNameEx", "uint", h_process, "uint", 0, "str", name, "uint", name_size)

	DllCall("CloseHandle", h_process)
	return, name
}

GetCommandLine2(pid)
{
	for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where ProcessId=" pid)
		Return sCmdLine := process.CommandLine
}

/* JSON module for AutoHotkey [requires v.1.1+, tested on v.1.1.13.01]
 * The parser is inspired by Douglas Crockford's(json.org) json_parse.js and
 * and Mike Samuel's json_sans_eval.js (https://code.google.com/p/json-sans-eval/).
 * I've combined the two implementation to create a fast(somehow:P) and validating
 * JSON parser. Some section(s) are based on VxE's JSON function(s) - 
 * [http://www.ahkscript.org/boards/viewtopic.php?f=6&t=30] - Thank you VxE
 */
class JSON
{
	parse(src, jsonize:=false) {
		;// Pre-validate JSON source before parsing
		if ((src:=Trim(src, " `t`n`r")) == "") ;// trim whitespace(s)
			throw Exception("Empty JSON source.")
		first := SubStr(src, 1, 1), last := SubStr(src, 0)
		if !InStr("{[""tfn0123456789-", first) ;// valid beginning chars
		|| !InStr("}]""el0123456789", last) ;// valid ending chars
		|| (first == "{" && last != "}") ;// if starts w/ '{' must end w/ '}'
		|| (first == "[" && last != "]") ;// if starts w/ '[' must end w/ ']'
		|| (first == """" && last != """") ;// if starts w/ '"' must end w/ '"'
		|| (first == "n" && last != "l") ;// assume 'null'
		|| (InStr("tf", first) && last != "e") ;// assume 'true' OR 'false'
		|| (InStr("-0123456789", first) && !InStr("0123456789", last)) ;// number
			throw Exception("Invalid JSON format.", -1)

		esc_char := {
		(Join
			"""": """",
			"/": "/",
			"b": "`b",
			"f": "`f",
			"n": "`n",
			"r": "`r",
			"t": "`t"
		)}
		/* This loop is based on VxE's JSON_ToObj.ahk - thank you VxE
		 * Quoted strings are extracted and temporarily stored in an object and
		 * later on re-inserted while the result object is being created.
		 */
		i := 0, strings := []
		while (i:=InStr(src, """",, i+1)) {
			j := i
			while (j:=InStr(src, """",, j+1)) {
				str := SubStr(src, i+1, j-i-1)
				StringReplace, str, str, \\, \u005C, A
				if (SubStr(str, 0) != "\")
					break
			}
			if !j
				throw Exception("Missing close quote(s).", -1)
			src := SubStr(src, 1, i) . SubStr(src, j+1)
			z := 0
			while (z:=InStr(str, "\",, z+1)) {
				ch := SubStr(str, z+1, 1)
				if InStr("""btnfr/", ch) ;// esc_char.HasKey(ch)
					str := SubStr(str, 1, z-1) . esc_char[ch] . SubStr(str, z+2)
				
				else if (ch = "u") {
					hex := "0x" . SubStr(str, z+2, 4)
					if !(A_IsUnicode || (Abs(hex) < 0x100))
						continue ;// throw Exception() ???
					str := SubStr(str, 1, z-1) . Chr(hex) . SubStr(str, z+6)
				
				} else throw Exception("Bad string")
			}
			strings.Insert(str)
		}
		;// Check for missing opening/closing brace(s)
		if InStr(src, "{") || InStr(src, "}") {
			StringReplace, dummy, src, {, {, UseErrorLevel
			c1 := ErrorLevel
			StringReplace, dummy, src, }, }, UseErrorLevel
			c2 := ErrorLevel
			if (c1 != c2)
				throw Exception("Missing " . Abs(c1-c2)
				. (c1 > c2 ? "clos" : "open") . "ing brace(s)", -1)
		}
		;// Check for missing opening/closing bracket(s)
		if InStr(src, "[") || InStr(src, "]") {
			StringReplace, dummy, src, [, [, UseErrorLevel
			c1 := ErrorLevel
			StringReplace, dummy, src, ], ], UseErrorLevel
			c2 := ErrorLevel
			if (c1 != c2)
				throw Exception("Missing " . Abs(c1-c2)
				. (c1 > c2 ? "clos" : "open") . "ing bracket(s)", -1)
		}
		/* Determine whether to subclass objects/arrays as JSON.object and
		 * JSON.array. User(s) can set this setting via the 'jsonize' parameter.
		 */
		if jsonize
			_object := this.object, _array := this.array
		else (_object := Object(), _array := Array())
		pos := 0
		, key := dummy := []
		, stack := [result := []]
		, assert := "" ;// "{[""tfn0123456789-"
		, null := ""
		;// Begin recursive descent
		while ((ch := SubStr(src, ++pos, 1)) != "") {
			;// skip whitespace
			while (ch != "" && InStr(" `t`n`r", ch))
				ch := SubStr(src, ++pos, 1)
			;// check if current char is expected or not
			if (assert != "") {
				if !InStr(assert, ch)
					throw Exception("Unexpected '" . ch . "'", -1)
				assert := ""
			}
			
			if InStr(":,", ch) { ;// colon(s) and comma(s)
				if (cont == result)
					throw Exception("Unexpected '" . ch . "' -> there is no "
					. "container object/array.")
				assert := """"
				if (ch == ":" || cont.base != _object)
					assert .= "{[tfn0123456789-"
			
			} else if InStr("{[", ch) { ; object|array - opening
				cont := stack[1]
				, sub := ch == "{" ? new _object : new _array
				, stack.Insert(1, cont[key == dummy ? Round(ObjMaxIndex(cont))+1 : key] := sub)
				, assert := (ch == "{" ? """}" : "]{[""tfn0123456789-")
				if (key != dummy)
					key := dummy
			
			} else if InStr("}]", ch) { ;// object|array - closing
				cont := stack.Remove(1)
				if !jsonize
					cont.base := ""
				cont := stack[1]
				, assert := (cont.base == _object) ? "}," : "],"
			
			} else if (ch == """") { ;// string
				str := strings.Remove(1), cont := stack[1]
				if (key == dummy) {
					if (cont.base == _object) {
						key := str, assert := ":"
						continue
					}
					;// _array or result | using 'else' seems faster, sometimes
					else key := Round(ObjMaxIndex(cont))+1
				}
				cont[key] := str
				, assert := (cont.base == _object ? "}," : "],")
				, key := dummy
			
			} else if (ch >= 0 && ch <= 9) || (ch == "-") { ;// number
				if !RegExMatch(src, "-?\d+(\.\d+)?((?i)E[-+]?\d+)?", num, pos)
					throw Exception("Bad number", -1)
				pos += StrLen(num)-1
				, cont := stack[1]
				, cont[key == dummy ? Round(ObjMaxIndex(cont))+1 : key] := num+0
				, assert := (cont.base == _object ? "}," : "],")
				if (key != dummy)
					key := dummy
			
			} else if InStr("tfn", ch, true) { ;// true|false|null
				/* ternary seems faster than using object ->
				 * val := {t:"true", f:"false", n:"null"}[ch]
				 */
				val := (ch == "t") ? "true" : (ch == "f") ? "false" : "null"
				;// case-sensitive comparison
				if !((tfn:=SubStr(src, pos, len:=StrLen(val))) == val)
					throw Exception("Expected '" val "' instead of '" tfn "'")
				pos += len-1
				/*
				;// advance to next char, first char has already been validated
				while (c:=SubStr(val, A_Index+1, 1)) {
					ch := SubStr(src, ++pos, 1)
					if !(ch == c) ;// case-sensitive comparison
						throw Exception("Expected '" c "' instead of " ch)
				}
				*/
				cont := stack[1]
				, cont[key == dummy ? Round(ObjMaxIndex(cont))+1 : key] := %val%
				, assert := (cont.base == _object ? "}," : "],")
				if (key != dummy)
					key := dummy
			
			}
		}
		return result[1]
	}
	/* Returns a string representation of an AHK object.
	 * The 'i' (indent) parameter allows 'pretty printing'. Specify any char(s)
	 * to use as indentation.
	 * Usage: JSON.stringify(object, "`t") ; use tab as indentation
	 *        JSON.stringify(object, "    ") ; 4-spaces indentation
	 *        JSON.stringify(object) ; no indentation
	 * Remarks:
	 * JSON.object and JSON.array instance(s) may call this method, automatically
	 * passing itself as the first parameter. If indententation is specified,
	 * nested arrays [] are in OTB-style.
	 * As per JSON spec, hex numbers are treated as strings - doing something
	 * like: 'JSON.stringify([0xffff])' will output '0xffff' as decimal. To
	 * output as string, wrap it in quotes: 'JSON.stringify(["0xffff"])'
	 * 0, 1 and ""(blank) are output as false, true and null respectively.
 	 */
	stringify(obj:="", indent:="", lvl:=1) {
		if IsObject(obj) {
			if (ComObjValue(x) != "") ;// COM Object
			|| IsFunc(obj)            ;// Func object
				throw Exception("Unsupported object type")
			for k in obj
				arr := (k == A_Index)
			until !arr

			n := indent ? "`n" : (i := indent := "")
			Loop, % indent ? lvl : 0
				i .= indent

			lvl += 1, str := "" ;// make #Warn happy
			for k, v in obj {
				if IsObject(k) || (k == "")
					throw Exception("Invalid key.", -1)
				if !arr
					;// integer key(s) are automatically wrapped in quotes
					key := k+0 == k ? """" . k . """" : JSON.stringify(k)
				val := JSON.stringify(v, indent, lvl)
				;// format output
				str .= (arr ? "" : key . ":" . (indent
				? (IsObject(v) && InStr(val, "{") == 1 && val != "{}")
				  ? n . i
				  : " "
				: "")) . val . "," . (indent ? n . i : "")
			}
			;// trim and pad
			if (str != "") {
				str := Trim(str, ",`n`t ")
				if indent
					str := n . i . str . n . SubStr(i, StrLen(indent)+1)
			}
			return arr ? "[" str "]" : "{" str "}"
		}
		;// null
		else if (obj == "")
			return "null"
		;// true|false
		else if (obj == "0" || obj == "1") ;// compare as string to bypass float
			return obj ? "true" : "false"
		;// string
		else if [obj].GetCapacity(1) {
			if obj is float
				return obj

			esc_char := {
			(Join
			    """": "\""",
			    "/": "\/",
			    "`b": "\b",
			    "`f": "\f",
			    "`n": "\n",
			    "`r": "\r",
			    "`t": "\t"
			)}
			
			StringReplace, obj, obj, \, \\, A
			for k, v in esc_char
				StringReplace, obj, obj, % k, % v, A

/* ; FoxMod
			while RegExMatch(obj, "[^\x20-\x7e]", ch) {
				ustr := Asc(ch), esc_ch := "\u", n := 12
				while (n >= 0)
					esc_ch .= Chr((x:=(ustr>>n) & 15) + (x<10 ? 48 : 55))
					, n -= 4
				StringReplace, obj, obj, % ch, % esc_ch, A
			}
*/ ; FoxMod
			return """" . obj . """"
		}
		;// number
		if obj is xdigit
			if obj is not digit
				obj := """" . obj . """"
		
		return obj
	}
	/* Base object for objects {} created during parsing. The user may also manually
	 * create an insatnce of this class. The sole purpose of wrapping objects {} as
	 * JSON.object instance is to allow enumeration of key-value pairs in the order
	 * they were created. The len() method may be used to get the total count of
	 * key-value pairs.
	 * Usage: Instances are automatically created during parsing. The user may
	 *        use the 'new' operator to create a JSON.object object manually.
	 * --start-of-code--
	 * obj := new JSON.object("key1", "value1", "key2", "value2")
	 * obj["key3"] := "Add a new key-value pair"
	 * MsgBox, % obj.stringify() ; display as string
	 * ; '{"key1": "value1", "key2": "value2", "key3": "Add a new key-value pair"}'
	 * --end-of-code--
	 */
	class object
	{
		
		__New(p*) {
			ObjInsert(this, "_", [])
			if Mod(p.MaxIndex(), 2)
				p.Insert("")
			Loop, % p.MaxIndex()//2
				this[p[A_Index*2-1]] := p[A_Index*2]
		}

		__Set(k, v, p*) {
			this._.Insert(k)
		}

		_NewEnum() {
			return new JSON.object.Enum(this)
		}

		Insert(k, v) {
			return this[k] := v
		}

		Remove(k*) {
			ascs := A_StringCaseSense
			StringCaseSense, Off
			if (k.MaxIndex() > 1) {
				k1 := k[1], k2 := k[2], is_int := false
				if (Abs(k1) != "" && Abs(k2) != "")
					k1 := Round(k1), k2 := Round(k2), is_int := true
				while true {
					for each, key in this._
						i := each
					until found:=(key >= k1 && key <= k2)
					if !found
						break
					key := this._.Remove(i)
					ObjRemove(this, (is_int ? [key, ""] : [key])*)
					res := A_Index
				}

			} else for each, key in this._ {
				if (key = (k.MaxIndex() ? k[1] : ObjMaxIndex(this))) {
					key := this._.Remove(each)
					res := ObjRemove(this, (Abs(key) != "" ? [key, ""] : [key])*)
					break
				}
			}
			StringCaseSense, % ascs
			return res
		}

		len() {
			return Round(this._.MaxIndex())
		}

		stringify(i:="") {
			return JSON.stringify(this, i)
		}

		class Enum
		{

			__New(obj) {
				this.obj := obj
				this.enum := obj._._NewEnum()
			}
			; Lexikos' ordered array workaround
			Next(ByRef k, ByRef v:="") {
				if (r:=this.enum.Next(i, k))
					v := this.obj[k]
				return r
			}
		}
	}
	/* Base object for arrays [] created during parsing.
	 * Same as JSON.object above.
	 */	
	class array
	{
			
		__New(p*) {
			for k, v in p
				this.Insert(v)
		}

		stringify(i:="") {
			return JSON.stringify(this, i)
		}
	}
}
