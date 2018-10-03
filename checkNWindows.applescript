--set appName to "GeekTool Helper"
set appName to "Google Chrome"
--set appName to ""

--get application name of frontmost 
if appName is "" then
	tell application "System Events"
		set pList to name of every process whose frontmost is true
		set appName to item 1 of pList
		--display dialog appName
		log appName
		set appName to properties of every process whose frontmost is true
	end tell
end if

tell application "System Events"
	try
		tell process appName
			--check number of windows
			--activate
			set nW to number of windows
			--display dialog appName & " in process, nWindows=" & nW
			repeat with w in windows
				set p to position of w
				set s to size of w
				set x to item 1 of p
				set y to item 2 of p
				log "position: (x, y) = (" & x & ", " & y & ")"
				set x to item 1 of s
				set y to item 2 of s
				log "size    : (x, y) = (" & x & ", " & y & ")"
			end repeat
		end tell
	on error
		--display dialog "can't get nWindows in process"
	end try
end tell

tell application appName
	--check number of windows
	try
		set nW to number of windows
		--display dialog appName & " in application, nWindows=" & nW
	on error
		--display dialog "can't get nWindows in application"
	end try
end tell

tell application appName
	try
		--check number of documents
		set nDoc to number of document
		--display dialog appName & " in application, nDocuments=" & nDoc
	on error
		--display dialog "can't get nDocuments in application"
	end try
end tell
