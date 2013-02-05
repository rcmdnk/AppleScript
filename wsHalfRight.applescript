tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt
windowSize's windowSize(0.5, 1, 0.5, 0, "", "", "", "", "", "")
