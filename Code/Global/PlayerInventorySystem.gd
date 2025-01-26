extends Node

var bubble_gum: int = 3

#Signal for when the score changes
signal _bubble_gum_changed(bubble_gum: int, previous: int)

# Adds points to the score
func add_bubble_gum(points: int) -> void:
	var previous = bubble_gum
	bubble_gum += points
	_bubble_gum_changed.emit(bubble_gum, previous)

func use_bubble_gum() -> void:
	var previous = bubble_gum
	bubble_gum -= 1
	if bubble_gum < 0:
		bubble_gum = 0
	_bubble_gum_changed.emit(bubble_gum, previous)

func set_bubble_gum(value: int) -> void:
	var previous = bubble_gum
	bubble_gum = value
	_bubble_gum_changed.emit(bubble_gum, previous)

func get_bubble_gum() -> int:
	return bubble_gum


var has_hubba_yoyo_internal: bool = false

signal _hubayoyo_changed(has_hubba_yoyo: bool)

func has_hubba_yoyo() -> bool:
	return has_hubba_yoyo_internal

func set_has_hubba_yoyo(value: bool) -> void:
	has_hubba_yoyo_internal = value
	_hubayoyo_changed.emit(has_hubba_yoyo_internal)

var player_health: int = 100

signal _player_health_changed(player_health: int)

func get_player_health() -> int:
	return player_health

func set_player_health(value: int) -> void:
	player_health = value
	_player_health_changed.emit(player_health)

func take_damage(damage: int) -> void:
	player_health = max(0, player_health - damage)
	_player_health_changed.emit(player_health)
