;|2.1|2023.07.24|1375
;来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=8963&hilit=click+animation&start=20
;***************************************************************************************************
;#Include <My Altered Gdip Lib>  ;<------       Replace with your copy of GDIP
;***************************************************************************************************
;#Include <LayeredWindow>  ;Layered window class
;***************************************************************************************************
#SingleInstance, Force
SetBatchLines, -1
CoordMode, Mouse, Screen
OnExit, GuiClose
MainWindow := New LayeredWindow(x := -1 , y := -1 , w := A_ScreenWidth+1 , h := A_ScreenHeight+1 , window := 1 , title := "Cursor Tracker" , smoothing := 2 , options := "+AlwaysOnTop -DPIScale +Owner +E0x20" , autoShow := 1 , GdipStart := 1)
;~ Brush := Gdip_BrushCreateSolid("0x2200FF00")
Brush := Gdip_BrushCreateSolid("0x3300FF00")
Brush2 := Gdip_BrushCreateSolid("0x77ffff00")
MouseGetPos, x, y
RandomColor := 1
Circles := []
Loop, 25   ; 粒子
{
	if RandomColor
	{
		Random, R, 0, 255
		Random, G, 0, 255
		Random, B, 0, 255
		FntColor := Format("{1:x}{2:x}{3:x}", R, G, B)
		Brush := Gdip_BrushCreateSolid("0x88" FntColor)
	}
	Circles[A_Index] := New Circle(x,y,MainWindow.G,Brush)
}
SetTimer, Always, 300
SetTimer, WatchCursor, 30
return

GuiClose:
	MainWindow.DeleteWindow( TurnOffGdip := 1 )
	ExitApp

Always:
	Gui,1:Show,NA
	return

WatchCursor:
	MouseGetPos,tx,ty
	MainWindow.ClearWindow()
	;Gdip_FillEllipse(MainWindow.G, Brush2 , tx-20, ty-20 , 40, 40)  ; 黄色圆圈
	Loop, % Circles.Length()	{
		(Circles[A_Index].Move(tx,ty))?((Circles[A_Index].Active)?(Circles[A_Index].Draw()))
	}
	MainWindow.UpdateWindow()
	return

class Circle	{
	__New(x,y,pGraphics,Brush){
		This.D := This._Random(3,15)
		This.Position := New HB_Vector(x - This.D / 2, y - This.D / 2)
		;~ This.Speed := This._Random(10.00,20.00)
		This.Speed := This._Random(20.00,40.00)
		;~ This.Speed := This._Random(5.00,20.00)
		This.Acc := New HB_Vector()
		This.Target := New HB_Vector()
		This.Graphics := pGraphics
		This.Brush := Brush
		This.Distance := 0
		This._SetTarget( x, y)
	}
	Draw(){
		Gdip_FillEllipse(This.Graphics, This.Brush, This.Position.X, This.Position.Y, This.D, This.D)
	}
	_SetTarget(tx,ty){
		local dist 
		This.Target := ""
		if(This.LastTX=tx&&This.LastTY=ty){
			This.Position.X := tx - (This.D/2) 
			This.Position.Y := ty - (This.D/2)
			This.Active := 0
			return
		}
		This.Active := 1
		This.LastTX := tx
		This.LastTY := ty
		This.Target := New HB_Vector(tx-(This.D / 2),ty-( This.D /2))
		dist := This.Position.dist(This.Target)
		This.Distance := dist / This.Speed
	}
	Move(tx,ty){
		if(--This.Distance>0){
			This.Acc.X := This.Target.X 
			This.Acc.Y := This.Target.Y
			This.Acc.Sub(This.Position)
			This.Acc.SetMag(This.Speed)
			This.Position.Add(This.Acc)
		}else{
			This._SetTarget(tx,ty)
		}
		return 1
	}
	_Random(Min,Max){
		local Out
		Random,Out,Min,Max
		return Out
	}
}
Class HB_Vector	{
	__New(x:=0,y:=0){
		This.X:=x
		This.Y:=y
	}
	Add(Other_HB_Vector){
		This.X+=Other_HB_Vector.X
		This.Y+=Other_HB_Vector.Y
	}
	Sub(Other_HB_Vector){
		This.X-=Other_HB_Vector.X
		This.Y-=Other_HB_Vector.Y
	}
	mag(){
		return Sqrt(This.X*This.X + This.Y*This.Y)
	}
	magsq(){
		return This.Mag()**2
	}	
	setMag(in1){
		m:=This.Mag()
		This.X := This.X * in1/m
		This.Y := This.Y * in1/m
		return This
	}
	mult(in1,in2:="",in3:="",in4:="",in5:=""){
		if(IsObject(in1)&&in2=""){
			This.X*=In1.X 
			This.Y*=In1.Y 
		}else if(!IsObject(In1)&&In2=""){
			This.X*=In1
			This.Y*=In1
		}else if(!IsObject(In1)&&IsObject(In2)){
			This.X*=In1*In2.X
			This.Y*=In1*In2.Y
		}else if(IsObject(In1)&&IsObject(In2)){
			This.X*=In1.X*In2.X
			This.Y*=In1.Y*In2.Y
		}	
	}
	div(in1,in2:="",in3:="",in4:="",in5:=""){
		if(IsObject(in1)&&in2=""){
			This.X/=In1.X 
			This.Y/=In1.Y 
		}else if(!IsObject(In1)&&In2=""){
			This.X/=In1
			This.Y/=In1
		}else if(!IsObject(In1)&&IsObject(In2)){
			This.X/=In1/In2.X
			This.Y/=In1/In2.Y
		}else if(IsObject(In1)&&IsObject(In2)){
			This.X/=In1.X/In2.X
			This.Y/=In1.Y/In2.Y
		}	
	}
	dist(in1){
		return Sqrt(((This.X-In1.X)**2) + ((This.Y-In1.Y)**2))
	}
	dot(in1){
		return (This.X*in1.X)+(This.Y*In1.Y)
	}
	cross(in1){
		return This.X*In1.Y-This.Y*In1.X
	}
	Norm(){
		m:=This.Mag()
		This.X/=m
		This.Y/=m
	}
}

