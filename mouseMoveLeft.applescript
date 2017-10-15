set scriptPath to ((path to me as text) & "::")
set mouseMoveScpt to scriptPath & "mouseMove.scpt"
set mouseMove to load script file mouseMoveScpt
mouseMove's mouseMove({mouseKey:"4"})
