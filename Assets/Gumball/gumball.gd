@tool
extends Node2D
@onready var sprite: Sprite2D = $Gumball
@export var color: Color = Color.BLUE:
	set(value):
		color = value
		if sprite and sprite.material:
			sprite.material.set_shader_parameter("tint_color", color)

func _ready():
	print("Color: ", color)
	sprite.material.set_shader_parameter("tint_color", color)

func _on_body_entered(body:Node) -> void:
	if body.is_in_group("player"):
		PlayerInventorySystem.add_bubble_gum(1)
		self.queue_free()
