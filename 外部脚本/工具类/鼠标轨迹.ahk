;|2.6|2024.05.04|1590
;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;
;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;

;#Include gdip.ahk  		;<<<<<<<------------------------------

;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;
;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;

#SingleInstance, Force
SetBatchLines, -1
CoordMode, Mouse, Screen

;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;
;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;

Gdip_Startup()
AlphaList  := [ "F" , "E" , "D" , "C" , "B" , "A" , "9" , "8" , "7" , "6" , "5" , "4" , "3" , "2" , "1" , "0" ]
MaxIndex := AlphaList.Length()
Gui1 := New PopUpWindow( { AutoShow: 1 , X: 0 , +Y: 0 , W: A_ScreenWidth , H: A_ScreenHeight - 30 , Options: " -DPIScale +AlwaysOnTop +E0x20" } )

gosub, ^y

return

;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;
;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;

*ESC::ExitApp

;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;
;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;

^y::
	if( tog := !Tog ){
		MouseGetPos, x, y 
		CurrentPosition := New Vector( x , y )
		LastPosition := New Vector( CurrentPosition )
		Index := 0
		ResetIndex := 1
		scale := 0.5
		ArrowArray := []
		SetTimer, WatchCursor , 30
	}else{
		SetTimer, WatchCursor , Off
		Gui1.ClearWindow( 1 )
	}
	return 

;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;
;|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|000---<^>---000|;
		
WatchCursor:
	MouseGetPos, x, y 
	Gui1.ClearWindow()
		loop, % ln := ArrowArray.Length() 	{
			FillPolygon( Gui1.G , ArrowArray[ ln ].ArrowPoints , "0x" AlphaList[ ArrowArray[ ln ].Alpha1 ] "FFF0000" )
			;DrawPolygon( Gui1.G , ArrowArray[ ln ].ArrowPoints , "0x" AlphaList[ ArrowArray[ ln ].Alpha1 ] "F000000" , 3 )
			if( ++ArrowArray[ ln ].Alpha1 > ArrowArray[ ln ].MaxIndex )
					ArrowArray.RemoveAt(  ln  )
			ln--		
		}
	if( ++Index >= ResetIndex  && ( Abs( x - LastPosition.X ) > 30 ) || Abs( y - LastPosition.Y ) > 30 ){
		Index := 0	
		CurrentPosition := New Vector( x , y )
		Master := New Vector( LastPosition ) 
		Master.Sub( CurrentPosition )
		m := Master.GetMag() * 0.001
		Master.SetMag( m )
		Master.Add( LastPosition )
		MyArrow := New ArrowHead_2( Master , CurrentPosition , 25 * scale , 5 * scale , 15 * scale , 7 * scale )
		FillPolygon( Gui1.G , MyArrow , "0xFFFF0000" )
		;DrawPolygon( Gui1.G , MyArrow , "0xFF000000" , 3 )
		
		ArrowArray.Push( { ArrowPoints: MyArrow , Alpha1: 1 , MaxIndex: MaxIndex } )
		LastPosition := New Vector( CurrentPosition )
	}
	Gui1.UpdateWindow(155)	
	return

;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;
;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;
;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;

class ArrowHead_2	{
	
	__New( Start , End , HeadLength := 30 , NeckLength := 10 , ArmLength := 30 , ElbowLength := 15 ){
		
		Master := This._NewVector( Start )
		This._SubVector( Master , End )
		
		Head := This._NewVector( Master )
		This._SetVectorMag( Head , HeadLength )
		This._AddVector( Head , End )
		
		Neck := This._NewVector( Master )
		This._SetVectorMag( Neck , NeckLength )
		This._AddVector( Neck , Head )
		
		RightArm := This._NewVector( Master , , 1 )
		This._SetVectorMag( RightArm , ArmLength )
		This._AddVector( RightArm , Neck )
		
		RightElbow := This._NewVector( Master , , 1 )
		This._SetVectorMag( RightElbow , ElbowLength )
		This._AddVector( RightElbow , Head )
		
		LeftArm := This._NewVector( Master , , 2 )
		This._SetVectorMag( LeftArm , ArmLength )
		This._AddVector( LeftArm , Neck )
		
		LeftElbow := This._NewVector( Master , , 2 )
		This._SetVectorMag( LeftElbow , ElbowLength )
		This._AddVector( LeftElbow , Head )
		
		OutputString := ""
		for k , v in [ "Start" , "RightElbow" , "RightArm" , "End" , "LeftArm" , "LeftElbow" , "Start" ]	
			OutputString .= %v%.X "," %v%.Y "|"
		return OutputString 
	}
	
