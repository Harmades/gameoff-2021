extends Camera2D

var bugs = 0

func _on_Enemies_neos_changed(value):
	$RedPill.get_node("NeosCount").text = str(value)

func _on_BugLayer_bugs_changed(value):
	bugs = value
	$BluePill.get_node("MatrixHealth").text = str(bugs)
