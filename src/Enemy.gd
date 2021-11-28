extends KinematicBody2D

signal bug_signal(body)

export (PackedScene) var Bullet

export (int) var randomMovementRange = 64

var index = null
var nextPos = null
enum State { Idle, Attack, Dead }
var state = State.Idle
var run_speed = 50
var velocity = Vector2.ZERO
var player = null

func _physics_process(delta):
	velocity = Vector2.ZERO
	if state == State.Attack:
		if nextPos == null:
			chooseNextPos()
		elif position.x - nextPos.x < 0.5 and position.y - nextPos.y < 0.5:
			chooseNextPos()
		velocity = position.direction_to(self.nextPos) * run_speed
		look_at(player.position)
	var collision = move_and_collide(velocity, true, true, true)
	if collision != null:
		chooseNextPos()
	velocity = move_and_slide(velocity)
	
func chooseNextPos():
	var xRand = self.position.x + randomMovementRange * rand_range(-1, 1)
	var yRand = self.position.y + randomMovementRange * rand_range(-1, 1)
	self.nextPos = Vector2(xRand, yRand)
	
#func _on_Range_body_exited(body):
#	player = null
#	state = State.Idle
#	$ShootTimer.stop()

func _on_Range_body_entered(body):
	player = body
	state = State.Attack
	get_parent().get_parent().running = false
#	$ShootTimer.start()

func shoot():
	var b = Bullet.instance()
	get_parent().add_child(b)
	b.position = $Muzzle.global_position
	b.look_at(player.global_position)

func _on_ShootTimer_timeout():
	shoot()

func bulletHit(bullet):
	die()

func die():
	if self.state == State.Dead:
		return
	$DeadSprite.visible = true
	$Sprite.visible = false
	self.state = State.Dead
	$Shape.set_deferred("disabled", true)
	$Range.monitoring = false
	$BugTimer.stop()
	var transform = self.global_transform
	var enemiesNode = get_parent().get_parent().get_parent()
	enemiesNode.clearIndex(self.index)
	get_parent().remove_child(self)
	var firstNode = enemiesNode.get_child(0)
	enemiesNode.add_child_below_node(firstNode, self)
	self.global_transform = transform
	

func _on_BugTimer_timeout():
	emit_signal("bug_signal", self)
