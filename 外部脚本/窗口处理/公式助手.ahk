;|2.6|2024.05.15|1598
Gui, Add, Text, x10 y10 w60, 类型:
Gui, Add, ComboBox, xp+70 yp w250 vFormulaTypeIndex gshowNameIndex AltSubmit, 常用||身份证|时间|重复|常规运算
Gui, Add, Text, x10 yp+30 w60, 名称:
Gui, Add, ComboBox, xp+70 yp w250 vFormulaNameIndex gshowFormula AltSubmit, 
Gui, Add, Text, x10 yp+30 w60, 单元格:
Gui, Add, Edit, xp+70 yp w250 vReplacedCell,
Gui, Add, Button, xp+260 yp w60 gReplaceCell, 替换A1
Gui, Add, Text, x10 yp+30 w60, 区域:
Gui, Add, Edit, xp+70 yp w250 vSearchRange,
Gui, Add, Edit, x10 yp+30 w390 r8 vFormulaEdit,
Gui, Add, StatusBar,, 
Gui, Show, AutoSize, 公式助手

CY_ItemsStr := "1. 条件求和|2. 日期条件求和|3. 乘积求和|4. 单条件乘积求和|5. 多条件乘积求和|6. 多条件判断(多条件都为真结果才为真)|7. 多条件判断(多条件有一个为真结果就为真)|8. 验证银行卡"
CY_Arr := ["=SUMIF(A1:A10,""支付宝"",B1:B10)"
, "=SUMIF(A1:A10,53257,B1:B10)"
, "=SUMPRODUCT(A1:A10,B1:B10)"
, "=SUMPRODUCT((A1:A10=""条件1"")*(B1:B10)*(C1:C10))"
, "=SUMPRODUCT((A1:A10=""条件1"")*(B1:B10=""条件2"")*(C1:C10)*(D1:D10))"
, "=IF(AND(A1=""技术部"",B1>90),900,0)"
, "=IF(OR(A1=""技术部"",B1>90),900,0)"
, "=MOD(SUMPRODUCT(LEFT((0&MID(A1,ROW(INDIRECT(""1:""&LEN(A1))),1))*2^MOD(ROW(INDIRECT(""1:""&LEN(A1)))+MOD(LEN(A1),2),2),1)+(0&MID((0&MID(A1,ROW(INDIRECT(""1:""&LEN(A1))),1))*2^MOD(ROW(INDIRECT(""1:""&LEN(A1)))+MOD(LEN(A1),2),2),2,1))),10)=0"]

