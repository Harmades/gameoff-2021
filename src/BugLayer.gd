extends TileMap

export (int) var tileBugged
export (int) var tileBuggedDestroyed

signal bugs_changed(value)
var bugs = 0

func bulletHit(bullet):
	var contactPoint = bullet.get_node("HitTile").global_position
	var cell = world_to_map(contactPoint)
	var currentCell = get_cellv(cell)
	if currentCell == tileBugged:
		var newTile = tileBuggedDestroyed
		set_bugs(bugs - 1)
		set_cellv(cell, newTile)
	
func _on_bug_signal(body):
	var cell = world_to_map(body.global_position)
	var currentCell = get_cellv(cell)
	var xRand = randi() % 3 - 1
	var yRand = randi() % 3 - 1
	set_cell(cell.x + xRand, cell.y + yRand, tileBugged)
	if currentCell != tileBugged:
		set_bugs(bugs + 1)

func set_bugs(value):
	bugs = value
	emit_signal("bugs_changed", bugs)
