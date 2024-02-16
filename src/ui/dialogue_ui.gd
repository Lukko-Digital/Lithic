extends Control

@export_file var dialogue_file

@onready var label: Label = $TextBox/Label
@onready var text_timer: Timer = $TextTimer

var display_in_progress = false
var dialogue_lines
var current_line

var active_portrait: String
var portrait_map: Dictionary

const TEXT_SPEED = 0.04

func _ready():
	Globals.start_dialogue.connect(_start_dialogue)
	Globals.advance_dialogue.connect(next_line)
	init_portraits()
	print(portrait_map)


func init_portraits():
	for child in $TextBox/Portraits.get_children():
		portrait_map[child.name] = child
	active_portrait = portrait_map.keys()[0]
	portrait_map[active_portrait].show()


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
	var portrait = dialogue_lines[current_line].get_slice(": ", 0)
	var line = dialogue_lines[current_line].get_slice(": ", 1)
	if portrait != active_portrait:
		portrait_map[active_portrait].hide()
		active_portrait = portrait
		portrait_map[active_portrait].show()
	label.text = line
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
