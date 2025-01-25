extends Node

var score: int = 0

# Adds points to the score
func add_score(points: int) -> void:
	score += points
	print("Score added:", points, " | Total score:", score)

# Resets the score
func reset_score() -> void:
	score = 0
	print("Score reset.")

# Optionally, get the current score
func get_score() -> int:
	return score
