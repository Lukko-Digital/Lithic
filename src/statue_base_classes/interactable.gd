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

var dialogue_tree: Dictionary

func _ready():
	dialogue_tree = load_dialogue()


func load_dialogue():
	var dialogue_lines: Array = Array(FileAccess.open(
		dialogue_file,
		FileAccess.READ
	).get_as_text().strip_edges().split("\n")).filter(
		func(line): if line == "": return false else: return true
	)
	# Dictionary[String, Dictionary[int, Array[String]]]
	var dialogue_dict = {}
	var branch: String
	var interaction: int
	for line in dialogue_lines:
		match line[0]:
			"#":
				var flag = line.substr(1)
				if flag in BRANCH_FLAGS:
					branch = flag
					dialogue_dict[branch] = {}
			"!":
				var flag = line.substr(1)
				if flag.is_valid_int():
					interaction = flag.to_int()
					dialogue_dict[branch][interaction] = []
			_:
				dialogue_dict[branch][interaction].append(line)
	return dialogue_dict
