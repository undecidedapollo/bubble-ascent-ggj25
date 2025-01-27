extends RigidBody2D

@onready var bubbleCollider: CollisionShape2D = $BubbleCollisionShape
@onready var bubbleSprite: Sprite2D = $BubbleSprite
@onready var personCollider: CollisionShape2D = $PersonCollisionShape
@onready var personSprite: Sprite2D = $PersonSprite
@onready var playerSpawn: Node2D = $"../PlayerSpawn"
@onready var yoyoSpawn: Node2D = $"../YoyoSpawn"

var isBubbleState: bool = true
var jumpsSinceLastGroundTouch: int = 0
@export var numberOfJumps: int = 2
@export var is_bubble_state_allowed: bool = true
@export var is_person_state_allowed: bool = true
var immunity_time: float = 0.0

var touching_wall: Vector2 = Vector2.ZERO
var time_touching_wall: float = 0.0

@export var initial_state : bool = true

var friction_person: float = 0.8
var friction_bubble: float = 0.1

var last_jump_action: float = 0.0

var last_input_direction_is_right: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggle_bubble_state(initial_state, false)
	# Example usage:
	var x_values = [2.5, 3, 3.5, 4, 4.5, 5, 5.5]
	for x in x_values:
		print("x=", x, ", friction=", str(compute_friction(x)).pad_decimals(3))


func toggle_bubble_state(target_state: bool = !isBubbleState, use_gum : bool = true) -> void:
	if !is_bubble_state_allowed && target_state:
		target_state = false
	elif !is_person_state_allowed && !target_state:
		target_state = true

	if target_state  and target_state != isBubbleState and use_gum and PlayerInventorySystem.get_bubble_gum() <= 0:
		return

	isBubbleState = target_state
	bubbleSprite.set_deferred("visible", isBubbleState)
	bubbleCollider.set_deferred("disabled", isBubbleState)
	personCollider.set_deferred("disabled", !isBubbleState)
	if isBubbleState:
		self.gravity_scale = 0.1
		self.physics_material_override.friction = friction_bubble
		self.physics_material_override.bounce = 0.5
		PlayerInventorySystem.use_bubble_gum()
	else:
		self.gravity_scale = 1
		self.physics_material_override.friction = friction_person
		self.physics_material_override.bounce = 0.0
	jumpsSinceLastGroundTouch = 0

# func computeFriction(x):
# 	if x <= 2:
# 		return friction_person; # Constant friction of 1 from 0 to 3
# 	elif x > 2 && x <= 4: 
# 		return friction_bubble + (friction_person - friction_bubble) * exp(-3 * (x - 2)); # Exponential decay from 1 to 0.1
# 	else:
# 		return friction_bubble; # Constant friction of 0.1 beyond 5

