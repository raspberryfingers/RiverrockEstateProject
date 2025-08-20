# scene_manager.gd
# Handles loading the main scene container and individual level scenes.
extends Node

# Paths to main scene and its subroots
var main_scene_path: String = "res://scenes/levels/main_scene.tscn"
var main_scene_root_path: String = "/root/MainScene"
var main_scene_level_root_path: String = "/root/MainScene/GameRoot/LevelRoot"

# Dictionary mapping level names to their scene file paths
var level_scenes: Dictionary = {
	"Level1" : "res://scenes/levels/level_1.tscn"
}

# Loads the main scene container if not already loaded
func load_main_scene_container() -> void: 
	if get_tree().root.has_node(main_scene_root_path): 
		return
		
	var node: Node = load(main_scene_path).instantiate() 
	
	if node != null: 
		get_tree().root.add_child(node)


# Loads a specific level by name
func load_level(level: String) -> void: 
	# Get the scene path from the dictionary
	var scene_path: String = level_scenes.get(level)
	
	if scene_path == null: 
		return
		
	# Instantiate the level scene
	var level_scene: Node = load(scene_path).instantiate() 
	var level_root: Node = get_node(main_scene_level_root_path)
	
	if level_root != null: 
		# Remove existing children from the level root
		var nodes = level_root.get_children()
		
		if nodes != null: 
			for node: Node in nodes: 
				node.queue_free()
				
		# Wait a frame to ensure scene tree updates
		await get_tree().process_frame
				
		# Add the new level scene
		level_root.add_child(level_scene)
