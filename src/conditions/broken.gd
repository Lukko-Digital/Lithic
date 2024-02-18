extends StatueCondition

func check_condition(statue: Statue) -> bool:
	return statue.broken

func fix(statue: Statue) -> void:
	statue.fixed_statue.position = statue.get_parent().position
	statue.get_parent().queue_free()
