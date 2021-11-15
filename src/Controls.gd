extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var hasFocus = true

var nearVehicle = false
var vehicle = null

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed
	if Input.is_action_pressed("action") && nearVehicle:
		hasFocus = false
		vehicle.enter()
		visible = false
		
func exitVehicle(position2d: Position2D):
	visible = true
	hasFocus = true
	self.position = position2d.global_position
		
func triggerVehicleProximity(vehicle):
	if vehicle != null:
		nearVehicle = true
	else:
		nearVehicle = false
	self.vehicle = vehicle

func _physics_process(delta):
	if hasFocus:
		get_input()
		velocity = move_and_slide(velocity)
