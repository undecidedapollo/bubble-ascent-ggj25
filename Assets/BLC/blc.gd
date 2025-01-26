extends Node2D

class_name BLC
signal blc_collected(blc: BLC)

func _on_area_2d_body_entered(body:Node2D) -> void:
	if body.is_in_group("player"):
		blc_collected.emit(self)
