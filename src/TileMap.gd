extends TileMap

export (int) var tileDestroyed

func bulletHit(bullet):
	var contactPoint = bullet.get_node("HitTile").global_position
	var cell = world_to_map(contactPoint)
	if cell.x < 1 or cell.x > 73 or cell.y < 1 or cell.y > 84:
		return
	var currentCell = get_cellv(cell)
	var newTile = tileDestroyed
	set_cellv(cell, newTile)


func toWorldCoord(value):
	return value / 16

func explode(center, radius):
	var xMin = toWorldCoord(center.x - radius)
	var xMax = toWorldCoord(center.x + radius)
	var yMin = toWorldCoord(center.y - radius)
	var yMax = toWorldCoord(center.y + radius)
	for i in range(xMin, xMax):
		for j in range(yMin, yMax):
			set_cell(i, j, tileDestroyed)
