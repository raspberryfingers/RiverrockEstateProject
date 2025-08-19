# scene_data_resource.gd
# A resource class for saving and loading data about scene instances in the game world.
# Extends NodeDataResource to also include basic node position and path data.
class_name SceneDataResource
extends NodeDataResource

# The name of the node (used for identification).
@export var node_name: String

# The file path of the scene resource used to instantiate the node.
@export var scene_file_path: String


# Save relevant data from the source node.
# Captures the node name and its associated scene file path.
func _save_data(source_node: Node) -> void:
	super._save_data(source_node)
	
	node_name = source_node.name
	scene_file_path = source_node.scene_file_path


# Load the saved scene into the game world.
# Instantiates the scene resource and places it under its saved parent node.
func _load_data(window: Window) -> void:
	var parent_node: Node2D
	var scene_node: Node2D
	
	# Find the parent node if its path is stored.
	if parent_node_path != null:
		parent_node = window.get_node_or_null(parent_node_path)
	
	# Recreate the saved scene if a valid file path is provided.
	if node_path != null:
		var scene_file_resource: Resource = load(scene_file_path)
		scene_node = scene_file_resource.instantiate() as Node2D
	
	# Add the recreated node to its parent and restore its global position.
	if parent_node != null and scene_node != null:
		scene_node.global_position = global_position
		parent_node.add_child(scene_node)
