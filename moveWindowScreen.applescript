property DEF_DIRECTION : "LEFT"
property DEF_DEBUG_LEVEL : 0

on moveWindowScreen(pars)
	-- set default variables
	set direction to direction of (pars & {direction:DEF_DIRECTION})
	set debug_level to debug_level of (pars & {debug_level:DEF_DEBUG_LEVEL})
	
	-- Get application name and window number, if appName is "", if windowNumber is not set, set 1
	if appName is "" then
		tell application "System Events"
			set pList to name of every process whose frontmost is true
			set appName to item 1 of pList
		end tell
	end if
	if windowNumber is "" then
		set windowNumber to 1
	end if
	
	tell application "Finder"
		set scriptPath to (path to me)'s folder as text
	end tell
	
	-- debug mode
	if debug_level > 0 then
		log "debug mode = " & debug_level
		if debug_level > 1 then
			display dialog "debug mode = " & debug_level
		end if
	end if
	
	-- Get window position
	tell application "System Events"
		tell process appName
			try
				set topWindow to item windowNumber of (every window whose focused is true)
			on error
				set topWindow to window windowNumber
			end try
			set winPos to position of topWindow
			set winSize to size of topWindow
			set winPosX to item 1 of winPos
			set winPosY to item 2 of winPos
			set winSizeX to item 1 of winSize
			set winSizeY to item 2 of winSize
			set winPosRT to {winPosX + winSizeX, winPosY}
			set winPosLB to {winPosX, winPosY + winSizeY}
			set winPosRB to {winPosX + winSizeX, winPosY + winSizeY}
			if debug_level > 0 then
				log "winPos(" & winPosX & ", " & winPosY & ")"
				log "winSize(" & winSizeX & ", " & winSizeY & ")"
				if debug_level > 5 then
					display dialog "winPos(" & winPosX & ", " & winPosY & ")"
					display dialog "winSize(" & winSizeX & ", " & winSizeY & ")"
				end if
			end if
		end tell
	end tell
	
	-- Get screen (display) size
	set getFrameScpt to scriptPath & "getFrame.scpt"
	set vframes to gf's getAllVisibleFrames()
	set gf to load script file getFrameScpt
	if monPosX is not "" and monPosY is not "" then
		set svs to gf's getVisibleFrame(monPosX, monPosY)
	else
		set svs to gf's getVisibleFrame(item 1 of winPos, item 2 of winPos)
		if svs is 0 then
			set svs to gf's getVisibleFrame(item 1 of winPosRT, item 2 of winPosRT)
			if svn is 0 then
				set svs to gf's getVisibleFrame(item 1 of winPosLB, item 2 of winPosLB)
				if svs is 0 then
					set svs to gf's getVisibleFrame(item 1 of winPosRB, item 2 of winPosRB)
				end if
			end if
		end if
	end if
	
end moveWindowScreen

on run
	moveWindowScreen({})
end run
