; 1307
CandySel := A_Args[1]
Engzh := {",":"，", ".":"。", ":": "：", "?": "？", "!": "！", "(": "（", ")": "）"}
zhEng := {"，":",", "。":".", "：": ":", "？": "?", "！": "!", "（": "(", "）": ")"}
if CandySel
{
	if zhEng[CandySel]
		send % zhEng[CandySel]
	Else if Engzh[CandySel]
		send % Engzh[CandySel]
}
Else
{
	send +{Left}
	send ^c
	if zhEng[Clipboard]
		send % zhEng[Clipboard]
	Else if Engzh[Clipboard]
		send % Engzh[Clipboard]
}
return