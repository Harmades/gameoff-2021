extends KinematicBody2D

export (int) var speed = 200
export (PackedScene) var Bullet

var velocity = Vector2()
var hasFocus = true

var vehicle = null
var vehicleNear = null

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
	if Input.is_action_pressed("action") && vehicleNear != null:
		$Shape.disabled = true
		$Camera.current = false
		visible = false
		hasFocus = false
		vehicle = vehicleNear
		vehicle.enter()
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
func exitVehicle(position2d: Position2D):
	vehicle.exit()
	$Shape.disabled = false
	$Camera.current = true
	visible = true
	hasFocus = true
	vehicle = null
	self.position = position2d.global_position
		
func onPlayerEnterMountArea(vehicle):
	vehicleNear = vehicle
	
func onPlayerExitMountArea(vehicle):
	vehicleNear = null
	
func _physics_process(delta):
	if hasFocus:
		look_at(get_global_mouse_position())
		get_input()
		velocity = move_and_slide(velocity)

func shoot():
	var b = Bullet.instance()
##	add_child(b)
##	b.transform = $Muzzle.transform
	owner.add_child(b)
	b.transform = $Muzzle.global_transform
	
	

