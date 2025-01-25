@tool
extends Node2D

@onready var fan_animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var wind_collision_area: Area2D = $WindArea
@onready var wind_collision_shape: CollisionShape2D = $WindArea/WindAreaShape
@onready var fan_particles: GPUParticles2D = $WindArea/FanParticles

@export var max_reach: float = 100.0:
	set(value):
		max_reach = value
		set_max_reach()
@export var speed: float = 1.0:
	set(value):
		speed = value
		set_speed()


func set_max_reach() -> void:
	if wind_collision_shape:
		wind_collision_shape.transform.origin.x = max_reach
		wind_collision_shape.scale.x = max_reach / 10
	if fan_particles:
		var fan_particle_material: ParticleProcessMaterial = fan_particles.process_material
		var height = 15
		var width = max_reach
		var angle = rad_to_deg(atan(height / width))
		fan_particle_material.spread = angle
		fan_particles.visibility_rect.size.x = width * 4
		fan_particles.visibility_rect.size.y = 100
	set_particle_speed()



func set_speed() -> void:
	if !fan_animated_sprite:
		return
	fan_animated_sprite.speed_scale = speed
	set_particle_speed()

func set_particle_speed() -> void:
	if !fan_particles:
		return
	var fan_particle_material: ParticleProcessMaterial = fan_particles.process_material
	var lifetime = max_reach / (speed * 10 + 0.00001) * 2
	fan_particles.lifetime = lifetime
	fan_particle_material.initial_velocity_min = speed * 10
	fan_particle_material.initial_velocity_max = speed * 10
	print("Velocity: ", fan_particle_material.initial_velocity_min, "Lifetime: ", lifetime)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_max_reach()
	set_speed()
	pass # Replace with function body.


var time_elapsed: float = 0.0
var last_boundary: int = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Set the particles min/max angle to the rotation of self if it doesn't already match
	if fan_particles:
		var fan_particle_material: ParticleProcessMaterial = fan_particles.process_material
		if fan_particle_material.angle_min != self.rotation:
			fan_particle_material.angle_min = -rad_to_deg(self.rotation)
		if fan_particle_material.angle_max != self.rotation:
			fan_particle_material.angle_max = -rad_to_deg(self.rotation)

	if Engine.is_editor_hint():
		return

	var to_delete: Array[RigidBody2D] = []
	for body in captured_objects:
		if not is_instance_valid(body):
			to_delete.append(body)
			continue

		var distance_from_body_to_self = body.global_position.distance_to(self.global_position)
		var normalized_distance = distance_from_body_to_self / max_reach
		var wind_affect = max(0.0, 1.0 - pow(normalized_distance, 8))

		var base_wind_impulse_per_kg = 1
		var base_wind_impulse = base_wind_impulse_per_kg * body.mass
		var difference_from_grav_affect = 1 - body.gravity_scale / 4
		var speed_based_impulse = base_wind_impulse * speed * difference_from_grav_affect * wind_affect
		body.apply_central_impulse(Vector2.RIGHT.rotated(body.rotation) * speed_based_impulse)


	pass

var captured_objects: Array[RigidBody2D] = []

func _on_wind_area_body_entered(body:Node2D) -> void:
	if body is RigidBody2D:
		captured_objects.append(body)
	pass # Replace with function body.


func _on_wind_area_body_exited(body:Node2D) -> void:
	if body is RigidBody2D:
		captured_objects.erase(body)
	pass # Replace with function body.
