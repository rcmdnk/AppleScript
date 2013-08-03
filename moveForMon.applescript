property DEF_ALL : true
property DEF_DEBUG_LEVEL : 1

on moveForMon(pars)
	
	set {all, debug_level} to {DEF_ALL, DEF_DEBUG_LEVEL}
	try
		set all to all of pars
	end try
	try
		set debug_level to debug_level of pars
	end try
	
	-- debug mode
	if debug_level > 0 then
		log "debug mode = " & debug_level
		if debug_level > 1 then
			display dialog "debug mode = " & debug_level
		end if
	end if
	
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
	set y_gtGcal to y_gtCal + 115
	set y_gtTask to y_gtGcal + 170
	set y_gtPs to y_gtTask + 80
	set y_XRG to y_gtPs + 75
	
	-- app to be excepted
	set expApp to {"XRG"}
	
	-- app to be half size, in left monitor (0.7 times full)
	set halfSizeApp_L to {}
	
	-- app to be half size, in right monitor (0.7 times full)
	set halfSizeApp_R to {"AdobeReader"}
	
	-- app only to be moved, in left monitor
	set noResizeApp_L to {}
	
	-- app only to be moved, in right monitor
	set noResizeApp_R to {"Finder", "Skype", "Microsoft Word", "Microsoft Excel", "Microsoft PowerPoint"}
	
	-- app to be moved left
	set app_L to {"firefox", "Evernote", "thunderbird", "thunderbird-bin", "Mail"}
	
	-- app to be moved right
	set app_R to {"iTerm"}
	
	-- get screen size
	tell application "Finder"
		set scriptPath to (path to me)'s folder as text
	end tell
	set windowSizeScpt to scriptPath & "windowSize.scpt"
	set windowSize to load script file windowSizeScpt
	
	-- main screen
	set svs to windowSize's getVisibleFrame(1, 1) --+1 is used to avoid edge, especially needed for y position
	set dPosX to (item 1 of svs) + 1
	set dPosY to (item 2 of svs) + 1
	set dWidth to item 3 of svs
	set dHeight to item 4 of svs
	
	-- try to get left screen
	set dPosX_L to dPosX + 1
	set dPosY_L to dPosY + 1
	try
		set svsL to windowSize's getVisibleFrame(-1, 1)
		set dPosX_L to (item 1 of svsL) + 1
		set dPosY_L to (item 2 of svsL) + 1
	end try
	
	-- try to get right screen
	set dPosX_R to dPosX + 1
	set dPosY_R to dPosY + 1
	try
		set svsR to windowSize's getVisibleFrame(dPosX + dWidth + 1, 1)
		set dPosX_R to (item 1 of svsR) + 1
		set dPosY_R to (item 2 of svsR) + 1
	end try
	
	-- move monitoring tools
	if dPosX_L < 0 then
		set ledge to ledgeDual
		if debug_level > 0 then
			log "ledge to ledgeDual"
		end if
	else
		set ledge to ledgeSingle
		if debug_level > 0 then
			log "ledge to ledgeSingle"
		end if
	end if
	
	tell application "System Events"
		-- SimpleFloatingClock
		try
			set appName to "SimpleFloatingClock"
			tell «class prcs» appName
				tell window w_sfcCEST
					set size to {1000, 1000}
					set «class posn» to {ledge + ledgeSFCoffset, y_sfcCEST}
				end tell
				tell window w_sfcJST
					set size to {1000, 1000}
					set «class posn» to {ledge + ledgeSFCoffset, y_sfcJST}
				end tell
			end tell
		end try
		
		-- GeekTool
		try
			--set appName to "GeekTool"
			set appName to "GeekTool Helper" -- for GeekTool 3
			
			tell «class prcs» appName
				set nW to number of windows
				--display dialog appName & " in process, nWindows=" & nW
				tell window w_gtCal
					-- set size to {1000, 1000}
					set «class posn» to {ledge, y_gtCal}
				end tell
				tell window w_gtGcal
					-- set size to {1000, 1000}
					set «class posn» to {ledge, y_gtGcal}
				end tell
				tell window w_gtTask
					-- set size to {1000, 1000}
					set «class posn» to {ledge, y_gtTask}
				end tell
				tell window w_gtPs
					-- set size to {1000, 1000}
					set «class posn» to {ledge, y_gtPs}
				end tell
			end tell
			--on error errMsg
			--	display dialog "ERROR: " & errMsg
		end try
		
		-- XRG
		try
			set appName to "XRG"
			tell «class prcs» appName
				tell window w_XRG
					set size to {1000, 2000}
					set «class posn» to {ledge, y_XRG}
				end tell
			end tell
		end try
	end tell
	
	-- Move/Resize other windows
	if all then
		-- get application name
		tell application "System Events"
			set appList to (get name of every «class pcap» whose visible is true)
		end tell
		
		-- repeat for all app
		repeat with appName in appList
			if appName is not in expApp then
				tell application "System Events"
					try
						tell «class prcs» appName
							set nW to number of windows
							repeat with i from 1 to nW
								if debug_level > 0 then
									log appName & " " & i
									if debug_level > 1 then
										display dialog appName & " " & i
									end if
								end if
								if appName is in halfSizeApp_L then
									if debug_level > 0 then
										log "half size left"
										if debug_level > 1 then
											display dialog "half size left"
										end if
									end if
									windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_L, monPosY:dPosY_L, xsize:0.7, ysize:0.7, moveForMon:false, debug_level:debug_level})
								else if appName is in halfSizeApp_R then
									if debug_level > 0 then
										log "half size right"
										if debug_level > 1 then
											display dialog "half size right"
										end if
									end if
									windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_R, monPosY:dPosY_R, xsize:0.7, ysize:0.7, moveForMon:false, debug_level:debug_level})
								else if appName is in noResizeApp_L then
									if debug_level > 0 then
										log "half size left"
										if debug_level > 1 then
											display dialog "half size left"
										end if
									end if
									windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_L, monPosY:dPosY_L, resize:0, moveForMon:false, debug_level:debug_level})
								else if appName is in noResizeApp_R then
									if debug_level > 0 then
										log "move right"
										if debug_level > 1 then
											display dialog "move right"
										end if
									end if
									windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_R, monPosY:dPosY_R, resize:0, moveForMon:false, debug_level:debug_level})
								else if appName is in app_L then
									if debug_level > 0 then
										log "move left full size"
										if debug_level > 1 then
											display dialog "move left full size"
										end if
									end if
									windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_L, monPosY:dPosY_L, moveForMon:false, debug_level:debug_level})
								else if appName is in app_R then
									if debug_level > 0 then
										log "move right full size"
										if debug_level > 1 then
											display dialog "move right full size"
										end if
									end if
									windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_R, monPosY:dPosY_R, moveForMon:false, debug_level:debug_level})
								end if
							end repeat
						end tell
					end try
				end tell
			end if
		end repeat
	end if
end moveForMon

on run
	moveForMon({})
end run
