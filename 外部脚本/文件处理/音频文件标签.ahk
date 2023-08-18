;|2.1|2023.07.28|1397
#SingleInstance force
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\ec4f.ico"
CandySel := A_Args[1]
ChooseFile := CandySel

;_____________________________________
; A Very Simple Version Of tag Editor with minimalistic Requirements and interface
; Good Example of Audiogenie 
; Author - Rajat Kosh
; Email - rajatkosh2153@gmail.com
;_______________________________
;Add Gui Element
Gui, Add, Edit, x12 y9 w410 h20 ReadOnly vfile_dir, 
Gui, Add, Button, x320 y39 w100 h20 gButtonBrowse, 浏览
Gui, Add, Text, x12 y69 w120 h30, 参与创作的艺术家
Gui, Add, Text, x12 y99 w120 h30, 唱片集
Gui, Add, Text, x12 y129 w120 h30, #
Gui, Add, Text, x12 y159 w120 h30, 标题
Gui, Add, Text, x12 y189 w120 h30, 年
Gui, Add, Text, x12 y219 w120 h30, 流派
Gui, Add, Text, x12 y249 w120 h30, 注释
Gui, Add, Edit, x132 y69 w290 h20 vArtist, 
Gui, Add, Edit, x132 y99 w290 h20 vAlbum, 
Gui, Add, Edit, x132 y129 w290 h20 vTrack,
Gui, Add, Edit, x132 y159 w290 h20 vTitle, 
Gui, Add, Edit, x132 y189 w290 h20 vYear, 
Gui, Add, Edit, x132 y219 w290 h20 vGenre, 
Gui, Add, Edit, x132 y249 w290 h20 vComments, 
Gui, Add, Button, x142 y389 w100 h30 gButtonSave, 保存
Gui, Add, pic, x12 y279 w90 h90 vAlb_art,
Gui, Add, GroupBox, x12 y279 w110 h100, 专辑封面
Gui, Add, Button, x132 y289 w110 h20 gButtonAddAlbumArt, 添加专辑封面
Gui, Add, Button, x132 y319 w110 h20 gButtonRemoveAlbumArt, 移除专辑封面
Gui, Add, Text, x132 y344 w150 h30 vcovertype, 0/0 没有封面

; Multiple cover navigation Symbols
Symbollft := Chr(9664)
Symbolrit := Chr(9654)
; Add them to GUI as Button
Gui, Add, button, x132 y370 w17 h17 vprcov gupdwn, %Symbollft%	;Up down
Gui, Add, button, x149 y370 w17 h17 vnxcov gupupn, %Symbolrit%	;Up Next
;Disable them (by default)
GuiControl, disable, prcov
GuiControl, disable, nxcov
;Show the GUI
Gui, Show, w450 h441, 标签编辑
if A_PtrSize = 8
	DllCall( "LoadLibrary", Str, A_ScriptDir "\..\..\引用程序\x64\AudioGenie3.dll" )  ; 成功返回内存地址
else
	DllCall( "LoadLibrary", Str, A_ScriptDir "\..\..\引用程序\x32\AudioGenie3.dll" )
DllCall( "AudioGenie3\AUDIOAnalyzeFileW", Str,Dummy ) ; Dummy Call
gosub reload_same_file
return

;################################################   OPEN FILE #################################################
ButtonBrowse: ;Prompt User For Opening the file
FileSelectFile, ChooseFile,,, 请选择音频文件(不要选择视频文件), 支持的文件类型(*.mp3;*.mp2;*.mp1;*.ogg;*.oga;*.wav;*.aif;*.aiff;*.aifc;*.flac;*.wma;*.wmv;*.wmp;*.asf;*.aac;*.mp4;*.m4a;*.m4b;*.m4p;*.wv;*.wvc;*.ape;*.mpc;*.mpp;*.mp+;*.ac3;*.spx;*.tta;*.opus;)

if Choosefile=  ; IF no file is selected
{
	return
}
reload_same_file: ;Jump here in case of refreshing the data 
GuiControl,, file_dir, %ChooseFile%
loop, %ChooseFile%
{
  DllCall("AudioGenie3.dll\AUDIOAnalyzeFileW", Str, A_LoopFileFullPath )
}  
SplitPath, Choosefile,,, FileExtn  ; Get Extension

