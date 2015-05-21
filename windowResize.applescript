property ONE_RESIZE : 50
on windowResize(xResize, yResize)
	tell application "System Events"
		set pList to name of every process whose frontmost is true
		set appName to item 1 of pList
		tell process appName
			try
				set topWindow to item 1 of (every window whose focused is true)
			on error
				set topWindow to window 1
			end try
			set winSize to size of topWindow
			set x to item 1 of winSize
			set y to item 2 of winSize
			set newSize to {x + xResize * ONE_RESIZE, y + yResize * ONE_RESIZE}
			tell topWindow
				set size to newSize
			end tell
		end tell
	end tell
end windowResize
