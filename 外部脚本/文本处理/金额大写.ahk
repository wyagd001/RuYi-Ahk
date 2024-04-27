;|2.6|2024.04.25|1577
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=28&t=108312
CandySel := A_Args[1]
GuiText(金额中阿互转(CandySel), CandySel,, 5)
return

GuiText(Gtext, Title:="", w:=400, l:=20)
{
	global myedit, TextGuiHwnd
	Gui,GuiText: Destroy
	Gui,GuiText: Default
	Gui, +HwndTextGuiHwnd
	gui, font, s18
	Gui, Add, Edit, Multi readonly w%w% r%l% vmyedit
	GuiControl,, myedit, %Gtext%
	gui, Show, AutoSize, % Title
	return

	GuiTextGuiClose:
	GuiTextGuiescape:
	Gui, GuiText: Destroy
	ExitApp
	Return
}

金额中阿互转(InputStr, To:="z") ; To: 中|阿
{
	; 作者：sikongshan
	; 更新日期：2022年09月14日
	; 改进 ：中文转阿拉伯部分，将小数点部分浮点运算改成整数运算，不再有精度问题
	; 限制 ：数值转中文部分，因为不涉及到大数值计算，可以到20位或者更高，但是中文转回阿拉伯的时候，超过17位数值则会有问题（受限于ahk计算），下次考虑拼接方式避免
	InputStr:=trim(InputStr)
	if (RegExMatch(InputStr,"^[\.\d]+$") and  instr(To,"z"))
	{
		arrNum:=StrSplit(InputStr,".")
		IP:=arrNum[1]
		DP:=arrNum[2]
		if(strlen(IP)>17) ;设定20位，
			return InputStr
		OutputStr:=""
		数字转换:={0 : "零",1 : "壹",2 : "贰",3 : "叁",4 : "肆",5 : "伍",6 : "陆",7 : "柒",8 : "捌",9 : "玖"}
		小数单位:={1 : "角",2 : "分",3 : "毫",4 :"厘"}
		整数单位:={1 : "元",2 : "拾",3 : "佰",4 : "仟",5 : "万",6 : "拾",7 : "佰",8 : "仟",9 : "亿",10:"拾",11:"佰",12:"仟",13:"兆",14:"拾",15:"佰",16:"仟",17:"万",18 : "拾",19 : "佰",20 : "仟"}
		DllCall("msvcrt.dll\_wcsrev", "Ptr", &IP, "CDECL")
		Loop,parse,% IP
		OutputStr := 数字转换[A_LoopField] 整数单位[A_index] OutputStr
		loop,3
		{
			OutputStr:=RegExReplace(OutputStr,"零(拾|佰|仟)","零")
			OutputStr:=RegExReplace(OutputStr,"零{1,3}","零")
			OutputStr:=RegExReplace(OutputStr,"零(?=(兆|亿|万|元))","")
			OutputStr:=RegExReplace(OutputStr,"亿零万","亿")
			OutputStr:=RegExReplace(OutputStr,"兆零亿","兆")
		}
		if(DP)
		{
			OutputStr .="零"
			loop,parse,% DP
			{
				if(A_index>5)
				break
				if(A_loopfield=0)
				continue
				OutputStr .= 数字转换[A_LoopField] 小数单位[A_Index]
			}
		}
		else
		{
			OutputStr .= "整"
		}
		return OutputStr
	}
	else if (regexmatch(InputStr,"^[角分毫厘零一二两三四五六七八九十百千万亿兆壹贰叁肆伍陆柒捌玖拾佰仟元整]+$") and  instr(To,"a"))
	{
		InputStr:=StrReplace(InputStr,"整")
		arrStr:=StrSplit(InputStr,"元")
		IP:=arrStr[1]
		DP:=arrStr[2]
		DllCall("msvcrt.dll\_wcsrev", "Ptr", &IP, "CDECL") ;先反转
		中文转换:={角:1000,分:100,毫:10,厘:1,零:0, 一:1, 二:2, 两:2, 三:3, 四:4, 五:5, 六:6, 七:7, 八:8, 九:9, 十:10, 百:100, 千:1000, 万:10000, 亿:100000000, 兆:1000000000000,壹:1, 贰:2, 两:2, 叁:3, 肆:4, 伍:5, 陆:6, 柒:7, 捌:8, 玖:9, 拾:10, 佰:100, 仟:1000}
		num:=0
		x:=1
		old:=1
		loop,parse,IP  ;经过前面的反转，相当于从后面逐字parse
		{
			v:=中文转换[A_LoopField]   ;获取对应的数字，或者倍数
			if (v>=10 and v>old)  ;如果是倍数，且该倍数是上升的，就用这个倍数，基准值同时改变。
			old:=x:=v
			else if (v>=10 and v<old) ;如果是倍数，且该倍数突然跌落，则倍数累乘，且基准仍为之前较大的那个。
			x:=v*old
			else  ;当前字符不是倍数的话，累加
			num:=num+x*v
		}
		if(DP)
		{
			小数部分:=""
			前置数值:=0
			loop,parse,DP
			{
				v:=中文转换[A_LoopField]   ;获取对应的数字，或者倍数
				if (A_loopfield~="角|分|毫|厘")
				{
					小数部分+=前置数值 * v
					前置数值:=0
				}
				else
					前置数值:=v
			}
			num:=num "`." 小数部分
		}
		return num
	}
	else
		return InputStr
}
