extends Control

@onready var selectors = $selectors.get_children()

const DEFAULT_Y = 56
const ICON_DIST = 20
var selector_position = [0, 0, 0, 0]
var active_selector = 0 : set = _set_active_selector


func _set_active_selector(new_selector):
	# Release previous selector
	if active_selector != 4:
		selectors[active_selector].play("default")
	else:
		$Enter.release_focus()
		$Exit.release_focus()

	active_selector = clamp(new_selector, 0, 4)
	
	# Activate new Selector
	if active_selector != 4:
		selectors[active_selector].play("active")
	else:
		$Enter.grab_focus()


func _ready():
	Globals.enter_door_ui.connect(_enter)


func _enter():
	Globals.in_door_ui = true
	active_selector = 0
	show()


func move_selector(dir: int):
	if active_selector == 4:
		return
	var new_pos = clamp(selector_position[active_selector] + dir, 0, 3)
	selector_position[active_selector] = new_pos
	selectors[active_selector].position.y = DEFAULT_Y + new_pos * ICON_DIST


func _unhandled_input(event):
	if not Globals.in_door_ui:
		return
	if event.is_action_pressed("left"):
		active_selector -= 1
	elif event.is_action_pressed("right"):
		active_selector += 1
	elif event.is_action_pressed("up"):
		move_selector(-1)
	elif event.is_action_pressed("down"):
		move_selector(1)


func _on_enter_pressed():
	if selector_position == get_parent().door_code:
		print("correct")
	else:
		print("incorrect")


func _on_exit_pressed():
	Globals.in_door_ui = false
	hide()
