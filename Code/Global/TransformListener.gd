extends Node

@onready var player: Node2D = $"../Player"

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Transform"):
		player.toggle_bubble_state()
