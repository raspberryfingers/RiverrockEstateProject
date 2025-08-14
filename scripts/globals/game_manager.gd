extends Node

var game_menu_screen: PackedScene = preload("res://scenes/ui/game_menu_screen.tscn")
var menu_open: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		if menu_open:
			close_game_menu()
		else:
			open_game_menu()

func open_game_menu() -> void:
	var menu_instance = game_menu_screen.instantiate()
	menu_instance.name = "GameMenu"
	menu_instance.menu_closed.connect(_on_menu_closed)
	get_tree().root.add_child(menu_instance)
	menu_open = true

func close_game_menu() -> void:
	var menu = get_tree().root.get_node_or_null("GameMenu")
	if menu:
		menu.queue_free()

func _on_menu_closed() -> void:
	menu_open = false


func start_game() -> void: 
	SceneManager.load_main_scene_container() 
	SceneManager.load_level("Level1")
	SaveGameManager.load_game()
	SaveGameManager.allow_save_game = true

	
func exit_game() -> void: 
	get_tree().quit()


func show_game_menu_screen() -> void: 
	var game_menu_screen_instance = game_menu_screen.instantiate()
	get_tree().root.add_child(game_menu_screen_instance)
