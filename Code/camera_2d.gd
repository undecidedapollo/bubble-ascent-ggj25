extends Camera2D

var background_shader_material = preload("res://new_shader_material.tres") # Path to your ShaderMaterial


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update the shader's `camera_offset` uniform with the inverse of the camera's global position
	background_shader_material.set_shader_parameter("camera_offset", global_position)
