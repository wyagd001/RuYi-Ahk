;|2.7|2024.07.03|1367
#SingleInstance
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e75f.ico"
Menu, Tray, UseErrorLevel
Menu, Tray, Icon, % A_ScriptDir "\..\..\脚本图标\如意\e94d.ico"
Gui, Add, Text, x5 y5, 请输入 4 个数字:
Gui, Add, Edit, xp+120 yp  w60 h25 vnum1, 
Gui, Add, Edit, xp+70 yp w60 h25 vnum2,
Gui, Add, Edit, xp+70 yp w60 h25 vnum3,
Gui, Add, Edit, xp+70 yp w60 h25 vnum4,
Gui, Add, Button, xp+70 yp w90 ggenresult, 显示计算结果
Gui, Add, Edit, x5 yp+30 w390 r8 vresultedit,
Gui, Add, Button, xp+400 yp w90 grandomnum, 随机生成
gui, Show,, 24 点计算
return

genresult:
Gui, Submit, NoHide
result := main(num1, num2, num3, num4)
GuiControl,, resultedit, % result
return

randomnum:
loop 4
{
	Random, OutputVar, 1, 10
	GuiControl,, num%A_Index%, % OutputVar
}
return

GuiClose:
GuiEscape:
gui, Destroy
ExitApp
return

main(a, b, c, d)
{
	str .= get(a, b, c, d)
	str .= get(a, b, d, c)
	str .= get(a, c, b, d)
	str .= get(a, c, d, b)
	str .= get(a, d, b, c)
	str .= get(a, d, c, b)
	str .= get(b, a, c, d)
	str .= get(b, a, d, c)
	str .= get(b, c, a, d)
	str .= get(b, c, d, a)
	str .= get(b, d, a, c)
	str .= get(b, d, c, a)
	str .= get(c, a, b, d)
	str .= get(c, a, d, b)
	str .= get(c, b, a, d)
	str .= get(c, b, d, a)
	str .= get(c, d, a, b)
	str .= get(c, d, b, a)
	str .= get(d, a, b, c)
	str .= get(d, a, c, b)
	str .= get(d, b, a, c)
	str .= get(d, b, c, a)
	str .= get(d, c, a, b)
	str .= get(d, c, b, a)
	return str
}

get(a, b, c, d)
{
	mark1 := mark2 := mark3 := flag := 0
	mark := ["+", "-", "*", "/"]
  loop 4
  {
		mark1++
    loop 4
    {
			mark2++
			if mark2 = 5
					mark2 = 1
      loop 4
      {
				mark3++
				if mark3 = 5
					mark3 = 1
				;MsgBox % calculate_A(a,b,c,d,mark1,mark2,mark3)
        if(calculate_A(a,b,c,d,mark1,mark2,mark3)=24)
        {
          str .= "((" a mark[mark1] b ")" mark[mark2] c ")" mark[mark3] d "`n"
          flag = 1
        }
        if(calculate_B(a,b,c,d,mark1,mark2,mark3)=24)
        {
          str .= "(" a mark[mark1] "(" b mark[mark2] c "))" mark[mark3] d "`n"
          ;msgbox % a "|" b "|" c "|" d
          flag = 2
        }
        if(calculate_C(a,b,c,d,mark1,mark2,mark3)=24)
        {
          str .= a mark[mark1] "(" b mark[mark2] "(" c mark[mark3] d "))`n"
          flag=3
        }
        if(calculate_D(a,b,c,d,mark1,mark2,mark3)=24)
        {
          str .= a mark[mark1] "((" b mark[mark2] c ")" mark[mark3] d ")`n"
          flag=4
        }
        if(calculate_E(a,b,c,d,mark1,mark2,mark3)=24)
        {
          str .= "(" a mark[mark1] b ")" mark[mark2] "(" c mark[mark3] d ")`n"
          flag=5
        }
      }
    }
  }
	if flag
{
  ;msgbox % str " | " flag
  return str
}
	else
	return ""
}

cal(x, y, mark)
{
  switch mark
  {
    case 1: return x+y
    case 2: return x-y
    case 3: return x*y
    case 4: return x/y
  }
}

calculate_A(a,b,c,d, mark1, mark2, mark3)
{
  r1 := cal(a, b, mark1)
  r2 := cal(r1, c, mark2)
  r3 := cal(r2, d, mark3)
  return r3
}

calculate_B(a,b,c,d, mark1, mark2, mark3)
{
  r1 := cal(b, c, mark2)
  r2 := cal(a, r1, mark1)
  r3 := cal(r2, d, mark3)
  return r3
}

