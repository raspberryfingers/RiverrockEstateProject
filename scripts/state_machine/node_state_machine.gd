# node_state_machine.gd
# A state machine for managing NodeState instances as children.
# Handles automatic transitions, processing, and physics updates for the current state.
class_name NodeStateMachine
extends Node

# The initial state to enter when the state machine starts
@export var initial_node_state : NodeState

# Dictionary mapping lowercase state names to NodeState instances
var node_states : Dictionary = {}

# The currently active state
var current_node_state : NodeState
var current_node_state_name : String

# Name of the parent node (used for debugging/logging)
var parent_node_name: String


# Called when the node enters the scene tree
func _ready() -> void:
	parent_node_name = get_parent().name
	
	# Register all child NodeState instances
	for child in get_children():
		if child is NodeState:
			node_states[child.name.to_lower()] = child
			child.transition.connect(transition_to)
	
	# Enter the initial state if specified
	if initial_node_state:
		initial_node_state._on_enter()
		current_node_state = initial_node_state
		current_node_state_name = current_node_state.name.to_lower()


# Called each frame for general processing
func _process(delta : float) -> void:
	if current_node_state:
		current_node_state._on_process(delta)


# Called each physics frame
func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_physics_process(delta)
		current_node_state._on_next_transitions()
		print(parent_node_name, " Current State: ", current_node_state_name)


# Transition to a new state by name
func transition_to(node_state_name : String) -> void:
	# Avoid transitioning to the same state
	if node_state_name == current_node_state.name.to_lower():
		return
	
	var new_node_state = node_states.get(node_state_name.to_lower())
	
	# Return if the requested state does not exist
	if !new_node_state:
		return
	
	# Exit the current state
	if current_node_state:
		current_node_state._on_exit()
	
	# Enter the new state
	new_node_state._on_enter()
	
	current_node_state = new_node_state
	current_node_state_name = current_node_state.name.to_lower()
	print("Current State: ", current_node_state_name)
