extends AnimatedSprite

func _ready():
	self.frame = 0
	pass;

func _on_Explosion_animation_finished():
	queue_free()
