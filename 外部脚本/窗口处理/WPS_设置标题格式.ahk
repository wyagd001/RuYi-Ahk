;|2.5|2023.07.01|1537
#SingleInstance force
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e77f.ico"
Windo_ET_PasteAll:
word := ComObjActive("kwps.Application")
	if word.selection.type =1  ;当前Word中未选择具体内容，为光标闪烁状态
	{
		word.Selection.MoveRight  ;向右移动1格光标
		word.Selection.MoveUp(unit := 4)  ;移动光标到段首
		word.Selection.MoveDown(unit := 4,,1)   ;选中光标到段尾的内容
	}
	word.Selection.ClearFormatting  ;清除格式
	word.Selection.Range.HighlightColorIndex := 0  ;背景色突出显示，不能通过清除格式去掉（注意不是底纹）
	word.Selection.ParagraphFormat.CharacterUnitLeftIndent := 0    ;左缩进、右缩进、首行缩进（注意：必须中文设置在前，英文设置在后）
	word.Selection.ParagraphFormat.CharacterUnitRightIndent := 0
	word.Selection.ParagraphFormat.CharacterUnitFirstLineIndent := 0
	word.Selection.ParagraphFormat.LeftIndent := 0
	word.Selection.ParagraphFormat.RightIndent := 0
	word.Selection.ParagraphFormat.FirstLineIndent := 0
	word.Selection.Font.Name := "方正小标宋简体"
	word.Selection.Font.Size := 22  ;二号
	word.Selection.ParagraphFormat.Alignment := 1   ;0左对齐，1居中，2右对齐，3两端对齐，4分散对齐
	word.Selection.ParagraphFormat.LineSpacingRule := 4     ;行距规则，单倍行距多倍行距等，依据菜单项从0到5
	word.Selection.ParagraphFormat.LineSpacing := 28    ;行距具体值
	MouseMove, 2, 2 , , R
	word :=""
Return