func compute_friction(x: float, start: float = 1.0, end: float = 0.1, decay_start: float = 3.0, decay_end: float = 5.0) -> float:
	var time_span = decay_end - decay_start

	# Compute k programmatically to fit exactly from start to end over the decay range
	var k = -log(end / start) / time_span

	if x <= decay_start:
		return start # Constant friction at start value
	elif x > decay_start and x <= decay_end:
		# Compute the exponential decay
		return start * exp(-k * (x - decay_start))
	else:
		return end # Constant friction at final value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	immunity_time = max(0, immunity_time - delta)
	last_jump_action += delta
	if touching_wall != Vector2.ZERO and !isBubbleState:
		time_touching_wall += delta
		var friction = compute_friction(time_touching_wall, friction_person, 0.01, 1.7, 4.0)
		self.physics_material_override.friction = friction
		self.modulate.a = max(0.5, friction + (1 - friction_person))
		# print("Friction: ", self.physics_material_override.friction, " | Time: ", time_touching_wall)
	elif time_touching_wall == 0:
		self.physics_material_override.friction = friction_bubble if isBubbleState else friction_person
		self.modulate.a = 1
		
		

	if self.isBubbleState and (InputDetection.is_pressed("Jump") or InputDetection.is_pressed("MoveUp")):
		if self.linear_velocity.y > -400:
			self.apply_central_impulse(Vector2(0, -25000) * delta)
	
	if !self.isBubbleState and (Input.is_action_just_pressed("Jump") or Input.is_action_just_pressed("MoveUp")): 
			# Determine movement direction
			var vertical_impulse = -50000
			var horizontal_impulse = 0
			if touching_wall == Vector2.ZERO:
				if jumpsSinceLastGroundTouch < numberOfJumps:
					last_jump_action = 0.0
					jumpsSinceLastGroundTouch += 1
					print("Jumps Since: ", jumpsSinceLastGroundTouch)
					if InputDetection.is_pressed("MoveLeft"):
						last_input_direction_is_right = false
						horizontal_impulse = -10000
					elif InputDetection.is_pressed("MoveRight"):
						last_input_direction_is_right = true
						horizontal_impulse = 10000
				else:
					vertical_impulse = 0
					horizontal_impulse = 0
			elif touching_wall == Vector2.LEFT:
				var friction = self.physics_material_override.friction + (1 - friction_person)
				last_jump_action = 0.0
				horizontal_impulse = 20000 * friction
				vertical_impulse *= friction
				last_input_direction_is_right = true
			elif touching_wall == Vector2.RIGHT:
				var friction = self.physics_material_override.friction + (1 - friction_person)
				last_jump_action = 0.0
				horizontal_impulse = -20000 * friction
				vertical_impulse *= friction
				last_input_direction_is_right = false

			var jump_impulse = Vector2(horizontal_impulse, vertical_impulse)
			self.apply_central_impulse(jump_impulse)
	else:
		# Movement handling
		var impulse = 200000 if isBubbleState else 160000
		var max_speed = 300 if isBubbleState else 250
		if InputDetection.is_pressed("MoveLeft") and self.linear_velocity.x >= -max_speed:
			last_input_direction_is_right = false
			self.apply_central_impulse(Vector2(-impulse, 0) * delta)
		elif InputDetection.is_pressed("MoveRight") and self.linear_velocity.x <= max_speed:
			last_input_direction_is_right = true
			self.apply_central_impulse(Vector2(impulse, 0) * delta)

	if Input.is_action_just_pressed("Attack") and PlayerInventorySystem.has_hubba_yoyo():
		print("Attack")
		var res = hubayoyo.fire_hubayoyo(last_input_direction_is_right)
		if res and last_input_direction_is_right:
			hubayoyo.position.x = 37
		elif res and !last_input_direction_is_right:
			hubayoyo.position.x = 24 - 64


func take_damage(damage: int, eject_direction: Vector2 = Vector2.ZERO) -> void:
	var launch_amount = 40000
	if immunity_time > 0:
		if !self.isBubbleState and immunity_time < 0.2: # Don't immediately launch if immunity time is recent otherwise you may launch twice
			self.apply_central_impulse(eject_direction * launch_amount)
		return;
	immunity_time = 1.0
	if self.isBubbleState:
		toggle_bubble_state(false, false)
	else:
		self.apply_central_impulse(eject_direction * launch_amount)
		PlayerInventorySystem.take_damage(damage)

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


var is_in_right_touch_thing: bool = false

func classify_direction(contact_normal: Vector2) -> Vector2:
	contact_normal = contact_normal.normalized() * -1

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
	var move_player_to_spawn = false
	if self.global_position.x < 0:
		move_player_to_spawn = true
	if self.global_position.x > 6000:
		move_player_to_spawn = true
	if self.global_position.y > 1000:
		move_player_to_spawn = true
	if self.global_position.y < -2000 and self.isBubbleState:
		self.toggle_bubble_state(false)
		self.call_deferred("take_damage", 0)
		return
	if move_player_to_spawn:
		if PlayerInventorySystem.has_hubba_yoyo():
			self.global_position = yoyoSpawn.global_position
		else:
			self.global_position = playerSpawn.global_position
		self.linear_velocity = Vector2.ZERO
		self.call_deferred("take_damage", 10)
		return


	var set_touching_wall = false;
	for i in range(state.get_contact_count()):
		var contant_node = state.get_contact_collider_object(i)
		if contant_node.is_in_group("platform"):
			var contact_normal = state.get_contact_local_normal(i)
			var direction = classify_direction(contact_normal)

			if direction == Vector2.UP:
				pass
			elif direction == Vector2.DOWN:
				if self.last_jump_action > 0.1:
					self.jumpsSinceLastGroundTouch = 0
					self.time_touching_wall = 0
			elif direction == Vector2.LEFT:
				# print("Collided with the right side of a platform")
				set_touching_wall = true;
				self.set_deferred("touching_wall", Vector2.LEFT)
			elif direction == Vector2.RIGHT:
				set_touching_wall = true;
				self.set_deferred("touching_wall", Vector2.RIGHT)
				# print("Collided with the left side of a platform")
			else:
				print("Collided at an angle: ", direction)
		if contant_node.is_in_group("enemy"):
			var contact_normal = state.get_contact_local_normal(i)
			self.take_damage(10, contact_normal)
	if not set_touching_wall and touching_wall != Vector2.ZERO:
		self.set_deferred("touching_wall", Vector2.ZERO)



@onready var hubayoyo: Hubayoyo = $Hubayoyo