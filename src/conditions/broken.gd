extends StatueCondition

func check_condition(statue: Statue) -> bool:
	if !statue.broken:
		return true
	return false
