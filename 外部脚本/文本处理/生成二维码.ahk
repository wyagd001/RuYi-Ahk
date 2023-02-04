#SingleInstance force
CandySel := A_Args[1]
; 1173
Cando_生成二维码:
Gui,66:Default
Gui,66:Destroy
GUI, Add, Pic, x20 y20 w500 h-1 hwndhimage, % f:=GEN_QR_CODE(CandySel)
GUI, Add, Text, x20 y542 h24, 按Esc取消
GUI, Add, Button, x420 y540 w100 h24 gSaveAs, 另存为(&S)
GUI, Show, w540 h580
return

SaveAs:
  Fileselectfile,nf,s16,,另存为,PNG图片(*.png)
  If not strlen(nf)
    return
  nf := RegExMatch(nf,"i)\.png") ? nf : nf ".png"
  Filecopy,%f%,%nf%,1
return

GEN_QR_CODE(string,file:="")
{
  sFile := strlen(file) ? file : A_Temp "\" A_NowUTC ".png"
  DllCall( A_ScriptDir "\..\..\引用程序\" (A_PtrSize=8 ? "\x64\quricol64.dll" : "\x32\quricol32.dll") "\GeneratePNG","str", sFile , "str", string, "int", 4, "int", 20, "int", 0)
  Return sFile
}

66GuiClose:
66GuiEscape:
Gui,66: Destroy
exitapp
Return