extends Path2D

export (bool) var running = false
var speed = 30

func _process(delta):
	if running:
		$PathFollow.set_offset($PathFollow.get_offset() + speed * delta)

func _on_attack_signal():
	running = false

func reset():
	$PathFollow.set_offset(0)
	running = true
