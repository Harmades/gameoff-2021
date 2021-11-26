extends Camera2D

var bugs = 0

func _ready():
	pass # Replace with function body.


func _on_TileMap_bugs_changed(value):
	bugs = value
	$MatrixHealth.text = str(bugs)


func _on_Enemies_neos_changed(value):
	$NeosCount.text = str(value)
