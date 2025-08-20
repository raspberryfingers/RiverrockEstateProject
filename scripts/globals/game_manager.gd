# game_manager.gd
# Manages the main game flow, including starting, exiting, and opening the in-game menu.
extends Node

# Preloaded PackedScene for the game menu UI
var game_menu_screen: PackedScene = preload("res://scenes/ui/game_menu_screen.tscn")

# Tracks whether the game menu is currently open
var menu_open: bool = false

# Handles input for opening/closing the game menu
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		if menu_open:
			close_game_menu()
		else:
			open_game_menu()


# Opens the game menu and connects the menu_closed signal
func open_game_menu() -> void:
	var menu_instance = game_menu_screen.instantiate()
	menu_instance.name = "GameMenu"
	menu_instance.menu_closed.connect(_on_menu_closed)
	get_tree().root.add_child(menu_instance)
	menu_open = true


# Closes the game menu if it exists
func close_game_menu() -> void:
	var menu = get_tree().root.get_node_or_null("GameMenu")
	if menu:
		menu.queue_free()


# Callback for when the game menu signals it has been closed
func _on_menu_closed() -> void:
	menu_open = false


# Starts the game: loads the main scene and the first level, then loads saved game data
func start_game() -> void: 
	SceneManager.load_main_scene_container() 
	SceneManager.load_level("Level1")
	SaveGameManager.load_game()
	SaveGameManager.allow_save_game = true


# Exits the game
func exit_game() -> void: 
	get_tree().quit()


# Instantiates and shows the game menu screen
func show_game_menu_screen() -> void: 
	var game_menu_screen_instance = game_menu_screen.instantiate()
	get_tree().root.add_child(game_menu_screen_instance)
