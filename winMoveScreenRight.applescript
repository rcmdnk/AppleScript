tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt
windowSize's windowSize({direction:"RIGHT", resize:0})