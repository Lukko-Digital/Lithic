extends Sprite2D
class_name Interactable

@export_file var dialogue_file

const BRANCH_FLAGS = [
	"condition_unmet",
	"no_english",
	"not_in_tree",
	"next_to_sign",
	"unfriendly",
	"neighbor_language_barrier",
	"neighbor_condition_unmet",
	"other_tree_condition_unmet",
	"solution"
]


# Type: Dictionary[String, Dictionary[int, Array[String]]]
var dialogue_tree: Dictionary
# Type: Dictionary[String, int]
var interaction_count: Dictionary

func _ready():
	load_dialogue()
	init_interaction_count()


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
				if flag in BRANCH_FLAGS:
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
