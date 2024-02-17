extends Control

@export var column_groups: Array[ButtonGroup]

@onready var background: AnimatedSprite2D = $Background
@onready var big_button_sprite: AnimatedSprite2D = $BigButton/BigButtonSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal correct_code
signal incorrect_code

const BUTTON_MAP = {
	"butterfly": 0,
	"knife": 1,
	"human": 2,
	"wolf": 3
}

func _ready():
	Globals.enter_door_ui.connect(_enter)


func _enter():
	Globals.in_door_ui = true
	modulate = Color(Color.WHITE)
	background.play("default")
	big_button_sprite.play("default")
	$GridContainer/butterfly_button1.grab_focus()
	show()


func _on_big_button_pressed():
	if is_code_correct():
		background.play("correct")
		big_button_sprite.play("correct")
	else:
		background.play("incorrect")
		big_button_sprite.play("incorrect")
	animation_player.play("fade")
	await animation_player.animation_finished
	hide()
	Globals.in_door_ui = false


func is_code_correct() -> bool:
	var buttons = column_groups.map(
		func(group): return group.get_pressed_button()
	)
	if $_NULL in buttons:
		return false
	var code = buttons.map(
		func(button): return BUTTON_MAP[button.name.get_slice("_", 0)]
	)
	if code == get_parent().door_code:
		return true
	return false
