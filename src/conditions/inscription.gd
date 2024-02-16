extends StatueCondition

func check_condition(statue: Statue) -> bool:
	for neighbor in statue.get_neighbors():
		if neighbor.can_read:
			return true
	return false
