tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set moveForMonScpt to scriptPath & "moveForMon.scpt"
set moveformon to load script file moveForMonScpt
moveformon's moveformon({all:true})
