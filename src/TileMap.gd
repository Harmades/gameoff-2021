extends TileMap

export (int) var tileDestroyed

export (PackedScene) var explosionScene

func bulletHit(bullet):
	var contactPoint = bullet.get_node("HitTile").global_position
	var cell = world_to_map(contactPoint)
	if cell.x < 1 or cell.x > 73 or cell.y < 1 or cell.y > 84:
		return
	var currentCell = get_cellv(cell)
	var newTile = tileDestroyed
	explodeTile(Vector2(cell.x * 16, cell.y * 16))
#	set_cellv(cell, newTile)


func toWorldCoord(value):
	return value / 16
	
func explodeTile(pos):
	var explosion = explosionScene.instance()
	explosion.connect("animation_finished", self, "setDestroyed", [ pos ])
	get_parent().add_child(explosion)
	explosion.global_position = pos
	
func setDestroyed(pos):
	set_cellv(world_to_map(pos), tileDestroyed)

func explode(center, radius):
	var xMin = max(toWorldCoord(center.x - radius), 1)
	var xMax = min(toWorldCoord(center.x + radius), 73)
	var yMin = max(toWorldCoord(center.y - radius), 1)
	var yMax = min(toWorldCoord(center.y + radius), 84)
	for i in range(xMin, xMax):
		for j in range(yMin, yMax):
			explodeTile(Vector2(i * 16, j * 16))
#			set_cell(i, j, tileDestroyed)