	_NewVector( x , y := "" , rotate := 0 ){
		if( IsObject( x ) ){
			if( !rotate )
				return { X: x.X , Y: x.Y }
			else if( rotate = 1 )
				return { X: x.Y * -1 , Y: x.X }
			else if( rotate = 2 )
				return { X: x.Y , Y: x.X * -1 }
		}else{
			if( !rotate )
				return { X: x , Y: x }
			else if( rotate = 1 )
				return { X: y * -1 , Y: x }
			else if( rotate = 2 )
				return { X: y , Y: x * -1 }
		}
	}
	
	_SubVector( vector1 , vector2 ){
		vector1.X -= vector2.X
		vector1.Y -= vector2.Y
	}
	
	_AddVector( vector1 , vector2 ){
		vector1.X += vector2.X
		vector1.Y += vector2.Y
	}
	
	_SetVectorMag( vector , mag ){
		local m := This._GetVectorMag( vector )
		vector.X := vector.X * mag / m
		vector.Y := vector.Y * mag / m
	}
	
	_GetVectorMag( vector ){
		return Sqrt( vector.X * vector.X + vector.Y * vector.Y )
		
	}
	
}

;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;
;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;
;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;

Class Vector	{
	;Written By: HB
	;Date: Sept 23rd, 2022
	;Last Edit: Sept 24th, 2022
	;Purpose: Vector math class 
	;Credit: Rohwedder 
	;Resources: 
		;Line intercept concepts and code: https://www.autohotkey.com/boards/viewtopic.php?f=76&t=37175
		;Create an Arrow: https://www.autohotkey.com/boards/viewtopic.php?f=76&t=92039&p=479129#p478944
		;Getting an angle: https://www.autohotkey.com/boards/viewtopic.php?f=76&t=108760&p=483661#p483678
		;Setting an Angle: https://www.autohotkey.com/boards/viewtopic.php?f=76&t=108760&p=483786#p483811
		;
		
	static RadToDeg := 45 / ATan( 1 ) 
		, DegToRad := ATan( 1 ) / 45 
		
	__New( x := 0 , y := 0 , rotate := 0 ){ 
		if( IsObject( x ) ){
			if( rotate = 3 ){
				This.X := x.X * -1
				,This.Y := x.Y * -1
			}else if( rotate = 2 ){
				This.X := x.Y 
				,This.Y := x.X * -1
			}else if( rotate = 1 ){
				This.X := x.Y * -1
				,This.Y := x.X 
			}else{
				This.X := x.X
				,This.Y := x.Y
			}
		}else{
			if( rotate = 3 ){
				This.X := X * -1
				,This.Y := Y * -1
			}else if( rotate = 2 ){
				This.X := Y 
				,This.Y := X * -1
			}else if( rotate = 1 ){
				This.X := Y * -1
				,This.Y := X 
			}else{
				This.X := X
				,This.Y := Y
			}
		}
	}
	
	Add( x , y := "" ){
		if( IsObject( x ) ){
			This.X += x.X
			,This.Y += x.Y
		}else if( y = "" ){
			This.X += x 
			,This.Y += x
		}else{
			This.X += x 
			,This.Y += y 
		}
	}
	Sub( x , y := "" ){
		if( IsObject( x ) ){
			This.X -= x.X
			,This.Y -= x.Y
		}else if( y = "" ){
			This.X -= X
			,This.Y -= X
		}else{
			This.X -= X
			,This.Y -= Y
		}
	}
	Div( x , y := "" ){
		if( IsObject( x ) ){
			This.X /= x.X
			,This.Y /= x.Y
		}else if( x && y = "" ){
			This.X /= x 
			,This.Y /= x 
		}else{
			This.X /= X
			,This.Y /= Y
		}
	}
	Mult( x , y := "" ){
		if( IsObject( x ) ){
			This.X *= x.X
			,This.Y *= x.Y
		}else if( x && y = "" ){
			This.X *= x 
			,This.Y *= x 
		}else{
			This.X *= X
			,This.Y *= Y
		}
	}
	Dist( x , y := "" ){
		if( IsObject( x ) )
			return Sqrt( ( ( This.X - x.X ) **2 ) + ( ( This.Y - x.Y ) **2 ) )
		else 
			return Sqrt( ( ( This.X - X ) **2 ) + ( ( This.Y - Y ) **2 ) )
	}
	GetMag(){
		return Sqrt( This.X * This.X + This.Y * This.Y )
	}
	SetMag( magnitude ){
		local m := This.GetMag()
		This.X := This.X * magnitude / m
		,This.Y := This.Y * magnitude / m
	}
	MagSq(){
		return This.GetMag()**2
	}	
	Dot( x , y := "" ){
		if( IsObject( x ) )
			return ( This.X * x.X ) + ( This.Y * x.Y )
		else
			return ( This.X * X ) + ( This.Y * Y )
	}
	Cross( x , y := "" ){
		if( IsObject( x ) )
			return This.X * x.Y - This.Y * x.X
		else
			return This.X * Y - This.Y * X
		
	}
	Norm(){
		local m := This.GetMag()
		This.X /= m
		This.Y /= m
	}
	GetAngle(){ 
		local angle 
		( (  angle := Vector.RadToDeg * DllCall( "msvcrt\atan2" , "Double" , This.Y , "Double" , This.X , "CDECL Double" ) ) < 0 ) ? ( angle += 360 )
		return angle
	}
	SetAngle( newAngle := 0 , NewVector := 0 ){
		local Angle := This.GetAngle()
		, ChangeAngle := newAngle - Angle 
		, Co := Cos( Vector.DegToRad * ChangeAngle )
		, Si := Sin( Vector.DegToRad * ChangeAngle )
		, X := This.X 
		, Y := This.Y
		, X2 := X * Co - Y * Si 
		, Y2 := X * Si + Y * Co 
		
		if( !NewVector )
			This.X := X2 , This.Y := Y2
		else 
			return New Vector( X2 , Y2 )
	}
	RotateAngle( rotationAmount := 90 , NewVector := 0 ){
		local Co := Cos( Vector.DegToRad * rotationAmount )
		, Si := Sin( Vector.DegToRad * rotationAmount )
		, X := This.X 
		, Y := This.Y
		, X2 := X * Co - Y * Si 
		, Y2 := X * Si + Y * Co 
		if( !NewVector )
			This.X := X2 , This.Y := Y2
		else 
			return New Vector( X2 , Y2 )
	}
	;********************************************
	;class methods
	TestLineInterceptPoint( interceptPoint , Line1 , Line2 ){ ; Line = { Start: { X: , Y: } , End: { X: , Y: } } , interceptPoint = { X: , Y: }
		local
		for k , v in [ "X" , "Y" ]	
			M%v%_Min := min( Line1.Start[ v ] , Line1.End[ v ] )
			,M%v%_Max := max( Line1.Start[ v ] , Line1.End[ v ] )
			,L%v%_Min := min( Line2.Start[ v ] , Line2.End[ v ] )
			,L%v%_Max := max( Line2.Start[ v ] , Line2.End[ v ] )
		if( !( interceptPoint.X < Mx_Min || interceptPoint.X > Mx_Max || interceptPoint.X < Lx_Min || interceptPoint.X > Lx_Max ) && !( interceptPoint.Y < My_Min || interceptPoint.Y > My_Max || interceptPoint.Y < Ly_Min || interceptPoint.Y > Ly_Max ) )
			return 1
		return 0
	}
	GetLineInterceptPoint( Line1 , Line2 ){ ; Line = { Start: { X: , Y: } , End: { X: , Y: } }
		local A1 := Line1.End.Y - Line1.Start.Y
		,B1 := Line1.Start.X - Line1.End.X
		,C1 := A1 * Line1.Start.X + B1 * Line1.Start.Y
		,A2 := Line2.End.Y - Line2.Start.Y
		,B2 := Line2.Start.X - Line2.End.X
		,C2 := A2 * Line2.Start.X + B2 * Line2.Start.Y
		,Denominator := A1 * B2 - A2 * B1 
		return New Vector( { X: ( ( B2 * C1 - B1 * C2 ) / Denominator )  , Y: ( ( A1 * C2 - A2 * C1 ) / Denominator ) } )
	}
	;********************************************
	
}

