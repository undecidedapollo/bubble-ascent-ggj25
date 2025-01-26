extends Node2D

@onready var useTapeRopeLabel: RichTextLabel = $UseTapeRope
@onready var leftWall: Node2D = $LeftWall
@onready var rightWall: Node2D = $RightWall
@onready var jawbreaker_spaen_point: Node2D = $JawbreakerSpawnPoint
@export var jawbreaker_scene: PackedScene = preload("res://Assets/Jawbreaker/jawbreaker.tscn")


var open_wall_offset_y: float = -200
var was_jawbreaker_spawned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var closed_left_wall_position = leftWall.position.y
	var closed_right_wall_position = rightWall.position.y
	
	PlayerInventorySystem._hubayoyo_changed.connect(func(has_hubba_yoyo: bool):
		if !has_hubba_yoyo:
			#Formatting is intentional
			useTapeRopeLabel.text = " Use Tape Rope for\nshort range attacks"
			create_tween().tween_property(leftWall, "position:y", closed_left_wall_position + open_wall_offset_y, 0.5)
		else:
			useTapeRopeLabel.text = "\nLeft Click to Attack"
			create_tween().tween_property(leftWall, "position:y", closed_left_wall_position, 0.5)
			if !was_jawbreaker_spawned:
				was_jawbreaker_spawned = true
				var jawbreaker: Jawbreaker = jawbreaker_scene.instantiate()
				jawbreaker.position = jawbreaker_spaen_point.global_position
				jawbreaker._on_jawbreaker_destroyed.connect(func():
					create_tween().tween_property(rightWall, "position:y", closed_right_wall_position + open_wall_offset_y, 1)
				, ConnectFlags.CONNECT_ONE_SHOT)
				add_child(jawbreaker)
	)
	leftWall.position.y = closed_left_wall_position + open_wall_offset_y
	pass # Replace with function body.

