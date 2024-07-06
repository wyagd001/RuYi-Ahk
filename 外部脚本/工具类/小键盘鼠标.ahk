;|2.7|2024.06.23|1630
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=3753&sid=ae46efee1666ea4fdaca3878bea7b9d7
/*
o------------------------------------------------------------o
|Using Keyboard NumPad as a Mouse (NumpadMouse) 2.0.3        |
(------------------------------------------------------------)
| By deguix        / A Script file for AutoHotkey 1.1.15.0   |
|                 -------------------------------------------|
|                                                            |
|    This script can make use of 4 dimensional parametric    |
| equations (mouse x/y, wheel x/y -> z/w - Cartesian         |
| coordinate system) to move the mouse pointer or the mouse  |
| wheel, using separate time variables for each axis. It     |
| makes the keyboard move the mouse pointer/wheel almost as  |
| easy as when using a real mouse, except that it has much   |
| finer control, so it can be better used in drawing         |
| complicated equations. It also supports up to five mouse   |
| buttons, and features customizable movement speed, 3       |
| dimensional rotation on x,y,z axis (thinking on doing 4D), |
| button/moviment lock (alternative to holding buttons down),|
| equation swap for any defined equations in the script,     |
| and use of the equational inverse to relate equation with  |
| screen coordinates. See the list of keys used below:       |
|------------------------------------------------------------|
| Keys                  | Description                        |
|------------------------------------------------------------|
| ScrollLock (打开)| 激活 NumPad 鼠标模式.       |
|-----------------------|------------------------------------|
| NumPadDiv/NumPadMult  | 鼠标的第 4/5 个按键点击. 一般和 Browser_Back/Browser_Forward 执行相同功能. (Win 2k+)|
| NumPadAdd             | Rotates equation counterclockwise  |
|                       | 1 degree at the time using the 3D  |
|                       | rotation vector.***                |
| NumPadSub             | Rotates equation clockwise 1 degree|
|                       | at the time using the 3D rotation  |
|                       | vector.***                         |
|-----------------------|------------------------------------|
| NumLock (关闭)        | 激活鼠标移动模式                     |
| (- / +)               | Description (axis)                 |
|-----------------------|------------------------------------|
| 0 NumPadIns               | 左键.                          | 
| 5 NumPadClear             | 中键.                          |
| . NumPadDot               | 右键.                          |
| 4/6 NumPadLeft/Right      | 水平方向移动 (X)                |
| 2/8 NumPadDown/Up         | 竖直方向移动 (Y)                |
| 1/9 NumPadEnd/PgUp        | 竖直方向滚轮 (Z)                |
| 7/3 NumPadHome/PgDn       | 水平方向滚轮*(W)                |
|-----------------------|------------------------------------|
| NumLock (打开)  | 激活速度调整模式. /锁定模式   |
| (- / +)               | Description (axis)                 |
|-----------------------|------------------------------------|
| NumPad4/6             | X axis time variable speed adj.    |
| NumPad2/8             | Y axis time variable speed adj.    |
| NumPad1/9             | Z axis time variable speed adj.**  |
| NumPad7/3             | W axis time variable speed adj.**  |
| Numpad5               | Uses the functional inverse of the |
|                       | equation to make movement relative |
|                       | to current mouse (wheel) position. |
|                       | Requires a functional invertible   |
|                       | equation.***** (default is on)     |
| NumPad0               | 点击一次左键后保持按下状态 (on 1/off 0).       |
| NumPadDot             | 移动一次后保持移动状态 (on/off).    |
|------------------------------------------------------------|
| NumPadEnter (pressed) | Activates functional modification  |
|-----------------------|------------------------------------|
| NumpadDel             | Sets the origin of the coordinate  |
|                       | system to the mouse pointer screen |
|                       | coordinates and to the current Z   |
|                       | and W coordinates (this affects the|
|                       | place where equations start from). |
| NumpadPgDn            | Resets all time variables to 0.    |
| NumpadIns             | Moves to where equation is		 |
|						| currently.    					 |
| NumpadAdd             | Sets the 3D rotation vector to     |
|                       | the current time variables' values |
|                       | (Tx,Ty,Tz).                        |
| NumpadSub             | Sets the 3D rotation vector to     |
|                       | the opposite of the time variables'|
|                       | values (-Tx,-Ty,-Tz).              |
| NumpadDiv             | Swaps to previous equation.****    |
| NumpadMult            | Swaps to next equation.****        |
|------------------------------------------------------------|
| * = Left/Right movements are only supported in Vista+.     |
| ** = These options are affected by the mouse wheel speed   |
| adjusted on Control Panel as well. If you don't have a     |
| mouse with wheel, the default is 3 +/- lines per option    |
| button press. This is not shown by the script.             |
| *** = Requires a 3D rotation vector (x,y,z) before using   |
| (Use NumpadAdd/NumpadSub for that).                        |
| **** = Equations are defined in the script itself. Check   |
| the configuration section on how to use them.              |
| ***** = A functional invertible equation has to be defined |
| along with the normal equation definition. Check the       |
| configuration section on how to do that.                   |
o------------------------------------------------------------o

o------------------------------------------------------------o
| Basic usage												 |
(------------------------------------------------------------)
| .---.														 |
| |SL+|	SL on: activates the script.						 |
| .---.														 |
|------------------------------------------------------------|
| .---.---.---.---.											 |
| |NL-|XC |X2C|   |		   |								 |
| .---.---.---.---.		   |								 |
| |-W |+Y |+Z |   |		.-----.	    +Y	      +Z			 |
| .---.---.---.   |		|L|M|R|	   .-.	     |^|			 |
| |-X |MC |+X |   |		|-----|	-X |/  +X -W | | +W			 |
| .---.---.---.---.		|    X|	     \	     |v|			 |
| |-Z |-Y |+W |   |		|   X2|	    -Y	      -Z			 |
| .---.---.---.   |		|     |								 |
| |   LC  |RC |   |		.-----.								 |
| .-------.---.---.											 |
| 															 |
| While NumLock is Off:										 |
| +X, -X: Horizontal mouse pointer movement.				 |
| +Y, -Y: Vertical mouse pointer movement.					 |
| +Z, -Z: Vertical mouse wheel movement.					 |
| +W, -W: Horizontal mouse wheel movement.					 |
| LC: Left mouse button click.								 |
| MC: Middle mouse button click.							 |
| RC: Right mouse button click.								 |
| XC: X mouse button click.									 |
| X2C: X2 mouse button click.								 |
|------------------------------------------------------------|
| .---.---.---.---.											 |
| |NL+|   |   |   |											 |
| .---.---.---.---.											 |
| |-MW|+MY|+MZ|   |											 |
| .---.---.---.   |											 |
| |-MX|ST |+MX|   |											 |
| .---.---.---.---.											 |
| |-MZ|-MY|+MW|   |											 |
| .---.---.---.   |											 |
| |   CL  |ML |   |											 |
| .-------.---.---.											 |
| 															 |
| While NumLock is On:										 |
| +MX, -MX: Adjusts speed of the tX variable.				 |
| +MY, -MY: Adjusts speed of the tY variable.				 |
| +MZ, -MZ: Adjusts speed of the tZ variable.				 |
| +MW, -MW: Adjusts speed of the tW variable.				 |
| CL: (on/off) Locks button clicks when they are first		 |
| pressed. Unlocks them on the next press.					 |
| ML: (on/off) Locks button movement when they are first	 |
| pressed. Unlocks them on the next press.					 |
| ST: Shows the tray tip of current coordinates and time	 |
| variable vectors.											 |
| 															 |
| tX,tY,tZ,tW are time variables for each respective		 |
| axis that are used by the equation.						 |
(------------------------------------------------------------)
| Advanced usage											 |
(------------------------------------------------------------)
| Basic usage uses:											 |
| - Tesseract equation with Line equation inverse			 |
| (no screen coordinates for mouse wheel).					 |
| - Center at the center of all screens in terms of			 |
| height and width.											 |
| - No rotation.											 |
|------------------------------------------------------------|
| .---.---.---.---. .---.---.---.---. .---.---.---.---.		 |
| |NL-|   |   |R- | |NL+|   |   |R- | |NL-|PE |NE |RV-|		 |
| .---.---.---.---. .---.---.---.---. .---.---.---.---.		 |
| |   |   |   |   | |   |   |   |   | |   |   |   |   |		 |
| .---.---.---.R+ | .---.---.---.R+ | .---.---.---.RV+|		 |
| |   | . |   |   | |   |   |   |   | |   |RM |   |   |		 |
| .---.---.---.---. .---.---.---.---. .---.---.---.---.		 |
| |   |   |   |   | |   |   |   |   | |   |   |RE | E |		 |
| .---.---.---.   | .---.---.---.   | .---.---.---. N+|		 |
| |       |   |   | |       |   |   | |  GSE  |SC | T |		 |
| .-------.---.---. .-------.---.---. .-------.---.---.		 |
| 															 |
| NE= Swaps to the next equation in the array Equation#		 |
| (here in the script).										 |
| PE= Swaps to the previous equation in the array			 |
| Equation# (here in the script).							 |
| 															 |
| Check the configuration section on how to add them.		 |
| 															 |
| SC= Sets the center of the equation:						 |
| 															 |
| Should use this first, depending on the equation,			 |
| mainly if the equation is not related to the				 |
| definition of a coordinate system.						 |
| 															 |
| By default, the center is in the centered height and		 |
| width from all monitors.									 |
| 															 |
| RE= Resets all time variables to 0:						 |
|															 |
| Useful only if relative mode is off and/or equation has no |
| inverse.				 									 |
|															 |
| GSE= Moves the mouse pointer/wheel to the current position |
| of the equation:											 |
| 															 |
| Best used with equations with no inverse. Used for		 |
| drawing them on the screen from the right spot.			 |
| 															 |
| R-= Rotation in 3 dimensions (X,Y,Z) anti-clockwise about	 |
| the rotation vector (see below).							 |
| R+= Rotation in 3 dimensions (X,Y,Z) clockwise about the	 |
| rotation vector (see below).								 |
| RV-= Sets the rotation vector	to <-tX,-tY,-tZ>.			 |
| RV+=Sets the rotation vector to <tX,tY,tZ>.				 |
| 															 |
| Rotation is limited to 3 dimensions so far. I can't		 |
| understand the rotation for 4 dimensions yet. :/			 |
| 															 |
| RM= Relative mode switch (on/off):						 |
| 															 |
| When it's on, the equation inverse depends on the			 |
| screen coordinates to continue to move the equation.		 |
| 															 |
| When it's off, the equation doesn't use it, thus			 |
| will start at <0,0,0,0> regardless of the current			 |
| screen coordinates of pointer. Strongly recommended for	 |
| any equation that uses decimals (errors can become		 |
| horrifying).												 |
(------------------------------------------------------------)
| Overview of buttons used									 |
(------------------------------------------------------------)
| .--.														 |
| |SL|														 |
| .--.														 |
| 															 |
| .---.---.---.---.											 |
| |NL | / | * | - |											 |
| .---.---.---.---.											 |
| | 7 | 8 | 9 |   |											 |
| .---.---.---. + |											 |
| | 4 | 5 | 6 |   |											 |
| .---.---.---.---.											 |
| | 1 | 2 | 3 | E |											 |
| .---.---.---. N |											 |
| |   0   | . | T |											 |
| .-------.---.---.											 |
|------------------------------------------------------------|
| Functional keys placement:								 |
| 															 |
| > = Movement (or related adjustments/options)				 |
| . = Click (or related options)							 |
| * = Equational (or related options)						 |
| & = Miscellaneous											 |
| +- = on/off or pressed/not pressed						 |
| blank = no action associated with that button (or button	 |
| sequence)													 |
|------------------------------------------------------------|
| .---.														 |
| |SL+|														 |
| .---.														 |
| 															 |
| .---.---.---.---. .---.---.---.---. .---.---.---.---.		 |
| |NL-| . | . | * | |NL+| . | . | * | |NL-| * | * | * |		 |
| .---.---.---.---. .---.---.---.---. .---.---.---.---.		 |
| | > | > | > |   | | > | > | > |   | |   |   |   |   |		 |
| .---.---.---. * | .---.---.---. * | .---.---.---. * |		 |
| | > | . | > |   | | > | & | > |   | |   | * |   |   |		 |
| .---.---.---.---. .---.---.---.---. .---.---.---.---.		 |
| | > | > | > |   | | > | > | > |   | |   |   | * | E |		 |
| .---.---.---.   | .---.---.---.   | .---.---.---. N+|		 |
| |   .   | . |   | |   .   | > |   | |   *   | * | T |		 |
| .-------.---.---. .-------.---.---. .-------.---.---.		 |
o------------------------------------------------------------o
*/

