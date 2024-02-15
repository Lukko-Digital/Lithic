extends Resource
class_name StatueMovement

func move(statue: Statue, dir: Vector2) -> bool:
	statue.ray.target_position = dir * Globals.TILE_SIZE
	statue.ray.force_raycast_update()
	if !statue.ray.is_colliding():
		statue.get_parent().position += dir * Globals.TILE_SIZE
		return true
	else: return false
