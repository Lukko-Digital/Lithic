extends Area2D
class_name Statue

@export_group("Properties")
@export var conditions: Array[StatueCondition] = []
@export var movement: StatueMovement
@export var can_read: bool = false
@export var friendly: bool = false
@export var speaks_english: bool = true
@export var speaks_old: bool = false
@export_subgroup("Condition specific properties")
@export var is_parent: bool = false
@export var bound_location: Node2D = null
@export var broken: bool = false

@onready var ray: RayCast2D = $RayCast2D
@onready var glow: Node2D = $Glow
@onready var poof_scene = preload("res://src/statue_base_classes/poof.tscn")

## Move according to movement resource
## Update glow of self and neighbors
func move(dir: Vector2) -> bool:
	var prev_tree = get_entire_tree()
	var move_status = movement.move(self, dir)
	if move_status:
		poof(dir)
	handle_tree_glow(prev_tree)
	return move_status


func poof(dir: Vector2):
	var instance = poof_scene.instantiate()
	instance.position -= Globals.TILE_SIZE * dir
	instance.look_at(dir)
	add_child(instance)


## Glow or deglow self and all touching statues if in tree
func handle_tree_glow(prev_tree):
	var new_tree = get_entire_tree()
	if handle_glow():
		for statue in new_tree:
			if not statue.is_in_group("sign"):
				statue.glow.show()

		for statue in prev_tree:
			if statue not in new_tree:
				statue.glow.hide()
	else:
		for statue in prev_tree:
			statue.handle_glow()


## Glow or deglow self if in tree
func handle_glow() -> bool:
	if is_in_group("sign") or is_in_group("box"):
		return false
	if len(find_paths_to_sign()) == 0:
		glow.hide()
		return false
	else:
		glow.show()
		return true


## Fetch all touching statues
func get_entire_tree():
	var q = [self] #Initialize graph search queue
	var seen = [self]

	while len(q) > 0: #Run graph search
		var curr: Statue = q.pop_front()
		for neighbor in curr.get_neighbors():
			if neighbor not in seen:
				q.append(neighbor)
				seen.append(neighbor)
	return seen


## Fetch adjacent statues
func get_neighbors() -> Array[Statue]:
	var neighbors: Array[Statue] = []
	for dir in $Adjacents.get_children():
		dir.force_raycast_update()
		if dir.is_colliding():
			var colliding = dir.get_collider()
			if colliding.is_in_group("statue") and !colliding.is_in_group("box"):
				neighbors.append(colliding)
	return neighbors


## Check speaking conditions determined by resource
func check_conditions() -> bool:
	for condition in conditions:
		if !condition.check_condition(self):
			return false

	return true


## Called when player interacts with statue
func interact():
	if !check_conditions():
		say(Globals.DialogueState.CONDITIONS_UNMET)
		return
	if !speaks_english:
		say(Globals.DialogueState.NO_ENGLISH)
		return

	check_tree()


## Find paths through statues to the sign
## Returns all statues in the direct path to the sign
func find_paths_to_sign() -> Array:
	var q = [[self]] #Initialize graph search queue
	var paths = []

	while len(q) > 0: #Run graph search
		var path: Array = q.pop_front()
		var last: Statue = path[-1]
		if last.is_in_group("sign"):
			paths.append(path)
		else:
			for neighbor in last.get_neighbors():
				if neighbor not in path:
					q.append(path + [neighbor])
	return paths


## Check tree and say appropriate dialogue
func check_tree() -> bool:
	var paths = find_paths_to_sign()

	if len(paths) == 0: #Not in tree
		say(Globals.DialogueState.NOT_IN_TREE)
		return false

	for statue in get_neighbors(): #If there is no valid path, check if next to sign
		if statue.is_in_group("sign") and (!friendly or !can_read):
			say(Globals.DialogueState.NEXT_TO_SIGN)
			return false
	
	if !friendly: #Not friendly
		say(Globals.DialogueState.UNFRIENDLY)
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
			say(Globals.DialogueState.SOLUTION)
			return true
	
	var first_path = paths[0] #Check if neighbor doesn't speak the same language
	if !((self.speaks_english and first_path[1].speaks_english) or (self.speaks_old and first_path[1].speaks_old)):
		say(Globals.DialogueState.NEIGHBOR_LANGUAGE_BARRIER)
		return false
	
	if !first_path[0].check_conditions(): #Check neighbors condition
		say(Globals.DialogueState.NEIGHBOR_CONDITION_UNMET)
		return false
	
	#Else it is other condition
	say(Globals.DialogueState.OTHER_TREE_CONDITION_UNMET)
	return false


## Show dialogue
func say(state: int):
	get_parent().say(state)
