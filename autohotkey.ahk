#c::Center() ;Windows + c
#1::Center(0.95) ;Windows + 1
#2::Center(0.85) ;Windows + 2
#3::Center(0.75) ;Windows + 3
#4::Center(0.65) ;Windows + 4
#5::Center(0.55) ;Windows + 4

SC29::$ ; map ½ to $

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