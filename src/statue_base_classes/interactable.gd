extends Sprite2D
class_name Interactable

@export_file var dialogue_file

const BRANCH_FLAGS = {
	Globals.DialogueState.CONDITIONS_UNMET: "condition_unmet",
	Globals.DialogueState.NO_ENGLISH: "no_english",
	Globals.DialogueState.NOT_IN_TREE: "not_in_tree",
	Globals.DialogueState.NEXT_TO_SIGN: "next_to_sign",
	Globals.DialogueState.UNFRIENDLY: "unfriendly",
	Globals.DialogueState.NEIGHBOR_LANGUAGE_BARRIER: "neighbor_language_barrier",
	Globals.DialogueState.NEIGHBOR_CONDITION_UNMET: "neighbor_condition_unmet",
	Globals.DialogueState.OTHER_TREE_CONDITION_UNMET: "other_tree_condition_unmet",
	Globals.DialogueState.SOLUTION: "solution"
}


# Type: Dictionary[String, Dictionary[int, Array[String]]]
var dialogue_tree: Dictionary
# Type: Dictionary[String, int]
var interaction_count: Dictionary

func _ready():
	load_dialogue()
	init_interaction_count()
	print(dialogue_tree)


func load_dialogue():
	var dialogue_lines: Array = Array(FileAccess.open(
		dialogue_file,
		FileAccess.READ
	).get_as_text().strip_edges().split("\n")).filter(
		func(line): if line == "": return false else: return true
	)
	var branch: String
	var interaction: int
	for line in dialogue_lines:
		match line[0]:
			"#":
				var flag = line.substr(1)
				if flag in BRANCH_FLAGS.values():
					branch = flag
					dialogue_tree[branch] = {}
			"!":
				var flag = line.substr(1)
				if flag.is_valid_int():
					interaction = flag.to_int()
					dialogue_tree[branch][interaction] = []
			_:
				dialogue_tree[branch][interaction].append(line)


func init_interaction_count():
	for branch in dialogue_tree.keys():
		interaction_count[branch] = 0


func say(state: Globals.DialogueState):
	var branch = BRANCH_FLAGS[state]
	var interaction = interaction_count[branch]
	var lines = dialogue_tree[branch][interaction]
	Globals.start_dialogue.emit(lines)
