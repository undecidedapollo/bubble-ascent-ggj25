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

func set_bubble_gum(value: int) -> void:
	bubble_gum = value
	emit_signal("bubble_gum_changed", bubble_gum)

func get_bubble_gum() -> int:
	return bubble_gum


var has_hubba_yoyo_internal: bool = false

signal hubayoyo_changed(has_hubba_yoyo: bool)

func has_hubba_yoyo() -> bool:
	return has_hubba_yoyo_internal

func set_has_hubba_yoyo(value: bool) -> void:
	has_hubba_yoyo_internal = value
	emit_signal("hubayoyo_changed", has_hubba_yoyo_internal)
