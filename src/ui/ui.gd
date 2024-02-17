extends CanvasLayer

@export var door_code: Array[int]
@export var next_scene: PackedScene

@onready var transition_player: AnimationPlayer = $ScreenColor/AnimationPlayer

func _ready():
	transition_player.play("fade_from_black")


func transition_scene(hard_cut=false):
	if not hard_cut:
		transition_player.play("fade_to_black")
		await transition_player.animation_finished
	Globals.in_door_ui = false
	Globals.in_dialogue = false
	get_tree().change_scene_to_packed(next_scene)
