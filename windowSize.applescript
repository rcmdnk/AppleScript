property DEBUG_LEVEL : 1

property DEF_LEFT_MARGIN : 10
property DEF_RIGHT_MARGIN : 10
property DEF_TOP_MARGIN : 10
property DEF_BOTTOM_MARGIN : 10

property GEEKTOOL_WINDOW : 1
property GEEKTOOL_MARGIN : 10

-- Window size main function
on windowSize(pars)
	-- Debug mode
	if DEBUG_LEVEL > 0 then
		log "debug mode = " & DEBUG_LEVEL
		if DEBUG_LEVEL > 1 then
			display dialog "debug mode = " & DEBUG_LEVEL
		end if
	end if
	
	-- Set Parameters
	set {xsize, ysize, xpos, ypos, leftmargin, rightmargin, topmargin, bottommargin, appName, windowNumber, monPosX, monPosY, resize} to {1, 1, 0, 0, DEF_LEFT_MARGIN, DEF_RIGHT_MARGIN, DEF_TOP_MARGIN, DEF_BOTTOM_MARGIN, "", "", "", "", 1}
	try
		set xsize to xsize of pars
	end try
	try
		set ysize to ysize of pars
	end try
	try
		set xpos to xpos of pars
	end try
	try
		set ypos to ypos of pars
	end try
	try
		set leftmargin to leftmargin of pars
	end try
	try
		set rightmargin to rightmargin of pars
	end try
	try
		set topmargin to topmargin of pars
	end try
	try
		set bottommargin to bottommargin of pars
	end try
	try
		set appName to appName of pars
	end try
	try
		set windowNumber to windowNumber of pars
	end try
	try
		set monPosX to monPosX of pars
	end try
	try
		set monPosY to monPosY of pars
	end try
	try
		set resize to resize of pars
	end try
	
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
	
	
	
	if DEBUG_LEVEL > 0 then
		log "windowSize(" & xsize & ", " & ysize & ", " & xpos & ", " & ypos & ", " & leftmargin & ", " & rightmargin & ", " & topmargin & ", " & bottommargin & ", " & appName & ", " & windowNumber & ", " & monPosX & ", " & monPosY & "," & resize & ")"
		if DEBUG_LEVEL > 1 then
			display dialog "windowSize(" & xsize & ", " & ysize & ", " & xpos & ", " & ypos & ", " & leftmargin & ", " & rightmargin & ", " & topmargin & ", " & bottommargin & ", " & appName & ", " & windowNumber & ", " & monPosX & ", " & monPosY & "," & resize & ")"
		end if
	end if
	
	-- First, move monitoring applications to correct places, if available
	try
		tell application "Finder"
			set scriptPath to (path to me)'s folder as text
		end tell
		set moveForMonScpt to scriptPath & "moveForMon.scpt"
		set moveForMon to load script file moveForMonScpt
		moveForMon's moveForMon(false)
	end try
	
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
			if DEBUG_LEVEL > 0 then
				log "winPos(" & winPosX & ", " & winPosY & ")"
				log "winSize(" & winSizeX & ", " & winSizeY & ")"
				if DEBUG_LEVEL > 1 then
					display dialog "winPos(" & winPosX & ", " & winPosY & ")"
					display dialog "winSize(" & winSizeX & ", " & winSizeY & ")"
				end if
			end if
		end tell
	end tell
	
	-- Get screen (display) size
	if monPosX is not "" and monPosY is not "" then
		set svs to getVisibleFrame(monPosX, monPosY)
		set dPosX to item 1 of svs
	else
		try
			set svs to getVisibleFrame(item 1 of winPos, item 2 of winPos)
			set dPosX to item 1 of svs
			
		on error
			try
				set svs to getVisibleFrame(item 1 of winPosRT, item 2 of winPosRT)
				set dPosX to item 1 of svs
				
			on error
				try
					set svs to getVisibleFrame(item 1 of winPosLB, item 2 of winPosLB)
					set dPosX to item 1 of svs
					
				on error
					set svs to getVisibleFrame(item 1 of winPosRB, item 2 of winPosRB)
					set dPosX to item 1 of svs
				end try
			end try
		end try
	end if
	
	set dPosX to item 1 of svs
	set dPosY to item 2 of svs
	set dWidth to item 3 of svs
	set dHeight to item 4 of svs
	if DEBUG_LEVEL > 0 then
		log "svs(" & dPosX & ", " & dPosY & ", " & dWidth & ", " & dHeight & ")"
		if DEBUG_LEVEL > 1 then
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
		set gtsvs to getVisibleFrame(item 1 of gtPos, item 2 of gtPos)
		set gtdPosX to item 1 of gtsvs
		set gtdPosY to item 2 of gtsvs
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
			try
				set topWindow to item windowNumber of (every window whose focused is true)
			on error
				set topWindow to window windowNumber
			end try
			-- Set screen size w/o margins
			--set useSize to {dWidth - leftmargin - rightmargin, dHeight - topmargin - bottommargin}
			--if DEBUG_LEVEL > 0 then
			--	log "useSize(" & item 1 of useSize & ", " & item 2 of useSize & ")"
			--	if DEBUG_LEVEL > 1 then
			--		display dialog "useSize(" & item 1 of useSize & ", " & item 2 of useSize & ")"
			--	end if
			--end if
			-- No margin w/o edges of screen
			--set wpos to {dPosX + leftmargin + xpos * (item 1 of useSize), dPosY + topmargin + ypos * (item 2 of useSize)}
			--set wsize to {xsize * (item 1 of useSize), ysize * (item 2 of useSize)}
			
			-- Set margin in any place
			set wpos to {dPosX + leftmargin + xpos * dWidth, dPosY + topmargin + ypos * dHeight}
			set wsize to {xsize * dWidth - leftmargin - rightmargin, ysize * dHeight - topmargin - bottommargin}
			
			if DEBUG_LEVEL > 0 then
				log "wpos(" & item 1 of wpos & ", " & item 2 of wpos & ")"
				log "wsize(" & item 1 of wsize & ", " & item 2 of wsize & ")"
				if DEBUG_LEVEL > 1 then
					display dialog "wpos(" & item 1 of wpos & ", " & item 2 of wpos & ")"
					display dialog "wsize(" & item 1 of wsize & ", " & item 2 of wsize & ")"
				end if
			end if
			tell topWindow
				if DEBUG_LEVEL > 0 then
					log "preoperties before= "
					log properties
				end if
				set winSize to size
				if item 1 of winSize > dWidth or item 2 of winSize > dHeight then
					if DEBUG_LEVEL > 1 then
						display dialog "Curent size is larger than window size!"
					end if
					set position to {dPosX - ((item 1 of wpos) + (item 1 of wsize) - dWidth), dPosY - ((item 2 of wpos) + (item 2 of wsize) - dHeight)}
				else if (item 1 of wpos) + (item 1 of winSize) > dWidth or (item 2 of wpos) + (item 2 of winSize) > dHeight then
					if DEBUG_LEVEL > 1 then
						display dialog "Curent size is larger than window-windowpos!"
					end if
					set position to {dPosX, dPosY}
				else
					set position to wpos
				end if
				if DEBUG_LEVEL > 0 then
					log "preoperties after position change= "
					log properties
					if DEBUG_LEVEL > 1 then
						display dialog "set size"
					end if
				end if
				if resize is 1 then
					set size to wsize
				end if
				-- This shows an error for iTerm!
				-- maybe properties is changed when set size…???
				--if DEBUG_LEVEL > 0 then
				--	log "preoperties after resize= "
				--	properties
				--	if DEBUG_LEVEL > 1 then
				--		display dialog "set final position"
				--	end if
				--end if
				
				--end tell
				--try
				--	set topWindow to item windowNumber of (every window whose focused is true)
				--on error
				--	set topWindow to window windowNumber
				--end try
				--tell topWindow
				
				if DEBUG_LEVEL > 0 then
					log "preoperties after resize= "
					log properties
					if DEBUG_LEVEL > 1 then
						display dialog "set final position to (" & item 1 of wpos & ", " & item 2 of wpos & ")"
					end if
				end if
				set position to wpos
				
				if DEBUG_LEVEL > 2 then
					log "properties after = "
					log properties
				end if
			end tell
			
		end tell
	end tell
