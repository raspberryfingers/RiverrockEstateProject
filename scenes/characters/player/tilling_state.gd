# tilling_state.gd
# Handles the tilling action for the player, including animation and collision detection.
extends NodeState

# References to other important nodes
@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D
@export var hit_component_collision_shape : CollisionShape2D


func _ready():
	# Disable hitbox on start (prevents accidental hits before entering the state)
	hit_component_collision_shape.disabled = true 
	hit_component_collision_shape.position = Vector2(0, 0);


# Called every frame while in this state (non-physics logic) (unused for now)
func _on_process(_delta : float) -> void:
	pass


# Called every physics frame while in this state (movement/physics logic) (unused for now)
func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	# When animation finishes, transition back to Idle
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")


func _on_enter() -> void:
	# Play correct tilling animation depending on direction
	# and reposition the collision shape so it lines up with the tool
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("tilling_back")
		hit_component_collision_shape.position = Vector2(0, -22)
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("tilling_left") # reused left anim for right direction
		hit_component_collision_shape.position = Vector2(15, -3)
	elif player.player_direction == Vector2.DOWN: 
		animated_sprite_2d.play("tilling_front")
		hit_component_collision_shape.position = Vector2(0, 7)
	elif player.player_direction == Vector2.LEFT: 
		animated_sprite_2d.play("tilling_left")
		hit_component_collision_shape.position = Vector2(-15, -3)
	else: 
		# Default to front if no direction found
		animated_sprite_2d.play("tilling_front")
		hit_component_collision_shape.position = Vector2(0, 7)
	
	# Enable hitbox when action begins
	hit_component_collision_shape.disabled = false


func _on_exit() -> void:
	# Stop animation and disable hitbox when leaving the state
	animated_sprite_2d.stop()
	hit_component_collision_shape.disabled = true
