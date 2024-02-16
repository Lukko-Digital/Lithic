extends Area2D
class_name Statue

@export_group("Properties")
@export var conditions: Array[StatueCondition] = []
@export var movement: StatueMovement
@export var reads_inscription: bool = false
@export var speaks_english: bool = false

@onready var ray: RayCast2D = $RayCast2D

enum DialogStates {
	CONDITIONS_NOT_MET, 
	NO_ENGLISH, 
	NOT_IN_TREE, 
	NEXT_TO_SIGN, 
	NOT_FRIENDLY, 
	NEIGHBOR_LANGUAGE,
	NEIGHBOR_CONDITION,
	OTHER_TREE_CONDITION,
}

func _ready():
	get_parent().position = get_parent().position.snapped(Vector2.ONE * Globals.TILE_SIZE)
	get_parent().position += Vector2.ONE * Globals.TILE_SIZE/2


func move(dir: Vector2) -> bool:
	return movement.move(self, dir)

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

func interact():
	print(check_tree([]))

func check_tree(e: Array[Statue]) -> bool:
	var explored: Array[Statue] = e

	if !check_conditions():
		return false
	for neighbor in get_neighbors():
		if neighbor not in explored:
			explored.append(neighbor)
			if !neighbor.check_tree(explored):
				return false
	
	return true
