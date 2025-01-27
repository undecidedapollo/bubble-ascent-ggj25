extends Node2D

@export var tutorial: PackedScene = load("res://Assets/Levels/Tutorial/tutorial.tscn")

func _ready() -> void:
	PlayerInventorySystem.set_bubble_gum(3)
	PlayerInventorySystem.set_has_hubba_yoyo(true)
	PlayerInventorySystem.set_player_health(100)

func _on_button_pressed() -> void:
	print("Clicked")
	get_tree().change_scene_to_packed(tutorial)

