
tell application "System Events"
	set pList to name of every «class prcs» whose frontmost is true
	set appName to item 1 of pList
	tell «class prcs» appName
		--activate
		set nButtons to number of every «class butT»
		display dialog appName & ", nButtons=" & nButtons
		tell window 3
			get properties of every «class butT»
			repeat with p in (get properties of every «class butT»)
				display dialog «class desc» of p
				display dialog «class sbrl» of p
			end repeat
			display dialog "end"
			close
		end tell
	end tell
end tell
