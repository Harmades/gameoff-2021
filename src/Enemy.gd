extends KinematicBody2D

var run_speed = 50
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if player:
		velocity = position.direction_to(player.position) * run_speed
		look_at(player.position)
	velocity = move_and_slide(velocity)
	
func _on_Range_body_exited(body):
	player = null

func _on_Range_body_entered(body):
	player = body
