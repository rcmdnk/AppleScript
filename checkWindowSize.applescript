set mpt to my getMousePosition()

set scriptPath to ((path to me as text) & "::")
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt

log my windowSize's getVisibleFrame(item 1 of mpt, item 2 of mpt)

on getMousePosition()
	set cocoaScript to "require 'osx/cocoa';
event=OSX::CGEventCreate(nil);
pt = OSX::CGEventGetLocation(event);
print pt.x, '
',pt.y;
"
	set ret to do shell script "/usr/bin/ruby -e " & quoted form of cocoaScript
	return {paragraph 1 of ret as number, paragraph 2 of ret as number}
end getMousePosition
