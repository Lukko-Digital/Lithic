extends StatueCondition

func check_condition(statue: Statue) -> bool:
	for neighbor in statue.get_neighbors():
		if neighbor.reads_inscription:
			return true
	return false
