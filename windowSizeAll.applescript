-- app to be excepted
set expApp to {"thunderbird-bin", "XRG", "Skype"}

-- app to be half size, in left monitor (0.7 times full)
set halfSizeApp_L to {}

-- app to be half size, in right monitor
set halfSizeApp_R to {"AdobeReader"}

-- app only to be moved, in left monitor
set noResizeApp_L to {}

-- app only to be moved, in right monitor
set noResizeApp_R to {"Finder", "Skype", "Microsoft Word", "Microsoft Excel", "Microsoft PowerPoint"}

-- app to be moved left
set app_L to {"firefox", "Evernote", "thunderbird", "thunderbird-bin", "Mail"}

-- app to be moved right
set app_R to {"iTerm"}

-- get screen size
tell application "Finder"
	set scriptPath to (path to me)'s folder as text
end tell
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt

-- main screen
set svs to windowSize's getVisibleFrame(100, 100)
set dPosX to item 1 of svs
set dPosY to item 2 of svs
set dWidth to item 3 of svs
set dHeight to item 4 of svs

-- try to get left screen
set dPosX_L to dPosX
set dPosY_L to dPosY
try
	set svsL to windowSize's getVisibleFrame(-100, 100)
	set dPosX_L to item 1 of svsL
	set dPosY_L to item 2 of svsL
end try

-- try to get right screen
set dPosX_R to dPosX
set dPosY_R to dPosY
try
	set svsR to windowSize's getVisibleFrame(dPosX + dWidth + 100, 100)
	set dPosX_R to item 1 of svsR
	set dPosY_R to item 2 of svsR
end try


-- get application name
tell application "System Events"
	set appList to (get name of every application process whose visible is true)
end tell

-- repeat for all app
repeat with appName in appList
	if appName is not in expApp then
		tell application "System Events"
			try
				tell process appName
					set nW to number of windows
					display dialog appName & " " & nW
					
					repeat with i from 1 to nW
						log appName & i
						if appName is in halfSizeApp_L then
							windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_L, monPosY:dPosY_L, xsize:0.7, ysize:0.7})
						else if appName is in halfSizeApp_R then
							windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_R, monPosY:dPosY_R, xsize:0.7, ysize:0.7})
						else if appName is in noResizeApp_L then
							windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_L, monPosY:dPosY_L, resize:0})
						else if appName is in noResizeApp_R then
							windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_R, monPosY:dPosY_R, resize:0})
						else if appName is in app_L then
							log "app_L" & appName
							windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_L, monPosY:dPosY_L})
						else if appName is in app_R then
							log "app_R" & appName
							windowSize's windowSize({appName:appName, windowNumber:i, monPosX:dPosX_R, monPosY:dPosY_R})
						end if
					end repeat
				end tell
			end try
		end tell
	end if
end repeat
