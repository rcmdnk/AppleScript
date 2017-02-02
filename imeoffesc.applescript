property DEBUG : false
property LOG_FILE : "~/imeoffesc.log"
property JP_LIST : {"ひらがな"}

on echo(txt)
	if DEBUG then
		do shell script "echo \"" & txt & "\" >> " & LOG_FILE
	end if
end echo
echo("imeoffsec")

echo("Check IME")
set imeOn to false
tell application "System Events"
	tell process "SystemUIServer"
		set imeStatus to value of first menu bar item of menu bar 1 whose description is "text input"
	end tell
end tell
echo("imeStatus: " & imeStatus)

repeat with j in JP_LIST
	if imeStatus starts with j then
		set imeOn to true
		exit repeat
	end if
end repeat
echo("imeOn: " & imeOn)

tell application "System Events"
	set pList to name of every process whose frontmost is true
	set appName to item 1 of pList
	tell process appName
		-- 53: ESC
		-- 102: EISU
		if imeOn then
			key code 53
			key code 102
			key code 53
		else
			log ("send ESC")
			key code 53
		end if
	end tell
end tell
