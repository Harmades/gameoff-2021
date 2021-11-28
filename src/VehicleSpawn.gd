extends Position2D

export (PackedScene) var vehicleScene
export (int) var rot = 0

func _ready():
	spawn()

func spawn():
	var vehicle = vehicleScene.instance()
	vehicle.connect("explode", self, "dead")
	add_child(vehicle)
	vehicle.rotation_degrees = self.rot
	vehicle.init()

func dead(center, radius):
	$RespawnTimer.start()
	get_parent().get_parent().get_node("TileMap").explode(center, radius)

func _on_RespawnTimer_timeout():
	spawn()
