extends KinematicBody2D

export (int) var speed = 200
export (PackedScene) var Bullet

signal dead

var canMove = true
var velocity = Vector2()
var hasFocus = true

var vehicle = null
var vehicleNear = null

var canShoot = true

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
	if velocity == Vector2.ZERO:
		idle()
	else:
		run()
	if Input.is_action_just_pressed("action") && vehicleNear != null:
		$Shape.disabled = true
		visible = false
		set_deferred("hasFocus", false)
		vehicle = vehicleNear
		vehicle.enter()
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
func exitVehicle(position2d: Position2D):
	vehicle.exit()
	$Shape.disabled = false
	visible = true
	set_deferred("hasFocus", true)
	vehicle = null
	self.position = position2d.global_position
		
func onPlayerEnterMountArea(vehicle):
	vehicleNear = vehicle
	
func onPlayerExitMountArea(vehicle):
	vehicleNear = null
	
func _physics_process(delta):
	if hasFocus && canMove:
		look_at(get_global_mouse_position())
		get_input()
		velocity = move_and_slide(velocity)

func shoot():
	if !canShoot:
		return
	canShoot = false
	var b = Bullet.instance()
	owner.add_child(b)
	b.position = $Muzzle.global_position
	b.rotation = $Muzzle.global_rotation
	$FireRate.start()

func idle():
	if $Animation.animation != "idle":
		$Animation.play("idle")

func run():
	if $Animation.animation != "run":
		$Animation.play("run")
		
func bulletHit(bullet):
	die()

func die():
	$RespawnTimer.start()
	get_parent().get_node("Camera/DeathLabel").visible = true
	$Animation.animation = "death"
	canMove = false
	emit_signal("dead")

func _on_FireRate_timeout():
	canShoot = true

func _on_RespawnTimer_timeout():
	$Shape.disabled = false
	get_parent().get_node("Camera/DeathLabel").visible = false
	canMove = true
	visible = true
	set_deferred("hasFocus", true)
	vehicle = null
	self.global_transform = get_parent().get_node("Respawn").global_transform
