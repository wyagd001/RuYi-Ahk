;|2.0|2023.07.01|1316
CandySel :=  A_Args[1]
;CandySel := "C:\Documents and Settings\Administrator\Desktop\Gui"
Gui, Add, Text, x10 y15 h25, 查找文件夹:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vsfolder, % CandySel
Gui, Add, Button, xp+560 yp-2 w60 h30 gstartsearch, 开始查找
Gui, Add, Text, x10 yp+40 h25, 指定扩展名:
Gui, Add, Edit, xp+80 yp-5 w550 h25 vsExt, % "txt,ahk,md"
Gui, Add, Button, xp+560 yp w60 h30 grunzhuanma, 执行转码
gui, add, Text, x10 yp+40 w60 vmyparam1, 输出编码:
gui, add, ComboBox, xp+80 yp w550 vOut_Code, UTF-8(带BOM)||UTF-8|Unicode(UTF-16)|ANSI
Gui, Add, ListView, x10 yp+40 w700 h500 vfilelist Checked hwndHLV AltSubmit, 文件名|相对路径|扩展名|文件编码|大小(KB)|修改日期|完整路径
Gui, Add, Button, xp yp+510 w60 h30 guncheckall, 全不选
Gui, Add, Button, xp+70 yp w60 h30 gEditfilefromlist, 编辑文件
Gui, Add, Button, xp+70 yp w60 h30 gopenfilefromlist, 打开文件
Gui, Add, Button, xp+70 yp w60 h30 gopenfilepfromlist, 打开路径

gui, Show,, 列出文件夹中文本文件的编码

if FileExist(CandySel)
	gosub startsearch
Return

startsearch:
gui, Submit, NoHide
ToolTip, % "正在遍历文本文件编码类型, 请稍候..."
LV_Delete()
Loop, Files, %sfolder%\*.*, FR
{
	if A_LoopFileSize = 0
		continue
	if sExt
	{
		if A_LoopFileExt not in %sExt%
			continue
	}
	LV_Add("", A_LoopFileName, StrReplace(StrReplace(A_LoopFilePath, sfolder), A_LoopFileName), A_LoopFileExt, File_GetEncoding(A_LoopFileFullPath), A_LoopFileSizeKB+1, A_LoopFileTimeModified, A_LoopFilePath)
}
;msgbox % "文件遍历完成. 用时: " A_TickCount - st
ToolTip

LV_ModifyCol()
LV_ModifyCol(1, 200)
LV_ModifyCol(2, 250)
LV_ModifyCol(3, 60)
LV_ModifyCol(5, 75)

;FileAppend, % Array_ToString(folderobj) , %A_desktop%\123.txt
return

uncheckall:
LV_Modify(0, "-check")
return

Editfilefromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 7)
}
run notepad  %Tmp_file%
return

openfilefromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 7)
}
run %Tmp_file%
return

