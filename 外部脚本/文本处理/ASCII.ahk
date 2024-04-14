;|2.6|2024.04.13|1573
; https://www.twle.cn/l/yufei/charset/charset-basic-ansi.html
CandySel := A_Args[1]

ASCII_Beizhu := ["NUL(null) 空字符","SOH(start of headline) 标题开始","STX(start of text) 正文开始","ETX(end of text) 正文结束","EOT(end of transmission) 传输结束","ENQ(enquiry) 请求","ACK(acknowledge) 收到通知","\a BEL(bell) 响铃","\b BS(backspace) 退格","\t HT(horizontal tab) 水平制表符"
,"\n LF(NL line feed, new line) 换行键","\v VT(vertical tab) 垂直制表符","\f FF(NP form feed, new page) 换页键","\r CR(carriage return) 回车键","SO(shift out) 不用切换","SI(shift in) 启用切换","DLE(data link escape) 数据链路转义","DC1(device control 1) 设备控制1","DC2(device control 2) 设备控制2","DC3(device control 3) 设备控制3"
,"DC4(device control 4) 设备控制4","NAK(negative acknowledge) 拒绝接收","SYN(synchronous idle) 同步空闲","ETB(end of trans. block) 结束传输块","CAN(cancel) 取消","EM(end of medium) 媒介结束","SUB(substitute) 代替","ESC(escape) 换码(溢出)","FS(file separator) 文件分隔符","GS (group separator) 分组符"
,"RS(record separator) 记录分隔符","US(unit separator) 单元分隔符","(space) 空格","! 感叹号","&quot; "" 引号","# 数字符号","$ 美元符号","% 百分号","&amp; &","&apos; ' 撇号"
,"( 左括号",") 右括号","* 星号","+ 加号",", 逗号","- 连字符",". 句号","/ 斜线","0","1"
,"2","3","4","5","6","7","8","9",": 冒号","; 分号"
,"&lt; < 小于","= 等号","&gt; > 大于","? 问号","@","A","B","C","D","E"
,"F","G","H","I","J","K","L","M","N","O"
,"P","Q","R","S","T","U","V","W","X","Y"
,"Z","[ 左方括号","\ 反斜线","] 右方括号","^ 插入符","_ 下划线","`` 重音符","a","b","c"]

ASCII_Beizhu.Push("d","e","f","g","h","i","j","k","l","m"
,"n","o","p","q","r","s","t","u","v","w"
,"x","y","z","{ 左花括号","| 竖线","} 右花括号","~ 波浪线","DEL(delete) 删除","[保留]","[保留]"
,"[保留]","[保留]","IND 索引","NEL 下一行","SSA 被选区域起始","ESA 被选区域结束","HTS 水平制表符集","HTJ 对齐的水平制表符集","VTS 垂直制表符集","PLD 部分行向下"
,"PLU 部分行向上","RI 反向索引","SS2 单移 2","SS3 单移 3","DCS 设备控制字符串","PU1 专用 1","PU2 专用 2","STS 设置传输状态","CCH 取消字符","MW 消息等待"
,"SPA 保护区起始","EPA 保护区结束","[保留]","[保留]","[保留]","CSI 控制序列引导符","ST 字符串终止符","OSC 操作系统命令","PM 秘密消息","APC 应用程序"
,"&nbsp;   空格","&iexcl; ¡ 倒置感叹号","&cent; ¢ 美分符号","&pound; £ 英镑符号","&curren; ¤ 货币符号","&yen; ¥ 元","&brvbar; ¦","&sect; § 小节号","&uml; ¨ 分音符号","&copy; © 版权所有"
,"&ordf; ª","&laquo; «","&not; ¬","&shy; ­","&reg; ®","&macr; ¯","&deg; ° 度","&plusmn; ± 正负号","&sup2; ² 上标 2","&sup3; ³ 上标 3"
,"&acute; ´","&micro; µ 微米","&para; ¶ 段落符号","&middot; · 中间点","&cedil; ¸ 变音符号","&sup1; ¹ 上标 1","&ordm; º","&raquo; »","&frac14; ¼","&frac12; ½"
,"&frac34; ¾","&iquest; ¿","&Agrave; À","&Aacute; Á","&Acirc; Â","&Atilde; Ã","&Auml; Ä","&Aring; Å","&Aelig; Æ","&Ccedil; Ç")

