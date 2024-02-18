extends CharacterBody2D


const SPEED = 40.0

@onready var ray: RayCast2D = $RayCast2D
@onready var audio_player: AnimationPlayer = $AudioStreamPlayer/AudioAnimationPlayer
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var interact_prompt: AnimatedSprite2D = $CanvasLayer/InteractPrompt

func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()

	handle_animation(direction)
	velocity = direction * SPEED
	move_and_slide()

	if !direction.is_zero_approx():
		ray.target_position = direction * 30

	handle_interact_prompt()

func handle_animation(direction: Vector2):
	match direction.round():
		Vector2():
			if "idle_" not in sprite.animation:
				sprite.play("idle_" + sprite.animation)
		Vector2(1,-1), Vector2(1,0), Vector2(1,1):
			# right
			sprite.play("right")
			sprite.flip_h = false
		Vector2(-1,-1), Vector2(-1,0), Vector2(-1,1):
			# left
			sprite.play("right")
			sprite.flip_h = true
		Vector2(0,-1):
			# up
			sprite.play("up")
		Vector2(0,1):
			# down
			sprite.play("down")


func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		handle_interact()


func handle_interact():
	if Globals.in_dialogue:
		Globals.advance_dialogue.emit()
		return
	
	ray.force_raycast_update()
	if !ray.is_colliding():
		return
	
	var colliding = ray.get_collider()
	if colliding.is_in_group("statue"):
		colliding.interact()


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
	elif colliding.is_in_group("statue"):
		return true
	
	return false