tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set restartAppScpt to scriptPath & "restartApp.scpt"
set restartApp to load script file restartAppScpt
restartApp's restartApp({appName:"HyperSwitch", dir:"/Applications/"})
