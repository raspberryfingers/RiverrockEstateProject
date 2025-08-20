# walk_state.gd
# Handles the walking state for the player, including animation, movement and transition detection.
extends NodeState

# Reference to the Player instance this state controls.
@export var player: Player 
# The AnimatedSprite2D used for displaying the player's animations.
@export var animated_sprite_2d: AnimatedSprite2D

# Movement speed of the player while walking.
@export var speed: int = 50 


# Called every frame (not physics-based). Currently unused in this state.
func _on_process(_delta : float) -> void:
	pass


# Called every physics frame. Handles movement and animation playback.
func _on_physics_process(_delta : float) -> void:
	# Get movement direction from input (WASD/arrow keys, etc.)
	var direction: Vector2 = GameInputEvents.movement_input()
	
	# Play the correct animation depending on direction
	if direction == Vector2.UP:
		animated_sprite_2d.play("walk_back")
	elif direction == Vector2.RIGHT: 
		animated_sprite_2d.play("walk_left") # Note: uses 'left' animation for right direction
	elif direction == Vector2.DOWN: 
		animated_sprite_2d.play("walk_front")
	elif direction == Vector2.LEFT: 
		animated_sprite_2d.play("walk_left")
		
	# Update the player's facing direction if moving
	if direction != Vector2.ZERO:
		player.player_direction = direction
		
	# Apply velocity to the player
	player.velocity = direction * speed 
	player.move_and_slide()


# Handles transitions to other states.
# If no movement input is detected, switch to "Idle" state.
func _on_next_transitions() -> void:
	if !GameInputEvents.is_movement_input(): 
		transition.emit("Idle")


# Runs when entering the walking state. (Unused for now)
func _on_enter() -> void:
	pass


# Runs when exiting the walking state. Stops animation playback.
func _on_exit() -> void:
	animated_sprite_2d.stop()
