property DEBUG : true
property LOG_DIR : "~/log/"
property LOG_FILE : ""

-- Prepare log file
if DEBUG then
	do shell script "mkdir -p " & LOG_DIR
	set LOG_FILE to LOG_DIR & (name of me) & ".log"
	log "Log file: " & LOG_FILE
end if

-- Log output function
on echo(txt)
	if DEBUG then
		do shell script "echo '[" & (current date) & "] " & txt & "' >> " & LOG_FILE
		log "[" & (current date) & "] " & txt
	end if
end echo

-- Test log
echo("test output")
