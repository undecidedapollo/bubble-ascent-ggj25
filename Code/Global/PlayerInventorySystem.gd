extends Node

@export var bubble_gum: int = 3

#Signal for when the score changes
signal bubble_gum_changed(bubble_gum: int)

# Adds points to the score
func add_bubble_gum(points: int) -> void:
	bubble_gum += points
	emit_signal("bubble_gum_changed", bubble_gum)

func use_bubble_gum() -> void:
	bubble_gum -= 1
	if bubble_gum < 0:
		bubble_gum = 0
	emit_signal("bubble_gum_changed", bubble_gum)

func get_bubble_gum() -> int:
	return bubble_gum

