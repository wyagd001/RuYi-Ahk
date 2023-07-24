;|2.1|2023.07.21|1371
/*
    关于 贪吃蛇v20201219-虚荣.ahk 说明:

    抽空瞎写的比较粗糙, 为了找机会测试链表结构
    加上从没写过完整游戏, 还有一个最近拿python控制台输出写游戏很勤快的兄弟的刺激, 特地写了这个贪吃蛇

    感谢大佬fwt(狗头同志)的斗气, 不然我该没动力完成了
    狗头同志厉害不到150行完成了这样的效果, 特此记录以警示后人**装逼莫早**

    顺带挑战纯中文书写代码, 发现真的不是很容易, 太长了
    写得有点乱, 总算跑起来了, 有些不太好看的地方, 有思路完善不过目前没有心思优化了
    希望这个ahk示例对大家有帮助

    配置于 贪吃蛇.开始() 部分可以改动

    虚荣
    2020/12/19
*/

#SingleInstance, force

贪吃蛇程序入口:
    贪吃蛇.开始()
exitapp

贪吃蛇GuiClose:
    exitapp
return

贪吃蛇键回调(游戏循环, 操作朝向) {
    ;msgbox, % 操作朝向
    游戏循环.最后操作蛇朝向 := 操作朝向
}

class 贪吃蛇
{
    开始() {
        ;~ 地图.重建(块尺寸, 块间距, 块横数, 块纵数, 色值_背景, 色值_空地)
        this.地图.重建(15, 1, 20, 20, 0xECF8CA, 0xCCE7BA)

        ;~ 小蛇.初始化(地图, 初始蛇长, 蛇身色, 蛇头色)
        this.小蛇.初始化(this.地图, 3, 0x87CDA8, 0x80AAA8)

        ;~ 食物.初始化(地图, 食物色)
        this.食物.初始化(this.地图, 0xD29864)
        
        ;~ 游戏循环.设定鼠标监听(贪吃蛇, 上键, 下键, 左键, 右键)
        this.游戏循环.设定鼠标监听(this, "up", "down", "left", "right")
        this.游戏循环.设定刷新频率(300)

        this.游戏循环.启动(this, this.地图, this.小蛇, this.食物)
    }

    失败(errmsg) {
        msgbox, % ("游戏结束, 附加信息:`n") (errmsg)
    }

    class 游戏循环
    {
        static 最后方向逻辑单元
        static 刷新频率
        static 最后操作蛇朝向 := ""
        启动(贪吃蛇, 地图, 小蛇, 食物) 
        {
            上一时间 := A_TickCount
            loop {

                If (A_TickCount - 上一时间 > this.刷新频率) {
                    蛇头将至坐标 := 小蛇.移动朝向(this.最后操作蛇朝向)
                    ;msgbox, % (A_LineNumber) ":" 蛇头将至坐标.横 "-" 蛇头将至坐标.纵
                    蛇步入占位物 := 地图.取坐标占位物名称(蛇头将至坐标)

                    ;~ 失败条件 ----------------------------
                    if (蛇步入占位物 = 地图.边界占位名) {
                        ;print("小蛇撞墙了")
                        贪吃蛇.失败("小蛇撞墙了")
                        break
                    } 
                    else if (蛇步入占位物 = 食物.占位名) {
                        ;print("小蛇前进一格_并长大")
                        小蛇.前进一格_并长大(地图, 蛇头将至坐标)
                        ;msgbox, % isobject(食物)
                        食物.随机生成(地图)
                    }
                    ;~ 其他条件 ----------------------------
                    else if (蛇步入占位物 = 地图.空块占位名)
                    {
                        ;print("小蛇前进一格_不长大")
                        小蛇.前进一格_不长大(地图, 蛇头将至坐标)                        
                    }
                    else if (蛇步入占位物 = 小蛇.占位名)
                    {
                        ;print("小蛇撞到自己了")
                        贪吃蛇.失败("小蛇撞到自己了")
                        break
                    }

                    上一时间 := A_TickCount
                }
            }
            return
        }