;Get Information in Fields According to file type 
if FileExtn in MP3,AAC,MPP,TTA 
{
	Trackinfo := DllCall("AudioGenie3\ID3V2GetTextFrameW", uint, 1414677323, wstr) 
	Titleinfo := DllCall("AudioGenie3\ID3V2GetTextFrameW", uint, 1414091826, wstr) 
	Artistinfo := DllCall("AudioGenie3\ID3V2GetTextFrameW", uint, 1414546737, wstr) 
	Albuminfo := DllCall("AudioGenie3\ID3V2GetTextFrameW", uint, 1413565506, wstr) 
	Genreinfo := DllCall("AudioGenie3\ID3V2GetTextFrameW", uint, 1413697358, wstr) 
	Yearinfo := DllCall("AudioGenie3\ID3V2GetTextFrameW", uint, 1415136594, wstr)  
	Composerinfo := DllCall("AudioGenie3\ID3V2GetTextFrameW", uint, 1413697357, wstr) 
	Commentinfo := DllCall("AudioGenie3\ID3V2GetTextFrameW", uint, 1129270605, wstr)
}
else
{
	Artistinfo := DllCall("AudioGenie3\AUDIOGetArtistW", wstr)
	Albuminfo := DllCall("AudioGenie3\AUDIOGetAlbumW", wstr)
	Yearinfo := DllCall("AudioGenie3\AUDIOGetYearW", wstr)
	Genreinfo := DllCall("AudioGenie3\AUDIOGetGenreW", wstr)
	Trackinfo := DllCall("AudioGenie3\AUDIOGetTrackW", wstr)
	Titleinfo := DllCall("AudioGenie3\AUDIOGetTitleW", wstr)
	Commentinfo := DllCall("AudioGenie3\AUDIOGetCommentW", wstr)
	Composerinfo := DllCall("AudioGenie3\AUDIOGetComposerW", wstr)
}    

;Set Data into the fields 
GuiControl,, Title, %Titleinfo%
GuiControl,, Artist, %Artistinfo%
GuiControl,, Album, %Albuminfo%
GuiControl,, Year, %Yearinfo%
GuiControl,, Track, %Trackinfo%
GuiControl,, Comments, %Commentinfo%
GuiControl,, Genre, %Genreinfo%

;Check for Cover Art in temp folder, Delete if already exists
IfExist, %A_Temp%\AlbumArt.jpg
FileDelete, %A_Temp%\AlbumArt.jpg
IfExist, %A_Temp%\AlbumArt.png
FileDelete, %A_Temp%\AlbumArt.png

;Retrieve the cover art from the file
;Check all possible cover art and extract them into the temp folder for showing onto GUI

;###########################  MP4   ########################
Mime := DllCall("AudioGenie3\MP4GetPictureMimeW",uint, 01,wstr)
	IfInString, Mime, jpg
		DllCall("AudioGenie3\MP4GetPictureFileW", wstr, A_Temp "\AlbumArt.jpg", uint, 01)
	else 
		DllCall("AudioGenie3\MP4GetPictureFileW", wstr, A_Temp "\AlbumArt.png", uint, 01)

;###########################  FLAC   ########################
Mime := DllCall("AudioGenie3\FLACGetPictureMimeW",uint, 01,wstr)
	IfInString, Mime, jpeg
		DllCall("AudioGenie3\FLACGetPictureFileW", wstr, A_Temp "\AlbumArt.jpg", uint, 01)
	else 
		DllCall("AudioGenie3\FLACGetPictureFileW", wstr, A_Temp "\AlbumArt.png", uint, 01)

;###########################  MP3   ########################
Mime := DllCall("AudioGenie3\ID3V2GetPictureMimeW",uint, 01,wstr)
	IfInString, Mime, jpeg
		DllCall("AudioGenie3\ID3V2GetPictureFileW", wstr, A_Temp "\AlbumArt.jpg", uint, 01)
	else 
		DllCall("AudioGenie3\ID3V2GetPictureFileW", wstr, A_Temp "\AlbumArt.png", uint, 01)

;###########################  WMA   ########################
Mime := DllCall("AudioGenie3\WMAGetPictureMimeW",uint, 01,wstr)
	if(Mime = jpg)
		DllCall("AudioGenie3\WMAGetPictureFileW", wstr, A_Temp "\AlbumArt.jpg", uint, 01)
	else (Mime = png)
		DllCall("AudioGenie3\WMAGetPictureFileW", wstr, A_Temp "\AlbumArt.png", uint, 01)

; Set Extracted Cover Art onto the GUI

IfExist, %A_Temp%\AlbumArt.png 	; Check if PNG
	GuiControl,, Alb_art, *w90 *h90 %A_Temp%\AlbumArt.png
