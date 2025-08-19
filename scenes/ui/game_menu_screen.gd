extends CanvasLayer

@onready var save_game_button: Button = $MarginContainer/VBoxContainer/SaveGameButton

signal menu_closed

func _ready() -> void:
	# Pause the game when menu opens
	get_tree().paused = true
	# Ensure UI still works when paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	save_game_button.disabled = !SaveGameManager.allow_save_game
	save_game_button.focus_mode = SaveGameManager.allow_save_game if Control.FOCUS_ALL else Control.FOCUS_NONE

func _exit_tree() -> void:
	# Resume the game when menu closes
	get_tree().paused = false
	menu_closed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		queue_free()

func _on_start_game_button_pressed() -> void:
	GameManager.start_game()
	queue_free()

func _on_save_game_button_pressed() -> void:
	SaveGameManager.save_game() 


func _on_exit_game_button_pressed() -> void:
	GameManager.exit_game()
