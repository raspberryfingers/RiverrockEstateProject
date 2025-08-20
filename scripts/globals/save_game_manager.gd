# save_game_manager.gd
# Handles saving and loading game data through the SaveLevelDataComponent.
extends Node

# Determines if saving the game is currently allowed
var allow_save_game: bool

# Listen for player input to trigger saving
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		save_game()


# Saves the current level/game data
func save_game() -> void:
	# Find the first SaveLevelDataComponent in the scene tree
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	if save_level_data_component != null:
		save_level_data_component.save_game()


# Loads the current level/game data
func load_game() -> void:
	# Wait one frame to ensure the scene tree is ready
	await get_tree().process_frame
	
	# Find the first SaveLevelDataComponent in the scene tree
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	if save_level_data_component != null:
		save_level_data_component.load_game()
