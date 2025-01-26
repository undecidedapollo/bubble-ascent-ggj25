extends Node2D

@onready var score_label: RichTextLabel = $"CanvasLayer/ScoreLabel"
@onready var bubble_gum_label: RichTextLabel = $"CanvasLayer/BubbleGumLabel"
@onready var health_label: RichTextLabel = $"CanvasLayer/HealthLabel"
@onready var hubba_yoyo_sprite: Sprite2D = $"CanvasLayer/HubbaYoyoSprite"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_score(ScoreSystem.get_score())
	update_health(PlayerInventorySystem.get_player_health())
	update_bubble_gum(PlayerInventorySystem.get_bubble_gum(), 0)
	update_hubba_yoyo(PlayerInventorySystem.has_hubba_yoyo())
	ScoreSystem.score_changed.connect(update_score)
	PlayerInventorySystem._player_health_changed.connect(update_health)
	PlayerInventorySystem._bubble_gum_changed.connect(update_bubble_gum)
	PlayerInventorySystem._hubayoyo_changed.connect(update_hubba_yoyo)

func update_score(new_score: int) -> void:
	score_label.text = "Score: " + str(new_score)

func update_health(new_health: int) -> void:
	health_label.text = "Health: " + str(new_health)

func update_bubble_gum(new_bubble_gum: int, _previous_gumball: int) -> void:
	bubble_gum_label.text = "Gum: " + str(new_bubble_gum)

func update_hubba_yoyo(has_hubba_yoyo: bool) -> void:
	hubba_yoyo_sprite.visible = has_hubba_yoyo