;START OF CONFIG SECTION

#SingleInstance force
#MaxHotkeysPerInterval 500

; Using the keyboard hook to implement the NumPad hotkeys prevents
; them from interfering with the generation of ANSI characters such
; as à.  This is because AutoHotkey generates such characters
; by holding down ALT and sending a series of NumPad keystrokes.
; Hook hotkeys are smart enough to ignore such keystrokes.
#UseHook

;Pointer movement cycle speed
PointerMovementCycleInterval:=10 ;in milliseconds (approx. depending on computer performance)

;Mouse button cycle speed
ButtonPressCycleInterval:=10 ;in milliseconds (approx. depending on computer performance)

;The following can also be configured while using the script:

;Button lock states:
;1=on (pressing once = hold, pressing again = release)
;0=off (need holding and releasing of buttons).
ClickLockState:=0
MovementLockState:=0

;Allows movement relative to the screen coordinates.
;Z and W axis (mouse wheel) can't be captured, but
;they still can be used.
MovementRelativeToScreen:=1

;Shows the coordinates traytip whenever moving.
ShowCoordinatesTooltip:=0

;Time variable deltas per cycle (speed).
tXMagnitude:=5.000000
tYMagnitude:=5.000000
tZMagnitude:=1.000000
tWMagnitude:=1.000000

