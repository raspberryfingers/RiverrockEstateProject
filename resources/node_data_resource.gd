# node_data_resource.gd
# A base resource class for saving and loading generic node data.
# Can be extended by other save data resources (e.g., Inventory, DayCycle).
class_name NodeDataResource
extends Resource

# The world/global position of the node.
@export var global_position: Vector2

# The node's path in the scene tree (used to locate it later).
@export var node_path: NodePath

# The parent node's path (useful for reconstructing hierarchy).
@export var parent_node_path: NodePath


# Save the basic transform and paths of the given node.
func _save_data(source_node: Node) -> void:
	# Store the global position of the node (2D games).
	global_position = source_node.global_position
	
	# Save the node's path for later retrieval in the scene tree.
	node_path = source_node.get_path()
	
	# Capture the parent node path, if a parent exists.
	var parent_node = source_node.get_parent()
	if parent_node != null:
		parent_node_path = parent_node.get_path()


# Base load method. 
# Designed to be overridden by child classes with their own load logic.
func _load_data(_window: Window) -> void:
	pass
