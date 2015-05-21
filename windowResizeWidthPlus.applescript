tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set windowResizeScpt to scriptPath & "windowResize.scpt"
set windowResize to load script file windowResizeScpt
windowResize's windowResize(1, 0)
