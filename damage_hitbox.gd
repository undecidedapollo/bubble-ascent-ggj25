extends Area2D

enum TargetTypes {
	ENEMY,
	PLAYER
}

func target_to_string(target_type: TargetTypes) -> String:
	match target_type:
		TargetTypes.ENEMY:
			return "enemy"
		TargetTypes.PLAYER:
			return "player"
	return "unknown"

@export var target_group: Array[TargetTypes] = []
@export var direction_offset_degrees: float = 0

func _on_body_entered(body:Node2D) -> void:
	var is_body_in_target_group =  target_group.filter(func(target_type: TargetTypes): return body.is_in_group(target_to_string(target_type)))

	if is_body_in_target_group.size() > 0:
		print("Dealing damage to ", target_to_string(is_body_in_target_group[0]))
		var eject_vector = Vector2.UP.rotated(self.global_rotation + deg_to_rad(direction_offset_degrees))
		if body.has_method("take_damage"):
			body.take_damage(10, eject_vector)
			print("Angle raw: ", rad_to_deg(self.global_rotation), " Offset: ", direction_offset_degrees, " Angle: ", rad_to_deg(self.global_rotation + deg_to_rad(direction_offset_degrees)))
		if body.has_method("weapon_hit"):
			body.weapon_hit(eject_vector)

