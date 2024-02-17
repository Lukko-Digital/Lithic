extends StatueMovement

func move(statue: Statue, dir: Vector2) -> bool:
	statue.ray.target_position = dir * Globals.TILE_SIZE
	statue.ray.force_raycast_update()
	if !statue.ray.is_colliding():
		statue.get_parent().position += dir * Globals.TILE_SIZE
		return true
	else:
		var colliding = statue.ray.get_collider()
		if colliding.is_in_group('statue') and colliding.broken:
			colliding.conditions[0].fix(colliding)
			statue.get_parent().queue_free()
			return true
	
	return false
