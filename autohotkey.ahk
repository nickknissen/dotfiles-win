#SingleInstance force

; Monitor for WM_DEVICECHANGE 
OnMessage(0x219, "MsgMonitor")

hWnd := GetAHKWin()

DEVICE_NOTIFY_WINDOW_HANDLE := 0x0 
DBT_DEVTYP_DEVICEINTERFACE  := 5
DEVICE_NOTIFY_ALL_INTERFACE_CLASSES := 0x00000004
DBT_DEVNODES_CHANGED       := 0x0007
DBT_DEVICEREMOVECOMPLETE   := 0x8004
DBT_DEVICEARRIVAL          := 0x8000
DBT_DEVTYP_DEVICEINTERFACE := 0x00000005

VarSetCapacity(DevHdr, 32, 0) ; Actual size is 29, but the function will fail with less than 32
NumPut(32, DevHdr, 0, "UInt") ; sizeof(_DEV_BROADCAST_DEVICEINTERFACE) (should be 29)
NumPut(DBT_DEVTYP_DEVICEINTERFACE, DevHdr, 4, "UInt") ; DBT_DEVTYP_DEVICEINTERFACE
Addr := &DevHdr
Flags := DEVICE_NOTIFY_WINDOW_HANDLE|DEVICE_NOTIFY_ALL_INTERFACE_CLASSES
Ret := DllCall("RegisterDeviceNotification", "UInt", hWnd, "UInt", Addr, "UInt", Flags)

MsgMonitor(wParam, lParam, msg, hwnd)
{
   	global DBT_DEVICEARRIVAL, DBT_DEVICEREMOVECOMPLETE, DBT_DEVTYP_DEVICEINTERFACE

	if (wParam == DBT_DEVICEREMOVECOMPLETE && GetHex(lParam) ==  0x7FE830) {
		;
	} else if (wParam == DBT_DEVICEARRIVAL && GetHex(lParam) ==  0x7FE830 && FileExist("C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe")) {
		if (A_ComputerName == "HOME") {
			Run "C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe" /1:SetActiveInput DP1
		} else {
			Run "C:\Program Files (x86)\Dell\Dell Display Manager\ddm.exe" /1:SetActiveInput DP2
		}
	}
}

GetHex(Num)
{
    Old := A_FormatInteger 
    SetFormat, IntegerFast, Hex
    Num += 0 
    Num .= ""
    SetFormat, IntegerFast, %Old%
    return Num
}

GetAHKWin()
{
    Gui +LastFound  
    hwnd := WinExist() 
    return hwnd
}

#c::Center() ;Windows + c
#1::Center(0.95) ;Windows + 1
#2::Center(0.85) ;Windows + 2
#3::Center(0.75) ;Windows + 3
#4::Center(0.65) ;Windows + 4
#5::Center(0.55) ;Windows + 4

SC29::$ ; map ½ to $

#IfWinActive ahk_exe gvim.exe
{
^+n::Send +{F1}n
}


Center(scaleRatio = 1)
{
	WinGet, mm, MinMax, A
	If (mm <> 1)
	{
		SysGet, monCount, MonitorCount
		WinGetPos, winX, winY, winW, winH, A
		
		;Use center of window as base for comparison.
		baseX := winx + winW / 2
		baseY := winy + winH / 2
		
		curMonNum := GetMonitorNumber(baseX, baseY, winX, winY, monCount)
		curMonWidth := GetMonitorWorkArea("width", curMonNum)
		curMonHeight := GetMonitorWorkArea("height", curMonNum)
		
		SysGet, curMon, Monitor, %curMonNum%

		If (scaleRatio < 1) {
			winW := curMonWidth * scaleRatio
			winH := curMonHeight * scaleRatio
		}
		
		newWinX := ((curMonWidth - winW) ) /2 + curMonLeft
		newWinY := ((curMonHeight - winH) ) /2 + curMonTop
		
		WinMove, A,, newWinX, newWinY, winW, winH
	}
	Return
}
	
GetMonitorNumber(baseX, baseY, winX, winY, monCount)
{
	i := 0
	monFound := 0

	Loop %monCount%
    {   
		i := i+1
		SysGet, tmpMon, Monitor, %i%
        if (baseX >= tmpMonLeft and baseX <= tmpMonRight and baseY >= tmpMonTop and baseY <= tmpMonBottom)
		{
            monFound := i
		}
    }
	;If we couldn't find a monitor through the assumed x/y, lets check by window x/y.
	If (monFound = 0)
	{
		{
			i := 0
			Loop %monCount%
			{   
				i := i+1
				SysGet, tmpMon, Monitor, %i%
				if (winX >= tmpMonLeft and winX <= tmpMonRight and winY >= tmpMonTop and winY <= tmpMonBottom)
				{
					monFound := i
				}
			}
		}
	}
	Return monFound
}

GetMonitorWorkArea(measurement, monToGet)
{
    SysGet, tmpMon, MonitorWorkArea, %monToGet%
	If (measurement = "width")
	{
		tmpMonWidth  := tmpMonRight - tmpMonLeft
		Return tmpMonWidth
	}
	Else If (measurement = "height")
	{
		tmpMonHeight := tmpMonBottom - tmpMonTop
		Return tmpMonHeight
	}
}