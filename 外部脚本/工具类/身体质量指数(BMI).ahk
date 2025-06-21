;|2.9|2025.03.28|1708
#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
CandySel := A_Args[1]

Gui Font, s9, Segoe UI
Gui Add, Text, x10 y12 w120 h23 +0x200, 身高(米):
Gui Add, Edit, x70 y13 w351 h23 vheight, 1.73   ;% CandySel
Gui Add, Text, x8 y52 w120 h23 +0x200, 体重(kg):
Gui Add, Edit, x70 y52 w351 h23 gjisuan vweight, 70
Gui Add, Text, x11 y92 w120 h23 +0x200 cblue gjisuan, 结果:

Gui, Add, Slider, x5 y152 w530 vMySlider, 42
Gui Add, Text, x10 y180 w250 h23 c3498DB, ███████████████████
Gui Add, Text, xp+195 yp w75 h23 c3BCEAC, ██████
Gui Add, Text, xp+55 yp w70 h23 cE19B34, ████▌
Gui Add, Text, xp+42 yp w110 h23 cFF893B, ██████████
Gui Add, Text, xp+80 yp w110 h23 cF04849, ██████████


gui, font, s24
Gui Add, Text, x80 y102 w80 h40 vres, 0
Gui Add, Text, x180 y102 w250 h40 vres2
gui, font

Gui Show, w570 h230, 计算BMI指数(因人而异， 仅供参考)
;if CandySel
;  gosub adddes
Return

GuiEscape:
GuiClose:
    ExitApp

jisuan:
gui submit, nohide
BMI := weight / height / height
BMI := Round(BMI, 2)
GuiControl,, res, %BMI%
GuiControl,, MySlider, % BMI * 2
if (BMI<18.5)
  GuiControl,, res2, 偏瘦(<18.5)
if (BMI>18.5) and (BMI<24)
  GuiControl,, res2, 正常(18.5~24)
if (BMI>24) and (BMI<28)
  GuiControl,, res2, 超重(24~28)
if (BMI>28) and (BMI<36)
  GuiControl,, res2, 肥胖(28~36)
if (BMI>36)
  GuiControl,, res2, 严重肥胖(>36)
return