extends Control

func _process(delta):
	if Input.is_action_just_pressed("action"):
		get_tree().change_scene("res://Node2D.tscn")
