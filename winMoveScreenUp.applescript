set scriptPath to ((path to me as text) & "::")
set windowSizeScpt to scriptPath & "windowSize.scpt"
set windowSize to load script file windowSizeScpt
windowSize's windowSize({direction:"UP", resize:0})
