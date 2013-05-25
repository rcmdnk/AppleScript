tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt
windowSize's windowSize({xsize:1, ysize:0.5, xpos:0, ypos:0.5})
