extends Node2D

@export var next_scene: PackedScene

func _ready():
	Globals.end_dialogue.connect(_transition)

func _transition():
	get_tree().change_scene_to_packed(next_scene)
