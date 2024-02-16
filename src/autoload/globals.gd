extends Node

const TILE_SIZE = 16

var in_dialogue

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

signal start_dialogue(lines)
signal advance_dialogue
signal end_dialogue
