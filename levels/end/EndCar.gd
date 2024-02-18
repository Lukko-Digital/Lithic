extends StaticBody2D

## Called when player interacts with car
func interact():
	get_parent().say(Globals.DialogueState.SOLUTION)

