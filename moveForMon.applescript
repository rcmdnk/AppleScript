on moveForMon(all)
	
	-- set monitoring tools' positions
	-- SimpleFloatingClock
	set w_sfcCEST to 1
	set w_sfcJST to 2
	-- GeekTool
	set w_gtCal to 2
	set w_gtGcal to 3
	set w_gtTask to 4
	set w_gtPs to 1
	-- XRG
	set w_XRG to 1
	
	-- x posiiotn for dual/single monitor mode
	set ledgeDual to -160
	set ledgeSingle to 1280
	set ledgeSFCoffset to 20
	
	-- y positions
	set y_sfcCEST to 30
	set y_sfcJST to y_sfcCEST + 100
	set y_gtCal to y_sfcJST + 105
	set y_gtGcal to y_gtCal + 105
	set y_gtTask to y_gtGcal + 170
	set y_gtPs to y_gtTask + 50
	set y_XRG to y_gtPs + 75
	
	-- app to be moved/resized when all = true
	-- L/R: left/right monitor if there are multi monitors
	set appL to {}
	set appR to {}
	set appLMax to {"Mail", "thunderbird", "thunderbird-bin", "firefox", "Google Chrome"}
	set appRMax to {"iTerm"}
	set appLHalf to {}
	set appRHalf to {"Finder", "AdobeReader"}
	
	-- check if there is monitor in the left of main monitor
	-- Sigle mode: Main monitor is Mac's monitor if there are no other monitors
	-- Dual mode: Main monitor is external monitor, on the right of Mac
	tell application "Finder"
		set displayBounds to bounds of window of desktop
		set dle to item 1 of displayBounds
	end tell
	
	-- move monitoring tools
	tell application "System Events"
		if dle < 0 then
			set ledge to ledgeDual
		else
			set ledge to ledgeSingle
		end if
		
		-- SimpleFloatingClock
		try
			set appName to "SimpleFloatingClock"
			tell process appName
				tell window w_sfcCEST
					set size to {1000, 1000}
					set position to {ledge + ledgeSFCoffset, y_sfcCEST}
				end tell
				tell window w_sfcJST
					set size to {1000, 1000}
					set position to {ledge + ledgeSFCoffset, y_sfcJST}
				end tell
			end tell
		end try
		
		-- GeekTool
		try
			set appName to "GeekTool"
			tell process appName
				tell window w_gtCal
					set size to {1000, 1000}
					set position to {ledge, y_gtCal}
				end tell
				tell window w_gtGcal
					set size to {1000, 1000}
					set position to {ledge, y_gtGcal}
				end tell
				tell window w_gtTask
					set size to {1000, 1000}
					set position to {ledge, y_gtTask}
				end tell
				tell window w_gtPs
					set size to {1000, 1000}
					set position to {ledge, y_gtPs}
				end tell
			end tell
		end try
		
		-- XRG
		try
			set appName to "XRG"
			tell process appName
				tell window w_XRG
					set size to {1000, 2000}
					set position to {ledge, y_XRG}
				end tell
			end tell
		end try
	end tell
	
	-- Move/Resize other windows
	tell application "Finder"
		set scriptPath to (path to me)'s folder as text
	end tell
	set windowSizeScpt to scriptPath & "windowSize.scpt"
	set windowSize to load script file windowSizeScpt
	if all then
		if dle < 0 then
			set lmon to {-1, 1}
			set rmon to {1, 1}
		else
			set lmon to {1, 1}
			set rmon to {1, 1}
		end if
		set appL to {}
		set appR to {}
		set appLMax to {"Mail", "thunderbird", "thunderbird-bin", "firefox", "Google Chrome"}
		set appRMax to {"iTerm"}
		set appLHalf to {}
		set appRHalf to {"Finder", "AdobeReader"}
		tell application "System Events"
			repeat with a in appR
				tell process appName
					set nW to number of windows
					repeat with i from 1 to nW
						log i
					end repeat
				end tell
			end repeat
		end tell
		
	end if
end moveForMon

on run
	moveForMon(false)
end run

