extends Control

@onready var selectors = [
	$selector0,
	$selector1,
	$selector2,
	$selector3,
]

const DEFAULT_Y = 56
const ICON_DIST = 20
var selector_position = [0, 0, 0, 0]
var active_selector = 0 : set = _set_active_selector


func _set_active_selector(new_selector):
	active_selector = clamp(new_selector, 0, 3)


func move_selector(dir: int):
	var new_pos = clamp(selector_position[active_selector] + dir, 0, 3)
	selector_position[active_selector] = new_pos
	selectors[active_selector].position.y = DEFAULT_Y + new_pos * ICON_DIST


func _unhandled_input(event):
	if event.is_action_pressed("left"):
		active_selector -= 1
	elif event.is_action_pressed("right"):
		active_selector += 1
	elif event.is_action_pressed("up"):
		move_selector(-1)
	elif event.is_action_pressed("down"):
		move_selector(1)
