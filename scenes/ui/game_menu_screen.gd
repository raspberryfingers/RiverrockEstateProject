# game_menu_screen.gd
# Handles the in-game menu UI, including pausing the game, saving, starting, and exiting.
extends CanvasLayer

# References to UI nodes
@onready var save_game_button: Button = $MarginContainer/VBoxContainer/SaveGameButton

# Signal emitted when the menu is closed
signal menu_closed

func _ready() -> void:
	# Pause the game when the menu opens
	get_tree().paused = true
	# Ensure this CanvasLayer still processes input while the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Enable or disable the save game button depending on game state
	save_game_button.disabled = !SaveGameManager.allow_save_game
	save_game_button.focus_mode = SaveGameManager.allow_save_game if Control.FOCUS_ALL else Control.FOCUS_NONE


func _exit_tree() -> void:
	# Resume the game when the menu closes
	get_tree().paused = false
	# Emit a signal so other systems know the menu closed
	menu_closed.emit()


func _unhandled_input(event: InputEvent) -> void:
	# Close menu if player presses the menu key
	if event.is_action_pressed("game_menu"):
		queue_free()


# Button pressed handlers
func _on_start_game_button_pressed() -> void:
	GameManager.start_game()
	queue_free()


func _on_save_game_button_pressed() -> void:
	# Save the current game using SaveGameManager
	SaveGameManager.save_game() 


func _on_exit_game_button_pressed() -> void:
	# Exit the game
	GameManager.exit_game()
