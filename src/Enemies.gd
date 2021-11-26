extends Node2D

export (PackedScene) var Enemy

signal neos_changed(value)

var count = 0
var spawns = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child.name.begins_with("Spawn"):
			spawns.append(child)
			

func _on_Timer_timeout():
	var enemy = Enemy.instance()
	enemy.connect("bug_signal", get_parent().get_node("TileMap"), "_on_bug_signal")
	var spawn = spawns[randi() % spawns.size()]
	enemy.position = spawn.position
	add_child(enemy)
	count = count + 1
	emit_signal("neos_changed", count)
