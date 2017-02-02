tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set mouseMoveScpt to scriptPath & "mouseMove.scpt"
set mouseMove to load script file mouseMoveScpt
mouseMove's mouseMove({mouseKey:"8"})
