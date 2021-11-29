 extends KinematicBody2D

var player = null
var city = null
var hasFocus = false

signal explode(center, radius)

enum State { Alive, Dead }
var state = State.Alive

var currentDeathCounter = 0

export var burningMaxCounter = 5
export var wheel_base = 6
export var steering_angle = 8
export var engine_power = 100
export var friction = -0.9
export var drag = -0.001
export var braking = -450
export var max_speed_reverse = 50
export var slip_speed = 400
export var traction_fast = 0.1
export var traction_slow = 0.7
export var minSpeed = 0.5
var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_direction

func init():
	player = get_parent().get_parent().get_parent().get_node("Player")
	city = get_parent()

func _physics_process(delta):
	if !hasFocus: return
	player.global_position = $LeavePosition.global_position
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func apply_friction():
	if velocity.length() < minSpeed:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force
	
	
func get_input():
	var turn = 0
	if Input.is_action_pressed("right"):
		turn += 1
	if Input.is_action_pressed("left"):
		turn -= 1
	steer_direction = turn * deg2rad(steering_angle)
	if Input.is_action_pressed("up"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("down"):
		acceleration = transform.x * braking
	if Input.is_action_just_pressed("action"):
		player.exitVehicle($LeavePosition)
		set_deferred("hasFocus", false)
		
func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()

func enter():
	set_deferred("hasFocus", true)
	var remoteNode = player.get_node("CameraRemoteTransform")
	player.remove_child(remoteNode)
	add_child(remoteNode)
	remoteNode.remote_path = "../../../../Camera"
	
func exit():
	set_deferred("hasFocus", false)
	var remoteNode = get_node("CameraRemoteTransform")
	remove_child(remoteNode)
	player.add_child(remoteNode)
	remoteNode.remote_path = "../../Camera"
	turnOff()
	
func bulletHit(bullet):
	if self.state == State.Dead:
		return
	self.state = State.Dead
	$FireSprite.visible = true
	$DeathCounter.start()
	$DeathCounterLabel.visible = true
	$DeathCounterLabel.text = str(self.burningMaxCounter)
	
func turnOff():
	velocity = Vector2.ZERO
	acceleration = Vector2.ZERO
	
func onPlayerEnterMountArea(body):
	player.onPlayerEnterMountArea(self)

func onPlayerExitMountArea(body):
	player.onPlayerExitMountArea(self)

func _on_DeathArea_body_entered(body):
	if hasFocus:
		body.die()

func _on_DeathCounter_timeout():
	currentDeathCounter = currentDeathCounter + 1
	if currentDeathCounter == self.burningMaxCounter:
		if hasFocus:
			exit()
			player.die()
		$DeathCounterLabel.visible = false
		emit_signal("explode", self.global_position, $ExplodeArea.get_node("Shape").shape.radius)
		queue_free()
	else:
		$DeathCounterLabel.text = str(self.burningMaxCounter - currentDeathCounter)
