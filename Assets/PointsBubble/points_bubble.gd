@tool
extends Node2D


@export var points_value: int = 100:
	set(value):
		points_value = value
		if text:
			text.text = str(points_value) 

@onready var text: RichTextLabel = $AreaBody2D/RichTextLabel

func _ready():
	text.text = str(points_value)

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		if body.is_in_group("player"):
			ScoreSystem.add_score(self.points_value)
			print("Score is: " + str(ScoreSystem.get_score()))
			self.queue_free()
