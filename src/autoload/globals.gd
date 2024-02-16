extends Node

const TILE_SIZE = 16

var in_dialogue
var in_door_ui

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

signal enter_door_ui
signal exit_door_ui
