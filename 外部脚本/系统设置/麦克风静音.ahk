;|2.6|2024.03.26|1570
; 来源网址: https://www.autohotkey.com/boards/viewtopic.php?style=19&t=106835
;#include VA.ahk

;names := ""
;for index, name in VAx_GetDeviceNames()
;    names .= index ": " name "`n"
;MsgBox % names

Loop
{
	mic_state := VA_GetMasterMute("capture:" A_Index)
	;msgbox % mic_state
	if(mic_state = "")
		break
	VA_SetMasterMute(!mic_state, "capture:" A_Index)
	if(!mic_state = 0)
		action := "Unmuted"
	else
		action := "Muted"
	device := VA_GetDevice("capture:" A_Index)
	deviceName := VA_GetDeviceName(device)
	msg := msg A_Index ". " action " : " deviceName "`n"
	ObjRelease(Device)
}
MsgBox % msg

VAx_GetDeviceNames()
{
    static CLSID_MMDeviceEnumerator := "{BCDE0395-E52F-467C-8E3D-C4579291692E}"
        , IID_IMMDeviceEnumerator := "{A95664D2-9614-4F35-A746-DE8DB63617E6}"
    if !(deviceEnumerator := ComObjCreate(CLSID_MMDeviceEnumerator, IID_IMMDeviceEnumerator))
        throw Exception("Failed to create MMDeviceEnumerator")
    static DEVICE_STATE_ACTIVE := 1, DEVICE_STATE_UNPLUGGED := 8, eAll := 2
    if VA_IMMDeviceEnumerator_EnumAudioEndpoints(deviceEnumerator, eAll
        , DEVICE_STATE_ACTIVE | DEVICE_STATE_UNPLUGGED, devices) = 0 {
        VA_IMMDeviceCollection_GetCount(devices, count)
        names := []
        Loop % count
            if VA_IMMDeviceCollection_Item(devices, A_Index-1, device) = 0 {
                names[A_Index] := VA_GetDeviceName(device)
                ObjRelease(device)
            }
        ObjRelease(devices)
    }
    ObjRelease(deviceEnumerator)
    return names
}