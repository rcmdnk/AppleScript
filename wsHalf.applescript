tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt
set pars to {xsize:0.7, ysize:0.7}
windowSize's windowSize(pars)

