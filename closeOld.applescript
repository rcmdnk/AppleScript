
--maximum number of windows to quit
set maxWindows to 1

--get application name of frontmost 

tell application "System Events"
	set pList to name of every process whose frontmost is true
	set appName to item 1 of pList
end tell

--some application shows more than 1 window when it seems only 1 window
--firefox shows 2 or 3 windows when it seems only 1 window
if appName = "Firefox" then
	set maxWindows to 3
else if appName = "Spark" then
	set maxWindows to 3
	--for following applications, don't close event if there is only 1 window
else if appName = "thunderbird-bin" then
	set maxWindows to 0
else if appName = "Skype" then
	set maxWindows to 0
end if

--for below applications, use document instead of windows
set useDocument to {"AppleScript Editor"}


--for below applications, 
--"number of windows" can't be applied,
--always quit
set alwaysQuit to {"Activity Monitor", "AdobeReader", "Adobe Illustrator", "Cyberduck"}

--always close
set alwaysClose to {""}

--close or quit
tell application appName
	--quit flag
	set isQuit to 0
	
	display dialog appName
	if appName is in alwaysQuit then
		set isQuit to 1
	else if appName is in alwaysClose then
		set isQuit to 0
	else
		--check number of windows/document
		if appName is in useDocument then
			set nW to number of document
		else
			set nW to number of windows
		end if
		display dialog appName & ", nWindows=" & nW
		if nW ≤ maxWindows then
			set isQuit to 1
		end if
	end if
	if isQuit = 1 then
		--quit application
		--display dialog "quit"
		quit
		--display dialog "quit, ok"
	else
		--close frontmost window
		--display dialog "close"
		tell window 1
			close
		end tell
		--display dialog "close, ok"
	end if
end tell
