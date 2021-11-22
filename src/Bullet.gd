extends Area2D

export var speed = 300


func _physics_process(delta):
	position += transform.x * speed * delta
	pass;

func _on_Bullet_body_entered(body):
	queue_free()
	body.bulletHit(self)
