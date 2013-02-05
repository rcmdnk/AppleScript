on moveForMon()
	
	set w_sfcCEST to 1
	set w_sfcJST to 2
	set w_gtCal to 2
	set w_gtGcal to 3
	set w_gtTask to 4
	set w_gtPs to 1
	set w_XRG to 1
	
	set ledgeDual to -160
	set ledgeSingle to 1280
	set ledgeSFCoffset to 20
	
	set y_sfcCEST to 30
	set y_sfcJST to y_sfcCEST + 100
	set y_gtCal to y_sfcJST + 105
	set y_gtGcal to y_gtCal + 105
	set y_gtTask to y_gtGcal + 170
	set y_gtPs to y_gtTask + 50
	set y_XRG to y_gtPs + 75
	
	tell application "Finder"
		set displayBounds to bounds of window of desktop
		set dle to item 1 of displayBounds
	end tell
	
	tell application "System Events"
		if dle < 0 then
			set ledge to ledgeDual
		else
			set ledge to ledgeSingle
		end if
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
		
		set appName to "XRG"
		tell process appName
			tell window w_XRG
				set size to {1000, 2000}
				set position to {ledge, y_XRG}
			end tell
		end tell
	end tell
end moveForMon

moveForMon()
