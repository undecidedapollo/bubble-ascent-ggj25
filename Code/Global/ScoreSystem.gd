extends Node

var score: int = 0

#Signal for when the score changes
signal score_changed(score: int)

# Adds points to the score
func add_score(points: int) -> void:
	score += points
	emit_signal("score_changed", score)
	print("Score added:", points, " | Total score:", score)


# Resets the score
func reset_score() -> void:
	score = 0
	emit_signal("score_changed", score)
	print("Score reset.")


# Optionally, get the current score
func get_score() -> int:
	return score
