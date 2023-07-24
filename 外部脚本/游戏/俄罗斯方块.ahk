;|2.1|2023.07.21|1368
#SingleInstance,Force
global wb,Settings:=new XML("Settings"),Close:="}"
SetBatchLines,-1
Defaults()
Tetris:=new Tetris(),Tetris.Settings(),Tetris.Size:=20
if(Tetris.XML.SSN("//hold"),Current:=Tetris.XML.EA("//current")){
	if((ea:=Tetris.XML.EA("//hold")).Orientation)
		Tetris.Tetrimino(ea.Piece,ea.Orientation,"Hold",ea.Color)
	Run(Tetris.Tetrimino(Current.Piece,Current.Orientation,0,Current.Color)),Tetris.Score:=Tetris.XML.SSN("//score").text,Tetris.Lines:=Tetris.XML.SSN("//lines").text,Tetris.SetScore()
}else
	Run(Tetris.Tetrimino(Shape,Orientation))
/*
	m(Tetris.IE.Document.Body.OuterHtml)
*/
Tetris.FillQueue(Tetris.XML.SN("//queue"))
/*
	Random()
*/
if((All:=Tetris.XML.SN("//dot")).length)
	Tetris.Load(All)
else
	RegisterTetrimino(0,1)
Rem:=Tetris.XML.SN("//queue")
while(rr:=Rem.item[A_Index-1])
	rr.ParentNode.RemoveChild(rr)
EvalGhost(1)
Tetris.Debug:=0
if(Tetris.Debug)
	Debug()
/*
	m(wb.Document.Body.OuterHtml)
*/
Gui,Show
RegisterTetrimino(0)
SetTimer,Run,20
return
F3::
Tetris.SetBoardWidth(Tetris.BoardWidth=400?200:400)
return
GuiEscape:
GuiClose:
/*
	m("Disabled","time:.5")
	ExitApp
*/
SetTimer,Run,Off
for a,b in Tetris.queue
	Tetris.XML.Add("queue",{piece:b.Piece,orientation:b.Orientation,color:b.Color},,1)
top:=Tetris.XML.SSN("//Board"),Tetrimino:=Tetris.CurrentTetrimino
Tetris.XML.Add("current",{piece:Tetrimino.Piece,orientation:Tetrimino.Orientation,color:Tetrimino.Color})
Tetris.XML.Add("score").text:=Tetris.Score,Tetris.XML.Add("lines").text:=Tetris.Lines
if(Tetris.Hold.Orientation)
	Tetris.XML.Add("hold",{piece:Tetris.Hold.Piece,orientation:Tetris.Hold.Orientation,color:Tetris.Hold.Color})
for a,b in {width:Tetris.BoardWidth,height:Tetris.BoardHeight}
	top.SetAttribute(a,b)
