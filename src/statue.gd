extends Area2D
class_name Statue

@export var condition: Array[StatueCondition] = Array()

@onready var ray: RayCast2D = $RayCast2D


func _ready():
	get_parent().position = get_parent().position.snapped(Vector2.ONE * Globals.TILE_SIZE)
	get_parent().position += Vector2.ONE * Globals.TILE_SIZE/2


func move(dir: Vector2) -> bool:
	ray.target_position = dir * Globals.TILE_SIZE
	ray.force_raycast_update()
	if !ray.is_colliding():
		get_parent().position += dir * Globals.TILE_SIZE
		return true
	else: return false
