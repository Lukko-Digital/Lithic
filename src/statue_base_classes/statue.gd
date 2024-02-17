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
@export var bound_location: Vector2 = Vector2(0, 0)
@export var broken: bool = false

@onready var ray: RayCast2D = $RayCast2D
@onready var glow: Node2D = $Glow

func move(dir: Vector2) -> bool:
	var prev_tree = get_entire_tree()
	var move_status = movement.move(self, dir)
	handle_tree_glow(prev_tree)
	return move_status


func handle_tree_glow(prev_tree):
	if len(graph_search()) == 0:
		glow.hide()
		for statue in prev_tree:
			statue.handle_glow()
	else:
		for statue in get_entire_tree():
			statue.glow.show()


func handle_glow():
	if len(graph_search()) == 0:
		glow.hide()
	else:
		glow.show()


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
		say(Globals.DialogueState.CONDITIONS_UNMET)
		return
	if !speaks_english:
		say(Globals.DialogueState.NO_ENGLISH)
		return

	check_tree()


func graph_search() -> Array:
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
	return paths


func check_tree() -> bool:
	var paths = graph_search()

	if len(paths) == 0: #Not in tree
		say(Globals.DialogueState.NOT_IN_TREE)
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
	

	for statue in get_neighbors(): #If there is no valid path, check if next to sign
		if statue.is_in_group("inscription") and (!friendly or !can_read):
			say(Globals.DialogueState.NEXT_TO_SIGN)
			return false

	var first_path = paths[0] #Check if neighbor doesn't speak the same language
	if !((self.speaks_english and first_path[0].speaks_english) or (self.speaks_old and first_path[0].speaks_old)):
		say(Globals.DialogueState.NEIGHBOR_LANGUAGE_BARRIER)
		return false
	
	if !first_path[0].check_conditions(): #Check neighbors condition
		say(Globals.DialogueState.NEIGHBOR_CONDITION_UNMET)
		return false
	
	#Else it is other condition
	say(Globals.DialogueState.OTHER_TREE_CONDITION_UNMET)
	return false


func say(state: int):
	get_parent().say(state)
