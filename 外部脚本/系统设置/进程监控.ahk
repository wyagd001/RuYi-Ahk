;|2.8|2024.09.12|1674
Gui, New, +hwndhGui
Gui, Add, ListView, w900 h600, Event|PID|Name|Time|Command Line
for k, v in ["70", "50", "100", "60"]
   LV_ModifyCol(k, v)
Gui, Show

WMI := ComObjGet("winmgmts:")
ComObjConnect(createSink := ComObjCreate("WbemScripting.SWbemSink"), new EventSink("Created", hGui))
ComObjConnect(deleteSink := ComObjCreate("WbemScripting.SWbemSink"), new EventSink("Terminated", hGui))

Command := "Within 1 Where TargetInstance ISA 'Win32_Process'"
WMI.ExecNotificationQueryAsync(createSink, "select * from __InstanceCreationEvent " . Command)
WMI.ExecNotificationQueryAsync(deleteSink, "select * from __InstanceDeletionEvent " . Command)
Return

GuiClose() {
   ExitApp
}

class EventSink
{
   __New(eventType, hwnd) {
      this.event := eventType
      this.hwnd := hwnd
   }
   
   OnObjectReady(obj) {
      Process := obj.TargetInstance
      Gui, % this.hwnd . ": Default"
      time := this.event = "Created" ? RegExReplace(Process.CreationDate, "\..*") : A_Now
      FormatTime, formatted, time, HH:mm:ss
      LV_Insert(1,, this.event, Process.ProcessID, Process.Name, formatted, Process.CommandLine)
   }
}
; Process.ExecutablePath
; CreationDate  20160119174253.151951+480
