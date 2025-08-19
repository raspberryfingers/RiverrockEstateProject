# chicken.gd
# Sets up random walk cycles when the node is ready.
extends NonPlayableCharacter

func _ready() -> void:
	# Randomise the number of walk cycles between min_walk_cycle and max_walk_cycle.
	# randi_range(a, b) returns an integer between a and b (inclusive).
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
