extends Control


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		$Logo.play("fade")
		$ui.transition_scene(true)