        设定刷新频率(刷新频率) {
            this.刷新频率 := 刷新频率
        }

        设定鼠标监听(贪吃蛇, 上键, 下键, 左键, 右键) {
            操作朝向组 :=  { (上键) : "上", (下键) : "下", (左键) : "左", (右键) : "右" }  
            ;msgbox, % obj_dbg1(操作朝向组)
            for 此键, 操作朝向 in 操作朝向组
            {
                ;msgbox, % 此键 "--" 操作朝向
                贪吃蛇键回调 := func("贪吃蛇键回调").bind(this, 操作朝向)
                hotkey, % 此键, %贪吃蛇键回调%
            }
        }
    }

    class 地图
    {
        static 块   ;~ 
        static 空块占位名 := "空块"    ;~ 块_已占 := {}
        static 边界占位名 := "边界"
        static 画布_句柄, 画布_设备上下文
        static 块尺寸, 块间距, 块横数, 块纵数
        static 宽, 高
        static 背景色画刷
        static 空块色画刷
        
        ;-----------------------------------
        重建(块尺寸, 块间距, 块横数, 块纵数, 色值_背景, 色值_空地) {
            this.块 := []
            this.块尺寸 := 块尺寸
            this.块间距 := 块间距
            this.宽 := (块尺寸 + 块间距) * 块横数 - 块间距
            this.高 := (块尺寸 + 块间距) * 块纵数 - 块间距
            this.块横数 := 块横数
            this.块纵数 := 块纵数
            this.画布_句柄 := 0x0
            this.画布_设备上下文 := 0x0
            this.空块色画刷 := 0x0
            ;--------------------------------
            ;~ 创建画布
            Gui, 贪吃蛇:Destroy 
            Gui, 贪吃蛇:+hwnd画布_句柄 +toolwindow +AlwaysOnTop
            Gui, 贪吃蛇:Show, % " x10 " 
                . "w" this.宽 . " "
                . "h" this.高 . " "

            this.画布_句柄 := 画布_句柄
            this.画布_设备上下文:=Dllcall("GetDC"
                , "UInt", this.画布_句柄
                , "Uint")    ;~ 获取窗口dc指针
            ;----------------------------
            ;~ 设置空画笔, 让矩形无描边
            ;~hPenOld:=
            Dllcall("SelectObject"
                , "Ptr", this.画布_设备上下文    ;, "Ptr", hdcMem
                , "Ptr", DllCall("GetStockObject"
                    , "int", 0x8    ;~ NULL_PEN
                    , "uint")
                , "UInt")
            ;----------------------------
            ;~ 设置背景色画刷颜色
            this.背景色画刷:=DllCall("CreateSolidBrush"
                , "Uint", this.翻译RGB色(色值_背景)
                , "Uint")
            ;~ hBrushOld:=
            Dllcall("SelectObject"
                , "Ptr", this.画布_设备上下文    ;, "Ptr", hdcMem
                , "Ptr", this.背景色画刷
                , "UInt")            
            Dllcall("Rectangle"
                , "Ptr", this.画布_设备上下文
                , "Int", 1
                , "Int", 1
                , "Int", this.宽
                , "Int", this.高
                , "UInt")
            ;----------------------------
            ;~ 设置背景色画刷颜色            
            this.空块色画刷:=DllCall("CreateSolidBrush"
                , "Uint", this.翻译RGB色(色值_空地)
                , "Uint")
            ;~ hBrushOld:=
            Dllcall("SelectObject"
                , "Ptr", this.画布_设备上下文    ;, "Ptr", hdcMem
                , "Ptr", this.空块色画刷
                , "UInt")
            ;--------------------------------
            ;~ 创建空白地
            loop, % 块横数
            {
                横 := A_Index
                this.块[横] := []
                loop, % 块纵数
                {
                    纵 := A_Index
                    this.设置块颜色(画刷句柄, 横, 纵, this.空块占位名)
                }
            }
        }

