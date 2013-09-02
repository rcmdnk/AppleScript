on windowMove(xMove, yMove)
	set oneMove to 100
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
			set x to item 1 of winPos
			set y to item 2 of winPos
			set newPos to {x + xMove * oneMove, y + yMove * oneMove}
			tell topWindow
				set position to newPos
			end tell
		end tell
	end tell
end windowMove
