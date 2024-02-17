extends Control

@export var column_groups: Array[ButtonGroup]

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
	$GridContainer/butterfly_button1.grab_focus()


func _enter():
	Globals.in_door_ui = true
	show()


func _on_big_button_pressed():
	print(is_code_correct())


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
