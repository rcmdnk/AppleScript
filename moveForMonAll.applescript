set scriptPath to ((path to me as text) & "::")
set moveForMonScpt to scriptPath & "moveForMon.scpt"
set moveformon to load script file moveForMonScpt
moveformon's moveformon({all:true})