PI:=4*ATan(1)

pi() {
	Return 4*ATan(1)
}

atan2(x,y) {
   Return dllcall("msvcrt\atan2","Double",y, "Double",x, "CDECL Double")
}

/*
o------------------------------------------------------------o
| Parametric equation definitions							 |
(------------------------------------------------------------)
| 															 |
| New equations should have the following function/variable	 |
| names:													 |
| # = non-skipping integer starting from 0.					 |
| 															 |
| Equation#Name												 |
| 															 |
|   Describes its name. Shown whenever swapping equations.	 |
| 															 |
| Equation#(ByRef tX,ByRef tY,ByRef tZ,ByRef tW)			 |
| 															 |
|   Main parametric equation. Used to position the mouse	 |
|   pointer/wheel.											 |
| 															 |
| Equation#Inv(ByRef X,ByRef Y,ByRef Z,ByRef W)				 |
| 															 |
|   Inverse of the main parametric equation. Used to get the |
|   position of the mouse pointer/wheel. Return -1 to make	 |
|   script not to use this.									 |
o------------------------------------------------------------o
*/

Equation0Name:="Tesseract (X,Y,Z,W) - Line Inverse (X,Y)"

Equation0(ByRef tX,ByRef tY,ByRef tZ,ByRef tW)
{
	Return
}

Equation0Inv(ByRef X,ByRef Y,ByRef Z,ByRef W)
{
	Return
}

Equation1Name:="Line (X+Z,Y+W) - Line Inverse (X,Y)"

Equation1(ByRef tX,ByRef tY,ByRef tZ,ByRef tW)
{
	tX:=tX+tZ
	tY:=tY+tW
	tZ:=0
	tW:=0
}

Equation1Inv(ByRef X,ByRef Y,ByRef Z,ByRef W)
{
	Z:=0
	W:=0
}

Equation2Name:="Circle (radius, angle*100) + Line (Z,W) - No Inverse"

Equation2(ByRef tX,ByRef tY,ByRef tZ,ByRef tW)
{
	tXtemp:=tX
	tYtemp:=tY
	tX:=tXtemp*Cos(tYtemp/50.000000)
	tY:=tXtemp*Sin(tYtemp/50.000000)
}

Equation2Inv(ByRef X,ByRef Y,ByRef Z,ByRef W)
{
	;Xtemp:=X
	;Ytemp:=Y
	;X:=(Ytemp**2+Xtemp**2)**(1/2)
	;Y:=atan2(Xtemp,Ytemp)*50.000000
	Return -1
}

Equation3Name:="Butterfly curve (Transcendental) (X,Y) + Line (Z,W) - No Inverse"

Equation3(ByRef tX,ByRef tY,ByRef tZ,ByRef tW)
{
	tX:=(tX*pi()/500)
	tX:=Sin(tX)*(Exp(Cos(tX))-2*Cos(4*tX)-(Sin(tX/12))**5)*50

	tY:=(tY*pi()/500)
	tY:=Cos(tY)*(Exp(Cos(tY))-2*Cos(4*tY)-(Sin(tY/12))**5)*50
}

Equation3Inv(ByRef X,ByRef Y,ByRef Z,ByRef W)
{
	Return -1
}

Equation4Name:="Butterfly curve (Transcendental) (X+Y) + Line (Z,W) - No Inverse"

Equation4(ByRef tX,ByRef tY,ByRef tZ,ByRef tW)
{
	tX:=(tX*pi()/500)+(tY*pi()/500)
	tY:=tX
	tX:=Sin(tX)*(Exp(Cos(tX))-2*Cos(4*tX)-(Sin(tX/12))**5)*50
	tY:=Cos(tY)*(Exp(Cos(tY))-2*Cos(4*tY)-(Sin(tY/12))**5)*50
}

Equation4Inv(ByRef X,ByRef Y,ByRef Z,ByRef W)
{
	Return -1
}

Equation5Name:="Four-leaved clover (X,Y) + Line (Z,W) - No Inverse"

Equation5(ByRef tX,ByRef tY,ByRef tZ,ByRef tW)
{
	tX:=(tX*pi()/500)
	tX:=Sin(2*tX)*Cos(tX)*200

	tY:=(tY*pi()/500)
	tY:=Sin(tY)*Sin(2*tY)*200
}

Equation5Inv(ByRef X,ByRef Y,ByRef Z,ByRef W)
{
	Return -1
}

Equation6Name:="Four-leaved clover (X+Y) + Line (Z,W) - No Inverse"

Equation6(ByRef tX,ByRef tY,ByRef tZ,ByRef tW)
{
	tX:=(tX*pi()/500)+(tY*pi()/500)
	tY:=tX
	tX:=Sin(2*tX)*Cos(tX)*200
	tY:=Sin(tY)*Sin(2*tY)*200
}

Equation6Inv(ByRef X,ByRef Y,ByRef Z,ByRef W)
{
	Return -1
}

Equation7Name:="Sine wave (X), Amplitude (Y), Frequency (Z), Phase (W)"

Equation7(ByRef tX,ByRef tY,ByRef tZ,ByRef tW)
{
	tXtemp:=tX
	tYtemp:=tY
	tX:=tXtemp
	tY:=tYtemp*Sin(tXtemp/((tW/50.000000)+(tZ*1.000000)))
	tZ:=0
	tW:=0
}

Equation7Inv(ByRef X,ByRef Y,ByRef Z,ByRef W)
{
	Return -1
}

;END OF CONFIG SECTION

Equation:=0

MovementParametrizations:=0

