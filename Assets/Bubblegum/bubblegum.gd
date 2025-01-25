extends Node2D

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if body.is_in_group("player"):
			PlayerInventorySystem.add_bubble_gum(1)
			self.queue_free()
