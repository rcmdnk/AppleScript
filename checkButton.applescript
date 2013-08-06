
tell application "System Events"
	set pList to name of every process whose frontmost is true
	set appName to item 1 of pList
	tell process appName
		--activate
		set nButtons to number of buttons
		display dialog appName & ", nButtons=" & nButtons
		tell window 3
			get properties of every button
			repeat with p in (get properties of every button)
				display dialog description of p
				display dialog subrole of p
			end repeat
			display dialog "end"
			close
		end tell
	end tell
end tell
