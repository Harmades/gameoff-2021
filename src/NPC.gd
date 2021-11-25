extends KinematicBody2D

export (PackedScene) var Bullet

var run_speed = 50
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity = Vector2.ZERO
	
func bulletHit(bullet):
	die()

func die():
	$Animation.animation = "dead"
	$Shape.set_deferred("disabled", true)
	get_parent().get_parent().running = false
