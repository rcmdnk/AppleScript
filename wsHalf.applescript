set scriptPath to ((path to me as text) & "::")
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt
windowSize's windowSize({xsize:0.5, ysize:1.0, xpos:0.25, ypos: 0})
