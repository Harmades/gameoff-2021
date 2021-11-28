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
	$RespawnTimer.start()


func _on_RespawnTimer_timeout():
	$Animation.animation = "run"
	$Shape.set_deferred("disabled", false)
	get_parent().get_parent().reset()
