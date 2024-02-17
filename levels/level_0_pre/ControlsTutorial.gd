extends Sprite2D


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		hide()
