extends Node2D

export (PackedScene) var Enemy

signal neos_changed(value)

var enemies = []
var alive = 0

func _ready():
	var i = 0
	for child in get_children():
		if child.name.begins_with("Spawn"):
			var enemy = Enemy.instance()
			enemy.index = i
			enemy.connect("bug_signal", get_parent().get_node("BugLayer"), "_on_bug_signal")
			enemies.append(enemy)
			enemy.position = child.position
			var follow = child.get_node("PathFollow")
			follow.add_child(enemy)
			follow.get_parent().running = true
			follow.offset = 0
			i = i + 1
			alive = alive + 1
	emit_signal("neos_changed", alive)
	
func clearIndex(index):
	alive = alive - 1
	emit_signal("neos_changed", alive)
	if alive == 0:
		get_parent().get_node("WinTimer").start()
		get_parent().get_node("Camera/WinLabel").visible = true

func _on_Player_dead():
	for enemy in enemies:
		enemy.reset()


func _on_WinTimer_timeout():
	get_tree().change_scene("res://UIEnd.tscn")
