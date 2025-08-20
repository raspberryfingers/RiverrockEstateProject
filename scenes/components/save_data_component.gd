# save_data_component.gd
# Component for saving and loading data from a parent node using a Resource.
# Works with Node and Control types (not limited to Node2D).
class_name SaveDataComponent
extends Node

# The parent node whose data this component will save/load.
# Using Node so it works for Control, Node2D, and other node types.
@onready var parent_node: Node = get_parent()

# The resource that defines how this node's data is saved/loaded.
@export var save_data_resource: Resource = null

func _ready() -> void:
	# Add this component to a group for easy access by a SaveLevelDataComponent.
	add_to_group("save_data_component")


# Called by SaveLevelDataComponent to get a Resource containing this node's data
func _save_data() -> Resource:
	# Validate parent
	if parent_node == null:
		push_error("SaveDataComponent: parent_node is null for component '%s'." % name)
		return null
	
	# Validate that a save resource has been assigned
	if save_data_resource == null:
		push_error("SaveDataComponent: save_data_resource is not set for parent '%s'." % parent_node.name)
		return null

	# Validate that the resource has the required _save_data method
	if not save_data_resource.has_method("_save_data"):
		push_error("SaveDataComponent: save_data_resource lacks _save_data() method: %s" % save_data_resource)
		return null

	# Let the resource pull data from the parent node
	save_data_resource._save_data(parent_node)
	return save_data_resource


# Loads the saved data from the resource into the parent node
func _load_data() -> void:
	if parent_node == null or save_data_resource == null:
		push_error("SaveDataComponent: cannot load - missing parent or resource for component '%s'." % name)
		return
	
	# Call the resource's _load_data if it exists
	if save_data_resource.has_method("_load_data"):
		save_data_resource._load_data(parent_node)
	else:
		push_error("SaveDataComponent: resource missing _load_data(): %s" % save_data_resource)