IfNotExist, %A_Temp%\AlbumArt.png	;If not PNG
{
	IfExist, %A_Temp%\AlbumArt.jpg	;Check JPG
		GuiControl,, Alb_art, *w90 *h90 %A_Temp%\AlbumArt.jpg
	else	;If not JPG then Set Empty
		GuiControl,, Alb_art, *w90 *h90 empty.png
}

;Now Check For Cover Description info and Total No. of Covers
; First CHeck For MP3
covertypeinfo := DllCall("AudioGenie3\ID3V2GetPictureTypeTextW", uint, 1, wstr) 
coverSize := DllCall("AudioGenie3\ID3V2GetPictureSizeW", uint, 1) 
PicNum := DllCall("AudioGenie3\ID3V2GetFrameCountW", uint, 1095780675)

if covertypeinfo=	;If Not in MP3
{
	;Check in FLAC
	Covertypeinfo := DllCall("AudioGenie3\FLACGetPictureTypeTextW", uint, 01, wstr)
	coverSize := DllCall("AudioGenie3\FLACGetPictureSizeW", uint, 1) 
	Picnum := DllCall("AudioGenie3\FLACGetPictureCountW", uint, 1, uint)
	Picnum := Picnum - 9568256

if covertypeinfo=	;If not in FLAC, check for mp4
{
	Covertypeinfo= 没有描述信息
	coverSize := DllCall("AudioGenie3\MP4GetPictureSizeW", uint, 1) 
	Picnum := DllCall("AudioGenie3\MP4GetPictureCountW", uint, 1)

	if coverSize=	;Else check in WMA
	{
		coverSize:= DllCall("AudioGenie3\WMAGetPictureSizeW", uint, 1) 
		Picnum := DllCall("AudioGenie3\WMAGetPictureCountW", uint, 1)
	}
}
}
Updown := 1	;Set Value of Current (Default) Cover Art index to 1
;Set information of cover Art
GuiControl,, covertype,%Updown%/%Picnum% %Covertypeinfo% - %coverSize% Bytes

if (Picnum <= 1) ;PicNum = Total Number of Pictures in Tag
{
	GuiControl, disable, prcov
	GuiControl, disable, nxcov
	if (Picnum < 1)
	{
		Updown := 0
	}
}
else
{
	GuiControl, enable, prcov
	GuiControl, enable, nxcov
}

return

;########################################  Change Album Art ##############################################################

ButtonAddAlbumArt:
Gui +OwnDialogs  ; Forces user to dismiss the following dialog before using main window.
FileSelectFile, CoverFile, 3,, Choose Your Cover Art, Image Files(*.jpg;*.jpeg;*.png;) ; Select Cover File
if CoverFile=	; IF Empty, then return
    return

;Else Set Cover Art according to supproted format type
; Note - A Random no. is required in order to create a unique ID because No two frames of cover Art (Multiple Art)
; 		 Can have the same Description
CoverType = 3 ; Default Index For Front Cover

 Random, uniq, 102, 345622
if FileExtn in MP3,AAC,MPP,TTA
{
    CoverDes = Added Using IDTE - Id3 Tag Editor [Unique ID = %uniq%]  
	DllCall("AudioGenie3\ID3V2AddPictureFileW", str, Coverfile, str, CoverDes, Uint, CoverType, Int, 0)
     errorcode := DllCall("AudioGenie3\AUDIOSaveChangesW") 
}
else if FileExtn in FLAC
{
	CoverDes = Added Using IDTE - Id3 Tag Editor [Unique ID = %uniq%]  
	DllCall("AudioGenie3\FLACAddPictureFileW", str, Coverfile, str, CoverDes, Uint, CoverType, Int, 0)
	errorcode := DllCall("AudioGenie3\AUDIOSaveChangesW")
}
else if FileExtn in MP4,M4A,M4B,M4P
{
	DllCall("AudioGenie3\MP4AddPictureFileW",str,Coverfile)
	errorcode := DllCall("AudioGenie3\AUDIOSaveChangesW")
}
else if FileExtn in WMA,ASF
{
	CoverDes = Added Using IDTE - Id3 Tag Editor [Unique ID = %uniq%]  
	DllCall("AudioGenie3\WMAAddPictureFileW", str, Coverfile, str, CoverDes, Uint, CoverType, Int, 0)
	errorcode := DllCall("AudioGenie3\AUDIOSaveChangesW")
}