        设置块颜色(画刷句柄, 横, 纵, 占位物) {
            static 前一句柄 := ""
            this.块[横][纵] := {"占位物": 占位物}
            if not (画刷句柄 = 前一句柄)
                Dllcall("SelectObject"
                    , "Ptr", this.画布_设备上下文    ;, "Ptr", hdcMem
                    , "Ptr", 画刷句柄
                    , "UInt")
            左上横 := (横 - 1) * (this.块尺寸 + this.块间距)
            左上纵 := (纵 - 1) * (this.块尺寸 + this.块间距)
            右下横 := 左上横 + this.块尺寸
            右下纵 := 左上纵 + this.块尺寸

            Dllcall("Rectangle"
                , "Ptr", this.画布_设备上下文
                , "Int", 左上横
                , "Int", 左上纵
                , "Int", 右下横
                , "Int", 右下纵
                , "UInt")
        }

        取坐标占位物名称(蛇头将至) {

            横 := 蛇头将至.横
            纵 := 蛇头将至.纵
            if (0)    
                or (横 > this.块横数) 
                or (纵 > this.块纵数)
                or (横 < 1)
                or (纵 < 1)
                return this.边界占位名
            else {
                ;msgbox, % (A_LineNumber) ":" obj_dbg1(this["块"])
                return this["块"][横][纵]["占位物"]
            }
                
        }

        翻译RGB色(color, retHex := true) {
            return retHex ? format("0x{1:x}",((color & 0xff) << 16) + ((color >> 8 & 0xff) << 8) + (color >> 16 & 0xff)) : ((color & 0xff) << 16) + ((color >> 8 & 0xff) << 8) + (color >> 16 & 0xff)
        }
    }

    class 小蛇
    {
        static 占位名 := "小蛇蛇"
        static 当前方向
        static 蛇头, 蛇尾
        static 蛇头画刷, 蛇身画刷
        static 蛇长

        class 蛇段
        {
            前一段 := ""
            后一段 := ""
            __new(坐标) {
                this.坐标   := 坐标
            }
        }
        初始化(地图, 初始蛇长, 蛇身色, 蛇头色) {
            this.蛇长 := (初始蛇长 < 2) ? 2 : 初始蛇长
            this.蛇身画刷:=DllCall("CreateSolidBrush"
                , "Uint", 地图.翻译RGB色(蛇身色)
                , "Uint")
            this.蛇头画刷:=DllCall("CreateSolidBrush"
                , "Uint", 地图.翻译RGB色(蛇头色)
                , "Uint")
            random, 横, 1, % 地图.块横数
            random, 纵, 1, % 地图.块纵数
            this.蛇头 := new this.蛇段({"横": 横, "纵": 纵})
            ;MsgBox, % "造蛇" 横 "-" 纵
            this.蛇头.前一段 := ""
            地图.设置块颜色(this.蛇头画刷, 横, 纵, this.占位名)
            当前段 := this.蛇头
            loop, % 初始蛇长 - 1
            {
                loop {
                    ;print("造蛇中:" A_Index)
                    random, 随机增值, 1, 4
                    增值 := [[0, -1], [0, 1], [1, 0], [-1, 0]][随机增值]
                    横 := 当前段.坐标.横 + 增值[1]
                    纵 := 当前段.坐标.纵 + 增值[2]
                    ;msgbox, % 地图["块", 横, 纵, "占位物"]
                } until ( ( 地图["块", 横, 纵, "占位物"] == 地图.空块占位名 )
                    and (not 横 > 地图.块横数)
                    and (not 横 < 1)
                    and (not 纵 > 地图.块纵数)
                    and (not 纵 < 0) )

                当前段.后一段          :=  new this.蛇段({"横": 横, "纵": 纵})
                当前段.后一段.前一段    := 当前段
                当前段                 := 当前段.后一段
                this.蛇尾 := 当前段
                地图.设置块颜色(this.蛇身画刷, 横, 纵, this.占位名)
            }

            ;msgbox, %  obj_dbg1(this.蛇尾.坐标)
        }

