; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=132770&p=583213#p583213
#Requires AutoHotkey v2.0
;**************************************************************************************************************************************************************************
;00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 
;00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 
;00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 
;**************************************************************************************************************************************************************************
class Vector    {
    ;class: Vector v3.1 for ahk v2
    ;Purpose: Vector math class
    ;Author/Written By: HB
    ;Date Started: Aug 29th 2024
    ;Last Edit:
    ;Examples:
    ;
    ;
    ;Notes: 
    ;Forum post: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=132770&p=583213#p583213
    ;
    static RadToDeg := 45 / ATan( 1 )
    static DegToRad := ATan( 1 ) / 45
    static TestLineInterceptPoint( interceptPoint , Line1 , Line2 ){ ; Line = { Start: { X: , Y: } , End: { X: , Y: } } , interceptPoint = { X: , Y: }
        local Mx_Min := 0 , Mx_Max := 0 , Lx_Min := 0 , Lx_Max := 0 , My_Min := 0 , My_Max := 0 , Ly_Min := 0 , Ly_Max := 0

        for k , v in [ "X" , "Y" ]  {
            M%v%_Min := min( Line1.Start.%v% , Line1.End.%v% )
            M%v%_Max := max( Line1.Start.%v% , Line1.End.%v% )
			L%v%_Min := min( Line1.Start.%v% , Line1.End.%v% )
			L%v%_Max := max( Line1.Start.%v% , Line1.End.%v% )
        }

        if( !( interceptPoint.X < Mx_Min || interceptPoint.X > Mx_Max || interceptPoint.X < Lx_Min || interceptPoint.X > Lx_Max ) && !( interceptPoint.Y < My_Min || interceptPoint.Y > My_Max || interceptPoint.Y < Ly_Min || interceptPoint.Y > Ly_Max ) )
			return 1
		return 0

    }
	static GetLineInterceptPoint( Line1 , Line2 ){ ; Line = { Start: { X: , Y: } , End: { X: , Y: } }
		local A1 := Line1.End.Y - Line1.Start.Y
		,B1 := Line1.Start.X - Line1.End.X
		,C1 := A1 * Line1.Start.X + B1 * Line1.Start.Y
		,A2 := Line2.End.Y - Line2.Start.Y
		,B2 := Line2.Start.X - Line2.End.X
		,C2 := A2 * Line2.Start.X + B2 * Line2.Start.Y
		,Denominator := A1 * B2 - A2 * B1 
		return Vector( { X: ( ( B2 * C1 - B1 * C2 ) / Denominator )  , Y: ( ( A1 * C2 - A2 * C1 ) / Denominator ) } )
	}
    __New( x_or_Vector := "" , y := "" , setAngle := "" , rotateAngle := "" , mag := "" ){
        if( IsObject( x_or_Vector ) ){
            This.X := x_or_Vector.X
            This.Y := x_or_Vector.Y
        }else{
            ( x_or_Vector != "" )   || x_or_Vector := 10 
            ( y != "" )             || y := 10 
            This.X := x_or_Vector
            This.Y := y
        }
        ( setAngle = "" )       || ( This.Angle := setAngle )
        ( rotateAngle = "" )    || ( This.RotateAngle( rotateAngle ) )
        ( mag = "" )            || ( This.Mag := mag )
    }
    Angle{
        Get{
            local angle := Vector.RadToDeg * DllCall( "msvcrt\atan2" , "Double" , This.Y , "Double" , This.X , "CDECL Double" )
            ( angle >= 0 ) || angle += 360
            return angle
        }Set{
            local changeAngle , Co , Si , X2 , Y2 
            changeAngle := value - This.Angle 
            Co := Cos( Vector.DegToRad * changeAngle )
            Si := Sin( Vector.DegToRad * ChangeAngle )
            X2 := This.X * Co - This.Y * Si 
            Y2 := This.X * Si + This.Y * Co 
            This.X := X2 
            This.Y := Y2 
        }
    }
    RotateAngle( rotationAmount := 90 , NewVector := 0  ){
        local Co , Si , X2 , Y2
        Co := Cos( Vector.DegToRad * rotationAmount )
		Si := Sin( Vector.DegToRad * rotationAmount )
		X2 := This.X * Co - This.Y * Si 
		Y2 := This.X * Si + This.Y * Co 
        if( NewVector ){
            return Vector( X2 , Y2 )
        }else{
            This.X := X2 
            This.Y := Y2
        }
    }
    Mag{
        Get{
            return Sqrt( This.X * This.X + This.Y * This.Y )
        }Set{
            local mag := This.Mag
            This.X := This.X * value / mag
            This.Y := This.Y * value / mag
        }

    }
    Dist( x , y := "" ){
        if( IsObject( x ) )
            return Sqrt( ( ( This.X - x.X ) **2 ) + ( ( This.Y - x.Y ) **2 ) )
        else 
            return Sqrt( ( ( This.X - X ) **2 ) + ( ( This.Y - Y ) **2 ) )
    }
    MagSq(){
        return This.Mag**2
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
        local mag := This.Mag
		This.X /= mag
		This.Y /= mag
	}
    Mult( x , y := "" ){
		if( IsObject( x ) ){
			This.X *= x.X
			This.Y *= x.Y
		}else if( x && y = "" ){
			This.X *= x 
			This.Y *= x 
		}else{
			This.X *= X
			This.Y *= Y
		}
	}
    Div( x , y := "" ){
		if( IsObject( x ) ){
			This.X /= x.X
			This.Y /= x.Y
		}else if( x && y = "" ){
			This.X /= x 
			This.Y /= x 
		}else{
			This.X /= X
			This.Y /= Y
		}
	}
    Sub( x , y := "" ){
		if( IsObject( x ) ){
			This.X -= x.X
			This.Y -= x.Y
		}else if( y = "" ){
			This.X -= X
			This.Y -= X
		}else{
			This.X -= X
			This.Y -= Y
		}
	}
    Add( x , y := "" ){
		if( IsObject( x ) ){
			This.X += x.X
			This.Y += x.Y
		}else if( y = "" ){
			This.X += x 
			This.Y += x
		}else{
			This.X += x 
			This.Y += y 
		}
	}
    InRect( rect ){
        if( This.X >= rect.X )
            if( This.X <= rect.X + rect.W )
                if( This.Y >= rect.Y )
                    if( This.Y <= rect.Y + rect.H )
                        return 1
        return 0
    }
    static Line( startVector , endVector ){
        local lineObject := {}
        lineObject.Start := Vector( startVector )
        lineObject.End := Vector( endVector )
        return lineObject
    }
    Line( endVector ){
        return Vector.Line( This , endVector )
    }
    static Arrow( start , end , headLength := 30 , neckLength := 5 , armLength := 10 , elbowLength := 4 , scale := 1 , returnString := 1 ){
        local master 
        local head 
        local neck 
        local rightArm 
        local leftArm 
        local rightElbow
        local leftElbow
        local outputString
        local outputArray

        if( start.HasProp( "start" ) ){
            start := Vector( start.Start )
            end := Vector( start.End )
        }
        master := Vector( start )
        master.Sub( end )

        head := Vector( master )
        head.Mag := headLength * scale
        head.Add( end )

        neck := Vector( master )
        neck.Mag := neckLength * scale 
        neck.Add( head )

        rightArm := Vector( master ,,, -90 ) 
        rightArm.Mag := armLength * scale 
        rightArm.Add( neck )
        
        rightElbow := Vector( master ,,, -90 )
        rightElbow.Mag := elbowLength * scale 
        rightElbow.Add( head )

        leftArm := Vector( master ,,, 90 )
        leftArm.Mag := armLength * scale 
        leftArm.Add( neck )

        leftElbow := Vector( master ,,, 90 )
        leftElbow.Mag := elbowLength * scale
        leftElbow.Add( head )

        if( returnString ){
            outputString := ""
		    for k , v in [ "Start" , "RightElbow" , "RightArm" , "End" , "LeftArm" , "LeftElbow" , "Start" ]    {
		        if( k < 7 ){
			        outputString .= %v%.X "," %v%.Y "|"
                }else{
                    outputString .= %v%.X "," %v%.Y  
                }
            }

		    return outputString 

        }else{
            outputArray := []
            for k , v in [ "Start" , "RightElbow" , "RightArm" , "End" , "LeftArm" , "LeftElbow" , "Start" ]	
                outputArray.Push( %v% )
            return outputArray
        }
    }
    static PolygonShape( Home , Radius := 100 , Sides := 4 , StartAngle := 270 , Scale := 1 , ReturnString := 1 ){
        local master , rotation , vectorArray := [] , arm , outputString
        if( Sides < 3 ){
            MsgBox( "The shape needs a min of 3 sides" )
            return
        }
        master := Vector( 10 , 10 , StartAngle )
        master.Mag := Radius * Scale
        rotation := 360 / Sides
        arm := Vector( master )
        arm.Add( home )
        vectorArray.Push( arm )
        Loop Sides  {
            arm := Vector( master ,,, rotation * A_Index )
            arm.Add( home )
            vectorArray.Push( arm )
        }
        if( ReturnString ){
            outputString := ""
            loop vectorArray.Length {
                if( A_Index != vectorArray.Length )
                    outputString .= vectorArray[ A_Index ].X "," vectorArray[ A_Index ].Y "|"
                else  
                    outputString .= vectorArray[ A_Index ].X "," vectorArray[ A_Index ].Y 
            }
            return outputString
        }else{
            return vectorArray
        }
    }
    static Rect( x_or_Rect := "" , y := "" , w := "" , h := "" , scale := 1 , offsetRect := "" , saveRect := 0 ){
        static SavedRect := { X: 0 , Y: 0 , W: 100 , H: 100 }
        local rect := SavedRect.Clone()
        local x := x_or_Rect
        if( IsObject( x ) ){
            for k , v in StrSplit( "X|Y|W|H" , "|" )    {
                if( x.HasProp( v ) ){
                    if( x.%v% != "" )
                        rect.%v% := x.%v%
                }
            }
        }else{
            for k , v in StrSplit( "X|Y|W|H" , "|" )    {
                if( %v% != "" )
                    rect.%v% := %v%
            }
        }
        if( IsObject( offsetRect ) ){
            for k , v in StrSplit( "X|Y|W|H" , "|" )    {
                if( offsetRect.HasProp( v ) ){
                    if( offsetRect.%v% != "" && offsetRect.%v% != 0 ){
                        rect.%v% += offsetRect.%v% 
                    }
                }
            }
        }
        if( scale != 1 && scale != 0 && scale != "" ){
            for k , v in StrSplit( "X|Y|W|H" , "|" )    
                rect.%v% *= scale
        }
        if( saveRect )
            SavedRect := rect.Clone()
        return rect 
    }
    static MouseVector( Mode := "Screen" ){
        local x := "", y := "", lastMode := ""
        lastMode := CoordMode( "Mouse" , Mode )
        MouseGetPos &x , &y 
        CoordMode( "Mouse" , lastMode )
        return Vector( x , y )
    }
    static ArrayToString( vectorArray , Scale := 1 ){
        local outputString := "" , v := ""
        Loop vectorArray.Length   {
            v := vectorArray[ A_Index ]
            if( A_Index != vectorArray.Length )
                outputString .= v.X * scale "," v.Y * scale "|"
            else
                outputString .= v.X * scale "," v.Y * scale
        }
        return outputString
    }
    static StringToArray( stringPath , Scale := 1 ){
        local outputArray := []
        local vArr := StrSplit( stringPath , "|" , " " )
        local v := ""
        Loop vArr.Length    {
            v := StrSplit( vArr[ A_Index ] , "," )
            outputArray.Push( Vector( v[ 1 ] , v[ 2 ] ) )
        }
        return outputArray
    }
    static VectorToRect( topLeftVector , bottomRightVector ){
        local rect := {}
        rect.X := topLeftVector.X
        rect.Y := topLeftVector.Y
        rect.W := bottomRightVector.X - topLeftVector.X
        rect.H := bottomRightVector.Y - topLeftVector.Y
        return rect
    }
    static VectorToString( inputVector , valueSeparator := "," ){
        return inputVector.X . valueSeparator . inputVector.Y 
    }
    VectorToString( valueSeparator := "," ){
        return Vector.VectorToString( This , valueSeparator )
    }
    static RectToString( rect , scale := 1 , vSep := "," , pSep := "|" ){
        return rect.X * scale . vSep . rect.Y * scale . vSep . rect.W * scale . vSep . rect.H * scale . pSep
    }
    static StringToRect( InString , scale := 1 , vSep := "," , pSep := "|" ){
        local arr := [] , rect := {}
        InString := StrReplace( InString , pSep )
        arr := StrSplit( InString , vSep , A_Space )
        for k , v in StrSplit( "X|Y|W|H" , "|" )
            rect.%v% := arr[ k ]
        return rect
    }
    static BestFit( OuterRect , InnerRect , UpSizeInnerRect := 0 , Margin := 0 ){
        local w1 := "" , w2 := "" , h1 := "" , h2 := "" , x1 := "" , x2 := "" , y1 := "" , y2 := "" 
        x1 := OuterRect.X + Margin 
        y1 := OuterRect.Y + Margin
        w1 := OuterRect.W - 2 * Margin
        h1 := OuterRect.H - 2 * Margin
        x2 := InnerRect.X
        y2 := InnerRect.Y
        w2 := InnerRect.W
        h2 := InnerRect.H
        w2Mult := w2 / h2 
        h2Mult := h2 / w2 
        if( !( w2 <= w1 && h2 <= h1 && !UpSizeInnerRect ) ){
            if( w1 * h2Mult <= h1 ){
                w2 := w1 
                h2 := w2 * h2Mult 
            }else{
                h2 := h1 
                w2 := h2 * w2Mult
            }
        }
        x2 := x1 + ( ( w1 - w2 ) / 2 )
        y2 := y1 + ( ( h1 - h2 ) / 2 )
        for k , v in StrSplit( "X|Y|W|H" , "|" )    {
            InnerRect.%v% := %v%2
        }
    }
}
;**************************************************************************************************************************************************************************
;00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 
;00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 
;00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 00000 <<<>>> 00000 
;**************************************************************************************************************************************************************************


