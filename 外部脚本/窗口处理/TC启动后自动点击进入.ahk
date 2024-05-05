;|2.6|2024.05.03|1589
WinWait, ahk_class TNASTYNAGSCREEN
WinActivate, ahk_class TNASTYNAGSCREEN
ControlGetText, OutputVar, Window4, ahk_class TNASTYNAGSCREEN
if( OutPutVar == 3 )
{
	WinActivate, ahk_class TNASTYNAGSCREEN
	ControlClick, Button1, ahk_class TNASTYNAGSCREEN
	sleep 100
	cishu := 0
	while WinExist("ahk_class TNASTYNAGSCREEN")
	{
		WinActivate, ahk_class TNASTYNAGSCREEN
		ControlClick, Button1, ahk_class TNASTYNAGSCREEN
		cishu++
		if cishu > 5
			break
	}
}else if( OutPutVar == 2 ){
	WinActivate, ahk_class TNASTYNAGSCREEN
	ControlClick, Button2, ahk_class TNASTYNAGSCREEN
	sleep 100
	cishu := 0
	while WinExist("ahk_class TNASTYNAGSCREEN")
	{
		WinActivate, ahk_class TNASTYNAGSCREEN
		ControlClick, Button2, ahk_class TNASTYNAGSCREEN
		cishu++
		if cishu > 5
			break
	}
}else if( OutPutVar == 1 ){
	WinActivate, ahk_class TNASTYNAGSCREEN
	ControlClick, Button3, ahk_class TNASTYNAGSCREEN
	sleep 100
	cishu := 0
	while WinExist("ahk_class TNASTYNAGSCREEN")
	{
		WinActivate, ahk_class TNASTYNAGSCREEN
		ControlClick, Button3, ahk_class TNASTYNAGSCREEN
		cishu++
		if cishu > 5
			break
	}
}
return