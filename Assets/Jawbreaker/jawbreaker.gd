extends RigidBody2D

class_name Jawbreaker

@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

@export_range(1, 5) var num_stages: int = 3
@export_range(0, 4) var starting_stage: int = 0
@export var iframes_delta_after_hit: float = 0.5

signal _on_jawbreaker_destroyed()

var iframes = 0

# Four colors for stages 1, 2, 3, 4
var jawbreaker_inner_colors = [Color.CYAN, Color.YELLOW, Color.GREEN, Color.MAGENTA]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.call_deferred("set_animation_frame", starting_stage)
	jawbreaker_inner_colors.shuffle()

var last_direction_right: bool = true
var do_nothing_time: float = 1.0

func get_mass_ratio() -> float:
	return self.mass / 550

func _process(delta):
	if iframes > 0:
		iframes = max(0, iframes - delta)
	if do_nothing_time > 0:
		do_nothing_time = max(0, do_nothing_time - delta)
		return
	else:
		var should_do_nothing = randf() < 0.01
		if should_do_nothing:
			do_nothing_time = randf_range(0.1, 0.8)
		else:
			var should_apply_impulse = randf() < 0.3
			if should_apply_impulse:
				var should_jump = randf() < 0.1
				var should_change_dir = randf() < 0.1
				if should_change_dir:
					last_direction_right = !last_direction_right
				
				var vector = Vector2.RIGHT if last_direction_right else Vector2.LEFT 
				if should_jump:
					vector = vector + Vector2.UP

				var ratio = self.mass / 550
				self.apply_central_impulse(vector * (10000 * ratio))



func set_animation_frame(frame: int) -> void:
	var base_scale_offset = 3.14 # This works for some reason
	var divider = 1 + frame * 0.5
	var scale_offset = base_scale_offset / divider
	collisionShape.scale = Vector2(scale_offset, scale_offset)
	sprite.frame = frame
	if frame > 0 and frame <= jawbreaker_inner_colors.size():
		sprite.modulate = jawbreaker_inner_colors[frame - 1]
	self.mass = 550 - (frame * 100)

func weapon_hit(eject_direction: Vector2 = Vector2.ZERO) -> bool:
	if iframes > 0:
		return false
	iframes = iframes_delta_after_hit
	var next_frame = sprite.frame + 1
	if next_frame >= num_stages:
		_on_jawbreaker_destroyed.emit()
		queue_free()
		return true

	set_animation_frame(next_frame)
	var ratio = self.mass / 550
	var launch_amount = 100000 * ratio
	eject_direction = eject_direction + Vector2.UP
	self.apply_central_impulse(eject_direction * launch_amount)
	return true