end windowSize

-- Function to get visible frame (w/o menu bar, dock)
on getVisibleFrame(x, y)
	set cocoaScript to "require 'osx/cocoa'; 
x = (ARGV[1].to_i);
y = (ARGV[2].to_i);

mf = OSX::NSScreen.mainScreen().frame();
mX = mf.origin.x
mY = mf.origin.y
mW = mf.size.width
mH = mf.size.height
sc = OSX::NSScreen.screens;
point = OSX::NSMakePoint(x, -y + mY + mH);
vf = 0
for i in 0..sc.count()-1
	f = sc[i].frame();
	if( OSX:: NSMouseInRect(point,f,0) )
		vf = sc[i].visibleFrame();
		break;
	end
end

if vf == 0
exit 0;
end

vX = vf.origin.x
vY = vf.origin.y
vW = vf.size.width
vH = vf.size.height

print (vX);
print '
';
print (-vY - vH + mH - mY);
print '
';
print vW;
print '
';
print vH;
"
	
	set ret to do shell script "/usr/bin/ruby -e " & quoted form of cocoaScript & " '' " & " " & x & " " & y
	if ret is "" then
		--display dialog "missing value"
		return 0
	end if
	return {(paragraph 1 of ret) as number, (paragraph 2 of ret) as number, (paragraph 3 of ret) as number, (paragraph 4 of ret) as number}
end getVisibleFrame
