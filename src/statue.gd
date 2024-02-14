extends StaticBody2D

@onready var ray: RayCast2D = $RayCast2D


func _ready():
	position = position.snapped(Vector2.ONE * Globals.TILE_SIZE)
	position += Vector2.ONE * Globals.TILE_SIZE/2


func move(dir: Vector2) -> bool:
	ray.target_position = dir * Globals.TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += dir * Globals.TILE_SIZE
		return true
	else: return false