openfilepfromlist:
RF := LV_GetNext("F")
if RF
{
	LV_GetText(Tmp_file, RF, 7)
}
SplitPath, Tmp_file,, OutDir
Run, %OutDir%
;Run, explorer.exe /select`, %Tmp_file%
return

runzhuanma:
gui, Submit, NoHide

RowNumber := 0  ; 这样使得首次循环从列表的顶部开始搜索.
Loop
{
	RowNumber := LV_GetNext(RowNumber, "C")  ; 在前一次找到的位置后继续搜索.
	if not RowNumber  ; 上面返回零, 所以选择的行已经都找到了.
		break
	LV_GetText(Tmp_Path, RowNumber, 7)
	LV_GetText(Tmp_CPcode, RowNumber, 4)

	if (Tmp_CPcode != out_code)
		File_CpTransform(Tmp_Path, Tmp_CPcode, out_code, 0)
}
Return

GuiClose:
Guiescape:
Gui Destroy
Gui, GuiText: Destroy
exitapp
Return

GuiText(Gtext, Title:="", w:=300, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	Return
}

CF_ToolTip(tipText, delay := 1000)
{
	ToolTip
	ToolTip, % tipText
	SetTimer, RemoveToolTip, % "-" delay
return

RemoveToolTip:
	ToolTip
return
}

/*!
	函数: File_GetEncoding
		类似 chardet Py库, 检测文件的代码页.

	参数:
		aFile - 要分析的外部文件路径.

	备注:
			> 注意:
			> ANSI 文档为全英文时, 默认返回 UTF-8.

	返回值:
		字符串
		0      - 错误, 文件不存在
		CPnnn  - ANSI (CPnnn), 必须带有中文字符串, 才能和 UTF-8 无签名 区分开.
		UTF-16 - text Utf-16 LE File
		CP1201 - text Utf-16 BE File
		UTF-32 - text Utf-32 BE/LE File
		UTF-8  - text Utf-8 File (UTF-8 + BOM). 检验的文件太小, 不足以检查时, 默认返回 UTF-8.
		UTF-8-RAW  - UTF-8 无签名. 
		对于 UTF-8-RAW 的说明：
		1.文件小于100kb 读取整个文件, 必须带有中文字符串(文件中存在乱码（特殊字符）时可能得到错误的结果), 才能和 CP936 区分开.
		2.文件大于100kb 读取文件前 100kb 的内容。
*/

; isBinFile
; https://www.autohotkey.com/boards/viewtopic.php?f=76&t=144&start=20

/*
; 示例
Loop, Files, *.txt
msgbox % A_LoopFileName " - " File_GetEncoding(A_LoopFileLongPath)
*/

File_GetEncoding(aFile, aNumBytes = 0, aMinimum = 4)
{
	if !FileExist(aFile) or InStr(FileExist(aFile), "D")
		return 0

	_rawBytes := ""
	_hFile := FileOpen(aFile, "r")
	; force position to 0 (zero)
	_hFile.Position := 0
	; 文件小于100k, 则读取整个文件
	_nBytes := (_hFile.length < 102400) ? (_hFile.RawRead(_rawBytes, _hFile.length)) : (aNumBytes = 0) ? (_hFile.RawRead(_rawBytes, 102402)) : (_hFile.RawRead(_rawBytes, aNumBytes))
	_hFile.Close()

	; Initialize vars
	_t := 0, _i := 0, _bytesArr := []

	loop % _nBytes ; create c-style _bytesArr array
		_bytesArr[(A_Index - 1)] := Numget(&_rawBytes, (A_Index - 1), "UChar")

	; determine BOM if possible/existant
	if ((_bytesArr[0] = 0xFE) && (_bytesArr[1] = 0xFF))
	{
		; text Utf-16 BE File
		return "CP1201"
	}
	if ((_bytesArr[0] = 0xFF) && (_bytesArr[1] = 0xFE))
	{
		; text Utf-16 LE File
		return "UTF-16"
	}
	if ((_bytesArr[0] = 0xEF) && (_bytesArr[1] = 0xBB) && (_bytesArr[2] = 0xBF))
	{
		; text Utf-8 File
		return "UTF-8"
	}
	if ((_bytesArr[0] = 0x00) && (_bytesArr[1] = 0x00) && (_bytesArr[2] = 0xFE) && (_bytesArr[3] = 0xFF))
	|| ((_bytesArr[0] = 0xFF) && (_bytesArr[1] = 0xFE) && (_bytesArr[2]= 0x00) && (_bytesArr[3] = x00))
	{
		; text Utf-32 BE/LE File
		return "UTF-32"
	}
	; 为了 unicode 检测, 推荐 aMinimum 为 4  (4个字节以下的文件无法判断类型)
	if (_nBytes < aMinimum)
	{
		; 如果文本太短，返回编码"UTF-8"
		return "UTF-8"
	}

	while(_i < _nBytes)
	{
		; // ASCII
		if (_bytesArr[_i] == 0x09)
		|| (_bytesArr[_i] == 0x0A)
		|| (_bytesArr[_i] == 0x0D)
		|| ((0x20 <= _bytesArr[_i]) && (_bytesArr[_i] <= 0x7E))
		{
			_i += 1
			continue
		}

		; // non-overlong 2-byte
		if (0xC2 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xDF)
		&& (0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF)
		{
			_i += 2
			if (_i + 1 > 102400) or (_i + 2 > 102400)
				break
			else
				continue
		}

		; // excluding overlongs, straight 3-byte, excluding surrogates
		if (((_bytesArr[_i] == 0xE0)
		&& ((0xA0 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF)))
		|| ((((0xE1 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xEC))
		|| (_bytesArr[_i] == 0xEE)
		|| (_bytesArr[_i] == 0xEF))
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF)))
		|| ((_bytesArr[_i] == 0xED)
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0x9F))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))))
		{
			_i += 3
			if (_i + 1 > 102400) or (_i + 2 > 102400) or (_i + 3 > 102400)
				break
			else
				continue
		}

		; // planes 1-3, planes 4-15, plane 16
		if (((_bytesArr[_i] == 0xF0)
		&& ((0x90 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
			&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF)))
		|| (((0xF1 <= _bytesArr[_i])
		&& (_bytesArr[_i] <= 0xF3))
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF)))
		|| ((_bytesArr[_i] == 0xF4)
		&& ((0x80 <= _bytesArr[_i + 1])
		&& (_bytesArr[_i + 1] <= 0x8F))
		&& ((0x80 <= _bytesArr[_i + 2])
		&& (_bytesArr[_i + 2] <= 0xBF))
		&& ((0x80 <= _bytesArr[_i + 3])
		&& (_bytesArr[_i + 3] <= 0xBF))))
		{
			_i += 4
			continue
		}
		_t := 1
		break
	}

	; while 循环没有失败，然后确认为utf-8
	if (_t = 0)
	{
		return "UTF-8-RAW"
	}

	; 如果通过以上判断没有获取到文件编码
	; 通过检测文件是否含有不可见字符来简单判断是否为exe类型的二进制文件
/*
	loop, %_nBytes%
	{
		if ((_bytesArr[(A_Index - 1)] > 0) && (_bytesArr[(A_Index - 1)] < 9))
		|| ((_bytesArr[(A_Index - 1)] > 13) && (_bytesArr[(A_Index - 1)] < 20))
		{
			return 1
		}
	}
*/

	changyongzi := ["的", "一", "是", "了", "不", "在", "有", "个", "人", "这", "上", "中", "大", "为", "来", "我", "到", "出", "要", "以", "时", "和", "地", "们", "得", "可", "下", "对", "生", "也", "子", "就", "过", "能", "他", "会", "多", "发", "说", "而", "于", "自", "之", "用", "年", "行", "家", "方", "后", "作", "成", "开", "面", "事", "好", "小", "心", "前", "所", "道", "法", "如", "进", "着", "同", "经", "分", "定", "都", "然", "与", "本", "还", "其", "当", "起", "动", "已", "两", "点", "从", "问", "里", "主", "实", "天", "高", "去", "现", "长", "此", "三", "将", "无", "国", "全", "文", "理", "明", "日"]
	readstr := StrGet(&_rawBytes, _nBytes, "CP65001")
	changyongzi_jishu := 0
	for k,v in changyongzi
	{
		if InStr(readstr, v)
			changyongzi_jishu := changyongzi_jishu + 1
		if (changyongzi_jishu > 5)
		{
			return "UTF-8-Raw"
		}
	}

	readstr := StrGet(&_rawBytes, _nBytes, "CP936")
	changyongzi_jishu := 0
	for k,v in changyongzi
	{
		if InStr(readstr, v)
		{
			changyongzi_jishu := changyongzi_jishu + 1
		}
		if (changyongzi_jishu > 5)
		{
			return "CP936"
		}
	}

	changyongzi2 :=["的", "一", "是", "了", "不", "在", "有", "個", "人", "這", "上", "中", "大", "為", "來", "我", "到", "出", "要", "以", "時", "和", "地", "們", "得", "可", "下", "對", "生", "也", "子", "就", "過", "能", "他", "會", "多", "發", "說", "而", "于", "自", "之", "用", "年", "行", "家", "方", "后", "作", "成", "開", "面", "事", "好", "小", "心", "前", "所", "道", "法", "如", "進", "著", "同", "經", "分", "定", "都", "然", "與", "本", "還", "其", "當", "起", "動", "已", "兩", "點", "從", "問", "里", "主", "實", "天", "高", "去", "現", "長", "此", "三", "將", "無", "國", "全", "文", "理", "明", "日"]
	readstr := StrGet(&_rawBytes, _nBytes, "CP950")
	changyongzi_jishu := 0
	for k,v in changyongzi
	{
		if InStr(readstr, v)
			changyongzi_jishu := changyongzi_jishu + 1
		if (changyongzi_jishu > 5)
		{
			return "CP950"
		}
	}

	; 未符合上面条件的返回系统默认 ansi 内码
	; 简体中文系统默认返回的是 CP936, 非中文系统的内码显示中文会乱码,如果要显示中文可直接改为"CP936"
	return "CP" DllCall("GetACP")  
}

File_CpTransform(aInFile, aInCp := "", aOutCp := "", aOutNewFile := 1)
{
	if (aInCp = "CP1201")
	{
		_hFile := FileOpen(aInFile, "r")
		_hFile.Position := 2
		aInLen := _hFile.length - 2
		_hFile.RawRead(FileR_TFRaw, aInLen)
		_hFile.Close()
		;msgbox % aInLen
	}
	else
	{
		FileEncoding, % aInCp
		FileRead, FileR_TFC, %aInFile%
		FileEncoding
	}

	aSysCp := "CP" DllCall("GetACP")
	if !aOutCp or (aOutCp = "ansi")
		aOutCp := aSysCp

	SplitPath, % aInFile, , aOutDir, OutExtension, OutNameNoExt
	if aOutNewFile
	{
		aOutFile := aOutDir "\" OutNameNoExt "(" aInCp "转码" aOutCp ")." OutExtension
		aOutFile := PathU(aOutFile)
	}
	else
	{
		FileRecycle, %aInFile%
		aOutFile := aInFile
	}

	if (aOutCp != "CP1201")
	{
		if (aInCp = "CP1201")
		{
			LCMAP_BYTEREV := 0x800   ; 高低位转换
			cch := DllCall("LCMapStringW", "UInt", 0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFRaw, "UInt", -1, "Str", 0, "UInt", 0)
			;msgbox % cch  ; 长度与文件的实际长度 不一致
			VarSetCapacity(LE, cch * 2)
			DllCall("LCMapStringW", "UInt",0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFRaw, "UInt", cch, "Str", LE, "UInt",  cch)
			;msgbox % LE
			StrLE := StrGet(&LE, aInLen / 2)   ; 移除掉多余的长度的乱码
			;msgbox % StrLE
			FileAppend, %StrLE%, % aOutFile, % aOutCp
			FileR_TFRaw := StrLE := LE := ""
			return
		}
		else
		{
			FileAppend, %FileR_TFC%, % aOutFile, % aOutCp
			FileR_TFC := ""
			return
		}
	}
	else if (aOutCp = "CP1201")
	{
		if (aInCp = "CP1201")
		{
			_hFile := FileOpen(aOutFile, "w")
			MCode(code, "FEFF")
			_hFile.RawWrite(code, 2)
			_hFile.RawWrite(FileR_TFRaw, aInLen)
			FileR_TFRaw := ""
			return
		}
		else
		{
			LCMAP_BYTEREV := 0x800
			cch:=DllCall("LCMapStringW", "UInt",0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFC, "UInt", -1, "Str", 0, "UInt", 0)
			VarSetCapacity(BE, cch * 2)
			DllCall("LCMapStringW", "UInt", 0, "UInt", LCMAP_BYTEREV, "Str", FileR_TFC, "UInt", cch, "Str", BE, "UInt", cch)
			_hFile := FileOpen(aOutFile, "w")
			MCode(code, "FEFF")
			_hFile.RawWrite(code, 2)
			_hFile.RawWrite(BE, cch * 2-2)
			FileR_TFC := BE := ""
			return
		}
	}
}

MCode(ByRef code, hex) 
{ ; allocate memory and write Machine Code there
	VarSetCapacity(code, 0) 
	VarSetCapacity(code, StrLen(hex)//2+2)
	Loop % StrLen(hex)//2 + 2
		NumPut("0x" . SubStr(hex, 2*A_Index-1, 2), code, A_Index-1, "Char")
}

PathU(sFile) {                     ; PathU v0.90 by SKAN on D35E/D35F @ tiny.cc/pathu 
Local Q, F := VarSetCapacity(Q,520,0) 
  DllCall("kernel32\GetFullPathNameW", "WStr",sFile, "UInt",260, "Str",Q, "PtrP",F)
  DllCall("shell32\PathYetAnotherMakeUniqueName","Str",Q, "Str",Q, "Ptr",0, "Ptr",F)
Return A_IsUnicode ? Q : StrGet(&Q, "UTF-16")
}

