# idle_state.gd
# Handles the idle state for the player, including animation and transition detection.
extends NodeState 

# Reference to the Player node
@export var player: Player
# Reference to the AnimatedSprite2D used for idle animations
@export var animated_sprite_2d: AnimatedSprite2D

# Stores the current movement direction of the player
var direction: Vector2 
# Tracks whether the player is pressing "hit" while not interacting with UI
var not_on_ui : bool = false


# Called every frame (logic updates not tied to physics)
func _on_process(_delta : float) -> void:
	# Reset not_on_ui when "hit" is not pressed
	if not Input.is_action_pressed("hit"):
		not_on_ui = false


# Handles player input that hasn't been consumed by the UI
func _unhandled_input(event):
	# If "hit" is pressed, flag as not_on_ui
	if event.is_action_pressed("hit"):
		not_on_ui = true


# Called every physics frame (used for movement & animation updates)
func _on_physics_process(_delta : float) -> void:	
	# Update idle animations based on the player's last movement direction
	if player.player_direction == Vector2.UP: 
		animated_sprite_2d.play("idle_back")
	elif player.player_direction == Vector2.RIGHT: 
		animated_sprite_2d.play("idle_left")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("idle_front")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("idle_left")
	else: 
		animated_sprite_2d.play("idle_front")


# Determines which state the player should transition into next
func _on_next_transitions() -> void:
	# Check if movement input is being pressed
	GameInputEvents.movement_input()
	
	# If movement is detected, switch to Walk state
	if GameInputEvents.is_movement_input(): 
			transition.emit("Walk")
	
	# If pressing hit (not while on UI), check tool usage
	elif not_on_ui:
		# Transition into different states depending on the tool equipped	
		if player.current_tool == DataTypes.Tools.AxeWood && GameInputEvents.use_tool():
			transition.emit("Chopping")
			
		if player.current_tool == DataTypes.Tools.TillGround && GameInputEvents.use_tool():
			transition.emit("Tilling")
			
		if player.current_tool == DataTypes.Tools.WaterCrops && GameInputEvents.use_tool():
			transition.emit("Watering")


# Called when entering this state
func _on_enter() -> void:
	pass


# Called when exiting this state
func _on_exit() -> void:
	animated_sprite_2d.stop()
