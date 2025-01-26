extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerInventorySystem.set_bubble_gum(0)
	PlayerInventorySystem.set_has_hubba_yoyo(false)

func _on_blc_collected(blc:BLC) -> void:
	print("BLC collected")
	blc.queue_free()

