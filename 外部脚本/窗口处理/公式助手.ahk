;|2.6|2024.05.12|1598
Gui, Add, Text, x10 y10 w60, 类型:
Gui, Add, ComboBox, xp+70 yp w250 vFormulaTypeIndex gshowNameIndex AltSubmit, 常用||身份证|时间
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
SFZ_ItemsStr := "1. 身份证提取生日|2. 身份证提取生日2|3. 计算年龄|4. 计算年龄2|5. 计算年龄3|6. 提取男女|7. 是否重复|8. 验证是否有效|9. 变18位身份证*"
SFZ_Arr := ["=MID(A1,7,4)&""/""&MID(A1,11,2)&""/""&MID(A1,13,2)"
, "=--TEXT(MID(A1,7,8),""0000-00-00"")"
, "=(TODAY()-A1)/365"
, "=IF(B1,YEAR(B1)-YEAR(A1),YEAR(TODAY())-YEAR(A1))"
, "=DATEDIF(TEXT(MID(A1,7,8),""0-00-00""),TODAY(),""y"")"
, "=IF(MOD(MID(A1,17,1),2)=1,""男"",""女"")"
, "=IF(COUNTIF(A$1:A$10,A1&""*"")>1,""有重复"","""")"
, "=IF(LEN(A1)<>18,""位数错误"",IF(MOD(SUMPRODUCT(MID(A1,ROW($1:$17),1)*2^(18-ROW($1:$17)))+IFERROR(--RIGHT(A1),10),11)<>1,""号码异常"",IF(ISERROR(--TEXT(MID(A1,7,8),""0-00-00"")),""日期错误"",IF(--TEXT(MID(A1,7,8),""0-00-00"")>TODAY(),""尚未生效"",""有效""))))"
, "=IF(LEN(A1)=15,REPLACE(A1,7,,19)&MID(""10X98765432"",MOD(SUMPRODUCT(MID(REPLACE(A1,7,,19),ROW($1:$17),1)*2^(18-ROW($1:$17))),11)+1,1),IF(LEN(A1)=16,REPLACE(A1,7,,19),IF(LEN(A1)=17,A1&MID(""10X98765432"",MOD(SUMPRODUCT(MID(A1,ROW($1:$17),1)*2^(18-ROW($1:$17))),11)+1,1),IF(LEN(A1)=18,A1,""错误""))))"]
CY_ItemsStr := "1. 是否有重复(满足条件的单元格计数)|2. 重复项目计数(满足多条件的单元格计数)|3. 提取唯一值(重复的只提取一次)|4. 提取唯一值(重复的不提取)|5. 是否有重复(重复内容首次出现时不提示)|6. 条件求和|7. 验证银行卡|8. 列查找提取同行列数据|9. 反选查找|10.非空单元格计数"
CY_Arr := ["=IF(COUNTIF(A$1:A$10,A1)>1,""有重复"",""无重复"")"
, "=COUNTIFS(A$1:A$10,A1,B$1:B$10,B1)"
, "=UNIQUE(A1:A10)"
, "=UNIQUE(A1:A10,,1)"
, "=IF(COUNTIF(A$2:A2,A2)>1,""有重复"","""")"
, "=SUMIF(A1:A10,""支付宝"",B1:B10)"
, "=MOD(SUMPRODUCT(LEFT((0&MID(A1,ROW(INDIRECT(""1:""&LEN(A1))),1))*2^MOD(ROW(INDIRECT(""1:""&LEN(A1)))+MOD(LEN(A1),2),2),1)+(0&MID((0&MID(A1,ROW(INDIRECT(""1:""&LEN(A1))),1))*2^MOD(ROW(INDIRECT(""1:""&LEN(A1)))+MOD(LEN(A1),2),2),2,1))),10)=0"
, "=IFNA(VLOOKUP(A1,'[文件名.xlsx]Sheet1'!B1:B10,3,0),"""")"
, "=VLOOKUP(A1,IF({1,0},$B$1:$B$10,$A$1:$A$2),2,0)"
, "=SUBTOTAL(3,$A$2:A2)"]
SJ_ItemsStr := "1. 判断季度|2. 距离合同到期还剩多少天|3. 生肖"
SJ_Arr := ["=LEN(2^MONTH(A1))&""季度"""
, "=DATEDIF(TODAY(),A1,""D"")"
, "=MID(""猴鸡狗猪鼠牛虎兔龙蛇马羊"",MOD(Year(A1),12)+1,1)"]
kind := "常用"  ; 常用|身份证|时间
GuiControl,, FormulaNameIndex, % CY_ItemsStr
return

ReplaceCell:
Gui Submit, NoHide
Tmp_Str := StrReplace(FormulaEdit, "A1", ReplacedCell)
GuiControl,, FormulaEdit, % Tmp_Str
return

showNameIndex:
Gui Submit, NoHide
FormulaType_Arr :=["常用", "身份证", "时间"]
kind := FormulaType_Arr[FormulaTypeIndex]
if (kind = "常用")
	GuiControl,, FormulaNameIndex, % "|" CY_ItemsStr
else if (kind = "身份证")
	GuiControl,, FormulaNameIndex, % "|" SFZ_ItemsStr
else if (kind = "时间")
	GuiControl,, FormulaNameIndex, % "|" SJ_ItemsStr
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
return