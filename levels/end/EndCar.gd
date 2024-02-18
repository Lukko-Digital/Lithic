extends StaticBody2D

@export var ui: CanvasLayer

func _ready():
	Globals.end_dialogue.connect(transition_scene)

## Called when player interacts with car
func interact():
	get_parent().say(Globals.DialogueState.SOLUTION)


func transition_scene():
	ui.transition_scene(true)