extends TileMap

export (int) var tileDestroyed
export (int) var tileBugged
export (int) var tileBuggedDestroyed

var bugs = 0

signal bugs_changed(value)

func _ready():
	pass

func bulletHit(bullet):
	var contactPoint = bullet.get_node("HitTile").global_position
	var cell = world_to_map(contactPoint)
	if cell.x < 1 or cell.x > 73 or cell.y < 1 or cell.y > 84:
		return
	var currentCell = get_cellv(cell)
	var newTile = tileDestroyed
	if currentCell == tileBugged:
		newTile = tileBuggedDestroyed
		set_bugs(bugs - 1)
		
	set_cellv(cell, newTile)

func set_bugs(value):
	bugs = value
	emit_signal("bugs_changed", bugs)

func _on_bug_signal(body):
	var cell = world_to_map(body.global_position)
	var currentCell = get_cellv(cell)
	var xRand = randi() % 3 - 1
	var yRand = randi() % 3 - 1
	set_cell(cell.x + xRand, cell.y + yRand, tileBugged)
	if currentCell != tileBugged:
		set_bugs(bugs + 1)

func toWorldCoord(value):
	return value / 16

func _on_Vehicle1_explode(center, radius):
	var xMin = toWorldCoord(center.x - radius)
	var xMax = toWorldCoord(center.x + radius)
	var yMin = toWorldCoord(center.y - radius)
	var yMax = toWorldCoord(center.y + radius)
	for i in range(xMin, xMax):
		for j in range(yMin, yMax):
			set_cell(i, j, tileDestroyed)
