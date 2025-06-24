;|2.8|2024.10.7|1688
#InstallMouseHook
#InputLevel 5

CoordMode, Mouse, Screen

左边缘开关 := 1
右边缘开关 := 1
顶部开关   := 1
底部开关   := 0

按下左键时禁用 := 1
按下右键时禁用 := 1
按下键盘时禁用 := 1

左上角禁用宽 := 200
左上角禁用高 := 50
右上角禁用宽 := 200
右上角禁用高 := 50
左下角禁用宽 := 200
左下角禁用高 := 40
右下角禁用宽 := 280
右下角禁用高 := 40

SysGet, OutputVar_W, 78
SysGet, OutputVar_H, 79
SysGet, OutputVar_X, 76
SysGet, OutputVar_Y, 77

X_MIN := OutputVar_X
X_MAX := OutputVar_W + OutputVar_X - 1
Y_MIN := OutputVar_Y
Y_MAX := OutputVar_H + OutputVar_Y - 1

;tooltip % OutputVar_X "|" OutputVar_Y "|" OutputVar_W
loop
{
  MouseGetPos, OutputVarX, OutputVarY
  按下左键 := getkeystate("LButton")
  按下右键 := getkeystate("RButton", "P")
  按下键盘 := getkeystate("Ctrl") or getkeystate("Shift") or getkeystate("Alt") or getkeystate("Win")
  ;tooltip % 按下右键时禁用 "|" 按下右键
  if 按下左键时禁用 && 按下左键
    continue
  if 按下右键时禁用 && 按下右键
    continue
  if 按下键盘时禁用 && 按下键盘
    continue

  if 左边缘开关 && (OutputVarX <= X_MIN) and ((OutputVarY >= 左上角禁用高) && (OutputVarY <=  Y_MAX - 左下角禁用高))
    DllCall("SetCursorPos", "int", X_MAX - 1, "int", OutputVarY)
  else if 右边缘开关 && (OutputVarX >= X_MAX) and ((OutputVarY >= 左上角禁用高) && (OutputVarY <=  Y_MAX - 右下角禁用高))
    DllCall("SetCursorPos", "int", X_MIN + 1, "int", OutputVarY)
  else if 顶部开关 && (OutputVarY <= Y_MIN) and ((OutputVarX >= X_MIN + 左上角禁用宽) && (OutputVarX <= X_MAX - 右上角禁用宽))
    DllCall("SetCursorPos", "int", OutputVarX, "int", Y_MAX - 1)
  else if 底部开关 && (OutputVarY >= Y_MAX) and ((OutputVarX >= X_MIN + 左下角禁用宽) && (OutputVarX <= X_MAX - 右下角禁用宽))       ; 底部
    DllCall("SetCursorPos", "int", OutputVarX, "int", Y_MIN + 1)
}