extends Area2D
class_name Statue

@export_group("Properties")
@export var conditions: Array[StatueCondition] = []
@export var movement: StatueMovement
@export var can_read: bool = false
@export var friendly: bool = false
@export var speaks_english: bool = true
@export var speaks_old: bool = false

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
	print(check_tree())

func check_tree() -> bool:
	if !friendly:
		return false

	var q = [[self]]
	var paths = []

	while len(q) > 0:
		var path: Array = q.pop_front()
		var last: Statue = path[-1]
		if last.is_in_group("inscription"):
			paths.append(path)
		else:
			for neighbor in last.get_neighbors():
				if neighbor not in path:
					q.append(path + [neighbor])

	for path in paths:
		var previous: Statue = null
		var condition = true
		var language = true
		for statue in path:
			condition = statue.check_conditions()
			if previous != null:
				language = ((statue.speaks_english and previous.speaks_english) or 
							(statue.speaks_old and previous.speaks_old))
		if condition and language:
			return true

	return false
