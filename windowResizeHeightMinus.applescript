set scriptPath to ((path to me as text) & "::")
set windowResizeScpt to scriptPath & "windowResize.scpt"
set windowResize to load script file windowResizeScpt
windowResize's windowResize(0, -1)
