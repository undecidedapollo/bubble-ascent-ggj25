extends RigidBody2D

var last_first_action_apply = 0;

@onready var bubbleCollider: CollisionShape2D = $BubbleCollisionShape
@onready var bubbleSprite: Sprite2D = $BubbleSprite
@onready var personCollider: CollisionShape2D = $PersonCollisionShape
@onready var personSprite: Sprite2D = $PersonSprite
var isBubbleState: bool = true
var jumpsSinceLastGroundTouch: int = 0
var maxNumberOfJumps: int = 3

var immunity_time: float = 0.0

@export var initial_state : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_bubble_state(initial_state)

func toggle_bubble_state(target_state: bool = !isBubbleState) -> void:
	if target_state and PlayerInventorySystem.get_bubble_gum() <= 0:
		return

	isBubbleState = target_state
	bubbleSprite.set_deferred("visible", isBubbleState)
	bubbleCollider.set_deferred("disabled", isBubbleState)
	personSprite.set_deferred("visible", !isBubbleState)
	personCollider.set_deferred("disabled", !isBubbleState)
	if isBubbleState:
		self.gravity_scale = 0.1
		self.physics_material_override.friction = 0.1
		self.physics_material_override.bounce = 0.5
		PlayerInventorySystem.use_bubble_gum()
	else:
		self.gravity_scale = 1
		self.physics_material_override.friction = 1
		self.physics_material_override.bounce = 0.1
	jumpsSinceLastGroundTouch = 0

func computeFriction(x):
	if x <= 3:
		return 1; # Constant friction of 1 from 0 to 3
	elif x > 3 && x <= 5: 
		return 0.1 + (1 - 0.1) * exp(-2 * (x - 3)); # Exponential decay from 1 to 0.1
	else:
		return 0.1; # Constant friction of 0.1 beyond 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	last_first_action_apply += delta
	immunity_time = max(0, immunity_time - delta)

	if self.isBubbleState and InputDetection.is_pressed("LeftClick"):
		if self.linear_velocity.y > -400:
			self.apply_central_impulse(Vector2(0, -500))
	
	if not self.isBubbleState and Input.is_action_just_pressed("LeftClick"):
		if jumpsSinceLastGroundTouch < maxNumberOfJumps:
			jumpsSinceLastGroundTouch += 1

			# Determine movement direction
			var horizontal_impulse = 0
			if InputDetection.is_pressed("MoveLeft"):
				horizontal_impulse = -30000
			elif InputDetection.is_pressed("MoveRight"):
				horizontal_impulse = 30000

			# Apply combined impulse
			var jump_impulse = Vector2(horizontal_impulse, -50000)
			self.apply_central_impulse(jump_impulse)
	else:
		# Movement handling
		if InputDetection.is_pressed("MoveLeft") and self.linear_velocity.x >= -300:
			self.apply_central_impulse(Vector2(-2000, 0))
		elif InputDetection.is_pressed("MoveRight") and self.linear_velocity.x <= 300:
			self.apply_central_impulse(Vector2(2000, 0))


	# if is_in_right_touch_thing:
	# 	self.physics_material_override.friction = computeFriction(last_first_action_apply)
	# 	print("Friction: ", self.physics_material_override.friction)
	# else:
	# 	self.physics_material_override.friction = 1


func take_damage(damage: int) -> void:
	if immunity_time > 0:
		return;
	if self.isBubbleState:
		immunity_time = 1.0
		toggle_bubble_state()
	print("Damage taken: " + str(damage))

# Enum for different directions
enum DIRECTION {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func _on_body_entered(body: Node) -> void:
	pass
	# if body.is_in_group("platform"):
	# 	# Get direction of the collision, figure out if the platform is below or next to the bubble
	# 	self.jumpsSinceLastGroundTouch = 0
	# 	print("Bitch is on the ground")


var is_in_right_touch_thing: bool = false

func classify_direction(contact_normal: Vector2) -> Vector2:
	contact_normal = contact_normal.normalized()

	# Cardinal directions
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

	var best_match = null
	var max_similarity = -1.0  # Dot product values range from -1 to 1

	for direction in directions:
		var similarity = contact_normal.dot(direction)
		if similarity > max_similarity:
			best_match = direction
			max_similarity = similarity

	return best_match if best_match != null else contact_normal


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var set_value = false;
	for i in range(state.get_contact_count()):
		var contant_node = state.get_contact_collider_object(i)
		if not contant_node.is_in_group("platform"):
			continue

		var contact_normal = state.get_contact_local_normal(i)
		var direction = classify_direction(contact_normal)

		if direction == Vector2.UP:
			pass
		elif direction == Vector2.DOWN:
			self.set_deferred("jumpsSinceLastGroundTouch", 0)
			pass
		elif direction == Vector2.LEFT:
			# print("Collided with the right side of a platform")
			set_value = true
			self.set_deferred("is_in_right_touch_thing", true)
		elif direction == Vector2.RIGHT:
			set_value = true
			self.set_deferred("is_in_right_touch_thing", true)
			# print("Collided with the left side of a platform")
		else:
			print("Collided at an angle: ", direction)

	if not set_value and is_in_right_touch_thing:
		self.set_deferred("is_in_right_touch_thing", false)
		self.set_deferred("last_first_action_apply", 0)

		# Optional: Debug drawing
		# state.add_collision_exception(contact_collider) # Prevent further collisions with this object if needed
