extends Node2D


var gumball: PackedScene = preload("res://Assets/Gumball/gumball.tscn")
var gumball_colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW, Color.MAGENTA, Color.PINK, Color.CYAN, Color.ORANGE, Color.PURPLE]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var should_spawn_gumdrop = randf() < 0.005
	if not should_spawn_gumdrop:
		return

	var gb: Gumball = gumball.instantiate()
	gb.global_position = self.global_position + Vector2(randf_range(-100, 100), randf_range(0, 20))
	gb.set_deferred("color", gumball_colors[randi() % gumball_colors.size()])
	gb.visible = true
	gb.gravity_scale = randf_range(0.1, 1.0)
	get_parent().add_child(gb)
