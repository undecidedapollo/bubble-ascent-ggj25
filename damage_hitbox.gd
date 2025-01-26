extends Area2D

func _on_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		print("Players")
		if body.has_method("take_damage"):
			body.take_damage(10)

