extends Node2D

export (PackedScene) var Enemy

var spawns = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.name.begins_with("Spawn"):
			spawns.append(child)
			



func _on_Timer_timeout():
	var enemy = Enemy.instance()
	var spawn = spawns[randi() % spawns.size()]
	enemy.position = spawn.position
	owner.add_child(enemy)
