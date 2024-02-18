extends CharacterBody2D


const SPEED = 300.0

@onready var ray: RayCast2D = $RayCast2D
@onready var audio_player: AnimationPlayer = $AudioStreamPlayer/AudioAnimationPlayer
@onready var sprite: AnimatedSprite2D = 

func _physics_process(delta):
	var direction = Vector2(
		Input.get_axis("left", "right"), Input.get_axis("up", "down")
	).normalized()
	handle_animation(direction)
	velocity = direction * SPEED
	move_and_slide()

	if !direction.is_zero_approx():
		ray.target_position = direction * 30

func handle_animation(direction: Vector2):
	match direction.round():
		Vector2():
			animation_player.play("idle")
		Vector2(1,-1), Vector2(1,0), Vector2(1,1):
			# right
			animation_player.play("run_left")
			sprite.flip_h = true
		Vector2(-1,-1), Vector2(-1,0), Vector2(-1,1):
			# left
			animation_player.play("run_left")
			sprite.flip_h = false
		Vector2(0,-1):
			# up
			animation_player.play("run_up")
		Vector2(0,1):
			# down
			animation_player.play("run_down")
	if direction != Vector2():
		walk_sound.play()


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