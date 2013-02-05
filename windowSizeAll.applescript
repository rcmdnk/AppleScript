--*mergin
set leftmargin to 10
set rightmargin to 10
set topmargin to 15
set bottommargin to 20

--*app to be excepted
set expApp to {"thunderbird-bin", "XRG", "Skype"}

--*app to be half size
set halfSizeApp to {"AdobeReader"}

--*app only to be moved
set noResizeApp to {"Finder"}

--*get screen size
set svs to screenVisibleSizeAtPoint(1, 1) --*main screen, (-1,1) for secondary screen in the left, (1+(mainscreen size),1 for secondary screen in the right)
set dPosX to item 1 of svs
set dPosX to item 1 of svs
set dPosY to item 2 of svs
set dWidth to item 3 of svs
set dHeight to item 4 of svs

--*get application name
tell application "System Events"
	set appList to (get name of every application process whose visible is true)
end tell

--*repeat for all app
repeat with appName in appList
	if appName is not in expApp then
		tell application "System Events"
			tell process appName
				repeat with win in windows
					--*get window position
					set winPos to position of win
					set winSize to size of win
					set winPosRT to {(item 1 of winPos) + (item 1 of winSize), item 2 of winPos}
					set winPosLB to {item 1 of winPos, (item 2 of winPos) + (item 2 of winSize)}
					set winPosRB to {(item 1 of winPos) + (item 1 of winSize), (item 2 of winPos) + (item 2 of winSize)}
					
					--*set position, size
					set xsize to 1
					set ysize to 1
					if appName is in halfSizeApp then
						set xsize to 0.5
						--set ysize to 0.5 only x size
					end if
					set wpos to {dPosX + leftmargin, dPosY + topmargin}
					set wsize to {dWidth * xsize - leftmargin - rightmargin, dHeight * ysize - topmargin - bottommargin}
					tell win
						set position to wpos
						if appName is not in noResizeApp then
							set size to wsize
						end if
					end tell
				end repeat
			end tell
		end tell
	end if
end repeat

on screenVisibleSizeAtPoint(x, y)
	set theScript to "require 'osx/cocoa'; 
x = (ARGV[1].to_i);
y = (ARGV[2].to_i);

frameT = 0;
frameM = OSX::NSScreen.mainScreen().frame();
screens = OSX::NSScreen.screens;
cocoaPoint = OSX::NSMakePoint(x, frameM.size.height + frameM.origin.y - y);
for i in 0..screens.count()-1
	f = screens[i].frame();
	if( OSX:: NSMouseInRect(cocoaPoint,f,0) )
		frameT = screens[i].visibleFrame();
		break;
	end
end

if frameT == 0
exit 0;
end

print (frameT.origin.x);
print '
';
print (-frameT.origin.y - frameT.size.height + frameM.size.height - frameM.origin.y);
print '
';
print frameT.size.width;
print '
';
print frameT.size.height;
"
	set sizeText to do shell script "/usr/bin/ruby -e " & quoted form of theScript & " '' " & " " & x & " " & y
	if sizeText is "" then
		--display dialog "missing value"
		return 0
	end if
	return {(paragraph 1 of sizeText) as number, (paragraph 2 of sizeText) as number, (paragraph 3 of sizeText) as number, (paragraph 4 of sizeText) as number}
end screenVisibleSizeAtPoint
