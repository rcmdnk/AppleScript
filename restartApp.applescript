property DEF_APP_NAME : "HyperSwitch"
property DEF_DIR : "/Applications"

on restartApp(pars)
	
	set {appName, dir} to {DEF_APP_NAME, DEF_DIR}
	try
		set appName to appName of pars
	end try
	try
		set dir to dir of pars
	end try
	
	if application appName is running then
		tell application appName to quit
		repeat while application appName is running
			delay 0.1
		end repeat
	end if
	
	tell application (dir & "/" & appName & ".app")
		activate
	end tell
end restartApp

on run
	restartApp({})
end run
