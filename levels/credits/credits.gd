extends Control


func _ready():
	await get_tree().create_timer(7).timeout
	$ui.transition_scene(false, true)
