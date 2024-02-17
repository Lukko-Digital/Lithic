extends StatueCondition

func check_condition(statue: Statue) -> bool:
	return statue.broken

func fix(statue: Statue) -> void:
	statue.get_parent().modulate = Color.BLUE
	statue.broken = false
