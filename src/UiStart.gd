extends Control

func _process(delta):
	if Input.is_action_just_pressed("action"):
		get_tree().change_scene("res://Node2D.tscn")


func _on_LinkButton_pressed():
	OS.shell_open("https://twitter.com/intent/tweet?hashtags=GrandMatrixReloaded%2CGitHubGameOff&original_referer=https%3A%2F%2Fpublish.twitter.com%2F&ref_src=twsrc%5Etfw%7Ctwcamp%5Ebuttonembed%7Ctwterm%5Ehashtag%7Ctwgr%5ELoveTwitter&text=I%20eliminated%20all%20neos%20and%20debugged%20the%20Matrix!&url=https%3A%2F%2Ffennelle.itch.io%2Fgrand-matrix-reloaded")
