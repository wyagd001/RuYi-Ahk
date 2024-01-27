;|2.5|2023.07.01|1538
#SingleInstance force
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e77f.ico"
Windo_ET_PasteAll:
word := ComObjActive("kwps.Application")
	word.Selection.ClearFormatting  ;清除格式
	word.Selection.Range.HighlightColorIndex := 0  ;背景色突出显示，不能通过清除格式去掉（注意不是底纹）
	word.Selection.ParagraphFormat.CharacterUnitLeftIndent := 0    ;左缩进、右缩进、首行缩进（注意：必须中文设置在前，英文设置在后）
	word.Selection.ParagraphFormat.CharacterUnitRightIndent := 0
	word.Selection.ParagraphFormat.CharacterUnitFirstLineIndent := 2
	word.Selection.ParagraphFormat.LeftIndent := 0
	word.Selection.ParagraphFormat.RightIndent := 0
	word.Selection.ParagraphFormat.FirstLineIndent := 0
	word.Selection.Font.Name := "仿宋_GB2312"
	word.Selection.Font.Size := 16  ;三号
	word.Selection.ParagraphFormat.LineSpacingRule := 4     ;行距规则，单倍行距多倍行距等，依据菜单项从0到5
	word.Selection.ParagraphFormat.LineSpacing := 28    ;行距具体值
	MouseMove, 2, 2 , , R
	word :=""
Return