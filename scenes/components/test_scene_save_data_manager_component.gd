# test_scene_save_data_manager_component.gd
# This component handles loading the saved game data when the scene is ready.
class_name TestSceneSaveDataManagerComponent
extends Node

func _ready() -> void:
	# Defer scene loading to ensure all nodes are initialized before calling SaveGameManager
	call_deferred("load_scene")
	
	
func load_scene():
	# Load the saved game data using the global SaveGameManager
	SaveGameManager.load_game()