MovementTotalMagnitudeTX:=0.000000
MovementTotalMagnitudeTY:=0.000000
MovementTotalMagnitudeTZ:=0.000000
MovementTotalMagnitudeTW:=0.000000

SysGet, ScreenResolutionWidth, 78
SysGet, ScreenResolutionHeight, 79

EquationOriginX:=(ScreenResolutionWidth/2)*1.000000
EquationOriginY:=(ScreenResolutionHeight/2)*1.000000
EquationOriginZ:=0.000000
EquationOriginW:=0.000000

GlobalPointerCurrentX:=0.000000
GlobalPointerCurrentY:=0.000000
GlobalPointerCurrentZ:=0.000000

GlobalEquationX:=0.000000
GlobalEquationY:=0.000000
GlobalEquationZ:=0.000000
GlobalEquationW:=0.000000

GlobalAngle:=0.000000
GlobalQuaternaryA:=1.000000
GlobalQuaternaryB:=0.000000
GlobalQuaternaryC:=0.000000
GlobalQuaternaryD:=0.000000
GlobalQuaternaryE:=0.000000

GlobalQuaternaryRotationX:=1.000000
GlobalQuaternaryRotationY:=1.000000
GlobalQuaternaryRotationZ:=1.000000
GlobalQuaternaryRotationW:=1.000000

GlobalRotationVectorX:=0.000000
GlobalRotationVectorY:=0.000000
GlobalRotationVectorZ:=0.000000
GlobalRotationVectorW:=0.000000

CoordMode, Mouse, Screen

;This is needed or key presses would faulty send their natural
;actions. Like NumPadDiv would send sometimes "/" to the
;screen.
#InstallKeybdHook

Buttons:=0

SetKeyDelay, -1
SetMouseDelay, -1

Hotkey, *NumPad0, ButtonLeftClick
Hotkey, *NumPadIns, ButtonLeftClickIns
Hotkey, *NumPad5, ButtonMiddleClick
Hotkey, *NumPadClear, ButtonMiddleClickClear
Hotkey, *NumPadDot, ButtonRightClick
Hotkey, *NumPadDel, ButtonRightClickDel
Hotkey, *NumPadDiv, ButtonX1Click
Hotkey, *NumPadMult, ButtonX2Click

Hotkey, *NumPadSub, ButtonRotateEquationAgainstCenterClockwise
Hotkey, *NumPadAdd, ButtonRotateEquationAgainstCenterCounterclockwise

Hotkey, *NumPadRight, ButtonXUp
Hotkey, *NumPadLeft, ButtonXDown
Hotkey, *NumPadUp, ButtonYUp
Hotkey, *NumPadDown, ButtonYDown
Hotkey, *NumPadPgUp, ButtonZUp
Hotkey, *NumPadEnd, ButtonZDown
Hotkey, *NumPadPgDn, ButtonWUp
Hotkey, *NumPadHome, ButtonWDown

Hotkey, *NumPad6, ButtontXMagnitudeUp
Hotkey, *NumPad4, ButtontXMagnitudeDown
Hotkey, *NumPad8, ButtontYMagnitudeUp
Hotkey, *NumPad2, ButtontYMagnitudeDown
Hotkey, *NumPad9, ButtontZMagnitudeUp
Hotkey, *NumPad1, ButtontZMagnitudeDown
Hotkey, *NumPad3, ButtontWMagnitudeUp
Hotkey, *NumPad7, ButtontWMagnitudeDown
Hotkey, *NumPad0, ButtonLockClick
Hotkey, *NumPadDot, ButtonLockMovement
Hotkey, *NumPad5, ButtonShowCoordinatesTooltip

;Hotkey, NumPadEnter & NumPadRight, 
;Hotkey, NumPadEnter & NumPadLeft, 
;Hotkey, NumPadEnter & NumPadUp, 
;Hotkey, NumPadEnter & NumPadDown, 
;Hotkey, NumPadEnter & NumPadPgUp, 
;Hotkey, NumPadEnter & NumPadEnd, 
;Hotkey, NumPadEnter & NumPadHome, 
Hotkey, NumPadEnter & NumPadPgDn, ButtonResetEquation
Hotkey, NumPadEnter & NumpadClear, ButtonUseRelativeSystem
Hotkey, NumPadEnter & NumpadIns, ButtonToEquationCurrent
Hotkey, NumPadEnter & NumpadDel, ButtonCentralizeEquation
Hotkey, NumPadEnter & NumpadDiv, ButtonPrevEquation
Hotkey, NumPadEnter & NumpadMult, ButtonNextEquation
Hotkey, NumPadEnter & NumpadAdd, ButtonSetRotationVector
Hotkey, NumPadEnter & NumpadSub, ButtonSetRotationVectorOpposite

Hotkey, NumPadEnter, ButtonEnter

Gosub, ~ScrollLock  ; Initialize based on current ScrollLock state.
return

;Key activation support

