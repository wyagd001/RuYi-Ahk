该文件夹下的脚本为 [如一.exe] 外接的内置子脚本, OnMessage(0x4a, "Receive_WM_COPYDATA") 执行一次后, 响应 如一.exe 发来的消息.   
利用 Ahk_H 的 dll 文件引入多线程, 使编译后的 exe 文件能加载外部的 ahk 文件.  