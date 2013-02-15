set mpt to my getMouseLocation()

log my screenVisibleSizeAtPoint(item 1 of mpt, item 2 of mpt)

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
		return missing value
	end if
	return {x:(paragraph 1 of sizeText) as number, y:(paragraph 2 of sizeText) as number, width:(paragraph 3 of sizeText) as number, height:(paragraph 4 of sizeText) as number}
end screenVisibleSizeAtPoint

on getMouseLocation()
	set theRubyScript to "require 'osx/cocoa';
event=OSX::CGEventCreate(nil);
pt = OSX::CGEventGetLocation(event);
print pt.x, '
',pt.y;
"
	set thePtText to do shell script "/usr/bin/ruby -e " & quoted form of theRubyScript
	set theResultList to {paragraph 1 of thePtText as number, paragraph 2 of thePtText as number}
	return theResultList
end getMouseLocation

(*
log my screenVisibleSize(1)
log my screenVisibleSize(2)

on screenVisibleSize(screenIndex)
	set theScript to "require 'osx/cocoa'; 
i = (ARGV[1].to_i) - 1;
frameM = OSX::NSScreen.mainScreen().frame();
frameT = OSX::NSScreen.screens[i].visibleFrame();
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
	set sizeText to do shell script "/usr/bin/ruby -e " & quoted form of theScript & " '' " & " " & screenIndex
	return {x:(paragraph 1 of sizeText) as number, y:(paragraph 2 of sizeText) as number, width:(paragraph 3 of sizeText) as number, height:(paragraph 4 of sizeText) as number}
end screenVisibleSize
*)

(*
log my screenSize(1)
log my screenSize(2)

on screenSize(screenIndex)
	set theScript to "require 'osx/cocoa'; 
i = (ARGV[1].to_i) - 1;
frame = OSX::NSScreen.screens[i].frame();
print frame.size.width,' ',frame.size.height;
"
	set sizeText to do shell script "/usr/bin/ruby -e " & quoted form of theScript & " '' " & " " & screenIndex
	return {(word 1 of sizeText) as number, (word 2 of sizeText) as number}
end screenSize
*)
(*
--activate application "Dock"
tell application "System Events"
	tell process "Dock"
		get position of list 1
		get size of list 1
	end tell
end tell
*)
(*
tell application "System Events"
	set pList to name of every process whose frontmost is true
	set appName to item 1 of pList
	
	tell application process "GeekTool"
		try
			set topWindow to item 1 of (every window whose focused is true)
		on error
			set topWindow to window 1
			display dialog "hoge"
		end try
		set winPos to position of topWindow
		set winSize to size of topWindow
		set p1 to item 1 of winPos
		set p2 to item 2 of winPos
		set s1 to item 1 of winSize
		set s2 to item 2 of winSize
		display dialog "pos={" & p1 & "," & p2 & "}, size={" & s1 & "," & s2 & "}"
		
	end tell
end tell
*)

