extends Control

@export_file var dialogue_file

@onready var label: Label = $TextBox/Label
@onready var text_timer: Timer = $TextTimer
@onready var portrait: AnimatedSprite2D = $TextBox/Portraits

var display_in_progress = false
var dialogue_lines
var current_line

var active_portrait: String
var portrait_map: Dictionary

const TEXT_SPEED = 0.04

const Label_Width = {
	DEFAULT = 214,
	NARRATOR = 266
}

const Label_X_Pos = {
	DEFAULT = 64,
	NARRATOR = 12
}

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
			show_line()


func show_line():
	var portrait_name = dialogue_lines[current_line].get_slice(": ", 0)
	var line = dialogue_lines[current_line].get_slice(": ", 1)
	portrait.play(portrait_name)
	label.text = line
	
	if portrait_name == "narrator":
		label.size.x = Label_Width.NARRATOR
		label.position.x = Label_X_Pos.NARRATOR
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		label.size.x = Label_Width.DEFAULT
		label.position.x = Label_X_Pos.DEFAULT
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
	animate_display()


func animate_display():
	label.visible_characters = 0
	display_in_progress = true
	while label.visible_characters < len(label.text):
		label.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout
	display_in_progress = false


func exit_dialogue():
	hide()
	Globals.end_dialogue.emit()
	Globals.in_dialogue = false
