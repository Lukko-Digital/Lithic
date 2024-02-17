extends Area2D

var INPUTS = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

@onready var ray: RayCast2D = $RayCast2D
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var interact_prompt: CanvasLayer = $InteractPrompt

func move(dir):
	if Globals.in_dialogue or Globals.in_door_ui:
		return
	ray.target_position = INPUTS[dir] * Globals.TILE_SIZE
	ray.force_raycast_update()

	if !ray.is_colliding():
		position += INPUTS[dir] * Globals.TILE_SIZE
		match dir:
			"up", "down":
				sprite.play(dir)
			"left":
				sprite.flip_h = true
				sprite.play("right")
			"right":
				sprite.flip_h = false
				sprite.play(dir)
	else:
		var colliding = ray.get_collider()
		if colliding.is_in_group("statue"):
			colliding.move(INPUTS[dir])
		match dir:
			"up", "down":
				sprite.play("%s_push" % dir)
			"left":
				sprite.flip_h = true
				sprite.play("right_push")
			"right":
				sprite.flip_h = false
				sprite.play("%s_push" % dir)


func _ready():
	position = position.snapped(Vector2.ONE * Globals.TILE_SIZE)
	position += Vector2.ONE * Globals.TILE_SIZE/2


func _process(delta):
	handle_interact_prompt()


func handle_interact_prompt():
	if Globals.in_dialogue or Globals.in_door_ui:
		interact_prompt.hide()
		return
	var colliding = ray.get_collider()
	if !is_instance_valid(colliding):
		interact_prompt.hide()
	elif colliding.is_in_group("statue") or colliding.is_in_group("door"):
		interact_prompt.show()
	else:
		interact_prompt.hide()


func _unhandled_input(event):
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			move(dir)
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("interact"):
		if Globals.in_dialogue:
			Globals.advance_dialogue.emit()
			return
		
		ray.force_raycast_update()
		if !ray.is_colliding():
			return
		
		var colliding = ray.get_collider()
		if colliding.is_in_group("statue"):
			colliding.interact()
		elif colliding.is_in_group("door") and not Globals.in_door_ui:
			Globals.enter_door_ui.emit()
