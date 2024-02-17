extends Area2D

@export var no_interact_prompt: bool
@export var disable_movement: bool

var INPUTS = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

@onready var ray: RayCast2D = $RayCast2D
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var interact_prompt: AnimatedSprite2D = $CanvasLayer/InteractPrompt
@onready var audio_player: AnimationPlayer = $AudioStreamPlayer/AudioAnimationPlayer


func _ready():
	$CanvasLayer.visible = !no_interact_prompt


func move(dir):
	if Globals.in_dialogue or Globals.in_door_ui or disable_movement:
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
		if colliding.is_in_group("statue") and not colliding.is_in_group("sign"):
			if colliding.move(INPUTS[dir]):
				audio_player.play("push")
			else:
				audio_player.play("fail_push")
		else:
			audio_player.play("bump_wall")
		match dir:
			"up", "down":
				sprite.play("%s_push" % dir)
				await sprite.animation_finished
				sprite.play(dir)
			"left":
				sprite.flip_h = true
				sprite.play("right_push")
				await sprite.animation_finished
				sprite.play("right")
			"right":
				sprite.flip_h = false
				sprite.play("%s_push" % dir)
				await sprite.animation_finished
				sprite.play(dir)


func _process(delta):
	handle_interact_prompt()


func handle_interact_prompt():
	if facing_interactable():
		interact_prompt.show()
		interact_prompt.play("default")
	else:
		interact_prompt.hide()
		interact_prompt.stop()


func facing_interactable():
	if Globals.in_dialogue or Globals.in_door_ui:
		return false

	var colliding = ray.get_collider()
	if !is_instance_valid(colliding):
		return false
	elif colliding.is_in_group("statue") or colliding.is_in_group("door"):
		return true
	
	return false


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