~ScrollLock::
; Wait for it to be released because otherwise the hook state gets reset
; while the key is down, which causes the up-event to get suppressed,
; which in turn prevents toggling of the ScrollLock state/light:
KeyWait, ScrollLock
GetKeyState, ScrollLockState, ScrollLock, T
If ScrollLockState = D
{
	Hotkey, *NumPad0, on
	Hotkey, *NumPadIns, on
	Hotkey, *NumPad5, on
	Hotkey, *NumPadClear, on
	Hotkey, *NumPadDot, on
	Hotkey, *NumPadDel, on
	Hotkey, *NumPadDiv, on
	Hotkey, *NumPadMult, on

	Hotkey, *NumPadSub, on
	Hotkey, *NumPadAdd, on

	Hotkey, *NumPadRight, on
	Hotkey, *NumPadLeft, on
	Hotkey, *NumPadUp, on
	Hotkey, *NumPadDown, on
	Hotkey, *NumPadPgUp, on
	Hotkey, *NumPadEnd, on
	Hotkey, *NumPadHome, on
	Hotkey, *NumPadPgDn, on

	Hotkey, *NumPad6, on
	Hotkey, *NumPad4, on
	Hotkey, *NumPad8, on
	Hotkey, *NumPad2, on
	Hotkey, *NumPad9, on
	Hotkey, *NumPad1, on
	Hotkey, *NumPad7, on
	Hotkey, *NumPad3, on
	Hotkey, *NumPad0, on
	Hotkey, *NumPadDot, on
	Hotkey, *NumPad5, on

	;Hotkey, NumPadEnter & NumPadRight, on
	;Hotkey, NumPadEnter & NumPadLeft, on
	;Hotkey, NumPadEnter & NumPadUp, on
	;Hotkey, NumPadEnter & NumPadDown, on
	;Hotkey, NumPadEnter & NumPadPgUp, on
	;Hotkey, NumPadEnter & NumPadEnd, on
	;Hotkey, NumPadEnter & NumPadHome, on
	Hotkey, NumPadEnter & NumPadPgDn, on
	Hotkey, NumPadEnter & NumpadClear, on
	Hotkey, NumPadEnter & NumpadIns, on
	Hotkey, NumPadEnter & NumpadDel, on
	Hotkey, NumPadEnter & NumpadDiv, on
	Hotkey, NumPadEnter & NumpadMult, on
	Hotkey, NumPadEnter & NumpadAdd, on
	Hotkey, NumPadEnter & NumpadSub, on

	Hotkey, NumPadEnter, on
}
else
{
	Hotkey, *NumPad0, off
	Hotkey, *NumPadIns, off
	Hotkey, *NumPad5, off
	Hotkey, *NumPadClear, off
	Hotkey, *NumPadDot, off
	Hotkey, *NumPadDel, off
	Hotkey, *NumPadDiv, off
	Hotkey, *NumPadMult, off

	Hotkey, *NumPadSub, off
	Hotkey, *NumPadAdd, off

	Hotkey, *NumPadRight, off
	Hotkey, *NumPadLeft, off
	Hotkey, *NumPadUp, off
	Hotkey, *NumPadDown, off
	Hotkey, *NumPadPgUp, off
	Hotkey, *NumPadEnd, off
	Hotkey, *NumPadHome, off
	Hotkey, *NumPadPgDn, off

	Hotkey, *NumPad6, off
	Hotkey, *NumPad4, off
	Hotkey, *NumPad8, off
	Hotkey, *NumPad2, off
	Hotkey, *NumPad9, off
	Hotkey, *NumPad1, off
	Hotkey, *NumPad7, off
	Hotkey, *NumPad3, off
	Hotkey, *NumPad0, off
	Hotkey, *NumPadDot, off
	Hotkey, *NumPad5, off

	;Hotkey, NumPadEnter & NumPadRight, off
	;Hotkey, NumPadEnter & NumPadLeft, off
	;Hotkey, NumPadEnter & NumPadUp, off
	;Hotkey, NumPadEnter & NumPadDown, off
	;Hotkey, NumPadEnter & NumPadPgUp, off
	;Hotkey, NumPadEnter & NumPadEnd, off
	;Hotkey, NumPadEnter & NumPadHome, off
	Hotkey, NumPadEnter & NumPadPgDn, off
	Hotkey, NumPadEnter & NumpadClear, off
	Hotkey, NumPadEnter & NumpadIns, off
	Hotkey, NumPadEnter & NumpadDel, off
	Hotkey, NumPadEnter & NumpadDiv, off
	Hotkey, NumPadEnter & NumpadMult, off
	Hotkey, NumPadEnter & NumpadAdd, off
	Hotkey, NumPadEnter & NumpadSub, off

	Hotkey, NumPadEnter, off
}
return

ButtonEnter:
Send, {NumPadEnter}
Return

;Pointer click section
;-----------------------

ButtonLeftClick:
ButtonLeftClickIns:
  ButtonClickType:="Left"
  PointerButtonName:="LButton"
Goto ButtonClickStart

ButtonMiddleClick:
ButtonMiddleClickClear:
  ButtonClickType:="Middle"
  PointerButtonName:="MButton"
Goto ButtonClickStart

ButtonRightClick:
ButtonRightClickDel:
  ButtonClickType:="Right"
  PointerButtonName:="RButton"
Goto ButtonClickStart

ButtonX1Click:
  ButtonClickType:="X1"
  PointerButtonName:="XButton1"
Goto ButtonClickStart

ButtonX2Click:
  ButtonClickType:="X2"
  PointerButtonName:="XButton2"

ButtonClickStart:
StringReplace, ButtonName, A_ThisHotkey, *
If (ButtonDown_%ButtonName%!=1)
{
  ;This adds the button to the button array
  ButtonDown_%ButtonName%:=1
  Buttons:=Buttons+1
  Button%Buttons%Name:=ButtonName
  Button%Buttons%ClickType:=ButtonClickType
  Button%Buttons%PointerButtonName:=PointerButtonName
  Button%Buttons%Initialized:=0
  Button%Buttons%UnHoldStep:=0
  If (Buttons = 1)
    SetTimer, ButtonPressCycle, % ButtonPressCycleInterval
}
Return

ButtonPressCycle:
If (Buttons=0)
{
  SetTimer, ButtonPressCycle, off
  Return
}

Button:=0
Loop
{
  ;Click section
  Button:=Button+1
  If (Button%Buttons%Initialized=0)
  {
    GetKeyState, PointerButtonState, % Button%Button%PointerButtonName
    If (PointerButtonState="D")
      Continue
    MouseClick, % Button%Button%ClickType,,, 1, 0, D
    Button%Buttons%Initialized:=1
  }
  
  ;Click release section
  GetKeyState, ButtonState, % Button%Button%Name, P
  If (ButtonState="U" and (ClickLockState=0 or (ClickLockState=1 and Button%Buttons%UnHoldStep=2)))
  {
    ButtonName:=Button%Buttons%Name
    ButtonDown_%ButtonName%:=0
    MouseClick, % Button%Button%ClickType,,, 1, 0, U
    
    ;This removes the button from the button array
    ;(AHK really needs proper array implementation)
    ButtonTemp:=Button
    ButtonTempPrev:=ButtonTemp-1

    Loop
    {
      ButtonTemp:=ButtonTemp+1
      ButtonTempPrev:=ButtonTempPrev+1
     
      If (Buttons<ButtonTemp)
      {
        Button%ButtonTempPrev%Name:=""
        Button%ButtonTempPrev%ClickType:=""
        Button%ButtonTempPrev%PointerButtonName:=""
        Button%ButtonTempPrev%Initialized:=0
        Break
      }
      Button%ButtonTempPrev%Name:=Button%ButtonTemp%Name
      Button%ButtonTempPrev%ClickType:=Button%ButtonTemp%ClickType
      Button%ButtonTempPrev%PointerButtonName:=Button%ButtonTemp%PointerButtonName
      Button%ButtonTempPrev%Initialized:=Button%ButtonTemp%Initialized
    }
    Buttons:=Buttons-1
  }
  
  ;LockState explaination:
  
  ;Start (button press): UnHoldStep is set to 1.
  ;Middle (cycles after that): click section is executed.
  ;End (button release): UnHoldStep is set to 2.
  ;(1 cycle after that): click release section is executed.
  
  If(ButtonState="U" and ClickLockState=1 and Button%Buttons%UnHoldStep=0)
    Button%Buttons%UnHoldStep:=1
  If(ButtonState="D" and ClickLockState=1 and Button%Buttons%UnHoldStep=1)
    Button%Buttons%UnHoldStep:=2
 
  If (Buttons<=Button)
    Break
}
Return


