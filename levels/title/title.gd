extends Control


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		$Logo.play("fade")
		Music.stop_music.emit()
		$ui.transition_scene(true)
