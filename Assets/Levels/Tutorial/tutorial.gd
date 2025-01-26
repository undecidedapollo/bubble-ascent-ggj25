extends Node2D

@onready var useTapeRopeLabel: RichTextLabel = $UseTapeRope

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerInventorySystem.set_bubble_gum(0)
	PlayerInventorySystem.set_has_hubba_yoyo(false)
	PlayerInventorySystem.hubayoyo_changed.connect(func(has_hubba_yoyo: bool):
		if !has_hubba_yoyo:
			#Formatting is intentional
			useTapeRopeLabel.text = " Use Tape Rope for\nshort range attacks"
		else:
			useTapeRopeLabel.text = "\nLeft Click to Attack"
	)
	pass # Replace with function body.

