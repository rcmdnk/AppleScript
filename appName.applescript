tell application "System Events"
	set pList to name of every process whose frontmost is true
	set appName to item 1 of pList
end tell
display dialog appName


tell application "Finder"
	set AppList to name of every process
	display dialog AppList
end tell
