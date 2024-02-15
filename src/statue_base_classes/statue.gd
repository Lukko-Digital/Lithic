extends Area2D
class_name Statue

@export_group("Properties")
@export var conditions: Array[StatueCondition] = []
@export var reads_inscription: bool = false
@export var speaks_english: bool = false

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

func get_neighbors() -> Array[Statue]:
	var neighbors: Array[Statue] = []
	for dir in $Adjacents.get_children():
		dir.force_raycast_update()
		if dir.is_colliding():
			var colliding = dir.get_collider()
			if colliding.is_in_group("statue"):
				neighbors.append(colliding)

	return neighbors

func check_conditions() -> bool:
	for condition in conditions:
		if !condition.check_condition(self):
			return false

	return true