ASCII_Beizhu.Push("&Egrave; È","&Eacute; É","&Ecirc; Ê","&Euml; Ë","&Igrave; Ì","&Iacute; Í","&Icirc; Î","&Iuml; Ï","&ETH; Ð","&Ntilde; Ñ"
,"&Ograve; Ò","&Oacute; Ó","&Ocirc; Ô","&Otilde; Õ","&Ouml; Ö","&times; ×","&Oslash; Ø","&Ugrave; Ù","&Uacute; Ú","&Ucirc; Û"
,"&Uuml; Ü","&Yacute; Ý","&THORN; Þ","&szlig; ß","&agrave; à","&aacute; á","&acirc; â","&atilde; ã","&auml; ä","&aring; å"
,"&aelig; æ","&ccedil; ç","&egrave; è","&eacute; é","&ecirc; ê","&euml; ë","&igrave; ì","&iacute; í","&icirc; î","&iuml; ï"
,"&eth; ð","&ntilde; ñ","&ograve; ò","&oacute; ó","&ocirc; ô","&otilde; õ","&ouml; ö","&divide; ÷","&oslash; ø","&ugrave; ù"
,"&uacute; ú","&ucirc; û","&uuml; ü","&yacute; ý","&thorn; þ","&yuml; ÿ")

HTMLEntry := {338:"&OElig; Œ",339:"&oelig; œ",352:"&Scaron; Š",353:"&scaron; š",376:"&Yuml; Ÿ",402:"&fnof; ƒ",710:"&circ; ˆ",732:"&tilde; ˜",913:"&Alpha; Α",914:"&Beta; Β"
,915:"&Gamma; Γ",916:"&Delta; Δ",917:"&Epsilon; Ε",918:"&Zeta; Ζ",919:"&Eta; Η",920:"&Theta; Θ",921:"&Iota; Ι"
,922:"&Kappa; Κ",923:"&Lambda; Λ",924:"&Mu; Μ",925:"&Nu; Ν",926:"&Xi; Ξ",927:"&Omicron; Ο",928:"&Pi; Π",929:"&Rho; Ρ",931:"&Sigma; Σ",932:"&Tau; Τ"
,933:"&Upsilon; Υ",934:"&Phi; Φ",935:"&Chi; Χ",936:"&Psi; Ψ",937:"&Omega; Ω",945:"&alpha; α",946:"&beta; β",947:"&gamma; γ",948:"&delta; δ",949:"&epsilon; ε"
,950:"&zeta; ζ",951:"&eta; η",952:"&theta; θ",953:"&iota; ι",954:"&kappa; κ",955:"&lambda; λ",956:"&mu; μ",957:"&nu; ν",958:"&xi; ξ",959:"&omicron; ο"
,960:"&pi; π",961:"&rho; ρ",962:"&sigmaf; ς",963:"&sigma; σ",964:"&tau; τ",965:"&upsilon; υ",966:"&phi; φ",967:"&chi; χ",968:"&psi; ψ",969:"&omega; ω"
,977:"&thetasym; ϑ",978:"&upsih; ϒ",982:"&piv; ϖ",8194:"&ensp;   	短空格",8195:"&emsp;   长空格",8201:"&thinsp;  ",8211:"&ndash; – 短破折号/连字符",8212:"&mdash; — 长破折号",8216:"&lsquo; ‘ 左单引号",8217:"&rsquo; ’ 右单引号",8218:"&sbquo; ‚ 低单引号",8220:"&ldquo; “ 左双引号",8221:"&rdquo; ” 右双引号",8222:"&bdquo; „ 	低双引号",8224:"&dagger; † 剑号",8225:"&Dagger; ‡ 双剑号"
,8226:"&bull; • 着重号",8230:"&hellip; … 水平省略号",8240:"&permil; ‰ 千分号",8242:"&prime; ′",8243:"&Prime; ″",8249:"&lsaquo; ‹ 左单角引号",8250:"&rsaquo; › 右单角引号",8254:"&oline; ‾ 上划线",8260:"&frasl; ⁄ 分数斜线",8364:"&euro; € 欧元"
,8465:"&image; ℑ",8472:"&weierp; ℘",8476:"&real; ℜ",8482:"&trade; ™",8501:"&alefsym; ℵ",8592:"&larr; ← 向左箭头",8593:"&uarr; ↑ 向上箭头",8594:"&rarr; → 向右箭头",8595:"&darr; ↓ 向下箭头",8596:"&harr; ↔ 左右箭头"
,8629:"&crarr; ↵ 角朝左的向下箭头",8656:"&lArr; ⇐ 向左双箭头",8657:"&uArr; ⇑ 向上双箭头",8658:"&rArr; ⇒ 向右双箭头",8659:"&dArr; ⇓ 向下双箭头",8660:"&hArr; ⇔ 左右双箭头",8704:"&forall; ∀ 所有",8706:"&part; ∂ 偏微分",8707:"&exist; ∃ 存在",8709:"&empty; ∅ 空集"
,8711:"&nabla; ∇ 向后差分",8712:"&isin; ∈ 属于",8713:"&notin; ∉ 不属于",8715:"&ni; ∋ 包含的成员",8719:"&prod; ∏ 求积",8721:"&sum; ∑ 求和",8722:"&minus; − 减号",8727:"&lowast; ∗ 星号",8730:"&radic; √ 平方根号",8733:"&prop; ∝ 成比例"}

