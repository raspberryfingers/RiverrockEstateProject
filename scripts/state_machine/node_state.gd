# NodeState.gd
# Base class for a node state, intended for use in a state machine.
# Provides signals and virtual functions to handle state lifecycle and transitions.
class_name NodeState
extends Node

# Signal emitted when this state requests a transition
@warning_ignore("unused_signal")
signal transition 


# Called each frame for general processing
func _on_process(_delta : float) -> void:
	pass


# Called each physics frame for physics-related processing
func _on_physics_process(_delta : float) -> void:
	pass


# Called to determine or trigger the next possible transitions from this state
func _on_next_transitions() -> void:
	pass


# Called when entering this state
func _on_enter() -> void:
	pass


# Called when exiting this state
func _on_exit() -> void:
	pass
