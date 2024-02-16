extends Control

@export_file var dialogue_file

@onready var label: Label = $TextBox/Label
@onready var text_timer: Timer = $TextTimer

var display_in_progress = false
var dialogue_lines
var current_line

const TEXT_SPEED = 0.04

func _ready():
	Globals.start_dialogue.connect(_start_dialogue)
	Globals.advance_dialogue.connect(next_line)


func _start_dialogue(lines):
	Globals.in_dialogue = true
	dialogue_lines = lines
	current_line = -1
	show()
	next_line()


func next_line():
	if display_in_progress:
		display_in_progress = false
		label.visible_characters = len(label.text)
	else:
		current_line += 1
		if current_line >= len(dialogue_lines):
			exit_dialogue()
		else:
			label.text = dialogue_lines[current_line]


func animate_display():
	label.visible_characters = 0
	while label.visible_characters < len(label.text):
		label.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout


func exit_dialogue():
	hide()
	Globals.end_dialogue.emit()
	Globals.in_dialogue = false
