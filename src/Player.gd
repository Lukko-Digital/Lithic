extends Area2D

var INPUTS = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

@onready var ray = $RayCast2D

func move(dir):
	ray.target_position = INPUTS[dir] * Globals.TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += INPUTS[dir] * Globals.TILE_SIZE
	else:
		var colliding = ray.get_collider()
		if colliding.is_in_group("statue"):
			if colliding.move(INPUTS[dir]):
				position += INPUTS[dir] * Globals.TILE_SIZE

func _ready():
	position = position.snapped(Vector2.ONE * Globals.TILE_SIZE)
	position += Vector2.ONE * Globals.TILE_SIZE/2

func _unhandled_input(event):
	for dir in INPUTS.keys():
		if event.is_action_pressed(dir):
			move(dir)
	if event.is_action_pressed("reset"):
		get_tree().reload_current_scene()