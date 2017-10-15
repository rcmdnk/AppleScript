set scriptPath to ((path to me as text) & "::")
set windowMoveScpt to scriptPath & "windowMove.scpt"
set windowMove to load script file windowMoveScpt
windowMove's windowMove(1, 0)
