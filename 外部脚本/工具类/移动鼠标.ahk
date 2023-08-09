;|2.1|2023.07.21|1416
CandySel := A_Args[1]
if !CandySel
	return
CoordMode Mouse, Screen
Click, % CandySel
return