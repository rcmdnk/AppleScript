use framework "AppKit"

on convertToWindowFrame(frame, mfH)
	-- Visible Frame's origin is left lower,
	-- while an origin of "position of window" in windowSize function is left upper.
	-- Therefore, second (y) is recalculated as left upper origin version.
	set frame's origin's y to -(frame's origin's y) - (frame's |size|'s height) + mfH
	return frame
end convertToWindowFrame

on getMainScreen()
	-- current application's NSScreen's mainScreen:
	-- -- This just return the screen of current application. 
	-- -- Need to find real main screen with frame of (x, y) == (0, 0)
	set nss to current application's NSScreen
	repeat with sc in nss's screens()
		set f to sc's frame()
		if f's origin's x is 0 and f's origin's y is 0 then
			return sc
		end if
	end repeat
	return 0
end getMainScreen

on getVisibleFrame(x, y)
	set nss to current application's NSScreen
	set mf to frame() of getMainScreen()
	set mfH to mf's |size|'s height
	set p to {x:x, y:y}
	set vf to 0
	repeat with sc in nss's screens()
		set f to convertToWindowFrame(sc's frame(), mfH)
		if current application's NSMouseInRect(p, f, 0) then
			-- set vf to convertToWindowFrame(sc's visibleFrame(), mfH)
			-- exit repeat
			return convertToWindowFrame(sc's visibleFrame(), mfH)
		end if
	end repeat
	return vf
end getVisibleFrame

on getAllVisibleFrames()
	set nss to current application's NSScreen
	set mf to frame() of getMainScreen()
	set mfW to mf's |size|'s width
	set mfH to mf's |size|'s height
	set mvf to convertToWindowFrame(visibleFrame() of getMainScreen(), mfH)
	set vframes to {main_frames:{mvf}, left_frames:{}, right_frames:{}, top_frames:{}, bottom_frames:{}}
	repeat with sc in nss's screens()
		set f to convertToWindowFrame(sc's frame(), mfH)
		if f is not mf then
			set vf to convertToWindowFrame(sc's visibleFrame(), mfH)
			set frames to {}
			set putflag to false
			if (f's origin's x) + (f's |size|'s width) ≤ 0 then
				set lf to left_frames of vframes
				set oldframes to lf
				repeat with i from 1 to lf's length
					if vf's origin's x ≥ origin's x of item i of lf then
						set frames to frames & {vf} & oldframes
						set putflag to true
						exit repeat
					end if
					set frames to frames & {item 1 of oldframes}
					set oldframes to rest of oldframes
				end repeat
				if not putflag then
					set frames to frames & {vf}
				end if
				set left_frames of vframes to frames
			else if (f's origin's x) ≥ mfW then
				set rf to right_frames of vframes
				set oldframes to rf
				repeat with i from 1 to rf's length
					if vf's origin's x ≤ origin's x of item i of rf then
						set frames to frames & {vf} & oldframes
						set putflag to true
						exit repeat
					end if
					set frames to frames & {item 1 of oldframes}
					set oldframes to rest of oldframes
				end repeat
				if not putflag then
					set frames to frames & {vf}
				end if
				set right_frames of vframes to frames
			else if (f's origin's y) + (f's |size|'s height) ≤ 0 then
				set tf to top_frames of vframes
				set oldframes to tf
				repeat with i from 1 to tf's length
					if vf's origin's y ≤ origin's y of item i of tf then
						set frames to frames & {vf} & oldframes
						set putflag to true
						exit repeat
					end if
					set frames to frames & {item 1 of oldframes}
					set oldframes to rest of oldframes
				end repeat
				if not putflag then
					set frames to frames & {vf}
				end if
				set top_frames of vframes to frames
			else
				set bf to bottom_frames of vframes
				set oldframes to bf
				repeat with i from 1 to bf's length
					if vf's origin's y ≥ origin's y of item i of bf then
						set frames to frames & {vf} & oldframes
						set putflag to true
						exit repeat
					end if
					set frames to frames & {item 1 of oldframes}
					set oldframes to rest of oldframes
				end repeat
				if not putflag then
					set frames to frames & {vf}
				end if
				set bottom_frames of vframes to frames
			end if
		end if
	end repeat
	return vframes
end getAllVisibleFrames

on getAllFrames()
	set nss to current application's NSScreen
	set mf to frame() of getMainScreen()
	set mfW to mf's |size|'s width
	set mfH to mf's |size|'s height
	set allframes to {main_frames:{mf}, left_frames:{}, right_frames:{}, top_frames:{}, bottom_frames:{}}
	repeat with sc in nss's screens()
		set f to convertToWindowFrame(sc's frame(), mfH)
		if f is not mf then
			set frames to {}
			set putflag to false
			if (f's origin's x) + (f's |size|'s width) ≤ 0 then
				set lf to left_frames of allframes
				set oldframes to lf
				repeat with i from 1 to lf's length
					if f's origin's x ≥ origin's x of item i of lf then
						set frames to frames & {f} & oldframes
						set putflag to true
						exit repeat
					end if
					set frames to frames & {item 1 of oldframes}
					set oldframes to rest of oldframes
				end repeat
				if not putflag then
					set frames to frames & {f}
				end if
				set left_frames of allframes to frames
			else if (f's origin's x) ≥ mfW then
				set rf to right_frames of allframes
				set oldframes to rf
				repeat with i from 1 to rf's length
					if f's origin's x ≤ origin's x of item i of rf then
						set frames to frames & {f} & oldframes
						set putflag to true
						exit repeat
					end if
					set frames to frames & {item 1 of oldframes}
					set oldframes to rest of oldframes
				end repeat
				if not putflag then
					set frames to frames & {f}
				end if
				set right_frames of allframes to frames
			else if (f's origin's y) + (f's |size|'s height) ≤ 0 then
				set tf to top_frames of allframes
				set oldframes to tf
				repeat with i from 1 to tf's length
					if f's origin's y ≤ origin's y of item i of tf then
						set frames to frames & {f} & oldframes
						set putflag to true
						exit repeat
					end if
					set frames to frames & {item 1 of oldframes}
					set oldframes to rest of oldframes
				end repeat
				if not putflag then
					set frames to frames & {f}
				end if
				set top_frames of allframes to frames
			else
				set bf to bottom_frames of allframes
				set oldframes to bf
				repeat with i from 1 to bf's length
					if f's origin's y ≥ origin's y of item i of bf then
						set frames to frames & {f} & oldframes
						set putflag to true
						exit repeat
					end if
					set frames to frames & {item 1 of oldframes}
					set oldframes to rest of oldframes
				end repeat
				if not putflag then
					set frames to frames & {f}
				end if
				set bottom_frames of allframes to frames
			end if
		end if
	end repeat
	return allframes
end getAllFrames

on run
	--getAllVisibleFrames()
	--getVisibleFrame(1, 1)
	getAllFrames()
end run
