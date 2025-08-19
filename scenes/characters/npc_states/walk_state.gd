# walk_state.gd
# A state for NPCs to handle random movement, animation, and transition back to idle.
extends NodeState

# References to the character, its animated sprite, and navigation agent.
@export var character: NonPlayableCharacter
@export var animated_sprite_2d: AnimatedSprite2D
@export var navigation_agent_2d: NavigationAgent2D

# Minimum and maximum movement speed for randomization.
@export var min_speed: float = 5
@export var max_speed: float = 10

# Current speed of the NPC.
var speed: float


func _ready() -> void:
	# Connect the navigation agent's velocity signal to safely apply movement.
	navigation_agent_2d.velocity_computed.connect(on_safe_velocity_computed)
	
	# Deferred setup to ensure the character is fully initialized.
	call_deferred("character_setup")


# Setup function called after deferred initialization.
func character_setup() -> void:
	print("Setup starting for: ", character.name)
	
	# Wait two physics frames to ensure scene tree and navigation agent are ready.
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	# Assign the first random movement target.
	set_movement_target()


# Assigns a random position on the navigation map and randomizes speed.
func set_movement_target() -> void:
	var target_position: Vector2 = NavigationServer2D.map_get_random_point(
		navigation_agent_2d.get_navigation_map(),
		navigation_agent_2d.navigation_layers,
		false
	)
	navigation_agent_2d.target_position = target_position
	speed = randf_range(min_speed, max_speed)


# Process function per frame (currently unused).
func _on_process(_delta: float) -> void:
	pass


# Physics process for movement along the navigation path.
func _on_physics_process(_delta: float) -> void:
	# If the NPC reached its target, increment the walk cycle and choose a new target.
	if navigation_agent_2d.is_navigation_finished():
		character.current_walk_cycle += 1
		set_movement_target()
		return 
	
	# Compute direction to next path point.
	var target_position: Vector2 = navigation_agent_2d.get_next_path_position()
	var target_direction: Vector2 = character.global_position.direction_to(target_position)
	
	# Flip sprite horizontally based on movement direction.
	animated_sprite_2d.flip_h = target_position.x > 0
	
	var velocity: Vector2 = target_direction * speed
	
	if navigation_agent_2d.avoidance_enabled:
		# If avoidance is enabled, use NavigationAgent2D velocity system.
		animated_sprite_2d.flip_h = velocity.x > 0
		navigation_agent_2d.velocity = velocity  # Calls on_safe_velocity_computed
	else:
		# Direct movement if avoidance is disabled.
		character.velocity = velocity
		character.move_and_slide()


# Called by NavigationAgent2D when safe velocity is computed.
func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	animated_sprite_2d.flip_h = safe_velocity.x > 0
	character.velocity = safe_velocity
	character.move_and_slide()


# Handle transitions to other states.
func _on_next_transitions() -> void:
	if character.current_walk_cycle == character.walk_cycles:
		character.velocity = Vector2.ZERO
		transition.emit("Idle")


# Called when entering this state.
func _on_enter() -> void:
	animated_sprite_2d.play("walk")
	character.current_walk_cycle = 0


# Called when exiting this state.
func _on_exit() -> void:
	animated_sprite_2d.stop()
