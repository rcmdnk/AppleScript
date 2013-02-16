on getVisibleFrame(x, y)
	-- ref: http://memogakisouko.appspot.com/AppleScript.html
	set cocoaScript to "require 'osx/cocoa'; 
x = (ARGV[1].to_i);
y = (ARGV[2].to_i);

mf = OSX::NSScreen.mainScreen().frame();
mX = mf.origin.x
mY = mf.origin.y
mW = mf.size.width
mH = mf.size.height
sc = OSX::NSScreen.screens;
point = OSX::NSMakePoint(x, -y + mY + mH);
vf = 0
for i in 0..sc.count()-1
	f = sc[i].frame();
	if( OSX:: NSMouseInRect(point,f,0) )
		vf = sc[i].visibleFrame();
		break;
	end
end

if vf == 0
exit 0;
end

vX = vf.origin.x
vY = vf.origin.y
vW = vf.size.width
vH = vf.size.height

print (vX);
print '
';
print (-vY - vH + mH - mY);
print '
';
print vW;
print '
';
print vH;
"
	
	set ret to do shell script "/usr/bin/ruby -e " & quoted form of cocoaScript & " '' " & " " & x & " " & y
	if ret is "" then
		--display dialog "missing value"
		return 0
	end if
	return {(paragraph 1 of ret) as number, (paragraph 2 of ret) as number, (paragraph 3 of ret) as number, (paragraph 4 of ret) as number}
end getVisibleFrame

log getVisibleFrame(100, 100)
--log getVisibleFrame(-100, 10)
--log getVisibleFrame(1500, 10)
--log getVisibleFrame(54, 47)


--tell application "Finder"
--	set bounds of Finder window 1 to {10, 32, 1200, 854 + 32}
--end tell
