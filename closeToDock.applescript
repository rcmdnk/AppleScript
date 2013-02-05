--debug mode
set debug to 0

--for below applications, use nWindows in applicatoin
set useApplication to {"Microsoft Word", "Microsoft Excel"}

--get application name
tell application "System Events"
	--get application name of frontmost 
	set pList to name of every process whose frontmost is true
	set appName to item 1 of pList
	if debug > 1 then
		display dialog appName
	end if
end tell

--close
if debug > 1 then
	display dialog "in close"
end if
tell application "System Events"
	tell process appName
		--activate
		
		--using GUI button
		--check window, apply on "AXStandardWindow"
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
					--click (button 1 of (item 1 of windows)) -- button 1 is the close button… -- not for all, check "AXCloseButton"
					set i to 1
					repeat with p in (get properties of every button)
						set s to subrole of p
						if debug > 1 then
							display dialog s
						end if
						if s is "AXMinimizeButton" then
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
