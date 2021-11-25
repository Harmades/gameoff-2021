extends TileMap

export (int) var tileDestroyed

export (int) var tileBugged

export (int) var tileBuggedDestroyed


func _ready():
	pass

func bulletHit(bullet):
	var contactPoint = bullet.get_node("HitTile").global_position
	var cell = world_to_map(contactPoint)
	var currentCell = get_cellv(cell)
	var newTile = tileDestroyed
	if currentCell == tileBugged:
		newTile = tileBuggedDestroyed
	set_cellv(cell, newTile)


func _on_bug_signal(body):
	var cell = world_to_map(body.global_position)
	var xRand = randi() % 3 - 1
	var yRand = randi() % 3 - 1
	set_cell(cell.x + xRand, cell.y + yRand, tileBugged)