;Pointer movement section
;--------------------------
ButtonXUp:
	MovementMagnitudeTemp:=+tXMagnitude
	MovementDimensionTemp:="x"
Goto ButtonPointerMovementStart

ButtonXDown:
	MovementMagnitudeTemp:=-tXMagnitude
	MovementDimensionTemp:="x"
Goto ButtonPointerMovementStart

ButtonYUp:
	MovementMagnitudeTemp:=+tYMagnitude
	MovementDimensionTemp:="y"
Goto ButtonPointerMovementStart

ButtonYDown:
	MovementMagnitudeTemp:=-tYMagnitude
	MovementDimensionTemp:="y"
Goto ButtonPointerMovementStart

ButtonZUp:
	MovementMagnitudeTemp:=+tZMagnitude
	MovementDimensionTemp:="z"
Goto ButtonPointerMovementStart

ButtonZDown:
	MovementMagnitudeTemp:=-tZMagnitude
	MovementDimensionTemp:="z"
Goto ButtonPointerMovementStart

ButtonWUp:
	MovementMagnitudeTemp:=+tWMagnitude
	MovementDimensionTemp:="w"
Goto ButtonPointerMovementStart

ButtonWDown:
	MovementMagnitudeTemp:=-tWMagnitude
	MovementDimensionTemp:="w"

ButtonPointerMovementStart:
StringReplace, MovementButtonName, A_ThisHotkey, *
If (MovementButtonDown_%MovementButtonName%!=1)
{
	MovementButtonDown_%MovementButtonName%:=1
	MovementParametrizations:=MovementParametrizations+1
	MovementParametrization%MovementParametrizations%Name:=MovementButtonName
	MovementParametrization%MovementParametrizations%Dimension:=MovementDimensionTemp
	MovementParametrization%MovementParametrizations%Magnitude:=MovementMagnitudeTemp
	MovementParametrization%MovementParametrizations%Initialized:=0
	MovementParametrization%MovementParametrizations%UnHoldStep:=0
	If (MovementParametrizations = 1)
	{
		SetTimer, MovementParametrizatio, % PointerMovementCycleInterval
	}
}
Return

MovementParametrizationInitialization:
If (MovementParametrization%MovementParametrization%Dimension = "x")
{
	MovementMagnitudeTX:=MovementParametrization%MovementParametrization%Magnitude
	MovementTotalMagnitudeTX:=MovementTotalMagnitudeTX+MovementMagnitudeTX
}
If (MovementParametrization%MovementParametrization%Dimension = "y")
{
	MovementMagnitudeTY:=MovementParametrization%MovementParametrization%Magnitude
	MovementTotalMagnitudeTY:=MovementTotalMagnitudeTY+MovementMagnitudeTY
}
If (MovementParametrization%MovementParametrization%Dimension = "z")
{
	MovementMagnitudeTZ:=MovementParametrization%MovementParametrization%Magnitude
	MovementTotalMagnitudeTZ:=MovementTotalMagnitudeTZ+MovementMagnitudeTZ
}
If (MovementParametrization%MovementParametrization%Dimension = "w")
{
	MovementMagnitudeTW:=MovementParametrization%MovementParametrization%Magnitude
	MovementTotalMagnitudeTW:=MovementTotalMagnitudeTW+MovementMagnitudeTW
}
Return

MovementParametrizatio:
If (MovementParametrizations=0)
{
  MovementTotalMagnitudeTX:=0.000000
  MovementTotalMagnitudeTY:=0.000000
  MovementTotalMagnitudeTZ:=0.000000
  MovementTotalMagnitudeTW:=0.000000
  SetTimer, MovementParametrizatio, off
  Return
}
MovementParametrization:=0
Loop
{
  MovementParametrization:=MovementParametrization+1
  If (MovementParametrization%MovementParametrization%Initialized=0)
  {
    Gosub, MovementParametrizationInitialization
    ;TrayTip,,% MovementParametrization
    MovementParametrization%MovementParametrization%Initialized:=1
  }
  GetKeyState, MovementButtonState, % MovementParametrization%MovementParametrization%Name, P
  If (MovementButtonState="U" and (MovementLockState=0 or (MovementLockState=1 and MovementParametrization%MovementParametrization%UnHoldStep=2)))
  {
    MovementButtonName:=MovementParametrization%MovementParametrization%Name
    MovementButtonDown_%MovementButtonName%:=0
    MovementParametrization%MovementParametrization%Magnitude:=-MovementParametrization%MovementParametrization%Magnitude
    Gosub, MovementParametrizationInitialization
    
    MovementParametrizationTemp:=MovementParametrization
    MovementParametrizationTempPrev:=MovementParametrization-1
    Loop
    {
      MovementParametrizationTemp:=MovementParametrizationTemp+1
      MovementParametrizationTempPrev:=MovementParametrizationTempPrev+1
      If (MovementParametrizations<MovementParametrizationTemp)
      {
        MovementParametrization%MovementParametrizationTempPrev%Name:=""
        MovementParametrization%MovementParametrizationTempPrev%Dimension:=0
        MovementParametrization%MovementParametrizationTempPrev%Magnitude:=0
        MovementParametrization%MovementParametrizationTempPrev%Initialized:=0
        MovementParametrization%MovementParametrizationTempPrev%UnHoldStep:=0
        Break
      }
      MovementParametrization%MovementParametrizationTempPrev%Name:=MovementParametrization%MovementParametrizationTemp%Name
      MovementParametrization%MovementParametrizationTempPrev%Dimension:=MovementParametrization%MovementParametrizationTemp%Dimension
      MovementParametrization%MovementParametrizationTempPrev%Magnitude:=MovementParametrization%MovementParametrizationTemp%Magnitude
      MovementParametrization%MovementParametrizationTempPrev%Initialized:=MovementParametrization%MovementParametrizationTemp%Initialized
      MovementParametrization%MovementParametrizationTempPrev%UnHoldStep:=MovementParametrization%MovementParametrizationTemp%UnHoldStep
    }
    MovementParametrizations:=MovementParametrizations-1
  }
 
  If(MovementButtonState="U" and MovementLockState=1 and MovementParametrization%MovementParametrization%UnHoldStep=0)
    MovementParametrization%MovementParametrization%UnHoldStep:=1
  If(MovementButtonState="D" and MovementLockState=1 and MovementParametrization%MovementParametrization%UnHoldStep=1)
    MovementParametrization%MovementParametrization%UnHoldStep:=2
 
  If (MovementParametrizations<=MovementParametrization)
    Break
}

