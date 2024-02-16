extends StatueCondition

func check_condition(statue: Statue) -> bool:
	for neighbor in statue.get_neighbors():
		if neighbor.is_parent:
			return true
	return false
