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
	enemy.connect("attack_signal", get_parent().get_parent(), "_on_attack_signal")
	var spawn = spawns[randi() % spawns.size()]
	enemy.position = spawn.position
	var follow = spawn.get_node("PathFollow")
	follow.add_child(enemy)
	follow.get_parent().running = true
	count = count + 1
	emit_signal("neos_changed", count)
