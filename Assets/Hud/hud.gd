extends Node2D

@onready var score_label: RichTextLabel = $"CanvasLayer/ScoreLabel"
@onready var bubble_gum_label: RichTextLabel = $"CanvasLayer/BubbleGumLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score(ScoreSystem.get_score())
	update_bubble_gum(PlayerInventorySystem.get_bubble_gum())
	ScoreSystem.score_changed.connect(update_score)
	PlayerInventorySystem.bubble_gum_changed.connect(update_bubble_gum)

func update_score(new_score: int) -> void:
	score_label.text = "Score: " + str(new_score)

func update_bubble_gum(new_bubble_gum: int) -> void:
	bubble_gum_label.text = "Gum: " + str(new_bubble_gum)
