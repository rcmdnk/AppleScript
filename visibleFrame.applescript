use framework "AppKit"
on getVisibleFrame(x, y)
	set nss to current application's NSScreen
	set mf to nss's mainScreen's frame()
	set mfX to mf's origin's x
	set mfY to mf's origin's y
	set mfW to mf's |size|'s width
	set mfH to mf's |size|'s height
	set p to {x:x, y:-y + mfY + mfH}
	set vf to 0
	repeat with sc in nss's screens()
		set f to sc's frame()
		if current application's NSMouseInRect(p, f, 0) then
			set vf to sc's visibleFrame()
			exit repeat
		end if
	end repeat
	if vf is 0 then
		return 0
	end if
	set vX to vf's origin's x
	set vY to vf's origin's y
	set vW to vf's |size|'s width
	set vH to vf's |size|'s height
	-- Visible Frame's origin is left lower,
	-- while an origin of window's position in windowSize function is left upper.
	-- Therefore, second (y) is recalculated as left upper origin version.
	return {vX, -vY - vH + mfH - mfY, vW, vH}
end getVisibleFrame

on run
	getVisibleFrame(0, 0)
end run
