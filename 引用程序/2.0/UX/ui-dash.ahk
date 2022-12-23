; Dash: AutoHotkey's "main menu".
; Run the script to show the GUI.
#include inc\bounce-v1.ahk
/* v1 stops here */
#requires AutoHotkey v2.0-beta.3

#NoTrayIcon
#SingleInstance Force

#include inc\ui-base.ahk
#include ui-launcherconfig.ahk
#include ui-editor.ahk
#include ui-newscript.ahk

class AutoHotkeyDashGui extends AutoHotkeyUxGui {
    __new() {
        super.__new("AutoHotkey")
        
        lv := this.AddListMenu('vLV LV0x40 w300', ["Name", "Desc"])
        lv.OnEvent("Click", "ItemClicked")
        lv.OnEvent("ItemFocus", "ItemFocused")
        lv.OnNotify(-155, "KeyPressed")
        
        this.AddButton("xp yp wp yp Hidden Default").OnEvent("Click", "EnterPressed")
        
        il := IL_Create(,, true)
        lv.SetImageList(il, 0)
        il2 := IL_Create(,, false)
        lv.SetImageList(il2, 1)
        addIcon(p*) =>(IL_Add(il, p*), IL_Add(il2, p*))
        
        lv.Add("Icon" addIcon(A_AhkPath, 2)
            , "New script", "Create a script or manage templates")
        lv.Add("Icon" addIcon("imageres.dll", -111)
            , "Compile", "Open Ahk2Exe - convert .ahk to .exe")
        lv.Add("Icon" addIcon("imageres.dll", -99)
            , "Help files (F1)")
        lv.Add("Icon" addIcon("shell32.dll", -281)
            , "Window spy")
        lv.Add("Icon" addIcon("imageres.dll", -116)
            , "Launch settings", "Configure how .ahk files are opened")
        lv.Add("Icon" addIcon("notepad.exe", 1)
            , "Editor settings", "Set your default script editor")
        ; lv.Add("Icon" addIcon("mmc.exe")
        ;     , "Maintenance", "Repair settings or add/remove versions")
        ; lv.Add(, "Auto-start", "Run scripts automatically at logon")
        ; lv.Add(, "Downloads", "Get related tools")
        
        lv.AutoSize()
        lv.GetPos(,, &w, &h)
        this.Show("Hide w" (w + this.MarginX*2) " h" (h + this.MarginY*2))
        ; this.AddPicture("Icon-114 w16 h16 y" 18+h, "imageres.dll")
    }
    
    KeyPressed(lv, lParam) {
        switch NumGet(lParam, A_PtrSize * 3, "Short") {
        case 0x70: ; F1
            ShowHelpFile()
        }
    }
    
    EnterPressed(*) {
        lv := this["LV"]
        this.ItemClicked(lv, lv.GetNext(,'F'))
    }
    
    ItemClicked(lv, item) {
        switch item && RegExReplace(lv.GetText(item), ' .*') {
        case "New":
            NewScriptGui.Show()
        case "Compile":
            if WinExist("Ahk2Exe ahk_class AutoHotkeyGUI")
                WinActivate
            else if FileExist(ROOT_DIR '\Compiler\Ahk2Exe.exe')
                Run '"' ROOT_DIR '\Compiler\Ahk2Exe.exe"'
            else
                Run Format('"{1}" /script "{2}\install-ahk2exe.ahk"', A_AhkPath, A_ScriptDir)
        case "Help":
            ShowHelpFile()
        case "Window":
            try {
                Run '"' A_MyDocuments '\AutoHotkey\WindowSpy.ahk"'
                return
            }
            static AHK_FILE_WINDOWSPY := 0xFF7A ; 65402
            static WM_COMMAND := 0x111 ; 273
            SendMessage WM_COMMAND, AHK_FILE_WINDOWSPY, 0, A_ScriptHwnd
            if WinWait("Window Spy ahk_class AutoHotkeyGUI",, 1)
                WinActivate
        case "Launch":
            LauncherConfigGui.Show()
        case "Editor":
            DefaultEditorGui.Show()
        }
    }
    
    ItemFocused(lv, item) {
        static WM_CHANGEUISTATE := 0x127 ; 295
        SendMessage WM_CHANGEUISTATE, 0x10001, 0, lv
    }
}

ShowHelpFile() {
    main := Map(), main.CaseSense := "off"
    other := Map(), other.CaseSense := "off"
    Loop Files ROOT_DIR "\*.chm", "FR" {
        SplitPath A_LoopFilePath,, &dir,, &name
        if SubStr(dir, -3) = '\v2' && (DllCall('GetFileAttributes', 'str', dir) & 0x400)
            continue ; Skip symbolic link
        dir := SubStr(dir, StrLen(ROOT_DIR) + 2)
        if dir ~= '^\d\.\d'
            dir := "v" dir
        if name = "AutoHotkey" {
            if dir = "" { ; Guess version
                dir := "Unknown version"
                Loop Files ROOT_DIR "\AutoHotkey*.exe" {
                    try {
                        info := GetExeInfo(A_LoopFilePath)
                        if (info.Description ~= '^AutoHotkey(?! Launcher)') {
                            dir := "v" info.Version
                            break
                        }
                    }
                }
            }
            main[A_LoopFilePath] := dir
        }
        else
            other[A_LoopFilePath] := name (dir != "" ? " (" dir ")" : "")
    }
    
    if main.Count = 1 && other.Count = 0 {
        for f in main { ; Don't bother showing online options in this case.
            Run f
            return
        }   
    }
    
    m := Menu()
    if main.Count {
        m.Add "Offline help", (*) => 0
        m.Disable "1&"
    }
    for f, t in main
        m.Add RegExReplace(t, 'v(?=\d)', "v&"), openIt.Bind(f)
    
    m.Add "Online help", (*) => 0
    m.Disable "Online help"
    prefix := main.Count ? "v" : "v&"
    m.Add prefix "1.1", (*) => Run("https://autohotkey.com/docs/")
    m.Add prefix "2.0", (*) => Run("https://lexikos.github.io/v2/docs/AutoHotkey.htm")
    
    if other.Count {
        m.Add "Other files", (*) => 0
        m.Disable "Other files"
    }
    for f, t in other
        m.Add t, openIt.Bind(f)
    
    m.Show
    openIt(f, *) => Run(f)
}

AutoHotkeyDashGui.Show()
