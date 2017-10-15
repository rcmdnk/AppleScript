set scriptPath to ((path to me as text) & "::")
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt
windowSize's windowSize({xsize:1, ysize:0.5})
