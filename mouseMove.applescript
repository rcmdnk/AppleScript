property N_MOVE : 100
property MOUSE_KEY : 8

-- Mouse Move using Mouse Key
on mouseMove(pars)
	-- Set Parameters
	set nMove to nMove of (pars & {nMove:N_MOVE})
	set mouseKey to mouseKey of (pars & {mouseKey:MOUSE_KEY})
	
	tell application "System Events"
		repeat nMove times
			keystroke mouseKey
		end repeat
	end tell
	
end mouseMove

on run
	mouseMove({})
end run