        调试蛇链表() {
            输出文本 := ""
            甲 := this.蛇头
            loop {
                if not 甲
                    break
                输出文本 .= "节:" 甲.坐标.横 "-" 甲.坐标.纵 "`n"
                甲 := 甲.后一段
            }
            return 输出文本
        }

        移动朝向(方向) {    ;~ 返回下一坐标
            static 朝向 := { ("上") : {"横增值":  0, "纵增值":-1}
                , ("下") : {"横增值":  0, "纵增值": 1}
                , ("左") : {"横增值": -1, "纵增值": 0}
                , ("右") : {"横增值":  1, "纵增值": 0} } 
            
            if (方向 = "") {
                增值逻辑 := this.取蛇头朝前逻辑()
                蛇头将至坐标 :=  { "横":this.蛇头.坐标.横 + 增值逻辑["横增值"]
                    , "纵":this.蛇头.坐标.纵 + 增值逻辑["纵增值"]}
            }
            else {
                增值逻辑 := 朝向[方向]
                蛇头将至坐标 :=  {  "横" : this.蛇头.坐标.横 + 增值逻辑.横增值
                    ,              "纵" : this.蛇头.坐标.纵 + 增值逻辑.纵增值  }

                if (    (蛇头将至坐标.横 = this.蛇头.后一段.坐标.横) 
                    &&  (蛇头将至坐标.纵 = this.蛇头.后一段.坐标.纵)    ) {
                    增值逻辑 := this.取蛇头朝前逻辑()
                    蛇头将至坐标 :=  { "横":this.蛇头.坐标.横 + 增值逻辑["横增值"]
                        , "纵":this.蛇头.坐标.纵 + 增值逻辑["纵增值"]}
                }
            }
            ;msgbox, % (A_LineNumber) ":" 蛇头将至坐标.横 "-" 蛇头将至坐标.纵
            return 蛇头将至坐标 
        }

        取蛇头朝前逻辑() {
            首横 := this.蛇头.坐标.横
            首纵 := this.蛇头.坐标.纵
            次横 := this.蛇头.后一段.坐标.横
            次纵 := this.蛇头.后一段.坐标.纵
  
            if (首横 = 次横 && 首纵 = 次纵) 
                增值逻辑 := {"横增值": 1, "纵增值": 0}
            else if (首横 = 次横) 
                增值逻辑 := {"横增值": 0, "纵增值": 首纵 - 次纵}
            else if (首纵 = 次纵) 
                增值逻辑 := {"横增值": 首横 - 次横, "纵增值": 0}
            else 
                增值逻辑 := {"横增值": 1, "纵增值": 0}

            return 增值逻辑
        }

        前进一格_并长大(地图, 蛇头将至坐标) {
            this.蛇长 += 1
            

            地图.设置块颜色(this.蛇头画刷, 蛇头将至坐标.横, 蛇头将至坐标.纵, this.占位名)
            地图.设置块颜色(this.蛇身画刷, this.蛇头.坐标.横, this.蛇头.坐标.纵, this.占位名)

            
            ;~ 蛇头与次段中间插入
            临时段 := this.蛇头.后一段
            this.蛇头.后一段 := new this.蛇段({"横": this.蛇头.坐标.横, "纵": this.蛇头.坐标.纵})
            this.蛇头.坐标 := {"横": 蛇头将至坐标.横, "纵": 蛇头将至坐标.纵}
            this.蛇头.后一段.前一段 := this.蛇头
            this.蛇头.后一段.后一段 := 临时段
            临时段.前一段 := this.蛇头.后一段
        }