MouseGetPos, PointerCurrentX, PointerCurrentY
PointerCurrentX:=PointerCurrentX & 0xFFFF

SysGet, ScreenResolutionWidth, 78
SysGet, ScreenResolutionHeight, 79

EquationX:=PointerCurrentX-EquationOriginX
EquationY:=((ScreenResolutionHeight-1)-PointerCurrentY)-EquationOriginY
EquationZ:=GlobalEquationZ
EquationW:=GlobalEquationW

;PEquationNextX:=EquationNextX
;PEquationNextY:=EquationNextY
PEquationNextZ:=EquationNextZ
if (PEquationNextZ == "")
	PEquationNextZ = 0.000000
PEquationNextW:=EquationNextW
if (PEquationNextW == "")
	PEquationNextW = 0.000000

If((Equation%Equation%Inv(EquationX, EquationY, EquationZ, EquationW) <> -1) and MovementRelativeToScreen=1)
{
	EquationNextX:=(EquationX+MovementTotalMagnitudeTX)
	EquationNextY:=(EquationY+MovementTotalMagnitudeTY)
	EquationNextZ:=(EquationZ+MovementTotalMagnitudeTZ)
	EquationNextW:=(EquationW+MovementTotalMagnitudeTW)
}
Else
{
	EquationNextX:=(GlobalEquationX+MovementTotalMagnitudeTX)
	EquationNextY:=(GlobalEquationY+MovementTotalMagnitudeTY)
	EquationNextZ:=(GlobalEquationZ+MovementTotalMagnitudeTZ)
	EquationNextW:=(GlobalEquationW+MovementTotalMagnitudeTW)
}

GlobalEquationX:=EquationNextX
GlobalEquationY:=EquationNextY
GlobalEquationZ:=EquationNextZ
GlobalEquationW:=EquationNextW

Equation%Equation%(EquationNextX, EquationNextY, EquationNextZ, EquationNextW)

EquationNextX:=GlobalQuaternaryRotationX*EquationNextX
EquationNextY:=GlobalQuaternaryRotationY*EquationNextY
EquationNextZ:=GlobalQuaternaryRotationZ*EquationNextZ
EquationNextW:=GlobalQuaternaryRotationW*EquationNextW
If(ShowCoordinatesTooltip = 1)
	Traytip,,% "(" . EquationNextX . "," . EquationNextY . "," . EquationNextZ . "," . EquationNextW ") <" . Floor(GlobalEquationX) . "," . Floor(GlobalEquationY) . "," . Floor(GlobalEquationZ) . "," . Floor(GlobalEquationW) . ">"

ToScreenCoordsCurrentX:=EquationNextX+EquationOriginX
ToScreenCoordsCurrentY:=(ScreenResolutionHeight-1)-(EquationNextY+EquationOriginY)
ToScreenCoordsCurrentZ:=EquationNextZ - PEquationNextZ
ToScreenCoordsCurrentW:=EquationNextW - PEquationNextW

MouseMove, % ToScreenCoordsCurrentX, % ToScreenCoordsCurrentY, 0

If (ToScreenCoordsCurrentZ > 0)
{
	MouseClick, wheelup,,, % ToScreenCoordsCurrentZ, 0, D
}
Else if (ToScreenCoordsCurrentZ < 0)
{
	MouseClick, wheeldown,,, % -ToScreenCoordsCurrentZ, 0, D
}

If (ToScreenCoordsCurrentW > 0)
{
	MouseClick, wheelright,,, % ToScreenCoordsCurrentW, 0, D
}
Else if (ToScreenCoordsCurrentW < 0)
{
	MouseClick, wheelleft,,, % -ToScreenCoordsCurrentW, 0, D
}
Return

ButtonToEquationCurrent:
EquationNextX:=GlobalEquationX
EquationNextY:=GlobalEquationY
EquationNextZ:=GlobalEquationZ
EquationNextW:=GlobalEquationW

Equation%Equation%(EquationNextX,EquationNextY,EquationNextZ,EquationNextW)

EquationNextX:=GlobalQuaternaryRotationX*EquationNextX
EquationNextY:=GlobalQuaternaryRotationY*EquationNextY
EquationNextZ:=GlobalQuaternaryRotationZ*EquationNextZ
EquationNextW:=GlobalQuaternaryRotationW*EquationNextW

ToScreenCoordsCurrentX:=EquationNextX+EquationOriginX
ToScreenCoordsCurrentY:=(ScreenResolutionHeight-1)-(EquationNextY+EquationOriginY)
ToScreenCoordsCurrentZ:=(EquationNextZ-GlobalEquationZ)
ToScreenCoordsCurrentW:=(EquationNextW-GlobalEquationW)

MouseMove, % ToScreenCoordsCurrentX, % ToScreenCoordsCurrentY, 0
ToolTip, % "Moved pointer to parametric equation's current position at: (" . ToScreenCoordsCurrentX . "," . ToScreenCoordsCurrentY . "," . ToScreenCoordsCurrentZ . "," . ToScreenCoordsCurrentW . ")"
SetTimer, RemoveToolTip, 5000
Return

ButtonResetEquation:
SysGet, ScreenResolutionWidth, 78
SysGet, ScreenResolutionHeight, 79

GlobalEquationX:=0
GlobalEquationY:=0
GlobalEquationZ:=0
GlobalEquationW:=0

EquationNextX:=0
EquationNextY:=0
EquationNextZ:=0
EquationNextW:=0

ToolTip, % "All time variables are now set to 0."

SetTimer, RemoveToolTip, 5000
Return

ButtonCentralizeEquation:
MouseGetPos, PointerCurrentX, PointerCurrentY
PointerCurrentX:=PointerCurrentX & 0xFFFF

SysGet, ScreenResolutionWidth, 78
SysGet, ScreenResolutionHeight, 79

EquationOriginX:=PointerCurrentX*1.000000
EquationOriginY:=((ScreenResolutionHeight-1)-PointerCurrentY)*1.000000
EquationOriginZ:=GlobalEquationZ
EquationOriginW:=GlobalEquationW
ToolTip, % "Set parametric equation center at: (" . PointerCurrentX*1.000000 . "," . PointerCurrentY*1.000000 . "," . GlobalEquationZ . "," . GlobalEquationW . ")"
GlobalEquationX:=0
GlobalEquationY:=0
GlobalEquationZ:=0
GlobalEquationW:=0
SetTimer, RemoveToolTip, 5000
Return

