extends Path2D

var running = true

func _process(delta):
	if running:
		$PathFollow.set_offset($PathFollow.get_offset() + 50 * delta)


func _on_attack_signal():
	running = false
