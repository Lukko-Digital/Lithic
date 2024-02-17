extends CanvasLayer

@export var door_code: Array[int]
@export var next_scene: PackedScene

@onready var color_animation: AnimationPlayer = $ScreenColor/ColorAnimationPlayer

func _on_door_ui_correct_code():
	color_animation.play("white")
	await color_animation.animation_finished
	get_tree().change_scene_to_packed(next_scene)


func _on_door_ui_incorrect_code():
	color_animation.play("red")
