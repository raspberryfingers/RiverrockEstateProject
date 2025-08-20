# save_level_data_component.gd
# Component responsible for saving and loading all saveable nodes in a level.
# Collects data from nodes in the "save_data_component" group and stores them
# in a SaveGameDataResource. Saves to user:// path for persistence.
class_name SaveLevelDataComponent
extends Node

# Name of the level scene; automatically set from parent node
var level_scene_name: String

# Folder path where game save files are stored
var save_game_data_path: String = "user://game_data/"

# Format string for save file name; %s will be replaced by the level_scene_name
var save_file_name: String = "save_%s_game_data.tres"

# The resource that stores all saved node data for this level
var game_data_resource: SaveGameDataResource

func _ready() -> void:
	# Add this component to a group for easy access
	add_to_group("save_level_data_component")
	
	# Automatically assign the level name based on parent node
	level_scene_name = get_parent().name


# Collects and saves all nodes in the "save_data_component" group
func save_node_data() -> void:
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	
	# Create a fresh game data resource
	game_data_resource = SaveGameDataResource.new()
	
	if nodes != null:
		for node: SaveDataComponent in nodes:
			if node is SaveDataComponent:
				# Get the node's save data resource
				var save_data_resource: NodeDataResource = node._save_data()
				if save_data_resource != null:
					# Duplicate to avoid modifying original resource
					var save_final_resource = save_data_resource.duplicate()
					game_data_resource.save_data_nodes.append(save_final_resource)
				else:
					push_warning("SaveDataComponent returned null for: " + node.name)


# Saves the current level's data to a file
func save_game() -> void:
	# Ensure the save directory exists
	if !DirAccess.dir_exists_absolute(save_game_data_path):
		DirAccess.make_dir_absolute(save_game_data_path)
	
	# Generate the save file name based on the level
	var level_save_file_name: String = save_file_name % level_scene_name
	
	# Collect node data before saving
	save_node_data()
	
	# Save the resource to disk
	var result: int = ResourceSaver.save(game_data_resource, save_game_data_path + level_save_file_name)
	print("save result:", result)


# Loads saved game data for the current level
func load_game() -> void:
	var level_save_file_name: String = save_file_name % level_scene_name
	var save_game_path: String = save_game_data_path + level_save_file_name
	
	# If the file does not exist, exit early
	if !FileAccess.file_exists(save_game_path):
		return
	
	# Load the saved resource
	game_data_resource = ResourceLoader.load(save_game_path)
	if game_data_resource == null:
		return
	
	# Apply loaded data to the current scene nodes
	var root_node: Window = get_tree().root
	for resource in game_data_resource.save_data_nodes:
		if resource is Resource:
			if resource is NodeDataResource:
				resource._load_data(root_node)
