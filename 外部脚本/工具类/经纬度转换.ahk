;|3.0|2025.09.05|1711
CandySel := A_Args[1]
SetFormat, float, 0.8
pi := 3.14159265358979
ee := 0.00669342162296594
a := 6378245
x_pi := 3.14159265358979 * 3000 / 180

Gui,66: Default
Gui, Destroy

Gui, add, text, x7, 经纬度  :
Gui, Add, edit, x+10 w280 vjingweidu gchangevalue hwndHandle, %CandySel%
Gui, Add, Button, x+10 w30 ginputdu, °
Gui, Add, DropDownList, x+10 w100 vjingweidu_type, 度||度°分'|度°分'秒"
Gui, add, text, x7, 度      :
Gui, Add, edit, x+10 readonly w280 vjingweidu_du
Gui, add, text, x7, 度.分   :
Gui, Add, edit, x+10 readonly w280 vjingweidu_du_fen
Gui, add, text, x7, 度.分.秒:
Gui, Add, edit, x+10 readonly w280 vjingweidu_du_fen_miao

Gui, add, text, x7 yp+40, 多行转换
Gui, add, text, x7, ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔
Gui, add, text, x7, 源格式  :
Gui, Add, DropDownList, x+10 w100 vjingweidu_stype gchangetype, 度||度°分'|度°分'秒"|WGS84|GCJ-02|BD-09

Gui, Add, Button, x+100 w40 gchange, 转换

Gui, add, text, x+50, 目标格式:
Gui, Add, DropDownList, x+10 w100 vjingweidu_ttype, 度||度°分'|度°分'秒"|WGS84|GCJ-02|BD-09

Gui, add, Edit, x7 w280 r25 vvalue1,
Gui, add, Edit, xp+300 w280 r25 vvalue2,

Gui, Show, w600 h560, 经纬度转换
return

changetype:
Gui,66: Default
Gui Submit, nohide
if (jingweidu_stype = "度") or (jingweidu_stype = "度°分'") or (jingweidu_stype = "度°分'秒""")
{
  GuiControl,, jingweidu_ttype, |度||度°分'|度°分'秒"
}
else if (jingweidu_stype = "WGS84") or (jingweidu_stype = "GCJ-02") or (jingweidu_stype = "BD-09")
{
  GuiControl,, jingweidu_ttype, |WGS84||GCJ-02|BD-09
}
return

66GuiClose:
66Guiescape:
Gui,66: Destroy
exitapp
Return

