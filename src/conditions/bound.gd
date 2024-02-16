extends StatueCondition

func check_condition(statue: Statue) -> bool:
	if statue.get_parent().position.distance_squared_to(statue.bound_location) < Globals.TILE_SIZE/2.0:
		return true
	return false
