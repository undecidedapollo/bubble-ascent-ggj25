extends Camera2D

class_name PlayerCamera

var background_shader_material = preload("res://new_shader_material.tres") # Path to your ShaderMaterial
# Predefine offsets for the two views
@export var center_view_offset: Vector2 = Vector2(0, 0) # Player in the center
@export var bottom_view_offset: Vector2 = Vector2(0, -200) # Bottom 1/5 view
var current_view_offset: Vector2

var tween : Tween

func _ready():
	# Initialize with center view offset
	current_view_offset = center_view_offset
	self.offset = current_view_offset

func transition_to_view(view: int):
	var target_offset = center_view_offset if view == 0 else bottom_view_offset
	if tween != null:
		tween.kill()
	if target_offset != current_view_offset:
		tween = create_tween()
		tween.tween_property(
			self, "offset", target_offset, 1)
		tween.set_ease(Tween.EASE_IN_OUT)
		current_view_offset = target_offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the shader's `camera_offset` uniform with the inverse of the camera's global position
	background_shader_material.set_shader_parameter("camera_offset", global_position)
