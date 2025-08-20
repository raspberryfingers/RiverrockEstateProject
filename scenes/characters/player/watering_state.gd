# watering_state.gd
# Handles the watering action for the player, including animation and collision detection.
extends NodeState

# Reference to the Player node
@export var player: Player
# Reference to the AnimatedSprite2D used for watering animations
@export var animated_sprite_2d: AnimatedSprite2D
# Reference to the collision shape used to detect watering hits
@export var hit_component_collision_shape : CollisionShape2D


func _ready():
	# Disable the hitbox by default and reset its position
	hit_component_collision_shape.disabled = true 
	hit_component_collision_shape.position = Vector2(0, 0);


# No process logic is needed for this state
func _on_process(_delta : float) -> void:
	pass


# No physics logic is needed for this state
func _on_physics_process(_delta : float) -> void:
	pass


# When the watering animation finishes, return to Idle state
func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")


func _on_enter() -> void:
	# Choose animation and hitbox position based on player direction
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("watering_back")
		hit_component_collision_shape.position = Vector2(0, -22)
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("watering_left") # Note: uses 'left' animation for right direction
		hit_component_collision_shape.position = Vector2(15, -3)
	elif player.player_direction == Vector2.DOWN: 
		animated_sprite_2d.play("watering_front")
		hit_component_collision_shape.position = Vector2(0, 7)
	elif player.player_direction == Vector2.LEFT: 
		animated_sprite_2d.play("watering_left")
		hit_component_collision_shape.position = Vector2(-15, -3)
	else: 
		# Default to front watering if no direction is se
		animated_sprite_2d.play("watering_front")
		hit_component_collision_shape.position = Vector2(0, 7)
		
	# Enable hitbox during watering
	hit_component_collision_shape.disabled = false


# Stop animation and disable hitbox when leaving watering state
func _on_exit() -> void:
	animated_sprite_2d.stop()
	hit_component_collision_shape.disabled = true
