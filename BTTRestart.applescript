tell application "System Events"
	set ProcessList to name of every process
	if "BetterTouchTool" is in ProcessList then
		set ThePID to unix id of process "BetterTouchTool"
		do shell script "kill -KILL " & ThePID
	end if
end tell