Tetris.XML.Transform()
Tetris.XML.Save()
ExitApp
return
CheckHeld(Tetrimino){
	static LastTick,Last:=[]
	Tick:=A_TickCount,Controls:=Tetris.Controls
	if(!Left:=GetKeyState(Controls.Left.Button,"P"))
		Right:=GetKeyState(Controls.Right.Button,"P")
	if(!Clockwise:=GetKeyState(Controls.Rotate_Clockwise.Button,"P"))
		CounterClockwise:=GetKeyState(Controls.Rotate_CounterClockwise.Button,"P")
	if(!Left&&!Right&&!Clockwise&&!CounterClockwise)
		return Last:=[],LastTick:=Tick-70
	if(Tick-LastTick<70&&LastTick)
		return
	Size:=Tetris.Size
	if(Left||Right){
		XPos:=[],YPos:=[],Sleep:=Controls[Left?"Left":"Right"]
		for a,b in Tetrimino.For
			x:=b.x,y:=b.y,YPos[y]:=1,XPos[x]:=1,YPos[y+Size]:=1,XPos[x+Size]:=1,Search.=" or (" (Left?"@x=" x-Size:"@x=" x+Size) " and (@y+" Size-1 ">=" y " and @y<='" y+Size-1 "'))"
		if(!Tetris.XML.SSN("//dot[" Trim(Search," or ") "]")){
			x:=Tetrimino.Position.x
			if(Left){
				if(XPos.MinIndex()-Tetris.Size>=0)
					Tetrimino.Position.x:=x-Tetris.Size,Tetris.DrawTetrimino()
			}else if(Right){
				if(XPos.MaxIndex()+Tetris.Size<=Tetris.BoardWidth)
					Tetrimino.Position.x:=x+Tetris.Size,Tetris.DrawTetrimino()
			}LastTick:=Tick+(Last[Left?"Left":"Right"]?Sleep.Sleep:Sleep.FirstPressSleep)
		}else
			LastTick:=LastTick
		EvalGhost()
	}if(Clockwise||CounterClockwise){
		Orientation:=Tetrimino.Orientation
		if(Clockwise)
			Orientation:=Orientation=4?1:Orientation+1
		else
			Orientation:=Orientation=1?4:Orientation-1
		Shape:=Tetris.Tetriminos[Tetrimino.Piece,Orientation]
		for a,b in Shape{
			x:=Tetrimino.Position.x+b.1*Tetris.Size,y:=Tetrimino.Position.y+b.2*Tetris.Size
			if(Tetris.XML.SSN("//dot[@x='" x "' and (@y>='" y "'and @y<='" y+Size "')]"))
				return LastTick:=Tick
		}Tetrimino.Orientation:=Orientation,Tetris.DrawTetrimino(),Sleep:=Controls[Clockwise?"Rotate_Clockwise":"Rotate_CounterClockwise"],LastTick:=Tick+(Last.Up?Sleep.Sleep:Sleep.FirstPressSleep)
		EvalGhost()
	}Last:={Left:Left,Right:Right,Up:Up}
}
Class Tetris{
	__New(){
		this.Body:=[],this.Score:=[],this.XML:=New XML("Board"),this.Size:=20,this.x:=this.Size*4+20,this.y:=26,this.BoardWidth:=200,this.BoardHeight:=500,this.Items:=[],this.Controls:=[]
		I:=[[[0,4],[1,4],[2,4],[3,4]],[[2,1],[2,2],[2,3],[2,4]],[[0,4],[1,4],[2,4],[3,4]],[[2,1],[2,2],[2,3],[2,4]]]
		T:=[[[0,1],[1,1],[2,1],[1,2]],[[1,0],[0,1],[1,1],[1,2]],[[0,2],[1,2],[2,2],[1,1]],[[0,0],[0,1],[1,1],[0,2]]]
		M:=[[[0,1],[1,1],[2,1],[0,2]],[[0,0],[1,0],[1,1],[1,2]],[[2,1],[0,2],[1,2],[2,2]],[[0,0],[0,1],[0,2],[1,2]]]
		L:=[[[0,1],[1,1],[2,1],[2,2]],[[1,0],[1,1],[1,2],[0,2]],[[0,1],[0,2],[1,2],[2,2]],[[1,0],[2,0],[1,1],[1,2]]]
		Z:=[[[0,2],[1,2],[1,1],[2,1]],[[0,0],[0,1],[1,1],[1,2]],[[0,2],[1,2],[1,1],[2,1]],[[0,0],[0,1],[1,1],[1,2]]]
		S:=[[[0,1],[1,1],[1,2],[2,2]],[[1,0],[1,1],[0,1],[0,2]],[[0,1],[1,1],[1,2],[2,2]],[[1,0],[1,1],[0,1],[0,2]]]
		O:=[[[0,0],[0,1],[1,0],[1,1]],[[0,0],[0,1],[1,0],[1,1]],[[0,0],[0,1],[1,0],[1,1]],[[0,0],[0,1],[1,0],[1,1]]]
		this.Tetriminos:={1:I,2:T,3:L,4:M,5:Z,6:S,7:O},this.QueueCount:=4,this.Score:=0,this.Lines:=0,this.Board:=[]
		this.AllDots:=[]
		if(!this.Init){
			Gui,Margin,0,0
			Gui,+hwndMain -Caption -DPIScale
			def:=this.FixIE(11)
			Gui,Add,ActiveX,% "w500 h" this.BoardHeight+this.y+8 " vwb hwndIE",mshtml
			this.Init:=1,this.FixIE(def),this.IEHWND:=IE,this.Main:=Main
		}wb.Navigate("about:<html><script>onerror=function(event){return true;"(Close)";onmessage=function(event){return false;"(Close)";onclick=function(event){ahk_event('OnClick',event);"(Close)";onchange=function(event){ahk_event('OnChange',event);"(Close)";oninput=function(event){ahk_event('OnInput',event);"(Close)";onprogresschange=function(event){ahk_event('OnProgressChange',event);"(Close)";</script><body style='background-color:Black;margin:0px;'><div id='Settings' Style='Visibility:Hidden'></div><svg></svg></body></html>")
		while(wb.ReadyState!=4)
			Sleep,10
		this.Main:=Main,this.IE:=wb,this.IE.Document.ParentWindow.ahk_event:=Tetris._Event.Bind(Tetris),this.Doc:=this.IE.Document,this.svg:=wb.Document.GetElementsByTagName("svg").item[0]
		this.MainBorder:=this.CreateElementNS(this.svg,0,0,this.BoardWidth+1,this.BoardHeight+1)
		ea:=this.XML.EA("//Board")
		this.SetBoardWidth(ea.width?ea.width:this.BoardWidth)
		this.CreateElementNS(this.svg,5,25,this.Size*4+4,this.Size*4+4).ID:="Hold"
		this.Hotkeys:=[],this.QueueGraphics:=[],this.Queue:=[]
		Loop,4
			this.QueueGraphics.Push((Obj:=this.CreateElementNS(this.svg,this.x+this.BoardWidth+10,((A_Index-1)*this.Size*4)+25+(A_Index=1?0:(8*(A_Index-1))),this.Size*4+4,this.Size*4+4))),Obj.ID:="Queue" A_Index
		this.CreateText(4,-12,"<center>Hold: Q</center>")
		this.CreateText(4,200,"<center>Press Escape to Exit<br><br>Press F1 to Pause/Play<br><br>Press F3 to Change the Board Size<br><br>S to Drop Piece</center>")
		this.CreateText(this.x+this.BoardWidth+10,-12,"<center>Queue:</center>","Left")
		this.ScoreText:=this.CreateText(this.x,-12,"<font style='word-wrap:break-word'><center>Score: 0</center>",,this.BoardWidth)
		Obj:=this.Ghost:=[],Obj.For:=[],Obj.Position:={x:0,y:0}
		Loop,4{
			this.Ghost.For.Push({obj:this.CreateElementNS(this.svg,0,0,this.Size,this.Size,"DarkGrey","black")})
		}
		return this
		Hotkey:
		Action:=Tetris.Hotkeys[A_ThisHotkey]
		if(Action="Hold"){
			if(Tetris.Swapped)
				return
			if(!IsObject(Tetris.Hold)){
				Tetris.Hold:=Tetris.CurrentTetrimino,Tetris.DrawTetrimino(Tetris.Hold,0,"Hold"),Tetris.PullQueue(),Run(Tetris.CurrentTetrimino)
			}else{
				Hold:=Tetris.Hold.Clone(),Tetris.DrawTetrimino(Tetris.Hold:=Tetris.CurrentTetrimino,0,"Hold")
				Hold.Position.x:=Floor(Tetris.BoardWidth/2),Hold.Position.y:=0
				Tetris.DrawTetrimino(Tetris.CurrentTetrimino:=Hold,1),Run(Tetris.CurrentTetrimino)
			}Tetris.Swapped:=1,EvalGhost(1)
		}else if(Action="Pause"){
			Tetris.Play:=Tetris.Play?0:1
			SetTimer,Run,% (Tetris.Play?"Off":40)
		}else if(Action="Drop")
			Tetris.CurrentTetrimino.Position.y:=Tetris.Ghost.Max-Tetris.Size
		return
	}
	_Events(Name,Event){
		Node:=Event.srcElement
		m(Node.OuterHtml)
	}CreateElementNS(Parent,x,y,w,h,Stroke:="blue",Fill:="",Type:="rect"){
		
		Parent.AppendChild(Item:=wb.Document.CreateElementNS("http://www.w3.org/2000/svg",Type))
		for a,b in {x:x,y:y,width:w,height:h,stroke:Stroke,fill:Fill}
			if(b!="")
				Item.SetAttribute(a,b)
		return Item
	}CreateText(Left,Top,InnerHtml,Side:="Right",Width:="",Height:=""){
		Width:=Width?Width:this.Size*4+4
		p:=wb.Document.CreateElement("p"),p.InnerHtml:=InnerHtml,Style:=p.Style
		for a,b in {Left:Left,top:Top,position:"absolute",color:"grey",width:Width,textshadow:"1px 1px 3px #cc00cc"}
			Style[a]:=b
		wb.Document.Body.AppendChild(p)
		if(Side="Left")
			this.QueueGraphics.Push(p)
		return p
	}DrawTetrimino(Tetrimino="",MoveTop:=0,Position:="",Stop:=0){
		if(!Tetrimino)
			Tetrimino:=this.CurrentTetrimino
		Shape:=this.Tetriminos[Tetrimino.Piece,Tetrimino.Orientation],Pos:=[],Size:=this.Size
		if(MoveTop||Position)
			for a,b in Tetrimino.For
				b.Obj.SetAttribute("height",MoveTop?0:Size)
		if(!MoveTop&&!Tetrimino.visibility)
			Tetrimino.visibility:=1,Vis:=1
		for a,b in Shape{
			if(Position)
				x:=DrawX:=(Tetrimino.Position.x+b.1*Size),y:=DrawY:=(Tetrimino.Position.y+b.2*Size)
			else
				x:=Tetrimino.Position.x+b.1*Size,DrawX:=x+this.x,y:=Tetrimino.Position.y+b.2*Size,DrawY:=y+this.y
			Tet:=Tetrimino.For[A_Index]
			Tet.Obj.SetAttribute("x",DrawX),Tet.Obj.SetAttribute("y",DrawY)
			if(Vis)
				Tet.obj.SetAttribute("visibility","visible")
			Pos["x",x]:=1,Pos["y",y]:=1
			Tet.x:=x,Tet.y:=y
			if(Tet.y<0&&!MoveTop&&!Position){
				Tet.Obj.SetAttribute("height",(Tet.Height:=Size+Tet.y))
				Tet.Obj.SetAttribute("y",this.y)
			}else if(!Position&&Tet.y>=0&&!MoveTop&&Tet.Height<Size){
				Tet.Obj.SetAttribute("height",Size),Tet.Height:=Size
			}
		}if(Position="Ghost"){
			/*
				Tetrimino.Pos:=Pos
			*/
			return
		}
		if(Stop)
			return
		if(Position){
			Hold:=wb.Document.GetElementById(Position),HoldPos:=[]
			for a,b in ["x","y","width","height"]
				HoldPos[b]:=Hold.GetAttribute(b)
			Width:=Pos.x.MaxIndex()-(x:=Pos.x.MinIndex())+this.Size
			Height:=Pos.y.MaxIndex()-(y:=Pos.y.MinIndex())+this.Size
			OPos:=Tetrimino.Position
			OPos.y:=OPos.y-(y-(Floor((HoldPos.Height-Height)/2)+HoldPos.y))
			OPos.x:=OPos.x-(x-(Floor((HoldPos.Width-Width)/2)+HoldPos.x))
			this.DrawTetrimino(Tetrimino,0,"Hold",1)
			return
		}
		Tetrimino.Pos:=Pos
		if(MoveTop)
			return Difference:=Pos.x.MaxIndex()-Pos.x.MinIndex(),x:=Tetrimino.Position.x,Tetrimino.Position.x:=x+(x-Pos.x.MinIndex())-Mod(Difference,this.Size)-this.Size,Tetrimino.Position.y-=(Pos.y.MaxIndex()+Size),this.DrawTetrimino()
		if(Pos.x.MinIndex()<0)
			Tetrimino.Position.x:=0,this.DrawTetrimino()
		else if(Pos.x.MaxIndex()>(Width:=this.BoardWidth-Size))
			Tetrimino.Position.x:=Tetrimino.Position.x-(Pos.x.MaxIndex()-Width),this.DrawTetrimino()
	}FillQueue(All:=""){
		for a,b in this.Queue
			this.DrawTetrimino(b,0,"Queue" A_Index)
		Loop,% this.QueueCount
			if(!this.Queue[A_Index])
				ea:=XML.EA(All.item[A_Index-1]),this.Queue.Push(this.Tetrimino(ea.Piece,ea.Orientation,"Queue" A_Index,ea.Color))
	}FixIE(Version=0){
		static Key:="Software\Microsoft\Internet Explorer\MAIN\FeatureControl\FEATURE_BROWSER_EMULATION",Versions:={7:7000,8:8888,9:9999,10:10001,11:11001}
		Version:=Versions[Version]?Versions[Version]:Version
		if(A_IsCompiled)
			ExeName:=A_ScriptName
		else
			SplitPath,A_AhkPath,ExeName
		RegRead,PreviousValue,HKCU,%Key%,%ExeName%
		if(!Version)
			RegDelete,HKCU,%Key%,%ExeName%
		else
			RegWrite,REG_DWORD,HKCU,%Key%,%ExeName%,%Version%
		return PreviousValue
	}Load(All){
		Obj:=[],Obj.For:=[],Size:=this.Size
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			rect:=wb.Document.CreateElementNS("http://www.w3.org/2000/svg","rect")
			for e,f in {x:ea.x+this.x,y:ea.y+this.y,width:Size,height:Size,stroke:"black",fill:"#" ea.Color}
				rect.SetAttribute(e,f),total.=ea.x "x" ea.y "`n"
			Obj.For.Push({obj:rect,x:ea.x,y:ea.y,color:ea.color}),this.svg.AppendChild(rect)
		}this.XML.XML.LoadXML("<Board/>"),RegisterTetrimino(Obj)
	}PullQueue(){
		Obj:=this.Queue.RemoveAt(1),Obj.Position.x:=Floor(this.BoardWidth/2),this.CurrentTetrimino:=Obj
		Obj.Position.y:=0
		this.FillQueue(),this.DrawTetrimino(Obj,1)
		return Obj
	}Tetrimino(Piece:="",Orientation:=1,Hold:=0,Color:=""){
		Size:=this.Size?this.Size:20
		if(!Piece){
			Random,Piece,1,7
			Random,Orientation,1,4
		}if(!Hold)
			Obj:=this.CurrentTetrimino:=[],Obj.For:=[]
		else
			Obj:=Hold="Hold"?this.Hold:=[]:Obj:=[],Obj.For:=[]
		if(!Color)
			Color:=RandomColor()
		Loop,4
			rect:=this.CreateElementNS(this.svg,0,Size*-4,Size,Size,"black","#" Color),rect.SetAttribute("visibility",(Hold?"visible":"hidden")),Obj.For.Push({x:0,y:0,obj:rect,visibility:(Hold?1:0),color:Color})
		Obj.Position:={x:(Hold?0:Floor(this.BoardWidth/2)),y:0},Obj.Piece:=Piece,Obj.Orientation:=Orientation,this.DrawTetrimino(Obj,Hold?0:1,Hold),obj.Color:=Color
		return Obj
	}Settings(){
		static LastHotkeys:=[]
		Hotkey,IfWinActive,% "ahk_id" this.Main
		for a,b in LastHotkeys
			Hotkey,%b%,Off
		all:=Settings.SN("//*"),LastHotkeys:=[]
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
			if(!aa.ChildNodes.Length){
				if(!IsObject(Obj:=this[aa.ParentNode.NodeName]))
					Obj:=this[aa.ParentNode.NodeName]:=[]
				Obj:=Obj[aa.Nodename]:=[]
				for a,b in ea{
					Obj[a]:=b
					if(a="Button"){
						Hotkey,%b%,DeadEnd,On
						LastHotkeys.Push(b)
					}if(aa.NodeName="Options"){
						Hotkey,%b%,Hotkey,On
						this.Hotkeys[b]:=a,LastHotkeys.Push(b)
					}
				}
			}
		}
		return
		DeadEnd:
		return
	}SetBoardWidth(Width){
		static Flash
		OWidth:=this.BoardWidth,this.BoardWidth:=Width
		for a,b in {x:this.x-1,y:this.y-1,width:this.BoardWidth+2,height:this.BoardHeight+2,stroke:"blue"}
			this.MainBorder.SetAttribute(a,b)
		if((all:=this.XML.SN("//dot[@x>='" Width "']")).length){
			SetTimer,Run,Off
			Flash:=[]
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
				Flash.Push({obj:this.Items[SSN(aa,"@id").text],ea:ea})
			SetTimer,FlashLose,300
			MsgBox,292,Tetris,You will lose the flashing items. Are you sure?
			IfMsgBox,Yes
			{
				SetTimer,FlashLose,Off
				while(aa:=all.item[A_Index-1])
					aa.ParentNode.RemoveChild(aa)
				for a,b in Flash
					b.Obj.ParentNode.RemoveChild(b.Obj)
				flash:=[],RegisterTetrimino(0)
				for a,b in this.QueueGraphics{
					if(A_Index<5)
						b.SetAttribute("x",this.x+this.BoardWidth+10),this.DrawTetrimino(this.Queue[a],0,"Queue" a)
					else
						b.Style.Left:=this.x+this.BoardWidth+10
				}Gui,Show,% "w" Width+200 " xCenter"
			}else{
				this.BoardWidth:=OWidth
				for a,b in {x:this.x-1,y:this.y-1,width:this.BoardWidth+2,height:this.BoardHeight+2,stroke:"blue"}
					this.MainBorder.SetAttribute(a,b)
				SetTimer,FlashLose,Off
				for a,b in Flash{
					b.obj.SetAttribute("fill",b.ea.Color)
				}
			}
			SetTimer,Run,40
			return
			FlashLose:
			Random,Random,111111,999999
			for a,b in Flash
				b.Obj.SetAttribute("fill",Random)
			return
		}for a,b in this.QueueGraphics{
			if(A_Index<5)
				b.SetAttribute("x",this.x+this.BoardWidth+10),this.DrawTetrimino(this.Queue[a],0,"Queue" a)
			else
				b.Style.Left:=this.x+this.BoardWidth+10
		}GuiControl,1:Move,% this.IEHWND,% "w" Width+200
		Gui,Show,% "w" Width+200 " xCenter"
	}SetScore(){
		this.ScoreText.InnerHtml:="<font style='word-wrap:break-word'><center>Score:" this.Score " Lines: " this.Lines "</center>"
	}
}
Class XML{
	keep:=[]
	__Get(x=""){
		return this.XML.xml
	}__New(param*){
		;if(!FileExist(A_ScriptDir "\lib"))
			;FileCreateDir,%A_ScriptDir%\lib
		;temp.preserveWhiteSpace:=1
		root:=param.1,file:=param.2,file:=file?file:root ".xml",temp:=ComObjCreate("MSXML2.DOMDocument"),temp.SetProperty("SelectionLanguage","XPath"),this.xml:=temp,this.file:=file,XML.keep[root]:=this
		if(FileExist(file)){
			;FileRead,info,%file%
			ff:=FileOpen(file,"R","UTF-8"),info:=ff.Read(ff.Length),ff.Close()
			if(info=""){
				this.xml:=this.CreateElement(temp,root)
				FileDelete,%file%
			}else
				temp.LoadXML(info),this.xml:=temp
		}else
			this.xml:=this.CreateElement(temp,root)
	}Add(XPath,Att:="",Text:="",Dup:=0){
		Obj:=StrSplit(XPath,"/")
		if(!Node:=this.SSN("//" XPath)){
			for a,b in Obj
				(!Exist:=this.SSN("//" Trim(Build.=b "/","/")))?(Node:=(A_Index=1?this.SSN("//*"):Node).AppendChild(this.CreateElement(b))):(Node:=Exist)
		}else if(Dup)
			Node:=Node.ParentNode.AppendChild(this.CreateElement(Obj.Pop()))
		for a,b in Att
			Node.SetAttribute(a,b)
		if(Text)
			Node.Text:=Text
		return Node
	}CreateElement(doc,root:=""){
		if(!root)
			return this.SSN("//*").AppendChild(this.XML.CreateElement(doc))
		return doc.AppendChild(this.XML.CreateElement(root)).ParentNode
	}EA(XPath,att:=""){
		list:=[]
		if(att)
			return XPath.NodeName?SSN(XPath,"@" att).text:this.SSN(XPath "/@" att).text
		nodes:=XPath.NodeName?XPath.SelectNodes("@*"):nodes:=this.SN(XPath "/@*")
		while(nn:=nodes.item[A_Index-1])
			list[nn.NodeName]:=nn.text
		return list
	}Find(info*){
		static last:=[]
		doc:=info.1.NodeName?info.1:this.xml
		if(info.1.NodeName)
			node:=info.2,find:=info.3,return:=info.4!=""?"SelectNodes":"SelectSingleNode",search:=info.4
		else
			node:=info.1,find:=info.2,return:=info.3!=""?"SelectNodes":"SelectSingleNode",search:=info.3
		if(InStr(info.2,"descendant"))
			last.1:=info.1,last.2:=info.2,last.3:=info.3,last.4:=info.4
		if(InStr(find,"'"))
			return doc[return](node "[.=concat('" RegExReplace(find,"'","'," Chr(34) "'" Chr(34) ",'") "')]/.." (search?"/" search:""))
		else
			return doc[return](node "[.='" find "']/.." (search?"/" search:""))
	}Get(XPath,Default){
		text:=this.SSN(XPath).text
		return text?text:Default
	}ReCreate(XPath,new){
		rem:=this.SSN(XPath),rem.ParentNode.RemoveChild(rem),new:=this.Add(new)
		return new
	}Save(x*){
		if(x.1=1)
			this.Transform()
		if(this.XML.SelectSingleNode("*").xml="")
			return m("Errors happened while trying to save " this.file ". Reverting to old version of the XML")
		FileName:=this.file?this.file:x.1.1,ff:=FileOpen(FileName,"R"),text:=ff.Read(ff.length),ff.Close()
		if(ff.encoding!="UTF-8")
			FileDelete,%FileName%
		if(!this[])
			return m("Error saving the " this.file " XML.  Please get in touch with maestrith if this happens often")
		if(!FileExist(FileName))
			FileAppend,% this[],%FileName%,UTF-8
		else if(text!=this[])
			file:=FileOpen(FileName,"W","UTF-8"),file.Write(this[]),file.Length(file.Position),file.Close()
	}SSN(XPath){
		return this.XML.SelectSingleNode(XPath)
	}SN(XPath){
		return this.XML.SelectNodes(XPath)
	}Transform(){
		static
		if(!IsObject(xsl))
			xsl:=ComObjCreate("MSXML2.DOMDocument"),xsl.LoadXML("<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'><xsl:output method='xml' indent='yes' encoding='UTF-8'/><xsl:template match='@*|node()'><xsl:copy>`n<xsl:apply-templates select='@*|node()'/><xsl:for-each select='@*'><xsl:text></xsl:text></xsl:for-each></xsl:copy>`n</xsl:template>`n</xsl:stylesheet>")
		this.XML.TransformNodeToObject(xsl,this.xml)
	}Under(under,node,att:="",text:="",list:=""){
		new:=under.AppendChild(this.XML.CreateElement(node))
		for a,b in att
			new.SetAttribute(a,b)
		for a,b in StrSplit(list,",")
			new.SetAttribute(b,att[b])
		if(text)
			new.text:=text
		return new
	}
}
SSN(node,XPath){
	return node.SelectSingleNode(XPath)
}
SN(node,XPath){
	return node.SelectNodes(XPath)
}
Debug(){
	static
	if(!WinExist("ahk_id" HWND)){
		Gui,2:Destroy
		Gui,2:+hwndHWND
		Gui,2:Color,0,0
		Gui,2:Add,Edit,w500 h1000 c0x00ff00
		Gui,2:Show,x0 y0 NA,Debug
	}
}
Defaults(){
	if(!Settings.SSN("//Controls/Left"))
		for a,b in {Left:"Left",Right:"Right",Rotate_Clockwise:"Up",Rotate_CounterClockwise:"w"}{
			for c,d in {FirstPressSleep:100,Sleep:0,Button:b}
				Settings.Add("Controls/" a,{(c):d}),Updated:=1
		}
	if(!Settings.SSN("//Options"))
		Settings.Add("Options",{Pause:"F1",Hold:"q",Drop:"s"}),Updated:=1
	if(Updated){
		Settings.Save(1)
	}
}
m(x*){
	active:=WinActive("A")
	ControlGetFocus,Focus,A
	ControlGet,hwnd,hwnd,,%Focus%,ahk_id%active%
	static list:={btn:{oc:1,ari:2,ync:3,yn:4,rc:5,ctc:6},ico:{"x":16,"?":32,"!":48,"i":64}},msg:=[],msgbox
	list.title:="Tetris",list.def:=0,list.time:=0,value:=0,msgbox:=1,txt:=""
	for a,b in x
		obj:=StrSplit(b,":"),(vv:=List[obj.1,obj.2])?(value+=vv):(list[obj.1]!="")?(List[obj.1]:=obj.2):txt.=b "`n"
	msg:={option:value+262144+(list.def?(list.def-1)*256:0),title:list.title,time:list.time,txt:txt}
	Sleep,120
	MsgBox,% msg.option,% msg.title,% msg.txt,% msg.time
	msgbox:=0
	for a,b in {OK:value?"OK":"",Yes:"YES",No:"NO",Cancel:"CANCEL",Retry:"RETRY"}
		IfMsgBox,%a%
	{
		WinActivate,ahk_id%active%
		ControlFocus,%Focus%,ahk_id%active%
		return b
	}
}
Random(){
	Size:=Tetris.Size,CountW:=Floor(Tetris.BoardWidth/Size)+1,StartY:=200,Tetris.CurrentTetrimino:=[],Tetris.CurrentTetrimino.For:=[]
	While(StartY<Tetris.BoardHeight){
		Color:=RandomColor()
		StartX:=0
		While(Mod(A_Index,CountW)){
			if(StartX=120){
				Startx+=Size
				Continue
			}
			rect:=wb.Document.CreateElementNS("http://www.w3.org/2000/svg","rect")
			for e,f in {x:StartX+Tetris.x,y:StartY+Tetris.y,width:Size,height:Size,stroke:"black",fill:"#" Color}
				rect.SetAttribute(e,f)
			Tetris.CurrentTetrimino.For.Push({obj:rect,x:StartX,y:StartY}),Tetris.svg.AppendChild(rect)
			/*
				Obj:=Tetris.CurrentTetrimino[Tetris.CurrentTetrimino.MaxIndex()],Obj.x:=StartX,Obj.y:=StartY
			*/
			StartX+=Size
			Index++
		}
		StartY+=Size
	}
	RegisterTetrimino(Tetris.CurrentTetrimino)
}
RegisterTetrimino(Tetrimino,Stop:=0){
	static init:=0,ID:=0
	for a,b in Tetrimino.For{
		xx:=Tetris.XML,Root:=xx.SSN("//*")
		if(!Node:=xx.SSN("//row[@y='" b.y "']")){
			Node:=xx.Add("row",{y:b.y},,1)
			all:=Tetris.XML.SN("//row"),Order:=[]
			while(aa:=all.item[A_Index-1])
				Order[SSN(aa,"@y").text]:=aa
			for c,d in Order
				d.ParentNode.AppendChild(d)
		}New:=xx.Under(Node,"dot",{x:b.x,y:b.y,id:++ID,color:b.Color}),Tetris.Items[ID]:=b.Obj
		
		Tetris.AllDots[b.x,b.y]:=b.Obj
		
	}Size:=Tetris.Size,Tetris.Board:=[],StartX:=0
	Size:=Tetris.Size,Remove:=[],all:=Tetris.XML.SN("//dot[not(@y=preceding-sibling::dot/@y)]/@y")
	Add:=0,MoveDown:=[],xx:=Tetris.XML,Count:=Floor(Tetris.BoardWidth/Size)
	while(aa:=all.item[All.Length-A_Index]){
		More:=xx.SN("//dot[@y='" aa.text "' and not(.=(preceding-sibling::*/@x))]")
		if(More.Length=Count)
			Add+=Size,Remove.Push(More.Item[0].ParentNode)
		else{
			Subtract:=SN(More.item[0].ParentNode,"descendant-or-self::*[@y]")
			while(ss:=Subtract.item[A_Index-1])
				ss.SetAttribute("y",SSN(ss,"@y").text+Add)
			MoveDown.Push(More.Item[0].ParentNode)
		}
	}Flash:=[]
	for a,b in Remove{
		all:=SN(b,"dot")
		while(aa:=all.item[A_Index-1],ea:=XML.EA(aa))
			Flash.Push(Tetris.Items[ea.ID])
		b.ParentNode.RemoveChild(b)
	}
	if(Flash.1){
		Loop,10{
			Random,Color,111111,999999
			for a,b in Flash
				b.SetAttribute("fill",Color)
			Sleep,50
		}for a,b in Flash
			b.ParentNode.RemoveChild(b)
		for a,b in MoveDown{
			list.=a "`n"
			all:=SN(b,"dot")
			while(aa:=all.item[A_Index-1],ea:=XML.EA(aa)){
				Tetris.Items[ea.ID].SetAttribute("y",ea.y+Tetris.y)
			}
		}
	}
	if(Tetris.Debug=1){
		xx.Transform()
		GuiControl,2:,Edit1,% xx[]
	}else if(Tetris.Debug=2){
		for a,b in Tetris.AllDots
			for c,d in b
				list.=a " = " c " x " d " - "  "`r`n"
		GuiControl,2:,Edit1,%List%
	}if(Lines:=Floor(Add/Size))
		Tetris.Score+=Lines*(Floor(Tetris.BoardWidth/Size)*(Lines=4?20:10)),Tetris.Lines+=Lines,Tetris.SetScore()
	/*
		while(StartX<=Tetris.BoardWidth-Size)
			Val:=Tetris.XML.SSN("//dot[@x='" StartX "' and not(@y>@y)][1]/@y").text,Val:=Val?Val:Tetris.BoardHeight,Tetris.Board[StartX]:=Val,StartX+=Size
	*/
}
Run(Tet:=""){
	static Count:=0,Tetrimino,Jitter:=0,JitterTotal:=0
	if(Tet)
		return Tetrimino:=Tet
	Tetris.DrawTetrimino(),Size:=Tetris.Size
	CheckHeld(Tetrimino)
	for a,b in Tetrimino.For
		Search.=" or (@y='" b.y+Size "' and @x='" b.x "')"
	All:=Tetris.XML.SSN("//dot[" Trim(Search," or ") "]"),Count++
	if(All){
		if(Count=1){
			FileDelete,Board.xml
			if(m("Final Score: " Tetris.Score,"Lines: " Tetris.Lines,"btn:ync")="Yes")
				Reload
			ExitApp
		}return RegisterTetrimino(Tetrimino),Tetris.Swapped:=0,Count:=0,Tetrimino:=Tetris.PullQueue(),EvalGhost(1)
	}
	Max:=Tetris.BoardHeight-Size,MaxY:=Tetrimino.Pos.y.MaxIndex()
	if(GetKeyState("Down","P")){
		Sub:=Mod(MaxY,Tetris.Size)
		y:=MaxY+Size-Sub<Max?Size-Sub:Max-MaxY
	}else if(MaxY<=Max)
		y:=Max-MaxY>1?1:Max-MaxY
	if(MaxY>=Max)
		return RegisterTetrimino(Tetrimino),Tetris.Swapped:=0,Count:=0,Tetrimino:=Tetris.PullQueue(),EvalGhost(1)
	Tetrimino.Position.y+=y
}
t(x*){
	for a,b in x
		msg.=b "`n"
	ToolTip,%msg%
}
EvalGhost(Color:=0){
	Tetrimino:=Tetris.CurrentTetrimino,Size:=Tetris.Size,Ghost:=Tetris.Ghost,Max:=0,Shape:=Tetris.Tetriminos[Tetrimino.Piece,Tetrimino.Orientation],Search:=[]
	Tetris.Board:=[]
	for a in Tetrimino.Pos.x{
		Val:=Tetris.XML.SSN("//dot[@x='" a "' and @y>'" Tetrimino.Position.y "' and not(@y>@y)][1]/@y").text
		Val:=Val?Val:Tetris.BoardHeight
		Tetris.Board[a]:=Val
	}
	for a,b in Tetrimino.For
		Max:=Max<Tetris.Board[b.x]?Tetris.Board[b.x]:Max
	while(Max>0){
		for a,b in Shape{
			x:=Tetrimino.Position.x+b.1*Size,y:=Max+b.2*Size
			if(Tetris.Board[x]<y){
				Max-=Size
				Break
			}if(a=4)
				Break,2
	}}Ghost:=Tetris.Ghost,Ghost.Position.y:=Max+(Tetris.y-Size),Ghost.Position.x:=Tetrimino.Position.x+Tetris.x,Ghost.Piece:=Tetrimino.Piece,Ghost.Orientation:=Tetrimino.Orientation,Tetris.DrawTetrimino(Tetris.Ghost,0,"Ghost")
	if(Color)
		for a,b in Ghost.For
			b.Obj.SetAttribute("fill",Tetrimino.Color),b.Obj.SetAttribute("fill-opacity",.2)
	Ghost.Max:=Max
}
RandomColor(){
	Random, Index, 0, 240
	return ColorHLSToRGB(Index,120,240)
}
ColorHLSToRGB(Hue,Luminance,Saturation) { ; Reference: https://docs.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-colorhlstorgb - ColorHLSToRGB function
	BGR:=DllCall("shlwapi.dll\ColorHLSToRGB","UShort",Hue,"UShort",Luminance,"UShort",Saturation,"UInt")
	Return Format("{:06X}",((BGR&0xFF)<<16)|(BGR&0xFF00)|((BGR>>16)&0xFF))
}