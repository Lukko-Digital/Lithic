extends CanvasLayer

@export var door_code: Array[int]
@export var next_scene: PackedScene

@export var start_music: bool
@export var ending_music: bool

@onready var transition_player: AnimationPlayer = $ScreenColor/AnimationPlayer

func _ready():
	transition_player.play("fade_from_black")
	handle_music()


func handle_music():
	if start_music:
		Music.start_music.emit()
	if ending_music:
		Music.ending_music.emit()

func transition_scene(hard_cut=false, ending=false):
	if not hard_cut and not ending:
		transition_player.play("fade_to_black")
		await transition_player.animation_finished
	if ending:
		transition_player.play("ending_fade_to_black")
		await transition_player.animation_finished
	Globals.in_door_ui = false
	Globals.in_dialogue = false
	get_tree().change_scene_to_packed(next_scene)
