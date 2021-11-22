extends KinematicBody2D

export (PackedScene) var Bullet

enum State { Idle, Attack, Dead }
var state = State.Idle
var run_speed = 50
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if state == State.Attack:
		velocity = position.direction_to(player.position) * run_speed
		look_at(player.position)
#	velocity = move_and_slide(velocity)
	
func _on_Range_body_exited(body):
	player = null
	state = State.Idle
#	$ShootTimer.stop()

func _on_Range_body_entered(body):
	player = body
	state = State.Attack
#	$ShootTimer.start()

func shoot():
	var b = Bullet.instance()
	get_parent().add_child(b)
	b.position = $Muzzle.global_position
	b.look_at(player.global_position)

func _on_ShootTimer_timeout():
	shoot() # Replace with function body.

func bulletHit(bullet):
	die()

func die():
	$DeadSprite.visible = true
	$Sprite.visible = false
	self.state = State.Dead
	$Shape.set_deferred("disabled", true)
	$Range.monitoring = false
