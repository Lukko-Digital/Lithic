extends Node2D


func _ready():
	Globals.end_dialogue.connect(_transition)


func _transition():
	$ui.transition_scene(true)
