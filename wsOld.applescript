set menuheight to 22
set dockheight to 60
set geekToolWidth to 180

set leftmargin to 10
set rightmargin to 10
set topmargin to 10
set bottommargin to 10

--*get screen size
tell application "Finder"
	set displayBounds to bounds of window of desktop
	set dle to item 1 of displayBounds
	set dte to item 2 of displayBounds
	set dre to item 3 of displayBounds
	set dbe to item 4 of displayBounds
end tell

--*get dock's height (assume dock is on the bottom)  and GeekTool's width
tell application "System Events"
	tell process "Dock"
		set dPos to position of list 1
		set dPosY to item 2 of dPos
		set dockheight to dbe - dPosY
	end tell
	
	tell process "GeekTool"
		set topWindow to window 1
		set gtSize to size of topWindow
		set geekToolWidth to item 1 of gtSize
		set geekToolWidth to geekToolWidth + 10 -- additional margin
	end tell
end tell

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
		set wle to item 1 of winPos
		set wpos to {0, 0}
		set wsize to {0, 0}
		if dle < 0 then
			if wle < 0 then
				set wpos to {dle + leftmargin, topmargin}
				set wsize to {0 - dle - leftmargin - rightmargin - geekToolWidth, dbe - topmargin - bottommargin}
			else
				set wpos to {0 + leftmargin, topmargin + menuheight}
				set wsize to {dre - leftmargin - rightmargin, dbe - menuheight - topmargin - bottommargin - dockheight}
			end if
		else
			set wpos to {0 + leftmargin, topmargin + menuheight}
			set wsize to {dre - leftmargin - rightmargin - geekToolWidth, dbe - menuheight - topmargin - bottommargin - dockheight}
		end if
		
		tell topWindow
			set position to wpos
			set size to wsize
		end tell
	end tell
end tell

