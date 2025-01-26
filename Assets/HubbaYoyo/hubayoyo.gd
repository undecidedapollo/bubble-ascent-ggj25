extends Node2D

class_name Hubayoyo

@onready var hubayoyo_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hubayoyo_area: Area2D = $Area2D
@onready var hubayoyo_collision: CollisionShape2D = $Area2D/CollisionShape2D

func _ready() -> void:
	hubayoyo_sprite.visible = false
	hubayoyo_collision.disabled = true


func fire_hubayoyo(direction: bool, on_complete: Callable = func(): pass) -> bool:
	if !direction:
		hubayoyo_sprite.flip_h = true
		hubayoyo_collision.position.x = -abs(hubayoyo_collision.position.x)
		hubayoyo_area.direction_offset_degrees = -90
	else:
		hubayoyo_sprite.flip_h = false
		hubayoyo_collision.position.x = abs(hubayoyo_collision.position.x)
		hubayoyo_area.direction_offset_degrees = 90


	if hubayoyo_sprite.is_playing():
		return false
	hubayoyo_collision.disabled = false
	hubayoyo_sprite.visible = true
	hubayoyo_sprite.play("attack")
	hubayoyo_sprite.animation_finished.connect(func(): 
		hubayoyo_collision.disabled = true
		hubayoyo_sprite.visible = false
		on_complete.call()
	, ConnectFlags.CONNECT_ONE_SHOT)
	return true

