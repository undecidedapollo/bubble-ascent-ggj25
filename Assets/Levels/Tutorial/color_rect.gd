extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var real_color = self.color
	var health = PlayerInventorySystem.get_player_health()
	PlayerInventorySystem._player_health_changed.connect(func(player_health: int):
		if player_health >= health:
			return;
		
		var tween = create_tween()
		tween.tween_property(self, "color", Color.RED, 0.08).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "color", real_color, 0.08).set_ease(Tween.EASE_IN_OUT)
		tween.set_loops(2)
	)
	pass