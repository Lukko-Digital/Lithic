extends Area2D

var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}

@onready var ray = $RayCast2D

func move(dir):
	ray.target_position = inputs[dir] * Globals.TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += inputs[dir] * Globals.TILE_SIZE
	else:
		print_debug(ray.get_collider().get_collision_layer_value(3))

func _ready():
	position = position.snapped(Vector2.ONE * Globals.TILE_SIZE)
	position += Vector2.ONE * Globals.TILE_SIZE/2

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
