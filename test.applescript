property DEF_XSIZE : 1
property DEF_YSIZE : 1
property DEF_XPOS : 0
property DEF_YPOS : 0

property DEF_LEFT_MARGIN : 10
property DEF_RIGHT_MARGIN : 10
property DEF_TOP_MARGIN : 10
property DEF_BOTTOM_MARGIN : 10

property DEF_APPNAME : ""
property DEF_WINDOWNUMBER : ""
property DEF_MONPOSX : ""
property DEF_MONPOSY : ""
property DEF_RESIZE : 1

property DEF_MOVEFORMON_FLAG : true
property DEF_DEBUG_LEVEL : 1

property GEEKTOOL_WINDOW : 1
property GEEKTOOL_MARGIN : 10

-- Window size main function
on windowSize(pars)
	-- Set Parameters
	set {xsize, ysize, xpos, ypos, leftmargin, rightmargin, topmargin, bottommargin, appName, windowNumber, monPosX, monPosY, resize, moveformon_flag, debug_level} to {DEF_XSIZE, DEF_YSIZE, DEF_XPOS, DEF_YPOS, DEF_LEFT_MARGIN, DEF_RIGHT_MARGIN, DEF_TOP_MARGIN, DEF_BOTTOM_MARGIN, DEF_APPNAME, DEF_WINDOWNUMBER, DEF_MONPOSX, DEF_MONPOSY, DEF_RESIZE, DEF_MOVEFORMON_FLAG, DEF_DEBUG_LEVEL}
	try
		set xsize to xsize of pars
	end try
	try
		set ysize to ysize of pars
	end try
	try
		set xpos to xpos of pars
	end try
	try
		set ypos to ypos of pars
	end try
	try
		set leftmargin to leftmargin of pars
	end try
	try
		set rightmargin to rightmargin of pars
	end try
	try
		set topmargin to topmargin of pars
	end try
	try
		set bottommargin to bottommargin of pars
	end try
	try
		set appName to appName of pars
	end try
	try
		set windowNumber to windowNumber of pars
	end try
	try
		set monPosX to monPosX of pars
	end try
	try
		set monPosY to monPosY of pars
	end try
	try
		set resize to resize of pars
	end try
	try
		set moveformon_flag to moveformon_flag of pars
	end try
	try
		set debug_level to debug_level of pars
	end try
	
	-- Debug mode
	if debug_level > 0 then
		log "debug mode = " & debug_level
		if debug_level > 1 then
			display dialog "debug mode = " & debug_level
		end if
	end if
	
	-- Get application name and window number, if appName is "", if windowNumber is not set, set 1
	if appName is "" then
		tell application "System Events"
			set pList to name of every process whose frontmost is true
			set appName to item 1 of pList
		end tell
	end if
	if windowNumber is "" then
		set windowNumber to 1
	end if
	
	if debug_level > 0 then
		log "windowSize(" & xsize & ", " & ysize & ", " & xpos & ", " & ypos & ", " & leftmargin & ", " & rightmargin & ", " & topmargin & ", " & bottommargin & ", " & appName & ", " & windowNumber & ", " & monPosX & ", " & monPosY & "," & resize & "," & moveformon_flag & "," & debug_level & ")"
		if debug_level > 5 then
			display dialog "windowSize(" & xsize & ", " & ysize & ", " & xpos & ", " & ypos & ", " & leftmargin & ", " & rightmargin & ", " & topmargin & ", " & bottommargin & ", " & appName & ", " & windowNumber & ", " & monPosX & ", " & monPosY & "," & resize & "," & moveformon_flag & "," & debug_level & ")"
		end if
	end if
	
	tell application "Finder"
		set scriptPath to (path to me)'s folder as text
	end tell
	
	-- First, move monitor
	if moveformon_flag then
		set moveForMonScpt to scriptPath & "moveForMon.scpt"
		set moveformon to load script file moveForMonScpt
		moveformon's moveformon({all:false})
	end if
end windowSize

on run
	windowSize({})
end run
