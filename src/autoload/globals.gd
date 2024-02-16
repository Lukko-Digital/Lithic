extends Node

var TILE_SIZE = 16

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
