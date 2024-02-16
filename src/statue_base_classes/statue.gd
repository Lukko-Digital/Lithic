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

enum DialogueState {
	CONDITIONS_UNMET, 
	NO_ENGLISH, 
	NOT_IN_TREE, 
	NEXT_TO_SIGN, 
	UNFRIENDLY, 
	NEIGHBOR_LANGUAGE_BARRIER,
	NEIGHBOR_CONDITION_UNMET,
	OTHER_TREE_CONDITION_UNMET,
	SOLUTION,
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
	if !check_conditions():
		say(DialogueState.CONDITIONS_UNMET)
		return
	if !speaks_english:
		say(DialogueState.NO_ENGLISH)
		return

	print(check_tree())

func check_tree() -> bool:
	var q = [[self]] #Initialize graph search queue
	var paths = []

	while len(q) > 0: #Run graph search
		var path: Array = q.pop_front()
		var last: Statue = path[-1]
		if last.is_in_group("inscription"):
			paths.append(path)
		else:
			for neighbor in last.get_neighbors():
				if neighbor not in path:
					q.append(path + [neighbor])

	if len(paths) == 0: #Not in tree
		say(DialogueState.NOT_IN_TREE)
		return false

	if !friendly: #Not friendly
		say(DialogueState.UNFRIENDLY)
		return false

	for path in paths: #Check if there is a valid path
		var previous: Statue = null
		var condition = true
		var language = true
		for statue in path:
			condition = statue.check_conditions()
			if previous != null:
				language = ((statue.speaks_english and previous.speaks_english) or 
							(statue.speaks_old and previous.speaks_old))
		if condition and language: #If there is a valid path, say solution
			say(DialogueState.SOLUTION)
			return true
	

	for statue in get_neighbors(): #If there is no valid path, check if next to sign
		if statue.is_in_group("inscription") and (!friendly or !can_read):
			say(DialogueState.NEXT_TO_SIGN)
			return false

	var first_path = paths[0] #Check if neighbor doesn't speak the same language
	if !((self.speaks_english and first_path[0].speaks_english) or (self.speaks_old and first_path[0].speaks_old)):
		say(DialogueState.NEIGHBOR_LANGUAGE_BARRIER)
		return false
	
	if !first_path.check_conditions(): #Check neighbors condition
		say(DialogueState.NEIGHBOR_CONDITION_UNMET)
		return false
	
	#Else it is other condition
	say(DialogueState.OTHER_TREE_CONDITION_UNMET)
	return false


func say(state: DialogueState):
	print(state)
	get_parent().say(state)