calculate_C(a,b,c,d, mark1, mark2, mark3)
{
  r1 := cal(c, d, mark3)
  r2 := cal(b, r1, mark2)
  r3 := cal(a, r2, mark1)
  return r3
}

calculate_D(a,b,c,d, mark1, mark2, mark3)
{
  r1 := cal(b, c, mark2)
  r2 := cal(r1, d, mark3)
  r3 := cal(a, r2, mark1)
  return r3
}

calculate_E(a,b,c,d, mark1, mark2, mark3)
{
  r1 := cal(a, b, mark1)
  r2 := cal(c, d, mark3)
  r3 := cal(r1, r2, mark2)
  return r3
}

/*
#include<stdio.h>
char mark[4]={'+','-','*','/'};
float cal(float x,float y,int mark)
{
  switch(mark)
  {
    case 0:return x+y;
    case 1:return x-y;
    case 2:return x*y;
    case 3:return x/y;
  }
}
float calculate_A(float a,float b,float c,float d,int mark1,int mark2,int mark3)
{
  float r1,r2,r3;
  r1=cal(a,b,mark1);
  r2=cal(r1,c,mark2);
  r3=cal(r2,d,mark3);
  return r3;
}
float calculate_B(float a,float b,float c,float d,int mark1,int mark2,int mark3)
{
  float r1,r2,r3;
  r1=cal(b,c,mark2);
  r2=cal(a,r1,mark1);
  r3=cal(r2,d,mark3);
  return r3;
}
float calculate_C(float a,float b,float c,float d,int mark1,int mark2,int mark3)
{
  float r1,r2,r3;
  r1=cal(c,d,mark3);
  r2=cal(b,r1,mark2);
  r3=cal(a,r2,mark1);
  return r3;
}
float calculate_D(float a,float b,float c,float d,int mark1,int mark2,int mark3)
{
  float r1,r2,r3;
  r1=cal(b,c,mark2);
  r2=cal(r1,d,mark3);
  r3=cal(a,r2,mark1);
  return r3;
}
float calculate_E(float a,float b,float c,float d,int mark1,int mark2,int mark3)
{
  float r1,r2,r3;
  r1=cal(a,b,mark1);
  r2=cal(c,d,mark3);
  r3=cal(r1,r2,mark2);
  return r3;
}
float get(int a,int b,int c,int d)
{
  int mark1,mark2,mark3;
  float flag=0;
  for(mark1=0;mark1<4;mark1++)
  {
    for(mark2=0;mark2<4;mark2++)
    {
      for(mark3=0;mark3<4;mark3++)
      {
        if(calculate_A(a,b,c,d,mark1,mark2,mark3)==24)
        {
          printf("((%d%c%d)%c%d)%c%d=24\n",a,mark[mark1],b,mark[mark2],c,mark[mark3],d);
          flag=1;
        }
        if(calculate_B(a,b,c,d,mark1,mark2,mark3)==24)
        {
          printf("(%d%c(%d%c%d))%c%d=24\n",a,mark[mark1],b,mark[mark2],c,mark[mark3],d);
          flag=1;
        }
        if(calculate_C(a,b,c,d,mark1,mark2,mark3)==24)
        {
          printf("%d%c(%d%c(%d%c%d))=24\n",a,mark[mark1],b,mark[mark2],c,mark[mark3],d);
          flag=1;
        }
        if(calculate_D(a,b,c,d,mark1,mark2,mark3)==24)
        {
          printf("%d%c((%d%c%d)%c%d)=24\n",a,mark[mark1],b,mark[mark2],c,mark[mark3],d);
          flag=1;
        }
        if(calculate_E(a,b,c,d,mark1,mark2,mark3)==24)
        {
          printf("(%d%c%d)%c(%d%c%d)=24\n",a,mark[mark1],b,mark[mark2],c,mark[mark3],d);
          flag=1;
        }
      }
    }
  }
  return flag;
}
main()
{
  int a,b,c,d;
  printf("Please input 4 numbers(1~13):");
  scanf("%d%d%d%d",&a,&b,&c,&d);
    if((a>=1&&a<=13)&&(b>=1&&b<=13)&&(c>=1&&c<=13)&&(d>=1&&d<=13))
    {
      get(a,b,c,d);
    }
      else
      {
        printf("Input illegal,please input again(1~13):");
        scanf("%d%d%d%d",&a,&b,&c,&d);
        if((a>=1&&a<=13)&&(b>=1&&b<=13)&&(c>=1&&c<=13)&&(d>=1&&d<=13))
         {
              get(a,b,c,d);
         }
      }
  system("pause");
}
*/