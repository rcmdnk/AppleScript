property DEF_XSIZE : 1
property DEF_YSIZE : 1
property DEF_XPOS : 0
property DEF_YPOS : 0

property DEF_LEFT_MARGIN : 10
property DEF_RIGHT_MARGIN : 10
property DEF_TOP_MARGIN : 10
property DEF_BOTTOM_MARGIN : 10

property DEF_APPNAME : ""
property DEF_WINDOWNUMBER : ""
property DEF_MONPOSX : ""
property DEF_MONPOSY : ""
property DEF_RESIZE : 1
property DEF_DIRECTION : ""

property DEF_MOVEFORMON_FLAG : true
property DEF_DEBUG_LEVEL : 0

property GEEKTOOL_WINDOW : 1
property GEEKTOOL_MARGIN : 10

-- Window size main function
on windowSize(pars)
	-- Set Parameters
	set xsize to xsize of (pars & {xsize:DEF_XSIZE})
	set ysize to ysize of (pars & {ysize:DEF_YSIZE})
	set xpos to xpos of (pars & {xpos:DEF_XPOS})
	set ypos to ypos of (pars & {ypos:DEF_YPOS})
	set leftmargin to leftmargin of (pars & {leftmargin:DEF_LEFT_MARGIN})
	set rightmargin to rightmargin of (pars & {rightmargin:DEF_RIGHT_MARGIN})
	set topmargin to topmargin of (pars & {topmargin:DEF_TOP_MARGIN})
	set bottommargin to bottommargin of (pars & {bottommargin:DEF_BOTTOM_MARGIN})
	set appName to appName of (pars & {appName:DEF_APPNAME})
	set windowNumber to windowNumber of (pars & {windowNumber:DEF_WINDOWNUMBER})
	set monPosX to monPosX of (pars & {monPosX:DEF_MONPOSX})
	set monPosY to monPosY of (pars & {monPosY:DEF_MONPOSY})
	set resize to resize of (pars & {resize:DEF_RESIZE})
	set direction to direction of (pars & {direction:DEF_DIRECTION})
	set moveformon_flag to moveformon_flag of (pars & {moveformon_flag:DEF_MOVEFORMON_FLAG})
	set debug_level to debug_level of (pars & {debug_level:DEF_DEBUG_LEVEL})
	
	-- Debug mode
	if debug_level > 0 then
		log "debug mode = " & debug_level
		if debug_level > 1 then
			display dialog "debug mode = " & debug_level
		end if
	end if
	
	-- Get application name and window number, if appName is "", if windowNumber is not set, set 1
	if appName is "" then
		tell application "System Events"
			set pList to name of every process whose frontmost is true
			set appName to item 1 of pList
		end tell
	end if
	if windowNumber is "" then
		if appName is "Google Chrome" then
			set windowNumber to 2
			set wnList to {2, 1}
		else
			set windowNumber to 1
			set wnList to {1}
		end if
	else
		set wnList to {windowNumber}
	end if
	
	if debug_level > 0 then
		log "windowSize(" & xsize & ", " & ysize & ", " & xpos & ", " & ypos & ", " & leftmargin & ", " & rightmargin & ", " & topmargin & ", " & bottommargin & ", " & appName & ", " & windowNumber & ", " & monPosX & ", " & monPosY & "," & resize & "," & moveformon_flag & "," & debug_level & ")"
		if debug_level > 5 then
			display dialog "windowSize(" & xsize & ", " & ysize & ", " & xpos & ", " & ypos & ", " & leftmargin & ", " & rightmargin & ", " & topmargin & ", " & bottommargin & ", " & appName & ", " & windowNumber & ", " & monPosX & ", " & monPosY & "," & resize & "," & moveformon_flag & "," & debug_level & ")"
		end if
	end if
	
	set scriptPath to ((path to me as text) & "::")
	
	-- First, move monitor
	if moveformon_flag then
		set moveForMonScpt to scriptPath & "moveForMon.scpt"
		set moveformon to load script file moveForMonScpt
		moveformon's moveformon({all:false})
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
	set gf to load script file getFrameScpt
	set vframes to gf's getAllVisibleFrames()
	set getCurrentFrameScpt to scriptPath & "getCurrentFrame.scpt"
	set gcf to load script file getCurrentFrameScpt
	
	if monPosX is not "" and monPosY is not "" then
		set cf to gcf's getCurrentFrame(monPosX, monPosY, vframes)
	else
		set cf to gcf's getCurrentFrame(item 1 of winPos, item 2 of winPos, vframes)
		if cf is 0 then
			set cf to gcf's getCurrentFrame(item 1 of winPosRT, item 2 of winPosRT, vframes)
			if cf is 0 then
				set cf to gcf's getCurrentFrame(item 1 of winPosLB, item 2 of winPosLB, vframes)
				if cf is 0 then
					set cf to gcf's getCurrentFrame(item 1 of winPosRB, item 2 of winPosRB, vframes)
				end if
			end if
		end if
	end if
	if debug_level > 0 then
		log "current frame"
		log cf
		if debug_level > 5 then
			display dialog "current frame"
			display dialog cf
		end if
	end if
	
	set recordlib to scriptPath & "recordlib.scpt"
	set rb to load script file recordlib
	
	set frames to rb's getKeyValue(vframes, item 1 of cf)
	set frame to item (item 2 of cf) of frames
	
	-- Move screen
	if direction is not "" then
		set fname to item 1 of cf
		set nout to item 2 of cf
		set nleft to length of rb's getKeyValue(vframes, "left_frames")
		set nright to length of rb's getKeyValue(vframes, "right_frames")
		set ntop to length of rb's getKeyValue(vframes, "top_frames")
		set nbottom to length of rb's getKeyValue(vframes, "bottom_frames")
		if direction is "LEFT" then
			if fname is "main_frames" then
				if nleft > 0 then
					set frame to item 1 of rb's getKeyValue(vframes, "left_frames")
				end if
			else if fname is "left_frames" then
				if nleft > nout then
					set frame to item (nout + 1) of rb's getKeyValue(vframes, "left_frames")
				end if
			else if fname is "right_frames" then
				if nout is 1 then
					set frame to item 1 of rb's getKeyValue(vframes, "main_frames")
				else
					set frame to item (nout - 1) of rb's getKeyValue(vframes, "right_frames")
				end if
			end if
		else if direction is "RIGHT" then
			if fname is "main_frames" then
				if nright > 0 then
					set frame to item 1 of rb's getKeyValue(vframes, "right_frames")
				end if
			else if fname is "right_frames" then
				if nright > nout then
					set frame to item (nout + 1) of rb's getKeyValue(vframes, "right_frames")
				end if
			else if fname is "left_frames" then
				if nout is 1 then
					set frame to item 1 of rb's getKeyValue(vframes, "main_frames")
				else
					set frame to item (nout - 1) of rb's getKeyValue(vframes, "left_frames")
				end if
			end if
		else if direction is "UP" then
			if fname is "main_frames" then
				if ntop > 0 then
					set frame to item 1 of rb's getKeyValue(vframes, "top_frames")
				end if
			else if fname is "top_frames" then
				if ntop > nout then
					set frame to item (nout + 1) of rb's getKeyValue(vframes, "top_frames")
				end if
			else if fname is "bottom_frames" then
				if nout is 1 then
					set frame to item 1 of rb's getKeyValue(vframes, "main_frames")
				else
					set frame to item (nout - 1) of rb's getKeyValue(vframes, "bottom_frames")
				end if
			end if
		else if direction is "DOWN" then
			if fname is "main_frames" then
				if nbottom > 0 then
					set frame to item 1 of rb's getKeyValue(vframes, "bottom_frames")
				end if
			else if fname is "bottom_frames" then
				if nbottom > nout then
					set frame to item (nout + 1) of rb's getKeyValue(vframes, "bottom_frames")
				end if
			else if fname is "top_frames" then
				if nout is 1 then
					set frame to item 1 of rb's getKeyValue(vframes, "main_frames")
				else
					set frame to item (nout - 1) of rb's getKeyValue(vframes, "top_frames")
				end if
			end if
		end if
	end if
	set dPosX to gf's getFrameOriginX(frame)
	set dPosY to gf's getFrameOriginY(frame)
	set dWidth to gf's getFrameWidth(frame)
	set dHeight to gf's getFrameHeight(frame)
	if debug_level > 0 then
		log "svs(" & dPosX & ", " & dPosY & ", " & dWidth & ", " & dHeight & ")"
		if debug_level > 5 then
			display dialog "svs(" & dPosX & ", " & dPosY & ", " & dWidth & ", " & dHeight & ")"
		end if
	end if
	
	-- Get GeekTool's position
	tell application "System Events"
		try
			tell process "GeekTool Helper"
				set topWindow to window GEEKTOOL_WINDOW
				set gtPos to position of topWindow
			end tell
			set gtflag to 1
		on error
			set gtflag to 0
		end try
	end tell
	
	-- Check if the window and GeekTool are in same screen
	if gtflag is 1 then
		set gtsvs to gf's getVisibleFrame(item 1 of gtPos, item 2 of gtPos)
		set gtdPosX to gf's getFrameOriginX(gtsvs)
		set gtdPosY to gf's getFrameOriginY(gtsvs)
		if dPosX is gtdPosX and dPosY is gtdPosY then
			try
				set gtSize to size of topWindow
				set geekToolWidth to item 1 of gtSize
				set geekToolWidth to geekToolWidth + GEEKTOOL_MARGIN -- additional margin
			on error
				set geekToolWidth to 0
			end try
		else
			set geekToolWidth to 0
		end if
	end if
	--if item 1 of winPos < 0 then
	--	set geekToolWidth to 160
	--	set geekToolWidth to geekToolWidth + GEEKTOOL_MARGIN -- additional margin
	--else
	--	set geekToolWidth to 0
	--end if
	
	-- Subtract geekToolWidth from display width
	set dWidth to dWidth - geekToolWidth
	
	
	-- Resize/move
	tell application "System Events"
		
		tell process appName
			repeat with wn in wnList
				try
					set topWindow to item wn of (every window whose focused is true)
				on error
					set topWindow to window wn
				end try
				-- Set screen size w/o margins
				--set useSize to {dWidth - leftmargin - rightmargin, dHeight - topmargin - bottommargin}
				--if debug_level > 0 then
				--	log "useSize(" & item 1 of useSize & ", " & item 2 of useSize & ")"
				--	if debug_level > 5 then
				--		display dialog "useSize(" & item 1 of useSize & ", " & item 2 of useSize & ")"
				--	end if
				--end if
				-- No margin w/o edges of screen
				--set wpos to {dPosX + leftmargin + xpos * (item 1 of useSize), dPosY + topmargin + ypos * (item 2 of useSize)}
				--set wsize to {xsize * (item 1 of useSize), ysize * (item 2 of useSize)}
				
				-- Set margin in any place
				set wpos to {dPosX + leftmargin + xpos * dWidth, dPosY + topmargin + ypos * dHeight}
				set wsize to {xsize * dWidth - leftmargin - rightmargin, ysize * dHeight - topmargin - bottommargin}
				
				if debug_level > 0 then
					log "wpos(" & item 1 of wpos & ", " & item 2 of wpos & ")"
					log "wsize(" & item 1 of wsize & ", " & item 2 of wsize & ")"
					if debug_level > 5 then
						display dialog "wpos(" & item 1 of wpos & ", " & item 2 of wpos & ")"
						display dialog "wsize(" & item 1 of wsize & ", " & item 2 of wsize & ")"
					end if
				end if
				tell topWindow
					if debug_level > 0 then
						log "preoperties before= "
						log properties
					end if
					set position to wpos
					if resize is 1 then
						set size to wsize
						-- When the original height is larger than the display size,
						-- the resize couldn't work well.
						-- Need to resize lower edge to internal of the display ({1,1})
						-- then resize to target size. 
						-- -> resize to {1,1} could make a crash for such a terminal with screen.
						--    (maybe too small to resize windows.)
						--   use {100,100} for safe.
						-- if height is longer than display size, width can't be shorten than display size.
						-- Then, sometime only height can be changed first in the below procedure,
						-- then, need one more resize for the width (5 times for safe, but normamlly it should be fixed in a 2 times.)
						-- In addition, sometime winSize is set to a little different (0.5 or so) from wsize.
						-- wsHalf always repeats 5 times as it set wsize + 0.5 width always...
						-- To avoid this, compare winSize + 10 and wsize. 
						repeat 5 times
							set winSize to size
							-- display dialog "winSize(" & item 1 of winSize & ", " & item 2 of winSize & "), wsize(" & item 1 of wsize & ", " & item 2 of wsize & ")"
							
							if item 1 of winSize > (item 1 of wsize) + 10 or item 2 of winSize > (item 2 of wsize) + 10 then
								
								set size to {100, 100}
								set size to wsize
								delay 0.1
							else
								exit repeat
							end if
						end repeat
					end if
				end tell
			end repeat
		end tell
	end tell
end windowSize

on run
	windowSize({})
end run
