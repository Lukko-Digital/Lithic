extends Control

@export_file var dialogue_file

@onready var default_font: FontFile = preload("res://assets/fonts/Early GameBoy.ttf")
@onready var old_font: FontFile = preload("res://assets/fonts/Olden Language.ttf")

@onready var label: Label = $TextBox/Label
@onready var text_timer: Timer = $TextTimer
@onready var portrait: AnimatedSprite2D = $TextBox/Portraits
@onready var audio_player: AnimationPlayer = $AudioStreamPlayer/AudioAnimationPlayer

var display_in_progress = false
var dialogue_lines
var current_line

var active_portrait: String
var portrait_map: Dictionary

const TEXT_SPEED = 0.06

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
	
	if line.left(1) == "~":
		label.add_theme_font_override("font", old_font)
		label.text = line.substr(1)
	else:
		label.add_theme_font_override("font", default_font)
		label.text = line
	
	if portrait_name == "narrator":
		label.size.x = Label_Width.NARRATOR
		label.position.x = Label_X_Pos.NARRATOR
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		label.size.x = Label_Width.DEFAULT
		label.position.x = Label_X_Pos.DEFAULT
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		
	animate_display(portrait_name)


func animate_display(portrait_name: String):
	var talking_sound
	if portrait_name == "player":
		talking_sound = "player"
	elif portrait_name == "narrator":
		talking_sound = "narrator"
	elif portrait_name.right(3) == "kid":
		talking_sound = "kid"
	else:
		talking_sound = "statue"

	label.visible_characters = 0
	display_in_progress = true
	while label.visible_characters < len(label.text):
		audio_player.stop(true)
		audio_player.play(talking_sound)
		label.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout
	display_in_progress = false


func exit_dialogue():
	hide()
	Globals.end_dialogue.emit()
	Globals.in_dialogue = false
