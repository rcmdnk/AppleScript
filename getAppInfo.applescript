tell application "System Events"
	set pList to name of every process whose frontmost is true
	set appName to item 1 of pList
end tell
set appName to "Google Chrome"
log appName

set windowNumber to 1
tell application "System Events"
	tell process appName
		--try
		--	set topWindow to item windowNumber of (every window whose focused is true)
		--on error
		repeat with windowNumber in [0, 1, 2, 3]
			set topWindow to window windowNumber
			--end try
			set winPos to position of topWindow
			set winSize to size of topWindow
			set winPosX to item 1 of winPos
			set winPosY to item 2 of winPos
			set winSizeX to item 1 of winSize
			set winSizeY to item 2 of winSize
			set winPosRT to {winPosX + winSizeX, winPosY}
			set winPosLB to {winPosX, winPosY + winSizeY}
			set winPosRB to {winPosX + winSizeX, winPosY + winSizeY}
			log "winPos(" & winPosX & ", " & winPosY & ")"
			log "winSize(" & winSizeX & ", " & winSizeY & ")"
			log properties of topWindow
		end repeat
	end tell
	
end tell
--tell application "System Events"
--	try
--		tell process appName
--			--check number of windows
--			--activate
--			set nW to number of windows
--			log appName & " in process, nWindows=" & nW
--			set topWindow to widnow 1
--			--repeat with w in windows
--			--	log properties of w
--			--	set x to item 1 of position of w
--			--	log item 2 of position of w
--			--	log x
--			--end repeat
--		end tell
--	on error
--		display dialog "can't get nWindows in process"
--	end try
--end tell

--tell application appName
--	--check number of windows
--	try
--		set nW to number of windows
--		display dialog appName & " in application, nWindows=" & nW
--	on error
--		display dialog "can't get nWindows in application"
--	end try
--end tell

--tell application appName
--	try
--		--check number of documents
--		set nDoc to number of document
--		display dialog appName & " in application, nDocuments=" & nDoc
--	on error
--		display dialog "can't get nDocuments in application"
--	end try
--end tell
