on getCurrentFrame(x, y, vframes)
	tell application "Finder"
		set scriptPath to (path to me)'s folder as text
	end tell
	set recordlib to scriptPath & "recordlib.scpt"
	set rb to load script file recordlib
	set positions to {"main_frames", "left_frames", "right_frames", "top_frames", "bottom_frames"}
	--repeat with pos in positions
	--	return pos
	--
	-- this returns "item 1 of {"main_frames", "left_frames", "right_frames", "top_frames", "bottom_frames"}", isntead of "main_frames"
	-- need to use i from 1 to lenght ...
	repeat with i from 1 to length of positions
		set pos to item i of positions
		set frames to rb's getKeyValue(vframes, pos)
		repeat with i from 1 to frames's length
			set f to item i of frames
			if x ≥ f's origin's x and x ≤ (f's origin's x) + (f's |size|'s width) and y ≥ f's origin's y and y ≤ (f's origin's y) + (f's |size|'s height) then
				return {pos, i, vframes}
			end if
		end repeat
	end repeat
	return 0
end getCurrentFrame

on getCurrentFrameSA(x, y)
	-- get current frame stand alone (w/o vframes input)
	
	tell application "Finder"
		set scriptPath to (path to me)'s folder as text
	end tell
	set visibleFrameScpt to scriptPath & "visibleFrame.scpt"
	set vf to load script file visibleFrameScpt
	set vframes to vf's getAllVisibleFrame()
	return getCurrentFrame(x, y, vframes)
end getCurrentFrameSA

on run
	tell application "System Events"
		set pList to name of every process whose frontmost is true
		set appName to item 1 of pList
		tell process appName
			try
				set topWindow to item 1 of (every window whose focused is true)
			on error
				set topWindow to window 1
			end try
			set winPos to position of topWindow
			set winPosX to item 1 of winPos
			set winPosY to item 2 of winPos
		end tell
	end tell
	return getCurrentFrameSA(winPosX, winPosY)
end run
