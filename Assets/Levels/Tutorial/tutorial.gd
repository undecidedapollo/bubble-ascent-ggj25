extends Node2D

@export var endgame: PackedScene = load("res://Assets/Levels/EndGame/endGame.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerInventorySystem.set_bubble_gum(0)
	PlayerInventorySystem.set_has_hubba_yoyo(false)
	PlayerInventorySystem.set_player_health(100)

func _on_blc_collected(blc:BLC) -> void:
	print("BLC collected")
	blc.queue_free()
	get_tree().change_scene_to_packed(endgame)
