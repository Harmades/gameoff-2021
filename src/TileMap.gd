extends TileMap

export (int) var tileDestroyed

func _ready():
	pass

func bulletHit(bullet):
	var contactPoint = bullet.get_node("HitTile").global_position
	var cell = world_to_map(contactPoint)
	set_cellv(cell, tileDestroyed)
