;|2.0|2023.07.01|1329
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\f738.ico"
JA_JowAlert()

JA_JowAlert(){
  FormatTime, CurrHour,, h ;得到12小时制的时，决定敲几下钟
  If CurrHour = 0 ;如果是0点
    CurrHour := 12 ;敲12下
  If A_Min = 30 ;如果是半点
    CurrHour := 1 ;敲1下
  soundplay, %A_ScriptDir%\..\..\脚本图标\dofasodo.wav, Wait ;整点时播放哆发嗦哆，哆嗦拉发。半点不播放。
  loop, %CurrHour%
    soundplay, %A_ScriptDir%\..\..\脚本图标\dong.wav, Wait ;敲钟
}