SFZ_ItemsStr := "1. 身份证提取生日|2. 身份证提取生日2|3. 计算年龄|4. 计算年龄2|5. 计算年龄3|6. 提取男女|7. 是否重复|8. 验证是否有效|9. 变18位身份证*|10.计算退休日期"
SFZ_Arr := ["=MID(A1,7,4)&""/""&MID(A1,11,2)&""/""&MID(A1,13,2)"
, "=--TEXT(MID(A1,7,8),""0000-00-00"")"
, "=(TODAY()-A1)/365"
, "=IF(B1,YEAR(B1)-YEAR(A1),YEAR(TODAY())-YEAR(A1))"
, "=DATEDIF(TEXT(MID(A1,7,8),""0-00-00""),TODAY(),""y"")"
, "=IF(MOD(MID(A1,17,1),2)=1,""男"",""女"")"
, "=IF(COUNTIF(A$1:A$10,A1&""*"")>1,""有重复"","""")"
, "=IF(LEN(A1)<>18,""位数错误"",IF(MOD(SUMPRODUCT(MID(A1,ROW($1:$17),1)*2^(18-ROW($1:$17)))+IFERROR(--RIGHT(A1),10),11)<>1,""号码异常"",IF(ISERROR(--TEXT(MID(A1,7,8),""0-00-00"")),""日期错误"",IF(--TEXT(MID(A1,7,8),""0-00-00"")>TODAY(),""尚未生效"",""有效""))))"
, "=IF(LEN(A1)=15,REPLACE(A1,7,,19)&MID(""10X98765432"",MOD(SUMPRODUCT(MID(REPLACE(A1,7,,19),ROW($1:$17),1)*2^(18-ROW($1:$17))),11)+1,1),IF(LEN(A1)=16,REPLACE(A1,7,,19),IF(LEN(A1)=17,A1&MID(""10X98765432"",MOD(SUMPRODUCT(MID(A1,ROW($1:$17),1)*2^(18-ROW($1:$17))),11)+1,1),IF(LEN(A1)=18,A1,""错误""))))"
, "=EDATE(TEXT(MID(A1,7,8),""0!/00!/00""),MOD(MID(A1,15,3),2)*120+600)"]

SJ_ItemsStr := "1. 判断季度|2. 距离合同到期还剩多少天|3. 生肖|4. 将距1900/1/1的天数转为日期|5. 天数转为日期2|6. 日期转为距1900/1/1的天数|7. 计算退休日期|8. 计算退休日期|9. 计算日期是一年中的第几周|10.计算是一年中的第几天|11.计算本月的最后一天的日期|11.计算本月的第一天的日期"
SJ_Arr := ["=LEN(2^MONTH(A1))&""季度"""
, "=DATEDIF(TODAY(),A1,""D"")"
, "=MID(""猴鸡狗猪鼠牛虎兔龙蛇马羊"",MOD(Year(A1),12)+1,1)"
, "=TEXT(YEAR(A1)&""-""&MONTH(A1)&""-""&DAY(A1),""yyyy-MM-dd"")"
, "=DATE(YEAR(A1)，MONTH(A1)，DAY(A1))"
, "=VALUE(A1)"
, "=IF(B1=""男"",A1+21915,A1+20089)"
, "=IF(B1=""男"",DATE(YEAR(A1)+60,MONTH(A1),DAY(A1)),DATE(YEAR(A1)+55,MONTH(A1),DAY(A1)))"
, "=WEEKNUM(A1,2)"
, "=A1-DATE(YEAR(A1),1,1)+1"
, "=EOMONTH(A1,0)"
, "=EOMONTH(A1,-1)+1"]

CF_ItemsStr := "1. 是否有重复(满足条件的单元格计数)|2. 重复项目计数(满足多条件的单元格计数)|3. 提取唯一值(重复的只提取一次)|4. 提取唯一值(重复的不提取)|5. 是否有重复(重复内容首次出现时不提示)|6. 列查找提取同行中的列数据|7. 反向列查找|8. 非空单元格计数(包含隐藏单元格)|9. 非空单元格计数(不包含隐藏单元格)|10.非空单元格计数|11.空单元格计数"
CF_Arr := ["=IF(COUNTIF(A$1:A$10,A1)>1,""有重复"",""无重复"")"
, "=COUNTIFS(A$1:A$10,A1,B$1:B$10,B1)"
, "=UNIQUE(A1:A10)"
, "=UNIQUE(A1:A10,,1)"
, "=IF(COUNTIF(A$1:A$10,A1)>1,""有重复"","""")"
, "=IFNA(VLOOKUP(A1,'[文件名.xlsx]Sheet1'!B1:B10,3,0),"""")"
, "=VLOOKUP(A1,IF({1,0},$B$1:$B$10,$A$1:$A$2),2,0)"
, "=SUBTOTAL(3,$A$2:A2)"
, "=SUBTOTAL(103,$A$2:A2)"
, "=COUNTA(A$2:A2)"
, "=COUNTBLANK(A$2:A2)"]

CGYS_ItemsStr := "1. 求和|2. 平均值|3. 取整|4. 绝对值|5. 四舍五入|6. |7. |8. ()|9. ()|10.|11."
CGYS_Arr := ["=SUM(A$1:A$10)"
, "=Average(A1:A10)"
, "=Int(A1)"
, "=ABS(A1)"
, "=Round(A1)"
, "="
, "="
, "="
, "="
, "="]


kind := "常用"  ; 常用|身份证|时间|重复|常规运算
GuiControl,, FormulaNameIndex, % CY_ItemsStr
return