TmpObj := {8734:"&infin; ∞ 无穷",8736:"&ang; ∠ 角",8743:"&and; ∧ 逻辑与",8744:"&or; ∨ 逻辑或",8745:"&cap; ∩ 交集",8746:"&cup; ∪ 并集",8747:"&int; ∫ 积分",8756:"&there4; ∴ 所以",8764:"&sim; ∼ 相似",8773:"&cong; ≅ 约等于"
,8776:"&asymp; ≈",8800:"&ne; ≠",8801:"&equiv; ≡",8804:"&le; ≤",8805:"&ge; ≥",8834:"&sub; ⊂ 子集",8835:"&sup; ⊃ 超集",8836:"&nsub; ⊄ 非子集",8838:"&sube; ⊆ 子集或等于",8839:"&supe; ⊇ 超集或等于"
,8853:"&oplus; ⊕",8855:"&otimes; ⊗",8869:"&perp; ⊥",8901:"&sdot; ⋅ 点运算符",8968:"&lceil; ⌈ 左天花板",8969:"&rceil; ⌉ 右天花板",8970:"&lfloor; ⌊ 左地板",8971:"&rfloor; ⌋ 右地板",9001:"&lang; 〈 向左的角括号",9002:"&rang; 〉 向右的角括号"
,9674:"&loz; ◊ 菱形",9824:"&spades; ♠ 黑桃",9827:"&clubs; ♣ 梅花",9829:"&hearts; ♥ 红桃",9830:"&diams; ♦ 方片"}

for k,v in TmpObj
	HTMLEntry[k] := v

gui, font, s14
gui,add, Edit, x8 y8 w600 h30 vsearchkey, % CandySel
gui,add, button, x610 y8 w50 h30 gfind default, 搜索
gui,add, ListView, x8 y40 w650 h380 vMyList,序号|字符|十进制|十六进制|备注
gosub find
gui,Show, w660 h400, ASCII 及 HTML 实体
Menu MyListViewMenu, Add, 复制, copy
return

GuiClose:
exitapp

find:
LV_Delete()
Gui, Submit, NoHide
B_Index := 0
for k,v in ASCII_Beizhu
{
	if instr(v, searchkey)
	{
		B_Index++
		LV_Add(, B_Index,Chr(k-1),k-1,Format("{:X}", k-1),v)
	}
}
for k,v in HTMLEntry
{
	if instr(v, searchkey)
	{
		B_Index++
		LV_Add(, B_Index,Chr(k),k,Format("{:X}", k),v)
	}
}
LV_ModifyCol(1, "Integer")
return

GuiContextMenu:
if (A_GuiControl = "MyList")
{
	Menu, MyListViewMenu, Show, %A_GuiX%, %A_GuiY%
}
return

copy:
ControlGet, aac, List, Selected, SysListView321, ASCII 及 HTML 实体
Clipboard := aac
sleep 30
aac := ""
return