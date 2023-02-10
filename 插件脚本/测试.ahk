!q::
FileAppend, %ClipboardAll%, %A_Desktop%\Clip.clip
return

/*
!q::
send ^l
SendInput javascript:document.querySelector("form input").value = '1234';document.querySelector('form').onsubmit()
return
*/

/*
!q::
robj:=dbGetTable("select * from history where actionobj =""无条件"" order by lastexectime desc LIMIT 24")
msgbox % robj[1] " - " robj[2] " - " robj[3]
return
*/