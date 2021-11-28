extends Node2D

export (PackedScene) var Enemy

signal neos_changed(value)

var count = 0
var spawns = []
var enemies = []

func _ready():
	for child in get_children():
		if child.name.begins_with("Spawn"):
			spawns.append(child)
			enemies.append(null)
			

func _on_Timer_timeout():
	var randomIndex = randi() % spawns.size()
	var spawn = spawns[randomIndex]
	if enemies[randomIndex] != null:
		return
	var enemy = Enemy.instance()
	enemy.index = randomIndex
	enemy.connect("bug_signal", get_parent().get_node("BugLayer"), "_on_bug_signal")
	enemies[randomIndex] = enemy
	enemy.position = spawn.position
	var follow = spawn.get_node("PathFollow")
	follow.add_child(enemy)
	follow.get_parent().running = true
	follow.offset = 0
	count = count + 1
	emit_signal("neos_changed", count)
	
func clearIndex(index):
	enemies[index] = null