ButtonLockClick:
If (ClickLockState = 0)
{
	ClickLockState:=1
}
Else
{
	ClickLockState:=0
}
ToolTip, % "Lock click ctate? (1 = True, 0 = False): " . ClickLockState
SetTimer, RemoveToolTip, 5000
Return

ButtonLockMovement:
If (MovementLockState = 0)
{
	MovementLockState:=1
}
Else
{
	MovementLockState:=0
}
ToolTip, % "Lock movement state? (1 = True, 0 = False): " . MovementLockState
SetTimer, RemoveToolTip, 5000
Return

ButtonUseRelativeSystem:
If (MovementRelativeToScreen = 0)
{
	MovementRelativeToScreen:=1
}
Else
{
	MovementRelativeToScreen:=0
}
ToolTip, % "Movement relative to screen? (1 = True, 0 = False): " . MovementRelativeToScreen
SetTimer, RemoveToolTip, 5000
Return

ButtonShowCoordinatesTooltip:
If (ShowCoordinatesTooltip = 0)
{
	ShowCoordinatesTooltip:=1
}
Else
{
	ShowCoordinatesTooltip:=0
}
ToolTip, % "Show coordinates traytip? (1 = True, 0 = False): " . ShowCoordinatesTooltip
SetTimer, RemoveToolTip, 5000
Return

ButtontXMagnitudeUp:
tXMagnitude:=tXMagnitude+1
ToolTip, % "tX Magnitude up to: " . tXMagnitude
SetTimer, RemoveToolTip, 5000
Return

ButtontXMagnitudeDown:
tXMagnitude:=tXMagnitude-1
ToolTip, % "tX Magnitude down to: " . tXMagnitude
SetTimer, RemoveToolTip, 5000
Return

ButtontYMagnitudeUp:
tYMagnitude:=tYMagnitude+1
ToolTip, % "tY Magnitude up to: " . tYMagnitude
SetTimer, RemoveToolTip, 5000
Return

ButtontYMagnitudeDown:
tYMagnitude:=tYMagnitude-1
ToolTip, % "tY Magnitude down to: " . tYMagnitude
SetTimer, RemoveToolTip, 5000
Return

ButtontZMagnitudeUp:
tZMagnitude:=tZMagnitude+1
ToolTip, % "tZ Magnitude up to: " . tZMagnitude
SetTimer, RemoveToolTip, 5000
Return

ButtontZMagnitudeDown:
tZMagnitude:=tZMagnitude-1
ToolTip, % "tZ Magnitude down to: " . tZMagnitude
SetTimer, RemoveToolTip, 5000
Return

ButtontWMagnitudeUp:
tWMagnitude:=tWMagnitude+1
ToolTip, % "tW Magnitude up to: " . tWMagnitude
SetTimer, RemoveToolTip, 5000
Return

ButtontWMagnitudeDown:
tWMagnitude:=tWMagnitude-1
ToolTip, % "tW Magnitude down to: " . tWMagnitude
SetTimer, RemoveToolTip, 5000
Return

ButtonRotateEquationAgainstCenterClockwise:
GlobalAngle:=GlobalAngle-2*(PI/180)
ButtonRotateEquationAgainstCenterCounterclockwise:
GlobalAngle:=GlobalAngle+(PI/180)
a:=Cos(GlobalAngle/2)
b:=GlobalRotationVectorX*Sin(GlobalAngle/2)
c:=GlobalRotationVectorY*Sin(GlobalAngle/2)
d:=GlobalRotationVectorZ*Sin(GlobalAngle/2)

GlobalQuaternaryRotationX:=((a**2)+(b**2)-(c**2)-(d**2))+2*((b*c)-(a*d))+2*((b*d)+(a*c))
GlobalQuaternaryRotationY:=2*((b*c)+(a*d))+((a**2)-(b**2)+(c**2)-(d**2))+2*((c*d)-(a*b))
GlobalQuaternaryRotationZ:=2*((b*d)-(a*c))+2*((c*d)+(a*b))+((a**2)-(b**2)-(c**2)+(d**2))

GlobalQuaternaryA:=newa
GlobalQuaternaryB:=newb
GlobalQuaternaryC:=newc
GlobalQuaternaryD:=newd

;ToolTip, % "(" . GlobalQuaternaryRotationX . "," . GlobalQuaternaryRotationY . "," . GlobalQuaternaryRotationZ . ")"
ToolTip, % "Rotated 3D equation " . GlobalAngle*(180/PI) . " degrees along vector: <" . GlobalRotationVectorX . "," . GlobalRotationVectorY . "," . GlobalRotationVectorZ . . "," . GlobalRotationVectorW ">"
SetTimer, RemoveToolTip, 5000
Return

ButtonSetRotationVector:
GlobalRotationVectorX:=GlobalEquationX
GlobalRotationVectorY:=GlobalEquationY
GlobalRotationVectorZ:=GlobalEquationZ
GlobalRotationVectorW:=GlobalEquationW
ToolTip, % "Set rotation vector from center to: <" . GlobalRotationVectorX . "," . GlobalRotationVectorY . "," . GlobalRotationVectorZ . "," . GlobalRotationVectorW ">"
SetTimer, RemoveToolTip, 5000
Return

ButtonSetRotationVectorOpposite:
GlobalRotationVectorX:=-GlobalEquationX
GlobalRotationVectorY:=-GlobalEquationY
GlobalRotationVectorZ:=-GlobalEquationZ
GlobalRotationVectorW:=-GlobalEquationW
ToolTip, % "Set rotation vector from center to: <" . GlobalRotationVectorX . "," . GlobalRotationVectorY . "," . GlobalRotationVectorZ . "," . GlobalRotationVectorW ">"
SetTimer, RemoveToolTip, 5000
Return

ButtonPrevEquation:
	Equation:=Equation-1
	EquationDelta:=-1
Goto SwapEquations
ButtonNextEquation:
	Equation:=Equation+1
	EquationDelta:=1
SwapEquations:
If ((Equation>=0) and (IsFunc("Equation" . Equation) and IsFunc("Equation" . Equation . "Inv")))
{
	ToolTip, % "Swapped to equation: " . Equation%Equation%Name
	SetTimer, RemoveToolTip, 5000
	Return
}
ToolTip, % "Equation with ID '" . Equation . "' doesn't exist."
Equation:=Equation+EquationDelta*-1
SetTimer, RemoveToolTip, 5000
Return

RemoveToolTip:
SetTimer, RemoveToolTip, Off
ToolTip
Return
