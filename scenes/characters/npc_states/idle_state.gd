# idle_state.gd
# A state for characters that handles idle animation and transitions to walking after a timeout.
extends NodeState

# References to the character and its animated sprite.
@export var character: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D

# Time in seconds before the idle state triggers a transition.
@export var idle_state_time_interval: float = 5.0

# Timer used to track idle duration.
@onready var idle_state_timer: Timer = Timer.new()

# Flag to indicate that the idle timeout has occurred.
var idle_state_timeout: bool = false


func _ready() -> void:
	# Configure the timer.
	idle_state_timer.wait_time = idle_state_time_interval
	idle_state_timer.one_shot = true
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	
	# Add the timer as a child node so it runs in the scene tree.
	add_child(idle_state_timer)


# Called every frame; currently not used for idle behavior.
func _on_process(_delta: float) -> void:
	pass


# Called every physics frame; currently not used for idle behavior.
func _on_physics_process(_delta: float) -> void:
	pass


# Check for transitions to other states.
func _on_next_transitions() -> void:
	if idle_state_timeout:
		# Emit a transition signal to switch to the "Walk" state.
		transition.emit("Walk")


# Called when entering this state.
func _on_enter() -> void:
	# Play the idle animation.
	animated_sprite_2d.play("idle")
	
	# Reset the timeout flag and start the timer.
	idle_state_timeout = false
	idle_state_timer.start()


# Called when exiting this state.
func _on_exit() -> void:
	# Stop the idle animation and timer.
	animated_sprite_2d.stop()
	idle_state_timer.stop() 


# Callback for when the idle timer completes.
func on_idle_state_timeout() -> void: 
	idle_state_timeout = true
