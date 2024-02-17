extends StatueCondition

func check_condition(statue: Statue) -> bool:
	var statue_pos = statue.get_parent().position
	var bound_pos = statue.bound_location.position
	if abs(statue_pos.x-bound_pos.x) + abs(statue_pos.y-bound_pos.y) <= Globals.TILE_SIZE*2.5:
		return true
	return false
