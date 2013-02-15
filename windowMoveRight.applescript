tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set windowMoveScpt to scriptPath & "windowMove.scpt"
set windowMove to load script file windowMoveScpt
windowMove's windowMove(1, 0)

