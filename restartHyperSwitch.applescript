set scriptPath to ((path to me as text) & "::")
set restartAppScpt to scriptPath & "restartApp.scpt"
set restartApp to load script file restartAppScpt
restartApp's restartApp({appName:"HyperSwitch", dir:"/Applications/"})
