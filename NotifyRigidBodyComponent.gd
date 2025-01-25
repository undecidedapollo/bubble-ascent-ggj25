extends Node

@onready var parent : CollisionObject2D = $"../"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent.connect("body_entered", self.on_parent_hit)
	pass # Replace with function body.


func on_parent_hit(body: Node) -> void:
	print("Hit something")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

