tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt
set pars to {}
windowSize's windowSize({appName:"firefox", monPosX:-1440, monPosY:1})
