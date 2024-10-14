; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=83&t=132744&p=583099#p583097
#Requires AutoHotkey v2.0
;|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|
;|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|
;|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|<<<()>>>|
Class PopupWindow_v4  {
    ;Class: PopupWindow_v4
    ;Version: 4.1
    ;Date Started: Aug 18th, 2024
    ;Last Edit: Aug 23rd, 2024
    ;Notes: 
    ;Requires GDIP for ahk v2: https://raw.githubusercontent.com/buliasz/AHKv2-Gdip/master/Gdip_All.ahk
    ;
    ;
    ;Prototype: Gui1 := PopupWindow_v4( { Options: "+AlwaysOnTop" , Title: "Gui1" , Rect: { X: 0 , Y: 0 , W: 100 , H: 100 } } )
    static Windows  := [] 
    static Handles  := [] 
    static Index    := 0 
    static Busy     := 0 
    static Colors{
        Get{
            return [ "0xFF000000" , "0xFFC0C0C0" , "0xFF808080" , "0xFFFFFFFF" 
                , "0xFF800000" , "0xFFFF0000" , "0xFF800080" , "0xFFFF00FF" , "0xFF008000" 
                , "0xFF00FF00" , "0xFF808000" , "0xFFFFFF00" , "0xFF000080" , "0xFF0000FF" 
                , "0xFF008080" , "0xFF00FFFF" , "0xFF8000FF" ]
            }
        }
    static pToken{
        Get{
            if( !This.HasProp( "_pToken" ) ) 
                This._pToken := Gdip_Startup()
            return This._pToken
        }Set{
            if( !This.HasProp( "_pToken" ) )
                This._pToken := This.pToken
        }
    }
    static TipsTimer{
        Get{
            if( !This.HasProp( "_TipsTimer" ) )
                This._TipsTimer := This._TipsOff.Bind( This )
            return This._TipsTimer
        }
    }
    static Tips( msg , delay := 1500 ){
        ToolTip( msg )
        SetTimer( This.TipsTimer , Abs( delay ) * -1 )
    }
    static _TipsOff(){
        ToolTip
    }
    static _AddWindow( window ){
        local Index := ++This.Index , hwnd := window.Hwnd
        This.Windows.%Index% := window 
        This.Windows.%Index%.Index := This.Index
        This.Windows.%Index%.Name := window.Title
        This.Handles.%hwnd% := window
    }
    __New( DefaultsObject := "" , AutoShow := 1 , startGdip := 1 ){
        if( startGdip )
            PopupWindow_v4.pToken := ""
        This._SetDefaults( DefaultsObject )
        This._CreateWindow()
        This._CreateGraphics()
        if( AutoShow )
            This.Show( 1 )
        PopupWindow_v4._AddWindow( This )
        return This
    }
    Show( Activate := "" , FadeIn := 0 , FadeCycles := 10 , FadeDelay := 60 ){
        local fadeLevel := 0
        if( Activate )
            Activate := ""
        else 
            Activate := " NA "
        if( FadeIn ){
            This.Update( 0 )
            This.Window.Show( "x" This.X " y" This.Y " w" This.W " h" This.H " NA" )
            Loop FadeCycles || 10   {
                fadeLevel += 255 / FadeCycles
                This.Update( Floor( fadeLevel ) )
                Sleep( FadeDelay )
            }
            This.Update( 255 )
        }
        This.Window.Show( "x" This.X " y" This.Y " w" This.W " h" This.H " " Activate )
        This.IsVisable := 1
    }
    Hide( FadeOut := 0 , FadeCycles := 10 , FadeDelay := 60 , StartAlpha := "" ){
        local fadeLevel := 0
        This.IsVisable := 0
        if( !FadeOut ){
            This.Window.Hide()
            return 0
        }else{
            alpha := ( StartAlpha != "" ) ? ( StartAlpha ) : ( This.Alpha )
            fadeLevel := alpha
            This.Update( Floor( alpha ) )
            This.Show()
            Loop FadeCycles || 10   {
                fadeLevel -= alpha / FadeCycles
                if( fadeLevel < 0 )
                    fadeLevel := 0
                This.Update( Floor( fadeLevel ) )
                Sleep( FadeDelay )
            }
            This.Window.Hide()
            return 0
        }
        return 1
    }
    Update( alpha := "" ){
        if( alpha = "" )
            alpha := This.Alpha
        UpdateLayeredWindow( This.HWND , This.HDC , This.X , This.Y , This.W , This.H , Floor( Alpha ) )
    }
    Clear( AutoUpdate := 0 , Color := "" , Alpha := 255 ){
        if( Color ){
            if( StrLen( Color ) = 6 )
                Color := "0xFF" Color 
            else if( StrLen( Color ) <= 2 ){
                try
                    Color := PopupWindow_v4.Colors[ color ]
                catch 
                    Color := PopupWindow_v4.Colors[ 1 ]
            }
            Gdip_GraphicsClear( This.G , Color )
        }else{
            Gdip_GraphicsClear( This.G )
        }
        if( AutoUpdate ){
            if( Alpha )
                This.Update( Alpha )
            else 
                This.Update()
        }
    }
    Resize( autoShow := 1 , x := "" , y := "" , w := "" , h := "" , Scale := "" ){
    
        local oldWidth := This.W 
        local oldHeight := This.H
    
        if( IsObject( x ) ){
            for k , v in StrSplit( "X|Y|W|H" , "|" )  {
                if( x.HasProp( v ) )
                    This._%v% := x.%v% 
            }
        }else{
            for k , v in StrSplit( "X|Y|W|H" , "|" ) 
                if( %v% != "" )
                    This._%v% := %v%
        }
        if( oldWidth != This.W || oldHeight != This.H ){
            This._DestroyGraphics()
            This._CreateGraphics()
        }
        if( autoShow )
            This.Show()
    }
    Clip( rect := "" , alpha := "" , mode := 1 ){
        local clipRect := { X: 0 , Y: 0 , W: This.W , H: This.H }
        ( alpha != "" ) || alpha := This.Alpha
        if( IsObject( rect ) ){
            for k , v in StrSplit( "X|Y|W|H" , "|" )    {
                if( rect.HasProp( v ) )
                    clipRect.%v% := rect.%v%
            }
        }
        return Gdip_SetClipRect( This.G , clipRect.X , clipRect.Y , clipRect.W , clipRect.H , mode )
    }
    Close(){
        Try{
            PopupWindow_v4.Handles.DeleteProp( This.Hwnd )
            PopupWindow_v4.Windows.DeleteProp( This.Index )
            This._DestroyGraphics()
            This.Window.Destroy()
            This.Window := ""
            This := ""
        }catch{
            PopupWindow_v4.Tips( "Failed to use CLOSE method" )
        }
    }
    Destroy(){
        Try{
            This.Close()
        }catch{
            PopupWindow_v4.Tips( "Failed to use DESTROY method" )
        }
    }
    Delete(){
        Try{
            This.Close()
        }catch{
            PopupWindow_v4.Tips( "Failed to use DELETE method" )
        }
    }
    Rect( x_or_Rect := "" , y := "" , w := "" , h := "" , scale := "" , offsetRect := "" ){
        local rect := { X: 0 , Y: 0 , W: This.W , H: This.H }
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
        return rect 
    }
    _SetDefaults( DefaultsObject := "" ){
        This._DefaultOptions := " -DPIScale -Caption +LastFound +E0x80000 "
        This.Options := ""
        This.Title := "PopupWindow_4"
        This.Alpha := 255
        This.Scale := 1
        if( IsObject( DefaultsObject ) ){
            for k , v in DefaultsObject.OwnProps() {
                if( IsObject( DefaultsObject.%k% ) ){
                    for i , j in DefaultsObject.%k%.OwnProps()  {
                        if( InStr( "XYWH" , i ) )
                            This._%i% := j 
                        else
                            This.%k%.%i% := DefaultsObject.%k%.%i%
                    }
                }else if( InStr( "XYWH" , k ) )
                    This._%k% := v 
                else 
                    This.%k% := DefaultsObject.%k%
            }
        }
    }
    _CreateWindow(){
        This.Window := Gui( This._DefaultOptions . This.Options , This.Title )
        This._Hwnd := This.Window.Hwnd
    }
    _DestroyGraphics(){
        Gdip_DeleteGraphics( This.G )
        SelectObject( This.HDC , This.OBM )
        DeleteObject( This.HBM )
        DeleteDC( This.HDC )
    }
    _CreateGraphics(){
        This.Window.Opt( "+LastFound" )
        This.HBM := CreateDIBSection( This.W , This.H )
        This.HDC := CreateCompatibleDC()
        This.OBM := SelectObject( This.HDC , This.HBM )
        This.G := Gdip_GraphicsFromHDC( This.HDC )
        Gdip_SetSmoothingMode( This.G , This.Smoothing )
        Gdip_SetInterpolationMode( This.G , This.InterpolationMode )
    }
    Hwnd{
        Get{
            if( !This.HasProp( "_Hwnd" ) || This._Hwnd = "" )
                return 0
            return This._Hwnd
        }
    }
    Smoothing{
        Get{
            if( !This.HasProp( "_Smoothing") )
                This._Smoothing := 2
            return This._Smoothing
        }Set{
            if( value >= 1 && value <= 4 ){
                if( !This.HasProp( "_Smoothing") ){
                    This._Smoothing := value
                    return
                }
                This._Smoothing := value
                Gdip_SetSmoothingMode( This.G , This.Smoothing )
            }
        }
    }
    InterpolationMode{
        Get{
            if( !This.HasProp( "_InterpolationMode") )
                This._InterpolationMode := 7
            return This._InterpolationMode
        }Set{
            if( value >= 0 && value <= 7 ){
                if( !This.HasProp( "_InterpolationMode") ){
                    This._InterpolationMode := value
                    return
                }
                This._InterpolationMode := value
                Gdip_SetInterpolationMode( This.G , This.InterpolationMode )
            }
            }
    }
    X{
        Get{
            if( !This.HasProp( "_X" ) )
                This._X := 0
            return This._X
        }Set{
            PopupWindow_v4.Tips( "Use the RESIZE method to set the Window X position" )
        }
    }
    Y{
        Get{
            if( !This.HasProp( "_Y" ) )
                This._Y := 0
            return This._Y
        }Set{
            PopupWindow_v4.Tips( "Use the RESIZE method to set the Window Y position" )
        }
    }
    W{
        Get{
            if( !This.HasProp( "_W" ) )
                This._W := A_ScreenWidth
            return This._W
        }Set{
            PopupWindow_v4.Tips( "Use the RESIZE method to set the Window Width" )
        }
    }
    H{
        Get{
            if( !This.HasProp( "_H" ) )
                This._H := A_ScreenHeight
            return This._H
        }Set{
            PopupWindow_v4.Tips( "Use the RESIZE method to set the Window Height" )
        }
    }
}