change:
Gui,66: Default
Gui Submit, nohide
Tmp_Str := ""
if (jingweidu_stype = "度")
{
  if (jingweidu_ttype = "度°分'秒""")
  {
    loop, Parse, value1, `n, `r
    {
      if !Instr(A_LoopField, ",")
      {
        if A_LoopField
        {
          du := Floor(A_LoopField)
          fen_miao := A_LoopField - Floor(A_LoopField)
          fen := Floor(fen_miao * 60)
          miao := (fen_miao * 60 - fen) * 60
          Tmp_Str .= du "°" fen "'" miao """`n"
        }
      }
      else
      {
          Arr := StrSplit(A_LoopField, ",")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2
          du := Floor(Arr1), du2 := Floor(Arr2)
          fen_miao := Arr1 - Floor(Arr1), fen_miao2 := Arr2 - Floor(Arr2)
          fen := Floor(fen_miao * 60), fen2 := Floor(fen_miao2 * 60)
          miao := (fen_miao * 60 - fen) * 60, miao2 := (fen_miao2 * 60 - fen2) * 60
          Tmp_Str .= du "°" fen "'" miao """, " du2 "°" fen2 "'" miao2 """`n"
      }
    }
  }
  else if (jingweidu_ttype = "度°分'")
  {
    loop, Parse, value1, `n, `r
    {
      if !Instr(A_LoopField, ",")
      {
        if A_LoopField
        {
          du := Floor(A_LoopField)
          fen_miao := A_LoopField - du
          Tmp_Str .= du "°" fen_miao * 60 "'`n"
        }
      }
      else
      {
          Arr := StrSplit(A_LoopField, ",")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2
          du := Floor(Arr1), du2 := Floor(Arr2)
          fen_miao := Arr1 - du, fen_miao2 := Arr2 - du2
          Tmp_Str .= du "°" fen_miao * 60 "', " du2 "°" fen_miao2 * 60 "'`n"
      }
    }
  }
  GuiControl,, value2, % Tmp_Str
}
else if (jingweidu_stype = "度°分'")
{
  if (jingweidu_ttype = "度°分'秒""")
  {
    loop, Parse, value1, `n, `r
    {
      if !Instr(A_LoopField, ",")
      {
        if A_LoopField
        {
          Arr := StrSplit(A_LoopField, ["°", "'"], """")
          du := Arr[1], fen := Arr[2]
          fen_to_du := fen / 60
          miao := (fen - Floor(fen)) * 60
          Tmp_Str .= du "°" fen "'" miao """`n"
        }
      }
      else
      {
          Arr := StrSplit(A_LoopField, ",")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2
    Arr := StrSplit(Arr1, ["°", "'"], """ "), Brr := StrSplit(Arr2, ["°", "'"], """ ")
    du := Arr[1], fen := Arr[2], du2 := Brr[1], fen2 := Brr[2]
    fen_to_du := fen / 60, fen_to_du2 := fen2 / 60
    miao := (fen - Floor(fen)) * 60, miao2 := (fen2 - Floor(fen2)) * 60
          Tmp_Str .= du "°" Floor(fen) "'" miao """, " du2 "°" Floor(fen2) "'" miao2 """`n"
      }
    }
  }
  else if (jingweidu_ttype = "度")
  {
    loop, Parse, value1, `n, `r
    {
      if !Instr(A_LoopField, ",")
      {
        if A_LoopField
        {
          Arr := StrSplit(A_LoopField, ["°", "'"], """")
          du := Arr[1], fen := Arr[2]
          fen_to_du := fen / 60
          Tmp_Str .= du + fen_to_du "`n"
        }
      }
      else
      {
          Arr := StrSplit(A_LoopField, ",")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2
    Arr := StrSplit(Arr1, ["°", "'"], """"), Brr := StrSplit(Arr2, ["°", "'"], """")
    du := Arr[1], fen := Arr[2], du2 := Brr[1], fen2 := Brr[2]
    fen_to_du := fen / 60, fen_to_du2 := fen2 / 60
          Tmp_Str .= du + fen_to_du ", " du2 + fen_to_du2 "`n"
      }
    }
  }
    GuiControl,, value2, % Tmp_Str
}
else if (jingweidu_stype = "度°分'秒""")
{
  if (jingweidu_ttype = "度")
  {
    loop, Parse, value1, `n, `r
    {
      if !Instr(A_LoopField, ",")
      {
        if A_LoopField
        {
          Arr := StrSplit(A_LoopField, ["°", "'"], """")
          du := Arr[1], fen := Arr[2], miao := Arr[3]
          fen_miao_to_du := fen / 60 + miao / 3600
          Tmp_Str .= du + fen_miao_to_du "`n"
        }
      }
      else
      {
          Arr := StrSplit(A_LoopField, ",")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2

          Arr := StrSplit(Arr1, ["°", "'"], """ "), Brr := StrSplit(Arr2, ["°", "'"], """ ")
    du := Arr[1], fen := Arr[2], miao := Arr[3], du2 := Brr[1], fen2 := Brr[2], miao2 := Brr[3]
    fen_miao_to_du := fen / 60 + miao / 3600, fen_miao_to_du2 := fen2 / 60 + miao2 / 3600
          Tmp_Str .= du + fen_miao_to_du ", " du2 + fen_miao_to_du2 "`n"

      }
    }
  }
  else if (jingweidu_ttype = "度°分'")
  {
    loop, Parse, value1, `n, `r
    {
      if !Instr(A_LoopField, ",")
      {
        if A_LoopField
        {
          Arr := StrSplit(A_LoopField, ["°", "'"], """")
          du := Arr[1], fen := Arr[2], miao := Arr[3]
          miao_to_fen := fen + miao / 60
          Tmp_Str .= du "°" miao_to_fen "'`n"
        }
      }
      else
      {
          Arr := StrSplit(A_LoopField, ",")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2

          Arr := StrSplit(Arr1, ["°", "'"], """ "), Brr := StrSplit(Arr2, ["°", "'"], """ ")
    du := Arr[1], fen := Arr[2], miao := Arr[3], du2 := Brr[1], fen2 := Brr[2], miao2 := Brr[3]
        miao_to_fen := fen + miao / 60, miao_to_fen2 := fen2 + miao2 / 60
          Tmp_Str .= du "°" miao_to_fen "', " du2 "°" miao_to_fen2 "'`n"
      }
    }
  }
    GuiControl,, value2, % Tmp_Str
}
else if (jingweidu_stype = "WGS84")
{
  if (jingweidu_ttype = "GCJ-02")
  {
    loop, Parse, value1, `n, `r
    {
          Arr := StrSplit(A_LoopField, ",", " ")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2

          Tmp_Str .= WGS84_To_GaoDe(Arr1, Arr2) "`n"
    }
  }
  else if (jingweidu_ttype = "BD-09")
  {
    loop, Parse, value1, `n, `r
    {
          Arr := StrSplit(A_LoopField, ",")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2

          Tmp_Str .= WGS84_To_BaiDu(Arr1, Arr2) "'`n"
    }
  }
    GuiControl,, value2, % Tmp_Str
}
else if (jingweidu_stype = "GCJ-02")
{
  if (jingweidu_ttype = "WGS84")
  {
    loop, Parse, value1, `n, `r
    {
          Arr := StrSplit(A_LoopField, ",", " ")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2

          ;Tmp_Str .= GaoDe_To_WGS84(Arr1, Arr2) "`n"
Tmp_Str .= gcj02towgs84(Arr1, Arr2) "`n"
    }
  }
  else if (jingweidu_ttype = "BD-09")
  {
    loop, Parse, value1, `n, `r
    {
          Arr := StrSplit(A_LoopField, ",")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2

          Tmp_Str .= GaoDe_To_BaiDu(Arr1, Arr2) "'`n"
    }
  }
    GuiControl,, value2, % Tmp_Str
}
else if (jingweidu_stype = "BD-09")
{
  if (jingweidu_ttype = "GCJ-02")
  {
    loop, Parse, value1, `n, `r
    {
          Arr := StrSplit(A_LoopField, ",", " ")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2

          Tmp_Str .= BaiDu_To_GaoDe(Arr1, Arr2) "`n"
    }
  }
  else if (jingweidu_ttype = "WGS84")
  {
    loop, Parse, value1, `n, `r
    {
          Arr := StrSplit(A_LoopField, ",")
          Arr1 := Arr[1]
          Arr2 := Arr[2]
          ;msgbox % Arr1 " - " Arr2

          Tmp_Str .= BaiDu_To_WGS84(Arr1, Arr2) "'`n"
    }
  }
    GuiControl,, value2, % Tmp_Str
}
return

inputdu:
;nochang := 1
Gui,66: Default
Gui Submit, nohide
GuiControl,, jingweidu, % jingweidu "°"
GuiControl, Focus, jingweidu
SendMessage, 0xB1, -2, -1,, ahk_id %Handle%
SendMessage, 0xB7,,,, ahk_id %Handle%
/*
 EM_SETSEL := 0x00B1 this allows to set the selection, for now character 5 .. 10
now play with the numbers, 0 = first character, 1 = second character, ..., -1 = last character
I found -2 to useful for putting the caret at the end, but with an empty selection.
Beware: to use -2 for StartPosition is undocumented, or it is documented and I could not find it.

-> scrolls the caret into view. EM_SCROLLCARET := 0x00B7

*/
return

changevalue:
;if nochang
;  return
Gui,66: Default
Gui Submit, nohide
if Instr(jingweidu, """")
  GuiControl, Choose, jingweidu_type, 3
else if !Instr(jingweidu, "°")
  GuiControl, Choose, jingweidu_type, 1
else if Instr(jingweidu, "'") && !Instr(jingweidu, """") && Instr(jingweidu, "°")
  GuiControl, Choose, jingweidu_type, 2

Gui Submit, nohide

if (jingweidu_type = "度")
{
  if Instr(jingweidu, ",")
  {
    Arr := StrSplit(jingweidu, ",", " """)
    Arr1 := Arr[1]
    Arr2 := Arr[2]
  }
  else
    Arr1 := jingweidu
  if !Instr(jingweidu, ",")
  {
    du := Floor(Arr1)
    fen_miao := Arr1 - Floor(Arr1)
    fen := Floor(fen_miao * 60)
    miao := (fen_miao * 60 - fen) * 60
    GuiControl,, jingweidu_du, % Arr1
    GuiControl,, jingweidu_du_fen, % du "°" fen_miao * 60 "'"
    GuiControl,, jingweidu_du_fen_miao, % du "°" fen "'" miao """"
  }
  else
  {
    du := Floor(Arr1), du2 := Floor(Arr2)
    fen_miao := Arr1 - Floor(Arr1), fen_miao2 := Arr2 - Floor(Arr2)
    fen := Floor(fen_miao * 60), fen2 := Floor(fen_miao2 * 60)
    miao := (fen_miao * 60 - fen) * 60, miao2 := (fen_miao2 * 60 - fen2) * 60
    GuiControl,, jingweidu_du, % Arr1 ", " Arr2
    GuiControl,, jingweidu_du_fen, % du "°" fen_miao * 60 "', " du2 "°" fen_miao2 * 60 "'"
    GuiControl,, jingweidu_du_fen_miao, % du "°" fen "'" miao """, " du2 "°" fen2 "'" miao2 """"
  }
}
else if (jingweidu_type = "度°分'秒""")
{
  if Instr(jingweidu, ",")
  {
    Arr := StrSplit(jingweidu, ",", " """)
    Arr1 := Arr[1]
    Arr2 := Arr[2]
  }
  else
    Arr1 := jingweidu

  if !Instr(jingweidu, ",")
  {
    Arr := StrSplit(Arr1, ["°", "'"], """")
    du := Arr[1], fen := Arr[2], miao := Arr[3]
    fen_miao_to_du := fen / 60 + miao / 3600
    miao_to_fen := fen + miao / 60
    GuiControl,, jingweidu_du, % du + fen_miao_to_du
    GuiControl,, jingweidu_du_fen, % du "°" miao_to_fen "'"
    GuiControl,, jingweidu_du_fen_miao, % Arr1
  }
  else
  {
    ;MSGBOX % Arr2
    Arr := StrSplit(Arr1, ["°", "'"], """"), Brr := StrSplit(Arr2, ["°", "'"], """")
    du := Arr[1], fen := Arr[2], miao := Arr[3], du2 := Brr[1], fen2 := Brr[2], miao2 := Brr[3]
    fen_miao_to_du := fen / 60 + miao / 3600, fen_miao_to_du2 := fen2 / 60 + miao2 / 3600
    miao_to_fen := fen + miao / 60, miao_to_fen2 := fen2 + miao2 / 60
    GuiControl,, jingweidu_du, % du + fen_miao_to_du ", " du2 + fen_miao_to_du2
    GuiControl,, jingweidu_du_fen, % du "°" miao_to_fen "', " du2 "°" miao_to_fen2 "'"
    GuiControl,, jingweidu_du_fen_miao, % Arr1 ", " Arr2
  }
}
else
{
  if Instr(jingweidu, ",")
  {
    Arr := StrSplit(jingweidu, ",")
    Arr1 := Arr[1]
    Arr2 := Arr[2]
  }
  else
    Arr1 := jingweidu

  if !Instr(jingweidu, ",")
  {
    Arr := StrSplit(Arr1, ["°", "'"], """")
    du := Arr[1], fen := Arr[2]
    fen_to_du := fen / 60
    miao := (fen - Floor(fen)) * 60
    GuiControl,, jingweidu_du, % du + fen_to_du
    GuiControl,, jingweidu_du_fen, % Arr1
    GuiControl,, jingweidu_du_fen_miao, % du "°" Floor(fen) "'" miao """"
  }
  else
  {
    Arr := StrSplit(Arr1, ["°", "'"], """"), Brr := StrSplit(Arr2, ["°", "'"], """")
    du := Arr[1], fen := Arr[2], du2 := Brr[1], fen2 := Brr[2]
    fen_to_du := fen / 60, fen_to_du2 := fen2 / 60
    miao := (fen - Floor(fen)) * 60, miao2 := (fen2 - Floor(fen2)) * 60
    GuiControl,, jingweidu_du, % du + fen_to_du ", " du2 + fen_to_du2
    GuiControl,, jingweidu_du_fen, % Arr1 "', " Arr2
    GuiControl,, jingweidu_du_fen_miao, % du "°" Floor(fen) "'" miao """, " du2 "°" Floor(fen2) "'" miao2 """"
  }
}
return


WGS84_To_GaoDe(wgLon, wgLat)
{
global pi, ee, a, x_pi

    If outOfChina(wgLat, wgLon)   ;//不在中国坐标范围
      return WGS84_To_GaoDe := wgLon "," wgLat

    dlat := transformLat(wgLon - 105, wgLat - 35)
    dlon := transformLon(wgLon - 105, wgLat - 35)
;msgbox %  dlon " - " dlat
    radlat := wgLat / 180 * pi
    magic := Sin(radlat)
    magic := 1 - ee * magic * magic
    sqrtmagic := Sqrt(magic)
;msgbox %  magic " - " sqrtmagic
;msgbox %  dlat * 180
    dlat := (dlat * 180) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi)
    dlon := (dlon * 180) / (a / sqrtmagic * Cos(radlat) * pi)
;msgbox %  dlon " - " dlat
   mglon := Format("{:.6f}", wgLon + dlon)
   mglat := Format("{:.6f}", wgLat + dlat)
    WGS84_To_GaoDe := mglon "," mglat
;msgbox % WGS84_To_GaoDe
return WGS84_To_GaoDe
}

outOfChina(lat, lon)
{
    If (lon < 72.004 Or lon > 137.8347) And (lat < 0.8293 Or lat > 55.8271)
        outOfChina := True
    Else
        outOfChina := False
  return outOfChina
}

transformLat(X , Y)
{
global pi, ee, a, x_pi
    ret := -100 + 2 * X + 3 * Y + 0.2 * Y * Y + 0.1 * X * Y + 0.2 * Sqrt(Abs(X))
    ret := ret + (20 * Sin(6 * X * pi) + 20 * Sin(2 * X * pi)) * 2 / 3
    ret := ret + (20 * Sin(Y * pi) + 40 * Sin(Y / 3 * pi)) * 2 / 3
    ret := ret + (160 * Sin(Y / 12 * pi) + 320 * Sin(Y * pi / 30)) * 2 / 3
    return ret
}

transformLon(X, Y)
{
global pi, ee, a, x_pi
    ret := 300 + X + 2 * Y + 0.1 * X * X + 0.1 * X * Y + 0.1 * Sqrt(Abs(X))
    ret := ret + (20 * Sin(6 * X * pi) + 20 * Sin(2 * X * pi)) * 2 / 3
    ret := ret + (20 * Sin(X * pi) + 40 * Sin(X / 3 * pi)) * 2 / 3
    ret := ret + (150 * Sin(X / 12 * pi) + 300 * Sin(X / 30 * pi)) * 2 / 3
    return ret
}

GaoDe_To_WGS84(X, Y)   ;高德到WG84
{
global pi, ee, a, x_pi
    z := Sqrt(X * X + Y * Y) + 0.00002 * Sin(Y * x_pi)
    theta := Atn2(Y, X) + 0.000003 * Cos(X * x_pi)
    bd_lon := z * Cos(theta) + 0.0065
    bd_lat := z * Sin(theta) + 0.006
   ;msgbox % bd_lat
;msgbox % gps_bd(bd_lon, bd_lat)
    Arr := StrSplit(gps_bd(bd_lon, bd_lat), ",")
    X := Arr[1]
    Y := Arr[2]
;msgbox % X " - " bd_lon
    GaoDe_To_WGS84 := Round(bd_lon * 2 - X, 6) "," Round(bd_lat * 2 - Y, 6)
  return GaoDe_To_WGS84
}

gcj02towgs84(lng, lat)
{
global pi, ee, a, x_pi
  if (outOfChina(lat, lng)) {
    return lng "," lat
  }
  else {
    dlat := transformlat(lng - 105.0, lat - 35.0)
    dlng := transformLon(lng - 105.0, lat - 35.0)

    radlat := lat / 180.0 * PI
    magic := Sin(radlat)
    magic := 1 - ee * magic * magic
    sqrtmagic := Sqrt(magic)
    dlat := (dlat * 180.0) / ((a * (1 - ee)) / (magic * sqrtmagic) * PI)
    dlng := (dlng * 180.0) / (a / sqrtmagic * Cos(radlat) * PI)
;msgbox % dlat " - " dlng
    mglat := lat + dlat
    mglng := lng + dlng
    return Round(lng * 2 - mglng, 6) "," Round(lat * 2 - mglat, 6)
  }
}

Atn2(numY, numX)
{
global pi, ee, a, x_pi
    If numX > 0 
        Atn2 := ATan(numY / numX)
    Else If numX = 0
    {
        If numY > 0 
            Atn2 := pi / 2
        Else If numY < 0 
            Atn2 := -pi / 2
   }
    Else
    {
        If numY >= 0 
            Atn2 := pi + ATan(numY / numX)
        Else
            Atn2 := ATan(numY / numX) - pi
    }
return Atn2
}

gps_bd(wgLon, wgLat)    ;GPS转换为百度(先转火星再再火星转百度）
{
/*
    If outOfChina(wgLat, wgLon) = True Then    ' //不再中国坐标范围
        gps_bd = wgLon & "," & wgLat

        Exit Function
    End If
*/
global pi, ee, a, x_pi

    If outOfChina(wgLat, wgLon)   ;//不在中国坐标范围
      return gps_bd := wgLon "," wgLat

    dlat := transformLat(wgLon - 105, wgLat - 35)
    dlon := transformLon(wgLon - 105, wgLat - 35)

    radlat := wgLat / 180 * pi
    magic := Sin(radlat)
    magic := 1 - ee * magic * magic
    sqrtmagic := Sqrt(magic)
    dlat := (dlat * 180) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi)
    dlon := (dlon * 180) / (a / sqrtmagic * Cos(radlat) * pi)
;msgbox % dlat " - " dlon
    mglon := wgLon + dlon
    mglat := wgLat + dlat
;msgbox % mglon
    Arr := StrSplit(GE_BD(mglon, mglat), ",")
    X := Arr[1]
    Y := Arr[2]

    gps_bd := X "," Y
return gps_bd
}

;'第2步  火星坐标系 (GCJ-02) 到百度坐标系 (BD-09) 的转换 （对应 百度地图坐标）
GE_BD(gg_lon, gg_lat)    ;谷歌到百度
{
global pi, ee, a, x_pi
    X := gg_lon, Y := gg_lat
    z := Sqrt(X * X + Y * Y) + 0.00002 * Sin(Y * x_pi)
    theta := Atn2(Y, X) + 0.000003 * Cos(X * x_pi)
    bd_lon := z * Cos(theta) + 0.0065
    bd_lat := z * Sin(theta) + 0.006
;msgbox % bd_lon
    GE_BD := bd_lon "," bd_lat
return GE_BD
}

WGS84_To_BaiDu(wgLon, wgLat)    ;GPS转换为百度(先转火星再再火星转百度）
{
/*
    If outOfChina(wgLat, wgLon) = True Then    ' //不再中国坐标范围
        WGS84_To_BaiDu = wgLon & "," & wgLat

        Exit Function
    End If
*/
    global pi, ee, a, x_pi

    If outOfChina(wgLat, wgLon)   ; //不在中国坐标范围
      return WGS84_To_BaiDu := wgLon "," wgLat

    dlat := transformLat(wgLon - 105, wgLat - 35)
    dlon := transformLon(wgLon - 105, wgLat - 35)
    radlat := wgLat / 180 * pi
    magic := Sin(radlat)
    magic := 1 - ee * magic * magic
    sqrtmagic := Sqrt(magic)
    dlat := (dlat * 180) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi)
    dlon := (dlon * 180) / (a / sqrtmagic * Cos(radlat) * pi)
    mglon := wgLon + dlon
    mglat := wgLat + dlat
    
    Arr := StrSplit(GE_BD(mglon, mglat), ",")
    X := Arr[1]
    Y := Arr[2]

    WGS84_To_BaiDu := Format("{:.6f}", X) "," Format("{:.6f}", Y)
return WGS84_To_BaiDu
}

BaiDu_To_WGS84(lon, lat)    ;百度坐标转GPS坐标（利用2次百度坐标转换计算
{
    global pi, ee, a, x_pi
    Arr := StrSplit(gps_bd(lon, lat), ",")
    X := Arr[1]
    Y := Arr[2]

    BaiDu_To_WGS84 := Format("{:.6f}", lon * 2 - X)  ","  Format("{:.6f}", lat * 2 - Y)
return BaiDu_To_WGS84
}

BaiDu_To_GaoDe(bd_lon, bd_lat)    ;百度到谷歌
{
    global pi, ee, a, x_pi
    X := bd_lon - 0.0065, Y := bd_lat - 0.006
    z := Sqrt(X * X + Y * Y) - 0.00002 * Sin(Y * x_pi)
    theta := Atn2(Y, X) - 0.000003 * Cos(X * x_pi)
    gg_lon := Format("{:.6f}", z * Cos(theta))
    gg_lat := Format("{:.6f}", z * Sin(theta))

    BaiDu_To_GaoDe := gg_lon  ","  gg_lat
return BaiDu_To_GaoDe
}

GaoDe_To_BaiDu(gg_lon, gg_lat)    ;谷歌到百度
{
    global pi, ee, a, x_pi
    X := gg_lon, Y := gg_lat
    z := Sqrt(X * X + Y * Y) + 0.00002 * Sin(Y * x_pi)
    theta := Atn2(Y, X) + 0.000003 * Cos(X * x_pi)
    bd_lon := Format("{:.6f}", z * Cos(theta) + 0.0065)
    bd_lat := Format("{:.6f}", z * Sin(theta) + 0.006)
    GaoDe_To_BaiDu := bd_lon  ","  bd_lat
return GaoDe_To_BaiDu
}

/*
Function gps_ge(wgLat As Double, wgLon As Double)    '第1 步 地球坐标系 (WGS-84) 到火星坐标系 (GCJ-02) 的转换  （对应 Google 地图坐标）

    If outOfChina(wgLat, wgLon) = True Then    ' //不再中国坐标范围
        gps_ge = wgLon & "," & wgLat

        Exit Function
    End If
    Dim dlat, dlon, radlat, magic, sqrtmagic, mglat, mglon As Double

    dlat = transformLat(wgLon - 105#, wgLat - 35#)
    dlon = transformLon(wgLon - 105#, wgLat - 35#)
    radlat = wgLat / 180# * pi
    magic = Sin(radlat)
    magic = 1 - ee * magic * magic
    sqrtmagic = Sqr(magic)
    dlat = (dlat * 180#) / ((a * (1 - ee)) / (magic * sqrtmagic) * pi)
    dlon = (dlon * 180#) / (a / sqrtmagic * Cos(radlat) * pi)
    mglon = wgLon + dlon
    mglat = wgLat + dlat
    gps_ge = mglat & "," & mglon

End Function


Function GE_WG84(str)    '谷歌到WG84

    Dim X, Y, z, theta, gg_lon, gg_lat As Double
    Dim bd_lon As Double
    Dim bd_lat As Double
    X = Split(str, ",")(0): Y = Split(str, ",")(1)
    z = Sqr(X * X + Y * Y) + 0.00002 * Sin(Y * x_pi)
    theta = Atn2(Y, X) + 0.000003 * Cos(X * x_pi)
    bd_lon = z * Cos(theta) + 0.0065
    bd_lat = z * Sin(theta) + 0.006
    
    X = Val(Split(gps_bd(bd_lon, bd_lat), ",")(0))
    Y = Val(Split(gps_bd(bd_lon, bd_lat), ",")(1))

    GE_WG84 = bd_lon * 2 - X & "," & bd_lat * 2 - Y

End Function

Function GE_WG84_1(X, Y)   '谷歌到WG84

    Dim z, theta, gg_lon, gg_lat As Double
    Dim bd_lon As Double
    Dim bd_lat As Double

    z = Sqr(X * X + Y * Y) + 0.00002 * Sin(Y * x_pi)
    theta = Atn2(Y, X) + 0.000003 * Cos(X * x_pi)
    bd_lon = z * Cos(theta) + 0.0065
    bd_lat = z * Sin(theta) + 0.006
    
    X = Val(Split(gps_bd(bd_lon, bd_lat), ",")(0))
    Y = Val(Split(gps_bd(bd_lon, bd_lat), ",")(1))

    GE_WG84_1 = bd_lon * 2 - X & "," & bd_lat * 2 - Y

End Function

Function DISTANCE(ByVal lon1 As Double, ByVal lat1 As Double, ByVal lon2 As Double, ByVal lat2 As Double) As Double
    '经纬度计算距离公式，得出结果单位为米
    DISTANCE = 6378137 * 2 * Application _
    .ASin(Sqr(SumSq(Sin((Radians(lat1) - Radians(lat2)) / 2)) + Cos(Radians(lat1)) * _
    Cos(Radians(lat2)) * SumSq(Sin((Radians(lon1) - Radians(lon2)) / 2))))
End Function
Function Radians(latORlon As Double) As Double
    '度转换成弧度公式为X*π/180
    PI14 = 3.14159265358979
    Radians = latORlon * PI14 / 180
End Function
Function SumSq(xx As Double) As Double
    SumSq = xx * xx
End Function

*/