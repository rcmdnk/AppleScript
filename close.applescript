-- debug mode
set debug to 0

-- maximum number of windows to quit
set maxWindows to 1
set nW to 0

-- quit flag
set isQuit to -1

-- always quit
--set alwaysQuit to {"cooViewer", "JavaApplicationStub"}
set alwaysQuit to {"cooViewer"}

-- always close, w/o quit
-- set alwaysClose to {"thunderbird", "thunderbird-bin", "Skype", "Finder", "X11.bin", "Evernote"}
set alwaysClose to {"Mail", "Skype", "Finder", "X11.bin", "Evernote", "Slack"}

-- for below applications, use nWindows in applicatoin
set useApplication to {"Microsoft Word", "Microsoft Excel", "EverNote"}

--for below applications, use document instead of windows, in application
set useDocument to {}

-- debug mode
if debug > 0 then
	display dialog "debug mode = " & debug
end if

-- get application name
tell application "System Events"
	-- get application name of frontmost 
	set pList to name of every process whose frontmost is true
	set appName to item 1 of pList
	if debug > 1 then
		display dialog appName
	end if
end tell

-- check application
if appName is in alwaysQuit then
	set isQuit to 1
else if appName is in alwaysClose then
	set isQuit to 0
else if appName is in useApplication then
	set isQuit to 2
else if appName is in useDocument then
	set isQuit to 3
end if

-- check winsows/documents in application
if isQuit is 2 or isQuit is 3 then
	tell application appName
		-- activate
		if isQuit is 2 then
			-- check number of windows
			if debug > 1 then
				display dialog "get number of windows in application"
			end if
			
			set nW to number of windows
			if debug > 0 then
				repeat with i from 1 to nW
					get properties of window i
				end repeat
			end if
			if debug > 1 then
				display dialog appName & ", nWindows=" & nW
			end if
		else
			if debug > 1 then
				display dialog "get number of documents in application"
			end if
			set nW to number of document
			if debug > 1 then
				display dialog appName & ", nDocuments=" & nW
			end if
		end if
		if nW ≤ maxWindows then
			set isQuit to 1
		else
			set isQuit to 0
		end if
	end tell
end if

-- check windows in process
if isQuit is -1 then
	tell application "System Events"
		tell process appName
			-- activate
			-- check number of windows
			if debug > 0 then
				repeat with w in windows
					get properties of w
				end repeat
			end if
			if debug > 1 then
				display dialog "get number of windows in process"
			end if
			set nW to number of windows
			if debug > 1 then
				display dialog appName & ", nWindows=" & nW
			end if
			if nW ≤ maxWindows then
				set isQuit to 1
			else
				set isQuit to 0
			end if
		end tell
	end tell
end if

-- close
if isQuit is 0 then
	if debug > 1 then
		display dialog "in close"
	end if
	tell application "System Events"
		tell process appName
			-- activate
			
			-- using close method
			--tell window 1
			--close
			--end tell
			
			-- using GUI button
			-- check window, apply on "AXStandardWindow"
			repeat with w in windows
				repeat 1 times -- fake loop for pseudo "continue"
					--if debug > 0 then
					--	get properties of w
					--end if
					set p to properties of w
					set s to subrole of p
					if s is not equal to "AXStandardWindow" then
						exit repeat --exit fake loop
					end if
					
					tell w
						-- click (button 1 of (item 1 of windows)) -- button 1 is the close button… -- not for all, check "AXCloseButton"
						set i to 1
						repeat with p in (get properties of every button)
							set s to subrole of p
							if debug > 1 then
								display dialog s
							end if
							if s is "AXCloseButton" then
								click button i
								exit repeat
							end if
							set i to i + 1
						end repeat
						return
					end tell
				end repeat
			end repeat
		end tell
	end tell
end if

-- quit
if isQuit = 1 then
	tell application appName
		-- quit application
		if debug > 1 then
			display dialog "quit"
		end if
		quit
		if debug > 1 then
			display dialog "quit, ok"
		end if
		return
	end tell
end if
