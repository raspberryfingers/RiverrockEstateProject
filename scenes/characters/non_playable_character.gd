# non_playable_character.gd
# Defines the behavior and properties of a Non-Playable Character (NPC) in the game.
# Handles walking cycle limits, and tracks current walking cycle state.
class_name NonPlayableCharacter
extends CharacterBody2D

# Editor Exports
@export var min_walk_cycle: int = 2 # Minimum number of steps or cycles an NPC can walk before stopping
@export var max_walk_cycle: int = 6 # Maximum number of steps or cycles an NPC can walk before stopping

# Internal Variables 
var walk_cycles: int # Randomly chosen number of walk cycles for the current movement session
var current_walk_cycle: int # Tracks how many cycles the NPC has currently completed