; Check if Added Sucessfully
if(errorcode<>-1)
	MsgBox, 添加专辑封面时遇到错误
else
	MsgBox, 成功添加专辑封面
	;Refresh Changes
gosub, reload_same_file
return

;################################################ REMOVE ALBUM ART #######################################

ButtonRemoveAlbumArt:
    Gui +OwnDialogs  ; Forces user to dismiss the following dialog before using main window.
MsgBox, 36, 等待..,确认移除?`n	;Prompt First
	IfMsgBox, No
		return
	
	;Analyze file
loop, %ChooseFile%
{
  DllCall("AudioGenie3.dll\AUDIOAnalyzeFileW", Str, A_LoopFileFullPath )
}  

;Remove Cover According to Supported Type
; Note - Only One Cover at a Time is removed therefore in case of multiple coverarts a repeatedly action 
;        Should be applied.

if FileExtn in MP3,AAC,MPP,TTA
{ 
	DllCall("AudioGenie3\ID3V2DeleteSelectedFrameW", uint, 1095780675, uint, Updown)
	errorcode := DllCall("AudioGenie3\AUDIOSaveChangesW") 
}
else if FileExtn in FLAC
{
	DllCall("AudioGenie3\FLACDeletePictureW",Uint,Updown)
	errorcode := DllCall("AudioGenie3\AUDIOSaveChangesW")
}
else if FileExtn in MP4,M4A,M4B,M4P
{
	DllCall("AudioGenie3\MP4DeletePictureW",Uint,Updown)
	errorcode := DllCall("AudioGenie3\AUDIOSaveChangesW")
}
else if FileExtn in WMA,WMV,WMP,ASF
{
	DllCall("AudioGenie3\WMADeletePictureW",Uint,Updown)
	errorcode := DllCall("AudioGenie3\AUDIOSaveChangesW")
}
if(errorcode<>-1)
	MsgBox, 16, Error, 处理标签时发生错误 `nErrorCode: %errorcode%
else
	MsgBox, 成功移除专辑封面

;Refresh Changes
gosub, reload_same_file
return

;#######################################################  Save Tag ###########################################

ButtonSave:
Gui, submit, NoHide

;Save According to the extension type
if FileExtn in MP3,AAC,MPP,TTA
{
	; Set Encoding Information = Unicode
	DllCall("AudioGenie3\ID3V2SetFormatAndEncodingW", uint, 0, uint, 1)
	; Save Tag 
	Trackinfo := DllCall("AudioGenie3\ID3V2SetTextFrameW", uint, 1414677323, wstr, Track) 
	Titleinfo := DllCall("AudioGenie3\ID3V2SetTextFrameW", uint, 1414091826, wstr, Title) 
	Artistinfo := DllCall("AudioGenie3\ID3V2SetTextFrameW", uint, 1414546737, wstr, Artist) 
	Albuminfo := DllCall("AudioGenie3\ID3V2SetTextFrameW", uint, 1413565506, wstr, Album) 
	Genreinfo := DllCall("AudioGenie3\ID3V2SetTextFrameW", uint, 1413697358, wstr, Genre) 
	Yearinfo  := DllCall("AudioGenie3\ID3V2SetTextFrameW", uint, 1415136594, wstr, Year) 
   
	; Get Language and Description of Comment 
	; Note - there can be multiple Comments frame but with different description.
	lang := DllCall("AudioGenie3\ID3V2GetCommentLanguageW", uint, 1,wstr) 
	Desc := DllCall("AudioGenie3\ID3V2GetCommentDescriptionW", uint, 1,wstr) 
	Commentinfo := DllCall("AudioGenie3\ID3V2AddCommentW", wstr, lang, wstr, Desc, wstr, Comments)
   
	; Get Error info (if any)
	errorcode := DllCall("AudioGenie3\ID3V2SaveChangesW", Short)
}
else
{
	Artistinfo := DllCall("AudioGenie3\AUDIOSetArtistW", wstr, Artist)
	Albuminfo := DllCall("AudioGenie3\AUDIOSetAlbumW", wstr, Album)
	Yearinfo := DllCall("AudioGenie3\AUDIOSetYearW", wstr, Year)
	Genreinfo := DllCall("AudioGenie3\AUDIOSetGenreW", wstr, Genre)
	Trackinfo := DllCall("AudioGenie3\AUDIOSetTrackW", wstr, Track)
	Titleinfo := DllCall("AudioGenie3\AUDIOSetTitleW", wstr, Title)
	Commentinfo := DllCall("AudioGenie3\AUDIOSetCommentW", wstr, Comments)
	errorcode := DllCall("AudioGenie3\AUDIOSaveChangesW", Short)
}

