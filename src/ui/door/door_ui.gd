extends Control

@export var column_groups: Array[ButtonGroup]

@onready var background: AnimatedSprite2D = $Background
@onready var big_button_sprite: AnimatedSprite2D = $BigButton/BigButtonSprite
@onready var animation_player: AnimationPlayer = $TransitionAnimationPlayer
@onready var vert_selector: Sprite2D = $VerticalSelector
@onready var press_sound: AudioStreamPlayer = $sfx/button_press
@onready var hover_sound: AudioStreamPlayer = $sfx/button_hover
@onready var correct_sound: AudioStreamPlayer = $sfx/correct
@onready var incorrect_sound: AudioStreamPlayer = $sfx/incorrect

var SELECTOR_DEFUALT_POS

const BUTTON_MAP = {
	"butterfly": 0,
	"knife": 1,
	"human": 2,
	"wolf": 3
}

func _ready():
	Globals.enter_door_ui.connect(_enter)
	get_viewport().connect("gui_focus_changed", _on_focus_changed)
	SELECTOR_DEFUALT_POS = vert_selector.position
	connect_button_signals()


func connect_button_signals():
	for button in $GridContainer.get_children():
		button.pressed.connect(_button_pressed)


func _enter():
	Globals.in_door_ui = true
	modulate = Color(Color.WHITE)
	background.play("default")
	big_button_sprite.play("default")
	$GridContainer/butterfly_button1.grab_focus()
	show()


func _on_big_button_pressed():
	if is_code_correct():
		correct_sound.play()
		background.play("correct")
		big_button_sprite.play("correct")
		animation_player.play("fade_to_black")
		await animation_player.animation_finished
		get_tree().change_scene_to_packed(get_parent().next_scene)
	else:
		incorrect_sound.play()
		background.play("incorrect")
		big_button_sprite.play("incorrect")
		animation_player.play("fade_to_clear")
		await animation_player.animation_finished
		hide()
		Globals.in_door_ui = false


func is_code_correct() -> bool:
	var buttons = column_groups.map(
		func(group): return group.get_pressed_button()
	)
	if false in buttons.map(func(button): return is_instance_valid(button)):
		return false
	var code = buttons.map(
		func(button): return BUTTON_MAP[button.name.get_slice("_", 0)]
	)
	if code == get_parent().door_code:
		return true
	return false


func _on_focus_changed(button: Control):
	if button.name != "BigButton":
		vert_selector.show()
		vert_selector.position.x = SELECTOR_DEFUALT_POS.x + button.position.x
	else:
		vert_selector.hide()
	hover_sound.play()

func _button_pressed():
	press_sound.play()
	
