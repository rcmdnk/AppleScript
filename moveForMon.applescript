property DEF_ALL : false
property DEF_DEBUG_LEVEL : 0

on moveForMon(pars)
	-- set default variables
	set all to all of (pars & {all:DEF_ALL})
	set debug_level to debug_level of (pars & {debug_level:DEF_DEBUG_LEVEL})
	
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
	
	-- XRG
	set w_XRG to 1
	
	-- set monitoring tool's name
	-- GeekTool
	set s_gtCal to "gcalCal"
	set s_gtGcal to "gcalList"
	set s_gtTask to "gtasklist"
	set s_gtPs to "myps"
	
	-- x posiiotn for monitoring
	set ledge to -160
	set ledgeSFCoffset to 20
	
	-- y positions
	set y_sfcCEST to 30
	set y_sfcJST to y_sfcCEST + 100
	set y_gtCal to y_sfcJST + 105
	set y_gtGcal to y_gtCal + 115
	set y_gtTask to y_gtGcal + 175
	set y_gtPs to y_gtTask + 85
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
	set ws to load script file windowSizeScpt
	set getFrameScpt to scriptPath & "getFrame.scpt"
	set gf to load script file getFrameScpt
	
	-- main screen
	set vframes to gf's getAllVisibleFrames()
	-- dpoxY needs to be enough bigger than menubar's (~23) height
	set dPosX to 100
	set dPosY to 100
	set dWidth to |size|'s width of item 1 of (vframes's main_frames)
	set dHeight to |size|'s height of item 1 of (vframes's main_frames)
	
	-- try to get left screen
	set dPosX_L to dPosX
	set dPosY_L to dPosY
	if length of vframes's left_frames > 0 then
		set dPosX_L to (origin's x of item 1 of (vframes's left_frames)) + 100
		set dPosY_L to (origin's y of item 1 of (vframes's left_frames)) + 100
	end if
	
	-- try to get right screen
	set dPosX_R to dPosX + 1
	set dPosY_R to dPosY + 1
	if length of vframes's right_frames > 0 then
		set dPosX_R to (origin's x of item 1 of (vframes's right_frames)) + 100
		set dPosY_R to (origin's y of item 1 of (vframes's right_frames)) + 100
	end if
	
	-- move monitoring tools
	if length of vframes's left_frames > 0 then
		if debug_level > 0 then
			log "ledge to ledgeDual"
		end if
	else
		set ledge to dWidth + ledge
		if debug_level > 0 then
			log "ledge to ledgeSingle"
		end if
	end if
	
	tell application "System Events"
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
		
		---- GeekTool
		--try
		--	--set appName to "GeekTool"
		--	set appName to "GeekTool Helper" -- for GeekTool 3
		--	
		--	tell process appName
		--		set nW to number of windows
		--		--display dialog appName & " in process, nWindows=" & nW
		--		tell window w_gtCal
		--		end tell
		--		tell window w_gtGcal
		--			-- set size to {1000, 1000}
		--			set position to {ledge, y_gtGcal}
		--		end tell
		--		tell window w_gtTask
		--			-- set size to {1000, 1000}
		--			set position to {ledge, y_gtTask}
		--		end tell
		--		tell window w_gtPs
		--			-- set size to {1000, 1000}
		--			set position to {ledge, y_gtPs}
		--		end tell
		--	end tell
		--	--on error errMsg
		--	--	display dialog "ERROR: " & errMsg
		--end try
		
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
	
	-- GeekTool (should be outside of application "System Events", and use application "GeekTool Helper" ?)
	-- can't use position to geeklets
	tell application "GeekTool Helper" -- can not use appName (variable), which shows error at id?
		--geeklets
		repeat with g in geeklets
			tell g
				if name is s_gtCal then
					set x to ledge
					set y to y_gtCal
				else if name is s_gtGcal then
					set x to ledge
					set y to y_gtGcal
				else if name is s_gtTask then
					set x to ledge
					set y to y_gtTask
				else if name is s_gtPs then
					set x to ledge
					set y to y_gtPs
				end if
			end tell
		end repeat
	end tell
	
	-- Move/Resize other windows
	if all then
		-- get application name
		tell application "System Events"
			set appList to (get name of every application process whose visible is true)
		end tell
		
		-- repeat for all app
		repeat with appName in appList
			if appName is not in expApp then
				tell application "System Events"
					try
						tell process appName
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
									ws's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_L, monPosY:dPosY_L, xsize:0.7, ysize:0.7, moveForMon:false, debug_level:debug_level})
								else if appName is in halfSizeApp_R then
									if debug_level > 0 then
										log "half size right"
										if debug_level > 1 then
											display dialog "half size right"
										end if
									end if
									ws's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_R, monPosY:dPosY_R, xsize:0.7, ysize:0.7, moveForMon:false, debug_level:debug_level})
								else if appName is in noResizeApp_L then
									if debug_level > 0 then
										log "half size left"
										if debug_level > 1 then
											display dialog "half size left"
										end if
									end if
									ws's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_L, monPosY:dPosY_L, resize:0, moveForMon:false, debug_level:debug_level})
								else if appName is in noResizeApp_R then
									if debug_level > 0 then
										log "move right"
										if debug_level > 1 then
											display dialog "move right"
										end if
									end if
									ws's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_R, monPosY:dPosY_R, resize:0, moveForMon:false, debug_level:debug_level})
								else if appName is in app_L then
									if debug_level > 0 then
										log "move left full size"
										if debug_level > 1 then
											display dialog "move left full size"
										end if
									end if
									ws's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_L, monPosY:dPosY_L, moveForMon:false, debug_level:debug_level})
								else if appName is in app_R then
									if debug_level > 0 then
										log "move right full size"
										if debug_level > 1 then
											display dialog "move right full size"
										end if
									end if
									ws's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_R, monPosY:dPosY_R, moveForMon:false, debug_level:debug_level})
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
