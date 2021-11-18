extends KinematicBody2D

export (NodePath) var playerPath = null
var player = null
var city = null
var hasFocus = false

var wheel_base = 70
var steering_angle = 15
var engine_power = 800
var friction = -0.9
var drag = -0.001
var braking = -450
var max_speed_reverse = 250
var slip_speed = 400
var traction_fast = 0.1
var traction_slow = 0.7
var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var steer_direction

func _ready():
	player = get_node(playerPath)
	city = get_parent()

func _physics_process(delta):
	if !hasFocus: return
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
	velocity = move_and_slide(velocity)

func apply_friction():
	if velocity.length() < 5:
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
	if Input.is_action_pressed("action_leave"):
		player.exitVehicle($LeavePosition)
		hasFocus = false
		
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
	hasFocus = true
	$Camera.current = true
	
func exit():
	hasFocus = false
	$Camera.current = false
	player.remove_child(self)
	city.add_child(self)
	
func onPlayerEnterMountArea(body):
	player.onPlayerEnterMountArea(self)

func onPlayerExitMountArea(body):
	player.onPlayerExitMountArea(self)