;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;
;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;
;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;

class PopUpWindow	{
;PopUpWindow v2.2
;Date Written: Oct 28th, 2021
;Last Edit: Feb 7th, 2022 :Changed the trigger method.
;Written By: Hellbent aka CivReborn
;SpcThanks: teadrinker , malcev 
	static Index := 0 , Windows := [] , Handles := [] , EditHwnd , HelperHwnd
	__New( obj := "" ){
		This._SetDefaults()
		This.UpdateSettings( obj )
		This._CreateWindow()
		This._CreateWindowGraphics()
		if( This.AutoShow )
			This.ShowWindow( This.Title )
	}
	_SetDefaults(){
		This.X := 10
		This.Y := 10
		This.W := 10
		This.H := 10
		This.Smoothing := 2
		This.Options := " -DPIScale +AlwaysOnTop "
		This.AutoShow := 0
		This.GdipStartUp := 0
		This.Title := ""
		
		This.Controls := []
		This.Handles := []
		This.Index := 0 
	}
	AddTrigger( obj ){
		local k , v , cc , bd
		
		This.Controls[ ++This.Index ] := { 	X:		10
										,	Y:		10
										,	W:		10
										,	H:		10	}
		for k, v in obj
			This.Controls[ This.Index ][ k ] := obj[ k ] 
		cc := This.Controls[ This.Index ]
		Gui, % This.Hwnd ":Add", Text, % "x" cc.X " y" cc.Y " w" cc.W " h" cc.H " hwndhwnd"
		This.Handles[ hwnd ] := This.Index
		This.Controls[ This.Index ].Hwnd := hwnd
		
		if( IsObject( cc.Label ) ){
			bd := cc.Label
			GuiControl, % This.Hwnd ":+G" , % hwnd , % bd
		}else{
			bd := This._TriggerCall.Bind( This )
			GuiControl, % This.Hwnd ":+G" , % hwnd , % bd
		}
		return hwnd
		
	}
	_TriggerCall(){
		MouseGetPos,,,, ctrl, 2
		Try
			;~ SetTimer, % This.Controls[ This.Handles[ ctrl ] ].Label, -0
			gosub, % This.Controls[ This.Handles[ ctrl ] ].Label
		
				
	}
	DrawTriggers( color := "0xFFFF0000" , AutoUpdate := 0 ){
		local brush , cc 
		Brush := Gdip_BrushCreateSolid( color ) 
		Gdip_SetSmoothingMode( This.G , 3 )
		loop, % This.Controls.Length()	{
			cc := This.Controls[ A_Index ]
			Gdip_FillRectangle( This.G , Brush , cc.x , cc.y , cc.w , cc.h )
		
		}
		Gdip_DeleteBrush( Brush )
		Gdip_SetSmoothingMode( This.G , This.Smoothing )
		if( AutoUpdate )
			This.UpdateWindow()
	}
	UpdateSettings( obj := "" , UpdateGraphics := 0 ){
		local k , v
		if( IsObject( obj ) )
			for k, v in obj
				This[ k ] := obj[ k ]
		( This.X = "Center" ) ? ( This.X := ( A_ScreenWidth - This.W ) / 2 ) 	
		( This.Y = "Center" ) ? ( This.Y := ( A_ScreenHeight - This.H ) / 2 ) 	
		if( UpdateGraphics ){
			This._DestroyWindowsGraphics()
			This._CreateWindowGraphics()
		}
	}
	_CreateWindow(){
		local hwnd
		Gui , New, % " +LastFound +E0x80000 hwndhwnd Toolwindow -Caption  " This.Options
		PopUpWindow.Index++
		This.Index := PopUpWindow.Index
		PopUpWindow.Windows[ PopUpWindow.Index ] := This
		This.Hwnd := hwnd
		PopUpWindow.Handles[ hwnd ] := PopUpWindow.Index
		if( This.GdipStartUp && !PopUpWindow.pToken )
			PopUpWindow.pToken := GDIP_STARTUP()
	}
	_DestroyWindowsGraphics(){
		Gdip_DeleteGraphics( This.G )
		SelectObject( This.hdc , This.obm )
		DeleteObject( This.hbm )
		DeleteDC( This.hdc )
	}
	_CreateWindowGraphics(){
		This.hbm := CreateDIBSection( This.W , This.H )
		This.hdc := CreateCompatibleDC()
		This.obm := SelectObject( This.hdc , This.hbm )
		This.G := Gdip_GraphicsFromHDC( This.hdc )
		Gdip_SetSmoothingMode( This.G , This.Smoothing )
	}
	ShowWindow( Title := "" ){
		Gui , % This.Hwnd ":Show", % "x" This.X " y" This.Y " w" This.W " h" This.H " NA", % Title
	}
	HideWindow(){
		Gui , % This.Hwnd ":Hide",
	}
	UpdateWindow( alpha := 255 ){
		UpdateLayeredWindow( This.hwnd , This.hdc , This.X , This.Y , This.W , This.H , alpha )
	}
	ClearWindow( AutoUpdate := 0 ){
		Gdip_GraphicsClear( This.G )
		if( Autoupdate )
			This.UpdateWindow()
	}
	DrawBitmap( pBitmap , obj , dispose := 1 , AutoUpdate := 0 ){
		Gdip_DrawImage( This.G , pBitmap , obj.X , obj.Y , obj.W , obj.H )
		if( dispose )
			Gdip_DisposeImage( pBitmap )
		if( Autoupdate )
			This.UpdateWindow()
	}
	PaintBackground( color := "0xFF000000" , AutoUpdate := 0 ){
		if( isObject( color ) ){
			Brush := Gdip_BrushCreateSolid( ( color.HasKey( "Color" ) ) ? ( color.Color ) : ( "0xFF000000" ) ) 
			if( color.Haskey( "Round" ) )
				Gdip_FillRoundedRectangle( This.G , Brush , color.X , color.Y , color.W , color.H , color.Round )
			else
				Gdip_FillRectangle( This.G , Brush , color.X , color.Y , color.W , color.H ) 
		}else{
			Brush := Gdip_BrushCreateSolid( color ) 
			Gdip_FillRectangle( This.G , Brush , -1 , -1 , This.W + 2 , This.H + 2 ) 
		}
		Gdip_DeleteBrush( Brush )
		if( AutoUpdate )
			This.UpdateWindow()
	}
	DeleteWindow( GDIPShutdown := 0 ){
		Gui, % This.Hwnd ":Destroy"
		SelectObject( This.hdc , This.obm )
		DeleteObject( This.hbm )
		DeleteDC( This.hdc )
		Gdip_DeleteGraphics( This.G )
		hwnd := This.Hwnd
		for k, v in PopUpWindow.Windows[ Hwnd ]
			This[k] := ""
		PopUpWindow.Windows[ Hwnd ] := ""
		if( GDIPShutdown ){
			Gdip_Shutdown( PopUpWindow.pToken )
			PopUpWindow.pToken := ""
		}
	}
	_OnClose( wParam ){
		if( wParam = 0xF060 ){	;SC_CLOSE ;[ clicking on the gui close button ]
			Try{
				Gui, % PopUpWindow.HelperHwnd ":Destroy"
				SoundBeep, 555
			}
		}
	}
	CreateCachedBitmap( pBitmap , Dispose := 0 ){
		local pCachedBitmap
		if( This.CachedBitmap )
			This.DisposeCachedbitmap()
		DllCall( "gdiplus\GdipCreateCachedBitmap" , "Ptr" , pBitmap , "Ptr" , this.G , "PtrP" , pCachedBitmap )
		This.CachedBitmap := pCachedBitmap
		if( Dispose )
			Gdip_DisposeImage( pBitmap )
	}
	DrawCachedBitmap( AutoUpdate := 0 ){
		DllCall( "gdiplus\GdipDrawCachedBitmap" , "Ptr" , this.G , "Ptr" , This.CachedBitmap , "Int" , 0 , "Int" , 0 )
		if( AutoUpdate )
			This.UpdateWindow()
	}
	DisposeCachedbitmap(){
		DllCall( "gdiplus\GdipDeleteCachedBitmap" , "Ptr" , This.CachedBitmap )
	}
	Helper(){
		local hwnd , MethodList := ["__New","UpdateSettings","ShowWindow","HideWindow","UpdateWindow","ClearWindow","DrawBitmap","PaintBackground","DeleteWindow" , "AddTrigger" , "DrawTriggers", "CreateCachedBitmap" , "DrawCachedBitmap" , "DisposeCachedbitmap" ]
		Gui, New, +AlwaysOnTop +ToolWindow +HwndHwnd
		PopUpWindow.HelperHwnd := hwnd
		Gui, Add, Edit, xm ym w250 r1 Center hwndhwnd, Gui1
		PopUpWindow.EditHwnd := hwnd
		loop, % MethodList.Length()	
			Gui, Add, Button, xm y+1 w250 r1 gPopUpWindow._HelperClip, % MethodList[ A_Index ]
		Gui, Show,,
		OnMessage( 0x112 , This._OnClose.Bind( hwnd ) )
	}
	_HelperClip(){
		local ClipList 
		
		GuiControlGet, out, % PopUpWindow.HelperHwnd ":", % PopUpWindow.EditHwnd	
		
		ClipList := 		{ 	__New: 					" := New PopUpWindow( { AutoShow: 1 , X: 0 , Y: 0 , W: A_ScreenWidth , H: A_ScreenHeight , Options: "" -DPIScale +AlwaysOnTop "" } )"
							,	UpdateSettings:			".UpdateSettings( { X: """" , Y: """" , W: """" , H: """" } , UpdateGraphics := 0 )"
							,	ShowWindow:				".ShowWindow( Title := """" )"
							,	HideWindow:				".HideWindow()"
							,	UpdateWindow:			".UpdateWindow()"
							,	ClearWindow:			".ClearWindow( AutoUpdate := 0 )"
							,	DrawBitmap:				".DrawBitmap( pBitmap := """" , { X: 0 , Y: 0 , W: " Out ".W , H: " Out ".H } , dispose := 1 , AutoUpdate := 0 )"
							,	PaintBackground:		".PaintBackground( color := ""0xFF000000"" , AutoUpdate := 0 )  "  ";{ Color: ""0xFF000000"" , X: 2 , Y: 2 , W: " Out ".W - 4 , H: " Out ".H - 4 , Round: 10 }"
							,	DeleteWindow:			".DeleteWindow( GDIPShutdown := 0 )"
							,	AddTrigger:				".AddTrigger( { X: """" , Y: """" , W: """" , H: """" , Value: """" , Label: """" } )"	
							,	DrawTriggers:			".DrawTriggers( color := ""0xFFFF0000"" , AutoUpdate := 0 )"	
							,	CreateCachedBitmap:		".CreateCachedBitmap( pBitmap , Dispose := 0 )"	
							,	DrawCachedBitmap: 		".DrawCachedBitmap( AutoUpdate := 0 )"	
							,	DisposeCachedbitmap:	".DisposeCachedbitmap()"	}
							
		clipboard := Out ClipList[ A_GuiControl ]
		
	}
}

;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;
;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;
;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;

FillPolygon( G , Points := "50 , 50 | 100 , 100 | 150 , 50 | 50 , 50 " , Color := "0xFFFF0000" ){
	Brush := Gdip_BrushCreateSolid( Color ) , Gdip_FillPolygon( G , Brush , Points ) , Gdip_DeleteBrush( Brush )
}

DrawPolygon( G , Points := "50 , 50 | 100 , 100 | 150 , 50 | 50 , 50 " , Color := "0xFF000000" , Thickness := 3 ){
	Pen := Gdip_CreatePen( Color , Thickness ) , Gdip_DrawLines( G , Pen , Points ) , Gdip_DeletePen( Pen )
}

;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;
;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;
;| ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) | ((((()))))***^|^***((((())))) |;








