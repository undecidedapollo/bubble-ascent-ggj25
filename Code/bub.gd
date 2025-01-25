extends RigidBody2D

var last_first_action_apply = 0;

@onready var bubbleCollider: CollisionShape2D = $BubbleCollisionShape
@onready var bubbleSprite: Sprite2D = $BubbleSprite
@onready var personCollider: CollisionShape2D = $PersonCollisionShape
@onready var personSprite: Sprite2D = $PersonSprite
var isBubbleState: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func toggle_bubble_state() -> void:
	isBubbleState = !isBubbleState
	bubbleSprite.set_deferred("visible", isBubbleState)
	bubbleCollider.set_deferred("disabled", isBubbleState)
	personSprite.set_deferred("visible", !isBubbleState)
	personCollider.set_deferred("disabled", !isBubbleState)
	if isBubbleState:
		self.gravity_scale = 0.1
	else:
		self.gravity_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	last_first_action_apply += delta
	if InputDetection.is_pressed("LeftClick"):
		if self.linear_velocity.y > -400:
			self.apply_central_impulse(Vector2(0, -500))
			# last_first_action_apply = 0
	if InputDetection.is_pressed("MoveLeft") and self.linear_velocity.x >= -300: 
		self.apply_central_impulse(Vector2(-2000, 0));
	if InputDetection.is_pressed("MoveRight") and self.linear_velocity.x <= 300:
		self.apply_central_impulse(Vector2(2000, 0));
	if Input.is_action_just_pressed("Transform"):
		toggle_bubble_state()
	pass



func _on_body_entered(body: Node) -> void:
	if body is RigidBody2D && body.is_in_group("damage_player"):
		print("Bitch is the bitch")
