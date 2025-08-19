# npc_cow.gd
# Assigns a random walk cycle count when the NPC spawns.
extends NonPlayableCharacter


func _ready() -> void:
	# Randomise how many walk cycles this NPC will perform.
	# randi_range(a, b) returns an integer between a and b (inclusive).
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
