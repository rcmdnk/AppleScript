

--get application name of frontmost 

tell application "System Events"
	set pList to name of every process whose frontmost is true
	set appName to item 1 of pList
	display dialog appName
	set allp to properties of every process whose frontmost is true
end tell

set appName to "cooViewer"

tell application "System Events"
	try
		tell process appName
			--check number of windows
			--activate
			set nW to number of windows
			display dialog appName & " in process, nWindows=" & nW
		end tell
	on error
		display dialog "can't get nWindows in process"
	end try
end tell

tell application appName
	--check number of windows
	try
		set nW to number of windows
		display dialog appName & " in application, nWindows=" & nW
	on error
		display dialog "can't get nWindows in application"
	end try
end tell

tell application appName
	try
		--check number of documents
		set nDoc to number of document
		display dialog appName & " in application, nDocuments=" & nDoc
	on error
		display dialog "can't get nDocuments in application"
	end try
end tell
