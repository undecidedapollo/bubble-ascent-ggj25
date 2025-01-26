extends Node2D



func _on_body_entered(body:Node) -> void:
	if body.is_in_group("player"):
		PlayerInventorySystem.set_has_hubba_yoyo(true)
		self.queue_free()
