extends Control

@export_file var dialogue_file

@onready var label: Label = $Label
@onready var text_timer: Timer = $TextTimer

var game_script

const TEXT_SPEED = 0.04

func animate_display():
	label.visible_characters = 0
	while label.visible_characters < len(label.text):
		label.visible_characters += 1
		text_timer.start(TEXT_SPEED)
		await text_timer.timeout
