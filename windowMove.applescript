on windowMove(xMove, yMove)
	set oneMove to 100
	tell application "System Events"
		set pList to name of every «class prcs» whose frontmost is true
		set appName to item 1 of pList
		
		tell «class prcs» appName
			try
				set topWindow to item 1 of (every window whose «class focu» is true)
			on error
				set topWindow to window 1
			end try
			set winPos to «class posn» of topWindow
			set x to item 1 of winPos
			set y to item 2 of winPos
			set newPos to {x + xMove * oneMove, y + yMove * oneMove}
			tell topWindow
				set «class posn» to newPos
			end tell
		end tell
	end tell
end windowMove