ReplaceCell:
Gui Submit, NoHide
Tmp_Str := StrReplace(FormulaEdit, "A1", ReplacedCell)
GuiControl,, FormulaEdit, % Tmp_Str
return

showNameIndex:
Gui Submit, NoHide
FormulaType_Arr :=["常用", "身份证", "时间", "重复", "常规运算"]
kind := FormulaType_Arr[FormulaTypeIndex]
if (kind = "常用")
	GuiControl,, FormulaNameIndex, % "|" CY_ItemsStr
else if (kind = "身份证")
	GuiControl,, FormulaNameIndex, % "|" SFZ_ItemsStr
else if (kind = "时间")
	GuiControl,, FormulaNameIndex, % "|" SJ_ItemsStr
else if (kind = "重复")
	GuiControl,, FormulaNameIndex, % "|" CF_ItemsStr
else if (kind = "常规运算")
	GuiControl,, FormulaNameIndex, % "|" CGYS_ItemsStr
return

showFormula:
Gui Submit, NoHide
;tooltip % kind
if (kind = "常用")
	FormulaStr := CY_Arr[FormulaNameIndex]
else if (kind = "身份证")
	FormulaStr := SFZ_Arr[FormulaNameIndex]
else if (kind = "时间")
	FormulaStr := SJ_Arr[FormulaNameIndex]
else if (kind = "重复")
	FormulaStr := CF_Arr[FormulaNameIndex]
else if (kind = "常规运算")
	FormulaStr := CGYS_Arr[FormulaNameIndex]

GuiControl,, FormulaEdit, % FormulaStr
if Instr(FormulaStr, "COUNTIFS")
	SB_SetText("COUNTIFS(数据区域1,条件1,数据区域2,条件2...")
else if Instr(FormulaStr, "COUNTIF")
	SB_SetText("COUNTIF(数据区域,条件)")
else if Instr(FormulaStr, "VLOOKUP")
	SB_SetText("VLOOKUP(查找值,数据区域,查找列数,精确匹配或者近似匹配）")
else if Instr(FormulaStr, "UNIQUE")
	SB_SetText("UNIQUE(数据区域,[去重方向:=0(默认竖直)],[是否仅返回没有重复的项:=0])")
else if Instr(FormulaStr, "DATEDIF")
	SB_SetText("DATEDIF(开始日期,结束日期,日期相差单位)")
else if Instr(FormulaStr, "TEXT")
	SB_SetText("TEXT(值,字符串格式)")
else if Instr(FormulaStr, "SUMIFS")
	SB_SetText("SUMIFS(求和区域,条件区域1,条件1,条件区域2,条件2...）")
else if Instr(FormulaStr, "SUMIF")
	SB_SetText("SUMIF(条件区域,条件,求和区域）")
else if Instr(FormulaStr, "SUBTOTAL(3")
	SB_SetText("SUBTOTAL(函数编号(3),引用1,引用2...）")
else if Instr(FormulaStr, "SUBTOTAL(103")
	SB_SetText("SUBTOTAL(函数编号(103),引用1,引用2...）")
else if Instr(FormulaStr, "SUMPRODUCT")
	SB_SetText("SUMPRODUCT(数组1*数组2*数组3...）")
else if Instr(FormulaStr, "IF(AND(")
	SB_SetText("IF(AND(条件1,条件2...）,条件成立返回值[真值],条件不成立返回值[假值])")
else if Instr(FormulaStr, "IF(OR(")
	SB_SetText("IF(OR(条件1,条件2...）,条件成立返回值[真值],条件不成立返回值[假值])")
else if Instr(FormulaStr, "EDATE")
	SB_SetText("Edate(起始日期,月份数(正为加上指定月数, 负数为减去))")
else if Instr(FormulaStr, "WEEKNUM")
	SB_SetText("WEEKNUM(日期,2(星期一为第一天))")


else
	SB_SetText("")
return

GuiClose:
GuiEscape:
 ExitApp