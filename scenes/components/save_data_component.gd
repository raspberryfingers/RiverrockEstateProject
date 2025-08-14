class_name SaveDataComponent
extends Node

# Use Node not Node2D so it works when attached to Control / Panel nodes too
@onready var parent_node: Node = get_parent()
@export var save_data_resource: Resource = null

func _ready() -> void:
	add_to_group("save_data_component")

# Called by the SaveLevelDataComponent to get a Resource containing this node's data
func _save_data() -> Resource:
	# Validate parent
	if parent_node == null:
		push_error("SaveDataComponent: parent_node is null for component '%s'." % name)
		return null
	
	# Validate resource
	if save_data_resource == null:
		push_error("SaveDataComponent: save_data_resource is not set for parent '%s'." % parent_node.name)
		return null

	# Validate API
	if not save_data_resource.has_method("_save_data"):
		push_error("SaveDataComponent: save_data_resource lacks _save_data() method: %s" % save_data_resource)
		return null

	# Let the resource pull data from the parent node
	save_data_resource._save_data(parent_node)
	return save_data_resource

func _load_data() -> void:
	if parent_node == null or save_data_resource == null:
		push_error("SaveDataComponent: cannot load - missing parent or resource for component '%s'." % name)
		return
	
	if save_data_resource.has_method("_load_data"):
		save_data_resource._load_data(parent_node)
	else:
		push_error("SaveDataComponent: resource missing _load_data(): %s" % save_data_resource)