; Updated: December 6th, 2020
;----------------------------------------------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------------------------------------------------------------
class LayeredWindow	{
;LayeredWindow class By: Hellbent
	__New( x := 0 , y := 0 , w := 100 , h := 100 , window := 1 , title := " " , smoothing := 4 , options := "" , autoShow := 1 , GdipStart := 0 , WinMover := "" , BackgroundColor := "" ){
		This.X := x , This.Y := y , This.W := w , This.H := h 
		This.Window := window , This.Title := title
		This.Options := options , This.Smoothing := smoothing
		( GdipStart ) ? ( This.Token := Gdip_Startup() )
		This._CreateWindow()
		( autoShow ) ? ( This.ShowWindow() )
		This._SetUpdateLayeredWindow()
		( WinMover ) ? ( This._AddMoveTrigger( WinMover ) )
		( BackgroundColor ) ? ( This.PaintBackground( BackgroundColor , 1 ) )
	}
	_CreateWindow(){
		Gui , % This.Window ": New" , % " +E0x80000 +LastFound -Caption " This.Options 
		This.Hwnd := WinExist()
		This.hbm := CreateDIBSection( This.W , This.H )
		This.hdc := CreateCompatibleDC()
		This.obm := SelectObject( This.hdc , This.hbm )
		This.G := Gdip_GraphicsFromHDC( This.hdc )
		Gdip_SetSmoothingMode( This.G , This.Smoothing )
	}
	_SetUpdateLayeredWindow(){
		UpdateLayeredWindow( This.hwnd , This.hdc , This.X , This.Y , This.W , This.H )
	}
	UpdateWindow(){
		UpdateLayeredWindow( This.hwnd , This.hdc )
	}
	ShowWindow( update := 1 , Position := "" ){ 
		if( !Position )
			Gui , % This.Window ": Show" , % "w" This.W " h" This.H  , % ( This.Title ) ? ( This.Title ) : ( "" )
		else
			Gui , % This.Window ": Show" , % "x" Position.X " y" Position.Y "w" Position.W " h" Position.H  , % ( This.Title ) ? ( This.Title )  : ( "" )
		( update ) ? ( This.UpdateWindow() )
	}
	_AddMoveTrigger( positons ){ 
		local hwnd , bd
		Gui , % This.Window " : Add" , Text , % "x" positons.x " y" positons.y " w" positons.w " h" positons.h " hwndhwnd"
		This.MoveHwnd := hwnd
		bd := This._WindowMover.Bind( This )
		GuiControl , % This.Window ": +G" , % This.MoveHwnd , % bd
	}
	_WindowMover(){ 
		PostMessage, 0xA1 , 2
	}
	PaintBackground( BackgroundColor := "0xFF000000" , update := 0){ 
		local Brush
		This.BackgroundColor := BackgroundColor
		Brush := Gdip_BrushCreateSolid( BackgroundColor )
		Gdip_FillRectangle( This.G , Brush , 0 , 0 , This.W , This.H )
		Gdip_DeleteBrush( Brush )
		( update ) ? ( This.UpdateWindow() )
	}
	Draw( pBitmap , Positions := "" , update := 1 , disposeBitmap := 0  , PaintBackground := 0){ 
	(PaintBackground) ? ( This.PaintBackground( This.BackgroundColor ) )	
		Gdip_DrawImage( This.G 
						, pBitmap 
						, ( Positions.X1 ) ? ( Positions.X1 ) : ( Positions.X ) ? ( Positions.X ) : ( "" )
						, ( Positions.Y1 ) ? ( Positions.Y1 ) : ( Positions.Y ) ? ( Positions.Y ) : ( "" ) 
						, ( Positions.W1 ) ? ( Positions.W1 ) : ( Positions.W ) ? ( Positions.W ) : ( "" ) 
						, ( Positions.H1 ) ? ( Positions.H1 ) : ( Positions.H ) ? ( Positions.H ) : ( "" ) 
						, ( Positions.X2 ) ? ( Positions.X2 ) : ( Positions.SX ) ? ( Positions.SX ) : ( "" )
						, ( Positions.Y2 ) ? ( Positions.Y2 ) : ( Positions.SY ) ? ( Positions.SY ) : ( "" )
						, ( Positions.W2 ) ? ( Positions.W2 ) : ( Positions.SW ) ? ( Positions.SW ) : ( "" )
						, ( Positions.H2 ) ? ( Positions.H2 ) : ( Positions.SH ) ? ( Positions.SH ) : ( "" ) )
		( update ) ? ( This.UpdateWindow() )
		( disposeBitmap ) ? ( Gdip_DisposeImage( pBitmap ) )
	}
	ClearWindow( update := "" ){ 
		Gdip_GraphicsClear( This.G )
		( update ) ? ( This.UpdateWindow() )
	}
	Add_Trigger(PositionObject,Label:="GuiClose"){
		Gui, % This.Window ": Add", Text, % "x" PositionObject.X " y" PositionObject.Y " w" PositionObject.W " h" PositionObject.H " g" Label " BackgroundTrans"
	}
	Draw_Text(PosObj,Text,Font:="Arial",FontSize:="12",Color1:="0xFFFFFFFF",Color2:="",PosObj2:="",update:=0){
		local Brush
		(!color2&&color2!="000000")?(Color2:=Color1)
		(StrLen(Color1)=6)?( Color1 := "0xFF" Color1 )
		(StrLen(Color2)=6)?( Color2 := "0xFF" Color2 )
		(PosObj2="")?(PosObj2:=PosObj)
		Brush := Gdip_CreateLineBrushFromRect( PosObj2.X , PosObj2.Y , PosObj2.W , PosObj2.H , Color1 , Color2 , 1 , 1 )
		Gdip_TextToGraphics(This.G, Text, "s" FontSize " c" Brush " Center vCenter Bold x" PosObj.X " y" PosObj.Y, Font , PosObj.W, PosObj.H)
		Gdip_DeleteBrush( Brush )
		( update ) ? ( This.UpdateWindow() )
	}
	Draw_Rectangle(Thickness:="5",PosObj:="",Color1:=0xFFFFFFFF,Color2:="",PosObj2:="",update:=0){
		local Brush, pPen
		(!color2)?(Color2:=Color1)
		(StrLen(Color1)=6)?( Color1 := "0xFF" Color1 )
		(StrLen(Color2)=6)?( Color2 := "0xFF" Color2 )
		(PosObj2="")?(PosObj2:=PosObj)
		Brush := Gdip_CreateLineBrushFromRect( PosObj2.X , PosObj2.Y , PosObj2.W , PosObj2.H , Color1 , Color2 , 1 , 1 )
		pPen := Gdip_CreatePenFromBrush(Brush, Thickness)
		Gdip_DrawRectangle( This.G, pPen, PosObj.X , PosObj.Y , PosObj.W , PosObj.H )
		Gdip_DeleteBrush( Brush )
		Gdip_DeletePen(pPen)
		( update ) ? ( This.UpdateWindow() )
	}
	Draw_Line(Thickness:="2",PosObj:="",Color1:="0xFF000000",Color2:="",Update:=0){
		local Brush, pPen
		(!color2)?(Color2:=Color1)
		(StrLen(Color1)=6)?( Color1 := "0xFF" Color1 )
		(StrLen(Color2)=6)?( Color2 := "0xFF" Color2 )
		(PosObj2="")?(PosObj2:=PosObj)
		Brush := Gdip_CreateLineBrushFromRect( PosObj2.X , PosObj2.Y , PosObj.W , PosObj.H , Color1 , Color2 , 1 , 1 )
		pPen := Gdip_CreatePenFromBrush(Brush, Thickness)
		Gdip_DrawLine(This.G, pPen, PosObj.X1 , PosObj.Y1 , PosObj.X2 , PosObj.Y2)
		Gdip_DeleteBrush( Brush )
		Gdip_DeletePen(pPen)
		( update ) ? ( This.UpdateWindow() )
	}
	Fill_Circle(PosObj:="",Color1:=0xFFFFFFFF,Color2:="",PosObj2:="",update:=0){
		local Brush
		(!color2)?(Color2:=Color1)
		(StrLen(Color1)=6)?( Color1 := "0xFF" Color1 )
		(StrLen(Color2)=6)?( Color2 := "0xFF" Color2 )
		(PosObj2="")?(PosObj2:=PosObj)
		Brush := Gdip_CreateLineBrushFromRect( PosObj2.X , PosObj2.Y , PosObj2.W , PosObj2.H , Color1 , Color2 , 1 , 1 )
		Gdip_FillEllipse(This.G, Brush, PosObj.X , PosObj.Y , PosObj.W , PosObj.H )
		Gdip_DeleteBrush( Brush )
		( update ) ? ( This.UpdateWindow() )
	}
	ColorButton( PosObj := "" , Label :="", Text :="Color Button", ButtonC1 :="0xFFFFFFFF", TextC1 :="0xFF000000", Roundness :=0, Font :="Arial", FontSizePlus := "10 Bold", ButtonC2 :="", TextC2 :=""){
		local Brush1, Brush2
		(!ButtonC2)?(ButtonC2:=ButtonC1)
		(!TextC2)?(TextC2:=TextC1)
		;~ ToolTip, % PosObj.x 
		Brush1 := Gdip_BrushCreateSolid(ButtonC1)
		Brush2 := Gdip_BrushCreateSolid(ButtonC2)
		Gdip_FillRoundedRectangle(This.G, Brush1, PosObj.X, PosObj.Y, PosObj.W, PosObj.H, Roundness)
		Gdip_FillRoundedRectangle(This.G, Brush2, PosObj.X+2, PosObj.Y+2, PosObj.W-4, PosObj.H-4, Roundness)
		Gdip_DeleteBrush( Brush1 ), Gdip_DeleteBrush( Brush2 )
		Brush1 := Gdip_BrushCreateSolid(TextC1)
		Brush2 := Gdip_BrushCreateSolid(TextC2)
		Gdip_TextToGraphics(This.G, Text, "s" FontSizePlus " c" Brush1 " Center vCenter x" PosObj.X " y" PosObj.Y+3, Font , PosObj.W, PosObj.H)
		Gdip_TextToGraphics(This.G, Text, "s" FontSizePlus " c" Brush2 " Center vCenter x" PosObj.X+1 " y" PosObj.Y+4, Font , PosObj.W, PosObj.H)
		if(Label){
			This.Add_Trigger(PosObj,Label)
		}
		
	}
	DeleteWindow( TurnOffGdip := 0 ){
		Gui, % This.Window " : Destroy"
		SelectObject( This.hdc , This.obm )
		DeleteObject( This.hbm )
		DeleteDC( This.hdc )
		Gdip_DeleteGraphics( This.G )
		( TurnOffGdip && This.Token ) ? ( Gdip_Shutdown( This.Token ) )
	}
}
