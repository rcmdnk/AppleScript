set scriptPath to ((path to me as text) & "::")
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt
windowSize's windowSize({xsize:0.7, ysize:0.7})
