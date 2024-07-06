;|2.7|2024.06.21|1628
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=86090&sid=d0fadba6e7002b0a78851d8deecc0e79
#NoEnv
Windy_CurWin_id := A_Args[1]
FileExtensions := ["txt", "ahk", "docx", "xlsx", "pptx"]
CreateMenu("MyMenu", "MyMenuFunc", FileExtensions)
;return

;#If WinActive("ahk_class CabinetWClass") OR WinActive("ahk_class Progman") OR WinActive("ahk_class WorkerW")
;^n::
   hwnd := Windy_CurWin_id
   Menu, MyMenu, Show
return
;#If

CreateMenu(MenuName, FunctionName, Extensions) {
   RegRead, Item, HKEY_CLASSES_ROOT\Folder\ShellNew, ItemName
;msgbox %  Item
   if !Item
		RegRead, Item, HKEY_CLASSES_ROOT\Folder
	else
	{
		Array := StrSplit(Item, ",")
		tmp_val := trim(Array[1],"@")
		Item := TranslateMUI(ExpandEnvVars(tmp_val), abs(Array[2]))
	}

   RegRead, IconInfo, HKEY_CLASSES_ROOT\Folder\DefaultIcon
   if RegExMatch(IconInfo, "O)(.*),(\d+)", Match) {
      IconFile := StrReplace(Match[1], "%SystemRoot%", A_WinDir)
      IconNo := Match[2] + 1
   } else
      throw Exception("Unable to extract folder icon information.", -1, IconInfo)
	 Item := InStr(Item, "新建") ? Item : "新建 &" Item
   Menu, %MenuName%, Add, %Item%, %FunctionName%
   Menu, %MenuName%, Icon, %Item%, %IconFile%, %IconNo%
   Menu, %MenuName%, Add
   
   for Each, Extension in Extensions {
      RegRead, Key, HKEY_CLASSES_ROOT\.%Extension%
      if !Key
         throw Exception("Invalid extension.", -1, Extension)
      RegRead, Item, HKEY_CLASSES_ROOT\.%Extension%\ShellNew, ItemName
      if !Item
				RegRead, Item, HKEY_CLASSES_ROOT\%Key%
			else
			{
				Array := StrSplit(Item, ",")
				tmp_val := trim(Array[1],"@")
				Item := TranslateMUI(ExpandEnvVars(tmp_val), abs(Array[2]))
	}
;msgbox % Key "|" Item
      RegRead, OpenCommand, HKEY_CLASSES_ROOT\%Key%\shell\Open\command
      if (Instr(OpenCommand, """") = 1)
         if RegExMatch(OpenCommand, "O)""(.*?)"".*", Match)
            IconFile := Match[1]
         else
            throw Exception("Unable to extract executable from open command line.", -1, Extension)
      else
         if RegExMatch(OpenCommand, "O)(.*?) .*", Match)
            IconFile := StrReplace(Match[1], "%SystemRoot%", A_WinDir)
         else
            throw Exception("Unable to extract executable from open command line.", -1, Extension)
      Item := InStr(Item, "Microsoft") ? SubStr(Item, 1, 10) "&" SubStr(Item, 11) : "&" Item
;msgbox % Item
			if InStr(Item, "新建")
			{
      Menu, %MenuName%, Add, %Item%, %FunctionName%
      Menu, %MenuName%, Icon, %Item%, %IconFile%
			}
			else
			{
      Menu, %MenuName%, Add, 新建 %Item%, %FunctionName%
      Menu, %MenuName%, Icon, 新建 %Item%, %IconFile%
			}
   }
}

MyMenuFunc(ItemName, ItemPos, MenuName) {
   global FileExtensions, hwnd
   Name := StrReplace(ItemName, "&") (ItemPos > 2 ? "." FileExtensions[ItemPos - 2] : "")
   DestinationFolder := GetWindowPath(hwnd)
   TemplateName := ItemPos > 2 ? GetTemplateName(Name) : ""
   FileAttributes := ItemPos = 1 ? 0x10 : 0x20  ; FILE_ATTRIBUTE_DIRECTORY = 0x10, FILE_ATTRIBUTE_ARCHIVE = 0x20
   if (NewItemPath := New.Item(Name, DestinationFolder, TemplateName, FileAttributes)) {
      Sleep, 100
      SelectItem(hwnd, NewItemPath, 3|4|8)
   } else
      MsgBox, 0x10, , Unable to create "%Name%" in the active window.
}

; Gets the path of an Explorer window or the desktop given a window handle.

GetWindowPath(hwnd) {
   WinGetClass, WinClass, ahk_id %hwnd%
   if (WinClass = "CabinetWClass") {
      for Window in ComObjCreate("Shell.Application").Windows
         if (Window.hwnd = hwnd)
            return Window.Document.Folder.Self.Path
   } else if (WinClass = "Progman" || WinClass = "WorkerW") {
      return A_Desktop
   } else
      throw Exception("Window must be an Explorer window or the desktop.", -1)
}

; Gets the path of the template, if any, associated with a filename or path.

GetTemplateName(FilenameOrPath) {
   SplitPath, FilenameOrPath, , , Extension
   Loop, Files, % A_AppData "\Microsoft\Windows\Templates\*." Extension
      return A_LoopFilePath
   Loop, Files, % A_AppDataCommon "\Microsoft\Windows\Templates\*." Extension
      return A_LoopFilePath
   Loop, Files, % A_WinDir "\shellnew\*." Extension
      return A_LoopFilePath
   RegRead, Key, HKEY_CLASSES_ROOT\.%Extension%
   RegRead, FileName, HKEY_CLASSES_ROOT\.%Extension%\%Key%\ShellNew, FileName
   return FileName
}

; Selects a file in an Explorer window or on the desktop given the specified name or path.
; References: https://docs.microsoft.com/en-us/windows/win32/shell/folderitem
;             https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview-selectitem

SelectItem(hwnd, NameOrPath, Flags) {
   WinGetClass, WinClass, ahk_id %hwnd%
   if (WinClass = "CabinetWClass") {
      for Win in ComObjCreate("Shell.Application").Windows {
         if (Win.hwnd = hwnd) {
            Window := Win
            break
         }
      }
   } else if (WinClass = "Progman" || WinClass = "WorkerW") {
      VarSetCapacity(hwnd, 4, 0)
      ShellWindows := ComObjCreate("Shell.Application").Windows
      Window := ShellWindows.FindWindowSW(0, "", 0x8, ComObject(0x4003, &hwnd), 0x1)
   } else
      throw Exception("Window must be an Explorer window or the desktop.", -1)
   for Item in Window.Document.Folder.Items
      if InStr(Item.Path, NameOrPath)
         return Window.Document.SelectItem(Item, Flags)
}
; ===============================================================================================================================
; NewItem(Name, DestinationFolder := "", TemplateName := "", FileAttributes := 0x20, OperationFlags := 0x0440)
; Function:       Creates a new item (file or folder) in the specified destination folder.
; Parameters:     - Name - String containing the name of the file or folder to be created, including the extension (if any).
;                 - DestinationFolder (Optional) - String containing the absolute path of the destrination folder. If blank or
;                   omitted, it defaults to A_WorkingDir. If the folder doesn't exist, an exception is thrown.
;                 - TemplateName (Optional) - String containing the name or path of a pre-existing template file. If only a name
;                   is specified, the function will look for the file in the following folders (in order of precedence):
;                      - A_AppData "\Microsoft\Windows\Templates"
;                      - A_AppDataCommon "\Microsoft\Windows\Templates"
;                      - A_WinDir "\shellnew"
;                   If blank, omitted, or non-existent, no template will be used.
;                 - FileAttributes (Optional) - A bitwise value that specifies the file system attributes for the file or folder.
;                   If omitted, a regular file will be created, i.e. a file with the FILE_ATTRIBUTE_ARCHIVE (0x20) attribute.
;                   When creating a folder, use 0x10 (FILE_ATTRIBUTE_DIRECTORY) instead. See [REF1] for more information.
;                 - OperationFlags (Optional) - Flags that controls the file operation. If omitted, it defaults to
;                   FOF_ALLOWUNDO (0x0040) | FOF_NOERRORUI (0x0400). See [REF2] for more information.
; Return values:  If the operation is successful, the function returns a string containing the path of the file that was created.
;                 The name of the new file may be different than the specified name depending on whether an item by the same name
;                 already exists. Otherwise, the function returns a blank, e.g. if the user doesn't have sufficient priviledges to
;                 create the item in the destination folder.
; Global vars:    None
; Dependencies:   New class (included)
; Requirements:   Windows Vista+ and AHK v1.0.47+
; Tested with:    AHK 1.1.33.02 (A32/U32/U64)
; Tested on:      Win 10 Pro (Build 18362)
; Written by:     iPhilip
; Forum link:     https://www.autohotkey.com/boards/viewtopic.php?f=6&t=86090
; References:     1. https://docs.microsoft.com/en-us/windows/win32/fileio/file-attribute-constants
;                 2. https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifileoperation-setoperationflags
;                 3. https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifileoperation-newitem
;                 4. https://docs.microsoft.com/en-us/windows/win32/api/shobjidl_core/nf-shobjidl_core-ifileoperation-performoperations
; ===============================================================================================================================

NewItem(Name, DestinationFolder := "", TemplateName := "", FileAttributes := 0x20, OperationFlags := 0x0440) {
   return New.Item(Name, DestinationFolder, TemplateName, FileAttributes, OperationFlags)
}

class New
{
   Item(Name, DestinationFolder := "", TemplateName := "", FileAttributes := 0x20, OperationFlags := 0x0440) {
      static pIID_IShellItem := New.IIDFromString("{43826d1e-e718-42ee-bc55-a1e261c37bfe}")  ; ShObjIdl_core.h
      static CLSID_FileOperation := "{3ad05575-8857-4850-9277-11b85bdb8e09}"  ; ShObjIdl_core.h
      static IID_IFileOperation := "{947aab5f-0a5c-4c13-b4d6-4bf7836fc9f8}"  ; ShObjIdl_core.h
      static pIFileOperationProgressSink := New.CreateIFileOperationProgressSink()
      
      New.Name := "", pIShellItem := 0, DestinationFolderPath := DestinationFolder ? DestinationFolder : A_WorkingDir
      if DllCall("Shell32\SHCreateItemFromParsingName", "WStr", DestinationFolderPath, "Ptr", 0, "Ptr", pIID_IShellItem, "Ptr*", pIShellItem, "UInt")
         throw Exception("Destination folder does not exist.", -1, DestinationFolderPath)
      
      pIFileOperation   := ComObjCreate(CLSID_FileOperation, IID_IFileOperation)
      VTable            := NumGet(pIFileOperation + 0, "Ptr")
      SetOperationFlags := NumGet(VTable +  5 * A_PtrSize, "Ptr")  ; IFileOperation::SetOperationFlags
      NewItem           := NumGet(VTable + 20 * A_PtrSize, "Ptr")  ; IFileOperation::NewItem
      PerformOperations := NumGet(VTable + 21 * A_PtrSize, "Ptr")  ; IFileOperation::PerformOperations
      
      DllCall(SetOperationFlags, "Ptr",  pIFileOperation, "UInt", OperationFlags, "UInt")
      DllCall(NewItem, "Ptr", pIFileOperation, "Ptr", pIShellItem, "UInt", FileAttributes, "WStr", Name, "WStr", TemplateName, "Ptr", pIFileOperationProgressSink, "UInt")
      DllCall(PerformOperations, "Ptr",  pIFileOperation, "UInt")
      
      ObjRelease(pIShellItem)
      ObjRelease(pIFileOperation)
      
      return New.Name ? DestinationFolderPath "\" New.Name : ""
   }
   
   ; Helper methods
   
   IIDFromString(String) {
      static IID
      VarSetCapacity(IID, 16)
      DllCall("Ole32\IIDFromString", "WStr", String, "Ptr", &IID, "UInt")
      return &IID
   }
   
   CreateIFileOperationProgressSink() {
      static IFileOperationProgressSink
      VarSetCapacity(IFileOperationProgressSink, 20 * A_PtrSize)
      NumPut(&IFileOperationProgressSink + A_PtrSize, IFileOperationProgressSink, "Ptr")
      Loop, Parse, % "3111246575735483111"
         NumPut(RegisterCallback(New.IFileOperationProgressMonitor, "Fast", A_LoopField, A_Index), IFileOperationProgressSink, A_Index * A_PtrSize, "Ptr")
      return &IFileOperationProgressSink
   }
   
   IFileOperationProgressMonitor(params*) {
      if (A_EventInfo = 15)  ; IFileOperationProgressSink::PostNewItem
         if !NumGet(params + 5 * A_PtrSize, "UInt")  ; hrNew
            New.Name := StrGet(NumGet(params + 2 * A_PtrSize, "Ptr"), "UTF-16")  ; pszNewName
   }
}

TranslateMUI(resDll, resID)
{
	VarSetCapacity(buf, 256)
	hDll := DllCall("LoadLibrary", "str", resDll, "Ptr")
	Result := DllCall("LoadString", "uint", hDll, "uint", resID, "uint", &buf, "int", 128)
	VarSetCapacity(buf, -1)
	Return buf
}

ExpandEnvVars(ppath)
{
	VarSetCapacity(dest, 2000)
	DllCall("ExpandEnvironmentStrings", "str", ppath, "str", dest, "int", 1999, "Cdecl int")
	Return dest
}