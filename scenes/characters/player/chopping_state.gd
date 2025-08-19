# ChopActionState.gd
# Handles the chopping action for the player, including animation and collision detection.
extends NodeState

# References to the player, its animated sprite, and the hit detection collision shape.
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape : CollisionShape2D

func _ready():
	# Disable the hit detection by default.
	hit_component_collision_shape.disabled = true 
	
	# Reset the collision shape position.
	hit_component_collision_shape.position = Vector2(0, 0);


# Per-frame processing (unused for now).
func _on_process(_delta : float) -> void:
	pass


# Per-physics-frame processing (unused for now).
func _on_physics_process(_delta : float) -> void:
	pass


# Handles transitions to other states.
func _on_next_transitions() -> void:
	# Once the chopping animation finishes, transition back to Idle.
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")


# Called when entering the chopping state.
func _on_enter() -> void:
	# Play the correct chopping animation based on player direction,
	# and position the hit collision shape appropriately.
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("chopping_back")
		hit_component_collision_shape.position = Vector2(0, -22)
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("chopping_left")
		hit_component_collision_shape.position = Vector2(15, -3)
	elif player.player_direction == Vector2.DOWN: 
		animated_sprite_2d.play("chopping_front")
		hit_component_collision_shape.position = Vector2(0, 7)
	elif player.player_direction == Vector2.LEFT: 
		animated_sprite_2d.play("chopping_left")
		hit_component_collision_shape.position = Vector2(-15, -3)
	else: 
		# Default case: facing front
		animated_sprite_2d.play("chopping_front")
		hit_component_collision_shape.position = Vector2(0, 7)
	
	# Enable hit detection for the duration of the chopping action.	
	hit_component_collision_shape.disabled = false
		


# Called when exiting the chopping state.
func _on_exit() -> void:
	# Stop the animation and disable hit detection.
	animated_sprite_2d.stop()
	hit_component_collision_shape.disabled = true
