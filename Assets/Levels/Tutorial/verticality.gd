extends Node2D

@onready var verticalityLabel: RichTextLabel = $VerticalityLabel
@onready var gumball_spawn: Node2D = $GumballSpawn
@onready var playerCamera: PlayerCamera = $"../Player/Camera2D"
var gumballScene: PackedScene = preload("res://Assets/Gumball/gumball.tscn")

# Called when the node enters the scene tree for the first time.
var triggered_float_msg: bool = false
func _ready() -> void:
	PlayerInventorySystem.set_bubble_gum(0)
	PlayerInventorySystem._bubble_gum_changed.connect(func(bubble_gum: int, previous_gumball: int):
		print("Bubble gum: ", bubble_gum)
		if bubble_gum <= 0:
			verticalityLabel.text = "[center]Collect Gumballs[/center]"
		else:
			verticalityLabel.text = "[center]Right Click to use Gumball[/center]"
			if bubble_gum < previous_gumball:
				triggered_float_msg = true
			if triggered_float_msg:
				verticalityLabel.text += "\n\n[center]W/Space to float[/center]"
	)
	pass # Replace with function body.


var gumball_colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW, Color.MAGENTA, Color.PINK, Color.CYAN, Color.ORANGE, Color.PURPLE]
func _on_trigger_verticality_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		playerCamera.transition_to_view(1)
		await get_tree().create_timer(1).timeout
		# Run for 5 - number of gumballs
		for i in range(max(0, 5 - PlayerInventorySystem.get_bubble_gum())): 
			var gb: Gumball = gumballScene.instantiate()
			gb.position = self.gumball_spawn.position + Vector2(randf_range(-100, 100), randf_range(-20, 20))
			gb.set_deferred("color", gumball_colors[randi() % gumball_colors.size()])
			gb.visible = true
			self.add_child(gb)
	pass # Replace with function body.



func _on_trigger_post_verticality_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		playerCamera.transition_to_view(0)