        前进一格_不长大(地图, 蛇头将至坐标) {
            地图.设置块颜色(this.蛇身画刷, this.蛇头.坐标.横, this.蛇头.坐标.纵, this.占位名)
            地图.设置块颜色(this.蛇头画刷, 蛇头将至坐标.横, 蛇头将至坐标.纵, this.占位名)
            地图.设置块颜色(地图.空块色画刷, this.蛇尾.坐标.横, this.蛇尾.坐标.纵, 地图.空块占位名)

            ;~ 原来蛇头位置用新段填充
            临时段 := this.蛇头.后一段
            this.蛇头.后一段 := new this.蛇段({"横": this.蛇头.坐标.横, "纵": this.蛇头.坐标.纵})
            this.蛇头.坐标 := {"横": 蛇头将至坐标.横, "纵": 蛇头将至坐标.纵}
            this.蛇头.后一段.前一段 := this.蛇头
            this.蛇头.后一段.后一段 := 临时段
            临时段.前一段 := this.蛇头.后一段

            ;~ 原来蛇尾位置空
            this.蛇尾 := this.蛇尾.前一段
            this.蛇尾.后一段 := ""
            ;msgbox, % "移动-不长大:`n" this.调试蛇链表() "`n" obj_dbg1(this.蛇尾.坐标)
        }
    }

    class 食物
    {
        static 占位名 := "好吃的"
        static 食物色画刷
        static 当前坐标
        初始化(地图, 食物色) {
            this.食物色画刷:=DllCall("CreateSolidBrush"
                , "Uint", 地图.翻译RGB色(食物色)
                , "Uint")
            this.随机生成(地图)
        }

        随机生成(地图) {
            loop {
                random, 横, 1, % 地图.块横数
                random, 纵, 1, % 地图.块纵数
            } until ( 地图["块", 横, 纵, "占位物"] = 地图.空块占位名 )
                and (not 横 > 地图.块横数) 
                and (not 纵 > 地图.块纵数)
                and (not 横 < 1) 
                and (not 纵 < 0)
            ;msgbox, % this.食物色画刷 "-" 横 "-" 纵 "-" this.占位名
            地图.设置块颜色(this.食物色画刷, 横, 纵, this.占位名)
            this.当前坐标 := {"横": 横, "纵": 纵}
        }
    }
}


print(msg) {
	DBG_GUI.print(msg)
}

class DBG_GUI {
	static hwnd := ""
	init() {
		local x, y, w := 500, h := 150
		local sFont := "微软雅黑"
		Gui, dbgls: Font, , % sFont
		Gui, dbgls: destroy
		Gui, dbgls: +AlwaysOnTop +toolwindow +hwnd@main
		Gui, dbgls: Add, ListBox,  w%w% h%h%  hwnd@lb
		x := (A_ScreenWidth - w) / 2
		y := A_ScreenHeight - h - 100
		gui, dbgls: Show, Hide x%x% y%y%, 列表debug
		this.hwnd := @main
		this.lb   := @lb
		this.Msgs := []
	}

	show() {
		gui, dbgls: Show
	}

	hide() {
		gui, dbgls: hide
	}

	print(msg) {
		local i, v, ex
		static times := 0

		ex := A_DetectHiddenWindows
		DetectHiddenWindows, on
		;~ 不存在该窗口则重建
		if not (this.hwnd && winexist("ahk_id " this.hwnd))
			this.init()
		;~ 未显示该窗口则显示
		DetectHiddenWindows, off
		if not winexist("ahk_id " this.hwnd)
			this.show()

		DetectHiddenWindows, % ex
		times += 1
		if (this.Msgs.count() > 200) {
			this.Msgs.removeat(1, 50)
			this.Msgs.push(msg)
			GuiControl, , % this.lb, % " "
			GuiControl, , % this.lb, % "|"
			For i, v in this.Msgs
				GuiControl, , % this.lb, % times ": " v "||"
		} else {
			this.Msgs.push(msg)
			GuiControl, , % this.lb, % times ": " msg "||"
		}
	}
}

obj_dbg1(obj) {
    ret := ""
    if IsObject(obj) {
        ret .= "{"
        for key, var in obj
            ret .= key . " :" . obj_dbg1(var) . ", "
        if (key <> "")
            ret := SubStr(ret, 1, -2)
        ret .= "}"
    } else {
        if obj is number
            ret := obj
        else if (obj = "")
            ret = ""
        else
            ret := """" obj """"
    }
    return ret
}