if(errorcode <> -1)
	MsgBox, 16, Error, 处理标签时发生错误 `nErrorCode: %errorcode%
else
	MsgBox, 成功保存标签

; Refresh Changes
gosub, reload_same_file
return

;######################## MULTIPLE COVER NAVIGATION #############################
;Updown Variable Stores Current Position of Cover Art
;Viz implemented as follows

upupn:
UpDown+=2	;increment by 2
updwn:
UpDown--	;decrement by 1 => net = 1
if(UpDown<=0) ; if updown is <0 
    UpDown := 1	;Revert back to first cover art in the file
else if (UpDown>=Picnum)  ;else if updown is greater then total number of covers present in file
    UpDown := Picnum ; revert it to actual max. i.e. total no. of covers

;Delete prev cover art (Say cover 1)
FileDelete, %A_Temp%\AlbumArt.png
FileDelete, %A_Temp%\AlbumArt.jpg

;Get Next Picture Info (Say cover 2)
;According to supported tag type

Mime := DllCall("AudioGenie3\MP4GetPictureMimeW",uint, Updown,wstr)
	IfInString, Mime, jpg
		DllCall("AudioGenie3\MP4GetPictureFileW", wstr, A_Temp "\AlbumArt.jpg", uint, Updown)
	else 
		DllCall("AudioGenie3\MP4GetPictureFileW", wstr, A_Temp "\AlbumArt.png", uint, Updown)


Mime := DllCall("AudioGenie3\FLACGetPictureMimeW",uint, Updown,wstr)
	IfInString, Mime, jpeg
		DllCall("AudioGenie3\FLACGetPictureFileW", wstr, A_Temp "\AlbumArt.jpg", uint, Updown)
	else 
		DllCall("AudioGenie3\FLACGetPictureFileW", wstr, A_Temp "\AlbumArt.png", uint, Updown)


Mime := DllCall("AudioGenie3\ID3V2GetPictureMimeW",uint, Updown,wstr)
	IfInString, Mime, jpeg
		DllCall("AudioGenie3\ID3V2GetPictureFileW", wstr, A_Temp "\AlbumArt.jpg", uint, Updown)
	else 
		DllCall("AudioGenie3\ID3V2GetPictureFileW", wstr, A_Temp "\AlbumArt.png", uint, Updown)


Mime := DllCall("AudioGenie3\WMAGetPictureMimeW",uint, Updown,wstr)
	if(Mime = jpg)
		DllCall("AudioGenie3\WMAGetPictureFileW", wstr, A_Temp "\AlbumArt.jpg", uint, Updown)
	else (Mime = png)
		DllCall("AudioGenie3\WMAGetPictureFileW", wstr, A_Temp "\AlbumArt.png", uint, Updown)

; Get Cover type i.e. - front, back etc.
covertypeinfo:= DllCall("AudioGenie3\ID3V2GetPictureTypeTextW", uint, Updown, wstr) 
;Get its size (in Bytes)
coverSize:= DllCall("AudioGenie3\ID3V2GetPictureSizeW", uint, Updown) 

;if nothing found then check for other types
if covertypeinfo=
{
	Covertypeinfo := DllCall("AudioGenie3\FLACGetPictureTypeTextW", uint, Updown, wstr)
	coverSize := DllCall("AudioGenie3\FLACGetPictureSizeW", uint, Updown) 
	if covertypeinfo=
	{
		Covertypeinfo = 没有描述信息
		coverSize := DllCall("AudioGenie3\MP4GetPictureSizeW", uint, Updown) 
		if coverSize =
		{
			coverSize := DllCall("AudioGenie3\WMAGetPictureSizeW", uint, Updown) 
		}
	}
}

;Now change the cover Art on the Gui

IfExist, %A_Temp%\AlbumArt.png
	GuiControl,, Alb_art, *w240 *h235 %A_Temp%\AlbumArt.png
IfNotExist, %A_Temp%\AlbumArt.png
{
	IfExist, %A_Temp%\AlbumArt.jpg
		GuiControl,, Alb_art, *w90 *h90 %A_Temp%\AlbumArt.jpg
	else
		GuiControl,, Alb_art, *w90 *h90 empty.png
}
GuiControl,, covertype,%Updown%/%Picnum% %Covertypeinfo% - %coverSize% Bytes
return


;########################## EXIT #################################
GuiClose:
ExitApp